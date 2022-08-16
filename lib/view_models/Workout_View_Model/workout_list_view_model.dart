import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:home_workout_app/Api%20services/workout_list_api.dart';
import 'package:home_workout_app/components.dart';
import 'package:home_workout_app/models/workout_list_model.dart';

class WorkoutListViewModel with ChangeNotifier {
  List<WorkoutListModel>? workoutsList = [];

  List<WorkoutListModel>? CategoriesList = [];
  String PickedCategoryValue = '';
  String PickedDifficultyValue = 'All';
  int CategoryNumber = 1;
  int DifficultyNumber = 4;
  int page = 1;
  bool isLoading = false;
  bool CategoriesfetchedList = false;

  bool _isReviewLoading = false;

  void changeIsReviews({required int dietId, required bool value}) {
    if (workoutsList != null && workoutsList!.isNotEmpty)
      workoutsList!.firstWhere((element) => element.id == dietId).reviewd =
          value;
    notifyListeners();
  }

  Future<bool> sendReview(
      {required String lang,
      required int id,
      required String review,
      required double stars,
      required BuildContext context}) async {
    setIsReviewLoading(true);
    final response = await WorkoutListsAPI()
        .sendReview(id: id, lang: lang, review: review, stars: stars);

    setIsReviewLoading(false);

    if (response['success']) {
      return true;
    } else {
      showSnackbar(Text(response['message'].toString()), context);
      return false;
    }
  }

  void setIsReviewLoading(value) {
    _isReviewLoading = value;
    notifyListeners();
  }

  // bool DiffetchedList = false;
  List<String>? difficultyList = ['All', 'Easy', 'Medium', 'Hard'];
  setfutureworkoutsList(List<WorkoutListModel>? futureworkoutsList) {
    workoutsList?.addAll(futureworkoutsList!);
    log('woooooooooooooooooooooooooo' + workoutsList.toString());
    isLoading = false;
    print(futureworkoutsList);
    notifyListeners();
  }

  increasePages() {
    page++;
    notifyListeners();
  }

  setIsLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }

  reset() {
    workoutsList = [];
    CategoriesList = [];
    page = 1;
    isLoading = false;
    CategoriesfetchedList = false;
    notifyListeners();
  }

  resetForFilter() {
    workoutsList = [];
    page = 1;
    isLoading = false;
    // CategoriesfetchedList = false;
    notifyListeners();
  }

  getWorkoutsData(String lang, int page, int category, int difficulty,
      String linkType) async {
    isLoading = true;
    setfutureworkoutsList(await WorkoutListsAPI()
        .getworkouts(lang, '/$category', '/$difficulty', page, linkType));
    increasePages();
    notifyListeners();
    // return futureworkoutsList;
  }

  getCategoriesData(String lang) async {
    try {
      CategoriesList = await WorkoutListsAPI().getCategoriesList(lang);
      // print(CategoriesList!.length);
      if (CategoriesList != null) {
        for (var i = 0; i < CategoriesList!.length; i++) {
          // dropDownList?.add(CategoriesList![i].name.toString());
          // dropDownList!.insert('v');
          // print(dropDownList![i]);
          print(CategoriesList![i].id.toString());
          // dropDownList![i] = '$i';
          print('dddddddddddd');
          // print(dropDownList![i]);
        }

        // dropDownNewValue = CategoriesList![0].name.toString();
        PickedCategoryValue = CategoriesList![0].name.toString();
        CategoriesfetchedList = true;
      }
      notifyListeners();
      // return futureworkoutList;
    } catch (e) {
      print('Categories fetch List error $e');
    }
  }

  updatePickedCategory(String pickedCategory) {
    PickedCategoryValue = pickedCategory;
    for (var i = 0; i < CategoriesList!.length; i++) {
      if (CategoriesList![i].name == pickedCategory) {
        CategoryNumber = CategoriesList![i].id!.toInt();
        print(CategoriesList![i].id.toString());
      }

      // dropDownList![i] = '$i';
      // print('dddddddddddd');
      // print(dropDownList![i]);
    }
    notifyListeners();
  }

  updatePickedDifficulty(String PickedDifficulty) {
    PickedDifficultyValue = PickedDifficulty;
    if (PickedDifficultyValue == 'Easy') {
      DifficultyNumber = 1;
    } else if (PickedDifficultyValue == 'Medium') {
      DifficultyNumber = 2;
    } else if (PickedDifficultyValue == 'Hard') {
      DifficultyNumber = 3;
    } else {
      DifficultyNumber = 4;
    }
    notifyListeners();
  }

  Future<WorkoutListModel> deleteSpecificWorkout(String lang, int? id) async {
    return await WorkoutListsAPI().deleteWorkout(lang, id);
    notifyListeners();
  }

  Future<WorkoutListModel?> changeFavoriteState(String lang, int id) async {
    return await WorkoutListsAPI().changeFavoriteState(lang, id);
    notifyListeners();
  }

  List<WorkoutListModel>? get getfutureworkoutsList => workoutsList;
  List<WorkoutListModel>? get getCategoriesList => CategoriesList;
  List<String>? get getdifficultyList => difficultyList;
  bool get getIsREviewLoading => _isReviewLoading;
}
