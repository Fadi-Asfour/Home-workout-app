// ignore_for_file: curly_braces_in_flow_control_structures, use_build_context_synchronously

import 'package:flutter/cupertino.dart';
import 'package:home_workout_app/Api%20services/food_api.dart';
import 'package:home_workout_app/components.dart';
import 'package:home_workout_app/models/food_model.dart';

class FoodsListViewModel with ChangeNotifier {
  List<FoodModel> _foodsList = [];
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
    _foodsList.clear();
    _isLoading = false;
    _searchValue = '';
  }

  Future<void> getFoods({required String lang}) async {
    setIsLoading(true);
    //setPage(getPage + 1);
    _foodsList = await FoodAPI().getFoodsList(lang: lang, page: getPage);

    // _foodsList.add(FoodModel.fromJson({
    //   'data': {
    //     'name': 'test',
    //     'id': 1,
    //     'image_url':
    //         'https://st2.depositphotos.com/7036298/10694/i/450/depositphotos_106948346-stock-photo-ripe-red-apple-with-green.jpg',
    //     'user_id': 1,
    //     'calories': 70,
    //   }
    // }));

    setIsLoading(false);
  }

  Future<void> deleteFood(
      {required String lang,
      required int foodId,
      required BuildContext context}) async {
    setIsDeleteLoading(true);
    final response = await FoodAPI().deleteFood(lang: lang, foodId: foodId);
    if (response['success']) {
      showSnackbar(Text(response['message']), context);
      _foodsList.removeWhere((element) => element.id == foodId);
      notifyListeners();
    } else {
      showSnackbar(Text(response['message']), context);
    }
    setIsDeleteLoading(false);
  }

  int get getPage => _page;
  bool get getIsLoading => _isLoading;
  List<FoodModel> get getFoodsList => _foodsList;
  bool get getIsDeleteLoading => _isDeleteLoading;
  String get getSearchValue => _searchValue;
}
