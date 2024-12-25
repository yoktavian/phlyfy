import 'package:oni_api/oni_api.dart';

class UnsplashInterceptor extends OniApiInterceptor {
  UnsplashInterceptor({required clientID})
      : super(
          headers: {
            'Authorization': clientID,
          },
        );
}
