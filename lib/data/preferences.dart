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

  static Future<bool> getBackSound() async {
    try{
      final prefs = await SharedPreferences.getInstance();
      return prefs.getBool('backSound') ?? true;
    }catch(e){
      debugPrint('Terjadi kesalahan pada getBackSound: $e');
      return false;
    }
  }

  static Future<void> setBackSound(bool value) async {
    try{
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('backSound', value);
    }catch(e){
      debugPrint('Terjadi kesalahan pada setBackSound: $e');
    }
  }

  static Future<bool> getSoundEffect() async {
    try{
      final prefs = await SharedPreferences.getInstance();
      return prefs.getBool('soundEffect') ?? true;
    }catch(e){
      debugPrint('Terjadi kesalahan pada getSoundEffect: $e');
      return false;
    }
  }

  static Future<void> setSoundEffect(bool value) async {
    try{
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('soundEffect', value);
    }catch(e){
      debugPrint('Terjadi kesalahan pada setSoundEffect: $e');
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

      if(point < 500){
        return AppImages.beginner;
      } else if(point >= 500 && point < 1000) {
        return AppImages.intimidate;
      } else {
        return AppImages.expert;
      }

    } catch(e){
      debugPrint('Terjadi kesalahan pada getRank: $e');
      return AppImages.beginner;
    }
  }

  static Future<void> setLevel(int point) async {
    try{
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('level', point);
    }catch(e){
      debugPrint('Terjadi kesalahan pada setLevel: $e');
    }
  }

  static Future<int> getLevel() async {
    try{
      final prefs = await SharedPreferences.getInstance();
      return prefs.getInt('level') ?? 0;
    }catch(e){
      debugPrint('Terjadi kesalahan pada getLevel: $e');
      return 0;
    }
  }

  static Future<void> setChange(int point) async {
    try{
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('change', point);
    }catch(e){
      debugPrint('Terjadi kesalahan pada setLevel: $e');
    }
  }

  static Future<int> getChange() async {
    try{
      final prefs = await SharedPreferences.getInstance();
      return prefs.getInt('change') ?? 10;
    }catch(e){
      debugPrint('Terjadi kesalahan pada getLevel: $e');
      return 10;
    }
  }

  static Future<void> clearData()async{
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }


}