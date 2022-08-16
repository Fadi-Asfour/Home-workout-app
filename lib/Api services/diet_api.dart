// ignore_for_file: curly_braces_in_flow_control_structures

import 'dart:convert';
import 'dart:developer';

import 'package:home_workout_app/constants.dart';
import 'package:home_workout_app/models/diet_model.dart';
import 'package:http/http.dart' as http;

import '../main.dart';
import '../models/comments_model.dart';

class DietAPI {
  Future<Map> createDiet(
      {required String name, required List meals, required String lang}) async {
    try {
      print(meals);
      final response =
          await http.post(Uri.parse('$base_URL/diet/create'), headers: {
        'apikey': apiKey,
        'lang': lang,
        'accept': 'application/json',
        'authorization':
            'Bearer ${sharedPreferences.getString('access_token')}',
        'timeZone': getTimezone()
      }, body: {
        'name': name,
        'meals': jsonEncode(meals)
      });
      print(jsonDecode(response.body));
      if (response.statusCode == 200) {
        return {
          'success': true,
          'message': jsonDecode(response.body)['message']
        };
      } else
        return {
          'success': false,
          'message': jsonDecode(response.body)['message']
        };
    } catch (e) {
      print('Create Diet Error: $e');
      return {'success': false, 'message': e.toString()};
    }
  }

  Future<Map> updateDiet(
      {required int id,
      required List meals,
      required String lang,
      required String name}) async {
    try {
      print(meals);
      final response =
          await http.put(Uri.parse('$base_URL/diet/update/$id'), headers: {
        'apikey': apiKey,
        'lang': lang,
        'accept': 'application/json',
        'authorization':
            'Bearer ${sharedPreferences.getString('access_token')}',
        'timeZone': getTimezone()
      }, body: {
        'name': name,
        'meals': jsonEncode(meals)
      });
      print(jsonDecode(response.body));
      if (response.statusCode == 201) {
        return {
          'success': true,
          'message': jsonDecode(response.body)['message']
        };
      } else
        return {
          'success': false,
          'message': jsonDecode(response.body)['message']
        };
    } catch (e) {
      print('Update Diet Error: $e');
      return {'success': false, 'message': e.toString()};
    }
  }

  Future<Map> deleteDiet({required int id, required String lang}) async {
    try {
      final response = await http.delete(
        Uri.parse('$base_URL/diet/delete/$id'),
        headers: {
          'apikey': apiKey,
          'lang': lang,
          'accept': 'application/json',
          'authorization':
              'Bearer ${sharedPreferences.getString('access_token')}',
          'timeZone': getTimezone()
        },
      );

      if (response.statusCode == 201) {
        return {
          'success': true,
          'message': jsonDecode(response.body)['message']
        };
      } else
        return {
          'success': false,
          'message': jsonDecode(response.body)['message']
        };
    } catch (e) {
      print('Delete Diet Error: $e');
      return {'success': false, 'message': e.toString()};
    }
  }

  Future<List<DietModel>> getDietsList(
      {required String lang, required int page}) async {
    print('Called');
    try {
      final response = await http.get(
        Uri.parse('$base_URL/diet/all?page=$page'),
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
        List<DietModel> newDiet = [];
        final data = jsonDecode(response.body)['data'] as List;
        data.forEach((element) {
          newDiet.add(DietModel.fromJson(element));
        });
        return newDiet;
      } else {}
    } catch (e) {
      print('Get Diet List Error: $e');
    }
    return [];
  }

  Future<List<DietModel>> getSavedDiets(
      {required String lang, required int page}) async {
    print('Called');
    try {
      final response = await http.get(
        Uri.parse('$base_URL/diet/favorites?page=$page'),
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
        List<DietModel> newDiet = [];
        final data = jsonDecode(response.body)['data'] as List;
        data.forEach((element) {
          newDiet.add(DietModel.fromJson(element));
        });
        return newDiet;
      } else {}
    } catch (e) {
      print('Get Foods List Error: $e');
    }
    return [];
  }

  Future<List<DietModel>> getUserDiets(
      {required String lang, required int page}) async {
    print('Called');
    try {
      final response = await http.get(
        Uri.parse('$base_URL/diet/my_diets?page=$page'),
        headers: {
          'apikey': apiKey,
          'lang': lang,
          'accept': 'application/json',
          'authorization':
              'Bearer ${sharedPreferences.getString('access_token')}',
          'timeZone': getTimezone()
        },
      );
      //print(jsonDecode(response.body));
      if (response.statusCode == 200) {
        List<DietModel> newDiet = [];
        final data = jsonDecode(response.body)['data'] as List;
        data.forEach((element) {
          newDiet.add(DietModel.fromJson(element));
        });
        return newDiet;
      } else {}
    } catch (e) {
      print('Get My Diets List Error: $e');
    }
    return [];
  }

  Future<List<DietModel>> getUserSavedDiets(
      {required String lang, required int page}) async {
    print('Called');
    try {
      final response = await http.get(
        Uri.parse('$base_URL/diet/my_diets?page=$page'),
        headers: {
          'apikey': apiKey,
          'lang': lang,
          'accept': 'application/json',
          'authorization':
              'Bearer ${sharedPreferences.getString('access_token')}',
          'timeZone': getTimezone()
        },
      );
      //print(jsonDecode(response.body));
      if (response.statusCode == 200) {
        List<DietModel> newDiet = [];
        final data = jsonDecode(response.body)['data'] as List;
        data.forEach((element) {
          newDiet.add(DietModel.fromJson(element));
        });
        return newDiet;
      } else {}
    } catch (e) {
      print('Get My Subscribed Diets List Error: $e');
    }
    return [];
  }

  Future<List<DietModel>> getAnotherUserDiets(
      {required String lang, required int page, required int id}) async {
    print('Called');
    try {
      final response = await http.get(
        Uri.parse('$base_URL/diet/user/$id?page=$page'),
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
        List<DietModel> newDiet = [];
        final data = jsonDecode(response.body)['data'] as List;
        data.forEach((element) {
          newDiet.add(DietModel.fromJson(element));
        });
        return newDiet;
      } else {}
    } catch (e) {
      print('Get Foods List Error: $e');
    }
    return [];
  }

  Future<DietModel> getSpeDiet({required String lang, required int id}) async {
    try {
      final response = await http.get(
        Uri.parse('$base_URL/diet/show/$id'),
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
        return DietModel.fromJsonForFull(jsonDecode(response.body)['data']);
      }
    } catch (e) {
      print('Get Specific Diet Error: $e');
      return DietModel();
    }
    return DietModel();
  }

  Future<Map> saveDiet({required String lang, required int id}) async {
    try {
      final response = await http.get(
        Uri.parse('$base_URL/diet/favorite/$id'),
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
          'message': jsonDecode(response.body)['message']
        };
      } else
        return {
          'success': false,
          'message': jsonDecode(response.body)['message']
        };
    } catch (e) {
      print('Save Diet Error: $e');
      return {'success': false, 'message': e.toString()};
    }
  }

  Future<List<CommentsModel>> getReviews(
      {required int id, required String lang, required int page}) async {
    try {
      final response = await http.get(
        Uri.parse('$base_URL/diet/review/$id?page=$page'),
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
          comments.add(CommentsModel.fromJsonForReview(element));
        });
        print(comments);

        return comments;
      } else {
        print(jsonDecode(response.body));
        return [];
      }
    } catch (e) {
      print('Get Reviews Error: $e');
      return [];
    }
  }

  Future<Map> sendReview(
      {required String lang,
      required int id,
      required String review,
      required double stars}) async {
    try {
      final response =
          await http.post(Uri.parse('$base_URL/diet/review/$id'), headers: {
        'apikey': apiKey,
        'lang': lang,
        'accept': 'application/json',
        'authorization':
            'Bearer ${sharedPreferences.getString('access_token')}',
        'timeZone': getTimezone()
      }, body: {
        'stars': stars.toString(),
        if (review.trim().isNotEmpty) 'description': review
      });

      if (response.statusCode == 200) {
        return {
          'success': true,
          'message': jsonDecode(response.body)['message']
        };
      } else
        return {
          'success': false,
          'message': jsonDecode(response.body)['message']
        };
    } catch (e) {
      print('Send Review Error: $e');
      return {'success': false, 'message': e.toString()};
    }
  }

  Future<Map> deleteReview(
      {required String lang,
      required int reviewId,
      required int dietId}) async {
    try {
      final response = await http.delete(
        Uri.parse('$base_URL/diet/review/$reviewId'),
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
      print('Delete Review Error: $e');
      return {'success': false, 'message': e.toString()};
    }
  }

  Future<Map> deleteReviewForWorkout(
      {required String lang,
      required int reviewId,
      required int workoutId}) async {
    try {
      final response = await http.delete(
        Uri.parse('$base_URL/workout/review/$reviewId'),
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
      print('Delete Review Error: $e');
      return {'success': false, 'message': e.toString()};
    }
  }

  Future<Map> updateReview(
      {required String lang,
      required int reviewId,
      required int dietId,
      required double stars,
      required String comment}) async {
    try {
      log(reviewId.toString());
      final response = await http
          .put(Uri.parse('$base_URL/diet/review/$reviewId'), headers: {
        'apikey': apiKey,
        'lang': lang,
        'accept': 'application/json',
        'authorization':
            'Bearer ${sharedPreferences.getString('access_token')}',
        'timeZone': getTimezone()
      }, body: {
        //'diet_id': dietId.toString(),
        if (comment.trim().isNotEmpty) 'description': comment,
        'stars': stars.toString()
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
      print('Update Review Error: $e');
      return {'success': false, 'message': e.toString()};
    }
  }

  Future<Map> updateReviewForWorkout(
      {required String lang,
      required int reviewId,
      required int workoutId,
      required double stars,
      required String comment}) async {
    try {
      log(reviewId.toString());
      final response = await http
          .put(Uri.parse('$base_URL/workout/review/$reviewId'), headers: {
        'apikey': apiKey,
        'lang': lang,
        'accept': 'application/json',
        'authorization':
            'Bearer ${sharedPreferences.getString('access_token')}',
        'timeZone': getTimezone()
      }, body: {
        //'diet_id': dietId.toString(),
        if (comment.trim().isNotEmpty) 'description': comment,
        'stars': stars.toString()
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
      print('Update Review Error: $e');
      return {'success': false, 'message': e.toString()};
    }
  }

  Future<Map> subscribeDiet({
    required String lang,
    required int id,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$base_URL/diet/subscribe/$id'),
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
        return {
          'success': true,
          'message': jsonDecode(response.body)['message']
        };
      } else
        return {
          'success': false,
          'message': jsonDecode(response.body)['message']
        };
    } catch (e) {
      print('Send Review Error: $e');
      return {'success': false, 'message': e.toString()};
    }
  }
}
