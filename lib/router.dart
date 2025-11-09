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
import 'package:puzzlers/screens/winner_screen.dart';

final router = GoRouter(
  initialLocation: '/splash',
  routes: [
    GoRoute(path: '/splash', builder: (context, state) =>const SplashScreen()),
    GoRoute(path: '/signIn', builder: (context, state) =>const SignInScreen()),
    GoRoute(path: '/home', builder: (context, state) => const HomeScreen()),
    GoRoute(path: '/puzzle', builder: (context, state){
        final level = state.extra.toString();
        return PuzzleScreen(level: level,);
    }),
    GoRoute(path: '/winner', builder: (context, state){
      final data = state.extra as Map<String, dynamic>;
      return WinnerScreen(
        level: data['level'].toString(),
        move: data['move'],
        timer: data['timer'],
      );
    }),
    GoRoute(path: '/profile', builder: (context, state) =>const ProfileScreen()),
    GoRoute(path: '/settings', builder: (context, state) =>const SettingsScreen()),
    GoRoute(path: '/info', builder: (context, state) =>const InfoScreen()),
    GoRoute(path: '/edit-name', builder: (context, state) =>const EditNameScreen()),
    GoRoute(path: '/edit-photo', builder: (context, state) =>const EditPhotoScreen()),
    GoRoute(path: '/level', builder: (context, state) =>const LevelPuzzleScreen()),
  ]
);