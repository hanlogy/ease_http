import 'package:ease_http/ease_http.dart';
import 'package:test/test.dart';

void main() {
  test('A HttpException is an Exception(not an Error, etc)', () {
    // ignore: unnecessary_type_check
    expect(HttpException(status: 400, code: 'code') is Exception, true);
  });

  group('supports value comparisons', () {
    test('equal', () {
      expect(
        HttpException(status: 400, code: 'unknown'),
        HttpException(status: 400, code: 'unknown'),
      );
    });

    test('not equal', () {
      expect(
        HttpException(status: 400, code: 'code'),
        isNot(HttpException(status: 400, code: 'unknown')),
      );
    });
  });
  group('fromJson', () {
    test('fromJson', () {
      expect(
        HttpException.fromJson({
          'status': 400,
          'code': 'code',
          'message': 'message',
          'data': 'data',
        }),
        HttpException(
          status: 400,
          code: 'code',
          message: 'message',
          data: 'data',
        ),
      );
    });

    group('failure', () {
      test('status is null', () {
        expect(
          () => HttpException.fromJson({}),
          throwsA(predicate<HttpUnexpectedErrorData>(
            (e) => e.message == 'status cannot be null',
          )),
        );
      });

      test('status is not int', () {
        expect(
          () => HttpException.fromJson({'status': 'good'}),
          throwsA(predicate<HttpUnexpectedErrorData>(
            (e) => e.message == 'status must be int type',
          )),
        );
      });

      test('code is null', () {
        expect(
          () => HttpException.fromJson({'status': 400}),
          throwsA(predicate<HttpUnexpectedErrorData>(
            (e) => e.message == 'code cannot be null',
          )),
        );
      });

      test('code is not string', () {
        expect(
          () => HttpException.fromJson({'status': 400, 'code': 100}),
          throwsA(predicate<HttpUnexpectedErrorData>(
            (e) => e.message == 'code must be String type',
          )),
        );
      });

      test('code is empty', () {
        expect(
          () => HttpException.fromJson({'status': 400, 'code': ''}),
          throwsA(predicate<HttpUnexpectedErrorData>(
            (e) => e.message == 'code cannot be empty',
          )),
        );
      });

      test('message is not string', () {
        expect(
          () => HttpException.fromJson({
            'status': 400,
            'code': 'code',
            'message': true,
          }),
          throwsA(predicate<HttpUnexpectedErrorData>(
            (e) => e.message == 'message must be String if it is not null',
          )),
        );
      });
    });
  });

  test('fromString', () {
    expect(
      HttpException.fromString(500, 'data'),
      HttpException(
        status: 500,
        code: 'ease_http.error',
        data: 'data',
      ),
    );
  });
}
