import 'dart:io';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:flutter/services.dart';
import '../../core/constant/color_constant.dart';
import '../../export/core_external.dart';

@lazySingleton
class ImageProcessor {
  /// Logic Crop ảnh
  Future<CroppedFile?> crop({
    required String sourcePath,
    required int width,
    required int height,
  }) async {
    return await ImageCropper().cropImage(
      sourcePath: sourcePath,
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Crop Image',
          toolbarColor: ColorConstant.primary,
          lockAspectRatio: true,
        ),
        IOSUiSettings(title: 'Crop Image', aspectRatioLockEnabled: true),
      ],
    );
  }

  /// Logic Nén ảnh vòng lặp dưới 500KB
  Future<Uint8List> compressToLimit({
    required String path,
    required String extension,
    required int minWidth,
    required int minHeight,
    int limitSize = 512000, // 500 KB
  }) async {
    final CompressFormat format = _getFormat(extension);

    int quality = 90;
    Uint8List? resultBytes;

    while (quality > 20) {
      final result = await FlutterImageCompress.compressWithFile(
        path,
        minWidth: minWidth,
        minHeight: minHeight,
        quality: quality,
        format: format,
      );

      if (result == null) break;
      resultBytes = result;
      if (resultBytes.length <= limitSize) break;
      quality -= 10;
    }

    if (resultBytes == null) throw Exception("Compression failed");
    return resultBytes;
  }

  CompressFormat _getFormat(String ext) {
    if (ext == 'png') return CompressFormat.png;
    if (ext == 'webp') return CompressFormat.webp;
    return CompressFormat.jpeg;
  }

  void deleteFile(File file) {
    if (file.existsSync()) file.delete().catchError((_) => null);
  }
}
