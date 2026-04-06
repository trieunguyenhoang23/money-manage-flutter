class SyncDeltaModel {
  final List<dynamic> data;
  final bool hasMore;
  final String serverTime;

  SyncDeltaModel({
    required this.data,
    required this.hasMore,
    required this.serverTime,
  });

  factory SyncDeltaModel.fromJson(Map<String, dynamic> json) {
    return SyncDeltaModel(
      data: json['data'] ?? [],
      hasMore: json['hasMore'] ?? false,
      serverTime: json['serverTime'] ?? '',
    );
  }
}
