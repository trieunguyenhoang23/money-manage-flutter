import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../../core/error/failure.dart';
import '../../../../../infrastructure/social_auth/social_auth_factory.dart';
import '../../data/model/local/user_local_model.dart';
import '../repositories/user_repository.dart';

@LazySingleton()
class AuthUseCase {
  UserRepository _repository;

  AuthUseCase(this._repository);

  Future<Either<Failure, UserLocalModel>> execute(AuthMethod method) async {
    return await _repository.signIn(method);
  }
}
