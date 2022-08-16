import 'package:flutter/material.dart';
import 'package:home_workout_app/Api%20services/reset_password_api.dart';
import 'package:home_workout_app/main.dart';
import 'package:home_workout_app/models/Reset_password_model.dart';
import 'package:http/http.dart';

class ResetPasswordViewModel with ChangeNotifier {
  bool obscurePassword = true;
  bool obscureConfirmPassword = true;

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

  postUserInfo(String emailVal, String passwordVal, String ConfirmPasswordVal,
      String c_nameVal, String forgetPasswordCodeVal, String lang) async {
    ResetPasswordModel? result;
    try {
      await ResetPasswordAPI.createUser(
              ResetPasswordModel(
                  email: emailVal,
                  password: passwordVal,
                  password_confirmation: ConfirmPasswordVal,
                  c_name: c_nameVal,
                  forgetPasswordCode: forgetPasswordCodeVal),
              lang)
          .then((value) {
        print(value);

        result = value;
      });
    } catch (e) {
      print("postUserInfo in SignUpViewModel error: $e");
    }

    // if ((result!.access_token != null && result!.access_token != '') &&
    //     (result!.statusCode == 201)) {
    //   setData(result!);
    // }
    return result;
  }

  // setData(ResetPasswordModel Data) async {
  //   sharedPreferences.setString("access_token", Data.access_token!);
  //   sharedPreferences.setString("refresh_token", Data.refresh_token!);
  //   sharedPreferences.setString("token_expiration", Data.token_expiration!);
  //   sharedPreferences.setInt("role_id", Data.role_id!);
  //   sharedPreferences.setString("role_name", Data.role_name!);
  //   sharedPreferences.setBool("googleProvider", Data.googleProvider!);
  // }

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
