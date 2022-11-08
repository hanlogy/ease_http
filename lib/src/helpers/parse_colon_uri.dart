/// Parses 'A:B' type uris.
ColonUri? parseColonUri(String uri) {
  if (RegExp('^[a-z]+://').hasMatch(uri)) {
    return null;
  }

  final segments = uri.split(':');

  return ColonUri(
    segments[0].trim(),
    segments.getRange(1, segments.length).join(':').trim(),
  );
}

class ColonUri {
  const ColonUri(this.name, this.path);
  final String name;
  final String path;

  Map<String, String> toMap() => {'name': name, 'path': path};
}
