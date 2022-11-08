import 'package:http/http.dart';

import 'http_client.dart';
import 'types.dart';

class SingleRequest {
  SingleRequest({
    HttpHeadersBuilder? headersBuilder,
    Map<String, String?>? endpointMap,
    Client? client,
  })  : _headersBuilder = headersBuilder,
        _endpointMap = endpointMap,
        _client = client;

  final Map<String, String?>? _endpointMap;
  final HttpHeadersBuilder? _headersBuilder;
  final Client? _client;

  HttpErrorHandler? _onHttpError;
  set onHttpError(HttpErrorHandler? fn) => _onHttpError = fn;

  Future<T> get<T extends dynamic>(
    String url, {
    Map<String, dynamic>? params,
    Map<String, String>? headers,
  }) =>
      _withClient<T>((client) => client.get<T>(
            url,
            params: params,
            headers: headers,
          ));

  Future<T> post<T extends dynamic>(
    String url,
    Map<String, dynamic>? fields, {
    Map<String, dynamic>? params,
    Map<String, String>? headers,
    List<MultipartFile>? files,
    bool? useForm,
  }) =>
      _withClient<T>((client) => client.post<T>(
            url,
            fields,
            params: params,
            headers: headers,
            files: files,
            useForm: useForm,
          ));

  Future<T> put<T extends dynamic>(
    String url,
    Map<String, dynamic> fields, {
    Map<String, dynamic>? params,
    Map<String, String>? headers,
  }) =>
      _withClient<T>((client) => client.put<T>(
            url,
            fields,
            params: params,
            headers: headers,
          ));

  Future<T> delete<T extends dynamic>(
    String url, {
    Map<String, dynamic>? params,
    Map<String, String>? headers,
  }) =>
      _withClient<T>((client) => client.delete<T>(
            url,
            params: params,
            headers: headers,
          ));

  Future<T> _withClient<T>(Future<T> Function(HttpClient client) fn) async {
    final client = HttpClient(
      endpointMap: _endpointMap,
      headersBuilder: _headersBuilder,
      client: _client,
    );

    client.onHttpError = _onHttpError;

    try {
      return await fn(client);
    } finally {
      client.close();
    }
  }
}
