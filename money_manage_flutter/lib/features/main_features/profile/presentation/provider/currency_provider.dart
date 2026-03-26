import 'dart:async';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:money_manage_flutter/core/di/injection.dart';

import '../../../../../core/constant/string_constant.dart';
import '../../data/datasource/local/user_local_datasource.dart';
import '../../domain/usecase/update_currency_usecase.dart';

class CurrencyProvider extends AsyncNotifier<String> {
  @override
  FutureOr<String> build() async {
    final user = await getIt<UserLocalDatasource>().getCurrentUser();
    String currency =
        getIt<SharedPreferences>().getString(currencyKey) ?? 'VND';

    if (user != null) {
      return user.currency ?? currency;
    }

    return currency;
  }

  Future<void> updateCurrency(
    String newCurrency, {
    bool isSyncData = true,
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      if (isSyncData) {
        final success = await getIt<UpdateCurrencyUseCase>().execute(
          newCurrency,
        );

        if (!success) {
          throw Exception("Error");
        }
      }
      return newCurrency;
    });
  }
}

final currencyProvider = AsyncNotifierProvider<CurrencyProvider, String>(() {
  return CurrencyProvider();
});
