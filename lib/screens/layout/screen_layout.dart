import 'package:flutter/material.dart';
import 'package:puzzlers/helpers/app_colors.dart';
import 'package:puzzlers/helpers/app_images.dart';

class ScreenLayout extends StatelessWidget {
  final Widget child;
  const ScreenLayout({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.primary,
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage(AppImages.background),
              fit: BoxFit.cover,
            ),
          ),
          child: Stack(
            children: [
              Container(
                color: Colors.black.withValues(alpha: .4),
              ),
              SafeArea(child: child)
            ],
          ),
        ),
      resizeToAvoidBottomInset: false,
    );
  }
}
