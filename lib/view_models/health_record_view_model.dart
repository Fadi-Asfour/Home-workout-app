// ignore_for_file: use_build_context_synchronously

import 'package:flutter/cupertino.dart';
import 'package:home_workout_app/Api%20services/health_record_api.dart';
import 'package:home_workout_app/components.dart';
import 'package:home_workout_app/view_models/profile_view_model.dart';
import 'package:provider/provider.dart';

import '../Api services/sign_up_api.dart';

class HealthRecordViewModel with ChangeNotifier {
  bool _addDesc = false;
  String _searchVal = '';
  List _diseases = [];
  //List _selectedDis = [];
  bool _isLoading = false;

  void setIsLoading(value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<void> setDiseases(String lang) async {
    final resp = await SignUpAPI().getDiseases(lang);
    print('called');
    _diseases.clear();
    resp.forEach(
      (element) {
        _diseases.add(
          {
            'id': element['id'],
            'name': element['name'],
            'selected': false,
          },
        );
      },
    );
    print(_diseases);
    notifyListeners();
  }

  void changeDiseasesValue(key, changedValue) {
    _diseases.firstWhere((element) => element['id'] == key)['selected'] =
        changedValue;
    notifyListeners();
  }

  // void changeSelectedDiseasesValue(key, changedValue) {
  //   _selectedDis.firstWhere((element) => element['id'] == key)['selected'] =
  //       changedValue;
  //   notifyListeners();
  // }

  void setSearchVal(String value) {
    _searchVal = value;
    notifyListeners();
  }

  void setAddDesc() {
    _addDesc = !_addDesc;
    notifyListeners();
  }

  Future<void> sendHealthRecord(
      String desc, String lang, BuildContext context) async {
    setIsLoading(true);
    List dis = [];
    List selectedDis =
        _diseases.where((element) => element['selected'] == true).toList();
    selectedDis.forEach((element) {
      dis.add(element['id']);
    });
    //print(dis);
    final response = await HealthRecordApi().sendHealthRecord(dis, lang, desc);
    if (response['success']) {
      setIsLoading(false);
      await Provider.of<ProfileViewModel>(context, listen: false)
          .setHealthRecord(lang);
      _diseases.clear();
      Navigator.pop(context);
    } else {
      setIsLoading(false);

      showSnackbar(Text(response['message'].toString()), context);
    }
  }

  bool get getAddDesc => _addDesc;
  String get getSearchVal => _searchVal;
  List get getDiseases => _diseases;
  //List get getSselectedDiseases => _selectedDis;
  bool get getIsLoading => _isLoading;
}
