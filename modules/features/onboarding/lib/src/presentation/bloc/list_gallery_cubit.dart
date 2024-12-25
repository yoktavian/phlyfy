import 'package:entity/entity.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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

    if (res is OniResultSuccess) {
      final photos = ListPhotoResponse.fromJson(res.data);
    } else {
      print('error');
      print(res);
    }
  }
}

class ListPhotoResponse {
  final int total;
  final int totalPages;
  final List<Photo> photos;

  ListPhotoResponse({
    required this.total,
    required this.totalPages,
    required this.photos,
  });

  factory ListPhotoResponse.fromJson(Map<String, dynamic> json) {
    final results = json['results'] as List;
    final List<Photo> photos = results
        .map(
          (item) => Photo.fromJson(item),
        )
        .toList();

    return ListPhotoResponse(
      total: json['total'],
      totalPages: json['total_pages'],
      photos: photos,
    );
  }
}

class Photo {
  final String id;
  final String slug;
  final String description;
  final int likes;
  final Photographer photographer;

  Photo({
    required this.id,
    required this.slug,
    required this.description,
    required this.likes,
    required this.photographer,
  });

  factory Photo.fromJson(Map<String, dynamic> json) {
    return Photo(
      id: json['id'],
      slug: json['slug'],
      description: json['description'] ?? '',
      likes: json['likes'],
      photographer: Photographer.fromJson(json['user']),
    );
  }
}

class Photographer {
  final String id;
  final String name;

  Photographer({required this.id, required this.name});

  factory Photographer.fromJson(Map<String, dynamic> json) {
    return Photographer(id: json['id'], name: json['name']);
  }
}
