import 'package:ease_http/src/helpers/parse_colon_uri.dart';
import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';

void main() {
  test('with URI schemes', () {
    expect(parseColonUri('https://foo'), null);
    expect(parseColonUri('ftp://foo'), null);
    expect(parseColonUri('a://foo'), null);
  });

  test('has both name and path', () {
    expect(parseColonUri('foo:bar')!.toMap(), {
      'name': 'foo',
      'path': 'bar',
    });
  });

  test('multiple level path', () {
    expect(parseColonUri('foo:bar/baz')!.toMap(), {
      'name': 'foo',
      'path': 'bar/baz',
    });
  });

  test('has only name', () {
    expect(parseColonUri('foo')!.toMap(), {'name': 'foo', 'path': ''});
    expect(parseColonUri('foo:')!.toMap(), {'name': 'foo', 'path': ''});
    expect(parseColonUri(' foo : ')!.toMap(), {'name': 'foo', 'path': ''});
  });

  test('has more than one colons', () {
    expect(parseColonUri('foo:bar:baz')!.toMap(), {
      'name': 'foo',
      'path': 'bar:baz',
    });
  });
}
