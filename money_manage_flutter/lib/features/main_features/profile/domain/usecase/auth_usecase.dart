import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../../core/error/failure.dart';
import '../../../../../infrastructure/social_auth/social_auth_factory.dart';
import '../../../../category/domain/repositories/category_repository.dart';
import '../../../../sync/domain/repositories/sync_repository.dart';
import '../../data/model/local/user_local_model.dart';
import '../repositories/user_repository.dart';

@LazySingleton()
class AuthUseCase {
  final UserRepository _userRepository;
  final SyncRepository _syncRepository;
  final CategoryRepository _categoryRepository;

  AuthUseCase(
    this._userRepository,
    this._syncRepository,
    this._categoryRepository,
  );

  Future<Either<Failure, UserLocalModel>> execute(AuthMethod method) async {
    final signInResult = await _userRepository.signIn(method);

    return await signInResult.fold((failure) async => Left(failure), (
      userLocal,
    ) async {
      final syncResult = await _syncRepository.syncAll();

      return syncResult.fold(
        (syncFailure) => Left(syncFailure), // Stop here and show error
        (_) async {
          // Remove data from local after sync to server for refetch data
          await _categoryRepository.clearAllData();
          return Right(userLocal);
        }, // Success!
      );
    });
  }
}
