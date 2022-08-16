// ignore_for_file: curly_braces_in_flow_control_structures, use_build_context_synchronously

import 'package:flutter/cupertino.dart';
import 'package:home_workout_app/Api%20services/diet_api.dart';
import 'package:home_workout_app/components.dart';
import 'package:home_workout_app/models/diet_model.dart';

class DietListViewModel with ChangeNotifier {
  List<DietModel> _diets = [];
  int _page = 0;
  bool _isLoading = false;
  bool _isDeleteLoading = false;
  bool _isReviewLoading = false;

  void changeIsReviews({required int dietId, required bool value}) {
    _diets.firstWhere((element) => element.id == dietId).reviewd = value;
    notifyListeners();
  }

  void setIsReviewLoading(value) {
    _isReviewLoading = value;
    notifyListeners();
  }

  void reset() {
    _diets.clear();
    _page = 0;
    _isLoading = false;
    _isDeleteLoading = false;
    notifyListeners();
  }

  void setIsLoading(value) {
    _isLoading = value;
    notifyListeners();
  }

  void setIsDeleteLoading(value) {
    _isDeleteLoading = value;
    notifyListeners();
  }

  void setPage(int i) {
    _page = i;
    notifyListeners();
  }

  Future<void> deleteDiet(
      {required String lang,
      required int id,
      required BuildContext context}) async {
    setIsDeleteLoading(true);
    final response = await DietAPI().deleteDiet(id: id, lang: lang);

    if (response['success']) {
      showSnackbar(Text(response['message'].toString()), context);
      _diets.removeWhere((element) => element.id == id);
      notifyListeners();
    } else {
      showSnackbar(Text(response['message'].toString()), context);
    }
    setIsDeleteLoading(false);
  }

  Future<bool> sendReview(
      {required String lang,
      required int id,
      required String review,
      required double stars,
      required BuildContext context}) async {
    setIsReviewLoading(true);
    final response = await DietAPI()
        .sendReview(id: id, lang: lang, review: review, stars: stars);

    setIsReviewLoading(false);

    if (response['success']) {
      return true;
    } else {
      showSnackbar(Text(response['message'].toString()), context);
      return false;
    }
  }

  Future<bool> saveDiet(
      {required String lang,
      required int id,
      required BuildContext context}) async {
    final response = await DietAPI().saveDiet(id: id, lang: lang);

    if (response['success']) {
      return true;
    } else {
      showSnackbar(Text(response['message'].toString()), context);
      return false;
    }
  }

  Future<void> getDietsList({required String lang}) async {
    setIsLoading(true);
    setPage(getPage + 1);
    final response = await DietAPI().getDietsList(lang: lang, page: getPage);
    if (response.isEmpty)
      setPage(getPage - 1);
    else
      _diets.addAll(response);
    // _diets.clear();
    // if (_diets.isEmpty)
    //   _diets.add(
    //     DietModel.fromJson(
    //       {
    //         "name": "Keto Diet",
    //         "created_by": {
    //           "id": 8,
    //           "f_name": "Ammar",
    //           "l_name": "Hunaidi",
    //           "email": "ammar.hunaidi.01@gmail.com",
    //           "lang_country": null,
    //           "prof_img_url":
    //               "Default/RrmDmqreoLbR6dhjSVuFenDAii8uBWdqhi2fYSjK9pRISPykLSdefaultprofileimg.jpg",
    //           "gender": "male",
    //           "birth_date": "1990-05-05",
    //           "bio": "",
    //           "country": "Syria",
    //           "email_verified_at": "2022-07-07T02:13:02.000000Z",
    //           "deleted_at": null,
    //           "role_id": 3,
    //           "created_at": "2022-07-07T02:13:02.000000Z",
    //           "updated_at": "2022-07-07T02:13:02.000000Z"
    //         },
    //         "schedule": [
    //           {
    //             "day": 1,
    //             "meals": [
    //               {
    //                 "id": 2,
    //                 "type": "breakfast",
    //                 "description": "Hello",
    //                 "calorie_count": 80,
    //                 "user_id": 8,
    //                 "created_at": "2022-08-02T10:57:08.000000Z",
    //                 "updated_at": "2022-08-02T10:57:08.000000Z"
    //               }
    //             ]
    //           },
    //           {
    //             "day": 2,
    //             "meals": [
    //               {
    //                 "id": 3,
    //                 "type": "lunch",
    //                 "description": "How",
    //                 "calorie_count": 100,
    //                 "user_id": 8,
    //                 "created_at": "2022-08-02T10:57:48.000000Z",
    //                 "updated_at": "2022-08-02T10:57:48.000000Z"
    //               },
    //               {
    //                 "id": 4,
    //                 "type": "snack",
    //                 "description": "are",
    //                 "calorie_count": 50,
    //                 "user_id": 8,
    //                 "created_at": "2022-08-02T10:58:09.000000Z",
    //                 "updated_at": "2022-08-02T10:58:09.000000Z"
    //               }
    //             ]
    //           },
    //           {
    //             "day": 3,
    //             "meals": [
    //               {
    //                 "id": 4,
    //                 "type": "snack",
    //                 "description": "are",
    //                 "calorie_count": 50,
    //                 "user_id": 8,
    //                 "created_at": "2022-08-02T10:58:09.000000Z",
    //                 "updated_at": "2022-08-02T10:58:09.000000Z"
    //               }
    //             ]
    //           },
    //           {
    //             "day": 4,
    //             "meals": [
    //               {
    //                 "id": 3,
    //                 "type": "lunch",
    //                 "description": "How",
    //                 "calorie_count": 100,
    //                 "user_id": 8,
    //                 "created_at": "2022-08-02T10:57:48.000000Z",
    //                 "updated_at": "2022-08-02T10:57:48.000000Z"
    //               },
    //               {
    //                 "id": 5,
    //                 "type": "dinner",
    //                 "description": "you",
    //                 "calorie_count": 180,
    //                 "user_id": 8,
    //                 "created_at": "2022-08-02T10:58:23.000000Z",
    //                 "updated_at": "2022-08-02T10:58:23.000000Z"
    //               }
    //             ]
    //           },
    //           {
    //             "day": 5,
    //             "meals": [
    //               {
    //                 "id": 2,
    //                 "type": "breakfast",
    //                 "description": "Hello",
    //                 "calorie_count": 80,
    //                 "user_id": 8,
    //                 "created_at": "2022-08-02T10:57:08.000000Z",
    //                 "updated_at": "2022-08-02T10:57:08.000000Z"
    //               }
    //             ]
    //           }
    //         ]
    //       },
    //     ),
    //   );

    setIsLoading(false);
  }

  List<DietModel> get getDiets => _diets;
  int get getPage => _page;
  bool get getIsLoading => _isLoading;
  bool get getIsDeleteLoading => _isDeleteLoading;
  bool get getIsREviewLoading => _isReviewLoading;
}
