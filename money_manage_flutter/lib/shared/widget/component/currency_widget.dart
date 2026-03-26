import 'package:money_manage_flutter/export/ui_external.dart';
import '../../../features/main_features/profile/presentation/provider/currency_provider.dart';
import '../../style/text_gg_style.dart';
import 'loading_widget.dart';

class CurrencyWidget extends ConsumerWidget {
  final double textSize;

  const CurrencyWidget({super.key, required this.textSize});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currencyState = ref.watch(currencyProvider);
    return currencyState.when(
      data: (currency) {
        return TextGGStyle(currency, textSize, fontWeight: FontWeight.bold);
      },
      loading: () => const LoadingWidget(),
      error: (err, stack) => Text('Error: $err'),
    );
  }
}
