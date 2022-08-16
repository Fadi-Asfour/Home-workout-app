// ignore_for_file: curly_braces_in_flow_control_structures, use_build_context_synchronously

import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:home_workout_app/Api%20services/diet_api.dart';
import 'package:home_workout_app/components.dart';

class CreateDietViewModel with ChangeNotifier {
  bool _isLoading = false;
  List<List> _mealsId = [];

  void addDayToMeals(BuildContext context) {
    if (_mealsId.length >= 7) {
      showSnackbar(Text("You can't add more than 7 days").tr(), context);
      return;
    }
    _mealsId.add([]);
    notifyListeners();
  }

  void addToMeals(int i, int day) {
    if (!_mealsId[day].contains(i)) _mealsId[day].add(i);
    notifyListeners();
  }

  void deleteDay(int day) {
    _mealsId.removeAt(day);
    notifyListeners();
  }

  void removeFromMeals(int i, int day) {
    _mealsId[day].removeWhere((element) => element == i);
    if (_mealsId[day].isEmpty) deleteDay(day);
    notifyListeners();
  }

  Future<void> createMeal(
      {required String name,
      required BuildContext context,
      required String lang}) async {
    if (getMeals.isEmpty) {
      showSnackbar(Text('Meals cannot be empty').tr(), context);
      return;
    }
    for (int i = 0; i < getMeals.length; i++) {
      if (getMeals[i].isEmpty) {
        log('ttttt');
        showSnackbar(Text('Meals cannot be empty').tr(), context);
        return;
      }
    }
    setIsLoading(true);

    final response =
        await DietAPI().createDiet(name: name, meals: getMeals, lang: lang);
    if (response['success']) {
      showSnackbar(Text(response['message'].toString()), context);
      Navigator.pop(context);
    } else {
      showSnackbar(Text(response['message'].toString()), context);
    }
    setIsLoading(false);
  }

  void reset() {
    _mealsId = [];
    _isLoading = false;
    notifyListeners();
  }

  void setIsLoading(value) {
    _isLoading = value;
    notifyListeners();
  }

  bool get getIsLoading => _isLoading;
  List<List> get getMeals => _mealsId;
}
