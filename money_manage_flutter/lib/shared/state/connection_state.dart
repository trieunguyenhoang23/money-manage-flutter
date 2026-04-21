import 'package:connectivity_plus/connectivity_plus.dart';
import '../../core/di/injection.dart';
import '../../export/ui_external.dart';
import '../../infrastructure/network/dio/network_info.dart';

final networkInfoProvider = Provider<NetworkInfo>(
  (ref) => getIt<NetworkInfo>(),
);

final connectivityStreamProvider = StreamProvider<bool>((ref) {
  final networkInfo = ref.watch(networkInfoProvider);

  return networkInfo.onConnectivityChanged.map((results) {
    bool isConnect = !results.contains(ConnectivityResult.none);
    return isConnect;
  });
});
