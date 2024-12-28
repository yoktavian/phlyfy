import 'package:oni_api/oni_api.dart';

import './list_photo.dart';

abstract class Gallery implements ListPhoto {
  final OniGet client;
  Gallery({required this.client});
}
