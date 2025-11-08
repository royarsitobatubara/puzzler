import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:puzzlers/data/preferences.dart';
import 'package:puzzlers/data/sound_manager.dart';
import 'package:puzzlers/data/user_provider.dart';
import 'package:puzzlers/helpers/app_colors.dart';
import 'package:puzzlers/helpers/app_images.dart';
import 'package:puzzlers/screens/layout/screen_layout.dart';

class EditPhotoScreen extends StatefulWidget {
  const EditPhotoScreen({super.key});

  @override
  State<EditPhotoScreen> createState() => _EditPhotoScreenState();
}

class _EditPhotoScreenState extends State<EditPhotoScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fade;
  int _currentIndex = 0;


  Future<void> _handleSubmit() async {
    SoundManager().playClick();
    await Preferences.setProfile(AppImages.profileList[_currentIndex]);
    if(!mounted)return;
    context.read<UserProvider>().getProfile();
    context.pop();
  }


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
          child: Column(children: [
            Row(
              children: [
                InkWell(
                  onTap: (){SoundManager().playClick(); context.pop();},
                  child: Image.asset(AppImages.arrowLeft,
                      width: 50, height: 50),
                ),
                const SizedBox(width: 10),
                const Text(
                  "Edit Photo",
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white
                  ),
                ),
              ],
            ),
            const SizedBox(height: 25),
            Expanded(
              child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      childAspectRatio: 1,
                      mainAxisSpacing: 15,
                      crossAxisSpacing: 5
                  ),
                  itemCount: AppImages.profileList.length,
                  itemBuilder: (context, index){
                    return GestureDetector(
                      onTap: (){
                        setState(() {
                          _currentIndex = index;
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: _currentIndex == index ? Colors.white.withValues(alpha: .8) : AppColors.primary,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: _currentIndex == index ? Colors.white.withValues(alpha: .5) : AppColors.primary.withValues(alpha: .7),
                              offset: const Offset(0, 8)
                            )
                          ]
                        ),
                        child: ClipOval(
                          child: Image.asset(AppImages.profileList[index]),
                        ),
                      ),
                    );
                  }
              ),
            ),
            const Spacer(),
            SizedBox(
              width: double.maxFinite,
              child: ElevatedButton(
                onPressed: ()=>_handleSubmit(),
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
          ],),
        ),
      ),
    );
  }
}
