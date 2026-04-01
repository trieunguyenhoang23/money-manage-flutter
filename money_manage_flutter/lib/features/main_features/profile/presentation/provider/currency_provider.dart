import 'dart:async';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:money_manage_flutter/core/di/injection.dart';
import '../../domain/repositories/user_repository.dart';
import '../../domain/usecase/update_currency_usecase.dart';

class CurrencyProvider extends AsyncNotifier<String> {
  @override
  FutureOr<String> build() async {
    String currency = await getIt<UserRepository>().getCurrency();

    return currency;
  }

  Future<void> updateCurrency(
    String newCurrency, {
    bool isSyncData = true,
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      if (isSyncData) {
        await getIt<UpdateCurrencyUseCase>().execute(newCurrency);
      }
      return newCurrency;
    });
  }
}

final currencyProvider = AsyncNotifierProvider<CurrencyProvider, String>(() {
  return CurrencyProvider();
});
