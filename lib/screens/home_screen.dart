import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:puzzlers/data/preferences.dart';
import 'package:puzzlers/helpers/app_colors.dart';
import 'package:puzzlers/helpers/app_images.dart';
import 'package:puzzlers/screens/layout/screen_layout.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {

  String? _name;

  // ANIMATION CONTROLLER
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  Future<void> _getName() async {
    final name = await Preferences.getUsername();
    if (mounted) {
      setState(() => _name = name);
    }
  }

  @override
  void initState() {
    super.initState();
    _getName();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(begin: 0.9, end: 1.08).animate(
        CurvedAnimation(parent: _controller, curve: Curves.easeInOut)
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenLayout(
      child: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              children: [
                InkWell(
                  onTap: (){},
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: .5),
                          shape: BoxShape.circle,
                          boxShadow: [BoxShadow(color:AppColors.primary.withValues(alpha: .5), offset: const Offset(0, 8), blurRadius: 8)] ),
                        child: ClipOval(child: Image.asset(AppImages.profile1, width: 55, height: 55,),),
                      ),
                      const SizedBox(width: 10,),
                      Column( children: [
                        Text(_name ?? 'Guest', style:const TextStyle( color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15 ),),
                        Image.asset(AppImages.logo, width: 50, height: 50,), ], )
                    ],
                  ),
                ),
                const SizedBox(height: 10),

                // LOGO fade-in
                AnimatedOpacity(
                  opacity: 1,
                  duration: const Duration(seconds: 2),
                  child: Column(
                    children: [
                      Image.asset(AppImages.logo, width: 250),
                      const SizedBox(height: 5),
                      const Text(
                        'Puzzlers',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 2,
                        ),
                      ),
                    ],
                  ),
                ),

                const Spacer(),

                // PLAY BUTTON PULSE ANIMATION
                ScaleTransition(
                  scale: _scaleAnimation,
                  child: InkWell(
                    onTap: () => context.push('/game-level'),
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withValues(alpha: .7),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.white.withValues(alpha: .5),
                            blurRadius: 20,
                            spreadRadius: 5,
                          )
                        ],
                      ),
                      child: Image.asset(AppImages.play, width: 150),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _iconButton(AppImages.setting, () => context.push('/settings')),
                    _iconButton(AppImages.info, () => context.push('/info')),
                  ],
                ),

                const Spacer(),

                Text(
                  "v1.0.0",
                  style: TextStyle(
                    color: Colors.white54,
                    fontSize: 12,
                  ),
                ),

                const SizedBox(height: 5),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _iconButton(String image, VoidCallback onTap) {
    return AnimatedRotation(
      duration: const Duration(seconds: 3),
      turns: 1,
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(2),
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withValues(alpha: .7)
          ),
          child: Image.asset(image, width: 90, height: 90),
        ),
      ),
    );
  }
}
