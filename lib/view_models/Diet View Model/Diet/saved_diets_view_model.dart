// ignore_for_file: curly_braces_in_flow_control_structures

import 'package:flutter/cupertino.dart';
import 'package:home_workout_app/components.dart';

import '../../../Api services/diet_api.dart';
import '../../../models/diet_model.dart';

class SavedDietsViewModel with ChangeNotifier {
  List<DietModel> _diets = [];
  int _page = 0;
  bool _isLoading = false;
  bool _isDeleteLoading = false;

  void reset() {
    _diets.clear();
    _page = 0;
    _isLoading = false;
    _isDeleteLoading = false;
    notifyListeners();
  }

  void setIsLoading(value) {
    _isLoading = value;
    notifyListeners();
  }

  void setIsDeleteLoading(value) {
    _isDeleteLoading = value;
    notifyListeners();
  }

  void setPage(int i) {
    _page = i;
    notifyListeners();
  }

  Future<void> getDietsList({required String lang}) async {
    setIsLoading(true);
    setPage(getPage + 1);
    final response = await DietAPI().getSavedDiets(lang: lang, page: getPage);
    if (response.isEmpty)
      setPage(getPage - 1);
    else
      _diets.addAll(response);

    setIsLoading(false);
  }

  Future<void> unsaveDiet(
      {required String lang,
      required int id,
      required BuildContext context}) async {
    final response = await DietAPI().saveDiet(id: id, lang: lang);

    if (response['success']) {
      _diets.removeWhere((element) => element.id == id);
      notifyListeners();
    } else {
      showSnackbar(Text(response['message'].toString()), context);
    }
  }

  List<DietModel> get getSavedDiets => _diets;
  int get getPage => _page;
  bool get getIsLoading => _isLoading;
  bool get getIsDeleteLoading => _isDeleteLoading;
}
