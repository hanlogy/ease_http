import 'package:ease_http/ease_http.dart';
import 'package:test/test.dart';

import 'mock_client.dart';

void main() {
  late HttpClient client;

  setUp(() {
    client = HttpClient(client: mockClient);
  });

  tearDown(() {
    client.close();
  });

  test('a simple request', () async {
    final result = await client.get<String>('string');
    expect(result, 'ok');
  });

  group('default headers', () {
    test('get', () async {
      final result = await client.get<Map<String, dynamic>>('headers');
      expect(result, <String, dynamic>{});
    });

    test('post', () async {
      final result = await client.post<Map<String, dynamic>>('headers', {});
      expect(result, {'content-type': 'application/json; charset=UTF-8'});
    });

    test('put', () async {
      final result = await client.put<Map<String, dynamic>>('headers', {});
      expect(result, {'content-type': 'application/json; charset=UTF-8'});
    });

    test('delete', () async {
      final result = await client.delete<Map<String, dynamic>>('headers');
      expect(result, <String, dynamic>{});
    });

    test('post with form', () async {
      final result = await client.post<Map<String, dynamic>>(
        'headers',
        null,
        useForm: true,
      );
      expect(
        (result['content-type'] as String).split(';')[0],
        'multipart/form-data',
      );
    });

    test('upload files', () async {
      final result = await client.post<Map<String, dynamic>>(
        'form',
        null,
        files: [MultipartFile.fromString('image', '0123456789')],
      );
      expect(result, {'foo': 'bar'});
    });
  });

  group('useForm', () {
    test('a form request', () async {
      expect(
        await client.post<Map<String, dynamic>>('form', null, useForm: true),
        {'foo': 'bar'},
      );
    });

    test('fields must be a string map when it is a form', () async {
      expect(
        () => client.post<Map<String, dynamic>>('form', {'a': null},
            useForm: true),
        throwsA(isA<TypeError>()),
      );
    });
  });

  group('error response', () {
    test('Default string error response', () {
      client.get('404').then(
        (_) {},
        onError: expectAsync1<void, HttpException>((error) {
          expect(error.status, 404);
          expect(error.code, 'ease_http.error');
          expect(error.data, 'Not found');
          expect(error.message, null);
          expect(error.isDefaultError, true);
        }),
      );
    });

    test('Custom string error response', () {
      client.get('string_error').then(
        (_) {},
        onError: expectAsync1<void, HttpException>((error) {
          expect(error.status, 400);
          expect(error.code, 'ease_http.error');
          expect(error.data, 'error');
          expect(error.message, null);
        }),
      );
    });

    test('map response', () {
      client.get('map_error').then(
        (_) {},
        onError: expectAsync1<void, HttpException>((error) {
          expect(error.status, 401);
          expect(error.code, 'error');
          expect(error.data, {'foo': 'bar'});
          expect(error.message, 'message');
        }),
      );
    });

    test('exception', () {
      client.get('exception').then(
        (_) {},
        onError: expectAsync1((error) {
          expect(error.runtimeType, HttpUnexpectedErrorData);
        }),
      );
    });
  });

  group('error handler', () {
    test('return null', () {
      client.onHttpError = (error) async {
        return null;
      };

      client.get('string_error').then(
        (_) {},
        onError: expectAsync1<void, HttpException>((error) {
          expect(error.code, 'ease_http.error');
        }),
      );
    });

    test('return null', () {
      client.onHttpError = (error) async => HttpException(
            code: 'updated_error',
            status: 403,
          );

      client.get('map_error').then(
        (_) {},
        onError: expectAsync1<void, HttpException>((error) {
          expect(error.status, 403);
          expect(error.code, 'updated_error');
        }),
      );
    });
  });
}
