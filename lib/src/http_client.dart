import 'dart:convert';
import 'package:http/http.dart';
import 'package:http/retry.dart';

import './exceptions.dart';
import './types.dart';
import 'errors.dart';
import 'helpers/parse_colon_uri.dart';
import 'helpers/parse_request_headers.dart';
import 'helpers/parse_request_url.dart';

class HttpClient {
  HttpClient({
    HttpHeadersBuilder? headersBuilder,
    Map<String, String?>? endpointMap,
    Client? client,
  })  : _headersBuilder = headersBuilder,
        _endpointMap = endpointMap,
        _client = client ?? Client();

  final Client _client;
  final Map<String, String?>? _endpointMap;
  final HttpHeadersBuilder? _headersBuilder;

  HttpErrorHandler? _onHttpError;
  set onHttpError(HttpErrorHandler? fn) => _onHttpError = fn;

  Future<T> _send<T extends dynamic>(
    RequestMethod method,
    String url, {
    Map<String, dynamic>? fields,
    Map<String, dynamic>? params,
    Map<String, String>? headers,
    List<MultipartFile>? files,
    bool? useForm,
  }) async {
    files = (files == null || files.isEmpty) ? null : files;
    fields = (fields == null || fields.isEmpty) ? null : fields;
    useForm = (useForm ?? false) || files != null;

    if (method.isNotPost && useForm) {
      throw ArgumentError('Only POST method is allowed when sending form data');
    }

    final colonUri = parseColonUri(url);
    final uri = parseRequestUrl(
      url,
      endpointMap: _endpointMap,
      params: params,
      colonUri: colonUri,
    );
    headers = await parseRequestHeaders(
      method: method,
      headers: headers,
      colonUri: colonUri,
      useForm: useForm,
      uri: uri,
      headersBuilder: _headersBuilder,
    );

    final streamedResponse = !useForm
        ? await _sendJson(method, uri, headers, fields)
        : await _sendForm(uri, headers, fields, files);

    return _httpResponseHandler<T>(await Response.fromStream(streamedResponse));
  }

  Future<T> get<T extends dynamic>(
    String url, {
    Map<String, dynamic>? params,
    Map<String, String>? headers,
  }) =>
      _send<T>(RequestMethod.get, url, params: params, headers: headers);

  Future<T> post<T extends dynamic>(
    String url,
    Map<String, dynamic>? fields, {
    Map<String, dynamic>? params,
    Map<String, String>? headers,
    List<MultipartFile>? files,
    bool? useForm,
  }) =>
      _send<T>(
        RequestMethod.post,
        url,
        params: params,
        headers: headers,
        fields: fields,
        files: files,
        useForm: useForm,
      );

  // NOTE: This method doesn't support useForm, beause for example:
  // Laravel PUT doesn't support form-data with file
  Future<T> put<T extends dynamic>(
    String url,
    Map<String, dynamic> fields, {
    Map<String, dynamic>? params,
    Map<String, String>? headers,
  }) =>
      _send<T>(
        RequestMethod.put,
        url,
        params: params,
        headers: headers,
        fields: fields,
      );

  Future<T> delete<T extends dynamic>(
    String url, {
    Map<String, dynamic>? params,
    Map<String, String>? headers,
  }) =>
      _send<T>(
        RequestMethod.delete,
        url,
        params: params,
        headers: headers,
      );

  Future<StreamedResponse> _sendForm(
    Uri uri,
    Map<String, String> headers,
    Map<String, dynamic>? fields,
    List<MultipartFile>? files,
  ) {
    final request = MultipartRequest('POST', uri);
    request.headers.addAll(headers);
    if (fields != null) {
      fields.forEach((key, value) {
        request.fields[key] = value as String;
      });
    }

    if (files != null) {
      files.forEach(request.files.add);
    }
    return RetryClient(_client).send(request);
  }

  Future<StreamedResponse> _sendJson(
    RequestMethod method,
    Uri uri,
    Map<String, String> headers,
    Map<String, dynamic>? fields,
  ) {
    final request = Request(method.value, uri);
    request.headers.addAll(headers);
    if (fields != null) {
      request.body = jsonEncode(fields);
    }

    return RetryClient(_client).send(request);
  }

  void close() {
    _client.close();
  }

  Future<T> _httpResponseHandler<T>(Response response) async {
    final status = response.statusCode;
    final contentType = response.headers['content-type'];
    var isJsonBody =
        contentType != null && contentType.contains('application/json');

    dynamic body = response.body;
    if (isJsonBody) {
      try {
        body = json.decode(body as String);
      } catch (_) {
        body = null;
      }
    }

    if (body is int || body is double || body is bool || body == null) {
      isJsonBody = false;
    }

    if (status == 200 || status == 201) {
      final expectedType = T.toString();

      // NOTE:
      // `null` `body` only happens when `contentType` is `application/json`.
      if (body != null) {
        try {
          switch (expectedType) {
            case 'Map<String, String>':
            case 'Map<String, String>?':
              body = Map<String, String>.from(body as Map);
              break;

            case 'Map<String, String?>':
            case 'Map<String, String?>?':
              body = Map<String, String?>.from(body as Map);
              break;
            case 'Map<String, int>':
            case 'Map<String, int>?':
              body = Map<String, int>.from(body as Map);
              break;
            case 'Map<String, int?>':
            case 'Map<String, int?>?':
              body = Map<String, int?>.from(body as Map);
              break;
            case 'Map<String, double>':
            case 'Map<String, double>?':
              body = Map<String, double>.from(body as Map);
              break;
            case 'Map<String, double?>':
            case 'Map<String, double?>?':
              body = Map<String, double?>.from(body as Map);
              break;
            case 'Map<String, bool>':
            case 'Map<String, bool>?':
              body = Map<String, bool>.from(body as Map);
              break;
            case 'Map<String, bool?>':
            case 'Map<String, bool?>?':
              body = Map<String, bool?>.from(body as Map);
              break;
            case 'int':
            case 'int?':
              body = body is int ? body : int.parse(body as String);
              break;
            case 'double':
            case 'double?':
              body = body is double ? body : double.parse(body as String);
              break;
            case 'bool':
            case 'bool?':
              if (body is String) {
                body = body.toLowerCase();
                if (body == 'true') {
                  body = true;
                } else if (body == 'false') {
                  body = false;
                }
              }
              if (body is! bool) {
                throw HttpUnexpectedResponseBodyType(T, body);
              }
              break;
          }
        } catch (e) {
          if (e is HttpUnexpectedResponseBodyType) {
            rethrow;
          } else {
            throw HttpUnexpectedResponseBodyType(T, body);
          }
        }
      } else if (expectedType != 'dynamic' && !expectedType.endsWith('?')) {
        throw HttpUnexpectedResponseBodyType(T, body);
      }

      return body as T;
    } else {
      HttpException httpError;
      final errorData = <String, dynamic>{
        'status': status,
      };

      if (isJsonBody) {
        body as Map<String, dynamic>;
        httpError = HttpException.fromJson({
          ...errorData,
          'code': body['code'],
          'message': body['message'],
          'data': body['data'],
        });
      } else {
        httpError = HttpException.fromString(
          status,
          body.toString(),
        );
      }

      if (_onHttpError != null) {
        final newError = await _onHttpError!(httpError);
        if (newError != null) {
          throw newError;
        }
      }

      throw httpError;
    }
  }
}
