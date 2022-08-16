// ignore_for_file: use_build_context_synchronously

import 'package:flutter/cupertino.dart';
import 'package:home_workout_app/components.dart';
import 'package:image_picker/image_picker.dart';

import '../../../Api services/food_api.dart';

class EditFoodViewModel with ChangeNotifier {
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
      notifyListeners();
    }
  }

  Future<void> editFood(
      {required String foodName,
      required int id,
      required String calories,
      required String lang,
      required String description,
      required BuildContext context}) async {
    print(getPickedImage);
    setIsLoading(true);
    final response = await FoodAPI().editFood(
        id: id,
        foodName: foodName,
        calories: calories,
        description: description,
        pickedImagePath: getPickedImage == null ? '' : getPickedImage!.path,
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
