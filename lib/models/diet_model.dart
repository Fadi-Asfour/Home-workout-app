import 'dart:developer';

import 'package:home_workout_app/constants.dart';
import 'package:home_workout_app/models/meal_model.dart';

import 'food_model.dart';

class DietModel {
  int id = 0;
  String name = '';
  String description = '';
  List<Map> meals = [];
  int userId = 0;
  String userImg = '';
  String userFname = '';
  String userLname = '';
  String createAt = '';
  double rating = 0;
  bool saved = false;
  //double caloriesCount = 0;
  int mealsCount = 0;
  bool reviewd = false;
  bool subscribed = false;

  DietModel();

  DietModel.fromJson(Map json) {
    print('Model ' + json.toString());
    name = json['name'] ?? '';
    id = json['id'] ?? 0;
    rating = double.tryParse(json['review_count'].toString()) ?? 0;
    createAt = json['created_at'] ?? '';
    mealsCount = json['meal_count'] ?? 0;
    saved = json['saved'] ?? false;
    reviewd = json['is_reviewed'] ?? false;

    userId = json['created_by']['id'] ?? 0;
    log('UserId: $userId');
    userImg = json['created_by']['prof_img_url'] ?? '';
    if (userImg.substring(0, 4) != 'http') userImg = '$ip/$userImg';
    print(userImg);
    userFname = json['created_by']['f_name'] ?? '';
    userLname = json['created_by']['l_name'] ?? '';
  }

  DietModel.fromJsonForFull(Map json) {
    log(json.toString());
    name = json['name'] ?? '';
    rating = json['rating'] ?? 0;
    saved = json['saved'] ?? false;
    id = json['id'] ?? 0;
    createAt = json['created_at'] ?? '';
    mealsCount = json['meal_count'] ?? 0;
    reviewd = json['is_reviewed'] ?? false;
    subscribed = json['subscribed'] ?? false;

    userId = json['created_by']['id'] ?? 0;
    userImg = json['created_by']['prof_img_url'] ?? '';
    if (userImg.substring(0, 4) != 'http') userImg = '$ip/$userImg';
    userFname = json['created_by']['f_name'] ?? '';
    userLname = json['created_by']['l_name'] ?? '';

    final mealsL = json['schedule'] as List;
    //print(mealsL);

    mealsL.forEach((element) {
      final m = [];
      List<FoodModel> foods = [];
      final l = element['meal_list'] as List;
      l.forEach((element) {
        m.add(MealModel.fromJsonForDiet(element));
        final foodsData = element['food_list'] as List;
        //print(foodsData);

        foodsData.forEach((element) {
          foods.add(FoodModel.fromJson(element));
        });
        //print(foods);
      });

      meals.add(
        {
          'day': element['day'] ?? '',
          'meals': m,
          'foods': foods,
        },
      );
    });

    //print(meals);
  }
}
