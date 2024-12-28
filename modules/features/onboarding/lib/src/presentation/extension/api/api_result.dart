import 'package:entity_api/api.dart';

extension ApiResultExt on ApiResult {
  void when({
    required Function(dynamic json) onSuccess,
    required Function(ApiResultError error) onError,
  }) {
    final result = this;

    if (result is ApiResultSuccess) {
      onSuccess(result.data);
    } else {
      onError(this as ApiResultError);
    }
  }
}
