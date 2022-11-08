import 'package:ease_http/src/helpers/parse_request_headers.dart';
import 'package:ease_http/src/types.dart';
import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';

void main() {
  final uri = Uri();
  group('default values', () {
    test('post method', () async {
      expect(
        await parseRequestHeaders(method: RequestMethod.post, uri: uri),
        {'content-type': 'application/json; charset=UTF-8'},
      );
    });

    test('put method', () async {
      expect(
        await parseRequestHeaders(method: RequestMethod.put, uri: uri),
        {'content-type': 'application/json; charset=UTF-8'},
      );
    });

    test('get method', () async {
      expect(
        await parseRequestHeaders(method: RequestMethod.get, uri: uri),
        <String, String>{},
      );
    });

    test('delete method', () async {
      expect(
        await parseRequestHeaders(method: RequestMethod.delete, uri: uri),
        <String, String>{},
      );
    });

    test('options method', () async {
      expect(
        await parseRequestHeaders(method: RequestMethod.options, uri: uri),
        <String, String>{},
      );
    });

    test('default headers when withForm is true', () async {
      expect(
        await parseRequestHeaders(
          method: RequestMethod.post,
          uri: uri,
          useForm: true,
        ),
        <String, String>{},
      );
    });
  });

  test('has custom headers', () async {
    final headers = await parseRequestHeaders(
      method: RequestMethod.post,
      uri: uri,
      headers: {'Content-Type': 'text/plain;', 'token': 'bar'},
    );

    expect(headers, {'content-type': 'text/plain;', 'token': 'bar'});
  });

  test('has headersBuilder', () async {
    final headers = await parseRequestHeaders(
      method: RequestMethod.post,
      uri: uri,
      headers: {'Content-Type': 'text/plain;', 'token': 'bar'},
      headersBuilder: (request) async {
        return {
          'Content-Type': 'application/json; charset=UTF-8',
          'env': 'ios',
        };
      },
    );

    expect(headers, {
      'content-type': 'application/json; charset=UTF-8',
      'token': 'bar',
      'env': 'ios',
    });
  });
}
