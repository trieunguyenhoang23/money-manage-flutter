import 'package:injectable/injectable.dart';
import '../repositories/user_repository.dart';

@LazySingleton()
class UpdateCurrencyUseCase {
  final UserRepository _userRepository;

  UpdateCurrencyUseCase(this._userRepository);

  Future<void> execute(String newCurrency) async {
    return await _userRepository.updateCurrency(newCurrency);
  }
}
