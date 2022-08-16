import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:home_workout_app/constants.dart';
import 'package:home_workout_app/main.dart';
import 'package:home_workout_app/models/create_exercise_model.dart';
import 'package:http/http.dart';

class CreateExerciseAPI {
  static Future<CreateExerciseModel?> createExercise(
      CreateExerciseModel user, String url, String lang) async {
    try {
      var request = MultipartRequest("Post", Uri.parse('$base_URL$url'));
      request.headers['accept'] = 'application/json';
      request.headers['apikey'] = apiKey;
      request.headers['timeZone'] = getTimezone();
      request.headers['authorization'] =
          'Bearer ${sharedPreferences.getString('access_token')}';
      request.fields['name'] = user.name!;
      print('dddddaaaaaaaaaa' + user.description!);
      print(user.img?.path);
      request.fields['description'] = user.description!;
      request.fields['burn_calories'] = user.burn_calories!;
      // if (user.time == 'true') {
      //   request.fields['time'] = '1';
      // } else {
      //   request.fields['time'] = '0';
      // }
      // request.fields['count'] = user.count!;
      // request.fields['ex_id'] = user.ex_id!;
      // request.fields['desc'] = user.desc!;

      print(sharedPreferences.get('access_token'));

      if (user.img?.path != '') {
        print('............................');
        var pic =
            await MultipartFile.fromPath("excersise_media", user.img!.path);
        request.files.add(pic);
        print(user.img?.path);
        print(pic);
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
      var responseString = String.fromCharCodes(responseData);
      // print(Response.fromStream(response));
      print(responseString);
      print(response.statusCode);

      if (response.statusCode == 201 || response.statusCode == 200) {
        // responseString
        print('yeeeeeeess');
        return CreateExerciseModel.fromJson(json.decode(responseString));

        // return CreateExerciseModel(message: 'dddddddddddddd', statusCode: 201);
        // CreateExerciseModel.fromJson(json.decode(response.body));
      } else {
        print(response.statusCode);
        // print(response.body);
        return CreateExerciseModel.fromJsonWithErrors(
            json.decode(responseString));

        // CreateExerciseModel.fromJsonWithErrors(
        //     json.decode(response.body));
      }
    } catch (e) {
      print('dddddaaaaaaaaaa' + user.description!);
      print("error in posting exercise $e");
      return CreateExerciseModel(
          message: 'There is a problem connecting to the internet'.tr(),
          statusCode: 0);
    }
  }

  static Future<CreateExerciseModel?> editExerciseWithoutImage(
      CreateExerciseModel user, String id, String lang) async {
    try {
      print(sharedPreferences.get('access_token'));
      print(id);
      final Response response =
          await post(Uri.parse('$base_URL/excersise/update/$id'),
              headers: <String, String>{
                // "Access-Control-Allow-Origin": "*",
                // 'Content-Type': 'application/json;charset=UTF-8'
                'Accept': 'application/json',
                'apikey': apiKey,
                'lang': lang,
                'authorization':
                    'Bearer ${sharedPreferences.getString('access_token')}',
                'timeZone': getTimezone()
              },
              body: user.toJson());
      print(user.toJson());
      print(response.body);
      if (response.statusCode.toString() == '201' ||
          response.statusCode.toString() == '200') {
        // responseString
        print('yeeeeeeess');
        return CreateExerciseModel.fromJson(json.decode(response.body));
      } else {
        print(response.statusCode);
        // print(response.body);
        return CreateExerciseModel.fromJsonWithErrors(
            json.decode(response.body));
        // CreateExerciseModel.fromJsonWithErrors(
        //     json.decode(response.body));
      }
    } catch (e) {
      print(e);
    }
    return CreateExerciseModel(
        message: 'There is a problem connecting to the internet'.tr(),
        statusCode: 0);
  }
}
