abstract class BackgroundTask {
  String get taskName;
  Future<bool> run(Map<String, dynamic>? inputData);
}