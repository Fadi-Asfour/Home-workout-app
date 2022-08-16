import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:home_workout_app/constants.dart';
import 'package:home_workout_app/main.dart';
import 'package:home_workout_app/models/sign_up_model.dart';
import 'package:http/http.dart';

class SignUpAPI {
  static Future<SignUpModel> createUser(SignUpModel user, String lang) async {
    try {
      final Response response = await post(Uri.parse('$base_URL'),
          headers: <String, String>{
            //  "Access-Control-Allow-Origin": "*",
            // 'Content-Type': 'application/json;charset=UTF-8'
            'Accept': 'application/json',
            'apikey': apiKey,
            'lang': lang,
            'timeZone': getTimezone(),
          },
          body: user.toJson());
      print(response.statusCode);
      print(response.body);
      if (response.statusCode == 201) {
        return SignUpModel.fromJson(json.decode(response.body));
      } else {
        print(response.body);
        return SignUpModel.fromJsonWithErrors(json.decode(response.body));
      }
    } catch (e) {
      print(e);
    }
    return SignUpModel(
        message: 'There is a problem connecting to the internet'.tr(),
        statusCode: 0);
  }

  Future<Map<String, dynamic>> sendUserInfo(
      Gender gender,
      DateTime birthdate,
      String height,
      String weight,
      String country,
      String heightUnit,
      String weightUnit) async {
    try {
      print(sharedPreferences.getString('access_token'));
      final response = await post(
        Uri.parse('$base_URL/user/info'),
        headers: {
          'apikey': apiKey,
          'lang': 'en',
          'accept': 'application/json',
          'authorization':
              'Bearer ${sharedPreferences.getString('access_token')}',
          'timeZone': getTimezone()
        },
        body: {
          'height': height,
          'height_unit': heightUnit,
          'weight': weight,
          'weight_unit': weightUnit,
          'gender': gender.name,
          'birth_date': birthdate.toString(),
          'country': country
        },
      );
      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return {'success': true, 'message': data['message']};
      } else {
        print(jsonDecode(response.body));
        return {'success': false, 'message': data['message']};
      }
    } catch (e) {
      print('Sending info error: $e');
      return {'success': false, 'message': e.toString()};
    }
  }

  Future<List> getDiseases(String lang) async {
    try {
      final response = await get(
        Uri.parse('$base_URL/diseases'),
        headers: {
          'apikey': apiKey,
          'lang': lang,
          'accept': 'application/json',
          'authorization':
              'Bearer ${sharedPreferences.getString('access_token')}',
          'timeZone': getTimezone()
        },
      );
      if (response.statusCode == 200) {
        List data = jsonDecode(response.body)['data'] ?? [];
        print('Data:$data');
        return data;
      } else {
        print(jsonDecode(response.body));
      }
    } catch (e) {
      print('Get diseases error: $e');

      return [];
    }
    return [];
  }
}
