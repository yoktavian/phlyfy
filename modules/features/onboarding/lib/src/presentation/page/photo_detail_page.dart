import 'package:flutter/material.dart';
import 'package:onboarding/src/presentation/view/photo_detail_view.dart';

class PhotoDetailPage extends StatelessWidget {
  final String imageUrl;
  final String description;
  final String photographerName;

  const PhotoDetailPage({
    super.key,
    required this.imageUrl,
    required this.description,
    required this.photographerName,
  });

  @override
  Widget build(BuildContext context) {
    return PhotoDetailView(
      imageUrl: imageUrl,
      description: description,
      photographerName: photographerName,
    );
  }
}
