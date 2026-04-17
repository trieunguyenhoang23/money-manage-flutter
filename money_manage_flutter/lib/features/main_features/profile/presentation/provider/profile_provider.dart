import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:money_manage_flutter/export/core.dart';
import '../../../../../infrastructure/social_auth/social_auth_factory.dart';
import '../../../../category/presentation/provider/category_provider.dart';
import '../../../../sync/data/model/sync_batch_progress.dart';
import '../../../../sync/presentation/provider/sync_manager_provider.dart';
import '../../../../sync/presentation/provider/sync_provider.dart';
import '../../../analytics/presentation/provider/overview_balance_provider.dart';
import '../../../transactions/presentation/provider/quick_select_cate_provider.dart';
import '../../../transactions/presentation/provider/transaction_provider.dart';
import '../../data/datasource/local/user_local_datasource.dart';
import '../../data/model/local/user_local_model.dart';
import '../../domain/usecase/auth_usecase.dart';
import '../../domain/usecase/logout_usecase.dart';
import 'currency_provider.dart';

class ProfileState {
  final UserLocalModel? userLocalModel;

  ProfileState({this.userLocalModel});

  ProfileState copyWith({UserLocalModel? userLocalModel}) {
    return ProfileState(userLocalModel: userLocalModel ?? this.userLocalModel);
  }
}

class ProfileNotifier extends AsyncNotifier<ProfileState> {
  @override
  Future<ProfileState> build() async {
    final user = await getIt<UserLocalDatasource>().getCurrentUser();
    return ProfileState(userLocalModel: user);
  }

  Future<void> onSignIn() async {
    final result = await getIt<AuthUseCase>().execute(AuthMethod.google);

    result.fold((error) => ToastUtils.showToastFailed(error.message), (
      userLocal,
    ) async {
      // Cập nhật state bằng AsyncData
      state = AsyncData(state.value!.copyWith(userLocalModel: userLocal));

      /// Refresh data từ server
      ref.invalidate(loadingTransactionProvider);
      ref.invalidate(loadingCategoryProvider);

      /// Update UI only (Don't need to update data to server) => isSyncData: false
      await ref
          .read(currencyProvider.notifier)
          .updateCurrency(
            state.value?.userLocalModel?.currency ?? 'VND',
            isSyncData: false,
          );

      ref.refresh(overviewBalanceProvider);
      ref.read(syncManagerProvider.notifier).initSync(type: SyncType.all);

      /// Register sync data in background
      Future.delayed(const Duration(seconds: 3), () {
        BackgroundTaskHelper.scheduleSync();
      });
    });
  }

  Future<void> onLogout() async {
    await getIt<LogoutUseCase>().execute();
    state = AsyncData(ProfileState(userLocalModel: null));

    Future.microtask(() {
      ref.invalidate(loadingCategoryProvider);
      ref.invalidate(loadingTransactionProvider);
      ref.invalidate(overviewBalanceProvider);
      ref.invalidate(quickSelectCategoryProvider);
      ref.invalidate(syncManagerProvider);
      ref.invalidate(syncStreamProvider);
    });
  }
}

final profileProvider = AsyncNotifierProvider<ProfileNotifier, ProfileState>(
  () {
    return ProfileNotifier();
  },
);
