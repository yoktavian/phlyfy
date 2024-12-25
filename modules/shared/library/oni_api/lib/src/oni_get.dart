import 'package:entity/entity.dart';

abstract class OniGet {
  Future<OniResult> get({
    required String path,
    dynamic data,
    Map<String, dynamic>? queryParameters,
  });
}
