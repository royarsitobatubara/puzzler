import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:puzzlers/data/preferences.dart';
import 'package:puzzlers/helpers/app_images.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  String? _msg;
  final TextEditingController _usernameController = TextEditingController();

  Future<void> _submitHandle() async {
    try{
      if(_usernameController.text.trim().isEmpty){
        setState(() {
          _msg = 'Username is required!';
        });
        return;
      }
      await Preferences.setIsLogin(true);
      await Preferences.setUsername(_usernameController.text);
      if(!mounted) return;
      context.go('/splash');
    }catch(e){
      debugPrint('Terjadi kesalahan pada _submitHandle: $e');
    }
  }
  @override
  void dispose() {
    _usernameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(AppImages.background),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: [
            Container(
              color: Colors.black.withValues(alpha: .4),
            ),
            Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 28),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Logo
                      Image.asset(
                        AppImages.logo,
                        width: 140,
                      ),

                      const SizedBox(height: 40),

                      // Username
                      TextField(
                        style: const TextStyle(color: Colors.white),
                        controller: _usernameController,
                        decoration: InputDecoration(
                          hintText: "Username",
                          hintStyle: const TextStyle(color: Colors.white70),
                          filled: true,
                          fillColor: Colors.white.withValues(alpha: .15),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide.none,
                          ),
                          prefixIcon: const Icon(Icons.person, color: Colors.white70),
                        ),
                      ),
                      if(_msg != null)
                        Align(
                            alignment: Alignment.centerRight,
                            child: const Text('Username is required!', style: TextStyle(
                                color: Colors.redAccent,
                                fontWeight: FontWeight.bold,
                                fontSize: 16
                            ),)
                        ),

                      const SizedBox(height: 50),

                      // Login Button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            backgroundColor: Colors.tealAccent.shade400,
                            shadowColor: Colors.black87,
                            elevation: 8,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          onPressed: ()=>_submitHandle(),
                          child: const Text(
                            "SUBMIT",
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              letterSpacing: 1,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
