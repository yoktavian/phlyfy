import 'package:entity_api/api.dart';

// An extension for API result. Just to make easier when we got result
// from API, we can just call response.when then we can get the json result
// directly onSuccess and ApiResultError onError.
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
