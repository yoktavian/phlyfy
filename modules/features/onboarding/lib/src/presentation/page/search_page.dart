import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repository/photo/search_photo.dart';
import '../../presentation/cubit/search_photo_cubit.dart';
import '../../presentation/view/search_view.dart';

class SearchPage extends StatelessWidget {
  final SearchPhoto photoRepo;

  const SearchPage({super.key, required this.photoRepo});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SearchPhotoCubit>(
      create: (_) => SearchPhotoCubit(
        SearchPhotoState(),
        photoRepo: photoRepo,
      ),
      child: const SearchView(),
    );
  }
}
