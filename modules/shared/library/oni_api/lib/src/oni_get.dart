import 'package:entity_api/api.dart';

abstract class OniGet {
  Future<ApiResult> get({
    required String path,
    dynamic data,
    Map<String, dynamic>? queryParameters,
  });
}
