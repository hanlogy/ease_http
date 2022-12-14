import 'package:ease_http/ease_http.dart';
import 'package:test/test.dart';

import 'mock_client.dart';

void main() {
  late SingleRequest request;

  setUp(() {
    request = SingleRequest(client: mockClient);
  });

  group('response data type', () {
    test('string', () async {
      expect(await request.get<String>('string'), 'ok');
      expect(await request.get<String?>('string'), 'ok');
    });

    test('int', () async {
      expect(await request.get<int>('int'), 1);
      expect(await request.get<int?>('int'), 1);
      expect(await request.get<int>('int_string'), 1);
      expect(await request.get<int?>('int_string'), 1);
    });

    test('double', () async {
      expect(await request.get<double>('double'), 1.2);
      expect(await request.get<double?>('double'), 1.2);
      expect(await request.get<double>('double_string'), 1.2);
      expect(await request.get<double?>('double_string'), 1.2);
    });

    test('bool', () async {
      expect(await request.get<bool>('bool'), true);
      expect(await request.get<bool?>('bool'), true);
      expect(await request.get<bool>('bool_string'), true);
      expect(await request.get<bool?>('bool_string'), true);
    });

    test('string map', () async {
      expect(
        await request.get<Map<String, String>>('string_map'),
        {'value': '1'},
      );

      expect(
        await request.get<Map<String, String>?>('string_map'),
        {'value': '1'},
      );

      expect(
        await request.get<Map<String, String>?>('null'),
        null,
      );
    });

    test('int map', () async {
      expect(
        await request.get<Map<String, int>>('int_map'),
        {'value': 1},
      );
      expect(
        await request.get<Map<String, int>?>('int_map'),
        {'value': 1},
      );
      expect(
        await request.get<Map<String, int>?>('null'),
        null,
      );
    });

    test('double map', () async {
      expect(
        await request.get<Map<String, double>>('double_map'),
        {'value': 1.0},
      );
      expect(
        await request.get<Map<String, double>?>('double_map'),
        {'value': 1.0},
      );
      expect(
        await request.get<Map<String, double>?>('null'),
        null,
      );
    });

    test('bool map', () async {
      expect(
        await request.get<Map<String, bool>>('bool_map'),
        {'value': true},
      );
      expect(
        await request.get<Map<String, bool>?>('bool_map'),
        {'value': true},
      );
      expect(
        await request.get<Map<String, bool>?>('null'),
        null,
      );
    });

    test('string map nullable', () async {
      expect(
        await request.get<Map<String, String?>>('string_map_nullable'),
        {'value': '1', 'name': null},
      );
    });

    test('int map  nullable', () async {
      expect(
        await request.get<Map<String, int?>>('int_map_nullable'),
        {'value': 1, 'name': null},
      );
    });

    test('double map  nullable', () async {
      expect(
        await request.get<Map<String, double?>>('double_map_nullable'),
        {'value': 1.0, 'name': null},
      );
    });

    test('bool map  nullable', () async {
      expect(
        await request.get<Map<String, bool?>>('bool_map_nullable'),
        {'value': true, 'name': null},
      );
    });

    test('no type specified', () async {
      expect(await request.get('null'), null);
      expect(await request.get('string'), 'ok');
      expect(await request.get('string_map'), {'value': '1'});
    });
  });

  group('http response exception', () {
    test('wrong non-null type', () async {
      expect(() async {
        await request.get<Map<String, String>>('int_map');
      }, throwsA(isA<HttpUnexpectedResponseBodyType>()));
    });

    test('expect Map, but returns null', () async {
      expect(() async {
        await request.get<Map<String, String>>('null');
      }, throwsA(isA<HttpUnexpectedResponseBodyType>()));
    });

    test('expect int, but returns null', () async {
      expect(() async {
        await request.get<int>('null');
      }, throwsA(isA<HttpUnexpectedResponseBodyType>()));
    });

    test('expect double, but returns null', () async {
      expect(() async {
        await request.get<double>('null');
      }, throwsA(isA<HttpUnexpectedResponseBodyType>()));
    });

    test('expect bool, but returns null', () async {
      expect(() async {
        await request.get<bool>('null');
      }, throwsA(isA<HttpUnexpectedResponseBodyType>()));
    });
  });
}
