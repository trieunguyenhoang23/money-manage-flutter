import 'package:money_manage_flutter/export/core.dart';
import 'package:money_manage_flutter/export/shared.dart';
import 'package:money_manage_flutter/export/ui_external.dart';
import '../provider/profile_provider.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final profileState = ref.watch(profileProvider);
    final profileNotifier = ref.watch(profileProvider.notifier);

    return Center(
      child: profileState.userLocalModel != null
          ? BtnMainWidget(
              onTap: profileNotifier.onLogout,
              color: ColorConstant.error400,
              child: TextGGStyle(context.lang.profile_logout, 0.05.sw),
            )
          : BtnMainWidget(
              onTap: profileNotifier.onSignIn,
              color: ColorConstant.primary,
              child: TextGGStyle(context.lang.profile_login, 0.05.sw),
            ),
    );
  }
}
