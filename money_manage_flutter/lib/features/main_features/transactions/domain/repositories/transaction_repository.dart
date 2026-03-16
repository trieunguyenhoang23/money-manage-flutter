import 'package:money_manage_flutter/core/enum/transaction_type.dart';
import '../../../../category/data/model/local/category_local_model.dart';
import '../../data/model/local/transaction_local_model.dart';

abstract class TransactionRepository {
  Future<List<CategoryLocalModel>> getCategoryThroughTrans(
    TransactionType type,
    int range,
  );
}
