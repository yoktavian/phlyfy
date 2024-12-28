import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:onboarding/src/presentation/bloc/list_photo_cubit.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => HomeViewState();
}

class HomeViewState extends State<HomeView> {
  ScrollController? _galleryScrollController;

  @override
  void initState() {
    super.initState();
    _galleryScrollController = ScrollController();
    _galleryScrollController?.addListener(() {
      final currentPosition = _galleryScrollController?.position.pixels;
      final maxScroll = _galleryScrollController?.position.maxScrollExtent;
      if (currentPosition == maxScroll) {
        context.read<ListPhotoCubit>().loadMore();
      }
    });
  }

  @override
  void dispose() {
    _galleryScrollController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gallery Showcase'),
        backgroundColor: Colors.redAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            InkWell(
              onTap: () => context.push('/search'),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.redAccent, width: 1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Text('Search Photo'),
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: BlocBuilder<ListPhotoCubit, ListPhotoState>(
                builder: (context, state) {
                  final isLoading = state.loadingState == ListPhotoLoadingState.loading;
                  // if the state hasReachMaxPage is false, adding 1
                  // to show loading animation for lazy load.
                  final additionalLength = state.hasReachMaxPage ? 0 : 1;
                  // for the grid will use 1 axis count if the state is loading
                  // to make loading animation in the middle. else will make it
                  // 2.
                  final gridCrossAxisCount = isLoading ? 1 : 2;

                  return GridView.builder(
                    controller: _galleryScrollController,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: gridCrossAxisCount,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                    ),
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
                    itemCount: state.photos.length + additionalLength,
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
