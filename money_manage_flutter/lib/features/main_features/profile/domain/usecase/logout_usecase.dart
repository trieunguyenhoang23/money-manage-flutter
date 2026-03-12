import 'package:injectable/injectable.dart';

import '../../../../category/domain/repositories/category_repository.dart';
import '../repositories/user_repository.dart';

@LazySingleton()
class LogoutUseCase {
  final UserRepository _userRepository;
  final CategoryRepository _categoryRepository;

  LogoutUseCase(this._userRepository, this._categoryRepository);

  Future<void> execute() async {
    await _userRepository.clearSession();
    await _categoryRepository.clearAllData();
  }
}
