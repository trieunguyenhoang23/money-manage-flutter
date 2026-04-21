abstract class ISocketClientService {
  String? get socketId;

  Future<void> init();

  void dispose() {}
}
