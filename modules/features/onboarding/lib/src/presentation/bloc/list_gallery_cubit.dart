import 'package:entity_api/api.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:onboarding/src/domain/entity/entity.dart';
import 'package:oni_api/oni_api.dart';

class ListGalleryState {
  final String message;

  ListGalleryState(this.message);
}

class ListGalleryCubit extends Cubit<ListGalleryState> {
  final OniGet client;

  ListGalleryCubit(super.initialState, { required this.client });

  void fetchGallery() async {
    final res = await client.get(
      path: '/search/photos',
      queryParameters: {
        'query': 'football',
        'page': 1,
        'per_page': 5,
      },
    );

    if (res is ApiResultSuccess) {
      final photos = ListPhotoResponse.fromJson(res.data);
      print('success');
      print(photos.photos.first.id);
    } else {
      print('error');
      print(res);
    }
  }
}
