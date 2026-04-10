import 'package:injectable/injectable.dart';
import 'package:dartz/dartz.dart';
import 'package:money_manage_flutter/core/network/online_action_guard.dart';
import '../../../../../core/error/failure.dart';
import '../../domain/repositories/user_repository.dart';
import '../datasource/local/user_local_datasource.dart';
import '../datasource/remote/user_remote_datasource.dart';
import 'package:money_manage_flutter/export/infrastructure.dart';
import '../model/local/user_local_model.dart';

@LazySingleton(as: UserRepository)
class UserRepositoryImpl implements UserRepository {
  final UserLocalDatasource _localDatasource;
  final UserRemoteDatasource _remoteDatasource;
  final SocialAuthFactory _socialAuthFactory;
  final OnlineActionGuard _onlineActionGuard;

  UserRepositoryImpl(
    this._localDatasource,
    this._remoteDatasource,
    this._socialAuthFactory,
    this._onlineActionGuard,
  );

  @override
  Future<Either<Failure, UserLocalModel>> signIn(AuthMethod method) async {
    // Get the specific service (Google/Apple)
    final service = _socialAuthFactory.getService(method);

    // Perform the sign-in
    final socialUser = await service.signIn();
    if (socialUser == null) return const Left(ServerFailure('Login Failed'));

    // Sync with your LoopBack backend via RemoteDatasource
    final data = await _remoteDatasource.verifyAuthenticate(
      jsonBody: socialUser.toJson(),
    );

    //Error
    if (data is String) return Left(ServerFailure(data));

    try {
      final String accessToken = data['token'];
      final String refreshToken = data['refreshToken'];
      final Map<String, dynamic> userData = data['user'];

      // Save Tokens to Secure Storage for the Interceptor
      await _localDatasource.saveTokens(accessToken, refreshToken);

      // Map JSON to Local Model and Save to Isar
      final userLocalModel = UserLocalModel.fromRemote(userData);
      await _localDatasource.saveUser(userLocalModel);
      return Right(userLocalModel);
    } catch (e) {
      return Left(CacheFailure('Failed to save user session $e'));
    }
  }

  @override
  Future<void> clearSession() async {
    await _localDatasource.clearSession();
  }

  @override
  Future<String> getCurrentUserId() async {
    final localUser = await _localDatasource.getCurrentUser();
    return localUser?.idServer ?? '';
  }

  @override
  Future<void> updateCurrency(String newCurrency) async {
    await _localDatasource.updateCurrency(newCurrency);

    await _onlineActionGuard.run((currentUserId, networkStatus) async {
      final localUser = await _localDatasource.getCurrentUser();
      if (localUser != null) {
        await _remoteDatasource.updateUserProperties({'currency': newCurrency});
      }
    });
  }

  @override
  Future<String> getCurrency() async {
    String currency = await _localDatasource.getCurrentCurrency();

    await _onlineActionGuard.run((currentUserId, networkStatus) async {
      final result = await _remoteDatasource.getUserCurrency();
      if (result.isFailure) return;

      currency = result.data['currency'];
    });

    return currency;
  }
}
