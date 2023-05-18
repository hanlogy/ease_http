import 'dart:convert';
import 'package:http/http.dart';
import 'package:http/testing.dart';

enum ContentType { json, text }

final mockClient = MockClient((Request request) async {
  dynamic body;
  var contentType = ContentType.json;
  var status = 200;

  switch (request.url.toString()) {
    // returns the request headers.
    case 'headers':
      body = request.headers;
      break;
    case 'string':
    case 'api/foo':
      contentType = ContentType.text;
      if (request.headers.containsKey('token')) {
        body = request.headers['token'];
      } else {
        body = 'ok';
      }
      break;
    case 'int':
      body = 1;
      break;
    case 'int_string':
      contentType = ContentType.text;
      body = '1';
      break;
    case 'double':
      body = 1.2;
      break;
    case 'double_string':
      contentType = ContentType.text;
      body = '1.2';
      break;
    case 'bool':
      body = true;
      break;
    case 'bool_string':
      contentType = ContentType.text;
      body = 'TRUE';
      break;
    case 'string_map':
      body = {'value': '1'};
      break;
    case 'int_map':
      body = {'value': 1};
      break;
    case 'double_map':
      body = {'value': 1.0};
      break;
    case 'bool_map':
      body = {'value': true};
      break;

    // ----
    // The map contains null element
    case 'string_map_nullable':
      body = {'value': '1', 'name': null};
      break;
    case 'int_map_nullable':
      body = {'value': 1, 'name': null};
      break;
    case 'double_map_nullable':
      body = {'value': 1.0, 'name': null};
      break;
    case 'bool_map_nullable':
      body = {'value': true, 'name': null};
      break;

    case 'null':
      body = null;
      break;

    case 'form':
      if (request.headers['content-type']?.contains('form-data') ?? false) {
        body = {'foo': 'bar'};
      }
      break;
    case 'string_error':
      body = 'error';
      contentType = ContentType.text;
      status = 400;
      break;
    case 'map_error':
      body = {
        'code': 'error',
        'data': {'foo': 'bar'},
        'message': 'message',
      };
      status = 401;
      break;
    case 'exception':
      body = {
        'code': 200,
      };
      status = 401;
      break;
    default:
      return Response('Not found', 404);
  }

  return Response(
    contentType == ContentType.json ? jsonEncode(body) : body as String,
    status,
    headers: {
      'content-type': {
        ContentType.json: 'application/json',
        ContentType.text: 'text/plain',
      }[contentType]!,
    },
  );
});
