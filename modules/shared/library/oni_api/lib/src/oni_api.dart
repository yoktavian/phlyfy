import 'package:dio/dio.dart';
import 'package:entity_api/api.dart';
import 'package:oni_api/src/interceptor/oni_api_interceptor.dart';
import 'package:oni_api/src/oni_get.dart';
import 'package:oni_api/src/oni_post.dart';
import 'package:oni_api/src/oni_put.dart';

/// Why we need to separate each api into some interfaces (ApiGet, ApiPut, ApiPost)?
/// as you now interface segregation concept hold only relevant method. if all of the contract
/// is not being used then for what this is being exposed? than this is useless. for example
/// we have class A, in class A we only use get request. so class A can depends directly on
/// ApiGet interface, so what we can do is just doing get request because we already separate
/// the post and put inside their own abstraction. but when we need to use 3 type of request
/// in one bloc/presenter, then we can use OniApi directly as the abstraction. so it depends
/// on the needs.
///
/// class A {
///   void doSomething() {
///     final ApiGet api = OniApi();
///     api.get(path: 'path');
///   }
/// }

abstract class OniApi implements OniGet, OniPut, OniPost {
  // client should not be know about dio.
  final Dio _dio;

  final String baseUrl;
  final List<OniApiInterceptor> interceptors;

  OniApi({
    required this.baseUrl,
    this.interceptors = const [],
  }) : _dio = Dio() {
    _setUpDio();
  }

  void _setUpDio() {
    _dio.options = BaseOptions(baseUrl: baseUrl);
    _dio.interceptors.addAll(interceptors);
  }

  @override
  Future<ApiResult> get({
    required String path,
    data,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final result = await _dio.get(path, queryParameters: queryParameters);
      return ApiResultSuccess(result.data);
    } catch (e) {
      const defaultMessage = "unknown error";
      if (e is DioException) {
        return ApiResultError(e.message ?? defaultMessage);
      }
      return ApiResultError(defaultMessage);
    }
  }

  @override
  Future<ApiResult> post({
    required String path,
    data,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final result = await _dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
      );
      return ApiResultSuccess(result.data);
    } catch (e) {
      const defaultMessage = "unknown error";
      if (e is DioException) {
        return ApiResultError(e.message ?? defaultMessage);
      }
      return ApiResultError(defaultMessage);
    }
  }

  @override
  Future<ApiResult> put({
    required String path,
    data,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final result = await _dio.put(
        path,
        data: data,
        queryParameters: queryParameters,
      );
      return ApiResultSuccess(result.data);
    } catch (e) {
      const defaultMessage = "unknown error";
      if (e is DioException) {
        return ApiResultError(e.message ?? defaultMessage);
      }
      return ApiResultError(defaultMessage);
    }
  }
}
