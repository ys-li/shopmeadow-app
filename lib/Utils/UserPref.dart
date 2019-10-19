
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

class UserPref{
  static bool _langChinese = true;
  static bool get langChinese => _langChinese;
  static set langChinese(bool value){
    _langChinese = value;
    save();
  }


  static Future save() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('chinese', _langChinese);
    prefs.commit();
  }

  static Future<bool> load() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _langChinese = prefs.getBool('chinese') ?? true;
    return _langChinese;
  }

}