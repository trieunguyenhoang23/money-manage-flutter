import 'dart:async';
import 'package:money_manage_flutter/export/ui_external.dart';
import 'package:money_manage_flutter/export/core.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../../../sync/data/model/sync_batch_progress.dart';
import '../../../../sync/domain/repositories/sync_repository.dart';
import '../../../../sync/domain/usecase/sync_category_usecase.dart';
import '../../../../sync/domain/usecase/sync_transaction_usecase.dart';
import '../../../../sync/presentation/widget/sync_progress_builder_widget.dart';

class SyncProgressSlideWidget extends StatefulWidget {
  const SyncProgressSlideWidget({super.key});

  @override
  State<SyncProgressSlideWidget> createState() =>
      _SyncProgressSlideWidgetState();
}

class _SyncProgressSlideWidgetState extends State<SyncProgressSlideWidget> {
  PageController pageController = PageController(initialPage: 0);
  late Timer timer;
  int currentPage = 0;

  List<Widget> syncWidget = [
    SyncProgressBuilderWidget(
      syncStreamFactory: () => getIt<SyncCateUseCase>().execute(),
      onCompleted: () {},
      onRetry: () {},
      syncType: SyncType.category,
      getSyncStatus: getIt<SyncRepository>().getCategorySyncStatus,
    ),
    SyncProgressBuilderWidget(
      syncStreamFactory: () => getIt<SyncTransactionUseCase>().execute(),
      onCompleted: () {},
      onRetry: () {},
      syncType: SyncType.transaction,
      getSyncStatus: getIt<SyncRepository>().getTransactionSyncStatus,
    ),
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    timer = Timer.periodic(const Duration(seconds: 5), (Timer timer) {
      if (currentPage < syncWidget.length - 1) {
        currentPage++;
      } else {
        currentPage = 0;
      }
      pageController.animateToPage(
        currentPage,
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeIn,
      );
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    timer.cancel();
    pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double w = 1.sw - 0.05.sw;
    double h = w * 130 / 339;

    double wBtn = (109 / 1024).sw;
    double hBtn = wBtn * 24 / 70;

    return SizedBox(
      width: w,
      height: h,
      child: Stack(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: PageView.builder(
              clipBehavior: Clip.none,
              controller: pageController,
              itemCount: syncWidget.length,
              itemBuilder: (context, index) {
                return syncWidget[index];
              },
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: wBtn,
              height: hBtn,
              alignment: Alignment.center,
              margin: EdgeInsets.symmetric(vertical: h * 0.1),
              child: LayoutBuilder(
                builder: (context, cc) {
                  double dotSize = cc.maxWidth * (1 / syncWidget.length - 0.15);
                  return RepaintBoundary(
                    child: SmoothPageIndicator(
                      count: syncWidget.length,
                      effect: WormEffect(
                        activeDotColor: ColorConstant.primary,
                        dotColor: ColorConstant.neutral200,
                        dotHeight: dotSize,
                        dotWidth: dotSize,
                      ),
                      controller: pageController,
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
