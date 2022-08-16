import 'package:flutter/material.dart';
import 'package:home_workout_app/Api%20services/forget_password_api.dart';
import 'package:home_workout_app/models/forget_password_model.dart';

class ForgetPasswordViewModel with ChangeNotifier {
  bool obscureCode = true;

  changeCodeobscure() {
    obscureCode = !obscureCode;
    print(obscureCode);
    notifyListeners();
  }

  postEmail(String emailVal, String c_nameVal, String lang) async {
    ForgetPasswordModel? result;
    try {
      await ForgetPasswordAPI.createEmail(
              ForgetPasswordModel(
                email: emailVal,
                c_name: c_nameVal,
              ),
              lang)
          .then((value) {
        print(value);

        result = value;
      });
    } catch (e) {
      print(e);
    }

    return result;
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
}
