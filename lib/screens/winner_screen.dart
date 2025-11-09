import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:puzzlers/data/preferences.dart';
import 'package:puzzlers/data/user_provider.dart';
import 'package:puzzlers/helpers/app_colors.dart';

class WinnerScreen extends StatefulWidget {
  final String timer;
  final int move;
  final String level;

  const WinnerScreen({
    super.key,
    required this.level,
    required this.timer,
    required this.move,
  });

  @override
  State<WinnerScreen> createState() => _WinnerScreenState();
}

class _WinnerScreenState extends State<WinnerScreen>
    with TickerProviderStateMixin {
  late AnimationController _mainController;
  late AnimationController _starController;
  late AnimationController _confettiController;

  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    _mainController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _starController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);

    _confettiController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat();

    _scaleAnimation = CurvedAnimation(
      parent: _mainController,
      curve: Curves.elasticOut,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _mainController, curve: Curves.easeIn),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _mainController, curve: Curves.easeOut));

    _mainController.forward();
  }

  @override
  void dispose() {
    _mainController.dispose();
    _starController.dispose();
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Gradient Background
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.primary,
                  AppColors.primary.withValues(alpha: .8),
                  const Color(0xFF1a237e),
                ],
              ),
            ),
          ),

          // Animated Confetti Background
          ...List.generate(20, (index) => _buildConfetti(index)),

          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Trophy Icon with Animation
                      ScaleTransition(
                        scale: _scaleAnimation,
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.amber.withValues(alpha: .2),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.amber.withValues(alpha: .3),
                                blurRadius: 30,
                                spreadRadius: 10,
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.emoji_events,
                            size: 80,
                            color: Colors.amber,
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Title with Stars
                      FadeTransition(
                        opacity: _fadeAnimation,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _buildStar(),
                            const SizedBox(width: 12),
                            const Text(
                              'VICTORY!',
                              style: TextStyle(
                                fontSize: 40,
                                fontWeight: FontWeight.w900,
                                color: Colors.white,
                                letterSpacing: 3,
                                shadows: [
                                  Shadow(
                                    color: Colors.black26,
                                    offset: Offset(2, 2),
                                    blurRadius: 4,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 12),
                            _buildStar(),
                          ],
                        ),
                      ),

                      const SizedBox(height: 8),

                      FadeTransition(
                        opacity: _fadeAnimation,
                        child: const Text(
                          'CONGRATULATIONS!',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.white70,
                            letterSpacing: 2,
                          ),
                        ),
                      ),

                      const SizedBox(height: 30),

                      // Avatar with Glow Effect
                      SlideTransition(
                        position: _slideAnimation,
                        child: Hero(
                          tag: "winnerAvatar",
                          child: Selector<UserProvider, String>(
                            selector: (_, prov) => prov.profile,
                            builder: (_, value, __) => Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.white.withValues(alpha: .3),
                                    blurRadius: 20,
                                    spreadRadius: 5,
                                  ),
                                ],
                                border: Border.all(
                                  color: Colors.amber,
                                  width: 4,
                                ),
                              ),
                              child: ClipOval(
                                child: Image.asset(
                                  value,
                                  width: 130,
                                  height: 130,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Username
                      FadeTransition(
                        opacity: _fadeAnimation,
                        child: Selector<UserProvider, String>(
                          selector: (_, prov) => prov.username,
                          builder: (_, value, __) => Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: .15),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: Colors.white.withValues(alpha: .3),
                              ),
                            ),
                            child: Text(
                              value,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w800,
                                fontSize: 24,
                              ),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 30),

                      // Stats Card with Glass Effect
                      SlideTransition(
                        position: _slideAnimation,
                        child: Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.white.withValues(alpha: .2),
                                Colors.white.withValues(alpha: .1),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(
                              color: Colors.white.withValues(alpha: .3),
                              width: 2,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: .1),
                                blurRadius: 20,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              buildStat(Icons.stars, "Level", widget.level, Colors.amber),
                              const Divider(color: Colors.white24, height: 24),
                              buildStat(Icons.timer, "Time", widget.timer, Colors.blue),
                              const Divider(color: Colors.white24, height: 24),
                              buildStat(Icons.touch_app, "Moves", widget.move.toString(), Colors.green),
                              const Divider(color: Colors.white24, height: 24),
                              buildStat(Icons.star, "Points", "10", Colors.orange),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 30),

                      // Buttons Row
                      FadeTransition(
                        opacity: _fadeAnimation,
                        child:SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: ()async{
                              final oldPoint = await Preferences.getPoint();
                              await Preferences.setPoint(oldPoint + 10);
                              if(!context.mounted)return;
                              context.read<UserProvider>().getPoint();
                              context.go('/home');
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.greenAccent
                            ),
                            child: const Text('Submit', style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              color: Colors.black
                          ),)),
                        )
                      ),

                      const SizedBox(height: 16),


                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStar() {
    return RotationTransition(
      turns: _starController,
      child: const Icon(
        Icons.star,
        color: Colors.amber,
        size: 30,
      ),
    );
  }

  Widget _buildConfetti(int index) {
    final random = (index * 137.5) % 360;
    final leftPosition = (index * 50.0) % MediaQuery.of(context).size.width;

    return AnimatedBuilder(
      animation: _confettiController,
      builder: (context, child) {
        final value = _confettiController.value;
        return Positioned(
          left: leftPosition,
          top: -50 + (MediaQuery.of(context).size.height * value),
          child: Transform.rotate(
            angle: value * 6.28 + random,
            child: Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                color: Colors.primaries[index % Colors.primaries.length]
                    .withValues(alpha: .7),
                shape: index % 2 == 0 ? BoxShape.circle : BoxShape.rectangle,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget buildStat(IconData icon, String label, String value, Color color) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: color.withValues(alpha: .2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Text(
            label,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: .15),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}