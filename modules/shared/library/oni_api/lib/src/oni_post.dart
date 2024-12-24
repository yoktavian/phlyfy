import 'package:entity_api/entity_api.dart';

abstract class OniPost {
  Future<OniResult<dynamic>> post({
    required String path,
    dynamic data,
    Map<String, dynamic>? queryParameters,
  });
}
