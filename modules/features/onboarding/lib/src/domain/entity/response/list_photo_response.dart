import '../photo/photo.dart';

class ListPhotoResponse {
  final List<Photo> photos;

  ListPhotoResponse({
    required this.photos,
  });

  factory ListPhotoResponse.fromJson(List<dynamic> json) {
    final List<Photo> photos = json
        .map(
          (item) => Photo.fromJson(item as Map<String, dynamic>),
        )
        .toList();

    return ListPhotoResponse(
      photos: photos,
    );
  }
}
