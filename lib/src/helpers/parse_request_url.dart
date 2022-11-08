import 'parse_colon_uri.dart';

Uri parseRequestUrl(
  String url, {
  Map<String, String?>? endpointMap,
  Map<String, dynamic>? params,
  ColonUri? colonUri,
}) {
  if (colonUri != null) {
    final colonValue = endpointMap?[colonUri.name];

    if (colonValue != null) {
      url = colonValue;
      if (colonUri.path.isNotEmpty) {
        url = '$url/${colonUri.path}';
      }
    }
  }

  var result = Uri.parse(url);
  if (params != null) {
    result = result.replace(queryParameters: params);
  }

  return result;
}
