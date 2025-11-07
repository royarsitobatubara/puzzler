import 'package:go_router/go_router.dart';
import 'package:puzzlers/screens/home_screen.dart';
import 'package:puzzlers/screens/puzzle_screen.dart';
import 'package:puzzlers/screens/sign_in_screen.dart';
import 'package:puzzlers/screens/splash_screen.dart';

final router = GoRouter(
  initialLocation: '/splash',
  routes: [
    GoRoute(path: '/splash', builder: (context, state) => SplashScreen()),
    GoRoute(path: '/home', builder: (context, state) => const HomeScreen()),
    GoRoute(path: '/puzzle', builder: (context, state) => PuzzleScreen()),

    GoRoute(path: '/signIn', builder: (context, state) => SignInScreen()),

  ]
);