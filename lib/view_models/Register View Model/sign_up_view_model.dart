import 'dart:convert';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:home_workout_app/Api%20services/sign_up_api.dart';
import 'package:home_workout_app/main.dart';
import 'package:home_workout_app/models/sign_up_model.dart';
import 'package:http/http.dart';

class SignUpViewModel with ChangeNotifier {
  bool obscurePassword = true;
  bool obscureConfirmPassword = true;
  bool logButton = true;
  bool googleButton = true;

  changeLogButtonState() {
    logButton = !logButton;
    notifyListeners();
  }

  changeGoogleButtonState() {
    googleButton = !googleButton;
    notifyListeners();
  }

  changePasswordobscure() {
    obscurePassword = !obscurePassword;
    // print(obscurePassword);
    notifyListeners();
  }

  changeConfirmPasswordobscure() {
    obscureConfirmPassword = !obscureConfirmPassword;
    // print(obscureConfirmPassword);
    notifyListeners();
  }

  postUserInfo(
      String f_nameVal,
      String l_nameVal,
      String emailVal,
      String passwordVal,
      String ConfirmPasswordVal,
      String m_tokenVal,
      String macVal,
      String c_nameVal,
      String lang) async {
    SignUpModel? result;
    try {
      await SignUpAPI.createUser(
              SignUpModel(
                  f_name: f_nameVal,
                  l_name: l_nameVal,
                  email: emailVal,
                  password: passwordVal,
                  password_confirmation: ConfirmPasswordVal,
                  m_token: m_tokenVal,
                  mac: macVal,
                  c_name: c_nameVal),
              lang)
          .then((value) {
        print(value);

        result = value;
      });
    } catch (e) {
      print("postUserInfo in SignUpViewModel error: $e");
    }

    if ((result!.access_token != null && result!.access_token != '') &&
        (result!.statusCode == 201)) {
      setData(result!);
    }
    return result;
  }

  setData(SignUpModel Data) async {
    sharedPreferences.setString("access_token", Data.access_token!);
    sharedPreferences.setString("refresh_token", Data.refresh_token!);
    sharedPreferences.setString("token_expiration", Data.token_expiration!);
    sharedPreferences.setInt("role_id", Data.role_id!);
    sharedPreferences.setString("role_name", Data.role_name!);
    sharedPreferences.setBool("googleProvider", Data.googleProvider!);
    sharedPreferences.setBool("is_verified", Data.is_verified!);
    sharedPreferences.setBool("is_info", Data.is_info!);
    //TODO:
  }

  String? checkFirstName(String name, String lang) {
    if (name.isEmpty) {
      return lang == 'en' ? ' Enter first name' : ' أدخل الاسم ';
    } else
      return null;
  }

  String? checkLastName(String name, String lang) {
    if (name.isEmpty) {
      return lang == 'en' ? ' Enter last name' : ' أدخل الكنية ';
    } else
      return null;
  }

  String? checkEmail(String email, String lang) {
    bool emailValid = RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(email);
    if (email.isEmpty) {
      return lang == 'en' ? ' Enter email' : " أدخل البريد الإلكتروني";
    } else if (!emailValid) {
      return lang == 'en' ? ' Invalid email' : " بريد إلكتروني خاطئ ";
    } else
      return null;
  }

  String? checkPassword(String password, String lang) {
    if (password.isEmpty) {
      return lang == 'en' ? ' Enter password' : " أدخل كلمة المرور ";
    } else if (password.length < 6) {
      return lang == 'en'
          ? ' Password should be at least 6 characters'
          : " يجب أن تكون كلمة المرور ست أحرف على الأقل";
    } else {
      return null;
    }
  }

  String? checkConfirmPassword(
      String confirmPassword, String password, String lang) {
    if (confirmPassword.isEmpty) {
      return lang == 'en'
          ? ' Enter password confirmation'
          : " أدخل تأكيد كلمة المرور ";
    } else if (confirmPassword != password) {
      return lang == 'en'
          ? " This password is not the same as the previous one"
          : " كلمة المرور ليست نفسها السابقة";
    } else if (password.length < 6) {
      return lang == 'en'
          ? ' Password should be at least 6 characters'
          : " يجب أن تكون كلمة المرور ست أحرف على الأقل";
    } else {
      return null;
    }
  }
}
