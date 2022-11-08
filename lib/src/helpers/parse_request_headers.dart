import '../types.dart';
import 'parse_colon_uri.dart';

/// Headers priorities:
/// 1. headers from [headersBuilder]
/// 2. [headers]
/// 3. default headers
Future<Map<String, String>> parseRequestHeaders({
  required RequestMethod method,
  required Uri uri,
  ColonUri? colonUri,
  bool useForm = false,
  // The custom headers of current request.
  Map<String, String>? headers,
  HttpHeadersBuilder? headersBuilder,
}) async {
  final result = <String, String>{
    if (!useForm && (method.isPost || method.isPut))
      'content-type': 'application/json; charset=UTF-8'
  };

  void apply(Map<String, String>? items) {
    if (items == null || items.isEmpty) {
      return;
    }
    for (final item in items.entries) {
      result[item.key.toLowerCase()] = item.value;
    }
  }

  apply(headers);

  if (headersBuilder != null) {
    apply(await headersBuilder(HttpRequest(
      headers: Map.unmodifiable(result),
      endpointName: colonUri?.name,
      endpointPath: colonUri?.path,
      uri: uri,
    )));
  }

  return Map.unmodifiable(result);
}
