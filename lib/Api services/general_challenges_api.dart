import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:home_workout_app/constants.dart';
import 'package:home_workout_app/main.dart';
import 'package:home_workout_app/models/challenge_model.dart';
import 'package:http/http.dart';

class GeneralChallengesAPI {
  Future<List<ChallengeModel>> getUserchallenges(
      String lang, int? page, String link) async {
    try {
      print('Page $page');
      final response = await get(
        Uri.parse(link == 'out'
            ? '$base_URL/ch?page=$page'
            : '$base_URL/ch/show/$page'),
        headers: {
          'apikey': apiKey,
          'lang': lang,
          'accept': 'application/json',
          'authorization':
              'Bearer ${sharedPreferences.getString('access_token')}',
          'timeZone': getTimezone()
        },
      );
      print(response.body);
      if (response.statusCode == 200) {
        List<ChallengeModel> challenges = [];

        List data = jsonDecode(response.body)['data'] ?? [];
        data.forEach((element) {
          challenges.add(ChallengeModel.fromJson(element));
        });
        print(challenges);
        return challenges;
      } else {
        print(jsonDecode(response.body));
        return [];
      }
    } catch (e) {
      print('Get challenges Error: $e');
      return [];
    }
  }

  Future<ChallengeModel> participate(String lang, int? id) async {
    try {
      // print('Page $page');
      final response = await get(
        Uri.parse('$base_URL/ch/sub/$id'),
        headers: {
          'apikey': apiKey,
          'lang': lang,
          'accept': 'application/json',
          'authorization':
              'Bearer ${sharedPreferences.getString('access_token')}',
          'timeZone': getTimezone()
        },
      );
      print(response.body);
      if (response.statusCode == 200) {
        return ChallengeModel.fromJsonForParticipate(
            json.decode(response.body));
      } else {
        print(response.statusCode);
        print(response.body);
        return ChallengeModel.fromJsonWithErrors(json.decode(response.body));
      }
    } catch (e) {
      print(e);
    }
    return ChallengeModel(
        message: 'There is a problem connecting to the internet'.tr(),
        statusCode: 0);
    // print(response.body);
    // if (response.statusCode == 200) {
    // List<ChallengeModel> challenges = [];

    // List data = jsonDecode(response.body)['data'] ?? [];
    // data.forEach((element) {
    //   challenges.add(ChallengeModel.fromJson(element));
    // });
    // print(challenges);
    // return challenges;
    //   } else {
    //     print(jsonDecode(response.body));
    //     // return [];
    //   }
    // } catch (e) {
    //   print('Get challenges Error: $e');
    //   return [];
    // }
  }

  Future<ChallengeModel> saveSpecificChallengeData(
      ChallengeModel user, int id, String lang) async {
    try {
      String? access_Token = sharedPreferences.getString('access_token');
      print('aceeeeeeeeeeeeeess_token:   $access_Token');
      final Response response = await post(Uri.parse('$base_URL/ch/done/$id'),
          headers: <String, String>{
            // 'Content-Type': 'application/json;charset=UTF-8'
            'Accept': 'application/json',
            'apikey': apiKey,
            'lang': lang,
            'authorization': 'Bearer $access_Token'
          },
          body: user.toJson());
      print(user.toJson());
      print(response.body);
      if (response.statusCode == 200) {
        print(response.body);
        return ChallengeModel.fromJsonWithErrors(json.decode(response.body));
      } else {
        print(response.body);
        return ChallengeModel.fromJsonWithErrors(json.decode(response.body));
      }
    } catch (e) {
      print('object');
      print(e);
    }
    return ChallengeModel(
        message: 'There is a problem connecting to the internet'.tr(),
        statusCode: 0);
  }

  Future<ChallengeModel> deleteChallenge(String lang, int? id) async {
    //business logic to send data to server
    try {
      final Response response = await delete(
        Uri.parse('$base_URL/ch/$id'),
        headers: {
          'apikey': apiKey,
          'lang': lang,
          'accept': 'application/json',
          'authorization':
              'Bearer ${sharedPreferences.getString('access_token')}',
          'timeZone': getTimezone()
        },
      );
      print(response.body);
      if (response.statusCode == 200) {
        return ChallengeModel.fromJsonWithErrors(json.decode(response.body));
      } else {
        print(response.statusCode);
        print(response.body);
        return ChallengeModel.fromJsonWithErrors(json.decode(response.body));
      }
    } catch (e) {
      print(e);
    }
    return ChallengeModel(
        message: 'There is a problem connecting to the internet'.tr(),
        statusCode: 0);
  }
}
