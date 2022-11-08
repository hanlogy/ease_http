import 'exceptions.dart';

typedef HttpErrorHandler = Future<HttpException?> Function(
  HttpException error,
);

typedef HttpHeadersBuilder = Future<Map<String, String>?> Function(
  HttpRequest request,
);

class HttpRequest {
  const HttpRequest({
    required this.uri,
    this.headers = const {},
    this.endpointName,
    this.endpointPath,
  });

  final Uri uri;
  final Map<String, String> headers;
  final String? endpointName;
  final String? endpointPath;
}

enum RequestMethod { get, delete, post, put, options }

extension RequestMethodX on RequestMethod {
  bool get isPost => this == RequestMethod.post;
  bool get isPut => this == RequestMethod.put;
  bool get isDelete => this == RequestMethod.delete;
  bool get isOptions => this == RequestMethod.options;
  bool get isNotPost => this != RequestMethod.post;
  String get value => toString().split('.')[1].toUpperCase();
}
