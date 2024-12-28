import 'package:entity_api/api.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:onboarding/src/domain/repository/repository.dart';
import '../../domain/entity/entity.dart' as entity;

enum ListPhotoLoadingState {
  loading,
  loadMore,
  loaded,
}

class ListPhotoState {
  final String errorMessage;
  final int page;
  final int totalPage;
  final ListPhotoLoadingState loadingState;
  final bool hasReachMaxPage;
  final List<entity.Photo> photos;

  ListPhotoState({
    this.errorMessage = '',
    this.page = 1,
    this.totalPage = 20,
    this.loadingState = ListPhotoLoadingState.loaded,
    this.hasReachMaxPage = false,
    List<entity.Photo>? photos,
  }) : photos = photos ?? [];

  ListPhotoState copyWith({
    String? errorMessage,
    int? page,
    int? totalPage,
    ListPhotoLoadingState? loadingState,
    bool? hasReachMaxPage,
    List<entity.Photo>? photos,
  }) {
    return ListPhotoState(
      errorMessage: errorMessage ?? this.errorMessage,
      page: page ?? this.page,
      totalPage: totalPage ?? this.totalPage,
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
        perPage: 20,
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
            // below perPage that mean its already reach to max page.
            hasReachMaxPage: newPhotos.length < 20,
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
    final isLoadMoreActive =
        state.loadingState == ListPhotoLoadingState.loadMore;
    if (state.hasReachMaxPage || isLoadMoreActive) return;

    emit(
      state.copyWith(
        loadingState: ListPhotoLoadingState.loadMore,
        page: state.page + 1,
      ),
    );

    fetchPhotos();
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
