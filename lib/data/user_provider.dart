import 'package:flutter/cupertino.dart';
import 'package:puzzlers/data/preferences.dart';

class UserProvider extends ChangeNotifier {

  String _username='';
  String _profile='';
  String _rank='';
  bool _backSound = true;
  bool _soundEffect = true;
  int _point=0;
  int _level = 1;
  int _change = 10;

  String get username => _username;
  String get profile => _profile;
  String get rank => _rank;
  bool get backSound => _backSound;
  bool get soundEffect => _soundEffect;
  int get point => _point;
  int get level => _level;
  int get change => _change;

  UserProvider(){
    getName();
    getPoint();
    getProfile();
    getBackSound();
    getSoundEffect();
    getLevel();
    getChange();
  }

  void changeName(String username)async{
    await Preferences.setUsername(username);
    _username = username;
    ChangeNotifier();
  }
  void getName() async{
    _username = await Preferences.getUsername();
    notifyListeners();
  }

  void changeProfile(String profile)async{
    await Preferences.setProfile(username);
    _profile = profile;
    ChangeNotifier();
  }
  void getProfile() async{
    _profile = await Preferences.getProfile();
    notifyListeners();
  }

  void changePoint(int point)async{
    await Preferences.setPoint(point);
    _point = point;
    ChangeNotifier();
  }
  void getPoint() async{
    _point = await Preferences.getPoint();
    _rank = await Preferences.getRank();
    notifyListeners();
  }

  void getBackSound() async {
    _backSound = await Preferences.getBackSound();
    notifyListeners();
  }

  Future<void> toggleBackSound() async {
    _backSound = !_backSound;
    await Preferences.setBackSound(_backSound);
    notifyListeners();
  }

  void getLevel() async {
    final data = await Preferences.getLevel();
    _level = data;
    notifyListeners();
  }

  void getSoundEffect() async {
    final data = await Preferences.getSoundEffect();
    _soundEffect = data;
    notifyListeners();
  }

  void getChange() async {
    final data = await Preferences.getChange();
    _change = data;
    notifyListeners();
  }

}