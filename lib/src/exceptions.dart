const _defaultErrorCode = 'ease_http.error';

class HttpException implements Exception {
  HttpException({
    required this.status,
    required this.code,
    this.message,
    this.data,
  });

  bool get isDefaultError => code == _defaultErrorCode;

  factory HttpException.fromJson(Map<String, dynamic> json) {
    final status = json['status'];
    final code = json['code'];
    final message = json['message'];
    final data = json['data'];

    if (status == null) {
      throw HttpErrorDataException('status cannot be null');
    }

    if (status is! int) {
      throw HttpErrorDataException('status must be int type');
    }

    if (code == null) {
      throw HttpErrorDataException('code cannot be null');
    }

    if (code is! String) {
      throw HttpErrorDataException('code must be String type');
    }

    if (code.isEmpty) {
      throw HttpErrorDataException('code cannot be empty');
    }

    if (message != null && message is! String) {
      throw HttpErrorDataException('message must be String if it is not null');
    }

    return HttpException(
      status: status,
      code: code,
      message: message as String?,
      data: data,
    );
  }

  factory HttpException.fromString(int status, String text) {
    return HttpException(
      status: status,
      code: _defaultErrorCode,
      data: text,
    );
  }

  @override
  String toString() => {
        'status': status,
        'code': code,
        'message': message,
        'data': data.toString(),
      }.toString();

  final int status;
  final String code;
  final String? message;
  final dynamic data;
}

/// Exception thrown when the success response body is not the expected type.
class HttpResponseBodyTypeException extends HttpException {
  HttpResponseBodyTypeException(int status, Type T, Object? data)
      : super(
          status: status,
          code: _defaultErrorCode,
          message: 'The response data does not match the expected type: $T',
          data: data,
        );
}

/// Exception thrown when the error response contains unexpected data types.
class HttpErrorDataException extends HttpException {
  HttpErrorDataException(String message)
      : super(
          status: -1,
          code: _defaultErrorCode,
          message: message,
        );
}
