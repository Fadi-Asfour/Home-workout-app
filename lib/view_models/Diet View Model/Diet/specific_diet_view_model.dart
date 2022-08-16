// ignore_for_file: use_build_context_synchronously

import 'package:flutter/cupertino.dart';
import 'package:home_workout_app/components.dart';
import 'package:home_workout_app/models/diet_model.dart';
import 'package:home_workout_app/view_models/Home%20View%20Model/mobile_home_view_model.dart';
import 'package:provider/provider.dart';

import '../../../Api services/diet_api.dart';
import 'edit_diet_view_model.dart';

class SpecificDietViewModel with ChangeNotifier {
  bool _isLoading = false;
  DietModel _diet = DietModel();
  bool _isSubLoading = false;

  void setIsSubLoading(value) {
    _isSubLoading = value;
    notifyListeners();
  }

  void reset() {
    _diet = DietModel();
    _isLoading = false;
    notifyListeners();
  }

  void setIsLoading(value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<void> subscribeDiet(
      {required String lang,
      required int dietId,
      required BuildContext context}) async {
    setIsSubLoading(true);
    final response = await DietAPI().subscribeDiet(
      lang: lang,
      id: dietId,
    );
    if (response['success']) {
      Provider.of<MobileHomeViewModel>(context, listen: false)
          .getSummaryData(lang: getLang(context), context: context);
      if (Provider.of<MobileHomeViewModel>(context, listen: false)
              .getSummary
              .dietId ==
          0)
        // ignore: curly_braces_in_flow_control_structures
        Provider.of<MobileHomeViewModel>(context, listen: false)
            .setDietId(dietId);
      else {
        Provider.of<MobileHomeViewModel>(context, listen: false).setDietId(0);
        Navigator.pop(context);
      }

      _diet.subscribed = !_diet.subscribed;
      notifyListeners();
    } else {
      showSnackbar(Text(response['message']), context);
    }
    setIsSubLoading(false);
  }

  Future<void> setSpecDiet(
      {required String lang,
      required int id,
      required BuildContext context}) async {
    setIsLoading(true);
    _diet = await DietAPI().getSpeDiet(lang: lang, id: id);
    setIsLoading(false);

    Provider.of<EditDietViewModel>(context, listen: false)
        .initMealsList(getDiet.meals);
    notifyListeners();
  }

  bool get getIsLoading => _isLoading;
  DietModel get getDiet => _diet;
  bool get getIsSubLoading => _isSubLoading;
}
