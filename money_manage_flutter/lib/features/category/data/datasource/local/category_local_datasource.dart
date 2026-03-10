import 'package:isar_community/isar.dart';
import 'package:money_manage_flutter/export/core_external.dart';
import '../../../../../core/utils/size_app_utils.dart';
import '../../model/local/category_local_model.dart';

@LazySingleton()
class CategoryLocalDatasource {
  Isar _isar;

  CategoryLocalDatasource(this._isar);

  int limitCount = SizeAppUtils().isTablet ? 12 : 6;

  Future<List<CategoryLocalModel>> loadByPage(int page) async {
    return await _isar.categoryLocalModels
        .where()
        .offset(page * limitCount)
        .limit(limitCount)
        .findAll();
  }

  Future<void> save(CategoryLocalModel cate) async {
    await _isar.writeTxn(() async {
      _isar.categoryLocalModels.put(cate);
    });
  }
}
