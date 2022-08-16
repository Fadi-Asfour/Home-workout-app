// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:home_workout_app/Api%20services/profile_api.dart';
import 'package:home_workout_app/components.dart';
import 'package:home_workout_app/constants.dart';
import 'package:home_workout_app/view_models/Home%20View%20Model/mobile_home_view_model.dart';
import 'package:home_workout_app/view_models/profile_view_model.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class EditProfileViewModel with ChangeNotifier {
  XFile _userImage = XFile('');
  Gender _gender = Gender.male;
  DateTime _birthdate = DateTime.now();
  String _bio = '';
  String _country = '';
  Units _weightUnit = Units.kg;
  Units _heightUnit = Units.cm;
  bool _isChangeLoading = false;
  bool _ChangePasswordLoading = false;

  bool _emailpasswordObsecure = true;

  bool _passwordObsecure1 = true;
  bool _passwordObsecure2 = true;
  bool _passwordObsecure3 = true;

  bool _isLoading = false;

  void setIsChangeLoading(value) {
    _isChangeLoading = value;
    notifyListeners();
  }

  void setIsChangePasswordLoading(value) {
    _ChangePasswordLoading = value;
    notifyListeners();
  }

  void ChangeWeightUnit(Units unit) {
    _weightUnit = unit;
    notifyListeners();
  }

  void ChangeHeightUnit(Units unit) {
    log(unit.name.toString());
    _heightUnit = unit;
    notifyListeners();
  }

  void setemailPasswordObsecure() {
    _emailpasswordObsecure = !_emailpasswordObsecure;
    notifyListeners();
  }

  void setPasswordObsecure1() {
    _passwordObsecure1 = !_passwordObsecure1;
    notifyListeners();
  }

  void setPasswordObsecure2() {
    _passwordObsecure2 = !_passwordObsecure2;
    notifyListeners();
  }

  void setPasswordObsecure3() {
    _passwordObsecure3 = !_passwordObsecure3;
    notifyListeners();
  }

  void setGender(Gender newGender) {
    _gender = newGender;
    notifyListeners();
  }

  void setInitialData(BuildContext ctx) {
    _gender =
        Provider.of<ProfileViewModel>(ctx, listen: false).getUserData.gender;
    _birthdate =
        Provider.of<ProfileViewModel>(ctx, listen: false).getUserData.birthdate;
    _bio = Provider.of<ProfileViewModel>(ctx, listen: false).getUserData.bio;
    _country = Provider.of<ProfileViewModel>(ctx, listen: false)
        .getUserData
        .countryName;
  }

  Future<void> changePhoto(ImageSource src) async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: src);
    if (pickedImage != null) {
      _userImage = pickedImage;
    }
    notifyListeners();
  }

  void resetUserImage() {
    _userImage = XFile('');
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
      _birthdate = selectedBirthdate;
      notifyListeners();
    }
  }

  void changeCountry(newCountry) {
    _country = newCountry;
    notifyListeners();
  }

  Future<void> changeEmail(String oldEmail, String newEmail, String password,
      BuildContext context) async {
    setIsChangeLoading(true);
    final response =
        await ProfileApi().changeEmail(oldEmail, newEmail, password);
    setIsChangeLoading(false);

    if (response['success']) {
      Navigator.pushNamed(
        context,
        '/otp',
        arguments: {
          'state': 'changeEmail',
          'newToken': response['newToken'],
        },
      );
      //Navigate to confirmation page

    } else {
      showSnackbar(Text(response['message']), context);
    }
  }

  Future<void> changePassword(String oldPassword, String newPassword,
      String confirmPassword, BuildContext context) async {
    setIsChangePasswordLoading(true);
    bool response = await ProfileApi()
        .changePassword(oldPassword, newPassword, confirmPassword);
    setIsChangePasswordLoading(false);

    if (response) {
      Navigator.pop(context);
    } else {
      showSnackbar(const Text('Change password failed').tr(), context);
    }
  }

  void setIsLoading(value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<void> editProfile(
      String fname,
      String lname,
      XFile image,
      String bio,
      String height,
      String weight,
      Gender gender,
      DateTime birthdate,
      BuildContext context,
      String country) async {
    log('unittttt' + getHeight.toString());
    setIsLoading(true);
    final response = await ProfileApi().editProfile(
        fname,
        lname,
        image,
        bio,
        height,
        weight,
        gender,
        birthdate,
        country,
        context,
        getHeight,
        getWeight);
    _isLoading = false;
    if (response['success']) {
      showSnackbar(Text(response['message']).tr(), context);
      Provider.of<MobileHomeViewModel>(context, listen: false)
          .getSummaryData(lang: getLang(context), context: context);
      Navigator.pop(context);
    } else {
      showSnackbar(Text(response['message']).tr(), context);
    }
    setIsLoading(false);
  }

  XFile get getUserImage => _userImage;
  Gender get getGender => _gender;
  DateTime get getBirthdate => _birthdate;
  String get getBio => _bio;
  String get getCountry => _country;
  bool get getPasswordObsecure1 => _passwordObsecure1;
  bool get getPasswordObsecure2 => _passwordObsecure2;
  bool get getPasswordObsecure3 => _passwordObsecure3;

  bool get getemailPasswordObsecure => _emailpasswordObsecure;

  Units get getWeight => _weightUnit;
  Units get getHeight => _heightUnit;
  bool get getIsLoading => _isLoading;
  bool get getIsChangeLoading => _isChangeLoading;
  bool get getIsChangePasswordLoading => _ChangePasswordLoading;
}
