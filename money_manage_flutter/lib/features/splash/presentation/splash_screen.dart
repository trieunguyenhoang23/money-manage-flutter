import 'package:money_manage_flutter/export/core.dart';
import 'package:money_manage_flutter/export/shared.dart';
import 'package:money_manage_flutter/export/ui_external.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import '../provider/splash_provider.dart';
import 'package:money_manage_flutter/export/router.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  late ProviderSubscription listener;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    listener = ref.listenManual<AsyncValue<double>>(splashProvider, (
      prev,
      next,
    ) {
      next.whenData((progress) {
        if (progress == 1) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            ///Navigate to main page
            NavigatorRouter.pushTo(
              context,
              TransactionsRoutes.transactionsPath,
            );
          });
        }
      });
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    listener.close();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // ClipRRect(
              //   borderRadius: BorderRadius.all(Radius.circular(0.0425.sw)),
              //   // child: Image.asset(
              //   //   IcPathConstant.icApp2,
              //   //   width: 0.5.sw,
              //   //   height: 0.5.sw,
              //   //   fit: BoxFit.fill,
              //   // ),
              // ),
              const SpacingStyle(),
              Consumer(
                builder: (context, ref, _) {
                  final splashState = ref.watch(splashProvider);

                  return splashState.when(
                    data: (progress) {
                      return RepaintBoundary(
                        child: CircularPercentIndicator(
                          radius: 1.w * 0.05,
                          lineWidth: 1.w * 0.01,
                          animation: true,
                          animateFromLastPercent: true,
                          percent: progress,
                          circularStrokeCap: CircularStrokeCap.round,
                          progressColor: ColorConstant.primary,
                        ),
                      );
                    },
                    error: (err, _) => TextGGStyle('Error $err', 0.05.sw),
                    loading: () => const LoadingWidget(),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
