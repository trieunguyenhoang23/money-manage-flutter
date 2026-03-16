import 'package:injectable/injectable.dart';
import 'package:money_manage_flutter/export/infrastructure.dart';

@LazySingleton()
class TransactionsRemoteDatasource {
  final DioService _dioService;

  TransactionsRemoteDatasource(this._dioService);
}
