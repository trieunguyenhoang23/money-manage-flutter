import 'package:money_manage_flutter/core/utils/size_app_utils.dart';
import 'package:money_manage_flutter/export/shared.dart';
import 'package:money_manage_flutter/export/ui_external.dart';
import '../provider/profile_provider.dart';
import '../widget/button_switch_login_widget.dart';
import '../widget/profile_currency_widget.dart';
import '../widget/profile_language_widget.dart';
import '../widget/profile_theme_widget.dart';
import '../widget/sync_progress_slide_widget.dart';
import 'profile_logged_in_screen.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  List<Widget> profileOptions = const [
    ProfileCurrencyWidget(),
    ProfileThemeWidget(),
    ProfileLanguageWidget(),
  ];

  @override
  Widget build(BuildContext context) {
    return PaddingStyle(
      child: Column(
        children: [
          Expanded(
            child: CustomScrollView(
              slivers: [
                Consumer(
                  builder: (context, ref, _) {
                    final profileState = ref.watch(profileProvider);
                    return SliverToBoxAdapter(
                      child: profileState.when(
                        data: (state) => state.userLocalModel != null
                            ? const Column(
                                children: [
                                  ProfileLoggedInScreen(),
                                  SpacingStyle(),

                                  /// Sync widget
                                  SyncProgressSlideWidget(),
                                ],
                              )
                            : const SizedBox(),
                        loading: () => const LoadingWidget(),
                        error: (err, stack) => Text('Error: $err'),
                      ),
                    );
                  },
                ),
                const SliverToBoxAdapter(child: SpacingStyle()),
                SliverGrid(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    return profileOptions[index];
                  }, childCount: profileOptions.length),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: SizeAppUtils().isTablet ? 2 : 1,
                    childAspectRatio: 6,
                    mainAxisSpacing: SizeAppUtils().isTablet ? 30 : 15,
                    crossAxisSpacing: SizeAppUtils().isTablet ? 30 : 15,
                  ),
                ),
                const SliverToBoxAdapter(child: SpacingStyle()),
              ],
            ),
          ),
          const ButtonSwitchLoginWidget(),
        ],
      ),
    );
  }
}
