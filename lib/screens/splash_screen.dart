import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:puzzlers/data/preferences.dart';
import 'package:puzzlers/helpers/app_colors.dart';
import 'package:puzzlers/helpers/app_images.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  Future<void> _splashHandle() async {
    try {
      await Future.delayed(const Duration(seconds: 2));
      final isLogin = await Preferences.getIsLogin();
      if(!isLogin){
        if (!mounted) return;
        context.go('/signIn');
        return;
      }
      if (!mounted) return;
      context.go('/home');
    } catch (e) {
      debugPrint('Terjadi kesalahan pada _splashHandle: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    _splashHandle();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              AppImages.logo,
              width: 150,
              height: 150,
            ),
            const SizedBox(height: 30),
            const CircularProgressIndicator(
              strokeWidth: 3,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ],
        ),
      ),
    );
  }

}
