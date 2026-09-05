import 'dart:io';

import 'package:fl_clash/common/unix_ipc.dart';
import 'package:test/test.dart';

void main() {
  group('unixIpcDirCandidates', () {
    test('prefers system temp then /tmp then macOS cache', () {
      expect(
        unixIpcDirCandidates(
          systemTempPath: '/var/folders/x/T',
          home: '/Users/a',
          isMacOS: true,
        ),
        ['/var/folders/x/T', '/tmp', '/Users/a/Library/Caches/FlClash'],
      );
    });

    test('uses linux cache path off macOS', () {
      expect(unixIpcDirCandidates(systemTempPath: '/tmp', home: '/home/a'), [
        '/tmp',
        '/home/a/.cache/FlClash',
      ]);
    });
  });

  group('resolveUnixIpcDir', () {
    late Directory root;

    setUp(() {
      root = Directory.systemTemp.createTempSync('flclash_ipc_');
    });

    tearDown(() {
      if (root.existsSync()) {
        root.deleteSync(recursive: true);
      }
    });

    test('uses the first existing candidate', () {
      expect(resolveUnixIpcDir([root.path]).path, root.path);
    });

    test('creates a missing candidate directory', () {
      final target = '${root.path}${Platform.pathSeparator}nested';
      expect(resolveUnixIpcDir([target]).path, target);
      expect(Directory(target).existsSync(), isTrue);
    });

    test('skips an unusable candidate and uses the next', () {
      final blocker = File('${root.path}${Platform.pathSeparator}not_a_dir')
        ..writeAsStringSync('x');
      final nested = '${blocker.path}${Platform.pathSeparator}child';
      final ok = '${root.path}${Platform.pathSeparator}ok';
      expect(resolveUnixIpcDir([nested, ok]).path, ok);
    });

    test('throws when no candidate is usable', () {
      expect(() => resolveUnixIpcDir(const []), throwsStateError);
    });
  });
}
