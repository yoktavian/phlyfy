import '../photo/photo.dart';

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
