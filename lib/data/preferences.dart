import 'package:flutter/cupertino.dart';
import 'package:puzzlers/helpers/app_images.dart';
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

  static Future<void> setProfile(String profile) async {
    try{
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('profile', profile);
    }catch(e){
      debugPrint('Terjadi kesalahan pada setProfile: $e');
    }
  }

  static Future<String> getProfile() async {
    try{
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString('profile') ?? AppImages.profile1;
    }catch(e){
      debugPrint('Terjadi kesalahan pada getProfile: $e');
      return 'Guest';
    }
  }

  static Future<void> setPoint(int point) async {
    try{
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('point', point);
    }catch(e){
      debugPrint('Terjadi kesalahan pada setPoint: $e');
    }
  }

  static Future<int> getPoint() async {
    try{
      final prefs = await SharedPreferences.getInstance();
      return prefs.getInt('point') ?? 0;
    }catch(e){
      debugPrint('Terjadi kesalahan pada getPoint: $e');
      return 0;
    }
  }

  static Future<void> setRank(String image) async {
    try{
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('rank', image);
    }catch(e){
      debugPrint('Terjadi kesalahan pada setRank: $e');
    }
  }

  static Future<String> getRank() async {
    try{
      final point = await getPoint();

      if(point < 100){
        return AppImages.beginner;
      } else if(point >= 100 && point < 500) {
        return AppImages.intimidate;
      } else {
        return AppImages.expert;
      }

    } catch(e){
      debugPrint('Terjadi kesalahan pada getRank: $e');
      return AppImages.beginner;
    }
  }


}