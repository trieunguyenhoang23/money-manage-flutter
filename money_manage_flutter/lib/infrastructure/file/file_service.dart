import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:injectable/injectable.dart';
import 'i_file_service.dart';
import 'img_processor.dart';
import 'models/file_picked.dart';

@Singleton(as: IFileService)
class FileServiceImpl implements IFileService {
  final ImagePicker _picker;
  final ImageProcessor _processor;

  FileServiceImpl(this._picker, this._processor);

  @override
  Future<FilePicked?> pickImageFromGalleryAndCrop({
    required int widthStandard,
    required int heightStandard,
  }) async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile == null) return null;

    return await _handleImageWorkflow(
      File(pickedFile.path),
      pickedFile.name,
      'gallery',
      widthStandard,
      heightStandard,
    );
  }

  @override
  Future<FilePicked?> pickImageFromFileAndCrop({
    required int widthStandard,
    required int heightStandard,
  }) async {
    final result = await FilePicker.platform.pickFiles(type: FileType.image);
    if (result == null || result.files.single.path == null) return null;

    return await _handleImageWorkflow(
      File(result.files.single.path!),
      result.files.single.name,
      'file_picker',
      widthStandard,
      heightStandard,
    );
  }

  /// Workflow điều phối: Lấy file -> Crop -> Compress -> Đóng gói Model
  Future<FilePicked?> _handleImageWorkflow(
    File file,
    String name,
    String source,
    int w,
    int h,
  ) async {
    // Crop thông qua processor
    final cropped = await _processor.crop(
      sourcePath: file.path,
      width: w,
      height: h,
    );
    if (cropped == null) return null;

    final String ext = name.split('.').last.toLowerCase();

    // Compress thông qua processor
    final bytes = await _processor.compressToLimit(
      path: cropped.path,
      extension: ext,
      minWidth: w,
      minHeight: h,
    );

    // Dọn dẹp file tạm
    _processor.deleteFile(file);
    _processor.deleteFile(File(cropped.path));

    return FilePicked(
      name: name,
      url: '',
      extension: ext,
      size: (bytes.lengthInBytes / 1024).toInt(),
      bytes: bytes,
      source: source,
    );
  }
}
