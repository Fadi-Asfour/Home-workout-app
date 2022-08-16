// ignore_for_file: curly_braces_in_flow_control_structures, use_build_context_synchronously

import 'package:flutter/cupertino.dart';
import 'package:home_workout_app/Api%20services/meal_api.dart';
import 'package:home_workout_app/components.dart';

class CreateMealViewModel with ChangeNotifier {
  List<int> _pickedFoodsIDs = [];
  bool _isLoading = false;

  void setIsLoading(value) {
    _isLoading = value;
    notifyListeners();
  }

  void reset() {
    _pickedFoodsIDs.clear();
  }

  void addToFoods(int i) {
    if (!_pickedFoodsIDs.contains(i)) _pickedFoodsIDs.add(i);
    notifyListeners();
  }

  void removeFromFoods(int i) {
    if (_pickedFoodsIDs.contains(i))
      _pickedFoodsIDs.removeWhere((element) => element == i);
    notifyListeners();
  }

  Future<void> createMeal(
      {required String type,
      required String desc,
      required List<int> foodsIDs,
      required String lang,
      required BuildContext context}) async {
    setIsLoading(true);
    final response = await MealAPI()
        .createMeal(type: type, desc: desc, foodsIDs: foodsIDs, lang: lang);
    if (response['success']) {
      showSnackbar(Text(response['message']), context);
      Navigator.pop(context);
    } else {
      showSnackbar(Text(response['message']), context);
    }
    setIsLoading(false);
  }

  List<int> get getPickedFoods => _pickedFoodsIDs;
  bool get getIsLoading => _isLoading;
}
