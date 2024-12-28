import '../src/result.dart';

class ApiResultSuccess<T> extends ApiResult {
  final T data;

  ApiResultSuccess(this.data);
}
