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
    with SingleTickerProviderStateMixin {

  late AnimationController _controller;
  late Animation<double> _fade;

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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  InkWell(
                    onTap: (){SoundManager().playClick(); context.pop();},
                    child: Image.asset(AppImages.arrowLeft,
                        width: 50, height: 50),
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    "Profile",
                    style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 25),

              Center(
                child: Column(
                  children: [
                    AnimatedScale(
                      duration: const Duration(milliseconds: 300),
                      scale: 1,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white24,
                        ),
                        child: ClipOval(
                          child: Selector<UserProvider, String>(
                            selector: (_, prov)=>prov.profile,
                            builder: (_, value, _)=>Image.asset(value.isEmpty ? AppImages.profile1 : value, width: 120, height: 120,),
                          ),
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: (){ SoundManager().playClick(); context.push('/edit-photo');},
                      child: const Text(
                        "Edit",
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    )
                  ],
                ),
              ),

              const SizedBox(height: 30),

              buildInfo(context, 'Name', false),
              buildInfo(context, 'Rank', true),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildInfo(
      BuildContext context,
      String label,
      bool isRank
      ){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 30),
        Text(
          label,
          style:const TextStyle(
            fontSize: 17,
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 10),
        Container(
            width: double.maxFinite,
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: .15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: isRank==false? Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Selector<UserProvider, String>(
                        selector: (_, prov)=>prov.username,
                        builder: (_, value, _)=>Text(value, style: const TextStyle(color: Colors.white)),
                      ),
                  IconButton(
                      onPressed: (){ SoundManager().playClick(); context.push('/edit-name');},
                      icon: const Icon(Icons.edit, size: 25, color: Colors.white,)
                  )
              ],
            ) : Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Selector<UserProvider, String>(
                  selector: (_, prov)=>prov.rank,
                  builder: (_, value, _)=>Image.asset(value.isEmpty ? AppImages.beginner : value, width: 70, height: 70,),
                ),
                Row(
                  children: [
                    Image.asset(AppImages.point, height: 30, width: 30,),
                    Selector<UserProvider, int>(
                      selector: (_, prov)=>prov.point,
                      builder: (_, value, _)=>Text(value.toString(), style: const TextStyle(color: Colors.white)),
                    ),
                  ],
                ),

              ],
            )
        ),
      ],
    );
  }
}
