import 'package:dio/dio.dart' as dio;
import 'package:flutter/services.dart';

class MapEntryUtils {
  static MapEntry<String, dio.MultipartFile> getMapEntry(
    String key,
    Uint8List bytes,
    String fileName,
  ) {
    return MapEntry<String, dio.MultipartFile>(
      key,
      dio.MultipartFile.fromBytes(bytes, filename: fileName),
    );
  }
}
