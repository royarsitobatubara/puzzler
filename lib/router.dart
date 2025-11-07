import 'package:go_router/go_router.dart';
import 'package:puzzlers/screens/puzzle_screen.dart';
import 'package:puzzlers/screens/splash_screen.dart';

final router = GoRouter(
  initialLocation: '/splash',
  routes: [
    GoRoute(path: '/splash', builder: (context, state) => SplashScreen()),
    GoRoute(path: '/puzzle', builder: (context, state) => PuzzleScreen()),
  ]
);