// ignore_for_file: use_build_context_synchronously

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:home_workout_app/Api%20services/meal_api.dart';
import 'package:home_workout_app/components.dart';
import 'package:home_workout_app/models/food_model.dart';
import 'package:home_workout_app/models/meal_model.dart';
import 'package:home_workout_app/view_models/Diet%20View%20Model/Meal/meal_list_view_model.dart';
import 'package:provider/provider.dart';

class EditMealViewModel with ChangeNotifier {
  bool _isLoading = false;
  List<int> _foods = [];

  void reset() {
    _foods.clear();
    _isLoading = false;
  }

  void setPickedFoods(List<int> ids) {
    _foods.addAll(ids);
    notifyListeners();
  }

  void addToFoods(int i) {
    if (!_foods.contains(i)) _foods.add(i);
    notifyListeners();
  }

  void removeFromFoods(int i) {
    if (_foods.contains(i)) _foods.removeWhere((element) => element == i);
    notifyListeners();
  }

  void setIsLoading(value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<void> editMeal(
      {required String lang,
      required int id,
      required String desc,
      required BuildContext context,
      required String type}) async {
    setIsLoading(true);
    final response = await MealAPI().editMeal(
        type: type, desc: desc, foodsIDs: getPickedFoods, lang: lang, id: id);

    if (response['success']) {
      showSnackbar(Text(response['message'].toString()).tr(), context);
      // Provider.of<MealsListViewModel>(context, listen: false)
      //     .editMeal(meal: response['data'] ?? MealModel());
      Navigator.pop(context);
    } else {
      showSnackbar(Text(response['message'].toString()).tr(), context);
    }
    setIsLoading(false);
  }

  bool get getIsLoading => _isLoading;
  List<int> get getPickedFoods => _foods;
}
