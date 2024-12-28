import 'photographer.dart';

class Photo {
  final String id;
  final String slug;
  final String description;
  final int likes;
  final Photographer photographer;
  final UrlPhoto urlPhoto;

  Photo({
    required this.id,
    required this.slug,
    required this.description,
    required this.likes,
    required this.photographer,
    required this.urlPhoto,
  });

  factory Photo.fromJson(Map<String, dynamic> json) {
    return Photo(
      id: json['id'],
      slug: json['slug'],
      description: json['description'] ?? '',
      likes: json['likes'],
      photographer: Photographer.fromJson(json['user']),
      urlPhoto: UrlPhoto.fromJson(json['urls']),
    );
  }
}

class UrlPhoto {
  final String full;
  final String small;

  UrlPhoto({required this.full, required this.small});

  factory UrlPhoto.fromJson(Map<String, dynamic> json) {
    return UrlPhoto(full: json['full'], small: json['small']);
  }
}
