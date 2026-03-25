import 'package:hooks_riverpod/legacy.dart';
import 'package:money_manage_flutter/export/shared.dart';
import '../../../../../core/di/injection.dart';
import '../../../../../export/ui_external.dart';
import '../../data/model/local/transaction_local_model.dart';
import '../../domain/usecase/loading_transaction_usecase.dart';
import 'base_transaction_provider.dart';

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

/// Provider Temp: can be transactionCreateProvider or transactionUpdateProvider
final currentTransactionProvider =
    Provider<
      StateNotifierProvider<
        BaseTransactionNotifier<BaseTransactionState>,
        BaseTransactionState
      >
    >((ref) {
      throw UnimplementedError();
    });
