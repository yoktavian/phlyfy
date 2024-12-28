import 'package:entity_api/api.dart';
import 'package:onboarding/src/domain/entity/request/photo.dart';
import 'package:onboarding/src/domain/entity/request/search_photo.dart';
import 'package:onboarding/src/domain/repository/photo/search_photo.dart';
import 'package:onboarding/src/domain/repository/repository.dart';

class PhotoRepository extends Photo {
  PhotoRepository({required super.client});

  @override
  Future<ApiResult> listPhoto(ListPhotoRequest request) async {
    return await client.get(
      path: ListPhoto.listPath,
      queryParameters: {
        'page': request.page,
        'per_page': request.perPage,
      },
    );
  }

  @override
  Future<ApiResult> searchPhoto(SearchPhotoRequest request) async {
    return await client.get(
      path: SearchPhoto.searchPath,
      queryParameters: {
        'query': request.query,
        'page': request.page,
        'per_page': request.perPage,
      },
    );
  }
}
