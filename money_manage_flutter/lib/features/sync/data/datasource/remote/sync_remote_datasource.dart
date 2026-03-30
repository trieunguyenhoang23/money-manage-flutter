import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:money_manage_flutter/export/infrastructure.dart';
import 'package:flutter/services.dart';
import '../../../../../core/constant/api_constants.dart';
import '../../../../../core/network/api_result.dart';
import '../../../../../core/utils/map_entry_utils.dart';

@LazySingleton()
class SyncRemoteDatasource {
  final DioService _dioService;

  SyncRemoteDatasource(this._dioService);

  Future<ApiResult> syncCategoryData(Map<String, dynamic> arrayJsonBody) async {
    final response = await _dioService.post(
      SyncAPI.post_sync_batch_category,
      arrayJsonBody,
    );

    return response;
  }

  Future<ApiResult> syncTransaction(
    Map<String, dynamic> arrayJsonBody, {
    List<Uint8List>? image_description_buffer_list,
    List<String>? image_name_list,
  }) async {
    FormData formData = FormData.fromMap(arrayJsonBody);

    if (image_description_buffer_list != null && image_name_list != null) {
      for (int i = 0; i < image_description_buffer_list.length; i++) {
        formData.files.add(
          MapEntryUtils.getMapEntry(
            'image_bytes',
            image_description_buffer_list[i],
            image_name_list[i],
          ),
        );
      }
    }

    final response = await _dioService.post(
      SyncAPI.post_sync_batch_transaction,
      formData,
    );

    return response;
  }
}
