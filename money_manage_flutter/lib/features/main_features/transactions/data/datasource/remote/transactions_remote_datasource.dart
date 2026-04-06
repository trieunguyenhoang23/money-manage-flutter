import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:injectable/injectable.dart';
import 'package:money_manage_flutter/export/infrastructure.dart';
import 'package:money_manage_flutter/export/core.dart';

@LazySingleton()
class TransactionsRemoteDatasource {
  final DioService _dioService;

  TransactionsRemoteDatasource(this._dioService);

  Future<ApiResult> loadTransByMonth(
    int page,
    int limit_count,
    int month,
    int year, {
    String? type,
  }) async {
    final response = await _dioService.getNoCache(
      TransactionAPI.get_load_by_month,
      queryParameters: {
        'page': page,
        'limit_count': limit_count,
        'month': month,
        'year': year,
        if (type != null) 'type': type,
      },
    );

    return response;
  }

  Future<ApiResult> loadTransByPage(int page, int limit_count) async {
    final response = await _dioService.getNoCache(
      TransactionAPI.get_load_by_page,
      queryParameters: {'page': page, 'limit_count': limit_count},
    );

    return response;
  }

  Future<ApiResult> uploadTransaction(
    Map<String, dynamic> jsonBodyRequest, {
    Uint8List? image_description_buffer,
    String? image_name,
  }) async {
    FormData formData = FormData.fromMap(jsonBodyRequest);

    if (image_description_buffer != null && image_name != null) {
      formData.files.add(
        MapEntryUtils.getMapEntry(
          'image_bytes',
          image_description_buffer,
          image_name,
        ),
      );
    }

    final response = await _dioService.post(
      TransactionAPI.post_transactions,
      formData,
    );

    return response;
  }

  Future<ApiResult> updateTransaction(
    Map<String, dynamic> jsonBodyRequest, {
    required String id,
    Uint8List? image_description_buffer,
    String? image_name,
  }) async {
    FormData formData = FormData.fromMap(jsonBodyRequest);

    if (image_description_buffer != null && image_name != null) {
      formData.files.add(
        MapEntryUtils.getMapEntry(
          'image_bytes',
          image_description_buffer,
          image_name,
        ),
      );
    }

    final response = await _dioService.patch(
      '${TransactionAPI.patch_transactions}/$id',
      formData,
    );

    return response;
  }

  Future<ApiResult> removeTransaction(String id) async {
    return await _dioService.delete(
      '${TransactionAPI.delete_transactions}/$id',
    );
  }
}
