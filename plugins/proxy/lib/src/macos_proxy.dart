import 'dart:io';

import 'proxy_command.dart';

class MacosProxy {
  final ProxyCommandRunner _commandRunner;

  MacosProxy({required ProxyCommandRunner commandRunner})
      : _commandRunner = commandRunner;

  Future<bool> start(int port, List<String> bypassDomain) async {
    final services = await _networkServices();
    if (!await _commandRunner.run(
      services.expand(
        (service) => MacosProxyCommands.buildStart(service, port, bypassDomain),
      ),
    )) {
      return false;
    }
    for (final service in services) {
      for (final type in const [
        '-getwebproxy',
        '-getsecurewebproxy',
        '-getsocksfirewallproxy',
      ]) {
        try {
          final result = await _commandRunner.process(
            '/usr/sbin/networksetup',
            [type, service],
          );
          if (result.exitCode != 0 ||
              !MacosProxyCommands.matchesProxyOutput(
                result.stdout.toString(),
                port,
              )) {
            return false;
          }
        } on ProcessException {
          return false;
        }
      }
    }
    return true;
  }

  Future<bool> stop() async {
    final services = await _networkServices();
    return _commandRunner.run(services.expand(MacosProxyCommands.buildStop));
  }

  Future<List<String>> _networkServices() async {
    try {
      final result = await _commandRunner.process('/usr/sbin/networksetup', [
        '-listallnetworkservices',
      ]);
      if (result.exitCode != 0) {
        return [];
      }
      return MacosProxyCommands.parseNetworkServices(result.stdout.toString());
    } on ProcessException {
      return [];
    }
  }
}

class MacosProxyCommands {
  static List<ProxyCommand> buildStart(
    String service,
    int port,
    List<String> bypassDomain,
  ) {
    return [
      ProxyCommand('/usr/sbin/networksetup', [
        '-setwebproxy',
        service,
        proxyHost,
        '$port',
      ]),
      ProxyCommand('/usr/sbin/networksetup', [
        '-setsecurewebproxy',
        service,
        proxyHost,
        '$port',
      ]),
      ProxyCommand('/usr/sbin/networksetup', [
        '-setsocksfirewallproxy',
        service,
        proxyHost,
        '$port',
      ]),
      buildProxyBypass(service, bypassDomain),
      ProxyCommand('/usr/sbin/networksetup', [
        '-setwebproxystate',
        service,
        'on',
      ]),
      ProxyCommand('/usr/sbin/networksetup', [
        '-setsecurewebproxystate',
        service,
        'on',
      ]),
      ProxyCommand('/usr/sbin/networksetup', [
        '-setsocksfirewallproxystate',
        service,
        'on',
      ]),
    ];
  }

  static List<ProxyCommand> buildStop(String service) {
    return [
      ProxyCommand('/usr/sbin/networksetup', [
        '-setautoproxystate',
        service,
        'off',
      ]),
      ProxyCommand('/usr/sbin/networksetup', [
        '-setwebproxystate',
        service,
        'off',
      ]),
      ProxyCommand('/usr/sbin/networksetup', [
        '-setsecurewebproxystate',
        service,
        'off',
      ]),
      ProxyCommand('/usr/sbin/networksetup', [
        '-setsocksfirewallproxystate',
        service,
        'off',
      ]),
      buildProxyBypass(service, const []),
    ];
  }

  static ProxyCommand buildProxyBypass(
    String service,
    List<String> bypassDomain,
  ) {
    return ProxyCommand('/usr/sbin/networksetup', [
      '-setproxybypassdomains',
      service,
      if (bypassDomain.isEmpty) 'Empty' else ...bypassDomain,
    ]);
  }

  static List<String> parseNetworkServices(String stdout) {
    return stdout
        .split('\n')
        .map((line) => line.trim())
        .where((line) => line.isNotEmpty)
        .where((line) => !line.startsWith('*'))
        .where((line) => !line.startsWith('An asterisk '))
        .toList();
  }

  static bool matchesProxyOutput(String output, int port) {
    final values = <String, String>{};
    for (final line in output.split('\n')) {
      final separator = line.indexOf(':');
      if (separator <= 0) continue;
      values[line.substring(0, separator).trim().toLowerCase()] =
          line.substring(separator + 1).trim();
    }
    return values['enabled']?.toLowerCase() == 'yes' &&
        values['server'] == proxyHost &&
        values['port'] == '$port';
  }
}
