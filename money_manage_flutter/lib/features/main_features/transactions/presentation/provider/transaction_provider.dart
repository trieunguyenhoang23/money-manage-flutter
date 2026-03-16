import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:hooks_riverpod/legacy.dart';
import 'package:money_manage_flutter/core/enum/transaction_type.dart';
import 'package:money_manage_flutter/export/shared.dart';
import '../../../../../core/di/injection.dart';
import '../../../../category/data/model/local/category_local_model.dart';
import '../../data/model/local/transaction_local_model.dart';
import '../../domain/usecase/get_popular_category_usecase.dart';
import '../../domain/usecase/loading_transaction_usecase.dart';

final loadingTransactionProvider =
    StateNotifierProvider<
      PullToRefreshNotifier<TransactionLocalModel>,
      PullToRefreshState<TransactionLocalModel>
    >((ref) {
      return PullToRefreshNotifier(
        fetchPage: (page) async {
          return await getIt<LoadingTransactionUseCase>().execute(page);
        },
      );
    });

/// Create Transaction
class QuickSelectNotifier
    extends StateNotifier<AsyncValue<List<CategoryLocalModel>>> {
  final TransactionType type;

  QuickSelectNotifier(this.type) : super(const AsyncValue.loading()) {
    _init();
  }

  Future<void> _init() async {
    try {
      final data = await getIt<GetPopularCategoryUseCase>().execute(type, 5);
      state = AsyncValue.data(data);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  void addCategory(CategoryLocalModel category) {
    state.whenData((currentList) {
      if (currentList.any((e) => e.idServer == category.idServer)) return;

      state = AsyncValue.data([category, ...currentList]);
    });
  }
}

final quickSelectCategoryProvider = StateNotifierProvider.family
    .autoDispose<
      QuickSelectNotifier,
      AsyncValue<List<CategoryLocalModel>>,
      TransactionType
    >((ref, type) => QuickSelectNotifier(type));

final selectedCategoryProvider = StateProvider<CategoryLocalModel?>(
  (ref) => null,
);
