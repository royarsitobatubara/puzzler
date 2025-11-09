import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:puzzlers/data/sound_manager.dart';
import 'package:puzzlers/helpers/app_images.dart';
import 'package:puzzlers/screens/layout/screen_layout.dart';

class InfoScreen extends StatefulWidget {
  const InfoScreen({super.key});

  @override
  State<InfoScreen> createState() => _InfoScreenState();
}

class _InfoScreenState extends State<InfoScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fade;
  late Animation<Offset> _slide;

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
                          Icons.info_outline,
                          color: Colors.white,
                          size: 28,
                        ),
                        SizedBox(width: 10),
                        Text(
                          "Informasi",
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

              const SizedBox(height: 30),

              // Content
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: SlideTransition(
                    position: _slide,
                    child: Column(
                      children: [
                        // Rank Section
                        _buildSectionCard(
                          icon: Icons.emoji_events,
                          iconColor: Colors.amber,
                          title: 'Peringkat Pemain',
                          child: Column(
                            children: [
                              _buildRankItem(
                                image: AppImages.beginner,
                                title: 'Beginner',
                                subtitle: 'Pemula',
                                points: '100',
                                color: Colors.green,
                                index: 0,
                              ),
                              const SizedBox(height: 12),
                              _buildRankItem(
                                image: AppImages.intimidate,
                                title: 'Intermediate',
                                subtitle: 'Menengah',
                                points: '500',
                                color: Colors.orange,
                                index: 1,
                              ),
                              const SizedBox(height: 12),
                              _buildRankItem(
                                image: AppImages.expert,
                                title: 'Expert',
                                subtitle: 'Ahli',
                                points: '1000',
                                color: Colors.red,
                                index: 2,
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 20),

                        // How to Play Section
                        _buildSectionCard(
                          icon: Icons.help_outline,
                          iconColor: Colors.blue,
                          title: 'Cara Bermain',
                          child: Column(
                            children: [
                              _buildHowToItem(
                                icon: Icons.play_circle_outline,
                                title: 'Mulai Permainan',
                                description:
                                'Tekan tombol PLAY untuk memulai',
                                index: 0,
                              ),
                              const SizedBox(height: 16),
                              _buildHowToItem(
                                icon: Icons.grid_4x4,
                                title: 'Pilih Level',
                                description:
                                'Pilih tingkat kesulitan: Mudah, Sedang, atau Sulit',
                                index: 1,
                              ),
                              const SizedBox(height: 16),
                              _buildHowToItem(
                                icon: Icons.timer,
                                title: 'Selesaikan Puzzle',
                                description:
                                'Susun puzzle dengan cepat sebelum waktu habis!',
                                index: 2,
                              ),
                              const SizedBox(height: 16),
                              _buildHowToItem(
                                icon: Icons.star,
                                title: 'Kumpulkan Poin',
                                description:
                                'Dapatkan poin untuk meningkatkan peringkatmu',
                                index: 3,
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 20),

                        // Tips Section
                        _buildSectionCard(
                          icon: Icons.lightbulb_outline,
                          iconColor: Colors.yellow,
                          title: 'Tips & Trik',
                          child: Column(
                            children: [
                              _buildTipItem(
                                '💡',
                                'Mulai dari sudut atau tepi puzzle',
                                0,
                              ),
                              _buildTipItem(
                                '⚡',
                                'Semakin cepat menyelesaikan, semakin banyak poin',
                                1,
                              ),
                              _buildTipItem(
                                '🎯',
                                'Kurangi jumlah gerakan untuk bonus poin',
                                2,
                              ),
                            ],
                          ),
                        ),

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

  Widget _buildSectionCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    required Widget child,
  }) {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 600),
      tween: Tween(begin: 0.0, end: 1.0),
      curve: Curves.easeOut,
      builder: (context, value, childWidget) {
        return Opacity(
          opacity: value,
          child: Transform.scale(
            scale: 0.95 + (0.05 * value),
            child: childWidget,
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
                  padding: const EdgeInsets.all(12),
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
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            child,
          ],
        ),
      ),
    );
  }

  Widget _buildRankItem({
    required String image,
    required String title,
    required String subtitle,
    required String points,
    required Color color,
    required int index,
  }) {
    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 400 + (index * 100)),
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
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withValues(alpha: .15),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: color.withValues(alpha: .3),
            width: 2,
          ),
        ),
        child: Row(
          children: [
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: color.withValues(alpha: .3),
                    blurRadius: 10,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Image.asset(
                image,
                width: 70,
                height: 70,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white.withValues(alpha: .7),
                    ),
                  ),
                ],
              ),
            ),
            Row(
              children: [
                Image.asset(
                  AppImages.point,
                  width: 32,
                  height: 32,
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: .3),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    points,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHowToItem({
    required IconData icon,
    required String title,
    required String description,
    required int index,
  }) {
    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 400 + (index * 100)),
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
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.blue.withValues(alpha: .6),
                  Colors.purple.withValues(alpha: .6),
                ],
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.blue.withValues(alpha: .3),
                  blurRadius: 8,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Icon(
              icon,
              color: Colors.white,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white.withValues(alpha: .8),
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTipItem(String emoji, String text, int index) {
    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 400 + (index * 100)),
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
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: .1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Colors.white.withValues(alpha: .2),
          ),
        ),
        child: Row(
          children: [
            Text(
              emoji,
              style: const TextStyle(fontSize: 24),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                text,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white.withValues(alpha: .9),
                  height: 1.4,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}