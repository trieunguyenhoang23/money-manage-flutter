import 'dart:async';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:money_manage_flutter/export/core.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import '../../../export/core_external.dart';
import '../../../export/ui_external.dart';
import 'i_socket_client_service.dart';

@LazySingleton(as: ISocketClientService)
class SocketClientServiceImpl implements ISocketClientService {
  final OnlineActionGuard _onlineActionGuard;
  final FlutterSecureStorage _secureStorage;

  SocketClientServiceImpl(this._onlineActionGuard, this._secureStorage);

  IO.Socket? _socket;
  final _syncEventController = StreamController<String>.broadcast();

  Stream<String> get syncEvents => _syncEventController.stream;

  @override
  Future<void> init() async {
    if (_socket?.connected == true) return;

    await _onlineActionGuard.run((currentUserId, isConnectInternet) async {
      _socket = IO.io(APIConstants.bareUrl, <String, dynamic>{
        'transports': ['websocket'],
        'autoConnect': true,
        'forceNew': true,
      });

      _socket?.onConnect((_) async {
        final sId = _socket?.id;
        debugPrint('Connected to Socket Server: $sId');

        if (sId != null) {
          await _secureStorage.write(key: 'last_socket_id', value: sId);
        }
        _socket?.emit('store-user', currentUserId);
      });

      _socket?.onConnectError(
        (data) => debugPrint('Socket Connect Error: $data'),
      );

      _socket?.on('sync-completed', (data) {
        debugPrint('Server notifies sync: $data');
        _handleServerNotify(data['type']);
      });
    });
  }

  void _handleServerNotify(String type) async {
    try {
      _syncEventController.add(type);
    } catch (e) {
      debugPrint("Sync Error via Socket: $e");
    }
  }

  @override
  @disposeMethod
  void dispose() {
    _socket?.disconnect();
    _socket?.dispose();
    debugPrint('SocketClientServiceImpl disposed');
  }

  @override
  String? get socketId => _socket?.id;
}
