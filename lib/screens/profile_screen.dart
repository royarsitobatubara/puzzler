import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:puzzlers/data/sound_manager.dart';
import 'package:puzzlers/data/user_provider.dart';
import 'package:puzzlers/helpers/app_images.dart';
import 'package:puzzlers/screens/layout/screen_layout.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late AnimationController _pulseController;
  late AnimationController _rotateController;
  late Animation<double> _fade;
  late Animation<Offset> _slide;
  late Animation<double> _pulse;
  late Animation<double> _rotate;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fade = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );

    _slide = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    ));

    // Pulse animation for avatar border
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat(reverse: true);

    _pulse = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    // Rotate animation for rank badge
    _rotateController = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    )..repeat();

    _rotate = Tween<double>(begin: 0, end: 1).animate(_rotateController);

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    _pulseController.dispose();
    _rotateController.dispose();
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
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
                    child: const Row(
                      children: [
                        Icon(
                          Icons.person,
                          color: Colors.white,
                          size: 28,
                        ),
                        SizedBox(width: 10),
                        Text(
                          "Profil Saya",
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
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 40),

              // Content
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: SlideTransition(
                    position: _slide,
                    child: Column(
                      children: [
                        // Avatar Section with fancy animation
                        TweenAnimationBuilder<double>(
                          duration: const Duration(milliseconds: 800),
                          tween: Tween(begin: 0.0, end: 1.0),
                          curve: Curves.elasticOut,
                          builder: (context, value, child) {
                            return Transform.scale(
                              scale: value,
                              child: child,
                            );
                          },
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              // Rotating glow effect
                              RotationTransition(
                                turns: _rotate,
                                child: Container(
                                  width: 160,
                                  height: 160,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    gradient: SweepGradient(
                                      colors: [
                                        Colors.blue.withValues(alpha: .3),
                                        Colors.purple.withValues(alpha: .3),
                                        Colors.pink.withValues(alpha: .3),
                                        Colors.blue.withValues(alpha: .3),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              // Pulsing border
                              ScaleTransition(
                                scale: _pulse,
                                child: Container(
                                  width: 150,
                                  height: 150,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    gradient: const LinearGradient(
                                      colors: [
                                        Colors.blue,
                                        Colors.purple,
                                      ],
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.blue.withValues(alpha: .5),
                                        blurRadius: 20,
                                        spreadRadius: 5,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              // Avatar
                              Container(
                                width: 140,
                                height: 140,
                                padding: const EdgeInsets.all(6),
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white,
                                ),
                                child: ClipOval(
                                  child: Selector<UserProvider, String>(
                                    selector: (_, prov) => prov.profile,
                                    builder: (_, value, _) => Image.asset(
                                      value.isEmpty ? AppImages.profile1 : value,
                                      width: 128,
                                      height: 128,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                              // Edit button badge
                              Positioned(
                                bottom: 5,
                                right: 5,
                                child: Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    onTap: () {
                                      SoundManager().playClick();
                                      context.push('/edit-photo');
                                    },
                                    borderRadius: BorderRadius.circular(20),
                                    child: Container(
                                      padding: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        gradient: const LinearGradient(
                                          colors: [
                                            Colors.blue,
                                            Colors.purple,
                                          ],
                                        ),
                                        shape: BoxShape.circle,
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.blue.withValues(alpha: .5),
                                            blurRadius: 10,
                                            spreadRadius: 2,
                                          ),
                                        ],
                                      ),
                                      child: const Icon(
                                        Icons.camera_alt,
                                        color: Colors.white,
                                        size: 20,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 40),

                        // Name Section
                        _buildInfoCard(
                          icon: Icons.person_outline,
                          iconColor: Colors.blue,
                          label: 'Nama Pengguna',
                          child: Row(
                            children: [
                              Expanded(
                                child: Selector<UserProvider, String>(
                                  selector: (_, prov) => prov.username,
                                  builder: (_, value, _) => Text(
                                    value,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  onTap: () {
                                    SoundManager().playClick();
                                    context.push('/edit-name');
                                  },
                                  borderRadius: BorderRadius.circular(12),
                                  child: Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: Colors.blue.withValues(alpha: .2),
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: Colors.blue.withValues(alpha: .4),
                                      ),
                                    ),
                                    child: const Icon(
                                      Icons.edit,
                                      size: 20,
                                      color: Colors.blue,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          index: 0,
                        ),

                        const SizedBox(height: 20),

                        // Rank Section
                        _buildInfoCard(
                          icon: Icons.emoji_events,
                          iconColor: Colors.amber,
                          label: 'Peringkat & Poin',
                          child: Row(
                            children: [
                              // Rank Badge
                              Selector<UserProvider, String>(
                                selector: (_, prov) => prov.rank,
                                builder: (_, value, _) => Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.amber.withValues(alpha: .4),
                                        blurRadius: 15,
                                        spreadRadius: 3,
                                      ),
                                    ],
                                  ),
                                  child: Image.asset(
                                    value.isEmpty ? AppImages.beginner : value,
                                    width: 80,
                                    height: 80,
                                  ),
                                ),
                              ),

                              const SizedBox(width: 20),

                              // Points
                              Expanded(
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 12,
                                  ),
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        Colors.amber.withValues(alpha: .2),
                                        Colors.orange.withValues(alpha: .2),
                                      ],
                                    ),
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(
                                      color: Colors.amber.withValues(alpha: .4),
                                      width: 2,
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Image.asset(
                                        AppImages.point,
                                        height: 36,
                                        width: 36,
                                      ),
                                      const SizedBox(width: 12),
                                      Selector<UserProvider, int>(
                                        selector: (_, prov) => prov.point,
                                        builder: (_, value, _) => Text(
                                          value.toString(),
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 28,
                                            fontWeight: FontWeight.bold,
                                            shadows: [
                                              Shadow(
                                                color: Colors.black38,
                                                offset: Offset(1, 1),
                                                blurRadius: 2,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      const Text(
                                        'pts',
                                        style: TextStyle(
                                          color: Colors.white70,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          index: 1,
                        ),

                        const SizedBox(height: 20),

                        // Stats Card
                        _buildStatsCard(index: 2),

                        const SizedBox(height: 30),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required Color iconColor,
    required String label,
    required Widget child,
    required int index,
  }) {
    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 600 + (index * 100)),
      tween: Tween(begin: 0.0, end: 1.0),
      curve: Curves.easeOutBack,
      builder: (context, value, cardChild) {
        return Transform.translate(
          offset: Offset(30 * (1 - value), 0),
          child: Opacity(
            opacity: value,
            child: cardChild,
          ),
        );
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.white.withValues(alpha: .15),
              Colors.white.withValues(alpha: .08),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Colors.white.withValues(alpha: .3),
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: .2),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: iconColor.withValues(alpha: .2),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: iconColor.withValues(alpha: .5),
                      width: 2,
                    ),
                  ),
                  child: Icon(
                    icon,
                    color: iconColor,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.white.withValues(alpha: .8),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            child,
          ],
        ),
      ),
    );
  }

  Widget _buildStatsCard({required int index}) {
    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 600 + (index * 100)),
      tween: Tween(begin: 0.0, end: 1.0),
      curve: Curves.easeOutBack,
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(30 * (1 - value), 0),
          child: Opacity(
            opacity: value,
            child: child,
          ),
        );
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.purple.withValues(alpha: .2),
              Colors.blue.withValues(alpha: .2),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Colors.purple.withValues(alpha: .4),
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.purple.withValues(alpha: .2),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.purple.withValues(alpha: .2),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.purple.withValues(alpha: .5),
                      width: 2,
                    ),
                  ),
                  child: const Icon(
                    Icons.analytics,
                    color: Colors.purple,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  'Statistik',
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.white.withValues(alpha: .8),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem(
                  Icons.sports_esports,
                  'Games',
                  '0',
                  Colors.green,
                ),
                _buildStatItem(
                  Icons.check_circle,
                  'Completed',
                  '0',
                  Colors.blue,
                ),
                _buildStatItem(
                  Icons.flash_on,
                  'Best Time',
                  '--',
                  Colors.orange,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(IconData icon, String label, String value, Color color) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withValues(alpha: .2),
            shape: BoxShape.circle,
            border: Border.all(
              color: color.withValues(alpha: .4),
              width: 2,
            ),
          ),
          child: Icon(
            icon,
            color: color,
            size: 24,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withValues(alpha: .7),
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}