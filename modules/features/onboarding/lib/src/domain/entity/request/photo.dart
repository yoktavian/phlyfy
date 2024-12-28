class ListPhotoRequest {
  final String query;
  final int page;
  final int perPage;

  ListPhotoRequest({
    required this.query,
    required this.page,
    required this.perPage,
  });
}
