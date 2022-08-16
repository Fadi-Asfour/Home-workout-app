import 'dart:convert';

import 'package:home_workout_app/models/app_feuture_model.dart';

import '../constants.dart';
import 'package:http/http.dart' as http;

import '../main.dart';

class AppControlApi {
  Future<List<AppFeuturesModel>> getAppFeutures({required String lang}) async {
    try {
      final response = await http.get(
        Uri.parse('$base_URL/App'),
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
        print(jsonDecode(response.body));
        List data = jsonDecode(response.body)['data'];
        List<AppFeuturesModel> feutures = [];
        data.forEach((element) {
          feutures.add(AppFeuturesModel.fromJson(element));
        });
        print(feutures);

        return feutures;
      } else {
        print(jsonDecode(response.body));
        return [];
      }
    } catch (e) {
      print('Get App Feutures Error: $e');
      return [];
    }
  }

  Future<Map> editAppFeutures({required String lang, required int id}) async {
    try {
      final response = await http.get(
        Uri.parse('$base_URL/App/edit'),
        headers: {
          'apikey': apiKey,
          'lang': lang,
          'accept': 'application/json',
          'authorization':
              'Bearer ${sharedPreferences.getString('access_token')}',
          'timeZone': getTimezone(),
          'id': id.toString()
        },
      );
      print(jsonDecode(response.body));

      if (response.statusCode == 200) {
        return {
          'success': true,
          'message': jsonDecode(response.body)['message'] ?? ''
        };
      } else {
        print(jsonDecode(response.body));
        return {
          'success': false,
          'message': jsonDecode(response.body)['message'] ?? ''
        };
      }
    } catch (e) {
      print('Edit App Feutures Error: $e');
      return {'success': false, 'message': e.toString()};
    }
  }
}
