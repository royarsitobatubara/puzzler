import 'package:flutter/cupertino.dart';
import 'package:puzzlers/data/preferences.dart';

class UserProvider extends ChangeNotifier {

  String _username='';
  String _profile='';
  String _rank='';
  bool _backSound = false;
  int _point=0;

  String get username => _username;
  String get profile => _profile;
  String get rank => _rank;
  bool get backSound => _backSound;
  int get point => _point;

  UserProvider(){
    getName();
    getPoint();
    getProfile();
    getBackSound();
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


}