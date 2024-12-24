import 'package:entity_api/entity_api.dart';

abstract class OniGet {
  Future<OniResult<dynamic>> get({
    required String path,
    dynamic data,
    Map<String, dynamic>? queryParameters,
  });
}
