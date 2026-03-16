import 'package:money_manage_flutter/export/ui_external.dart';
import '../../data/model/local/transaction_local_model.dart';

class EditTransactionScreen extends StatefulWidget {
  final TransactionLocalModel item;

  const EditTransactionScreen({super.key, required this.item});

  @override
  State<EditTransactionScreen> createState() => _EditTransactionScreenState();
}

class _EditTransactionScreenState extends State<EditTransactionScreen> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
