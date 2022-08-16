import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:home_workout_app/constants.dart';
import 'package:home_workout_app/models/sign_in_model.dart';
import 'package:home_workout_app/view_models/Register%20View%20Model/sign_in_view_model.dart';
import 'package:http/http.dart';

class SignInAPI {
  static Future<SignInModel> createUser(SignInModel user, String lang) async {
    try {
      final Response response = await post(Uri.parse('$base_URL/login'),
          headers: <String, String>{
            // "Access-Control-Allow-Origin": "*",
            // 'Content-Type': 'application/json;charset=UTF-8'
            'Accept': 'application/json',
            'apikey': apiKey,
            'lang': lang,
            'timeZone': getTimezone()
          },
          body: user.toJson());

      print(response.body);
      if (response.statusCode == 201 ||
          response.statusCode == 250 ||
          response.statusCode == 450) {
        return SignInModel.fromJson(json.decode(response.body));
      } else {
        print(response.statusCode);
        print(response.body);
        return SignInModel.fromJsonWithErrors(json.decode(response.body));
      }
    } catch (e) {
      print(e);
    }
    return SignInModel(
        message: 'There is a problem connecting to the internet'.tr(),
        statusCode: 0);
  }
}
