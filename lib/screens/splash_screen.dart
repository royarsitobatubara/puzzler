import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:puzzlers/helpers/app_images.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  Future<void> _splashHandle() async {
    try {
      await Future.delayed(const Duration(seconds: 3));
      if (!mounted) return;
      context.go('/puzzle');
    } catch (e) {
      debugPrint('Terjadi kesalahan pada _splashHandle: $e');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _splashHandle();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Image.asset(AppImages.logo, width: 150, height: 150,),
      ),
    );
  }
}
