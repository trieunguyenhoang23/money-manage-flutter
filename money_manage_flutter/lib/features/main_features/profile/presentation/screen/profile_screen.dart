import 'package:money_manage_flutter/export/core.dart';
import 'package:money_manage_flutter/export/shared.dart';
import 'package:money_manage_flutter/export/ui_external.dart';
import '../provider/profile_provider.dart';
import '../widget/profile_currency_widget.dart';
import '../widget/profile_theme_widget.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  late List<Widget> profileOptions = const [
    ProfileCurrencyWidget(),
    ProfileThemeWidget(),
  ];

  @override
  Widget build(BuildContext context) {
    return PaddingStyle(
      child: CustomScrollView(
        slivers: [
          Consumer(
            builder: (context, ref, _) {
              final profileState = ref.watch(profileProvider);
              final profileNotifier = ref.watch(profileProvider.notifier);

              return SliverToBoxAdapter(
                child: profileState.when(
                  data: (state) => state.userLocalModel != null
                      ? BtnMainWidget(
                          onTap: profileNotifier.onLogout,
                          color: ColorConstant.error400,
                          child: TextGGStyle(
                            context.lang.profile_logout,
                            0.05.sw,
                          ),
                        )
                      : BtnMainWidget(
                          onTap: profileNotifier.onSignIn,
                          color: ColorConstant.primary,
                          child: TextGGStyle(
                            context.lang.profile_login,
                            0.05.sw,
                          ),
                        ),
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
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 1,
              childAspectRatio: 6,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
            ),
          ),
        ],
      ),
    );
  }
}
