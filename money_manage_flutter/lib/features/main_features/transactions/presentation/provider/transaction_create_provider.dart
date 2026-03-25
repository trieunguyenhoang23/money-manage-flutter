import 'package:dartz/dartz.dart';
import 'package:hooks_riverpod/legacy.dart';
import '../../../../../core/di/injection.dart';
import '../../../../../core/error/failure.dart';
import '../../../../../export/ui_external.dart';
import '../../../../../infrastructure/file/models/file_picked.dart';
import '../../../../category/data/model/local/category_local_model.dart';
import '../../data/model/local/transaction_local_model.dart';
import '../../domain/usecase/create_transaction_usecase.dart';
import 'base_transaction_provider.dart';

/// Manage transaction create
class TransactionCreateState implements BaseTransactionState {
  @override
  final double amount;
  @override
  final String note;
  @override
  final CategoryLocalModel? category;
  @override
  final DateTime transactionAt;
  @override
  final FilePicked? imageFile;
  @override
  final dynamic imageOriginal;

  TransactionCreateState({
    this.amount = 0,
    this.note = '',
    this.category,
    required this.transactionAt,
    this.imageFile,
    this.imageOriginal,
  });

  TransactionCreateState copyWith({
    double? amount,
    String? note,
    CategoryLocalModel? category,
    DateTime? transactionAt,
    FilePicked? imageFile,
    String? imageOriginal,
  }) {
    return TransactionCreateState(
      amount: amount ?? this.amount,
      note: note ?? this.note,
      category: category ?? this.category,
      transactionAt: transactionAt ?? this.transactionAt,
      imageFile: imageFile,
      imageOriginal: imageOriginal,
    );
  }
}

class TransactionCreateNotifier
    extends BaseTransactionNotifier<TransactionCreateState> {
  final Ref ref;

  TransactionCreateNotifier(this.ref)
    : super(TransactionCreateState(transactionAt: DateTime.now()));

  @override
  void updateAmount(double value) => state = state.copyWith(amount: value);

  @override
  void updateNote(String note) => state = state.copyWith(note: note);

  @override
  void updateCategory(CategoryLocalModel? cat) =>
      state = state.copyWith(category: cat);

  @override
  void updateDate(DateTime date) => state = state.copyWith(transactionAt: date);

  @override
  void updateImage(FilePicked? img) =>
      state = state.copyWith(imageFile: img, imageOriginal: null);

  @override
  Future<Either<Failure, TransactionLocalModel>?> submit() async {
    if (state.category == null) return null;

    final result = await getIt<CreateTransactionUseCase>().execute(
      amount: state.amount,
      note: state.note,
      transactionAt: state.transactionAt,
      category: state.category!,
      imageFile: state.imageFile,
    );

    if (result is Right) {
      ref.invalidateSelf();
    }

    return result;
  }
}

final transactionCreateProvider =
    StateNotifierProvider<TransactionCreateNotifier, TransactionCreateState>(
      (ref) => TransactionCreateNotifier(ref),
    );
