import 'package:money_manage_flutter/export/core.dart';
import 'package:money_manage_flutter/export/shared.dart';
import 'package:money_manage_flutter/export/ui_external.dart';
import '../../../../../../infrastructure/file/models/file_picked.dart';
import '../../provider/transaction_provider.dart';

class ImageWidget extends ConsumerWidget {
  const ImageWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = ref.read(currentTransactionProvider);
    final filePickedNotifier = ref.read(provider.notifier);

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
                child: Consumer(
                  builder: (context, ref, _) {
                    final filePickedState = ref.watch(
                      provider.select((s) => s.imageFile),
                    );
                    final imageLocalState = ref.watch(
                      provider.select((s) => s.imageOriginal),
                    );
                    return LayoutBuilder(
                      builder: (context, cc2) {
                        return Center(
                          child:
                              imageLocalState != null || filePickedState != null
                              ? _imageWidget(
                                  cc,
                                  filePickedState,
                                  filePickedNotifier,
                                  imageLocalState,
                                )
                              : BtnMainWidget(
                                  w: cc.maxWidth * 0.1,
                                  h: cc.maxWidth * 0.1,
                                  color: ColorConstant.primary,
                                  child: const Icon(
                                    Icons.add,
                                    color: Colors.white,
                                  ),
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

  Widget _imageWidget(
    BoxConstraints cc,
    filePickedState,
    filePickedNotifier,
    imageLocal,
  ) {
    return Stack(
      children: [
        imageLocal != null
            ? imageLocal is String
                  ? ThumbnailNetworkWidget(
                      w: cc.maxWidth,
                      h: cc.maxHeight,
                      imgUrl: imageLocal,
                      boxFit: BoxFit.contain,
                      radius: 0,
                    )
                  : ThumbnailLocalWidget(
                      w: cc.maxWidth,
                      h: cc.maxHeight,
                      imgUrl: imageLocal,
                      boxFit: BoxFit.contain,
                      radius: 0,
                    )
            : ThumbnailLocalWidget(
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
