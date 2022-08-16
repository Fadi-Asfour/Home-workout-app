// ignore_for_file: curly_braces_in_flow_control_structures, use_build_context_synchronously

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:home_workout_app/Api%20services/profile_api.dart';
import 'package:home_workout_app/components.dart';
import 'package:home_workout_app/models/post_models.dart';
import 'package:home_workout_app/models/user_model.dart';

import '../Api services/diet_api.dart';
import '../Api services/post_api.dart';
import '../Api services/workout_list_api.dart';
import '../models/diet_model.dart';
import '../models/workout_list_model.dart';

class AnotherUserProfileViewModel with ChangeNotifier {
  UserModel _anotherUserData = UserModel();
  bool _isWorkoutLoading = false;

  bool _isLoading = false;
  bool _infoWidgetVisible = false;

  List _followers = [];
  List _followings = [];

  bool _isPostLoading = false;

  List<PostModel> _userPosts = [];
  int _page = 0;

  bool _postsIsOpened = false;

  bool _getMoreLoading = false;

  List<WorkoutListModel> _userWorkouts = [];

  int _workoutpage = 0;

  bool _workoutsIsOpened = false;

  void setMoreLoading(value) {
    _getMoreLoading = value;
    notifyListeners();
  }

  void setPostIsOpened(value) {
    _postsIsOpened = value;
    notifyListeners();
  }

  void setIsPostLoading(value) {
    _isPostLoading = value;
    notifyListeners();
  }

  void setPage(int i) {
    _page = i;
    notifyListeners();
  }

  void setWorkoutIsOpened(value) {
    _workoutsIsOpened = value;
    notifyListeners();
  }

  void setWorkoutPage(int i) {
    _workoutpage = i;
    notifyListeners();
  }

  Future<void> setAnotherUserWorkouts(
      {required String lang, required int userId}) async {
    //TODO:
    print('getting');
    setWorkoutPage(getWorkoutpage + 1);
    if (_userPosts.isNotEmpty) setIsMoreWorkoutLoading(true);
    setIsWorkoutLoading(true);
    List<WorkoutListModel> newWorkouts =
        await WorkoutListsAPI().getUserworkouts(lang, userId, getWorkoutpage);
    if (newWorkouts.isEmpty)
      setWorkoutPage(getWorkoutpage - 1);
    else
      _userWorkouts.addAll(newWorkouts);

    setIsWorkoutLoading(false);
    setIsMoreWorkoutLoading(false);
    notifyListeners();
  }

  Future<void> deleteWorkout(
      //TODO:
      {required String lang,
      required int id,
      required BuildContext context}) async {
    final response = await DietAPI().deleteDiet(id: id, lang: lang);

    if (response['success']) {
      showSnackbar(Text(response['message'].toString()), context);
      _userDiets.removeWhere((element) => element.id == id);
      notifyListeners();
    } else {
      showSnackbar(Text(response['message'].toString()), context);
    }
  }

  void clearWorkouts() {
    _userWorkouts.clear();
    notifyListeners();
  }

  Future<void> deleteDiet(
      {required String lang,
      required int id,
      required BuildContext context}) async {
    final response = await DietAPI().deleteDiet(id: id, lang: lang);

    if (response['success']) {
      showSnackbar(Text(response['message'].toString()), context);
      _userDiets.removeWhere((element) => element.id == id);
      notifyListeners();
    } else {
      showSnackbar(Text(response['message'].toString()), context);
    }
  }

  Future<void> setAnotherUserPosts(
      String lang, int userId, BuildContext context) async {
    print('getting');
    setPage(getPage + 1);
    if (_userPosts.isNotEmpty) setMoreLoading(true);
    setIsPostLoading(true);
    List<PostModel> newPosts =
        await PostAPI().getAnotherUserPosts(lang, getPage, userId, context);
    _userPosts.addAll(newPosts);
    if (newPosts.isEmpty) setPage(getPage - 1);
    setIsPostLoading(false);
    setMoreLoading(false);
    notifyListeners();
  }

  void clearPosts() {
    _userPosts.clear();
    notifyListeners();
  }

  setInfoWidgetVisible(bool value) {
    _infoWidgetVisible = value;
    notifyListeners();
  }

  // Map<dynamic, dynamic> user = {
  //   'id': 2,
  //   'data': {
  //     'fname': 'Omar',
  //     'lname': 'Za',
  //     'gender': 'male',
  //     'followed': false,
  //     'country': 'Syria',
  //     'birthdate': '2001-6-21',
  //     'imageUrl':
  //         'https://hips.hearstapps.com/hmg-prod.s3.amazonaws.com/images/full-body-workout-1563458040.jpg',
  //     'role': 'Coach',
  //     'role_id': 2,
  //     'finishedWorkouts': 5,
  //     'enteredWorkouts': 7,
  //     'bio':
  //         'Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test '
  //   }
  // };

  void setIsWorkoutLoading(value) {
    _isWorkoutLoading = value;
    notifyListeners();
  }

  void setIsMoreWorkoutLoading(value) {
    _getMoreWorkoutsLoading = value;
    notifyListeners();
  }

  Future<void> blockUser(int id, String lang, BuildContext context) async {
    final response = await ProfileApi().blockUser(id, lang);
    if (response['success'])
      _anotherUserData.isBlocked = true;
    else {
      showSnackbar(Text(response['message'] ?? ''), context);
    }
    notifyListeners();
  }

  Future<void> unblockUser(int id, String lang, BuildContext context) async {
    bool response = await ProfileApi().unblockUser(id, lang);
    if (response)
      _anotherUserData.isBlocked = false;
    else {
      showSnackbar(Text('Unblock failed').tr(), context);
    }
    notifyListeners();
  }

  Future<void> setFollowers(int id, String lang) async {
    _followers = await ProfileApi().getFollowers(lang, id);
    notifyListeners();
  }

  Future<void> setFollowings(int id, String lang) async {
    _followings = await ProfileApi().getFollowings(lang, id);
    notifyListeners();
  }

  Future<void> setFollow(int id, String lang, BuildContext context) async {
    _isLoading = true;
    final response = await ProfileApi().followUser(id, lang);

    if (response['success']) {
      _anotherUserData.followed = true;
      _anotherUserData.followers = response['followers'];
      _anotherUserData.followings = response['followings'];
      _isLoading = false;
    } else {
      showSnackbar(Text('Follow failed').tr(), context);
    }

    notifyListeners();
  }

  Future<void> setUnfollow(int id, String lang, BuildContext context) async {
    _isLoading = true;
    final response = await ProfileApi().unFollowUser(id, lang);
    if (response['success']) {
      _anotherUserData.followed = false;
      _anotherUserData.followers = response['followers'];
      _anotherUserData.followings = response['followings'];
      _isLoading = false;
    } else {
      showSnackbar(Text('Unfollow failed').tr(), context);
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> setUserData(int id, BuildContext context) async {
    _isLoading = true;
    _anotherUserData =
        await ProfileApi().getAnotherUserProfile('en', id, context);
    _isLoading = false;
    notifyListeners();
  }

  //////////////////////////////////

  bool _isDietLoading = false;
  bool _getMoreDietsLoading = false;
  List<DietModel> _userDiets = [];
  int _dietpage = 0;
  bool _dietsIsOpened = false;

  void setIsdietLoading(value) {
    _isDietLoading = value;
    notifyListeners();
  }

  void setGetMoreDietsLoading(value) {
    _getMoreDietsLoading = value;
    notifyListeners();
  }

  void setDietIsOpened(value) {
    _dietsIsOpened = value;
    notifyListeners();
  }

  void setDietPage(int i) {
    _dietpage = i;
    notifyListeners();
  }

  Future<void> setAnotherUserDiets(String lang, int id) async {
    print('getting');
    setDietPage(getDietPage + 1);
    if (_userDiets.isNotEmpty) setGetMoreDietsLoading(true);
    setIsdietLoading(true);
    List<DietModel> newdiets = await DietAPI()
        .getAnotherUserDiets(lang: lang, page: getDietPage, id: id);
    _userDiets.addAll(newdiets);
    if (newdiets.isEmpty) setDietPage(getDietPage - 1);
    setIsdietLoading(false);
    setGetMoreDietsLoading(false);
    notifyListeners();
  }

  void clearDiets() {
    _userDiets.clear();
    notifyListeners();
  }

  bool get getIsDietLogoutLoading => _isDietLoading;
  bool get getDietIsOpened => _dietsIsOpened;
  int get getDietPage => _dietpage;
  List<DietModel> get getUserDiets => _userDiets;
  bool get getMoreDietLoading => _getMoreDietsLoading;
  ////////////////////////////////

  UserModel get getUserData => _anotherUserData;
  bool get getIsLoading => _isLoading;
  bool get getInfoWidgetVisible => _infoWidgetVisible;
  List get getFollowers => _followers;
  List get getFollowings => _followings;
  bool get getPostIsOpened => _postsIsOpened;
  bool get getIsPostLoading => _isPostLoading;

  int get getPage => _page;
  List<PostModel> get getUserPosts => _userPosts;
  bool get getMoreLoading => _getMoreLoading;
  bool get getIsWorkoutLoading => _isWorkoutLoading;
  bool get getMoreWorkoutsLoading => _getMoreWorkoutsLoading;
  bool get getIsWorkoutLogoutLoading => _isWorkoutLoading;
  bool _getMoreWorkoutsLoading = false;
  int get getWorkoutpage => _workoutpage;

  bool get getWorkoutIsOpened => _workoutsIsOpened;

  List<WorkoutListModel> get getUserWorkouts => _userWorkouts;
}
