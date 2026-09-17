import 'dart:async';

import 'common/common.dart';
import 'enum/enum.dart';
import 'models/models.dart';

import 'package:fl_clash/common/theme.dart';
import 'package:fl_clash/providers/app.dart';
import 'package:fl_clash/providers/config.dart';
import 'package:flutter/foundation.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';

class GlobalState {
  static GlobalState? _instance;
  final navigatorKey = GlobalKey<NavigatorState>();
  String appDisplayVersion = '0.0.0';
  late final String appEnv;
  late final PackageInfo packageInfo;
  Function? updateCurrentDelayDebounce;
  late Measure measure;
  late CommonTheme theme;
  late ProviderContainer container;
  bool needInitStatus = true;

  bool get isPre => appEnv != 'stable';

  bool get canCrashCore => canCrashCoreFor(isDebug: kDebugMode, appEnv: appEnv);

  @visibleForTesting
  static bool canCrashCoreFor({required bool isDebug, required String appEnv}) {
    return isDebug || appEnv == 'dev';
  }

  String? lastConfigMd5;
  VpnState? lastVpnState;
  bool isAttach = false;

  GlobalState._internal();

  factory GlobalState() {
    _instance ??= GlobalState._internal();
    return _instance!;
  }

  String get ua => container
      .read(patchClashConfigProvider.select((state) => state.globalUa))
      .takeFirstValid([packageInfo.ua]);

  BuildContext get _context => navigatorKey.currentContext!;

  Future<ProviderContainer> _initData(int version) async {
    packageInfo = await PackageInfo.fromPlatform();
    var config = await migration.run();
    _didCrashOnPreviousExecution = await system.didCrashOnPreviousExecution();
    if (_didCrashOnPreviousExecution) {
      config = config.copyWith(currentProfileId: null);
      await preferences.saveConfig(config);
    }
    final appState = AppState(
      brightness: WidgetsBinding.instance.platformDispatcher.platformBrightness,
      version: version,
      viewSize: Size.zero,
      requests: FixedList(maxLength),
      logs: FixedList(maxLength),
      traffics: FixedList(30),
      totalTraffic: const Traffic(),
      systemUiOverlayStyle: const SystemUiOverlayStyle(),
    );
    final appStateOverrides = buildAppStateOverrides(appState);
    const definedVersion = String.fromEnvironment('APP_VERSION');
    appDisplayVersion = definedVersion.isNotEmpty
        ? _displayVersion(definedVersion)
        : _displayPackageVersion(packageInfo.version, packageInfo.buildNumber);
    final configOverrides = buildConfigOverrides(config);
    container = ProviderContainer(
      overrides: [...appStateOverrides, ...configOverrides],
    );
    final profiles = await database.profilesDao.query().get();
    container.read(profilesProvider.notifier).setAndReorder(profiles);
    container
        .read(profilesActionProvider.notifier)
        .ensureCurrentProfileSelected();
    await AppLocalizations.load(
      getLocaleForString(config.appSettingProps.locale) ??
          WidgetsBinding.instance.platformDispatcher.locale,
    );
    await window?.init(version, config.windowProps);
    if (system.isAndroid) {
      await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    }
    return container;
  }

  Future<T?> loadingRun<T>(
    FutureOr<T> Function() futureFunction, {
    String? title,
    required LoadingTag? tag,
    bool silence = false,
  }) async {
    return globalState.safeRun(
      futureFunction,
      silence: silence,
      title: title,
      onStart: () {
        if (tag != null) {
          container.read(loadingProvider(tag).notifier).start();
        }
      },
      onEnd: () {
        if (tag != null) {
          container.read(loadingProvider(tag).notifier).stop();
        }
      },
    );
  }

  Future<T?> safeRun<T>(
    FutureOr<T> Function() futureFunction, {
    String? title,
    VoidCallback? onStart,
    VoidCallback? onEnd,
    bool silence = true,
  }) async {
    try {
      onStart?.call();
      return await futureFunction();
    } catch (e, s) {
      commonPrint.log(
        title == null
            ? '${compactError(e)}, $s'
            : '$title ===> ${compactError(e)}, $s',
        logLevel: LogLevel.warning,
      );
      final message = userFacingErrorMessage(e, currentAppLocalizations);
      if (silence) {
        dialogs.showNotifier(message, level: MessageLevel.error);
      } else {
        unawaited(
          dialogs.showMessage(
            title: title ?? currentAppLocalizations.tip,
            message: TextSpan(text: message),
          ),
        );
      }
      return null;
    } finally {
      onEnd?.call();
    }
  }
}

String _displayPackageVersion(String version, String buildNumber) {
  final build = int.tryParse(buildNumber);
  if (build == null || build <= 0 || version.contains('+')) {
    return _displayVersion(version);
  }
  return '$version.$build';
}

String _displayVersion(String version) {
  final normalized = version.startsWith('v') ? version.substring(1) : version;
  final parts = normalized.split('+');
  if (parts.length < 2 || parts[1] == '0') return parts.first;
  return '${parts.first}.${parts[1]}';
}

final globalState = GlobalState();
