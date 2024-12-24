import 'package:entity_api/entity_api.dart';

abstract class OniPut {
  Future<OniResult<dynamic>> put({
    required String path,
    dynamic data,
    Map<String, dynamic>? queryParameters,
  });
}
