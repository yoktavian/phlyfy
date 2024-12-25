import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:onboarding/src/presentation/bloc/list_gallery_cubit.dart';

class HomeView extends StatefulWidget {
  @override
  State<HomeView> createState() => HomeViewState();
}

class HomeViewState extends State<HomeView>{

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
      ),
      body: Column(
        children: [
          InkWell(
            child: Text('fetch'),
            onTap: () => context.read<ListGalleryCubit>().fetchGallery(),
          ),
          BlocBuilder<ListGalleryCubit, ListGalleryState>(
              builder: (context, state) {
                return Text('Welcome to home ${state.message}');
              },
          )
        ],
      ),
    );
  }
}