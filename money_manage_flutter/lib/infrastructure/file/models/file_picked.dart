import 'package:flutter/services.dart';

class FilePicked {
  String name;
  String url;
  String extension;
  int size;
  Uint8List bytes;
  String source;

  FilePicked({
    required this.name,
    required this.url,
    required this.extension,
    required this.size,
    required this.bytes,
    required this.source,
  });
}
