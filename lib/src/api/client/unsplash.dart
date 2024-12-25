import 'package:oni_api/oni_api.dart';

class UnsplashClient extends OniApi {
  UnsplashClient({
    required super.baseUrl,
    required OniApiInterceptor interceptor,
  }) : super(
          interceptors: [
            interceptor,
          ],
        );
}
