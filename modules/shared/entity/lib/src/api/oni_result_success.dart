import '/entity.dart';

class OniResultSuccess<T> extends OniResult {
  final T data;

  OniResultSuccess(this.data);
}