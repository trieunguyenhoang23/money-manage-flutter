import 'package:money_manage_flutter/export/ui_external.dart';
import '../../state/connection_state.dart';

class ConnectionWifiWidget extends ConsumerWidget {
  const ConnectionWifiWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final connectivityAsync = ref.watch(connectivityStreamProvider);

    return connectivityAsync.when(
      data: (isOnline) => isOnline
          ? const SizedBox()
          : const Icon(Icons.wifi_off_sharp, color: Colors.red),
      error: (e, st) => Text("Error checking internet $e"),
      loading: () => const SizedBox(),
    );
  }
}
