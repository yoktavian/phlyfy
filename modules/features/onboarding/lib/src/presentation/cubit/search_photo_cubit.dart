import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entity/request/search_photo.dart';
import '../../domain/entity/response/search_photo_response.dart';
import '../../domain/repository/photo/search_photo.dart';
import '../../presentation/extension/api/api_result.dart';
import '../../domain/entity/entity.dart';

enum SearchPhotoLoadingState {
  loading,
  loadMore,
  loaded,
}

class SearchPhotoState {
  final String errorMessage;
  final int page;
  final int totalPerPage;
  final SearchPhotoLoadingState loadingState;
  final bool hasReachMaxPage;
  final List<Photo> photos;
  final String keyword;

  SearchPhotoState({
    this.errorMessage = '',
    this.keyword = '',
    this.page = 1,
    this.totalPerPage = 20,
    this.loadingState = SearchPhotoLoadingState.loaded,
    this.hasReachMaxPage = false,
    List<Photo>? photos,
  }) : photos = photos ?? [];

  SearchPhotoState copyWith({
    String? errorMessage,
    String? keyword,
    int? page,
    int? totalPerPage,
    SearchPhotoLoadingState? loadingState,
    bool? hasReachMaxPage,
    List<Photo>? photos,
  }) {
    return SearchPhotoState(
      errorMessage: errorMessage ?? this.errorMessage,
      keyword: keyword ?? this.keyword,
      page: page ?? this.page,
      totalPerPage: totalPerPage ?? this.totalPerPage,
      loadingState: loadingState ?? this.loadingState,
      hasReachMaxPage: hasReachMaxPage ?? this.hasReachMaxPage,
      photos: photos ?? this.photos,
    );
  }
}

class SearchPhotoCubit extends Cubit<SearchPhotoState> {
  final SearchPhoto photoRepo;

  SearchPhotoCubit(super.initialState, {required this.photoRepo});

  void searchPhoto(String keyword) async {
    if (state.loadingState != SearchPhotoLoadingState.loadMore) {
      emit(
        state.copyWith(
          keyword: keyword,
          page: 1,
          photos: [],
          loadingState: SearchPhotoLoadingState.loading,
        ),
      );
    }

    final result = await photoRepo.searchPhoto(
      SearchPhotoRequest(
        query: keyword,
        perPage: state.totalPerPage,
        page: state.page,
      ),
    );

    result.when(
      onSuccess: (json) {
        final photoResponse = SearchPhotoResponse.fromJson(json);
        final newPhotos = state.photos;
        newPhotos.addAll(photoResponse.photos);
        emit(
          state.copyWith(
            errorMessage: '',
            photos: newPhotos,
            // below totalPerPage that mean its already reach to max page.
            hasReachMaxPage: newPhotos.length < state.totalPerPage,
            loadingState: SearchPhotoLoadingState.loaded,
          ),
        );
      },
      onError: (error) {
        emit(state.copyWith(errorMessage: error.message));
      },
    );
  }

  void loadMore() {
    final isLoadMoreActive = state.loadingState == SearchPhotoLoadingState.loadMore;
    // there is a possibility user keep scrolling up and down multiple times, so
    // load more item can be called couple time and makes the request will be
    // duplicated. To avoid that, we check the loading state status here. if the
    // status is still trying to load More item then it will be returned. Same as
    // when we already reach max page, that means we don't have another data to load
    // from DB. So if the flag hasReachMaxPage is true, this function will be returned.
    if (state.hasReachMaxPage || isLoadMoreActive) return;

    emit(
      state.copyWith(
        loadingState: SearchPhotoLoadingState.loadMore,
        page: state.page + 1,
      ),
    );

    searchPhoto(state.keyword);
  }
}
