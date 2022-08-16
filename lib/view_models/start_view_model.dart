import 'package:flutter/material.dart';
import 'package:home_workout_app/main.dart';

class StartViewModel with ChangeNotifier {
  bool googleButton = true;

  changeGoogleButtonState() {
    googleButton = !googleButton;
    notifyListeners();
  }
}
