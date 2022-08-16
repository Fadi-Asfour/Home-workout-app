import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:home_workout_app/models/food_model.dart';
import 'package:http/http.dart' as http;

import '../constants.dart';
import '../main.dart';

class FoodAPI {
  Future<Map> createFood({
    required String foodName,
    required String desc,
    required String calories,
    required String pickedImagePath,
    required String lang,
  }) async {
    try {
      var request =
          http.MultipartRequest("Post", Uri.parse('$base_URL/food/create'));
      request.headers['accept'] = 'application/json';
      request.headers['apikey'] = apiKey;
      request.headers['timeZone'] = getTimezone();
      request.headers['authorization'] =
          'Bearer ${sharedPreferences.getString('access_token')}';
      request.fields['name'] = foodName;
      request.fields['calories'] = calories.toString();
      request.fields['description'] = desc;

      var pic =
          await http.MultipartFile.fromPath("food_image", pickedImagePath);
      request.files.add(pic);

      var response = await request.send();
      var responseData = await response.stream.toBytes();
      print(String.fromCharCodes(responseData));
      if (response.statusCode == 201) {
        return {'success': true, 'message': 'Added successfully'.tr()};
      } else {
        return {'success': false, 'message': 'Add Failed'.tr()};
      }
    } catch (e) {
      print('Add Food error: $e');

      return {'success': false, 'message': e.toString()};
    }
  }

  Future<Map> editFood(
      {required int id,
      required String foodName,
      required String calories,
      required String pickedImagePath,
      required String lang,
      required String description}) async {
    try {
      var request =
          http.MultipartRequest("Post", Uri.parse('$base_URL/food/update/$id'));
      request.headers['accept'] = 'application/json';
      request.headers['apikey'] = apiKey;
      request.headers['timeZone'] = getTimezone();
      request.headers['authorization'] =
          'Bearer ${sharedPreferences.getString('access_token')}';

      //request.fields['food_id'] = id.toString();
      request.fields['_method'] = 'PUT';
      request.fields['name'] = foodName;
      request.fields['calories'] = calories.toString();
      request.fields['description'] = description.toString();

      if (pickedImagePath != '') {
        var pic =
            await http.MultipartFile.fromPath("food_image", pickedImagePath);
        request.files.add(pic);
      }

      var response = await request.send();
      var responseData = await response.stream.toBytes();
      print(String.fromCharCodes(responseData));
      if (response.statusCode == 200) {
        return {'success': true, 'message': 'Edited successfully'.tr()};
      } else {
        return {'success': false, 'message': 'Edit Failed'.tr()};
      }
    } catch (e) {
      print('Edit Food error: $e');

      return {'success': false, 'message': e.toString()};
    }
  }

  Future<List<FoodModel>> getFoodsList(
      {required String lang, required int page}) async {
    print('Called');
    try {
      final response = await http.get(
        Uri.parse('$base_URL/food/all'),
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
        List<FoodModel> newFoods = [];
        final data = jsonDecode(response.body)['data'] as List;
        data.forEach((element) {
          newFoods.add(FoodModel.fromJson(element));
        });
        return newFoods;
      } else {}
    } catch (e) {
      print('Get Foods List Error: $e');
    }
    return [];
  }

  Future<Map> deleteFood({required String lang, required int foodId}) async {
    try {
      final response = await http.delete(
        Uri.parse('$base_URL/food/delete/$foodId'),
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
      print('Delete Food Error: $e');
      return {
        'success': false,
        'message': e.toString(),
      };
    }
  }
}
