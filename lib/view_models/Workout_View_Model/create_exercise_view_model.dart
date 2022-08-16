import 'package:flutter/material.dart';
import 'package:home_workout_app/Api%20services/create_exercise_api.dart';
import 'package:home_workout_app/constants.dart';
import 'package:home_workout_app/models/create_exercise_model.dart';
import 'package:image_picker/image_picker.dart';

class CreateExerciseViewModel with ChangeNotifier {
  XFile userImage = XFile('');

  String? checkName(String name, String lang) {
    if (name.isEmpty) {
      return lang == 'en' ? ' Enter name' : ' أدخل الاسم ';
    } else
      return null;
  }

  String? checkCalories(String name, String lang) {
    if (name.isEmpty) {
      return lang == 'en' ? ' Enter Calories' : ' أدخل السعرات المحروقة ';
    } else
      return null;
  }

  String? checkDescription(String name, String lang) {
    if (name.isEmpty) {
      return lang == 'en' ? ' Enter description' : ' أدخل الوصف ';
    } else
      return null;
  }

  resetImage() {
    userImage = XFile('');
    notifyListeners();
  }

  postExerciseInfo(String nameVal, String descriptionVal,
      String burn_caloriesVal, XFile imgVal, String urlVal, String lang) async {
    CreateExerciseModel? result;
    print(imgVal.path);
    return await CreateExerciseAPI.createExercise(
        CreateExerciseModel(
            name: nameVal,
            burn_calories: burn_caloriesVal,
            img: imgVal,
            description: descriptionVal),
        urlVal,
        lang);
  }

  editExerciseInfo(String nameVal, String descriptionVal,
      String burn_caloriesVal, String idVal, String lang) async {
    CreateExerciseModel? result;
    try {
      await CreateExerciseAPI.editExerciseWithoutImage(
              CreateExerciseModel(
                  name: nameVal,
                  burn_calories: burn_caloriesVal,
                  description: descriptionVal),
              idVal,
              lang)
          .then((value) {
        print(value);
        result = value;
      });
    } catch (e) {
      print("create Exercise in ExerciseViewModel error: $e");
    }

    return result;
  }

  Future<void> changePhoto(ImageSource src) async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: src);
    if (pickedImage != null) {
      userImage = pickedImage;
      print('vvvvvvvvvvvvvvvvvvvvvvccccccccccc');
      print(userImage.path);
    }
    notifyListeners();
  }
}
