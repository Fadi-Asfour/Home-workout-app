import 'package:home_workout_app/models/food_model.dart';

class MealModel {
  String type = '';
  int id = 0;
  int day = 0;
  int ownerId = 0;
  int calories = 0;
  String description = '';
  List<FoodModel> foods = [];
  MealModel();
  MealModel.fromJson(Map json) {
    print(json);
    type = json['type'] ?? 'Breakfast';
    id = json['id'] ?? 0;
    //ownerId = json['user_id'] ?? 0;
    calories = int.tryParse(json['calorie_count'].toString()) ?? 0;
    description = json['description'];
    final foodsData = json['food_list'] as List;
    print(foodsData);

    foodsData.forEach((element) {
      foods.add(FoodModel.fromJson(element));
    });
  }

  MealModel.fromJsonForDiet(Map json) {
    print(json);
    type = json['type'] ?? 'Breakfast';
    id = json['id'] ?? 0;

    day = json['day'] ?? 0;
    //ownerId = json['user_id'] ?? 0;
    calories = int.tryParse(json['calorie_count'].toString()) ?? 0;
    description = json['description'];
  }
}
