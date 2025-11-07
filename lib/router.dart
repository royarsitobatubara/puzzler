import 'package:go_router/go_router.dart';
import 'package:puzzlers/screens/edit_name_screen.dart';
import 'package:puzzlers/screens/edit_photo_screen.dart';
import 'package:puzzlers/screens/home_screen.dart';
import 'package:puzzlers/screens/info_screen.dart';
import 'package:puzzlers/screens/level_puzzle_screen.dart';
import 'package:puzzlers/screens/profile_screen.dart';
import 'package:puzzlers/screens/puzzle_screen.dart';
import 'package:puzzlers/screens/settings_screen.dart';
import 'package:puzzlers/screens/sign_in_screen.dart';
import 'package:puzzlers/screens/splash_screen.dart';

final router = GoRouter(
  initialLocation: '/splash',
  routes: [
    GoRoute(path: '/splash', builder: (context, state) => SplashScreen()),
    GoRoute(path: '/signIn', builder: (context, state) => SignInScreen()),
    GoRoute(path: '/home', builder: (context, state) => const HomeScreen()),
    GoRoute(path: '/puzzle', builder: (context, state) => PuzzleScreen()),
    GoRoute(path: '/profile', builder: (context, state) => ProfileScreen()),
    GoRoute(path: '/settings', builder: (context, state) => SettingsScreen()),
    GoRoute(path: '/info', builder: (context, state) => InfoScreen()),
    GoRoute(path: '/edit-name', builder: (context, state) => EditNameScreen()),
    GoRoute(path: '/edit-photo', builder: (context, state) => EditPhotoScreen()),
    GoRoute(path: '/level', builder: (context, state) => LevelPuzzleScreen()),
  ]
);