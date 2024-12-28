import 'package:entity_api/api.dart';
import 'package:onboarding/src/domain/entity/request/search_photo.dart';

abstract class SearchPhoto {
  static const searchPath = '/search/photos';

  Future<ApiResult> searchPhoto(SearchPhotoRequest request);
}
