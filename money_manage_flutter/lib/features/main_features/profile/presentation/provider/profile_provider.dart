import 'package:hooks_riverpod/legacy.dart';
import 'package:money_manage_flutter/export/infrastructure.dart';
import 'package:money_manage_flutter/features/main_features/profile/domain/usecase/logout_usecase.dart';
import '../../../../../core/di/injection.dart';
import '../../data/datasource/local/user_local_datasource.dart';
import '../../data/model/local/user_local_model.dart';
import '../../domain/usecase/auth_usecase.dart';

class ProfileState {
  final UserLocalModel? userLocalModel;

  ProfileState({this.userLocalModel});

  ProfileState copyWith(UserLocalModel? userProfile) {
    return ProfileState(userLocalModel: userProfile ?? userLocalModel);
  }
}

class ProfileNotifier extends StateNotifier<ProfileState> {
  ProfileNotifier(super.state) {
    _init();
  }

  Future<void> _init() async {
    final user = await getIt<UserLocalDatasource>().getCurrentUser();
    state = state.copyWith(user);
  }

  void onSignIn() async {
    final result = await getIt<AuthUseCase>().execute(AuthMethod.google);
  }

  void onLogout() async {
    await getIt<LogoutUseCase>().execute(isClearLocalData: true);
  }
}

final profileProvider = StateNotifierProvider<ProfileNotifier, ProfileState>((
  ref,
) {
  return ProfileNotifier(ProfileState());
});
