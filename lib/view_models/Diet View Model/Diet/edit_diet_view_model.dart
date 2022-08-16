// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:home_workout_app/Api%20services/diet_api.dart';
import 'package:home_workout_app/components.dart';
import 'package:home_workout_app/models/meal_model.dart';

class EditDietViewModel with ChangeNotifier {
  bool _isLoading = false;
  List<List> _mealsId = [];
  List<int> _addedMealsId = [];
  List<int> _deletedMealsId = [];

  void setIsLoading(value) {
    _isLoading = value;
    notifyListeners();
  }

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

  void initMealsList(List meals) {
    _mealsId.clear();
    meals.forEach((element) {
      List<int> m = [];

      List mealData = element['meals'] as List;

      mealData.forEach((element) {
        m.add(element.id);
      });
      _mealsId.add(m);
    });

    print(_mealsId);
    notifyListeners();
  }

  void addToDeletedMealsId(int i) {
    if (!_deletedMealsId.contains(i)) _deletedMealsId.add(i);
    notifyListeners();
  }

  void addToAddedMealsId(int i) {
    if (!_addedMealsId.contains(i)) _addedMealsId.add(i);
    notifyListeners();
  }

  Future<void> editDiet(
      {required String lang,
      required String name,
      required int id,
      required BuildContext context}) async {
    log('Meals: $getMeals');

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
    final response = await DietAPI()
        .updateDiet(id: id, meals: getMeals, lang: lang, name: name);
    if (response['success']) {
      showSnackbar(Text(response['message'].toString()), context);
      Navigator.pop(context);
    } else {
      showSnackbar(Text(response['message'].toString()), context);
    }
    setIsLoading(false);
  }

  bool get getIsLoading => _isLoading;
  List<List> get getMeals => _mealsId;
  List<int> get getAddedMealsId => _addedMealsId;
}
