import 'dart:developer';

import 'package:home_workout_app/models/exercises_model.dart';

import '../constants.dart';

class Workout2Model {
  String name = '';
  int id = 0;
  String description = '';
  int burnCalories = 0;
  int length = 0;
  int exercisesCount = 0;
  int burntCalories = 0;
  double reviewCount = 0;
  String equipment = '';
  int difficulty = 1;
  int userId = 0;
  int categorieId = 0;
  String imgUrl = '';
  String createdAt = '';
  String userFname = '';
  String userLname = '';
  String userImg = '';
  List<ExercisesModel> exercises = [];

  Workout2Model();

  Workout2Model.fromJson(Map json) {
    log(json.toString());

    name = json['name'] ?? '';
    id = json['id'] ?? 0;
    description = json['description'] ?? '';
    burnCalories = json['predicted_burnt_calories'] ?? 0;
    imgUrl = json['workout_image_url'] ?? '';
    if (imgUrl.substring(0, 4) != 'http') imgUrl = '$ip/$imgUrl';
    userId = json['user_id'] ?? 0;
    equipment = json['equipment'] ?? '';
    difficulty = json['difficulty'] ?? 0;
    reviewCount = double.tryParse(json['review_count'].toString()) ?? 0;
    exercisesCount = json['excersise_count'];
    length = json['length'];

    final exercisesData = json['excersises'] as List;

    for (var element in exercisesData) {
      exercises.add(ExercisesModel.fromJson(element));
    }

    userId = json['user']['id'] ?? 0;
    userFname = json['user']['f_name'] ?? '';
    userLname = json['user']['l_name'] ?? '';
    userImg = json['user']['prof_img_url'] ?? '';
    if (userImg.substring(0, 4) != 'http') userImg = '$ip/$userImg';
  }
}
