// ignore_for_file: curly_braces_in_flow_control_structures, use_build_context_synchronously

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:home_workout_app/Api%20services/diet_api.dart';
import 'package:home_workout_app/Api%20services/health_record_api.dart';
import 'package:home_workout_app/Api%20services/profile_api.dart';
import 'package:home_workout_app/Api%20services/workout_list_api.dart';
import 'package:home_workout_app/components.dart';
import 'package:home_workout_app/models/diet_model.dart';
import 'package:home_workout_app/models/health_record_model.dart';
import 'package:home_workout_app/models/post_models.dart';
import 'package:home_workout_app/models/user_model.dart';
import 'package:home_workout_app/models/workout_list_model.dart';
import 'package:provider/provider.dart';

import '../Api services/post_api.dart';
import '../Api services/sign_up_api.dart';
import '../main.dart';

class ProfileViewModel with ChangeNotifier {
  UserModel _userData = UserModel();
  HealthRecordModel _healthRecord = HealthRecordModel();
  bool _isLoading = false;
  bool _isPostLoading = false;
  bool _isDietLoading = false;
  bool _isWorkoutLoading = false;

  bool _iseditLoading = false;
  bool _islogoutLoading = false;
  List _selectedDis = [];
  String _searchValue = '';
  bool _addDesc = false;
  bool _getMoreLoading = false;
  bool _getMoreDietsLoading = false;

  bool _isRemoveLaoding = false;

  void setIsRemoveLoading(value) {
    _isRemoveLaoding = value;
    notifyListeners();
  }

  bool _getMoreWorkoutsLoading = false;

  bool _infoWidgetVisible = false;
  List _followers = [];
  List _followings = [];
  List _blocklist = [];

  List<PostModel> _userPosts = [];
  List<DietModel> _userDiets = [];
  List<WorkoutListModel> _userWorkouts = [];
  int _page = 0;
  int _dietpage = 0;
  int _workoutpage = 0;

  bool _postsIsOpened = false;
  bool _dietsIsOpened = false;
  bool _workoutsIsOpened = false;

  void setIsWorkoutLoading(value) {
    _isWorkoutLoading = value;
    notifyListeners();
  }

  void setIsMoreWorkoutLoading(value) {
    _getMoreWorkoutsLoading = value;
    notifyListeners();
  }

  void changeIsCV(value) {
    _userData.cv = value ?? false;
  }

  void setGetMoreLoading(value) {
    _getMoreLoading = value;
    notifyListeners();
  }

  void setGetMoreDietsLoading(value) {
    _getMoreDietsLoading = value;
    notifyListeners();
  }

  void setPostIsOpened(value) {
    _postsIsOpened = value;
    notifyListeners();
  }

  void setDietIsOpened(value) {
    _dietsIsOpened = value;
    notifyListeners();
  }

  void setWorkoutIsOpened(value) {
    _workoutsIsOpened = value;
    notifyListeners();
  }

  void setPage(int i) {
    _page = i;
    notifyListeners();
  }

  void setDietPage(int i) {
    _dietpage = i;
    notifyListeners();
  }

  void setWorkoutPage(int i) {
    _workoutpage = i;
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

  Future<void> setUserPosts(String lang) async {
    print('getting');
    setPage(getPage + 1);
    if (_userPosts.isNotEmpty) setGetMoreLoading(true);
    setIsPostLoading(true);
    List<PostModel> newPosts = await PostAPI().getUserPosts(lang, getPage);
    _userPosts.addAll(newPosts);
    if (newPosts.isEmpty) setPage(getPage - 1);
    setIsPostLoading(false);
    setGetMoreLoading(false);
    notifyListeners();
  }

  Future<void> setUserWorkouts(
      {required String lang, required int userId}) async {
    //TODO:
    print('getting');
    setWorkoutPage(getWorkoutpage + 1);
    if (_userPosts.isNotEmpty) setIsMoreWorkoutLoading(true);
    setIsWorkoutLoading(true);
    List<WorkoutListModel> newWorkouts = await WorkoutListsAPI()
        .getworkouts(lang, '', '', getWorkoutpage, '/workout/my_workouts');
    // .getUserworkouts(lang, userId, getWorkoutpage);
    if (newWorkouts.isEmpty)
      setWorkoutPage(getWorkoutpage - 1);
    else
      _userWorkouts.addAll(newWorkouts);

    setIsWorkoutLoading(false);
    setIsMoreWorkoutLoading(false);
    notifyListeners();
  }

  Future<void> setUserDiets(String lang) async {
    print('getting');
    setDietPage(getDietPage + 1);
    if (_userDiets.isNotEmpty) setGetMoreDietsLoading(true);
    setIsdietLoading(true);
    List<DietModel> newdiets =
        await DietAPI().getUserDiets(lang: lang, page: getDietPage);
    _userDiets.addAll(newdiets);
    if (newdiets.isEmpty) setDietPage(getDietPage - 1);
    setIsdietLoading(false);
    setGetMoreDietsLoading(false);
    notifyListeners();
  }

  void clearPosts() {
    _userPosts.clear();
    notifyListeners();
  }

  void clearDiets() {
    _userDiets.clear();
    notifyListeners();
  }

  void clearWorkouts() {
    _userWorkouts.clear();
    notifyListeners();
  }

  void setAddDesc() {
    _addDesc = !_addDesc;
    notifyListeners();
  }

  void setSearchValue(value) {
    _searchValue = value;
    notifyListeners();
  }

  void setIslogoutLoading(value) {
    _islogoutLoading = value;
    notifyListeners();
  }

  void setIsLoading(value) {
    _isLoading = value;
    notifyListeners();
  }

  void setIsPostLoading(value) {
    _isPostLoading = value;
    notifyListeners();
  }

  void setIsdietLoading(value) {
    _isDietLoading = value;
    notifyListeners();
  }

  void seteditIsLoading(value) {
    _iseditLoading = value;
    notifyListeners();
  }

  Future<void> setFollowers(int id, String lang) async {
    _followers = await ProfileApi().getFollowers(lang, id);
    notifyListeners();
  }

  Future<void> deleteHealthRecord(String lang, BuildContext context) async {
    seteditIsLoading(true);

    final response = await HealthRecordApi().deleteHealthRecord(lang);
    if (response['success']) {
      await setHealthRecord(lang);
    } else {
      showSnackbar(Text(response['message']), context);
    }
    seteditIsLoading(false);
  }

  Future<void> setHealthRecord(String lang) async {
    _healthRecord = await HealthRecordApi().getHealthRecord(lang);
    notifyListeners();
  }

  Future<void> setFollowings(int id, String lang) async {
    _followings = await ProfileApi().getFollowings(lang, id);
    print('sssssaaaaa' + _followings.toString());
    notifyListeners();
  }

  setInfoWidgetVisible(bool value) {
    _infoWidgetVisible = value;
    notifyListeners();
  }

  // Map<dynamic, dynamic> user = {
  //   'id': 1,
  //   'data': {
  //     'fname': 'Omar',
  //     'lname': 'Za',
  //     'gender': 'male',
  //     'email': 'test@gmail.com',
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

  Future<void> setCurrentUserData(BuildContext context) async {
    setIsLoading(true);
    _userData = await ProfileApi().getUserProfile('en', context);
    setIsLoading(false);
    notifyListeners();
  }

  Future<void> removeRole(
      {required String lang,
      required BuildContext context,
      required String password}) async {
    setIsRemoveLoading(true);
    final response =
        await ProfileApi().removeRole(lang: lang, password: password);
    if (response['success']) {
      _userData.roleId = 1;
      _userData.role = '';
      notifyListeners();
    } else {
      showSnackbar(Text(response['message'] ?? ''), context);
    }
    setIsRemoveLoading(false);
  }

  Future<void> logout(BuildContext context) async {
    setIslogoutLoading(true);
    final response = await ProfileApi().logout('en');
    setIslogoutLoading(false);

    sharedPreferences.remove("access_token");
    sharedPreferences.remove("refresh_token");
    sharedPreferences.remove("token_expiration");
    sharedPreferences.remove("role_id");
    sharedPreferences.remove("role_name");
    sharedPreferences.remove("googleProvider");
    sharedPreferences.remove("is_verified");
    sharedPreferences.remove("is_info");
    _userData = UserModel();
    Navigator.of(context).pushNamedAndRemoveUntil('/start', (route) => false);
  }

  Future<void> logoutFromAll(BuildContext context) async {
    setIslogoutLoading(true);
    final response = await ProfileApi().logoutFromAll('en');
    setIslogoutLoading(false);

    sharedPreferences.remove("access_token");
    sharedPreferences.remove("refresh_token");
    sharedPreferences.remove("token_expiration");
    sharedPreferences.remove("role_id");
    sharedPreferences.remove("role_name");
    sharedPreferences.remove("googleProvider");
    sharedPreferences.remove("is_verified");
    sharedPreferences.remove("is_info");
    _userData = UserModel();
    Navigator.of(context).pushNamedAndRemoveUntil('/start', (route) => false);

    //Navigator.pop(context);

    setIslogoutLoading(false);
  }

  Future<void> setSelectedDiseases(String lang) async {
    final resp = await SignUpAPI().getDiseases(lang);
    print('called');
    _selectedDis.clear();

    resp.forEach(
      (element) {
        _selectedDis.add(
          {
            'id': element['id'],
            'name': element['name'],
            'selected': false,
          },
        );
      },
    );
    List<int> ids = [];
    _healthRecord.diseases.forEach((element) {
      ids.add(element['dis_id']);
    });
    print(_selectedDis);
    _selectedDis.forEach((element) {
      print(element['id']);
      if (ids.contains(element['id'])) {
        print('yesssss');
        element['selected'] = true;
      }
    });
    notifyListeners();
  }

  void changeDiseasesValue(key, changedValue) {
    _selectedDis.firstWhere((element) => element['id'] == key)['selected'] =
        changedValue;
    notifyListeners();
  }

  Future<void> sendHealthRecord(
      String desc, String lang, BuildContext context) async {
    setIsLoading(true);
    List dis = [];
    List selectedDis =
        _selectedDis.where((element) => element['selected'] == true).toList();
    selectedDis.forEach((element) {
      dis.add(element['id']);
    });
    print('Arrayyyyyyyyyyyyyyyyyyyyyyyyyy $dis');
    final response = await HealthRecordApi().sendHealthRecord(dis, lang, desc);
    if (response['success']) {
      setIsLoading(false);
      await Provider.of<ProfileViewModel>(context, listen: false)
          .setHealthRecord(lang);
      _selectedDis.clear();
      Navigator.pop(context);
    } else {
      setIsLoading(false);

      showSnackbar(Text(response['message'].toString()), context);
    }
  }
  // Future<void> followUser() async {
  //   await ProfileApi().followUser(1, 'en');
  // }

  // Future<void> getFollowers() async {
  //   await ProfileApi().getFollowers('en');
  // }

  // Future<void> getFollowings() async {
  //   await ProfileApi().getFollowings('en');
  // }

  Future<void> deleteAccount(
      String password, String lang, BuildContext context) async {
    final response = await ProfileApi().deleteAccount(password, lang);
    if (response['success']) {
      Navigator.pushReplacementNamed(context, '/startView');
    } else {
      showSnackbar(Text(response['message'].toString()).tr(), context);
      Navigator.pop(context);
    }
  }

  Future<void> setBlocklist(String lang) async {
    _blocklist = await ProfileApi().getBlocklist(lang);
    notifyListeners();
  }

  UserModel get getUserData => _userData;
  HealthRecordModel get getHealthRecord => _healthRecord;
  bool get getInfoWidgetVisible => _infoWidgetVisible;
  bool get getIsLoading => _isLoading;
  bool get getIseditLoading => _iseditLoading;

  List get getFollowers => _followers;
  List get getFollowings => _followings;
  List get getBlocklist => _blocklist;
  List get getSelectedDis => _selectedDis;
  String get getSearchValue => _searchValue;
  bool get getAddDesc => _addDesc;
  bool get getIsLogoutLoading => _islogoutLoading;
  bool get getIsPostLogoutLoading => _isPostLoading;
  bool get getPostIsOpened => _postsIsOpened;
  bool get getIsDietLogoutLoading => _isDietLoading;
  bool get getDietIsOpened => _dietsIsOpened;
  bool get getIsWorkoutLogoutLoading => _isWorkoutLoading;
  bool get getWorkoutIsOpened => _workoutsIsOpened;

  List<WorkoutListModel> get getUserWorkouts => _userWorkouts;

  int get getPage => _page;
  int get getDietPage => _dietpage;
  int get getWorkoutpage => _workoutpage;

  List<PostModel> get getUserPosts => _userPosts;
  List<DietModel> get getUserDiets => _userDiets;

  bool get getMoreLoading => _getMoreLoading;
  bool get getMoreDietLoading => _getMoreDietsLoading;
  bool get getIsRemoveLoading => _isRemoveLaoding;

  bool get getIsWorkoutLoading => _isWorkoutLoading;
  bool get getMoreWorkoutsLoading => _getMoreWorkoutsLoading;

  //bool get getPasswordObsecure => _PasswordObsecure;
}
