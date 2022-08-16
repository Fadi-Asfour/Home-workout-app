// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:home_workout_app/Api%20services/sign_up_api.dart';
import 'package:home_workout_app/components.dart';
import 'package:home_workout_app/constants.dart';
import 'package:home_workout_app/main.dart';

import '../Api services/health_record_api.dart';

class UserInformationViewModel with ChangeNotifier {
  var gender;
  DateTime birthdate = DateTime.now();
  bool dateIsSelected = false;
  Units weightUnit = Units.kg;
  Units heightUnit = Units.cm;
  String _country = '';
  List _diseases = [];
  bool _addDescription = false;
  String _searchValue = '';
  bool _isLoading = false;

  void setAddDesc() {
    _addDescription = !_addDescription;
    notifyListeners();
  }

  void setSearchValue(String value) {
    _searchValue = value;
    notifyListeners();
  }

  setCountry(countryName) {
    _country = countryName;
    notifyListeners();
  }

  // Map<String, bool> diseases = {
  //   'Amyotrophic lateral sclerosis (ALS).': false,
  //   'Charcot-Marie-Tooth disease.': false,
  //   'Multiple sclerosis.': false,
  //   'Muscular dystrophy.': false,
  //   'Myasthenia gravis.': false,
  //   'Myopathy.': false,
  //   'Peripheral neuropathy.': false,
  //   'Peripheral neuropa1thy.': false,
  //   'Peripheral neuropa2thy.': false,
  //   'Peripheral neuropa3thy.': false,
  // };

  Future<void> setDiseases(String lang) async {
    final resp = await SignUpAPI().getDiseases(lang);

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

  bool checkHWValues(String h, String w, BuildContext context) {
    return true;
  }

  checkDetails1Value(
    GlobalKey<FormState> _formkey,
    PageController _pageController,
    BuildContext context,
    String height,
    String weight,
  ) async {
    if (gender == null) {
      showSnackbar(const Text('Please enter your gender').tr(), context);
    } else if (!dateIsSelected) {
      showSnackbar(const Text('Please enter your birthdate').tr(), context);
    } else if (_formkey.currentState != null) {
      if (_formkey.currentState!.validate()) {
        if (_country.isEmpty) {
          showSnackbar(const Text('Please enter your country').tr(), context);
        } else {
          _isLoading = true;
          final response = await sendInfo(
              getGender,
              getBirthdate,
              height,
              weight,
              getCountryName,
              getHeightunit.name,
              getWeightUnit.name,
              context);
          _isLoading = false;
          if (response) {
            sharedPreferences.setBool('is_info', true);
            resetValue();
            _pageController.animateToPage(1,
                duration: const Duration(milliseconds: 300),
                curve: Curves.linear);
          }
        }
      }
    }
  }

  void changeDiseasesValue(key, changedValue) {
    _diseases.firstWhere((element) => element['id'] == key)['selected'] =
        changedValue;
    notifyListeners();
  }

  void changeGender(Gender selectedGender) {
    gender = selectedGender;
    notifyListeners();
  }

  void ChangeWeightUnit(Units unit) {
    weightUnit = unit;
    notifyListeners();
  }

  void ChangeHeightUnit(Units unit) {
    log(unit.name);
    heightUnit = unit;
    notifyListeners();
  }

  changeBirthdate(BuildContext context) async {
    final selectedBirthdate = await showDatePicker(
      builder: (context, child) => Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: orangeColor,
              onPrimary: Colors.white,
              onSurface: orangeColor,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                primary: orangeColor,
              ),
            ),
          ),
          child: child!),
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1922),
      lastDate: DateTime.now(),
    );
    if (selectedBirthdate != null) {
      birthdate = selectedBirthdate;
      dateIsSelected = true;
      notifyListeners();
    }
  }

  Future<bool> sendInfo(
      Gender gender,
      DateTime birthdate,
      String height,
      String weight,
      String country,
      String heightUnit,
      String weightUnit,
      BuildContext context) async {
    final response = await SignUpAPI().sendUserInfo(
        gender, birthdate, height, weight, country, heightUnit, weightUnit);
    if (response['success']) {
      return true;
    } else {
      showSnackbar(Text(response['message'].toString()), context);
      return false;
    }
  }

  Future<void> sendHealthRecord(
      String desc, String lang, BuildContext context) async {
    List dis = [];
    List selectedDis =
        _diseases.where((element) => element['selected'] == true).toList();
    selectedDis.forEach((element) {
      dis.add(element['id']);
    });
    //print(dis);
    final response = await HealthRecordApi().sendHealthRecord(dis, lang, desc);
    if (response['success']) {
      Navigator.of(context).pushNamedAndRemoveUntil('/home', (route) => false);
    } else {
      showSnackbar(Text(response['message'].toString()), context);
    }
  }

  void resetValue() {
    gender = '';
    birthdate = DateTime.now();
    dateIsSelected = false;
    weightUnit = Units.kg;
    heightUnit = Units.cm;
    _country = '';
    _diseases = [];
    _addDescription = false;
    _searchValue = '';
    _isLoading = false;
  }

  String get getCountryName => _country;
  get getGender => gender;
  DateTime get getBirthdate => birthdate;
  Units get getHeightunit => heightUnit;
  Units get getWeightUnit => weightUnit;
  List get getDiseases => _diseases;
  String get getSearchValue => _searchValue;
  bool get getIsLoading => _isLoading;
  bool get getAddDesc => _addDescription;
}
