import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:home_workout_app/constants.dart';
import 'package:home_workout_app/main.dart';
import 'package:home_workout_app/models/create_challenge_model.dart';
import 'package:http/http.dart';

class CreateChallengeAPI {
  static Future<CreateChallengeModel?> createChallenge(
      CreateChallengeModel user, String lang) async {
    try {
      var request = await MultipartRequest("Post", Uri.parse('$base_URL/ch'));
      request.headers['accept'] = 'application/json';
      request.headers['apikey'] = apiKey;
      request.headers['timeZone'] = getTimezone();
      request.headers['authorization'] =
          'Bearer ${sharedPreferences.getString('access_token')}';
      request.fields['name'] = user.name!;
      request.fields['end_time'] = user.end_time!;
      if (user.time == 'true') {
        request.fields['time'] = '1';
      } else {
        request.fields['time'] = '0';
      }
      request.fields['count'] = user.count!;
      request.fields['ex_id'] = user.ex_id!;
      request.fields['desc'] = user.desc!;
      // request.fields['gender'] = gender.name;
      // request.fields['birthdate'] = birthdate.toString();
      // request.fields['country'] = country;
      // request.fields['_method'] = 'PUT';
      print('tiiiiiiiiime');
      print(user.time);
      print(sharedPreferences.get('access_token'));
      if (user.img?.path != '') {
        var pic = await MultipartFile.fromPath("img", user.img!.path);
        request.files.add(pic);
      }

      // final Response response = await post(Uri.parse('$base_URL/ch'),
      //     headers: <String, String>{
      //       // "Access-Control-Allow-Origin": "*",
      //       // 'Content-Type': 'application/json;charset=UTF-8'
      //       'Accept': 'application/json',
      //       'apikey': apiKey,
      //       'lang': lang,
      //       'timeZone': getTimezone()
      //     },
      //     body: user.toJson());

      var response = await request.send();
      var responseData = await response.stream.toBytes();
      var responseString = await String.fromCharCodes(responseData);
      // print(Response.fromStream(response));
      print(responseString);
      print(response.statusCode);

      if (response.statusCode == 200) {
        // responseString
        print('yeeeeeeess');
        return CreateChallengeModel.fromJson(json.decode(responseString));

        // return CreateChallengeModel(message: 'dddddddddddddd', statusCode: 200);
        // CreateChallengeModel.fromJson(json.decode(response.body));
      } else {
        print(response.statusCode);
        // print(response.body);
        return CreateChallengeModel.fromJson(json.decode(responseString));
        // CreateChallengeModel.fromJsonWithErrors(
        //     json.decode(response.body));
      }
    } catch (e) {
      print(e);
    }
    return CreateChallengeModel(
        message: 'There is a problem connecting to the internet'.tr(),
        statusCode: 0);
  }

  Future<List<CreateChallengeModel>> getChallengesList(String lang) async {
    try {
      final response = await get(
        Uri.parse('$base_URL/ch/list'),
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
        List<CreateChallengeModel> challenges = [];

        List data = jsonDecode(response.body)['data'] ?? [];
        data.forEach((element) {
          challenges.add(CreateChallengeModel.fromChallengesJson(element));
        });
        print(challenges);
        return challenges;
      } else {
        print(jsonDecode(response.body));
        return [];
      }
    } catch (e) {
      print('Get challenges List Error: $e');
      return [];
    }
  }
}
