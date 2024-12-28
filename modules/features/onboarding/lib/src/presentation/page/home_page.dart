import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:onboarding/src/domain/repository/repository.dart';
import 'package:onboarding/src/presentation/bloc/list_gallery_cubit.dart';
import 'package:onboarding/src/presentation/view/home_view.dart';

class HomePage extends StatelessWidget {
  final ListPhoto galleryRepo;

  const HomePage({super.key, required this.galleryRepo});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ListGalleryCubit>(
      create: (_) => ListGalleryCubit(
        ListGalleryState(),
        galleryRepo: galleryRepo,
      )..fetchGallery(),
      child: HomeView(),
    );
  }
}
