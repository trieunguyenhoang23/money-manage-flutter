import '../../../../../../core/enum/transaction_type.dart';
import 'package:equatable/equatable.dart';

class TransactionSyncKey extends Equatable {
  final int year;
  final int month;
  final TransactionType? type;

  const TransactionSyncKey({
    required this.year,
    required this.month,
    this.type,
  });

  @override
  List<Object?> get props => [year, month, type];

  String toKey(String prefix) =>
      '${prefix}_${year}_${month}_${type?.name ?? 'all'}';

  TransactionSyncKey copyWith({int? year, int? month, TransactionType? type}) {
    return TransactionSyncKey(
      year: year ?? this.year,
      month: month ?? this.month,
      type: type,
    );
  }
}
