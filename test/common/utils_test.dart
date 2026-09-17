import 'package:fl_clash/common/package.dart';
import 'package:test/test.dart';

void main() {
  group('compareVersions', () {
    test('equal versions', () {
      expect(compareVersions('1.0.0', '1.0.0'), 0);
    });

    test('major version difference', () {
      expect(compareVersions('2.0.0', '1.0.0'), greaterThan(0));
      expect(compareVersions('1.0.0', '2.0.0'), lessThan(0));
    });

    test('minor version difference', () {
      expect(compareVersions('1.2.0', '1.1.0'), greaterThan(0));
    });

    test('patch version difference', () {
      expect(compareVersions('1.0.2', '1.0.1'), greaterThan(0));
    });

    test('handles build number', () {
      expect(compareVersions('1.0.0+1', '1.0.0+2'), lessThan(0));
      expect(compareVersions('1.0.0+2', '1.0.0+1'), greaterThan(0));
    });

    test('handles missing minor/patch', () {
      expect(compareVersions('1', '1.0.0'), 0);
    });

    test('normalizes fork release tags to Flutter build versions', () {
      expect(normalizeReleaseVersion('v0.8.94'), '0.8.94+0');
      expect(normalizeReleaseVersion('v0.8.94.1'), '0.8.94+1');
    });

    test('compares a fork patch release with the installed build', () {
      final installed = packageVersion('0.8.94', '0');
      final available = normalizeReleaseVersion('v0.8.94.1');

      expect(compareVersions(available, installed), greaterThan(0));
    });
  });
}
