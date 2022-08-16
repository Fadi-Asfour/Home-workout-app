// ignore_for_file: use_build_context_synchronously

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:home_workout_app/Api%20services/app_control_api.dart';
import 'package:home_workout_app/components.dart';
import 'package:home_workout_app/models/app_feuture_model.dart';

class AppControlViewModel with ChangeNotifier {
  List<AppFeuturesModel> _appFe = [];
  bool _isLoading = false;

  void setIsLoading(value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<void> setAppFeutures(
      {required String lang, required BuildContext context}) async {
    setIsLoading(true);
    _appFe = await AppControlApi().getAppFeutures(lang: lang);
    setIsLoading(false);
  }

  Future<void> editAppFeuture(
      {required String lang,
      required BuildContext context,
      required int id}) async {
    setIsLoading(true);
    final response = await AppControlApi().editAppFeutures(lang: lang, id: id);
    if (response['success']) {
      for (int i = 0; i < _appFe.length; i++) {
        if (_appFe[i].id == id) {
          if (_appFe[i].isActive == 1) {
            _appFe[i].isActive = 0;
            setIsLoading(false);
            notifyListeners();
            return;
          } else {
            _appFe[i].isActive = 1;
            setIsLoading(false);
            notifyListeners();
          }
        }
      }
    } else {
      showSnackbar(Text(response['message'] ?? '').tr(), context);
    }
    setIsLoading(false);
  }

  List<AppFeuturesModel> get getAppFeutures => _appFe;
  bool get getIsLoading => _isLoading;
}
