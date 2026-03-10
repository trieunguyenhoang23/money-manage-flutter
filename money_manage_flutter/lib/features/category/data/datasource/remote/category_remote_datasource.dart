import 'package:injectable/injectable.dart';
import 'package:money_manage_flutter/export/infrastructure.dart';

@LazySingleton()
class CategoryRemoteDatasource {
  DioService _dioService;

  CategoryRemoteDatasource(this._dioService);
}
