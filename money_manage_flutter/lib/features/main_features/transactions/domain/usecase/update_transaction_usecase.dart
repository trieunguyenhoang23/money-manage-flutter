import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../../core/error/failure.dart';
import '../../../../../infrastructure/file/models/file_picked.dart';
import '../../../../category/data/model/local/category_local_model.dart';
import '../../data/model/local/transaction_local_model.dart';
import '../repositories/transaction_repository.dart';

@LazySingleton()
class UpdateTransactionUseCase {
  final TransactionRepository _repository;

  UpdateTransactionUseCase(this._repository);

  Future<Either<Failure, TransactionLocalModel>> execute({
    required Map<String, dynamic> updateJsonRequestBody,
    required TransactionLocalModel oldItem,
    required CategoryLocalModel newCate,
    FilePicked? imageFile,
  }) async {
    return await _repository.updateTransaction(
      updateJsonRequestBody: updateJsonRequestBody,
      oldItem: oldItem,
      newCate: newCate,
      imageFile: imageFile,
    );
  }
}
