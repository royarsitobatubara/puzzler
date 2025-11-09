import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:puzzlers/data/preferences.dart';
import 'package:puzzlers/data/sound_manager.dart';
import 'package:puzzlers/data/user_provider.dart';
import 'package:puzzlers/helpers/app_images.dart';
import 'package:puzzlers/screens/layout/screen_layout.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fade;
  late Animation<Offset> _slide;

  bool _isBgMusicEnabled = true;
  bool _isSfxEnabled = true;

  Future<void> getActiveButton() async {
    final sfx = await Preferences.getSoundEffect();
    final sound = await Preferences.getBackSound();
    setState(() {
      _isBgMusicEnabled = sound;
      _isSfxEnabled = sfx;
    });
  }

  @override
  void initState() {
    super.initState();
    getActiveButton();
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

  void _toggleBgMusic(bool value)async {
    setState(() => _isBgMusicEnabled = value);
    if (value) {
      SoundManager().resumeBackground();
    } else {
      SoundManager().pauseBackground();
    }
    SoundManager().playClick();
    await Preferences.setBackSound(value);
  }

  void _toggleSfx(bool value) async {
    setState(() => _isSfxEnabled = value);
    SoundManager().toggleSound();
    if (value) {
      SoundManager().playClick();
    }
    await Preferences.setSoundEffect(value);
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
                          Icons.settings,
                          color: Colors.white,
                          size: 28,
                        ),
                        SizedBox(width: 10),
                        Text(
                          "Pengaturan",
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
                        // Sound Settings Section
                        _buildSectionCard(
                          icon: Icons.volume_up,
                          iconColor: Colors.purple,
                          title: 'Pengaturan Suara',
                          child: Column(
                            children: [
                              _buildToggleItem(
                                icon: Icons.music_note,
                                title: 'Musik Latar',
                                subtitle: 'Background music',
                                value: _isBgMusicEnabled,
                                onChanged: _toggleBgMusic,
                                color: Colors.blue,
                                index: 0,
                              ),
                              const SizedBox(height: 16),
                              _buildToggleItem(
                                icon: Icons.speaker,
                                title: 'Efek Suara',
                                subtitle: 'Sound effects',
                                value: _isSfxEnabled,
                                onChanged: _toggleSfx,
                                color: Colors.green,
                                index: 1,
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 20),

                        // Account Settings Section
                        _buildSectionCard(
                          icon: Icons.person,
                          iconColor: Colors.orange,
                          title: 'Pengaturan Akun',
                          child: Column(
                            children: [
                              _buildMenuItemWithAvatar(
                                context: context,
                                index: 0,
                              ),
                              const SizedBox(height: 16),
                              _buildMenuItem(
                                icon: Icons.edit,
                                title: 'Edit Nama',
                                subtitle: 'Ubah nama pengguna',
                                color: Colors.blue,
                                onTap: () {
                                  SoundManager().playClick();
                                  context.push('/edit-name');
                                },
                                index: 1,
                              ),
                              const SizedBox(height: 16),
                              _buildMenuItem(
                                icon: Icons.photo_camera,
                                title: 'Edit Foto',
                                subtitle: 'Ubah foto profil',
                                color: Colors.purple,
                                onTap: () {
                                  SoundManager().playClick();
                                  context.push('/edit-photo');
                                },
                                index: 2,
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 20),

                        // About Section
                        _buildSectionCard(
                          icon: Icons.info_outline,
                          iconColor: Colors.cyan,
                          title: 'Tentang',
                          child: Column(
                            children: [
                              _buildInfoItem(
                                'Versi Aplikasi',
                                '1.0.0',
                                Icons.app_settings_alt,
                                0,
                              ),
                              const SizedBox(height: 12),
                              _buildInfoItem(
                                'Developer',
                                'Puzzlers Team',
                                Icons.code,
                                1,
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

  Widget _buildToggleItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required Function(bool) onChanged,
    required Color color,
    required int index,
  }) {
    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 400 + (index * 100)),
      tween: Tween(begin: 0.0, end: 1.0),
      curve: Curves.easeOutBack,
      builder: (context, animValue, child) {
        return Transform.translate(
          offset: Offset(30 * (1 - animValue), 0),
          child: Opacity(
            opacity: animValue,
            child: child,
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(16),
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
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    color.withValues(alpha: .6),
                    color.withValues(alpha: .4),
                  ],
                ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: color.withValues(alpha: .3),
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
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.white.withValues(alpha: .7),
                    ),
                  ),
                ],
              ),
            ),
            Transform.scale(
              scale: 0.9,
              child: Switch(
                value: value,
                onChanged: onChanged,
                activeThumbColor: color,
                activeTrackColor: color.withValues(alpha: .5),
                inactiveThumbColor: Colors.grey,
                inactiveTrackColor: Colors.grey.withValues(alpha: .3),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItemWithAvatar({
    required BuildContext context,
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
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.orange.withValues(alpha: .2),
              Colors.red.withValues(alpha: .1),
            ],
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Colors.orange.withValues(alpha: .3),
            width: 2,
          ),
        ),
        child: Row(
          children: [
            // User Avatar
            Selector<UserProvider, String>(
              selector: (_, prov) => prov.profile,
              builder: (_, profile, __) => Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.orange,
                    width: 3,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.orange.withValues(alpha: .4),
                      blurRadius: 10,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: ClipOval(
                  child: Image.asset(
                    profile,
                    width: 56,
                    height: 56,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Profil Saya',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Selector<UserProvider, String>(
                    selector: (_, prov) => prov.username,
                    builder: (_, username, __) => Text(
                      username,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.white.withValues(alpha: .7),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.account_circle,
              color: Colors.orange.withValues(alpha: .7),
              size: 28,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
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
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.all(16),
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
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        color.withValues(alpha: .6),
                        color.withValues(alpha: .4),
                      ],
                    ),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: color.withValues(alpha: .3),
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
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.white.withValues(alpha: .7),
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.white.withValues(alpha: .5),
                  size: 18,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoItem(String label, String value, IconData icon, int index) {
    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 400 + (index * 100)),
      tween: Tween(begin: 0.0, end: 1.0),
      curve: Curves.easeOutBack,
      builder: (context, animValue, child) {
        return Transform.translate(
          offset: Offset(30 * (1 - animValue), 0),
          child: Opacity(
            opacity: animValue,
            child: child,
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: .1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Colors.white.withValues(alpha: .2),
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: Colors.cyan,
              size: 24,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white.withValues(alpha: .8),
                ),
              ),
            ),
            Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}