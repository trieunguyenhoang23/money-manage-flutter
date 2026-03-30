import 'package:money_manage_flutter/export/ui_external.dart';
import 'package:money_manage_flutter/export/shared.dart';
import '../provider/profile_provider.dart';
import 'package:money_manage_flutter/export/core.dart';

class ButtonSwitchLoginWidget extends ConsumerWidget {
  const ButtonSwitchLoginWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Consumer(
      builder: (context, ref, _) {
        final profileState = ref.watch(profileProvider);
        final profileNotifier = ref.watch(profileProvider.notifier);

        return profileState.when(
          data: (state) => state.userLocalModel != null
              ? BtnMainWidget(
                  onTap: profileNotifier.onLogout,
                  color: ColorConstant.error500,
                  child: TextGGStyle(
                    context.lang.profile_logout,
                    0.05.sw,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                )
              : BtnMainWidget(
                  onTap: profileNotifier.onSignIn,
                  color: ColorConstant.primary,
                  child: TextGGStyle(
                    context.lang.profile_login,
                    0.05.sw,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
          loading: () => const LoadingWidget(),
          error: (err, stack) => Text('Error: $err'),
        );
      },
    );
  }
}
