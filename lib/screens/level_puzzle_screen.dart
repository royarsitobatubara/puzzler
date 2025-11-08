import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:puzzlers/data/sound_manager.dart';
import 'package:puzzlers/helpers/app_colors.dart';
import 'package:puzzlers/helpers/app_images.dart';
import 'package:puzzlers/screens/layout/screen_layout.dart';

class LevelPuzzleScreen extends StatefulWidget {
  const LevelPuzzleScreen({super.key});

  @override
  State<LevelPuzzleScreen> createState() => _LevelPuzzleScreenState();
}

class _LevelPuzzleScreenState extends State<LevelPuzzleScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fade;
  final List<String> _level = ['easy', 'medium', 'hard'];

  int _selectedIndex = -1;
  int _pressedIndex = -1;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _fade = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenLayout(
      child: FadeTransition(
        opacity: _fade,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              Row(
                children: [
                  InkWell(
                    onTap: (){SoundManager().playClick(); context.pop();},
                    child: Image.asset(
                      AppImages.arrowLeft,
                      width: 50,
                      height: 50,
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    "Level",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 25),

              Expanded(
                child: ListView.separated(
                  itemCount: _level.length,
                  separatorBuilder: (context, _) => const SizedBox(height: 15),
                  itemBuilder: (context, index) {
                    final isPressed = _pressedIndex == index;
                    final isSelected = _selectedIndex == index;

                    return GestureDetector(
                      onTapDown: (_) {
                        SoundManager().playClick();
                        setState(() => _pressedIndex = index);
                      },
                      onTapUp: (_) {
                        setState(() {
                          _pressedIndex = -1;
                          _selectedIndex = index;
                        });
                      },
                      onTapCancel: () {
                        setState(() => _pressedIndex = -1);
                      },
                      child: AnimatedScale(
                        duration: const Duration(milliseconds: 150),
                        scale: isPressed
                            ? 1.08
                            : isSelected
                            ? 1.05
                            : 1.0,
                        curve: Curves.easeOutBack,
                        child: Container(
                          height: 80,
                          decoration: BoxDecoration(
                            image: const DecorationImage(
                              image: AssetImage(AppImages.buttonLevel),
                              fit: BoxFit.cover,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            _level[index].toUpperCase(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                              shadows: [
                                Shadow(
                                  blurRadius: 6,
                                  color: Colors.black54,
                                  offset: Offset(1, 2),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(
                width: double.maxFinite,
                child: ElevatedButton(
                    onPressed: (){
                      SoundManager().playClick();
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary
                    ),
                    child: const Text("Submit", style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 17
                    ),)
                ),
              ),
              const SizedBox(height: 20,)
            ],
          ),
        ),
      ),
    );
  }
}
