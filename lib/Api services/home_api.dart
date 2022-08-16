import 'dart:convert';

import 'package:home_workout_app/constants.dart';
import 'package:home_workout_app/models/summary_model.dart';
import 'package:http/http.dart' as http;

import '../main.dart';

class HomeAPI {
  Future<SummaryModel> getSummaryInfo({required String lang}) async {
    try {
      final response =
          await http.get(Uri.parse('$base_URL/home/summary'), headers: {
        'apikey': apiKey,
        'lang': lang,
        'accept': 'application/json',
        'authorization':
            'Bearer ${sharedPreferences.getString('access_token')}',
        'timeZone': getTimezone()
      });
      print(jsonDecode(response.body));

      if (response.statusCode == 200) {
        return SummaryModel.fromJson(jsonDecode(response.body)['data']);
      } else {
        return SummaryModel();
      }
    } catch (e) {
      print('Get Summary error: $e');
    }
    return SummaryModel();
  }
}
