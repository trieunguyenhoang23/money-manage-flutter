import 'package:hooks_riverpod/legacy.dart';
import 'package:money_manage_flutter/export/shared.dart';
import '../../../../../core/di/injection.dart';
import '../../data/model/local/transaction_local_model.dart';
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
