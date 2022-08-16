// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:home_workout_app/Api%20services/cv_api.dart';
import 'package:home_workout_app/components.dart';
import 'package:home_workout_app/models/cv_model.dart';
import 'package:home_workout_app/view_models/profile_view_model.dart';
import 'package:home_workout_app/views/Apply%20CV%20View/cv_view.dart';
import 'package:provider/provider.dart';

class ApplyViewModel with ChangeNotifier {
  File? _pickedCV;
  String _fileData = '';
  int _groupValue = 0;
  bool _isLoading = false;
  bool _isDeleteLoading = false;
  bool _pickCVisLoading = false;

  CVModel _cv = CVModel();

  void setIsLoading(value) {
    _isLoading = value;
    notifyListeners();
  }

  void setPickCVIsLoading(value) {
    _pickCVisLoading = value;
    notifyListeners();
  }

  void setIsDeleteLoading(value) {
    _isDeleteLoading = value;
    notifyListeners();
  }

  void setGroupValue(int i) {
    _groupValue = i;
    notifyListeners();
  }

  void resetPick() {
    _fileData = '';
    _pickedCV = null;
    _groupValue = 0;
    _cv = CVModel();
    notifyListeners();
  }

  Future<void> setCV({required String lang}) async {
    setIsLoading(true);
    _cv = await CVApi().getCV(lang: lang);
    setIsLoading(false);
  }

  Future<void> deleteCV(
      {required String lang, required BuildContext context}) async {
    setIsLoading(true);
    final response = await CVApi().deleteCV(lang: lang);
    if (response['success']) {
      showSnackbar(Text(response['message']), context);
      Provider.of<ProfileViewModel>(context, listen: false).changeIsCV(false);
      Navigator.pop(context);
      Navigator.pop(context);
    } else {
      showSnackbar(Text(response['message']), context);
    }
    setIsLoading(false);
  }

  Future<void> pickCV() async {
    try {
      setPickCVIsLoading(true);
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );

      if (result != null) {
        _pickedCV = File(result.files.single.path!);

        _fileData = _pickedCV!.absolute
            .toString()
            .substring(_pickedCV!.absolute.toString().indexOf('file_picker/'),
                _pickedCV!.absolute.toString().length)
            .replaceAll('file_picker/', '')
            .replaceAll("'", '')
            .toString();
        notifyListeners();
      }
    } catch (e) {
      print(e);
    }
    setPickCVIsLoading(false);
  }

  Future sendCV(
      {required String desc,
      required BuildContext context,
      required String lang}) async {
    setIsLoading(true);
    final response = await CVApi().sendCV(
        desc: desc,
        cv: getPickedCV,
        roleId: _groupValue == 1 ? '2' : '3',
        lang: lang);
    setIsLoading(false);
    if (response['success']) {
      showSnackbar(Text(response['message']).tr(), context);
      Provider.of<ProfileViewModel>(context, listen: false).changeIsCV(true);
      Navigator.pop(context);
    } else {
      showSnackbar(Text(response['message']).tr(), context);
    }
  }

  File? get getPickedCV => _pickedCV;
  String get getFileData => _fileData;
  int get getGroupValue => _groupValue;
  bool get getIsLoading => _isLoading;
  bool get getIsDeleteLoading => _isDeleteLoading;
  bool get getPickCVIsLoading => _pickCVisLoading;
  CVModel get getCV => _cv;
}
