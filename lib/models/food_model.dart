import 'package:home_workout_app/constants.dart';

class FoodModel {
  String name = '';
  String imageUrl = '';
  int id = 0;
  int calories = 0;
  int ownerId = 0;
  String description = '';

  FoodModel();

  FoodModel.fromJson(Map json) {
    print(json);
    print(json['image_url']);
    description = json['description'] ?? '';
    name = json['name'] ?? '';
    imageUrl = json['food_image_url'] ?? '';
    if (imageUrl.substring(0, 4) != 'http') imageUrl = '$ip/$imageUrl';
    print(imageUrl);
    id = json['id'] ?? 0;
    calories = int.tryParse(json['calories'].toString()) ?? 0;
    //ownerId = json['data']['user_id'] ?? 0;
  }
}
