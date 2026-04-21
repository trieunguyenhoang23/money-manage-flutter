import 'package:hooks_riverpod/legacy.dart';

import '../../../../../core/di/injection.dart';
import '../../../../../core/enum/transaction_type.dart';
import '../../../../../export/ui_external.dart';
import '../../../../category/data/model/local/category_local_model.dart';
import '../../domain/usecase/get_popular_category_usecase.dart';

/// Use for pick category by Type
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

  void addCategoryIfNeeded(CategoryLocalModel category) {
    if (state.isLoading) return;
    final current = state.value ?? [];
    if (!current.contains(category)) {
      final exists = current.any((e) {
        return e.idServer == category.idServer;
      });

      if (exists) return;

      state = AsyncValue.data([category, ...current]);
    }
  }
}

/// List category showcase
final quickSelectCategoryProvider =
    StateNotifierProvider.family<
      QuickSelectNotifier,
      AsyncValue<List<CategoryLocalModel>>,
      TransactionType
    >((ref, type) {
      final useCase = ref.watch(getPopularCategoryUseCaseProvider);
      return QuickSelectNotifier(useCase, type);
    });

/// Use case Provider
final getPopularCategoryUseCaseProvider = Provider(
  (ref) => getIt<GetPopularCategoryUseCase>(),
);
