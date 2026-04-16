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
    bool hasChanged = oldItem.merge(
      amountTemp: updateJsonRequestBody['amount'] ?? oldItem.amount,
      noteTemp: updateJsonRequestBody['note'] ?? oldItem.note,
      transactionAtTemp: updateJsonRequestBody['transaction_at'] != null
          ? DateTime.parse(updateJsonRequestBody['transaction_at'])
          : oldItem.transactionAt,
      cateTemp: newCate,
      newImageBytes: imageFile?.bytes,
    );

    /// Just update if any data change
    bool isDeleteImg = updateJsonRequestBody['delete_image'] ?? false;

    if (!hasChanged && !isDeleteImg) return Right(oldItem);

    return await _repository.updateTransaction(
      updateJsonRequestBody: updateJsonRequestBody,
      oldItem: oldItem,
      newCate: newCate,
      isDeleteImg: isDeleteImg,
      imageFile: imageFile,
    );
  }
}
