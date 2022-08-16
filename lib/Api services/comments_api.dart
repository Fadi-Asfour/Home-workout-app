import 'dart:convert';

import '../constants.dart';
import '../main.dart';
import 'package:http/http.dart' as http;

import '../models/comments_model.dart';

class CommentsApi {
  Future<List<CommentsModel>> getComments(
      {required int id, required String lang, required int page}) async {
    try {
      final response = await http.get(
        Uri.parse('$base_URL/posts/comment/$id?page=$page'),
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
        List<CommentsModel> comments = [];
        data.forEach((element) {
          comments.add(CommentsModel.fromJson(element));
        });
        print(comments);

        return comments;
      } else {
        print(jsonDecode(response.body));
        return [];
      }
    } catch (e) {
      print('Get Comments Error: $e');
      return [];
    }
  }

  Future<Map> sendCommet({
    required String comment,
    required int postId,
    required String lang,
  }) async {
    try {
      final response = await http
          .post(Uri.parse('$base_URL/posts/comment/$postId'), headers: {
        'apikey': apiKey,
        'lang': lang,
        'accept': 'application/json',
        'authorization':
            'Bearer ${sharedPreferences.getString('access_token')}',
        'timeZone': getTimezone()
      }, body: {
        'text': comment
      });
      if (response.statusCode == 200) {
        print(jsonDecode(response.body));
        return {
          'success': true,
          'message': jsonDecode(response.body)['message'],
          'data': jsonDecode(response.body)['data'][0] ?? {}
        };
      } else {
        print(jsonDecode(response.body));
        return {
          'success': false,
          'message': jsonDecode(response.body)['message']
        };
      }
    } catch (e) {
      print('Create Poll Post Error: $e');
      return {'success': false, 'message': e.toString()};
    }
  }

  Future<Map> deleteComment(
      {required String lang, required int commentId}) async {
    try {
      final response = await http
          .delete(Uri.parse('$base_URL/posts/comment/$commentId'), headers: {
        'apikey': apiKey,
        'lang': lang,
        'accept': 'application/json',
        'authorization':
            'Bearer ${sharedPreferences.getString('access_token')}',
        'timeZone': getTimezone()
      }, body: {
        //'comment_id': commentId.toString()
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
      print('Create Poll Post Error: $e');
      return {'success': false, 'message': e.toString()};
    }
  }

  Future<Map> updateComment(
      {required String lang,
      required int commentId,
      required String comment}) async {
    try {
      final response = await http
          .post(Uri.parse('$base_URL/posts/comment/$commentId'), headers: {
        'apikey': apiKey,
        'lang': lang,
        'accept': 'application/json',
        'authorization':
            'Bearer ${sharedPreferences.getString('access_token')}',
        'timeZone': getTimezone()
      }, body: {
        'text': comment,
        '_method': 'PUT'
      });
      print('Update' + jsonDecode(response.body).toString());
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
      print('Create Poll Post Error: $e');
      return {'success': false, 'message': e.toString()};
    }
  }

  Future<Map> reportComment({
    required String lang,
    required int commentId,
  }) async {
    try {
      final response = await http.get(
        Uri.parse('$base_URL/posts/comment/report/$commentId'),
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
      print('Create Poll Post Error: $e');
      return {'success': false, 'message': e.toString()};
    }
  }
}
