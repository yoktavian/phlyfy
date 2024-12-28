import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repository/repository.dart';
import '../../presentation/extension/extension.dart';
import '../../domain/entity/entity.dart' as entity;

enum ListPhotoLoadingState {
  loading,
  loadMore,
  loaded,
}

class ListPhotoState {
  final String errorMessage;
  final int page;
  final int totalPerPage;
  final ListPhotoLoadingState loadingState;
  final bool hasReachMaxPage;
  final List<entity.Photo> photos;

  ListPhotoState({
    this.errorMessage = '',
    this.page = 1,
    this.totalPerPage = 20,
    this.loadingState = ListPhotoLoadingState.loaded,
    this.hasReachMaxPage = false,
    List<entity.Photo>? photos,
  }) : photos = photos ?? [];

  ListPhotoState copyWith({
    String? errorMessage,
    int? page,
    int? totalPerPage,
    ListPhotoLoadingState? loadingState,
    bool? hasReachMaxPage,
    List<entity.Photo>? photos,
  }) {
    return ListPhotoState(
      errorMessage: errorMessage ?? this.errorMessage,
      page: page ?? this.page,
      totalPerPage: totalPerPage ?? this.totalPerPage,
      loadingState: loadingState ?? this.loadingState,
      hasReachMaxPage: hasReachMaxPage ?? this.hasReachMaxPage,
      photos: photos ?? this.photos,
    );
  }
}

class ListPhotoCubit extends Cubit<ListPhotoState> {
  final ListPhoto photoRepo;

  ListPhotoCubit(super.initialState, {required this.photoRepo});

  void fetchPhotos() async {
    if (state.loadingState != ListPhotoLoadingState.loadMore) {
      emit(
        state.copyWith(
          loadingState: ListPhotoLoadingState.loading,
        ),
      );
    }

    final result = await photoRepo.listPhoto(
      entity.ListPhotoRequest(
        perPage: state.totalPerPage,
        page: state.page,
      ),
    );

    result.when(
      onSuccess: (json) {
        final photoResponse = entity.ListPhotoResponse.fromJson(json);
        final newPhotos = state.photos;
        newPhotos.addAll(photoResponse.photos);
        emit(
          state.copyWith(
            errorMessage: '',
            photos: newPhotos,
            // below totalPerPage that mean its already reach to max page.
            hasReachMaxPage: newPhotos.length < state.totalPerPage,
            loadingState: ListPhotoLoadingState.loaded,
          ),
        );
      },
      onError: (error) {
        emit(state.copyWith(errorMessage: error.message));
      },
    );
  }

  void loadMore() {
    final isLoadMoreActive = state.loadingState == ListPhotoLoadingState.loadMore;
    // there is a possibility user keep scrolling up and down multiple times, so
    // load more item can be called couple time and makes the request will be
    // duplicated. To avoid that, we check the loading state status here. if the
    // status is still trying to load More item then it will be returned. Same as
    // when we already reach max page, that means we don't have another data to load
    // from DB. So if the flag hasReachMaxPage is true, this function will be returned.
    if (state.hasReachMaxPage || isLoadMoreActive) return;

    emit(
      state.copyWith(
        loadingState: ListPhotoLoadingState.loadMore,
        // adding + 1 to load the data from the next page.
        page: state.page + 1,
      ),
    );

    fetchPhotos();
  }
}
