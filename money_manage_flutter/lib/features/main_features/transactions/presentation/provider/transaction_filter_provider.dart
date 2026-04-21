import 'package:hooks_riverpod/legacy.dart';
import '../../data/datasource/sync/transaction_sync_key.dart';

final transactionFilterProvider = StateProvider<TransactionSyncKey>((ref) {
  final now = DateTime.now();
  return TransactionSyncKey(
    year: now.year,
    month: now.month,
    type: null, // All is default
  );
});
