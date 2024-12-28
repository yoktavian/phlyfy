class SearchPhotoRequest {
  final String query;
  final int page;
  final int perPage;

  SearchPhotoRequest({
    required this.query,
    required this.page,
    required this.perPage,
  });
}
