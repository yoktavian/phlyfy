import 'package:entity_api/api.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:onboarding/src/domain/entity/request/photo.dart';
import 'package:onboarding/src/domain/repository/repository.dart';
import '../../domain/entity/entity.dart';

enum ListGalleryLoadingState {
  loading,
  loadMore,
  loaded,
}

class ListGalleryState {
  final String errorMessage;
  final int page;
  final int totalPage;
  final ListGalleryLoadingState loadingState;
  final bool hasReachMaxPage;
  final List<Photo> photos;

  ListGalleryState({
    this.errorMessage = '',
    this.page = 1,
    this.totalPage = 20,
    this.loadingState = ListGalleryLoadingState.loaded,
    this.hasReachMaxPage = false,
    List<Photo>? photos,
  }) : photos = photos ?? [];

  ListGalleryState copyWith({
    String? errorMessage,
    int? page,
    int? totalPage,
    ListGalleryLoadingState? loadingState,
    bool? hasReachMaxPage,
    List<Photo>? photos,
  }) {
    return ListGalleryState(
      errorMessage: errorMessage ?? this.errorMessage,
      page: page ?? this.page,
      totalPage: totalPage ?? this.totalPage,
      loadingState: loadingState ?? this.loadingState,
      hasReachMaxPage: hasReachMaxPage ?? this.hasReachMaxPage,
      photos: photos ?? this.photos,
    );
  }
}

class ListGalleryCubit extends Cubit<ListGalleryState> {
  final ListPhoto galleryRepo;

  ListGalleryCubit(super.initialState, {required this.galleryRepo});

  void fetchGallery() async {
    if (state.page == 1) {
      emit(
        state.copyWith(
          loadingState: ListGalleryLoadingState.loading,
        ),
      );
    }

    final result = await galleryRepo.listPhoto(
      ListPhotoRequest(
        query: 'football',
        perPage: 20,
        page: state.page,
      ),
    );

    result.when(
      onSuccess: (json) {
        final photoResponse = ListPhotoResponse.fromJson(json);
        final newPhotos = state.photos;
        newPhotos.addAll(photoResponse.photos);
        emit(
          state.copyWith(
            errorMessage: '',
            photos: newPhotos,
            // below perPage that mean its already reach to max page.
            hasReachMaxPage: newPhotos.length < 20,
            loadingState: ListGalleryLoadingState.loaded,
          ),
        );
      },
      onError: (error) {
        emit(state.copyWith(errorMessage: error.message));
      },
    );
  }

  void loadMore() {
    final isLoadMoreActive = state.loadingState == ListGalleryLoadingState.loadMore;
    if (state.hasReachMaxPage || isLoadMoreActive) return;

    emit(
      state.copyWith(
        loadingState: ListGalleryLoadingState.loadMore,
        page: state.page + 1,
      ),
    );

    fetchGallery();
  }
}

extension ApiResultExt on ApiResult {
  void when({
    required Function(dynamic json) onSuccess,
    required Function(ApiResultError error) onError,
  }) {
    final result = this;

    if (result is ApiResultSuccess) {
      onSuccess(result.data);
    } else {
      onError(this as ApiResultError);
    }
  }
}
