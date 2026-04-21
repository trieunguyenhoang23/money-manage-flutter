enum SyncType {
  category,
  transaction,
  all;

  static SyncType fromDynamic(dynamic value) {
    if (value is SyncType) return value;

    if (value is String) {
      return SyncType.values.firstWhere(
        (e) => e.name.toUpperCase() == value.toUpperCase(),
        orElse: () => SyncType.all,
      );
    }

    return SyncType.all;
  }
}

class SyncBatchProgress {
  final SyncType type;
  final int current;
  final int total;
  final double overallProgress;

  SyncBatchProgress({
    required this.type,
    required this.current,
    required this.total,
    required this.overallProgress,
  });
}
