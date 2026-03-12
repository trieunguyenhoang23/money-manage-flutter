import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:money_manage_flutter/core/utils/toast_utils.dart';
import 'package:money_manage_flutter/export/infrastructure.dart';
import '../../../../../core/di/injection.dart';
import '../../../../category/presentation/provider/category_provider.dart';
import '../../data/datasource/local/user_local_datasource.dart';
import '../../data/model/local/user_local_model.dart';
import '../../domain/usecase/auth_usecase.dart';
import '../../domain/usecase/logout_usecase.dart';

class ProfileState {
  final UserLocalModel? userLocalModel;

  ProfileState({this.userLocalModel});

  ProfileState copyWith(UserLocalModel? userProfile) {
    return ProfileState(userLocalModel: userProfile);
  }
}

class ProfileNotifier extends Notifier<ProfileState> {
  @override
  ProfileState build() {
    _init();
    return ProfileState();
  }

  Future<void> _init() async {
    final user = await getIt<UserLocalDatasource>().getCurrentUser();
    state = state.copyWith(user);
  }

  void onSignIn() async {
    final result = await getIt<AuthUseCase>().execute(AuthMethod.google);
    await result.fold(
      (error) {
        ToastUtils.showToastFailed(error.message);
      },
      (userLocal) async {
        state = state.copyWith(userLocal);

        ///Refresh category to loading from server
        await ref.read(loadingCategoryProvider.notifier).refresh();
      },
    );
  }

  void onLogout() async {
    await getIt<LogoutUseCase>().execute().then((_) async {
      state = state.copyWith(null);
      await ref.read(loadingCategoryProvider.notifier).refresh();
    });
  }
}

final profileProvider = NotifierProvider<ProfileNotifier, ProfileState>(() {
  return ProfileNotifier();
});
