import 'package:ease_http/ease_http.dart';

void main() async {
  final request = SingleRequest();

// result is typed.
  final result = await request.get<Map<String, dynamic>>('http://example.com');

  print(result);
}
