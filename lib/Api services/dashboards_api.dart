import 'dart:convert';

import 'package:home_workout_app/components.dart';
import 'package:home_workout_app/constants.dart';
import 'package:home_workout_app/models/comments_model.dart';
import 'package:home_workout_app/models/cv_model.dart';
import 'package:home_workout_app/models/dashboard_model.dart';
import 'package:home_workout_app/models/post_models.dart';
import 'package:http/http.dart' as http;

import '../main.dart';

class DashboardsAPI {
  Future<DashboardModel> getDashboards({required String lang}) async {
    try {
      final response = await http.get(
        Uri.parse('$base_URL/dash'),
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
        return DashboardModel.fromJson(jsonDecode(response.body));
      } else {}
    } catch (e) {
      print('Get Dashboards Error: $e');
    }
    return DashboardModel();
  }

  Future<List<PostModel>> getPostsDashboard(
      {required String lang, required int page}) async {
    try {
      final response = await http.get(
        Uri.parse('$base_URL/dash/posts?page=$page'),
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
        List<PostModel> newPosts = [];
        final data = jsonDecode(response.body)['data'] as List;
        data.forEach((element) {
          newPosts.add(PostModel.fromJsonForDash(element));
        });
        return newPosts;
      } else {}
    } catch (e) {
      print('Get Posts Dashboards Error: $e');
    }
    return [];
  }

  Future<List<PostModel>> getReportedPostDashboard(
      {required String lang, required int page}) async {
    try {
      final response = await http.get(
        Uri.parse('$base_URL/dash/repPosts?page=$page'),
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
        List<PostModel> newPosts = [];
        final data = jsonDecode(response.body)['data'] as List;
        data.forEach((element) {
          newPosts.add(PostModel.fromJsonForDash(element));
        });
        return newPosts;
      } else {}
    } catch (e) {
      print('Get Reported Posts Dashboards Error: $e');
    }
    return [];
  }

  Future<List<CVModel>> getCVsDashbaord(
      {required String lang, required int page}) async {
    try {
      final response = await http.get(
        Uri.parse('$base_URL/dash/cvs?page=$page'),
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
        List<CVModel> newCVs = [];
        final data = jsonDecode(response.body)['data'] as List;
        data.forEach((element) {
          newCVs.add(CVModel.fromJsonForList(element));
        });
        return newCVs;
      } else {}
    } catch (e) {
      print('Get CVs Dashboards Error: $e');
    }
    return [];
  }

  Future<List<CommentsModel>> getReportedCommentsDashbaord(
      {required String lang, required int page}) async {
    try {
      final response = await http.get(
        Uri.parse('$base_URL/dash/RPComments?page=$page'),
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
        List<CommentsModel> newComments = [];
        final data = jsonDecode(response.body)['data'] as List;
        data.forEach((element) {
          newComments.add(CommentsModel.fromJson(element));
        });
        return newComments;
      } else {}
    } catch (e) {
      print('Get Reported Comments Dashboards Error: $e');
    }
    return [];
  }

  Future<Map> ARPost(
      {required String lang, required String id, required bool acc}) async {
    try {
      final response = await http.get(
        Uri.parse('$base_URL/dash/ARPosts/$id'),
        headers: {
          'apikey': apiKey,
          'lang': lang,
          'accept': 'application/json',
          'authorization':
              'Bearer ${sharedPreferences.getString('access_token')}',
          'timeZone': getTimezone(),
          'acc': acc.toString(),
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

  Future<Map> ARComments(
      {required String lang, required String id, required bool acc}) async {
    try {
      final response = await http.get(
        Uri.parse('$base_URL/dash/ARComments/$id'),
        headers: {
          'apikey': apiKey,
          'lang': lang,
          'accept': 'application/json',
          'authorization':
              'Bearer ${sharedPreferences.getString('access_token')}',
          'timeZone': getTimezone(),
          'acc': acc.toString(),
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
