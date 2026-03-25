import 'package:dartz/dartz.dart';
import 'package:hooks_riverpod/legacy.dart';
import '../../../../../core/di/injection.dart';
import '../../../../../core/error/failure.dart';
import '../../../../../export/ui_external.dart';
import '../../../../../infrastructure/file/models/file_picked.dart';
import '../../../../category/data/model/local/category_local_model.dart';
import '../../data/model/local/transaction_local_model.dart';
import '../../domain/usecase/update_transaction_usecase.dart';
import 'base_transaction_provider.dart';
import 'quick_select_cate_provider.dart';

/// Manage transaction update
class TransactionUpdateState implements BaseTransactionState {
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
  dynamic imageOriginal;

  TransactionUpdateState({
    this.amount = 0,
    this.note = '',
    this.category,
    required this.transactionAt,
    this.imageFile,
    this.imageOriginal,
  });

  TransactionUpdateState copyWith({
    double? amount,
    String? note,
    CategoryLocalModel? category,
    DateTime? transactionAt,
    FilePicked? imageFile,
    dynamic imageOriginal,
    bool isForeRemoveImageOriginal = false,
  }) {
    return TransactionUpdateState(
      amount: amount ?? this.amount,
      note: note ?? this.note,
      category: category ?? this.category,
      transactionAt: transactionAt ?? this.transactionAt,
      imageFile: imageFile ?? this.imageFile,
      imageOriginal: isForeRemoveImageOriginal
          ? null
          : imageOriginal ?? this.imageOriginal,
    );
  }
}

class TransactionUpdateNotifier
    extends BaseTransactionNotifier<TransactionUpdateState> {
  final TransactionLocalModel item;
  final Ref ref;

  TransactionUpdateNotifier(this.item, this.ref)
    : super(
        TransactionUpdateState(
          amount: item.amount,
          note: item.note,
          category: item.category.value,
          transactionAt: item.transactionAt,
          imageOriginal: item.imageUrl ?? item.imageBytes,
        ),
      ) {
    _initQuickSelect();
  }

  void _initQuickSelect() {
    final cate = item.category.value;
    if (cate != null && cate.type != null) {
      Future.microtask(() {
        ref
            .read(quickSelectCategoryProvider(cate.type!).notifier)
            .addCategoryIfNeeded(cate);
      });
    }
  }

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
      state = state.copyWith(imageFile: img, isForeRemoveImageOriginal: true);

  @override
  Future<Either<Failure, TransactionLocalModel>?> submit() async {
    if (state.category == null) {
      return Left(ValidationFailure(ValidationCode.notPickCategory));
    }
    Map<String, dynamic> updateJson = item.toUpdateJson(
      amountTemp: state.amount,
      noteTemp: state.note,
      cateTemp: state.category!,
      transactionAtTemp: state.transactionAt,
    );

    /// Check if user want to delete image
    bool isDeleteImg = state.imageOriginal == null && state.imageFile == null;
    if (isDeleteImg) {
      updateJson['delete_image'] = true;
    }

    /// Just update if any data change
    if (updateJson.isNotEmpty) {
      return await getIt<UpdateTransactionUseCase>().execute(
        updateJsonRequestBody: updateJson,
        imageFile: state.imageFile,
        oldItem: item,
        newCate: state.category!,
      );
    }

    return Left(ValidationFailure(ValidationCode.notChangeFormEdit));
  }
}

final transactionUpdateProvider = StateNotifierProvider.family
    .autoDispose<
      TransactionUpdateNotifier,
      TransactionUpdateState,
      TransactionLocalModel
    >((ref, item) => TransactionUpdateNotifier(item, ref));
