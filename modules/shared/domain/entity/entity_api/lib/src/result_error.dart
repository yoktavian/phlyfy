import '../src/result.dart';

class ApiResultError extends ApiResult implements Exception {
  final String message;

  ApiResultError(this.message);
}