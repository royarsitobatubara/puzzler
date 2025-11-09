import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:puzzlers/data/sound_manager.dart';
import 'package:puzzlers/data/user_provider.dart';
import 'package:puzzlers/helpers/app_images.dart';
import 'package:puzzlers/screens/layout/screen_layout.dart';

class LevelPuzzleScreen extends StatelessWidget {
  const LevelPuzzleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenLayout(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            // NAVBAR
            Row(
              children: [
                InkWell(
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
                const SizedBox(width: 10),
                const Row(
                  children: [
                    Icon(
                      Icons.star,
                      color: Colors.white,
                      size: 28,
                    ),
                    SizedBox(width: 10),
                    Text(
                      "Level",
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
              ],
            ),

            const SizedBox(height: 20),

            Expanded(
              child: Selector<UserProvider, int>(
                selector: (_, prov)=>prov.level,
                builder: (_, value, _) {
                  return GridView.builder(
                    physics: const BouncingScrollPhysics(),
                    gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      childAspectRatio: 1,
                    ),
                    itemCount: 12,
                    itemBuilder: (context, index) {
                      final level = index + 1;
                      final isLocked = level > value;
                      return GestureDetector(
                        onTap: (level > value + 1)
                            ? null
                            : () {
                          SoundManager().playClick();
                          context.push('/puzzle', extra: {
                            'level': level.toString(),
                            'count': level + 1
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: isLocked
                                ? Colors.grey.withValues(alpha: .4)
                                : Colors.white,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: isLocked
                                  ? Colors.grey
                                  : Colors.lightBlueAccent,
                              width: 2,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: .15),
                                blurRadius: 6,
                                offset: const Offset(2, 2),
                              )
                            ],
                          ),
                          child: Center(
                            child: (level > value + 1)
                                ? const Icon(
                              Icons.lock,
                              color: Colors.black54,
                              size: 28,
                            )
                                : Text(
                              '$level',
                              style: const TextStyle(
                                fontSize: 32,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
