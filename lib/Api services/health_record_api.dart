import 'dart:convert';

import 'package:http/http.dart' as http;

import '../constants.dart';
import '../main.dart';
import '../models/health_record_model.dart';

class HealthRecordApi {
  Future<Map<String, dynamic>> sendHealthRecord(
      List dis, String lang, String desc) async {
    try {
      print(dis);
      //print(sharedPreferences.getString('access_token'));
      final response = await http.post(
        Uri.parse('$base_URL/hRecord'),
        headers: {
          'apikey': apiKey,
          'lang': lang,
          'accept': 'application/json',
          'authorization':
              'Bearer ${sharedPreferences.getString('access_token')}',
          'timeZone': getTimezone()
        },
        body: {
          'dis': jsonEncode(dis),
          'desc': desc,
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
      print('Sending health record error: $e');
      return {'success': false, 'message': e.toString()};
    }
  }

  Future<HealthRecordModel> getHealthRecord(String lang) async {
    try {
      final response = await http.get(
        Uri.parse('$base_URL/hRecord'),
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
        final data = jsonDecode(response.body);
        print('Data: $data');
        return HealthRecordModel.fromJson(data);
      } else {
        print(jsonDecode(response.body));
      }
    } catch (e) {
      print('Get diseases error: $e');

      return HealthRecordModel();
    }
    return HealthRecordModel();
  }

  Future<dynamic> deleteHealthRecord(String lang) async {
    try {
      final response = await http.delete(
        Uri.parse('$base_URL/hRecord'),
        headers: {
          'apikey': apiKey,
          'lang': lang,
          'accept': 'application/json',
          'authorization':
              'Bearer ${sharedPreferences.getString('access_token')}',
          'timeZone': getTimezone()
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
      print('Delete Health Record error: $e');
      return {'success': false, 'message': e.toString()};
    }
  }
}
