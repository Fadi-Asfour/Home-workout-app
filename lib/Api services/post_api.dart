// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:home_workout_app/components.dart';
import 'package:home_workout_app/constants.dart';
import 'package:home_workout_app/models/comments_model.dart';
import 'package:home_workout_app/models/post_models.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:video_compress/video_compress.dart';

import '../main.dart';

class PostAPI {
  Future<Map> postNormalPost(
      {required String title,
      required List<XFile> images,
      required String lang,
      required List<XFile> videos}) async {
    try {
      var request = http.MultipartRequest("Post", Uri.parse('$base_URL/posts'));
      request.headers['accept'] = 'application/json';
      request.headers['apikey'] = apiKey;
      request.headers['lang'] = lang;
      request.headers['timeZone'] = getTimezone();
      request.headers['authorization'] =
          'Bearer ${sharedPreferences.getString('access_token')}';

      request.fields['text'] = title;

      List<http.MultipartFile> media = [];
      // media.addAll(videos);
      // media.addAll(images);

      for (int i = 0; i < images.length; i++) {
        var pic =
            await http.MultipartFile.fromPath('media[$i]', images[i].path);
        print(i);
        media.add(pic);
      }
      for (int i = 0; i < videos.length; i++) {
        var pic = await http.MultipartFile.fromPath(
            'media[${i + images.length}]', videos[i].path);
        print(i);

        media.add(pic);
      }

      request.files.addAll(media);
      request.files.forEach((element) {
        print('field: ' + element.field);
      });

      var response = await request.send();
      var responseData = await response.stream.toBytes();
      var responseString = String.fromCharCodes(responseData);
      if (response.statusCode == 200) {
        return {'success': true, 'message': responseString};
      } else {
        return {'success': false, 'message': responseString};
      }
      return {};
    } catch (e) {
      print('Create Normal Post error: $e');

      return {'success': false, 'message': e.toString()};
    }
  }

  Future<Map> updateNormalPost(
      {required String newtitle,
      required List<XFile> newimages,
      required List<XFile> newvideos,
      required int postId,
      required String lang,
      required List<int> deletedMedia}) async {
    try {
      var request = http.MultipartRequest(
          "Post", Uri.parse('$base_URL/posts/update/$postId'));
      request.headers['accept'] = 'application/json';
      request.headers['apikey'] = apiKey;
      request.headers['timeZone'] = getTimezone();
      request.headers['lang'] = lang;
      request.headers['authorization'] =
          'Bearer ${sharedPreferences.getString('access_token')}';

      request.fields['text'] = newtitle;
      request.fields['_method'] = 'PUT';
      request.fields['deleteMedia'] = jsonEncode(deletedMedia);

      List<http.MultipartFile> media = [];

      for (int i = 0; i < newimages.length; i++) {
        var pic = await http.MultipartFile.fromPath(
            'addMedia[$i]', newimages[i].path);
        media.add(pic);
      }
      for (int i = 0; i < newvideos.length; i++) {
        var pic = await http.MultipartFile.fromPath(
            'addMedia[${i + newimages.length}]', newvideos[i].path);

        media.add(pic);
      }

      request.files.addAll(media);

      var response = await request.send();
      var responseData = await response.stream.toBytes();
      var responseString = String.fromCharCodes(responseData);
      if (response.statusCode == 200) {
        return {'success': true, 'message': responseString};
      } else {
        return {'success': false, 'message': responseString};
      }
    } catch (e) {
      print('Update Normal Post error: $e');

      return {'success': false, 'message': e.toString()};
    }
  }

  Future<Map> postPoll(
      {required int type,
      required String title,
      required List choices,
      required String lang}) async {
    try {
      print(title);
      final response =
          await http.post(Uri.parse('$base_URL/posts/poll'), headers: {
        'apikey': apiKey,
        'lang': lang,
        'accept': 'application/json',
        'authorization':
            'Bearer ${sharedPreferences.getString('access_token')}',
        'timeZone': getTimezone()
      }, body: {
        'type': type.toString(),
        'text': title,
        if (type == 3) 'votes': jsonEncode(choices)
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

  Future<Map> updatePollPost(
      {required int type,
      required int postId,
      required String newtitle,
      required List newchoices,
      required String lang,
      required List<int> deletedChoices}) async {
    try {
      final response = await http
          .post(Uri.parse('$base_URL/posts/updatePoll/$postId'), headers: {
        'apikey': apiKey,
        'lang': lang,
        'accept': 'application/json',
        'authorization':
            'Bearer ${sharedPreferences.getString('access_token')}',
        'timeZone': getTimezone()
      }, body: {
        'type': type.toString(),
        'text': newtitle,
        '_method': 'PUT',
        if (type == 3) 'deleteVote': jsonEncode(deletedChoices),
        if (type == 3) 'addVote': jsonEncode(newchoices)
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

  Future<List<PostModel>> getPosts(
      String lang, int page, BuildContext context) async {
    try {
      print('Page $page');
      final response = await http.get(
        Uri.parse('$base_URL/posts?page=$page'),
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
        List<PostModel> posts = [];

        List data = jsonDecode(response.body)['data'] ?? [];
        data.forEach((element) {
          posts.add(PostModel.fromJson(element));
        });
        return posts;
      } else {
        showSnackbar(Text(jsonDecode(response.body)['message'] ?? ''), context);
        return [];
      }
    } catch (e) {
      print('Get Normal Posts Error: $e');
      return [];
    }
  }

  Future<List<PostModel>> getSavedPosts(
      String lang, int page, BuildContext context) async {
    try {
      print('Page $page');
      final response = await http.get(
        Uri.parse('$base_URL/posts/savedPosts?page=$page'),
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
        List<PostModel> posts = [];

        List data = jsonDecode(response.body)['data'] ?? [];
        data.forEach((element) {
          posts.add(PostModel.fromJson(element));
        });
        print(posts);
        return posts;
      } else {
        showSnackbar(Text(jsonDecode(response.body)['message'] ?? ''), context);

        print(jsonDecode(response.body));
        return [];
      }
    } catch (e) {
      print('Get Posts Error: $e');
      return [];
    }
  }

  Future<List<PostModel>> getUserPosts(String lang, int page) async {
    try {
      print('Page $page');
      final response = await http.get(
        Uri.parse('$base_URL/posts/myPosts?page=$page'),
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
        List<PostModel> posts = [];

        List data = jsonDecode(response.body)['data'] ?? [];
        data.forEach((element) {
          posts.add(PostModel.fromJson(element));
        });
        print(posts);
        return posts;
      } else {
        print(jsonDecode(response.body));
        return [];
      }
    } catch (e) {
      print('Get Posts Error: $e');
      return [];
    }
  }

  Future<List<PostModel>> getAnotherUserPosts(
      String lang, int page, int userId, BuildContext context) async {
    try {
      print('Page $page');
      final response = await http.get(
        Uri.parse('$base_URL/posts/showPosts/$userId?page=$page'),
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
        List<PostModel> posts = [];

        List data = jsonDecode(response.body)['data'] ?? [];
        data.forEach((element) {
          posts.add(PostModel.fromJson(element));
        });
        print(posts);
        return posts;
      } else {
        showSnackbar(Text(jsonDecode(response.body)['message'] ?? ''), context);

        print(jsonDecode(response.body));
        return [];
      }
    } catch (e) {
      print('Get Posts Error: $e');
      return [];
    }
  }

  Future<Map> savePost({required String lang, required int postId}) async {
    try {
      final response = await http.get(
        Uri.parse('$base_URL/posts/save/$postId'),
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
        return {
          'success': true,
          'message': jsonDecode(response.body)['message'] ?? '',
        };
      } else {
        return {
          'success': false,
          'message': jsonDecode(response.body)['message'] ?? '',
        };
      }
    } catch (e) {
      print('Save Posts Error: $e');
      return {
        'success': false,
        'message': e.toString(),
      };
    }
  }

  Future<Map> likePost(
      {required String lang, required int postId, required int likeId}) async {
    try {
      final response = await http.get(
        Uri.parse('$base_URL/posts/like/$postId/$likeId'),
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
        return {
          'success': true,
          'message': jsonDecode(response.body)['message'] ?? '',
          'data': jsonDecode(response.body)['data'] ?? {}
        };
      } else {
        return {
          'success': false,
          'message': jsonDecode(response.body)['message'] ?? '',
          'data': {}
        };
      }
    } catch (e) {
      print('Like Post Error: $e');
      return {'success': false, 'message': e.toString(), 'data': {}};
    }
  }

  Future<Map> reportPost({required String lang, required int postId}) async {
    try {
      final response = await http.get(
        Uri.parse('$base_URL/posts/report/$postId'),
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
        return {
          'success': true,
          'message': jsonDecode(response.body)['message'] ?? '',
        };
      } else {
        return {
          'success': false,
          'message': jsonDecode(response.body)['message'] ?? '',
        };
      }
    } catch (e) {
      print('Report Post Error: $e');
      return {
        'success': false,
        'message': e.toString(),
      };
    }
  }

  Future<Map> deletePost({required String lang, required int postId}) async {
    try {
      final response = await http.delete(
        Uri.parse('$base_URL/posts/$postId'),
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
        return {
          'success': true,
          'message': jsonDecode(response.body)['message'] ?? '',
        };
      } else {
        return {
          'success': false,
          'message': jsonDecode(response.body)['message'] ?? '',
        };
      }
    } catch (e) {
      print('Delete Post Error: $e');
      return {
        'success': false,
        'message': e.toString(),
      };
    }
  }

  Future<Map> votePost(
      {required String lang, required int postId, required int voteId}) async {
    try {
      final response = await http.get(
        Uri.parse('$base_URL/posts/vote/$postId/$voteId'),
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
          'message': jsonDecode(response.body)['message'] ?? '',
          'newVotes': jsonDecode(response.body)['data'] ?? []
        };
      } else {
        print(jsonDecode(response.body));
        return {
          'success': false,
          'message': jsonDecode(response.body)['message'] ?? '',
          'newVotes': jsonDecode(response.body)['data'] ?? []
        };
      }
    } catch (e) {
      print('Vote Post Error: $e');
      return {
        'success': false,
        'message': e.toString(),
      };
    }
  }
}
