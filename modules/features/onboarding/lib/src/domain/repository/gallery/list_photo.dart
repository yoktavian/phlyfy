import 'package:entity_api/api.dart';
import 'package:onboarding/src/domain/entity/request/photo.dart';

abstract class ListPhoto {
  static const photoPath = '/search/photos';

  Future<ApiResult> listPhoto(ListPhotoRequest request);
}
