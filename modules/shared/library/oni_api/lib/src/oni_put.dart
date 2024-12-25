import 'package:entity_api/api.dart';

abstract class OniPut {
  Future<ApiResult> put({
    required String path,
    dynamic data,
    Map<String, dynamic>? queryParameters,
  });
}
