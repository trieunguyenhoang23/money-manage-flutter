import 'dart:convert';
import 'package:injectable/injectable.dart';
import 'package:flutter/services.dart';
import '../../../../main_features/transactions/data/model/local/transaction_local_model.dart';

@lazySingleton
class TransactionPushService {
  ({Map<String, dynamic> manifest, List<Uint8List> buffers, List<String> names})
  prepareSyncPayload(List<TransactionLocalModel> transactions, String userId) {
    final List<Uint8List> imageBuffers = [];
    final List<Map<String, dynamic>> transactionsJson = [];
    final List<String> imageNames = [];
    int currentFileIndex = 0;

    for (var t in transactions) {
      final json = t.toJson();

      if (t.imageBytes != null && t.imageBytes!.isNotEmpty) {
        // Add buffer
        imageBuffers.add(Uint8List.fromList(t.imageBytes!));

        // Add image name
        imageNames.add(_generateImageName(userId));

        // Mark index of transaction have image
        json['fileIndex'] = currentFileIndex;
        currentFileIndex++;
      }

      transactionsJson.add(json);
    }

    return (
      manifest: {'transactions': jsonEncode(transactionsJson)},
      buffers: imageBuffers,
      names: imageNames,
    );
  }

  String _generateImageName(String userId) {
    final timestamp = DateTime.now().microsecondsSinceEpoch;
    return "${userId}_$timestamp.jpg";
  }
}
