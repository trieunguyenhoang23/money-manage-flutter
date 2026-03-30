enum SyncType { category, reminder, transaction }

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
