import 'package:hooks_riverpod/legacy.dart';
import 'package:money_manage_flutter/export/shared.dart';
import '../../../../core/di/injection.dart';
import '../../data/model/local/category_local_model.dart';
import '../../domain/usecase/loading_category_usecase.dart';

final loadingCategoryProvider =
    StateNotifierProvider<
      PullToRefreshNotifier<CategoryLocalModel>,
      PullToRefreshState<CategoryLocalModel>
    >((ref) {
      return PullToRefreshNotifier(
        fetchPage: (page) async {
          return await getIt<LoadingCategoryUseCase>().execute(page);
        },
      );
    });


