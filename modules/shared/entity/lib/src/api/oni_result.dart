import 'oni_exception.dart';

class OniResult<T> {
  final T result;

  OniResult(this.result);
}

extension ApiResultExtesion on OniResult {
  void when<T>({
    required Function(T) success,
    required Function(OniException) error,
  }) {
    if (result is OniException) {
      error.call(result);
    } else {
      success.call(result as T);
    }
  }
}
