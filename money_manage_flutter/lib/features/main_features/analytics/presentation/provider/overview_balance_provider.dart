import 'dart:async';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:money_manage_flutter/core/di/injection.dart';
import 'package:money_manage_flutter/core/utils/toast_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/usecase/get_overview_balance_usecase.dart';

class OverviewBalanceState {
  final double income;
  final double expense;
  final double balance;
  final bool isShowData;

  OverviewBalanceState({
    required this.income,
    required this.expense,
    required this.balance,
    required this.isShowData,
  });

  OverviewBalanceState copyWith({
    double? income,
    double? expense,
    double? balance,
    bool? isShowData,
  }) {
    return OverviewBalanceState(
      income: income ?? this.income,
      expense: expense ?? this.expense,
      balance: balance ?? this.balance,
      isShowData: isShowData ?? this.isShowData,
    );
  }
}

class OverviewBalanceNotifier extends AsyncNotifier<OverviewBalanceState> {
  static const String isShowDataKey = 'is_show_data_key';
  final prefs = getIt<SharedPreferences>();

  @override
  FutureOr<OverviewBalanceState> build() async {
    final financialData = await getIt<GetOverviewBalanceUseCase>().execute();
    bool isShowDataPrefs = prefs.getBool(isShowDataKey) ?? true;

    return financialData.fold(
      (left) {
        ToastUtils.showToastFailed(left.message);
        return OverviewBalanceState(
          balance: 0,
          income: 0,
          expense: 0,
          isShowData: isShowDataPrefs,
        );
      },
      (data) {
        double balance = data.value1 + data.value2 - data.value3;

        return OverviewBalanceState(
          balance: balance,
          income: data.value2,
          expense: data.value3,
          isShowData: isShowDataPrefs,
        );
      },
    );
  }

  void updateShowData(bool status) {
    prefs.setBool(isShowDataKey, status);
    update((data) => data.copyWith(isShowData: status));
  }
}

final overviewBalanceProvider =
    AsyncNotifierProvider<OverviewBalanceNotifier, OverviewBalanceState>(() {
      return OverviewBalanceNotifier();
    });

final balanceProvider = Provider<double>((ref) {
  final asyncState = ref.watch(overviewBalanceProvider);
  return asyncState.value?.balance ?? 0;
});

final incomeProvider = Provider<double>((ref) {
  final asyncState = ref.watch(overviewBalanceProvider);
  return asyncState.value?.income ?? 0;
});

final expenseProvider = Provider<double>((ref) {
  final asyncState = ref.watch(overviewBalanceProvider);
  return asyncState.value?.expense ?? 0;
});
