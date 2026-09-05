import 'dart:io';

import 'package:fl_clash/common/common.dart';
import 'package:fl_clash/providers/providers.dart';
import 'package:fl_clash/state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

const _threeDigitHourThreshold = 100 * 60 * 60 * 1000;
const _widthAnimationDuration = Duration(milliseconds: 200);
const _buttonHeight = 56.0;

TextStyle? _runTimeTextStyle(BuildContext context) {
  return context.textTheme.titleMedium?.toSoftBold.copyWith(
    color: context.colorScheme.onPrimaryContainer,
  );
}

TextStyle? _hundredsTextStyle(BuildContext context) {
  return context.textTheme.titleMedium?.toSoftBold.copyWith(
    color: context.colorScheme.primary,
    fontWeight: FontWeight.w600,
  );
}

double _computeRunTimeTextWidth(
  BuildContext context, {
  required bool hasThreeDigitHours,
}) {
  final regularWidth = globalState.measure
      .computeTextSize(Text('99:99:99', style: _runTimeTextStyle(context)))
      .width;
  if (!hasThreeDigitHours) {
    return regularWidth + 16;
  }
  final hundredsWidth = globalState.measure
      .computeTextSize(Text('9', style: _hundredsTextStyle(context)))
      .width;
  return hundredsWidth + regularWidth + 16;
}

class RunTimeText extends StatelessWidget {
  final int? timeStamp;

  const RunTimeText({super.key, required this.timeStamp});

  @override
  Widget build(BuildContext context) {
    final text = utils.getTimeText(timeStamp);
    final style = _runTimeTextStyle(context);
    final textWidget = text.length < 9
        ? Text(text, maxLines: 1, overflow: TextOverflow.visible, style: style)
        : Text.rich(
            TextSpan(
              text: text.substring(0, 1),
              style: _hundredsTextStyle(context),
              children: [TextSpan(text: text.substring(1), style: style)],
            ),
            maxLines: 1,
            overflow: TextOverflow.visible,
            style: style,
          );
    return textWidget;
  }
}

class StartButton extends ConsumerStatefulWidget {
  const StartButton({super.key});

  @override
  ConsumerState<StartButton> createState() => _StartButtonState();
}

class _StartButtonState extends ConsumerState<StartButton>
    with SingleTickerProviderStateMixin {
  AnimationController? _controller;
  late Animation<double> _animation;
  double? _twoDigitTextWidth;
  double? _threeDigitTextWidth;
  double? _suspendedTextWidth;
  int? _displayRunTime;

  @override
  void initState() {
    super.initState();
    final isStart = ref.read(isStartProvider);
    _displayRunTime = ref.read(runTimeProvider);
    _controller = AnimationController(
      vsync: this,
      value: isStart ? 1 : 0,
      duration: const Duration(milliseconds: 200),
    );
    _animation = CurvedAnimation(
      parent: _controller!,
      curve: Curves.easeOutBack,
    );
    ref.listenManual(runTimeProvider, (_, next) {
      _updateDisplayRunTime(next);
    });
    ref.listenManual(isStartProvider, (prev, next) {
      updateController(next);
    }, fireImmediately: true);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _twoDigitTextWidth = null;
    _threeDigitTextWidth = null;
    _suspendedTextWidth = null;
  }

  @override
  void dispose() {
    _controller?.dispose();
    _controller = null;
    super.dispose();
  }

  void handleSwitchStart() {
    ref.read(commonActionProvider.notifier).toggleRunning();
  }

  void _updateDisplayRunTime(int? runTime) {
    if (!mounted ||
        _displayRunTime == runTime ||
        (runTime == null && !(_controller?.isDismissed ?? true))) {
      return;
    }
    setState(() {
      _displayRunTime = runTime;
    });
  }

  void updateController(bool isStart) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }
      final controller = _controller;
      if (controller == null) {
        return;
      }
      if (isStart) {
        controller.forward();
        return;
      }
      controller.reverse().whenCompleteOrCancel(() {
        if (mounted && controller.isDismissed) {
          _updateDisplayRunTime(ref.read(runTimeProvider));
        }
      });
    });
  }

  double _getRunTimeTextWidth(
    BuildContext context, {
    required bool hasThreeDigitHours,
  }) {
    if (hasThreeDigitHours) {
      return _threeDigitTextWidth ??= _computeRunTimeTextWidth(
        context,
        hasThreeDigitHours: true,
      );
    }
    return _twoDigitTextWidth ??= _computeRunTimeTextWidth(
      context,
      hasThreeDigitHours: false,
    );
  }

  double _getSuspendedTextWidth(BuildContext context, String suspendedText) {
    return _suspendedTextWidth ??=
        globalState.measure
            .computeTextSize(
              Text(suspendedText, style: context.textTheme.titleMedium),
            )
            .width +
        24;
  }

  @override
  Widget build(BuildContext context) {
    final hasProfile = ref.watch(
      profilesProvider.select((state) => state.isNotEmpty),
    );
    if (!hasProfile) {
      return Container();
    }
    final suspend = ref.watch(suspendProvider);
    final hasThreeDigitHours =
        (_displayRunTime ?? 0) >= _threeDigitHourThreshold;
    final theme = Theme.of(context);
    final appLocalizations = context.appLocalizations;
    final textWidth = suspend
        ? _getSuspendedTextWidth(context, appLocalizations.suspended)
        : _getRunTimeTextWidth(context, hasThreeDigitHours: hasThreeDigitHours);
    return RepaintBoundary(
      child: Theme(
        data: theme.copyWith(
          floatingActionButtonTheme: theme.floatingActionButtonTheme.copyWith(
            sizeConstraints: const BoxConstraints(
              minWidth: 56,
              maxWidth: 220,
              minHeight: _buttonHeight,
              maxHeight: _buttonHeight,
            ),
          ),
        ),
        child: FloatingActionButton(
          clipBehavior: Clip.antiAlias,
          materialTapTargetSize: MaterialTapTargetSize.padded,
          heroTag: null,
          onPressed: () {
            handleSwitchStart();
          },
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedBuilder(
                animation: _animation,
                builder: (_, child) {
                  return Container(
                    height: _buttonHeight,
                    padding: EdgeInsets.only(
                      left: 16,
                      right: 16 - 8 * _animation.value,
                    ),
                    alignment: Alignment.centerLeft,
                    child: child,
                  );
                },
                child: AnimatedIcon(
                  icon: AnimatedIcons.play_pause,
                  progress: _animation,
                ),
              ),
              SizeTransition(
                axis: Axis.horizontal,
                alignment: Alignment.centerLeft,
                sizeFactor: _animation,
                child: AnimatedContainer(
                  width: textWidth,
                  duration: _widthAnimationDuration,
                  curve: Curves.easeOut,
                  child: suspend
                      ? Text(
                          appLocalizations.suspended,
                          maxLines: 1,
                          overflow: TextOverflow.visible,
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(
                                color: context.colorScheme.onPrimaryContainer,
                              ),
                        )
                      : RunTimeText(timeStamp: _displayRunTime),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class LaunchBrowserButton extends ConsumerWidget {
  const LaunchBrowserButton({super.key});

  Future<String> _resolveVisibleBaseDir() async {
    final env = Platform.environment;
    final home = env['USERPROFILE'] ?? env['HOME'] ?? Directory.current.path;
    final candidates = <String>[
      if (system.isWindows && (env['OneDriveConsumer']?.isNotEmpty ?? false))
        '${env['OneDriveConsumer']}${Platform.pathSeparator}Desktop',
      if (system.isWindows && (env['OneDriveCommercial']?.isNotEmpty ?? false))
        '${env['OneDriveCommercial']}${Platform.pathSeparator}Desktop',
      if (system.isWindows && (env['OneDrive']?.isNotEmpty ?? false))
        '${env['OneDrive']}${Platform.pathSeparator}Desktop',
      '$home${Platform.pathSeparator}Desktop',
      home,
    ];
    for (final path in candidates) {
      try {
        final dir = Directory(path);
        if (!dir.existsSync()) {
          continue;
        }
        final probe = Directory(
          '$path${Platform.pathSeparator}.flclash_write_probe',
        );
        if (!probe.existsSync()) {
          await probe.create(recursive: true);
        }
        if (probe.existsSync()) {
          await probe.delete(recursive: true);
          return path;
        }
      } catch (_) {}
    }
    return home;
  }

  Future<String> _ensureBrowserUserDataDir() async {
    final basePath = await _resolveVisibleBaseDir();
    final folderName = system.isWindows ? 'flclash-edge' : 'flclash-chrome';
    final dir = Directory('$basePath${Platform.pathSeparator}$folderName');
    if (!dir.existsSync()) {
      await dir.create(recursive: true);
    }
    final markerFile = File(
      '${dir.path}${Platform.pathSeparator}flclash-profile.txt',
    );
    if (!markerFile.existsSync()) {
      await markerFile.writeAsString(
        'This folder is used by FlClash browser launch profile.\n',
      );
    }
    return dir.path;
  }

  Future<void> _ensureStarted(WidgetRef ref) async {
    if (ref.read(isStartProvider)) {
      return;
    }
    await ref
        .read(setupActionProvider.notifier)
        .setRunning(true, initialize: !ref.read(initProvider));
    if (!ref.read(isStartProvider)) {
      throw 'FlClash failed to start, please check profile and core status.';
    }
  }

  Future<void> _launchWithProxy(int port, String userDataDir) async {
    final proxyArg = '--proxy-server=http://127.0.0.1:$port';
    final userDataArg = '--user-data-dir=$userDataDir';
    const homeUrl = 'https://www.google.com';
    if (system.isWindows) {
      final env = Platform.environment;
      final localAppData = env['LOCALAPPDATA'] ?? '';
      final candidates = <String>[
        r'C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe',
        r'C:\Program Files\Microsoft\Edge\Application\msedge.exe',
        if (localAppData.isNotEmpty)
          '$localAppData${Platform.pathSeparator}Microsoft${Platform.pathSeparator}Edge${Platform.pathSeparator}Application${Platform.pathSeparator}msedge.exe',
      ];
      for (final command in candidates) {
        try {
          await Process.start(command, [
            '--new-window',
            userDataArg,
            proxyArg,
            homeUrl,
          ]);
          return;
        } catch (_) {}
      }
      await Process.start('cmd', [
        '/c',
        'start',
        '',
        'msedge',
        '--new-window',
        userDataArg,
        proxyArg,
        homeUrl,
      ]);
      return;
    }
    if (system.isMacOS) {
      await Process.start('open', [
        '-n',
        '-a',
        'Google Chrome',
        '--args',
        '--new-window',
        userDataArg,
        proxyArg,
        homeUrl,
      ]);
      return;
    }
    if (system.isLinux) {
      final commands = [
        'google-chrome',
        'google-chrome-stable',
        'chromium-browser',
        'chromium',
      ];
      for (final command in commands) {
        try {
          await Process.start(command, [
            '--new-window',
            userDataArg,
            proxyArg,
            homeUrl,
          ]);
          return;
        } catch (_) {}
      }
      throw 'Chrome is not found on this Linux system.';
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (system.isAndroid) {
      return const SizedBox.shrink();
    }
    final appLocalizations = context.appLocalizations;
    final hasProfile = ref.watch(
      profilesProvider.select((state) => state.isNotEmpty),
    );
    if (!hasProfile) {
      return const SizedBox.shrink();
    }
    final isStart = ref.watch(isStartProvider);
    final port = ref.watch(proxyStateProvider.select((state) => state.port));
    return Theme(
      data: Theme.of(context).copyWith(
        floatingActionButtonTheme: Theme.of(context).floatingActionButtonTheme
            .copyWith(
              sizeConstraints: const BoxConstraints.tightFor(
                width: 56,
                height: 56,
              ),
            ),
      ),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: FloatingActionButton(
          clipBehavior: Clip.antiAlias,
          materialTapTargetSize: MaterialTapTargetSize.padded,
          mouseCursor: SystemMouseCursors.click,
          heroTag: 'launch-browser',
          tooltip: appLocalizations.launchBrowser,
          onPressed: () async {
            try {
              if (!isStart) {
                await _ensureStarted(ref);
              }
              final userDataDir = await _ensureBrowserUserDataDir();
              await _launchWithProxy(port, userDataDir);
            } catch (e) {
              globalState.showNotifier(
                '${appLocalizations.launchBrowserFailed}: $e',
              );
            }
          },
          child: const SizedBox(
            width: 56,
            height: 56,
            child: Center(child: Icon(Icons.language)),
          ),
        ),
      ),
    );
  }
}
