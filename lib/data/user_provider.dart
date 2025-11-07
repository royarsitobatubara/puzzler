import 'package:flutter/cupertino.dart';
import 'package:puzzlers/data/preferences.dart';

class UserProvider extends ChangeNotifier {

  String _username='';
  String _profile='';
  String _rank='';
  int _point=0;

  String get username => _username;
  String get profile => _profile;
  String get rank => _rank;
  int get point => _point;

  UserProvider(){
    getName();
    getPoint();
    getProfile();
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

}