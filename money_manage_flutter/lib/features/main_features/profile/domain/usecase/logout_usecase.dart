import 'package:injectable/injectable.dart';

import '../../../../category/domain/repositories/category_repository.dart';
import '../repositories/user_repository.dart';

@LazySingleton()
class LogoutUseCase {
  UserRepository _userRepository;
  CategoryRepository _categoryRepository;

  LogoutUseCase(this._userRepository, this._categoryRepository);

  Future<void> execute({required bool isClearLocalData}) async {
    _userRepository.clearSession();

    if (isClearLocalData) {

    }
  }
}
