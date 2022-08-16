import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:home_workout_app/constants.dart';
import 'package:home_workout_app/main.dart';
import 'package:home_workout_app/models/otp_model.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;

class OTPAPI {
  static Future<OTPModel> createUser(
      OTPModel user, String addedURL, String lang) async {
    try {
      String? access_Token = sharedPreferences.getString('access_token');
      print('aceeeeeeeeeeeeeess_token:   $access_Token');
      final Response response = await post(Uri.parse('$base_URL$addedURL'),
          headers: <String, String>{
            // 'Content-Type': 'application/json;charset=UTF-8'
            'Accept': 'application/json',
            'apikey': apiKey,
            'lang': lang,
            'authorization': 'Bearer $access_Token'
          },
          body: user.toJson());
      print(response.body);
      if (response.statusCode == 201) {
        print(response.body);
        return OTPModel.fromJson(json.decode(response.body));
      } else {
        print(response.body);
        return OTPModel.fromJsonWithErrors(json.decode(response.body));
      }
    } catch (e) {
      print(e);
    }
    return OTPModel(
        message: 'There is a problem connecting to the internet'.tr(),
        statusCode: 0);
  }

  Future<Map> changeEmailOTP(
      {required String otpCode,
      required String token,
      required String lang}) async {
    try {
      final response =
          await http.post(Uri.parse('$base_URL/user/verifyNewEmail'), headers: {
        'apikey': apiKey,
        'lang': lang,
        'accept': 'application/json',
        'authorization':
            'Bearer ${sharedPreferences.getString('access_token')}',
        'timeZone': getTimezone()
      }, body: {
        'code': otpCode,
        'token': token
      });
      if (response.statusCode == 200) {
        print(jsonDecode(response.body));
        return {
          'success': true,
          'message': jsonDecode(response.body)['message']
        };
      } else {
        print(jsonDecode(response.body));
        return {
          'success': false,
          'message': jsonDecode(response.body)['message']
        };
      }
    } catch (e) {
      print('Delete error: $e');
      return {'success': false, 'message': e.toString()};
    }
  }

  Future<Map> changeEmailResendCode(
      {required String cname, required String lang}) async {
    try {
      final response = await http
          .post(Uri.parse('$base_URL/emailVerfiy/newEmailReget'), headers: {
        'apikey': apiKey,
        'lang': lang,
        'accept': 'application/json',
        'authorization':
            'Bearer ${sharedPreferences.getString('access_token')}',
        'timeZone': getTimezone()
      }, body: {
        'c_name': cname
      });
      if (response.statusCode == 200) {
        print(jsonDecode(response.body));
        return {
          'success': true,
          'message': jsonDecode(response.body)['message']
        };
      } else {
        print(jsonDecode(response.body));
        return {
          'success': false,
          'message': jsonDecode(response.body)['message']
        };
      }
    } catch (e) {
      print('Delete error: $e');
      return {'success': false, 'message': e.toString()};
    }
  }
}
