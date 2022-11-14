import 'errors.dart';

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
      throw HttpUnexpectedErrorData('status cannot be null');
    }

    if (status is! int) {
      throw HttpUnexpectedErrorData('status must be int type');
    }

    if (code == null) {
      throw HttpUnexpectedErrorData('code cannot be null');
    }

    if (code is! String) {
      throw HttpUnexpectedErrorData('code must be String type');
    }

    if (code.isEmpty) {
      throw HttpUnexpectedErrorData('code cannot be empty');
    }

    if (message != null && message is! String) {
      throw HttpUnexpectedErrorData('message must be String if it is not null');
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

  @override
  bool operator ==(Object other) {
    return other is HttpException &&
        status == other.status &&
        code == other.code &&
        message == other.message &&
        data == other.data;
  }

  final int status;
  final String code;
  final String? message;
  final dynamic data;

  @override
  int get hashCode => Object.hash(status, code, message, data);
}
