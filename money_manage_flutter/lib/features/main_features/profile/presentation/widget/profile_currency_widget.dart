import 'package:currency_picker/currency_picker.dart';
import 'package:money_manage_flutter/core/constant/color_constant.dart';
import 'package:money_manage_flutter/core/extension/context_extension.dart';
import 'package:money_manage_flutter/export/shared.dart';
import 'package:money_manage_flutter/export/ui_external.dart';
import '../provider/currency_provider.dart';

class ProfileCurrencyWidget extends ConsumerWidget {
  const ProfileCurrencyWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return LayoutBuilder(
      builder: (context, cc) {
        return InkWell(
          onTap: () {
            showCurrencyPicker(
              context: context,
              showFlag: true,
              showSearchField: true,
              showCurrencyName: true,
              showCurrencyCode: true,
              favorite: ['eur'],
              onSelect: (Currency currency) async {
                await ref
                    .read(currencyProvider.notifier)
                    .updateCurrency(currency.code);
              },
            );
          },
          child: Container(
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Colors.black12, width: 0.5),
              ),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.currency_exchange,
                  color: ColorConstant.warning700,
                ),
                SizedBox(width: 0.05 * cc.maxWidth),
                TextGGStyle(context.lang.profile_currency, 0.3 * cc.maxHeight),
                const Spacer(),
                CurrencyWidget(textSize: 0.3 * cc.maxHeight),
              ],
            ),
          ),
        );
      },
    );
  }
}
