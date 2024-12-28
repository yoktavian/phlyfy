import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:onboarding/src/domain/repository/gallery/list_photo.dart';
import 'package:onboarding/src/presentation/bloc/search_photo_cubit.dart';
import 'package:onboarding/src/presentation/view/search_view.dart';

class SearchPage extends StatelessWidget {
  final ListPhoto galleryRepo;

  const SearchPage({super.key, required this.galleryRepo});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SearchPhotoCubit>(
      create: (_) => SearchPhotoCubit(
        SearchPhotoState(),
        galleryRepo: galleryRepo,
      ),
      child: const SearchView(),
    );
  }
}
