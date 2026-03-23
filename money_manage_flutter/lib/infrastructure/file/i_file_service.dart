import 'models/file_picked.dart';

abstract class IFileService {
  Future<FilePicked?> pickImageFromGalleryAndCrop({
    required int widthStandard,
    required int heightStandard,
  });

  Future<FilePicked?> pickImageFromFileAndCrop({
    required int widthStandard,
    required int heightStandard,
  });
}