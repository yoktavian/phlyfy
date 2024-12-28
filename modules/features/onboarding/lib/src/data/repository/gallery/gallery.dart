import 'package:entity_api/api.dart';
import 'package:onboarding/src/domain/entity/request/photo.dart';
import 'package:onboarding/src/domain/repository/gallery/gallery.dart';
import 'package:onboarding/src/domain/repository/gallery/list_photo.dart';

class GalleryRepository extends Gallery {
  GalleryRepository({required super.client});

  @override
  Future<ApiResult> listPhoto(ListPhotoRequest request) async {
    return await client.get(
      path: ListPhoto.photoPath,
      queryParameters: {
        'query': request.query ?? '',
        'page': request.page,
        'per_page': request.perPage,
      },
    );
  }
}
