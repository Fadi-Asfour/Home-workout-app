import 'dart:convert';
import 'package:easy_localization/easy_localization.dart';
import 'package:home_workout_app/constants.dart';
import 'package:home_workout_app/models/sign_by_google_model.dart';
import 'package:home_workout_app/view_models/Register%20View%20Model/sign_by_google_view_model.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';

class SignByGoogleAPI {
  static Future<SignByGoogleModel> createUser(
      SignByGoogleModel user, String lang) async {
    try {
      final Response response =
          await post(Uri.parse('$base_URL/login/callback'),
              headers: <String, String>{
                // 'Content-Type': 'application/json;charset=UTF-8'
                'Accept': 'application/json',
                'apikey': apiKey,
                'lang': lang,
                'timeZone': getTimezone()
              },
              body: user.toJson());
      print('ssssssssssssssssssssssssssssssssssssssssssssss');
      print(response.body);
      if (response.statusCode == 201) {
        SignByGoogleViewModel().signOut();
        return SignByGoogleModel.fromJson(json.decode(response.body));
      } else {
        print(response.body);
        SignByGoogleViewModel().signOut();
        return SignByGoogleModel.fromJsonWithErrors(json.decode(response.body));
      }
    } catch (e) {
      print(e);
    }
    SignByGoogleViewModel().signOut();
    return SignByGoogleModel(
        message: 'There is a problem connecting to the internet'.tr(),
        statusCode: 0);
  }
}
