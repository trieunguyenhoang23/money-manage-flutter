import 'package:money_manage_flutter/export/core.dart';
import 'package:money_manage_flutter/export/shared.dart';
import 'package:money_manage_flutter/export/ui_external.dart';
import '../../../../../../infrastructure/file/models/file_picked.dart';
import '../../provider/transaction_form_provider.dart';

class ImageWidget extends ConsumerWidget {
  final String? imgUrl;

  const ImageWidget({super.key, this.imgUrl});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filePickedState = ref.watch(
      transactionFormProvider.select((s) => s.image),
    );

    final filePickedNotifier = ref.watch(transactionFormProvider.notifier);

    return SizedBox(
      height: 0.25.sh,
      child: LayoutBuilder(
        builder: (context, cc) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextGGStyle(
                context.lang.image,
                (cc.maxHeight * 0.2).clamp(14, 18),
                fontWeight: FontWeight.bold,
              ),
              const SpacingStyle(),
              Expanded(
                child: LayoutBuilder(
                  builder: (context, cc2) {
                    return Center(
                      child: imgUrl != null || filePickedState != null
                          ? _imageWidget(
                              cc,
                              filePickedState,
                              filePickedNotifier,
                            )
                          : BtnMainWidget(
                              w: cc.maxWidth * 0.1,
                              h: cc.maxWidth * 0.1,
                              color: ColorConstant.primary,
                              child: const Icon(Icons.add, color: Colors.white),
                              onTap: () async {
                                FilePicked? imgBuffer =
                                    await DialogUtils.pickFile(context);
                                if (imgBuffer != null) {
                                  filePickedNotifier.updateImage(imgBuffer);
                                }
                              },
                            ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _imageWidget(BoxConstraints cc, filePickedState, filePickedNotifier) {
    return imgUrl != null
        ? ThumbnailNetworkWidget(
            w: cc.maxWidth,
            h: cc.maxHeight,
            imgUrl: imgUrl ?? '',
            radius: 0,
          )
        : Stack(
            children: [
              ThumbnailLocalWidget(
                w: cc.maxWidth,
                h: cc.maxHeight,
                imgUrl: filePickedState.bytes,
                boxFit: BoxFit.contain,
                radius: 0,
              ),
              Align(
                alignment: AlignmentGeometry.topRight,
                child: InkWell(
                  onTap: () {
                    filePickedNotifier.updateImage(null);
                  },
                  child: const Icon(Icons.delete, color: Colors.red),
                ),
              ),
            ],
          );
  }
}
