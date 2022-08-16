import 'package:flutter/material.dart';
import 'package:home_workout_app/Api%20services/otp_api.dart';
import 'package:home_workout_app/models/otp_model.dart';

class otpViewModel with ChangeNotifier {
  bool obscureCode = true;

  changeCodeobscure() {
    obscureCode = !obscureCode;
    print(obscureCode);
    notifyListeners();
  }

  postUserInfo(
      String otpVal, String c_nameVal, String addedURL, String lang) async {
    OTPModel? result;
    try {
      await OTPAPI
          .createUser(
              OTPModel(
                verification_code: otpVal,
                c_name: c_nameVal,
              ),
              addedURL,
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

  String? checkCode(String code, String lang) {
    if (code.isEmpty) {
      return lang == 'en' ? ' Enter code' : 'ادخل الرمز ';
    } else if (code.length < 5) {
      return lang == 'en'
          ? ' Code should be 5 characters'
          : "يجب أن يكون الرمز خمس أحرف";
    } else {
      return null;
    }
  }
}
