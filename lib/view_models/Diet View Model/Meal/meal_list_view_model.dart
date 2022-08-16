// ignore_for_file: curly_braces_in_flow_control_structures, use_build_context_synchronously

import 'package:flutter/cupertino.dart';
import 'package:home_workout_app/Api%20services/meal_api.dart';
import 'package:home_workout_app/components.dart';
import 'package:home_workout_app/models/meal_model.dart';

class MealsListViewModel with ChangeNotifier {
  List<MealModel> _mealsList = [];
  bool _isLoading = false;
  bool _isDeleteLoading = false;
  int _page = 0;
  String _searchValue = '';

  void setSearchValue(value) {
    _searchValue = value;
    notifyListeners();
  }

  void setIsDeleteLoading(value) {
    _isDeleteLoading = value;
    notifyListeners();
  }

  void setIsLoading(value) {
    _isLoading = value;
    notifyListeners();
  }

  void setPage(i) {
    _page = i;
    notifyListeners();
  }

  void reset() {
    _page = 0;
    _mealsList.clear();
    _isLoading = false;
  }

  Future<void> getMeals({required String lang}) async {
    if (_mealsList.isNotEmpty) return;

    print('Called');
    setIsLoading(true);
    setPage(getPage + 1);
    final newMeals = await MealAPI().getMealsList(lang: lang, page: getPage);
    if (newMeals.isEmpty)
      setPage(getPage - 1);
    else
      _mealsList.addAll(newMeals);

    print(_mealsList);

    // _mealsList.add(MealModel.fromJson({
    //   'data': {
    //     'type': 'Breakfast',
    //     'id': 1,
    //     'day': 2,
    //     'user_id': 1,
    //     'calories': 250,
    //     'foods': [
    //       {
    //         'data': {
    //           'id': 1,
    //           'name': 'apple',
    //           'calories': 70,
    //           'image_url':
    //               'https://st2.depositphotos.com/7036298/10694/i/450/depositphotos_106948346-stock-photo-ripe-red-apple-with-green.jpg',
    //         }
    //       }
    //     ]
    //   }
    // }));

    setIsLoading(false);
  }

  Future<void> deleteMeal(
      {required String lang,
      required int mealId,
      required BuildContext context}) async {
    setIsDeleteLoading(true);
    final response = await MealAPI().deleteMeal(lang: lang, mealId: mealId);
    if (response['success']) {
      showSnackbar(Text(response['message']), context);
      _mealsList.removeWhere((element) => element.id == mealId);

      notifyListeners();
    } else {
      showSnackbar(Text(response['message']), context);
    }
    setIsDeleteLoading(false);
  }

  void editMeal({required MealModel meal}) {
    try {
      print(meal.id);
      _mealsList[_mealsList.indexOf(
          _mealsList.firstWhere((element) => element.id == meal.id))] = meal;
      notifyListeners();
    } catch (e) {
      print('ssssssssssssssssssss $e');
    }
  }

  int get getPage => _page;
  bool get getIsLoading => _isLoading;
  List<MealModel> get getMealsList => _mealsList;
  bool get getIsDeleteLoading => _isDeleteLoading;
  String get getSearchValue => _searchValue;
}
