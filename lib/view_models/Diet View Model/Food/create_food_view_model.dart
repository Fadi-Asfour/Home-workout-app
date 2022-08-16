// ignore_for_file: use_build_context_synchronously

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:home_workout_app/Api%20services/food_api.dart';
import 'package:home_workout_app/components.dart';
import 'package:image_picker/image_picker.dart';

class CreateFoodViewModel with ChangeNotifier {
  XFile? _pickedimage;
  bool _isLoading = false;

  void reset() {
    _pickedimage = null;
    _isLoading = false;
  }

  void setIsLoading(value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      _pickedimage = pickedImage;
    }
    notifyListeners();
  }

  Future<void> addFood(
      {required String foodName,
      required String calories,
      required String desc,
      required String lang,
      required BuildContext context}) async {
    if (_pickedimage == null) {
      showSnackbar(Text('You have to add a photo').tr(), context);
      return;
    }
    setIsLoading(true);
    final response = await FoodAPI().createFood(
        desc: desc,
        foodName: foodName,
        calories: calories,
        pickedImagePath: _pickedimage!.path,
        lang: lang);
    if (response['success']) {
      showSnackbar(Text(response['message'].toString()), context);
      Navigator.pop(context);
    } else {
      showSnackbar(Text(response['message'].toString()), context);
    }
    setIsLoading(false);
  }

  bool get getIsLoading => _isLoading;
  XFile? get getPickedImage => _pickedimage;
}
