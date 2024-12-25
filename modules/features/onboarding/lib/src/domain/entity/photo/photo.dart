import 'photographer.dart';

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
