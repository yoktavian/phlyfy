import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:onboarding/src/presentation/bloc/list_gallery_cubit.dart';
import 'package:onboarding/src/presentation/view/home_view.dart';
import 'package:oni_api/oni_api.dart';

class HomePage extends StatelessWidget {
  final OniGet client;

  const HomePage({super.key, required this.client});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ListGalleryCubit>(
      create: (_) => ListGalleryCubit(
        ListGalleryState('abcd'),
        client: client,
      ),
      child: HomeView(),
    );
  }
}
