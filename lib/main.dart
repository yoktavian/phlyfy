import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:onboarding/onboarding.dart';
import 'package:oni_api/oni_api.dart';
import 'package:pholyfy/src/api/api.dart';

void main() {
  runApp(
    PholyfyApp(
      client: UnsplashClient(
        baseUrl: 'https://api.unsplash.com',
        interceptor: UnsplashInterceptor(
          clientID: ''
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
          return HomePage(client: client);
        },
      ),
    ],
  );
}
