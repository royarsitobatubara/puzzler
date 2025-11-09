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
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late AnimationController _bounceController;
  late Animation<double> _fade;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _bounceAnimation;

  final List<Map<String, dynamic>> _levels = [
    {
      'name': 'easy',
      'displayName': 'MUDAH',
      'icon': Icons.sentiment_very_satisfied,
      'color': Colors.green,
      'gradient': const [Color(0xFF11998e), Color(0xFF38ef7d)],
      'description': '2x2 Grid • 2 Menit',
      'difficulty': 1,
    },
    {
      'name': 'medium',
      'displayName': 'SEDANG',
      'icon': Icons.sentiment_neutral,
      'color': Colors.orange,
      'gradient': const [Color(0xFFf46b45), Color(0xFFeea849)],
      'description': '4x4 Grid • 2 Menit',
      'difficulty': 2,
    },
    {
      'name': 'hard',
      'displayName': 'SULIT',
      'icon': Icons.sentiment_very_dissatisfied,
      'color': Colors.red,
      'gradient': const [Color(0xFFB06AB3), Color(0xFF4568DC)],
      'description': '6x6 Grid • 2 Menit',
      'difficulty': 3,
    },
  ];

  int _selectedIndex = 0;
  int _pressedIndex = -1;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();

    // Fade animation
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fade = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    );

    // Slide animation
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
    ));

    // Bounce animation for submit button
    _bounceController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _bounceAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(
        parent: _bounceController,
        curve: Curves.easeInOut,
      ),
    );

    _fadeController.forward();
    _slideController.forward();

    // Continuous bounce animation for submit button
    _bounceController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    _bounceController.dispose();
    super.dispose();
  }

  void _onLevelTap(int index) async {
    SoundManager().playClick();
    setState(() {
      _pressedIndex = index;
    });

    await Future.delayed(const Duration(milliseconds: 150));

    if (mounted) {
      setState(() {
        _pressedIndex = -1;
        _selectedIndex = index;
      });
    }
  }

  void _onSubmit() async {
    if (_isSubmitting) return;

    setState(() => _isSubmitting = true);
    SoundManager().playClick();

    // Scale animation on submit
    await _bounceController.forward();
    await _bounceController.reverse();

    if (mounted) {
      context.push('/puzzle', extra: _levels[_selectedIndex]['name']);
      setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScreenLayout(
      child: FadeTransition(
        opacity: _fade,
        child: SlideTransition(
          position: _slideAnimation,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                // Header with back button
                Row(
                  children: [
                    TweenAnimationBuilder<double>(
                      duration: const Duration(milliseconds: 600),
                      tween: Tween(begin: 0.0, end: 1.0),
                      curve: Curves.elasticOut,
                      builder: (context, value, child) {
                        return Transform.scale(
                          scale: value,
                          child: child,
                        );
                      },
                      child: InkWell(
                        onTap: () {
                          SoundManager().playClick();
                          context.pop();
                        },
                        borderRadius: BorderRadius.circular(25),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: .2),
                            borderRadius: BorderRadius.circular(25),
                            border: Border.all(
                              color: Colors.white.withValues(alpha: .3),
                              width: 2,
                            ),
                          ),
                          child: Image.asset(
                            AppImages.arrowLeft,
                            width: 34,
                            height: 34,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 15),
                    TweenAnimationBuilder<double>(
                      duration: const Duration(milliseconds: 800),
                      tween: Tween(begin: 0.0, end: 1.0),
                      curve: Curves.easeOut,
                      builder: (context, value, child) {
                        return Opacity(
                          opacity: value,
                          child: Transform.translate(
                            offset: Offset(20 * (1 - value), 0),
                            child: child,
                          ),
                        );
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Pilih Level",
                            style: TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              shadows: [
                                Shadow(
                                  blurRadius: 10,
                                  color: Colors.black45,
                                  offset: Offset(2, 2),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            "Tantang kemampuanmu!",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white.withValues(alpha: .8),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 30),

                // Level cards
                Expanded(
                  child: ListView.separated(
                    physics: const BouncingScrollPhysics(),
                    itemCount: _levels.length,
                    separatorBuilder: (context, _) => const SizedBox(height: 20),
                    itemBuilder: (context, index) {
                      final level = _levels[index];
                      final isPressed = _pressedIndex == index;
                      final isSelected = _selectedIndex == index;

                      return TweenAnimationBuilder<double>(
                        duration: Duration(milliseconds: 400 + (index * 100)),
                        tween: Tween(begin: 0.0, end: 1.0),
                        curve: Curves.easeOutBack,
                        builder: (context, value, child) {
                          return Transform.scale(
                            scale: value,
                            child: Opacity(
                              opacity: value,
                              child: child,
                            ),
                          );
                        },
                        child: GestureDetector(
                          onTapDown: (_) => _onLevelTap(index),
                          onTapCancel: () {
                            setState(() => _pressedIndex = -1);
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            curve: Curves.easeOutBack,
                            transform: Matrix4.identity()
                              ..scale(
                                isPressed ? 0.95 : isSelected ? 1.02 : 1.0,
                                isPressed ? 0.95 : isSelected ? 1.02 : 1.0,
                                1.0,
                              )
                              ..rotateZ(isPressed ? -0.01 : 0.0),
                            child: Container(
                              height: 110,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: level['gradient'],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: isSelected
                                      ? Colors.white
                                      : Colors.white.withValues(alpha: .3),
                                  width: isSelected ? 3 : 2,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: level['color'].withOpacity(0.4),
                                    blurRadius: isSelected ? 20 : 10,
                                    offset: Offset(0, isSelected ? 8 : 4),
                                    spreadRadius: isSelected ? 2 : 0,
                                  ),
                                ],
                              ),
                              child: Stack(
                                children: [
                                  // Animated background pattern
                                  Positioned.fill(
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(18),
                                      child: CustomPaint(
                                        painter: PatternPainter(
                                          color: Colors.white.withValues(alpha: .1),
                                        ),
                                      ),
                                    ),
                                  ),
                                  // Content
                                  Padding(
                                    padding: const EdgeInsets.all(20),
                                    child: Row(
                                      children: [
                                        // Icon with animation
                                        Container(
                                          width: 60,
                                          height: 60,
                                          decoration: BoxDecoration(
                                            color: Colors.white.withValues(alpha: .3),
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                              color: Colors.white,
                                              width: 2,
                                            ),
                                          ),
                                          child: Icon(
                                            level['icon'],
                                            color: Colors.white,
                                            size: 32,
                                          ),
                                        ),
                                        const SizedBox(width: 20),
                                        // Text content
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                level['displayName'],
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 24,
                                                  fontWeight: FontWeight.bold,
                                                  letterSpacing: 1.2,
                                                  shadows: [
                                                    Shadow(
                                                      blurRadius: 8,
                                                      color: Colors.black38,
                                                      offset: Offset(1, 2),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              const SizedBox(height: 5),
                                              Text(
                                                level['description'],
                                                style: TextStyle(
                                                  color: Colors.white.withValues(alpha: .9),
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        // Difficulty stars
                                        Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: List.generate(
                                            3,
                                                (starIndex) => Padding(
                                              padding: const EdgeInsets.symmetric(vertical: 2),
                                              child: Icon(
                                                Icons.star,
                                                color: starIndex < level['difficulty']
                                                    ? Colors.amber
                                                    : Colors.white.withValues(alpha: .3),
                                                size: 18,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  // Selected indicator
                                  if (isSelected)
                                    Positioned(
                                      top: 10,
                                      right: 10,
                                      child: TweenAnimationBuilder<double>(
                                        duration: const Duration(milliseconds: 300),
                                        tween: Tween(begin: 0.0, end: 1.0),
                                        curve: Curves.elasticOut,
                                        builder: (context, value, child) {
                                          return Transform.scale(
                                            scale: value,
                                            child: child,
                                          );
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.all(6),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            shape: BoxShape.circle,
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black.withValues(alpha: .3),
                                                blurRadius: 8,
                                                offset: const Offset(0, 2),
                                              ),
                                            ],
                                          ),
                                          child: Icon(
                                            Icons.check,
                                            color: level['color'],
                                            size: 20,
                                          ),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 18),

                // Submit button with animation
                ScaleTransition(
                  scale: _bounceAnimation,
                  child: Container(
                    width: double.maxFinite,
                    height: 56,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppColors.primary,
                          AppColors.primary.withValues(alpha: .8),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: .5),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: ElevatedButton(
                      onPressed: _isSubmitting ? null : _onSubmit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: _isSubmitting
                          ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 3,
                        ),
                      )
                          : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "MULAI PERMAINAN",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              letterSpacing: 1.5,
                            ),
                          ),
                          const SizedBox(width: 10),
                          TweenAnimationBuilder<double>(
                            duration: const Duration(milliseconds: 800),
                            tween: Tween(begin: 0.0, end: 1.0),
                            curve: Curves.easeInOut,
                            builder: (context, value, child) {
                              return Transform.translate(
                                offset: Offset(5 * value, 0),
                                child: child,
                              );
                            },
                            child: const Icon(
                              Icons.arrow_forward,
                              color: Colors.white,
                              size: 24,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Custom painter for background pattern
class PatternPainter extends CustomPainter {
  final Color color;

  PatternPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    const spacing = 30.0;

    // Draw diagonal lines
    for (double i = -size.height; i < size.width + size.height; i += spacing) {
      canvas.drawLine(
        Offset(i, 0),
        Offset(i + size.height, size.height),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}