import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:onboarding/src/domain/entity/request/search_photo.dart';
import 'package:onboarding/src/domain/entity/response/search_photo_response.dart';
import 'package:onboarding/src/domain/repository/photo/search_photo.dart';
import '../../domain/entity/entity.dart';
import '../../domain/repository/photo/list_photo.dart';
import '../bloc/list_photo_cubit.dart';

enum SearchPhotoLoadingState {
  loading,
  loadMore,
  loaded,
}

class SearchPhotoState {
  final String errorMessage;
  final int page;
  final SearchPhotoLoadingState loadingState;
  final bool hasReachMaxPage;
  final List<Photo> photos;
  final String keyword;

  SearchPhotoState({
    this.errorMessage = '',
    this.keyword = '',
    this.page = 1,
    this.loadingState = SearchPhotoLoadingState.loading,
    this.hasReachMaxPage = false,
    List<Photo>? photos,
  }) : photos = photos ?? [];

  SearchPhotoState copyWith({
    String? errorMessage,
    String? keyword,
    int? page,
    SearchPhotoLoadingState? loadingState,
    bool? hasReachMaxPage,
    List<Photo>? photos,
  }) {
    return SearchPhotoState(
      errorMessage: errorMessage ?? this.errorMessage,
      keyword: keyword ?? this.keyword,
      page: page ?? this.page,
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
        perPage: 20,
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
            // below perPage that mean its already reach to max page.
            hasReachMaxPage: newPhotos.length < 20,
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
