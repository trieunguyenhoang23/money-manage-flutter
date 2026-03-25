import 'package:dartz/dartz.dart';
import 'package:hooks_riverpod/legacy.dart';
import '../../../../../core/error/failure.dart';
import '../../../../../infrastructure/file/models/file_picked.dart';
import '../../../../category/data/model/local/category_local_model.dart';
import '../../data/model/local/transaction_local_model.dart';

abstract class BaseTransactionState {
  double get amount;

  String get note;

  CategoryLocalModel? get category;

  DateTime get transactionAt;

  FilePicked? get imageFile;

  /// url or buffer
  dynamic get imageOriginal;
}

abstract class BaseTransactionNotifier<T extends BaseTransactionState>
    extends StateNotifier<T> {
  BaseTransactionNotifier(super.state);

  void updateAmount(double value);

  void updateNote(String note);

  void updateCategory(CategoryLocalModel? cat);

  void updateDate(DateTime date);

  void updateImage(FilePicked? img);

  Future<Either<Failure, TransactionLocalModel>?> submit();
}
