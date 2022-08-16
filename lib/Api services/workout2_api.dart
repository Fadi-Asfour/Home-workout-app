import 'dart:convert';
import 'dart:developer';

import 'package:home_workout_app/models/workout2_model.dart';
import 'package:home_workout_app/models/workout_summary_model.dart';
import 'package:http/http.dart' as http;

import '../constants.dart';
import '../main.dart';

class Workout2Api {
  Future<Workout2Model> getSepcWorkout(
      {required String lang, required int id}) async {
    try {
      final response = await http.get(
        Uri.parse('$base_URL/workout/show/$id'),
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
        return Workout2Model.fromJson(jsonDecode(response.body)['data']);
      }
    } catch (e) {
      print('Get Specific Workout Error: $e');
      return Workout2Model();
    }
    return Workout2Model();
  }

  Future<int> startPractice({required String lang, required int id}) async {
    try {
      final response = await http.get(
        Uri.parse('$base_URL/practice/start/$id'),
        headers: {
          'apikey': apiKey,
          'lang': lang,
          'accept': 'application/json',
          'authorization':
              'Bearer ${sharedPreferences.getString('access_token')}',
          'timeZone': getTimezone()
        },
      );
      print(jsonDecode(response.body));
      if (response.statusCode == 200) {
        return jsonDecode(response.body)['data']['id'];
      }
    } catch (e) {
      print('Start Workout Error: $e');
      return -1;
    }
    return -1;
  }

  Future<WorkoutSummaryModel> getWorkoutSummary(
      {required String lang,
      required int totalTime,
      required List<int> exercises,
      required int workoutId}) async {
    try {
      log(exercises.toString());
      final response =
          await http.post(Uri.parse('$base_URL/practice/summary'), headers: {
        'apikey': apiKey,
        'lang': lang,
        'accept': 'application/json',
        'authorization':
            'Bearer ${sharedPreferences.getString('access_token')}',
        'timeZone': getTimezone()
      }, body: {
        'totalTime': totalTime.toString(),
        'excersises_played': jsonEncode(exercises),
        'workout_id': workoutId.toString()
      });
      print(jsonDecode(response.body));

      if (response.statusCode == 200) {
        return WorkoutSummaryModel.fromJson(jsonDecode(response.body));
      }
    } catch (e) {
      print('Get  Workout Summary Error: $e');
      return WorkoutSummaryModel();
    }
    return WorkoutSummaryModel();
  }
}
