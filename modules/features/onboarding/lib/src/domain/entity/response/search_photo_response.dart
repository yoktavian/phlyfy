import '../photo/photo.dart';

class SearchPhotoResponse {
  final int total;
  final int totalPages;
  final List<Photo> photos;

  SearchPhotoResponse({
    required this.total,
    required this.totalPages,
    required this.photos,
  });

  factory SearchPhotoResponse.fromJson(Map<String, dynamic> json) {
    final results = json['results'] as List;
    final List<Photo> photos = results
        .map(
          (item) => Photo.fromJson(item),
        )
        .toList();

    return SearchPhotoResponse(
      total: json['total'],
      totalPages: json['total_pages'],
      photos: photos,
    );
  }
}
