## About

Based on Dart [http](https://pub.dev/packages/http) package, makes http package
more powerful and easier to use.

## Features

### Typed response

Use `HttpClient`:

```dart
import 'package:ease_http/ease_http.dart';

void main() async {
  final client = HttpClient();

  // response is typed.
  final response = await client.get<Map<String, dynamic>>('http://example.com');
  client.close();
}
```

Use `SingleRequest`:

```dart
import 'package:ease_http/ease_http.dart';

void main() async {
  final request = SingleRequest();

  // response is typed.
  final response = await request.get<Map<String, dynamic>>('http://example.com');
}
```

### Endpoint mapping

```dart
void main() async {
  final request = SingleRequest(endpointMap: {
    'api_1': 'http://example1.com',
    'api_2': 'http://example2.com',
  });

  final response = await request.get<String>('api_1:foo');
}
```

### Build headers on the fly

```dart
void main() async {
  final request = SingleRequest(
    endpointMap: {
      'api_1': 'http://example1.com',
      'api_2': 'http://example2.com',
    },
    headersBuilder: (request) async {
      if (request.endpointName == 'api_1') {
        return {
          'Authorization': 'accessToken',
          ...request.headers,
        };
      } else {
        return request.headers;
      }
    },
  );

  final result = await request.get<String>('api_1:foo');
}
```
