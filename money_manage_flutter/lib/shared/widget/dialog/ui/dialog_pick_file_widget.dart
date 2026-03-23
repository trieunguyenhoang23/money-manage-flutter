import 'package:go_router/go_router.dart';
import 'package:money_manage_flutter/export/core.dart';
import 'package:money_manage_flutter/export/shared.dart';
import 'package:money_manage_flutter/export/ui_external.dart';
import '../../../../infrastructure/file/models/file_picked.dart';
import '../../../style/padding_style.dart';

class DialogPickFileWidget extends StatelessWidget {
  const DialogPickFileWidget({super.key});

  @override
  Widget build(BuildContext context) {
    FilePicked? imageBytes;

    int widthStandard = 512, heightStandard = 512;

    return PaddingStyle(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: 0.2.sh, // tối đa 40% màn hình
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _itemPicked(Icons.image, context.lang.gallery, () async {
              imageBytes = await fileService.pickImageFromGalleryAndCrop(
                widthStandard: widthStandard,
                heightStandard: heightStandard,
              );
              if (imageBytes != null) {
                context.pop(imageBytes);
              }
            }),
            SizedBox(height: 0.025.sh),
            _itemPicked(Icons.file_copy_sharp, context.lang.file, () async {
              imageBytes = await fileService.pickImageFromFileAndCrop(
                widthStandard: widthStandard,
                heightStandard: heightStandard,
              );
              if (imageBytes != null) {
                context.pop(imageBytes);
              }
            }),
          ],
        ),
      ),
    );
  }

  Widget _itemPicked(IconData icon, String title, Function() onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        color: Colors.transparent,
        width: 1.sw,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(icon, size: 0.075.sw),
            SizedBox(width: 0.05.sw),
            TextGGStyle(title, 0.04.sw),
          ],
        ),
      ),
    );
  }
}
