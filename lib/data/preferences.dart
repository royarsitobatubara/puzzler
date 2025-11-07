import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Preferences {

  static Future<bool> getIsLogin() async {
    try{
      final prefs = await SharedPreferences.getInstance();
      return prefs.getBool('isLogin') ?? false;
    }catch(e){
      debugPrint('Terjadi kesalahan pada getIsLogin: $e');
      return false;
    }
  }

  static Future<void> setIsLogin(bool isLogin) async {
    try{
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLogin', isLogin);
    }catch(e){
      debugPrint('Terjadi kesalahan pada setIsLogin: $e');
    }
  }

  static Future<void> setUsername(String username) async {
    try{
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('username', username);
    }catch(e){
      debugPrint('Terjadi kesalahan pada setUsername: $e');
    }
  }

  static Future<String> getUsername() async {
    try{
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString('username') ?? 'Guest';
    }catch(e){
      debugPrint('Terjadi kesalahan pada getUsername: $e');
      return 'Guest';
    }
  }

}