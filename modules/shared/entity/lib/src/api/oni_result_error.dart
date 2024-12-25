import '/entity.dart';

class OniResultError extends OniResult implements Exception {
  final String message;

  OniResultError(this.message);
}