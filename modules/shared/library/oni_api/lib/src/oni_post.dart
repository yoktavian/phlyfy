import 'package:entity/entity.dart';

abstract class OniPost {
  Future<OniResult> post({
    required String path,
    dynamic data,
    Map<String, dynamic>? queryParameters,
  });
}
