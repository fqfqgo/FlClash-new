import 'dart:io';
import 'dart:math';

Directory? _unixIpcDir;
String? _unixSocketPath;

Directory get unixIpcDir => _unixIpcDir ??= resolveUnixIpcDir(
  unixIpcDirCandidates(
    systemTempPath: Directory.systemTemp.path,
    home: Platform.environment['HOME'],
    isMacOS: Platform.isMacOS,
  ),
);

String get unixSocketPath => _unixSocketPath ??=
    '${unixIpcDir.path}${Platform.pathSeparator}FlClashSocket_${Random().nextInt(10000)}.sock';

List<String> unixIpcDirCandidates({
  required String systemTempPath,
  String? home,
  bool isMacOS = false,
}) {
  final cache = (home == null || home.isEmpty)
      ? null
      : '$home${isMacOS ? '/Library/Caches/FlClash' : '/.cache/FlClash'}';
  return {systemTempPath, '/tmp', ?cache}.toList();
}

Directory resolveUnixIpcDir(List<String> candidates) {
  for (final path in candidates) {
    if (path.isEmpty) continue;
    try {
      final dir = Directory(path);
      if (!dir.existsSync()) {
        dir.createSync(recursive: true);
      }
      if (dir.existsSync()) {
        return dir;
      }
    } catch (_) {}
  }
  throw StateError('No writable directory for Unix IPC socket');
}
