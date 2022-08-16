import 'package:image_picker/image_picker.dart';

class CreateExerciseModel {
  String? name;
  String? message;
  String? description;
  XFile? img;
  String? burn_calories;

  int? statusCode;
  CreateExerciseModel(
      {this.name,
      this.message,
      this.statusCode,
      this.burn_calories,
      this.img,
      this.description});
  // to convert data from json to dart object
  factory CreateExerciseModel.fromJson(Map<String, dynamic> user) =>
      CreateExerciseModel(
        message: user['message'] ?? '',
        statusCode: user['status'] ?? 0,
      );

  factory CreateExerciseModel.fromJsonWithErrors(Map<String, dynamic> user) =>
      CreateExerciseModel(
          message: user['message'], statusCode: user['status'] ?? 0);
  // to convert data to json
  Map<String, dynamic> toJson() => {
        'name': name,
        'burn_calories': burn_calories,
        'description': description
      };
}
