// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:home_workout_app/models/challenge_model.dart';
import 'package:home_workout_app/models/diet_model.dart';
import 'package:home_workout_app/models/post_models.dart';
import 'package:home_workout_app/models/user_model.dart';
import 'package:home_workout_app/models/workout_list_model.dart';
import 'package:home_workout_app/models/workout_model.dart';

import '../components.dart';
import '../constants.dart';
import '../main.dart';

import 'package:http/http.dart' as http;

class SearchApi {
  Future<List> getSearchData(
      {required String lang,
      required String text,
      required String filter,
      required int page,
      required BuildContext context}) async {
    try {
      print('Page $page');
      final response =
          await http.post(Uri.parse('$base_URL/search?page=$page'), headers: {
        'apikey': apiKey,
        'lang': lang,
        'accept': 'application/json',
        'authorization':
            'Bearer ${sharedPreferences.getString('access_token')}',
        'timeZone': getTimezone()
      }, body: {
        'text': text,
        'filter': filter
      });
      print(text);
      print(filter);

      print(jsonDecode(response.body));
      if (response.statusCode == 200) {
        switch (filter) {
          case 'Users':
            List<UserModel> posts = [];

            List data = jsonDecode(response.body)['data'] ?? [];
            data.forEach((element) {
              posts.add(UserModel.fromJsonForSearch(element));
            });
            print(posts);
            return posts;

          case 'Posts':
            List<PostModel> posts = [];

            List data = jsonDecode(response.body)['data'] ?? [];
            data.forEach((element) {
              posts.add(PostModel.fromJson(element));
            });
            print(posts);
            return posts;

          case 'Diets':
            List<DietModel> posts = [];

            List data = jsonDecode(response.body)['data'] ?? [];
            data.forEach((element) {
              posts.add(DietModel.fromJson(element));
            });
            print(posts);
            return posts;

          case 'Workouts':
            List<WorkoutListModel> posts = [];

            List data = jsonDecode(response.body)['data'] ?? [];
            data.forEach((element) {
              posts.add(WorkoutListModel.fromJson(element));
            });
            print(posts);
            return posts;

          case 'Challenges':
            List<ChallengeModel> posts = [];

            List data = jsonDecode(response.body)['data'] ?? [];
            data.forEach((element) {
              posts.add(ChallengeModel.fromJson(element));
            });
            print(posts);
            return posts;

          default:
            return [];
        }
      } else {
        showSnackbar(Text(jsonDecode(response.body)['message'] ?? ''), context);

        print(jsonDecode(response.body));
        return [];
      }
    } catch (e) {
      print('Get Search Data Error: $e');
      return [];
    }
  }

  Future<List<String>> getSuggestion(
      {required String lang,
      required String text,
      required String filter,
      required BuildContext context}) async {
    try {
      final response =
          await http.post(Uri.parse('$base_URL/search/sug'), headers: {
        'apikey': apiKey,
        'lang': lang,
        'accept': 'application/json',
        'authorization':
            'Bearer ${sharedPreferences.getString('access_token')}',
        'timeZone': getTimezone()
      }, body: {
        'text': text,
        'filter': filter
      });
      print(text);
      print(filter);
      print(jsonDecode(response.body).toString());
      if (response.statusCode == 200) {
        List<String> sugs = [];
        List data = jsonDecode(response.body)['data'] ?? [];
        //print(data);
        data.forEach((element) {
          sugs.add(element['sug'] ?? '');
        });
        //print(sugs);

        return sugs;
      } else {
        showSnackbar(Text(jsonDecode(response.body)['message'] ?? ''), context);
        print(jsonDecode(response.body));
        return [];
      }
    } catch (e) {
      print('Get Search Sug Error: $e');
      return [];
    }
  }
}
