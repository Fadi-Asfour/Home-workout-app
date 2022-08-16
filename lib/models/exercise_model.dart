import 'package:home_workout_app/constants.dart';

class exerciseModel {
  int? id;
  String? name;
  String? message;

  String? exercise_img;
  String? end_time;
  String? time;
  String? count;
  String? ex_id;
  String? desc;
  String? categorie_id;
  String? equipment;
  String? difficulty;
  List? excersisesList;
  int? statusCode;

  String? f_name;
  String? l_name;
  String? prof_img_url;
  int? burn_calories;
  String? created_at;
  int? user_id;

  exerciseModel({
    this.id,
    this.name,
    this.message,
    this.statusCode,
    this.end_time,
    this.time,
    this.count,
    this.ex_id,
    this.desc,
    this.exercise_img,
    this.categorie_id,
    this.equipment,
    this.difficulty,
    this.excersisesList,
    this.f_name,
    this.l_name,
    this.burn_calories,
    this.created_at,
    this.prof_img_url,
    this.user_id,
  });

  // exerciseModel.fromJson(Map json) {
  //   print(json);
  //   print(json['image_url']);
  //   description = json['description'] ?? '';
  //   name = json['name'] ?? '';
  //   imageUrl = json['exercise_image_url'] ?? '';
  //   if (imageUrl.substring(0, 4) != 'http') imageUrl = '$ip/$imageUrl';
  //   print(imageUrl);
  //   id = json['id'] ?? 0;
  //   calories = int.tryParse(json['calories'].toString()) ?? 0;
  //   //ownerId = json['data']['user_id'] ?? 0;
  // }
  factory exerciseModel.fromExercisesJson(Map<String, dynamic> user) =>
      exerciseModel(
        // message: user['message'] ?? '',
        // statusCode: user['status'] ?? 0,
        id: user['id'] ?? 0,
        name: user['name'] ?? '',
        desc: user['description'] ?? '',
        exercise_img: user['excersise_media_url'] ?? '',
        user_id: user['user_id']['id'] ?? '',
        f_name: user['user_id']['f_name'] ?? '',
        l_name: user['user_id']['l_name'] ?? '',
        prof_img_url: user['user_id']['prof_img_url'] ?? '',
        burn_calories: user['burn_calories'] ?? 0,
        created_at: user['created_at'] ?? '',

        //  ca: user['ca'] ?? '',
      );
  factory exerciseModel.fromJsonWithErrors(Map<String, dynamic> user) =>
      exerciseModel(message: user['message'], statusCode: user['status'] ?? 0);
}
