import 'package:flutter/cupertino.dart';
import 'package:home_workout_app/Api%20services/exercise_api.dart';
import 'package:home_workout_app/components.dart';
import 'package:home_workout_app/models/exercise_model.dart';

class exercisesPickerViewModel with ChangeNotifier {
  List<exerciseModel> _exercisesList = [];
  bool _isLoading = false;
  bool _isDeleteLoading = false;

  void reset() {
    // _page = 0;
    _exercisesList = [];
    _isLoading = false;
    notifyListeners();
  }

  Future<void> getExercisesData({required String lang}) async {
    setIsLoading(true);
    //setPage(getPage + 1);
    _exercisesList = await exerciseAPI().getExercisesList(lang);

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

  void setIsLoading(value) {
    _isLoading = value;
    notifyListeners();
  }

  bool get getIsLoading => _isLoading;
  List<exerciseModel> get getexercisesList => _exercisesList;
}
