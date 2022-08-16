import 'dart:convert';

import 'package:image_picker/image_picker.dart';

class CreateworkoutModel {
  int? id;
  String? name;
  String? message;
  // XFile? img;
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
  XFile? workout_image;
  CreateworkoutModel(
      {this.id,
      this.name,
      this.message,
      this.statusCode,
      // this.img,
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
      this.workout_image});
  // to convert data from json to dart object
  factory CreateworkoutModel.fromJson(Map<String, dynamic> user) =>
      CreateworkoutModel(
        message: user['message'] ?? '',
        statusCode: user['status'] ?? 0,
        // id: user['id'] ?? 0,
        // name: user['name'] ?? '',
        // desc: user['desc'] ?? '',
        // img: user['img'] ?? '',
        // end_time: user['end_time'] ?? '',
        // role_id: user['role_id'] ?? 0,
        // total_count: user['total_count'] ?? '',
        // my_count: user['my_count'] ?? '',
        // created_at: user['created_at'] ?? '',
        // sub_count: user['sub_count'] ?? '',
        // user_img: user['user_img'] ?? '',
        // is_time: user['is_time'] ?? false,
        // is_sub: user['is_sub'] ?? false,
        // is_active: user['is_active'] ?? false,
      );
  factory CreateworkoutModel.fromCategoriesJson(Map<String, dynamic> user) =>
      CreateworkoutModel(
        // message: user['message'] ?? '',
        // statusCode: user['status'] ?? 0,
        id: user['id'] ?? 0,
        name: user['name'] ?? '',
        // img: user['img'] ?? '',
        //  ca: user['ca'] ?? '',
      );
  factory CreateworkoutModel.fromExercisesJson(Map<String, dynamic> user) =>
      CreateworkoutModel(
        // message: user['message'] ?? '',
        // statusCode: user['status'] ?? 0,
        id: user['id'] ?? 0,
        name: user['name'] ?? '',
        desc: user['description'] ?? '',
        exercise_img: user['excersise_media_url'] ?? '',
        //  ca: user['ca'] ?? '',
      );
  factory CreateworkoutModel.fromJsonWithErrors(Map<String, dynamic> user) =>
      CreateworkoutModel(
          message: user['message'], statusCode: user['status'] ?? 0);

  // to convert data to json
  Map<String, dynamic> toJson() => {
        'name': name,
        'categorie_id': categorie_id,
        'difficulty': difficulty,
        'equipment': equipment,
        'description': desc,
        'excersises': jsonEncode(excersisesList)
      };
}
