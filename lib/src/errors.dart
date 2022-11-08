import 'dart:convert';

/// Error thrown when the success response body is not the expected type.
class HttpUnexpectedResponseBodyType extends Error {
  HttpUnexpectedResponseBodyType(Type T, Object? body)
      : message = 'The response data does not match the expected type: $T, '
            'body:\n ${body is Map ? jsonEncode(body) : body.toString()}';

  final String message;

  @override
  String toString() {
    return message;
  }
}

/// Error thrown when the error response contains unexpected data.
class HttpUnexpectedErrorData extends Error {
  HttpUnexpectedErrorData(this.message);

  final String message;

  @override
  String toString() {
    return message;
  }
}
