import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:home_workout_app/constants.dart';
import 'package:home_workout_app/main.dart';
import 'package:home_workout_app/models/create_workout_model.dart';
import 'package:http/http.dart';

class CreateWorkoutAPI {
  Future<List<CreateworkoutModel>> getCategoriesList(String lang) async {
    try {
      final response = await get(
        Uri.parse('$base_URL/workout_categorie/all/categories'),
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
        List<CreateworkoutModel> Exersises = [];

        List data = jsonDecode(response.body)['data'] ?? [];
        data.forEach((element) {
          Exersises.add(CreateworkoutModel.fromCategoriesJson(element));
        });
        print(Exersises);
        return Exersises;
      } else {
        print(jsonDecode(response.body));
        return [];
      }
    } catch (e) {
      print('Get Categories List Error: $e');
      return [];
    }
  }

  Future<List<CreateworkoutModel>> getExercisesList(String lang) async {
    try {
      final response = await get(
        Uri.parse('$base_URL/excersise/all'),
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
        List<CreateworkoutModel> Exersises = [];

        List data = jsonDecode(response.body)['data'] ?? [];
        data.forEach((element) {
          Exersises.add(CreateworkoutModel.fromExercisesJson(element));
        });
        print(Exersises);
        return Exersises;
      } else {
        print(jsonDecode(response.body));
        return [];
      }
    } catch (e) {
      print('Get Exersises List Error: $e');
      return [];
    }
  }

  static Future<CreateworkoutModel?> EditWorkoutWithoutImage(
      CreateworkoutModel user, String link, String lang) async {
    try {
      // print(sharedPreferences.get('access_token'));
      // String link;
      // if (user.id == -1 || user.id == 0) {
      //   link = '$base_URL/workout/create';
      // } else {
      //   link = '$base_URL/workout/update/${user.id}';
      // }
      print(link);
      final Response response = await post(Uri.parse('$base_URL$link'),
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
        return CreateworkoutModel.fromJson(json.decode(response.body));
      } else {
        print(response.statusCode);
        // print(response.body);
        return CreateworkoutModel.fromJsonWithErrors(
            json.decode(response.body));
        // CreateworkoutModel.fromJsonWithErrors(
        //     json.decode(response.body));
      }
    } catch (e) {
      print(e);
    }
    return CreateworkoutModel(
        message: 'There is a problem connecting to the internet'.tr(),
        statusCode: 0);
  }

  static Future<CreateworkoutModel?> CreateWorkout(
      CreateworkoutModel user, String url, String lang) async {
    try {
      var request = MultipartRequest("Post", Uri.parse('$base_URL$url'));
      request.headers['accept'] = 'application/json';
      request.headers['apikey'] = apiKey;
      request.headers['timeZone'] = getTimezone();
      request.headers['authorization'] =
          'Bearer ${sharedPreferences.getString('access_token')}';
      request.fields['name'] = user.name!;
      // print('dddddaaaaaaaaaa' + user.description!);
      print(user.workout_image?.path);
      request.fields['categorie_id'] = user.categorie_id!;
      request.fields['equipment'] = user.equipment!;
      request.fields['difficulty'] = user.difficulty!;
      request.fields['description'] = user.desc!;
      request.fields['excersises'] = jsonEncode(user.excersisesList!);
      // if (user.time == 'true') {
      //   request.fields['time'] = '1';
      // } else {
      //   request.fields['time'] = '0';
      // }

      // request.fields['desc'] = user.desc!;

      print(sharedPreferences.get('access_token'));

      if (user.workout_image?.path != '') {
        print('............................');
        var pic = await MultipartFile.fromPath(
            "workout_image", user.workout_image!.path);
        request.files.add(pic);
        print(user.workout_image?.path);
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
        return CreateworkoutModel.fromJson(json.decode(responseString));

        // return CreateworkoutModel(message: 'dddddddddddddd', statusCode: 201);
        // CreateworkoutModel.fromJson(json.decode(response.body));
      } else {
        print(response.statusCode);
        // print(response.body);
        return CreateworkoutModel.fromJsonWithErrors(
            json.decode(responseString));

        // CreateworkoutModel.fromJsonWithErrors(
        //     json.decode(response.body));
      }
    } catch (e) {
      // print('dddddaaaaaaaaaa' + user.description!);
      print("error in posting workout with image $e");
      return CreateworkoutModel(
          message: 'There is a problem connecting to the internet'.tr(),
          statusCode: 0);
    }
  }
}
