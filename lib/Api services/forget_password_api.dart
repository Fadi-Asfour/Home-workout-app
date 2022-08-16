import 'dart:convert';
import 'package:easy_localization/easy_localization.dart';
import 'package:home_workout_app/constants.dart';
import 'package:home_workout_app/main.dart';
import 'package:home_workout_app/models/forget_password_model.dart';
import 'package:http/http.dart';

class ForgetPasswordAPI {
  static Future<ForgetPasswordModel> createEmail(
      ForgetPasswordModel user, String lang) async {
    try {
      String? access_Token = sharedPreferences.getString('access_token');
      print('aceeeeeeeeeeeeeess_token:   $access_Token');
      final Response response =
          await post(Uri.parse('$base_URL/forgetpassword'),
              headers: <String, String>{
                // 'Content-Type': 'application/json;charset=UTF-8'
                'Accept': 'application/json',
                'apikey': apiKey,
                'lang': lang,
                'timeZone': getTimezone(),
                'authorization': 'Bearer $access_Token'
              },
              body: user.emailToJson());
      print(response.body);
      if (response.statusCode == 201) {
        print(response.body);
        return ForgetPasswordModel.fromJson(json.decode(response.body));
      } else {
        print(response.body);
        return ForgetPasswordModel.fromJsonWithErrors(
            json.decode(response.body));
      }
    } catch (e) {
      print(e);
    }
    return ForgetPasswordModel(
        message: 'There is a problem connecting to the internet'.tr(),
        statusCode: 0);
  }
}
