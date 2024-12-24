import 'package:dio/dio.dart';

abstract class OniApiInterceptor extends Interceptor {
  final Map<String, dynamic>? headers;
  final Map<String, dynamic>? queryParams;

  OniApiInterceptor({this.headers, this.queryParams});

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.headers = headers;
    final queryParameters = queryParams;
    if (queryParameters != null) {
      options.queryParameters.addAll(queryParameters);
    }
    super.onRequest(options, handler);
  }
}
