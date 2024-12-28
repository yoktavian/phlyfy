import 'package:entity_api/api.dart';

abstract class OniPost {
  Future<ApiResult> post({
    required String path,
    dynamic data,
    Map<String, dynamic>? queryParameters,
  });
}
