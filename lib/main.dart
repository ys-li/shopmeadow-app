import 'package:flutter/material.dart';
import 'Utils/lang.dart';
import 'UI/splash_screen.dart';
import 'Utils/Favourites.dart';
import 'Utils/DataVersionControl.dart';
import 'Utils/UserPref.dart';
import 'Utils/UserStat.dart';
import 'Utils/Categories.dart';
import 'dart:async';
import 'Utils/utils.dart';
import 'UI/main_screen.dart';

void main() {

  GlobalKey<Splash_ScreenState> _splashKey = new GlobalKey<Splash_ScreenState>();

  runApp(new Splash_Screen(key: _splashKey));

  Future initAll() async {
    await utilsInit();
    await DataVersionControl.synchronise();
    //if (!DataVersionControl.serverUp) return false;
    await Favourites.initialise();
    await UserStat.load();
    await Categories.initialise(splashKey: _splashKey);
  }

  UserPref.load().then((c) async {
    IBLocale.setLanguage(c);
    await initAll();
    runApp(new MyApp());
  });
}


