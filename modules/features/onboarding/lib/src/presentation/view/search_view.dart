import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../presentation/cubit/search_photo_cubit.dart';
import './../widget/text_field_widget.dart';

class SearchView extends StatefulWidget {
  const SearchView({super.key});

  @override
  State<StatefulWidget> createState() => SearchViewState();
}

class SearchViewState extends State<SearchView> {
  ScrollController? _searchViewController;
  Timer? _searchDebounce;

  @override
  void initState() {
    super.initState();
    _searchViewController = ScrollController();
    _searchViewController?.addListener(() {
      final currentPosition = _searchViewController?.position.pixels;
      final maxScroll = _searchViewController?.position.maxScrollExtent;
      if (currentPosition == maxScroll) {
        context.read<SearchPhotoCubit>().loadMore();
      }
    });
  }

  @override
  void dispose() {
    if (_searchDebounce?.isActive == true) {
      _searchDebounce?.cancel();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Photo'),
        backgroundColor: Colors.redAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            TextFieldWidget(
              key: const Key('searchBar'),
              placeholder: 'Input Some Keywords...',
              onChanged: (value) {
                // will cancel the active timer to start new one
                if (_searchDebounce?.isActive ?? false) {
                  _searchDebounce?.cancel();
                }
                // we listen all changes but will add some debounce about 500ms
                // before sent it to API request. this operation is needed to
                // make sure user complete to input the keyword, before we sent
                // it to the API request, so it can be more efficient.
                _searchDebounce = Timer(const Duration(milliseconds: 500), () {
                  context.read<SearchPhotoCubit>().searchPhoto(value);
                });
              },
            ),
            const SizedBox(height: 8),
            Expanded(
              child: BlocBuilder<SearchPhotoCubit, SearchPhotoState>(
                builder: (context, state) {
                  final isLoading = state.loadingState == SearchPhotoLoadingState.loading;
                  // if we already reach max page or in loading condition will not adding
                  // any additional length, but for other than that condition lazy load will
                  // continue so we need to add 1 length to show loading animation.
                  final additionalLength = state.hasReachMaxPage || !isLoading ? 0 : 1;
                  // for the grid will use 1 axis count if the state is loading
                  // to make loading animation in the middle. else will make it
                  // 2.
                  final gridCrossAxisCount = isLoading ? 1 : 2;

                  return GridView.builder(
                    controller: _searchViewController,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: gridCrossAxisCount,
                      crossAxisSpacing: 4,
                      mainAxisSpacing: 4,
                    ),
                    itemCount: state.photos.length + additionalLength,
                    itemBuilder: (context, index) {
                      final photos = state.photos;

                      if (index == photos.length) {
                        return const Center(
                          child: CircularProgressIndicator(
                            color: Colors.redAccent,
                          ),
                        );
                      }

                      final photo = photos[index];
                      // Will use No description label as default value when
                      // the description is not provided.
                      final photoDescription = photo.description == ""
                          ? "No description"
                          : photo.description;

                      return GestureDetector(
                        onTap: () => {
                          context.push(
                            '/detail',
                            extra: {
                              'imageUrl': photo.urlPhoto.full,
                              'description': photoDescription,
                              'photographerName': photo.photographer.name,
                            },
                          )
                        },
                        child: Stack(
                          children: [
                            Positioned(
                              top: 0,
                              bottom: 0,
                              left: 0,
                              right: 0,
                              child: CachedNetworkImage(
                                placeholder: (context, url) {
                                  return Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 2,
                                      vertical: 2,
                                    ),
                                    color: Colors.black12,
                                    child: const Center(
                                      child: CircularProgressIndicator(
                                        color: Colors.redAccent,
                                      ),
                                    ),
                                  );
                                },
                                imageUrl: photo.urlPhoto.small,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              left: 0,
                              right: 0,
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                color: Colors.black38,
                                child: Text(
                                  photoDescription,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
