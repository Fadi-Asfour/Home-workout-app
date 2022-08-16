import 'dart:developer';

class WorkoutSummaryModel {
  String message = '';

  String totalTime = '';
  String exercises = '';
  String calories = '';

  WorkoutSummaryModel();
  WorkoutSummaryModel.fromJson(Map json) {
    log(json.toString());
    message = json['message'] ?? '';
    totalTime = json['data']['summary_time'] ?? '';
    exercises = json['data']['excersises_played'] ?? '';
    calories = json['data']['summary_calories'] ?? '';
  }
}
