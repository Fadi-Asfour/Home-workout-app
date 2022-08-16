// ignore_for_file: curly_braces_in_flow_control_structures

import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:home_workout_app/main.dart';

class SettingsViewModel with ChangeNotifier {
  bool _isEnglish = true;
  bool isLight = true;
  bool isSetted = false;

  void setIsSetted(value) {
    isSetted = true;
    //notifyListeners();
  }

  void setLang(BuildContext context) {
    log(context.locale.toString());
    if (context.locale == Locale('en')) {
      context.setLocale(Locale('ar'));
    } else {
      context.setLocale(Locale('en'));
    }
    log(context.locale.toString());

    _isEnglish = context.locale == const Locale('en') ? true : false;

    notifyListeners();
  }

  void setLangFirstTime(BuildContext context) {
    if (context.locale == Locale('en')) {
      context.setLocale(Locale('en'));
    } else {
      context.setLocale(Locale('ar'));
    }
    log(context.locale.toString());

    _isEnglish = context.locale == const Locale('en') ? true : false;
    notifyListeners();
  }

  void setTheme(BuildContext context) {
    log(context.locale.toString());
    if (sharedPreferences.getString('theme') == 'dark') {
      isLight = true;
      sharedPreferences.setString('theme', 'light');
    } else {
      sharedPreferences.setString('theme', 'dark');
      isLight = false;
    }

    notifyListeners();
  }

  void setThemeFirstTime() {
    if (getIsSetted) return;
    if (sharedPreferences.getString('theme') == 'dark') {
      isLight = false;
      sharedPreferences.setString('theme', 'dark');
    } else {
      sharedPreferences.setString('theme', 'light');
      isLight = true;
    }
    setIsSetted(true);
    notifyListeners();

    //notifyListeners();
  }

  bool get getLang => _isEnglish;
  bool get getTheme => isLight;
  bool get getIsSetted => isSetted;
}
