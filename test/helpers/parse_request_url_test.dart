import 'package:ease_http/src/helpers/parse_colon_uri.dart';
import 'package:ease_http/src/helpers/parse_request_url.dart';
import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';

void main() {
  test('simple one', () {
    expect(parseRequestUrl('foo').toString(), 'foo');
  });

  group('with params', () {
    test('simple', () {
      expect(
        parseRequestUrl(
          'foo',
          params: {'a': '1'},
        ).toString(),
        'foo?a=1',
      );
    });

    test('list', () {
      expect(
        parseRequestUrl(
          'foo',
          params: {
            'a': ['1', '2']
          },
        ).toString(),
        'foo?a=1&a=2',
      );
    });

    test('exception', () {
      expect(
        () => parseRequestUrl('foo', params: {'a': 1}),
        throwsA(isA<TypeError>()),
      );
    });
  });

  group('endpointMap', () {
    const uri = 'app:bar';
    final colonUri = parseColonUri(uri);
    test('a valid map', () {
      expect(
        parseRequestUrl(
          uri,
          endpointMap: {'app': 'foo'},
          colonUri: colonUri,
        ).toString(),
        'foo/bar',
      );
    });

    test('an invalid map', () {
      const uri = 'app:bar';
      expect(
        parseRequestUrl(
          uri,
          endpointMap: {'web': 'foo'},
          colonUri: colonUri,
        ).toString(),
        'app:bar',
      );
    });
  });
}
