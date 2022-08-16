import 'dart:convert';
import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:home_workout_app/constants.dart';
import 'package:home_workout_app/models/cv_model.dart';
import 'package:http/http.dart' as http;

import '../main.dart';

class CVApi {
  Future<Map> sendCV(
      {required String desc,
      required File? cv,
      required String roleId,
      required String lang}) async {
    try {
      var request = http.MultipartRequest("Post", Uri.parse('$base_URL/cv'));
      request.headers['accept'] = 'application/json';
      request.headers['apikey'] = apiKey;
      request.headers['lang'] = lang;
      request.headers['timeZone'] = getTimezone();
      request.headers['authorization'] =
          'Bearer ${sharedPreferences.getString('access_token')}';
      request.fields['desc'] = desc;
      request.fields['role'] = roleId;
      print(cv);

      if (cv != null) {
        var file = await http.MultipartFile.fromPath("cv", cv.path);
        request.files.add(file);
      }

      var response = await request.send();
      var responseData = await response.stream.toBytes();
      var responseString = String.fromCharCodes(responseData);
      print(responseString);
      if (response.statusCode == 200) {
        return {
          'success': true,
          'message': 'CV has been sent successfully'.tr()
        };
      } else {
        return {'success': false, 'message': 'Failed to send CV'.tr()};
      }
    } catch (e) {
      print('Update profile error: $e');

      return {'success': false, 'message': e.toString()};
    }
  }

  Future<CVModel> getCV({required String lang}) async {
    try {
      final response = await http.get(
        Uri.parse('$base_URL/cv'),
        headers: {
          'apikey': apiKey,
          'lang': lang,
          'accept': 'application/json',
          'authorization':
              'Bearer ${sharedPreferences.getString('access_token')}',
          'timeZone': getTimezone()
        },
      );
      print(jsonDecode(response.body).toString());
      if (response.statusCode == 200) {
        return CVModel.fromJson(jsonDecode(response.body));
      } else {
        return CVModel();
      }
    } catch (e) {
      print('Get CV Error: $e');
      return CVModel();
    }
  }

  Future<Map> deleteCV({required String lang}) async {
    try {
      final response = await http.delete(
        Uri.parse('$base_URL/cv'),
        headers: {
          'apikey': apiKey,
          'lang': lang,
          'accept': 'application/json',
          'authorization':
              'Bearer ${sharedPreferences.getString('access_token')}',
          'timeZone': getTimezone()
        },
      );
      print(jsonDecode(response.body).toString());
      if (response.statusCode == 200) {
        return {
          'success': true,
          'message': jsonDecode(response.body)['message']
        };
      } else {
        return {
          'success': false,
          'message': jsonDecode(response.body)['message']
        };
      }
    } catch (e) {
      print('Delete CV Error: $e');
      return {'success': false, 'message': e.toString()};
    }
  }

  Future<Map> AcceptCV({required String lang, required String id}) async {
    try {
      final response = await http.get(
        Uri.parse('$base_URL/cv/acc/$id'),
        headers: {
          'apikey': apiKey,
          'lang': lang,
          'accept': 'application/json',
          'authorization':
              'Bearer ${sharedPreferences.getString('access_token')}',
          'timeZone': getTimezone(),
        },
      );
      print(jsonDecode(response.body));
      if (response.statusCode == 200) {
        return {
          'success': true,
          'message': jsonDecode(response.body)['message']
        };
      } else {
        return {
          'success': false,
          'message': jsonDecode(response.body)['message']
        };
      }
    } catch (e) {
      print('AR Posts Dashboards Error: $e');
      return {'success': false, 'message': e.toString()};
    }
  }

  Future<Map> RefuseCV({required String lang, required String id}) async {
    try {
      final response = await http.get(
        Uri.parse('$base_URL/cv/ref/$id'),
        headers: {
          'apikey': apiKey,
          'lang': lang,
          'accept': 'application/json',
          'authorization':
              'Bearer ${sharedPreferences.getString('access_token')}',
          'timeZone': getTimezone(),
        },
      );
      print(jsonDecode(response.body));
      if (response.statusCode == 200) {
        return {
          'success': true,
          'message': jsonDecode(response.body)['message']
        };
      } else {
        return {
          'success': false,
          'message': jsonDecode(response.body)['message']
        };
      }
    } catch (e) {
      print('AR Posts Dashboards Error: $e');
      return {'success': false, 'message': e.toString()};
    }
  }
}
