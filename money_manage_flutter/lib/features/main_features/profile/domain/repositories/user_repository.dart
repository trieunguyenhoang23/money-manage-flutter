import '../../../../../core/error/failure.dart';
import '../../../../../infrastructure/social_auth/social_auth_factory.dart';
import '../../data/model/local/user_local_model.dart';
import 'package:dartz/dartz.dart';

abstract class UserRepository {
  Future<Either<Failure, UserLocalModel>> signIn(AuthMethod method);

  Future<String> getCurrentUserId();

  Future<String> getCurrency();

  Future<void> clearSession();

  Future<void> updateCurrency(String newCurrency);
}
