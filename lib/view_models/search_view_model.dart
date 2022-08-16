// ignore_for_file: curly_braces_in_flow_control_structures, use_build_context_synchronously

import 'package:flutter/cupertino.dart';
import 'package:home_workout_app/Api%20services/search_api.dart';
import 'package:home_workout_app/components.dart';
import 'package:home_workout_app/constants.dart';
import 'package:home_workout_app/models/challenge_model.dart';
import 'package:home_workout_app/models/diet_model.dart';
import 'package:home_workout_app/models/post_models.dart';
import 'package:home_workout_app/models/user_model.dart';
import 'package:home_workout_app/models/workout_list_model.dart';
import 'package:home_workout_app/models/workout_model.dart';

import '../Api services/diet_api.dart';

class SearchViewModel with ChangeNotifier {
  List<UserModel> _users = [];
  List<PostModel> _posts = [];
  List<DietModel> _diets = [];
  List<WorkoutListModel> _workouts = [];
  List<ChallengeModel> _challenges = [];
  int _page = 0;
  Filters _filter = Filters.users;
  bool _isSugLoading = false;

  List<String> _suggestions = [];

  Map<String, bool> categories = {
    'Users': true,
    'Posts': false,
    'Workouts': false,
    'Diets': false,
    'Challenges': false,
  };

  void setIsSugLoading(value) {
    _isSugLoading = value;
    notifyListeners();
  }

  changeSelectedCategorie(key, selectedValue) {
    categories.updateAll((key, value) => false);
    categories.update(key, (value) => selectedValue);
    notifyListeners();
  }

  String getFilter() {
    return categories.entries
        .firstWhere((element) => element.value == true)
        .key;
  }

  void setPage(i) {
    _page = i;
    notifyListeners();
  }

  void reset() {
    _suggestions.clear();
    _users.clear();
    _posts.clear();
    _diets.clear();
    _challenges.clear();
    _workouts.clear();
    _isSugLoading = false;
    _page = 0;
    _isLoading = false;
    notifyListeners();
  }

  bool _isLoading = false;

  void setIsLoading(value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<void> getSuggestion(
      {required String lang,
      required String text,
      required BuildContext context}) async {
    print('Called');
    setIsSugLoading(true);
    _suggestions.clear();
    _suggestions = await SearchApi().getSuggestion(
        lang: lang, text: text, filter: getFilter(), context: context);
    print(_suggestions);
    setIsSugLoading(false);

    notifyListeners();
  }

  Future<void> getSearchData(
      {required String lang,
      required String text,
      required BuildContext context}) async {
    setPage(getPage + 1);
    setIsLoading(true);

    final response = await SearchApi().getSearchData(
        lang: lang,
        text: text,
        filter: getFilter(),
        page: getPage,
        context: context);
    if (response.isEmpty)
      setPage(getPage - 1);
    else if (response.isNotEmpty) {
      switch (getFilter()) {
        case 'Users':
          _users.addAll(response as List<UserModel>);
          break;
        case 'Posts':
          _posts.addAll(response as List<PostModel>);
          break;
        case 'Diets':
          _diets.addAll(response as List<DietModel>);
          break;
        case 'Workouts':
          _workouts.addAll(response as List<WorkoutListModel>);
          break;
        case 'Challenges':
          _challenges.addAll(response as List<ChallengeModel>);
          break;
        default:
      }
    }

    if (_users.isNotEmpty ||
        _posts.isNotEmpty ||
        _diets.isNotEmpty ||
        _workouts.isNotEmpty ||
        _challenges.isNotEmpty) _suggestions.clear();

    notifyListeners();

    setIsLoading(false);
  }

  Future<void> deleteDiet(
      {required String lang,
      required int id,
      required BuildContext context}) async {
    final response = await DietAPI().deleteDiet(id: id, lang: lang);

    if (response['success']) {
      showSnackbar(Text(response['message'].toString()), context);
      _diets.removeWhere((element) => element.id == id);
      notifyListeners();
    } else {
      showSnackbar(Text(response['message'].toString()), context);
    }
  }

  bool get getIsLoading => _isLoading;
  List<UserModel> get getUsers => _users;
  List<PostModel> get getposts => _posts;
  List<DietModel> get getDiets => _diets;
  List<ChallengeModel> get getChallenges => _challenges;
  List<WorkoutListModel> get getWorkouts => _workouts;
  int get getPage => _page;
  List<String> get getSugs => _suggestions;
  bool get getIsSugLoading => _isSugLoading;
  //Filters get getFilter => _filter;
}
