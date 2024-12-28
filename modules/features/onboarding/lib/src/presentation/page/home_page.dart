import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repository/repository.dart';
import '../../presentation/cubit/list_photo_cubit.dart';
import '../../presentation/view/home_view.dart';

class HomePage extends StatelessWidget {
  final ListPhoto photoRepo;

  const HomePage({super.key, required this.photoRepo});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ListPhotoCubit>(
      create: (_) => ListPhotoCubit(
        ListPhotoState(),
        photoRepo: photoRepo,
      )..fetchPhotos(),
      child: const HomeView(),
    );
  }
}
