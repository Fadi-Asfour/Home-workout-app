// ignore_for_file: avoid_print, use_build_context_synchronously

import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:home_workout_app/components.dart';
import 'package:home_workout_app/models/health_record_model.dart';
import 'package:home_workout_app/models/user_model.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

import '../constants.dart';
import '../main.dart';

class ProfileApi {
  Future<UserModel> getUserProfile(String lang, BuildContext context) async {
    try {
      print(getTimezone());
      final response =
          await http.get(Uri.parse('$base_URL/user/profile'), headers: {
        'apikey': apiKey,
        'lang': lang,
        'accept': 'application/json',
        'authorization':
            'Bearer ${sharedPreferences.getString('access_token')}',
        'timeZone': getTimezone()
      });

      final data = jsonDecode(response.body);
      print(data);
      if (response.statusCode == 200) {
        UserModel userModel = UserModel.fromJson(jsonDecode(response.body));
        return userModel;
      } else {
        showSnackbar(Text(data['message'].toString()), context);
      }
    } catch (e) {
      showSnackbar(Text(e.toString()), context);
      print('Get profile error: $e');
    }
    return UserModel();
  }

  Future<UserModel> getAnotherUserProfile(
      String lang, int id, BuildContext context) async {
    try {
      final response =
          await http.get(Uri.parse('$base_URL/user/profile/$id'), headers: {
        'apikey': apiKey,
        'lang': lang,
        'accept': 'application/json',
        'authorization':
            'Bearer ${sharedPreferences.getString('access_token')}',
        'timeZone': getTimezone()
      });
      final data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        UserModel _userModel = UserModel.fromJson(jsonDecode(response.body));
        print(_userModel);
        return _userModel;
      } else {
        showSnackbar(Text(data['message']), context);
        print(jsonDecode(response.body));
      }
    } catch (e) {
      showSnackbar(Text(e.toString()), context);
      print('Get another profile error: $e');
    }
    return UserModel();
  }

  Future<dynamic> editProfile(
      String fname,
      String lname,
      XFile image,
      String bio,
      String height,
      String weight,
      Gender gender,
      DateTime birthdate,
      String country,
      BuildContext context,
      Units heightUnit,
      Units weightUnit) async {
    try {
      var request =
          http.MultipartRequest("Post", Uri.parse('$base_URL/user/update'));
      request.headers['accept'] = 'application/json';
      request.headers['apikey'] = apiKey;
      request.headers['timeZone'] = getTimezone();
      request.headers['authorization'] =
          'Bearer ${sharedPreferences.getString('access_token')}';
      request.fields['fname'] = fname;
      request.fields['lname'] = lname;
      request.fields['bio'] = bio;
      request.fields['height'] = height.toString();
      request.fields['weight'] = weight.toString();
      request.fields['gender'] = gender.name;
      request.fields['birthdate'] = birthdate.toString();
      request.fields['country'] = country;
      log(heightUnit.name.toString());
      request.fields['height_unit'] = heightUnit.name.toString();
      request.fields['weight_unit'] = weightUnit.name.toString();
      request.fields['_method'] = 'PUT';

      if (image.path != '') {
        var pic = await http.MultipartFile.fromPath("img", image.path);
        request.files.add(pic);
      }
      var response = await request.send();
      var responseData = await response.stream.toBytes();
      var responseString = String.fromCharCodes(responseData);
      print(responseString);
      if (response.statusCode == 200) {
        return {'success': true, 'message': 'Edited successfully'};
      } else {
        log(response.statusCode.toString());
        return {'success': false, 'message': 'Edit Failed'};
      }
    } catch (e) {
      print('Update profile error: $e');

      return {'success': false, 'message': e.toString()};
    }
  }

  Future<Map> changeEmail(
      String oldEmail, String newEmail, String password) async {
    //const String url = '';
    try {
      final response = await http.post(
        Uri.parse('$base_URL/user/updateEmail'),
        headers: {
          'apikey': apiKey,
          'lang': 'en',
          'accept': 'application/json',
          'authorization':
              'Bearer ${sharedPreferences.getString('access_token')}',
          'timeZone': getTimezone()
        },
        body: {
          'oldEmail': oldEmail,
          'newEmail': newEmail,
          'password': password
        },
      );
      print(jsonDecode(response.body));

      if (response.statusCode == 201) {
        print('Change email success');
        return {
          'success': true,
          'newToken': jsonDecode(response.body)['data']['token']
        };
      } else {
        print('Change email failed');
        print(jsonDecode(response.body));
        return {
          'success': false,
          'newToken': '',
          'message': jsonDecode(response.body)['message']
        };
      }
    } catch (e) {
      print('Change Email Error: $e');
      return {'success': false, 'newToken': '', 'message': e.toString()};
    }
  }

  Future<bool> changePassword(
      String oldPassword, String newPassword, String confirmNewPassword) async {
    try {
      final response = await http.post(
        Uri.parse('$base_URL/user/updatePassword'),
        headers: {
          'apikey': apiKey,
          'lang': 'en',
          'accept': 'application/json',
          'authorization':
              'Bearer ${sharedPreferences.getString('access_token')}',
          'timeZone': getTimezone()
        },
        body: {
          'oldPassword': oldPassword,
          'newPassword': newPassword,
          'newPassword_confirmation': confirmNewPassword
        },
      );
      if (response.statusCode == 200) {
        print('Change Password success');
        return true;
      } else {
        print('Change Password failed');
        print(jsonDecode(response.body));

        return false;
      }
    } catch (e) {
      print('Change Password Error: $e');
    }
    return false;
  }

  Future<bool> logout(String lang) async {
    try {
      final response = await http.get(
        Uri.parse('$base_URL/user/logout'),
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
        return true;
      } else {
        print(jsonDecode(response.body));
        return false;
      }
    } catch (e) {
      print('Logout Error: $e');
      return false;
    }
  }

  Future<bool> logoutFromAll(String lang) async {
    //
    try {
      final response = await http.get(
        Uri.parse('$base_URL/user/all_logout'),
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
        return true;
      } else {
        print(jsonDecode(response.body));
        return false;
      }
    } catch (e) {
      print('Logout Error: $e');
      return false;
    }
  }

  Future<Map<String, dynamic>> followUser(int id, String lang) async {
    try {
      final response = await http.get(
        Uri.parse('$base_URL/user/follow/$id'),
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
        print(data);
        return {
          'success': true,
          'followers': data['data']['followers'],
          'followings': data['data']['followings'],
        };
      } else {
        print(jsonDecode(response.body));
      }
    } catch (e) {
      print('Follow error: $e');
      return {'success': false};
    }
    return {'success': false};
  }

  Future<Map<String, dynamic>> unFollowUser(int id, String lang) async {
    try {
      final response = await http.get(
        Uri.parse('$base_URL/user/unfollow/$id'),
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
        print(data);
        return {
          'success': true,
          'followers': data['data']['followers'],
          'followings': data['data']['followings'],
        };
      } else {
        print(jsonDecode(response.body));
        return {'success': false};
      }
    } catch (e) {
      print('Unfollow error: $e');
      return {'success': false};
    }
  }

  Future<List> getFollowers(String lang, int id) async {
    try {
      final response = await http.get(
        Uri.parse('$base_URL/user/followers/$id'),
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
        List data = jsonDecode(response.body)['data'] ?? [];
        print(data);
        return data;
      } else {
        print(jsonDecode(response.body));
      }
    } catch (e) {
      print('Get followers error: $e');

      return [];
    }
    return [];
  }

  Future<List> getFollowings(String lang, int id) async {
    try {
      final response = await http.get(
        Uri.parse('$base_URL/user/following/$id'),
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
        List data = jsonDecode(response.body)['data'] ?? [];
        print(data);
        return data;
      } else {
        print(jsonDecode(response.body));
      }
    } catch (e) {
      print('Get followings error: $e');

      return [];
    }
    return [];
  }

  Future<Map> blockUser(int id, String lang) async {
    try {
      final response = await http.get(
        Uri.parse('$base_URL/user/block/$id'),
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
          'message': jsonDecode(response.body)['message'] ?? ''
        };
      } else {
        return {
          'success': false,
          'message': jsonDecode(response.body)['message'] ?? ''
        };
      }
    } catch (e) {
      print('Block error: $e');
      return {'success': false, 'message': e.toString()};
    }
  }

  Future<bool> unblockUser(int id, String lang) async {
    try {
      final response = await http.get(
        Uri.parse('$base_URL/user/unblock/$id'),
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
        return true;
      } else {
        print(jsonDecode(response.body));
        return false;
      }
    } catch (e) {
      print('Block error: $e');
      return false;
    }
  }

  Future<Map<String, dynamic>> deleteAccount(
      String password, String lang) async {
    try {
      final response =
          await http.post(Uri.parse('$base_URL/user/delete'), headers: {
        'apikey': apiKey,
        'lang': lang,
        'accept': 'application/json',
        'authorization':
            'Bearer ${sharedPreferences.getString('access_token')}',
        'timeZone': getTimezone()
      }, body: {
        'password': password
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
      return {'success': false, 'message': 'Something went wrong'};
    }
  }

  Future<List> getBlocklist(String lang) async {
    try {
      final response = await http.get(
        Uri.parse('$base_URL/user/blocklist'),
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
        List data = jsonDecode(response.body)['data'] ?? [];
        print(data);
        return data;
      } else {
        print(jsonDecode(response.body));
      }
    } catch (e) {
      print('Get followings error: $e');

      return [];
    }
    return [];
  }

  Future<Map> removeRole(
      {required String lang, required String password}) async {
    try {
      final response =
          await http.post(Uri.parse('$base_URL/cv/deleteRole'), headers: {
        'apikey': apiKey,
        'lang': lang,
        'accept': 'application/json',
        'authorization':
            'Bearer ${sharedPreferences.getString('access_token')}',
        'timeZone': getTimezone()
      }, body: {
        'password': password
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
      print('Remove Role error: $e');
      return {'success': false, 'message': 'Something went wrong'};
    }
  }
}
