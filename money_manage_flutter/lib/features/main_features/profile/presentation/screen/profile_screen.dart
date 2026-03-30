import 'package:money_manage_flutter/core/di/injection.dart';
import 'package:money_manage_flutter/export/core.dart';
import 'package:money_manage_flutter/export/shared.dart';
import 'package:money_manage_flutter/export/ui_external.dart';
import '../../../../sync/data/model/sync_batch_progress.dart';
import '../../../../sync/domain/repositories/sync_repository.dart';
import '../../../../sync/domain/usecase/sync_category_usecase.dart';
import '../../../../sync/domain/usecase/sync_transaction_usecase.dart';
import '../../../../sync/presentation/widget/sync_progress_builder_widget.dart';
import '../provider/profile_provider.dart';
import '../widget/profile_currency_widget.dart';
import '../widget/profile_theme_widget.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  List<Widget> profileOptions = const [
    ProfileCurrencyWidget(),
    ProfileThemeWidget(),
  ];

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
                      ? Column(
                          children: [
                            BtnMainWidget(
                              onTap: profileNotifier.onLogout,
                              color: ColorConstant.error400,
                              child: TextGGStyle(
                                context.lang.profile_logout,
                                0.05.sw,
                              ),
                            ),

                            /// Sync widget
                            for (var widget in syncWidget) ...[
                              const SpacingStyle(),
                              widget,
                            ],
                          ],
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
          const SliverToBoxAdapter(child: SpacingStyle()),
        ],
      ),
    );
  }
}
