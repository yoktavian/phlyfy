import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:onboarding/src/presentation/bloc/list_gallery_cubit.dart';

class HomeView extends StatefulWidget {
  @override
  State<HomeView> createState() => HomeViewState();
}

class HomeViewState extends State<HomeView> {
  late ScrollController _galleryScrollController;

  @override
  void initState() {
    super.initState();
    _galleryScrollController = ScrollController();

    _galleryScrollController.addListener(() {
      final currentPosition = _galleryScrollController.position.pixels;
      final maxScroll = _galleryScrollController.position.maxScrollExtent;
      if (currentPosition == maxScroll) {
        context.read<ListGalleryCubit>().loadMore();
      }
    });
  }

  @override
  void dispose() {
    _galleryScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gallery Showcase'),
      ),
      body: BlocBuilder<ListGalleryCubit, ListGalleryState>(
        builder: (context, state) {
          final isLoading =
              state.loadingState == ListGalleryLoadingState.loading;

          return GridView.builder(
            controller: _galleryScrollController,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: isLoading ? 1 : 2,
              crossAxisSpacing: 4.0,
              mainAxisSpacing: 4.0,
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
                                horizontal: 2.0,
                                vertical: 2.0,
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
                  ));
            },
            itemCount: state.photos.length + 1,
          );
        },
      ),
    );
  }
}
