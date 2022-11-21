import 'dart:io';
import 'package:http/http.dart';

extension EaseHttpFileExtensions on File {
  /// Converts this file to a [MultipartFile] with given [name].
  MultipartFile toMultipartFile(String name) => MultipartFile(
        name,
        readAsBytes().asStream(),
        lengthSync(),
        filename: path.split('/').last,
      );
}
