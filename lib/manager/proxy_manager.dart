import 'package:fl_clash/common/proxy.dart';
import 'package:fl_clash/common/print.dart';
import 'package:fl_clash/enum/enum.dart';
import 'package:fl_clash/models/models.dart';
import 'package:fl_clash/providers/action.dart';
import 'package:fl_clash/providers/state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

@visibleForTesting
bool shouldFallbackToTun(ProxyState? previous, ProxyState next) {
  return previous?.isStart != true && next.isStart && next.systemProxy;
}

class ProxyManager extends ConsumerStatefulWidget {
  final Widget child;

  const ProxyManager({super.key, required this.child});

  @override
  ConsumerState createState() => _ProxyManagerState();
}

class _ProxyManagerState extends ConsumerState<ProxyManager> {
  Future<void> _pendingUpdate = Future.value();

  Future<void> _updateProxy(
    ProxyState proxyState, {
    required bool fallbackToTunOnFailure,
  }) async {
    final isStart = proxyState.isStart;
    final systemProxy = proxyState.systemProxy;
    final port = proxyState.port;
    bool? result = false;
    try {
      if (isStart && systemProxy) {
        result = await proxy?.startProxy(port, proxyState.bassDomain);
      } else {
        result = await proxy?.stopProxy();
      }
    } catch (error) {
      commonPrint.log(
        'update system proxy failed: $error',
        logLevel: LogLevel.warning,
      );
    }
    if (result != true) {
      commonPrint.log('update system proxy failed', logLevel: LogLevel.warning);
      if (fallbackToTunOnFailure && mounted) {
        final current = ref.read(proxyStateProvider);
        if (current == proxyState) {
          await ref
              .read(setupActionProvider.notifier)
              .fallbackToTunFromSystemProxyFailure();
        }
      }
    }
  }

  void _scheduleUpdateProxy(
    ProxyState proxyState, {
    required bool fallbackToTunOnFailure,
  }) {
    _pendingUpdate = _pendingUpdate
        .then(
          (_) => _updateProxy(
            proxyState,
            fallbackToTunOnFailure: fallbackToTunOnFailure,
          ),
        )
        .catchError((Object error) {
          commonPrint.log(
            'update system proxy failed: $error',
            logLevel: LogLevel.warning,
          );
        });
  }

  @override
  void initState() {
    super.initState();
    ref.listenManual(proxyStateProvider, (prev, next) {
      if (prev != next) {
        _scheduleUpdateProxy(
          next,
          fallbackToTunOnFailure: shouldFallbackToTun(prev, next),
        );
      }
    }, fireImmediately: true);
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
