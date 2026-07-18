import 'package:fl_clash/manager/proxy_manager.dart';
import 'package:fl_clash/models/models.dart';
import 'package:flutter_test/flutter_test.dart';

ProxyState proxyState({required bool isStart, required bool systemProxy}) {
  return ProxyState(
    isStart: isStart,
    systemProxy: systemProxy,
    bassDomain: const [],
    port: 7890,
  );
}

void main() {
  test('falls back only when system proxy fails during startup', () {
    final stopped = proxyState(isStart: false, systemProxy: true);
    final started = proxyState(isStart: true, systemProxy: true);

    expect(shouldFallbackToTun(stopped, started), isTrue);
    expect(shouldFallbackToTun(null, started), isTrue);
    expect(shouldFallbackToTun(started, started), isFalse);
  });

  test('does not fall back when system proxy is disabled', () {
    expect(
      shouldFallbackToTun(
        proxyState(isStart: false, systemProxy: false),
        proxyState(isStart: true, systemProxy: false),
      ),
      isFalse,
    );
  });
}
