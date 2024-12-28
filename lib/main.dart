import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:go_router/go_router.dart';
import 'package:onboarding/onboarding.dart';
import 'package:oni_api/oni_api.dart';
import 'package:pholyfy/src/api/api.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');

  runApp(
    PholyfyApp(
      client: UnsplashClient(
        baseUrl: 'https://api.unsplash.com',
        interceptor: UnsplashInterceptor(
          clientID: dotenv.get('UNSPLASH_CLIENT_ID', fallback: ''),
        ),
      ),
    ),
  );
}

class PholyfyApp extends StatelessWidget {
  final OniGet client;

  const PholyfyApp({super.key, required this.client});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: _router(client),
    );
  }
}

GoRouter _router(OniGet client) {
  return GoRouter(
    routes: <RouteBase>[
      GoRoute(
        path: '/',
        builder: (BuildContext _, GoRouterState __) {
          return HomePage(
            photoRepo: PhotoRepository(client: client),
          );
        },
      ),
      GoRoute(
        path: '/detail',
        builder: (BuildContext _, GoRouterState state) {
          final extraData = state.extra as Map<String, String>;
          final imageUrl = extraData['imageUrl'] ?? '';
          final description = extraData['description'] ?? '';
          final photographerName = extraData['photographerName'] ?? '';

          return PhotoDetailPage(
            imageUrl: imageUrl,
            description: description,
            photographerName: photographerName,
          );
        },
      ),
      GoRoute(
        path: '/search',
        builder: (BuildContext _, GoRouterState state) {
          return SearchPage(
            photoRepo: PhotoRepository(client: client),
          );
        },
      ),
    ],
  );
}
