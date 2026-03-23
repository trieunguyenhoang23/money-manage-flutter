import 'package:dartz/dartz.dart';
import 'package:money_manage_flutter/core/enum/transaction_type.dart';
import 'package:money_manage_flutter/export/core_external.dart';
import 'package:money_manage_flutter/infrastructure/network/network_info.dart';
import '../../../../../core/error/failure.dart';
import '../../../../../core/utils/size_app_utils.dart';
import '../../../../../infrastructure/file/models/file_picked.dart';
import '../../../../category/data/model/local/category_local_model.dart';
import '../../../profile/domain/repositories/user_repository.dart';
import '../../domain/repositories/transaction_repository.dart';
import '../datasource/local/transactions_local_datasource.dart';
import '../datasource/remote/transactions_remote_datasource.dart';
import '../model/local/transaction_local_model.dart';

@LazySingleton(as: TransactionRepository)
class TransactionRepositoryImpl implements TransactionRepository {
  final TransactionsRemoteDatasource _remoteDatasource;
  final TransactionsLocalDatasource _localDatasource;
  final UserRepository _userRepository;
  final NetworkInfo _networkInfo;

  TransactionRepositoryImpl(
    this._remoteDatasource,
    this._localDatasource,
    this._userRepository,
    this._networkInfo,
  );

  int limitCount = SizeAppUtils().isTablet ? 20 : 10;

  @override
  Future<List<CategoryLocalModel>> getCategoryThroughTrans(
    TransactionType type,
    int range,
  ) async {
    return await _localDatasource.getRecentActiveCategories(range, type);
  }

  @override
  Future<Either<Failure, TransactionLocalModel>> addTransaction({
    required double amount,
    required String note,
    required CategoryLocalModel category,
    required DateTime transactionAt,
    FilePicked? image,
  }) async {
    bool isLogin = await _userRepository.checkIsLogin();

    TransactionLocalModel transaction = TransactionLocalModel()
      ..amount = amount
      ..note = note
      ..transactionAt = transactionAt
      ..createdAt = DateTime.now()
      ..updatedAt = DateTime.now()
      ..type = category.type ?? TransactionType.EXPENSE
      ..categoryId = category.idServer
      ..category.value = category
      ..imageBytes = image?.bytes
      ..currency = 'VND';

    /// Add more properties if logged in
    if (isLogin && await _networkInfo.isConnected) {
      String currentActiveUser = await _userRepository.getCurrentUserId();
      String imageUrl = '';
      transaction = TransactionLocalModel()
        ..userId = currentActiveUser
        ..imageUrl = imageUrl
        ..imageBytes = null
        ..isSynced = true;
    }

    await _localDatasource.addTransaction(transaction);

    return Right(transaction);
  }

  @override
  Future<List<TransactionLocalModel>> loadTransByPage(int page) async {
    var localData = await _localDatasource.loadByPage(page, limitCount);
    if (await _userRepository.checkIsLogin() && localData.isEmpty) {
      // final remoteData = await _remoteDatasource.loadCateByPage(
      //   page,
      //   limitCount,
      // );
      // if (remoteData.isSuccess) {
      //   final localModels = await parseListJsonIsolate(
      //     CategoryLocalModel.fromJson,
      //     remoteData.data,
      //   );

      // Save to local Isar
      // await _localDatasource.saveAll(localModels);
      // localData = await _localDatasource.loadByType(page, limitCount, type);
      // }
    }
    return localData;
  }
}
