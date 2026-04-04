class TransactionSyncProgress {
  final int lastPage;
  final bool hasReachedEnd;

  const TransactionSyncProgress({
    required this.lastPage,
    required this.hasReachedEnd,
  });

  int get nextPage => lastPage + 1;
}
