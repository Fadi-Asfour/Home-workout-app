import 'package:flutter/cupertino.dart';
import 'package:home_workout_app/Api%20services/workout2_api.dart';
import 'package:home_workout_app/models/workout2_model.dart';

class SpecificWorkoutViewModel with ChangeNotifier {
  bool _isLoading = false;
  Workout2Model _workout = Workout2Model();

  void setIsLoading(value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<void> setWorkout({required String lang, required int id}) async {
    setIsLoading(true);
    _workout = await Workout2Api().getSepcWorkout(lang: lang, id: id);
    setIsLoading(false);
    notifyListeners();
  }

  bool get getIsLoading => _isLoading;
  Workout2Model get getWorkout => _workout;
}
