import 'package:onboarding/src/domain/repository/photo/search_photo.dart';
import 'package:oni_api/oni_api.dart';

import './list_photo.dart';

abstract class Photo implements ListPhoto, SearchPhoto {
  final OniGet client;
  Photo({required this.client});
}
