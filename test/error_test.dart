import 'package:ease_http/src/errors.dart';
import 'package:test/test.dart';

void main() {
  group('HttpUnexpectedResponseBodyType', () {
    test('is an Error(not an Exception, etc)', () {
      // ignore: unnecessary_type_check
      expect(HttpUnexpectedResponseBodyType(int, 'foo') is Error, true);
    });

    group('supports value comparisons', () {
      test('equal', () {
        expect(
          HttpUnexpectedResponseBodyType(bool, 'foo'),
          HttpUnexpectedResponseBodyType(bool, 'foo'),
        );
      });

      test('unequal', () {
        expect(
          HttpUnexpectedResponseBodyType(bool, 'foo'),
          isNot(HttpUnexpectedResponseBodyType(String, 'foo')),
        );
      });
    });
  });

  group('HttpUnexpectedErrorData', () {
    test('is an Error(not an Exception, etc)', () {
      // ignore: unnecessary_type_check
      expect(HttpUnexpectedErrorData('foo') is Error, true);
    });

    group('supports value comparisons', () {
      test('equal', () {
        expect(
          HttpUnexpectedErrorData('foo'),
          HttpUnexpectedErrorData('foo'),
        );
      });

      test('unequal', () {
        expect(
          HttpUnexpectedErrorData('foo'),
          isNot(HttpUnexpectedErrorData('bar')),
        );
      });
    });
  });
}
