import 'package:dartz/dartz.dart';
import 'package:hooks_riverpod/legacy.dart';
import '../../../../../core/di/injection.dart';
import '../../../../../core/enum/transaction_type.dart';
import '../../../../../core/error/failure.dart';
import '../../../../../export/ui_external.dart';
import '../../../../../infrastructure/file/models/file_picked.dart';
import '../../../../category/data/model/local/category_local_model.dart';
import '../../data/model/local/transaction_local_model.dart';
import '../../domain/usecase/create_transaction_usecase.dart';
import '../../domain/usecase/get_popular_category_usecase.dart';

/// Manage transaction form input
class TransactionFormState {
  final double amount;
  final String note;
  final CategoryLocalModel? category;
  final DateTime transactionAt;
  final FilePicked? image;

  TransactionFormState({
    this.amount = 0,
    this.note = '',
    this.category,
    required this.transactionAt,
    this.image,
  });

  TransactionFormState copyWith({
    double? amount,
    String? note,
    CategoryLocalModel? category,
    DateTime? transactionAt,
    FilePicked? image,
  }) {
    return TransactionFormState(
      amount: amount ?? this.amount,
      note: note ?? this.note,
      category: category ?? this.category,
      transactionAt: transactionAt ?? this.transactionAt,
      image: image,
    );
  }
}

class TransactionFormNotifier extends Notifier<TransactionFormState> {
  @override
  TransactionFormState build() {
    // Khởi tạo state mặc định tại đây
    return TransactionFormState(transactionAt: DateTime.now());
  }

  // Các phương thức cập nhật
  void updateAmount(double value) => state = state.copyWith(amount: value);

  void updateNote(String note) => state = state.copyWith(note: note);

  void updateCategory(CategoryLocalModel? cat) =>
      state = state.copyWith(category: cat);

  void updateDate(DateTime date) => state = state.copyWith(transactionAt: date);

  void updateImage(FilePicked? img) => state = state.copyWith(image: img);

  Future<Either<Failure, TransactionLocalModel>?> submit() async {
    if (state.category != null) {
      return await getIt<CreateTransactionUseCase>().execute(
        amount: state.amount,
        note: state.note,
        transactionAt: state.transactionAt,
        category: state.category!,
        image: state.image,
      );
    }

    return null;
  }
}

final transactionFormProvider =
    NotifierProvider.autoDispose<TransactionFormNotifier, TransactionFormState>(
      TransactionFormNotifier.new,
    );

/// Use for pick category by Type
final getPopularCategoryUseCaseProvider = Provider(
  (ref) => getIt<GetPopularCategoryUseCase>(),
);

class QuickSelectNotifier
    extends StateNotifier<AsyncValue<List<CategoryLocalModel>>> {
  final GetPopularCategoryUseCase _useCase;
  final TransactionType type;

  QuickSelectNotifier(this._useCase, this.type)
    : super(const AsyncValue.loading()) {
    _init();
  }

  Future<void> _init() async {
    // Use guard() to automatically activate try - catch
    state = await AsyncValue.guard(() => _useCase.execute(type, 5));
  }

  void addCategory(CategoryLocalModel category) {
    if (state.hasValue) {
      final currentList = state.value!;
      if (currentList.any((e) => e.idServer == category.idServer)) return;
      state = AsyncValue.data([category, ...currentList]);
    }
  }
}

final quickSelectCategoryProvider = StateNotifierProvider.family
    .autoDispose<
      QuickSelectNotifier,
      AsyncValue<List<CategoryLocalModel>>,
      TransactionType
    >((ref, type) {
      final useCase = ref.watch(getPopularCategoryUseCaseProvider);
      return QuickSelectNotifier(useCase, type);
    });

final selectedCategoryProvider = StateProvider<CategoryLocalModel?>(
  (ref) => null,
);
