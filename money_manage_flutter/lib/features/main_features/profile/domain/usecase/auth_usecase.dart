import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../../core/error/failure.dart';
import '../../../../../infrastructure/social_auth/social_auth_factory.dart';
import '../../data/model/local/user_local_model.dart';
import '../repositories/user_repository.dart';

@LazySingleton()
class AuthUseCase {
  final UserRepository _userRepository;

  AuthUseCase(this._userRepository);

  Future<Either<Failure, UserLocalModel>> execute(
    AuthMethod method,
    String currency,
  ) async {
    final signInResult = await _userRepository.signIn(method, currency);
    return signInResult;
  }
}
