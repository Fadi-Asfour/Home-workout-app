import 'package:flutter/cupertino.dart';
import 'package:home_workout_app/Api%20services/workout2_api.dart';
import 'package:home_workout_app/models/workout_summary_model.dart';

class FinishWorkoutViewModel with ChangeNotifier {
  WorkoutSummaryModel _workoutSummary = WorkoutSummaryModel();
  bool _isLoading = false;

  void setIsLoading(value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<void> setWorkoutSummary(
      {required String lang,
      required int totalTime,
      required int workoutId,
      required List<int> exercises}) async {
    setIsLoading(true);
    _workoutSummary = await Workout2Api().getWorkoutSummary(
        lang: lang,
        totalTime: totalTime,
        exercises: exercises,
        workoutId: workoutId);
    setIsLoading(false);
  }

  bool get getisLoading => _isLoading;
  WorkoutSummaryModel get getWorkoutSummary => _workoutSummary;
}
