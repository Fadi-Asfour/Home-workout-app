import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:home_workout_app/Api%20services/create_workout_api.dart';
import 'package:home_workout_app/Api%20services/workout2_api.dart';
import 'package:home_workout_app/constants.dart';
import 'package:home_workout_app/models/create_workout_model.dart';
import 'package:home_workout_app/models/exercises_model.dart';
import 'package:home_workout_app/models/workout2_model.dart';
import 'package:image_picker/image_picker.dart';

class EditworkoutViewModel with ChangeNotifier {
  Future<List<CreateworkoutModel>>? futureworkoutList;
  Future<List<CreateworkoutModel>>? futureExercisesList;
  XFile userImage = XFile('');
  List<String>? dropDownList = [];
  String dropDownNewValue = '';
  List<String>? equipmentDropDownList = [
    'Recommended',
    'Required',
    'Not Required'
  ];
  List<String>? difficultyDropDownList = ['Easy', 'Medium', 'Hard'];
  String? equipmentDropDownNewValue = 'Recommended';
  String? difficultyDropDownNewValue = 'Easy';

  bool switchValue = false;
  bool _isLoading = false;
  Workout2Model _workout = Workout2Model();

  void setIsLoading(value) {
    _isLoading = value;
    notifyListeners();
  }

  List<CreateworkoutModel>? ConvertedFutureCategoriesList;
  List<CreateworkoutModel>? ConvertedFutureExercisesList;
  bool fetchedList = false;
  // bool fetchedExercisesList = false;

  List _pickedExercisesIDs = [];

  List<Map<int, int>> pickedExercisesIDsAndCount = [];
  // var f<String,dynamic> = {};
  // List<f, f> l;

  reset() {
    fetchedList = false;
    dropDownNewValue = '';
    dropDownList = [];
    ConvertedFutureCategoriesList?.clear();
    ConvertedFutureExercisesList?.clear();
    _pickedExercisesIDs = [];
    pickedExercisesIDsAndCount = [];
    _workout = Workout2Model();
    userImage = XFile('');

    notifyListeners();

    // fetchedExercisesList = false;
  }

  void addToExercises(int i) {
//     [{
//       'id':1,'isTime':true,'value':50,
//     }
// ]

    bool exist = false;
    _pickedExercisesIDs.forEach((element) {
      if (element['id'] == i) exist = true;
    });

    if (!exist) {
      _pickedExercisesIDs.add({'id': i, 'isTime': false, 'value': 10});
    }
    // if (!_pickedExercisesIDs.contains(i)) {
    //   _pickedExercisesIDs.add(i);
    // pickedExercisesIDsAndCount.add();
    // }
    notifyListeners();
  }

  bool containIdInExercises(int id) {
    for (int i = 0; i < _pickedExercisesIDs.length; i++) {
      if (_pickedExercisesIDs[i]['id'] == id) {
        return true;
      }
    }
    return false;
  }

  void removeFromExercises(int id) {
    // if (_pickedExercisesIDs.contains(i)) {
    //   _pickedExercisesIDs.removeWhere((element) => element == i);
    // }
    for (int i = 0; i < _pickedExercisesIDs.length; i++) {
      if (_pickedExercisesIDs[i]['id'] == id) {
        _pickedExercisesIDs.removeAt(i);
      }
    }
    notifyListeners();
  }

  getData(String lang) async {
    try {
      futureworkoutList = CreateWorkoutAPI().getCategoriesList(lang);
      ConvertedFutureCategoriesList = await futureworkoutList;
      // print(ConvertedFutureCategoriesList!.length);
      if (ConvertedFutureCategoriesList != null) {
        for (var i = 0; i < ConvertedFutureCategoriesList!.length; i++) {
          dropDownList?.add(ConvertedFutureCategoriesList![i].name.toString());
          // dropDownList!.insert('v');
          // print(dropDownList![i]);
          print(ConvertedFutureCategoriesList![i].id.toString());
          // dropDownList![i] = '$i';
          print('dddddddddddd');
          print(dropDownList![i]);
        }
        dropDownNewValue = ConvertedFutureCategoriesList![0]
            .name
            .toString(); //TODO: //remeber to uncommnet it if you recieved any error
      }
      fetchedList = true;
      notifyListeners();
      return futureworkoutList;
    } catch (e) {
      print('drop down in create workout error $e');
    }
  }

  // getExercisesData(String lang) async {
  //   try {
  //     ConvertedFutureExercisesList =
  //         await CreateWorkoutAPI().getExercisesList(lang);
  //     // futureExercisesList;
  //     // print(ConvertedFutureCategoriesList!.length);
  //     // if (ConvertedFutureCategoriesList != null) {
  //     for (var i = 0; i < ConvertedFutureExercisesList!.length; i++) {
  //       print(ConvertedFutureExercisesList![i].id.toString());
  //       // dropDownList?.add(ConvertedFutureCategoriesList![i].name.toString());
  //       // // dropDownList!.insert('v');
  //       // // print(dropDownList![i]);
  //       // print(ConvertedFutureCategoriesList![i].id.toString());
  //       // // dropDownList![i] = '$i';
  //       // print('dddddddddddd');
  //       // print(dropDownList![i]);
  //     }
  //     //   dropDownNewValue = ConvertedFutureCategoriesList![0].name.toString();
  //     // }
  //     // fetchedExercisesList = true;
  //     setfetchedExercisesList();
  //     notifyListeners();
  //     // return futureExercisesList;
  //   } catch (e) {
  //     print('get exercises in create workout error $e');
  //   }
  // }

  postWorkoutInfo(
      String nameVal,
      String descriptionVal,
      String categoryVal,
      String equipmentVal,
      String difficultyVal,
      List exercisesVal,
      XFile imgVal,
      String URlVal,
      String lang) async {
    CreateworkoutModel? result;
    return await CreateWorkoutAPI.CreateWorkout(
        CreateworkoutModel(
          name: nameVal,
          desc: descriptionVal,
          categorie_id: categoryVal,
          equipment: equipmentVal,
          difficulty: difficultyVal,
          excersisesList: exercisesVal,
          workout_image: imgVal,
          // id:id
        ),
        URlVal,
        lang);
  }

  editWorkoutInfo(
      String nameVal,
      String descriptionVal,
      String categoryVal,
      String equipmentVal,
      String difficultyVal,
      List exercisesVal,
      String URlVal,
      String lang) async {
    CreateworkoutModel? result;
    return await CreateWorkoutAPI.EditWorkoutWithoutImage(
        CreateworkoutModel(
          name: nameVal,
          desc: descriptionVal,
          categorie_id: categoryVal,
          equipment: equipmentVal,
          difficulty: difficultyVal,
          excersisesList: exercisesVal,
        ),
        URlVal,
        lang);
  }

  addToListOfExercises() {
    List<ExercisesModel> ExercisesList = _workout.exercises;

    for (int i = 0; i < ExercisesList.length; i++) {
      if (ExercisesList[i].count != 0)
        _pickedExercisesIDs.add({
          'id': ExercisesList[i].id,
          'isTime': false,
          'value': ExercisesList[i].count
        });
      else {
        _pickedExercisesIDs.add({
          'id': ExercisesList[i].id,
          'isTime': true,
          'value': ExercisesList[i].length
        });
      }
      print(_pickedExercisesIDs[i]);
    }
    notifyListeners();
  }

  Future<void> setWorkout({required String lang, required int id}) async {
    print('iiiiiiiiiiiiiiiiiiiiiiiiiiiii');
    setIsLoading(true);
    _workout = await Workout2Api().getSepcWorkout(lang: lang, id: id);
    // if (fetchedList == true) {
    addToListOfExercises();
    print(_workout.categorieId);
    for (int i = 0; i < dropDownList!.length; i++) {
      print('categgoooooooorrrrrrrrrrrry');
      print(_workout.categorieId);
      print(ConvertedFutureCategoriesList![i].id);
      print(ConvertedFutureCategoriesList![i].name);
      log(ConvertedFutureCategoriesList![i].name.toString());
      log(ConvertedFutureCategoriesList![i].name.toString());
      if (_workout.categorieId ==
          ConvertedFutureCategoriesList![i].id!.toInt()) {
        setdropDownNewValue(ConvertedFutureCategoriesList![i].name.toString());
        print('xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx');
        print(_workout.categorieId);
        print(ConvertedFutureCategoriesList![i].id);
        print(ConvertedFutureCategoriesList![i].name);
        log(ConvertedFutureCategoriesList![i].name.toString());
      }
    }
    setequipmentDropDownNewValue(_workout.equipment);

    if (_workout.difficulty == 1) {
      setdifficultyDropDownNewValue('Easy');
    } else if (_workout.difficulty == 2) {
      setdifficultyDropDownNewValue('Medium');
    } else {
      setdifficultyDropDownNewValue('Hard');
    }
    // }
    // _workout.exercises
    setIsLoading(false);
    notifyListeners();
  }

  setdropDownNewValue(String dropDownNewVal) {
    dropDownNewValue = dropDownNewVal;
    print(dropDownNewValue);
    notifyListeners();
  }

  // setfetchedExercisesList() {
  //   fetchedExercisesList = true;
  //   notifyListeners();
  // }

  setequipmentDropDownNewValue(String dropDownNewVal) {
    equipmentDropDownNewValue = dropDownNewVal;
    notifyListeners();
  }

  setdifficultyDropDownNewValue(String dropDownNewVal) {
    difficultyDropDownNewValue = dropDownNewVal;
    notifyListeners();
  }

  getIdOfDropDownValue() {
    for (int i = 0; i < ConvertedFutureCategoriesList!.length; i++) {
      if (dropDownNewValue == ConvertedFutureCategoriesList![i].name) {
        return ConvertedFutureCategoriesList![i].id;
      }
    }
  }

  getIdOfDifficultyDropDownValue() {
    if (difficultyDropDownNewValue == 'Easy') {
      return 1;
    } else if (difficultyDropDownNewValue == 'Medium') {
      return 2;
    } else {
      return 3;
    }
  }

  String? checkName(String name, String lang) {
    if (name.isEmpty) {
      return lang == 'en' ? ' Enter name' : ' أدخل الاسم ';
    } else {
      return null;
    }
  }

  String? checkDescription(String name, String lang) {
    if (name.isEmpty) {
      return lang == 'en' ? ' Enter description' : ' أدخل الوصف ';
    } else
      return null;
  }

  void changestateOfTime(int id) {
    for (int i = 0; i < _pickedExercisesIDs.length; i++) {
      if (_pickedExercisesIDs[i]['id'] == id) {
        _pickedExercisesIDs[i]['isTime'] = !_pickedExercisesIDs[i]['isTime'];
      }
    }
    notifyListeners();
  }

  void decreaseCount(int id) {
    for (int i = 0; i < _pickedExercisesIDs.length; i++) {
      if (_pickedExercisesIDs[i]['id'] == id &&
          _pickedExercisesIDs[i]['value'] > 1) {
        _pickedExercisesIDs[i]['value']--;
      }
    }
    notifyListeners();
  }

  void increaseCount(int id) {
    for (int i = 0; i < _pickedExercisesIDs.length; i++) {
      if (_pickedExercisesIDs[i]['id'] == id) {
        _pickedExercisesIDs[i]['value']++;
      }
    }
    notifyListeners();
  }

  getCountVal(int id) {
    for (int i = 0; i < _pickedExercisesIDs.length; i++) {
      if (_pickedExercisesIDs[i]['id'] == id) {
        return _pickedExercisesIDs[i]['value'];
      }
    }
    notifyListeners();
  }

  getSwitchVal(int id) {
    for (int i = 0; i < _pickedExercisesIDs.length; i++) {
      if (_pickedExercisesIDs[i]['id'] == id) {
        return _pickedExercisesIDs[i]['isTime'];
      }
    }
    notifyListeners();
  }

  changeSwitchState(bool Val, int id) {
    for (int i = 0; i < _pickedExercisesIDs.length; i++) {
      if (_pickedExercisesIDs[i]['id'] == id) {
        _pickedExercisesIDs[i]['isTime'] = Val;
      }
    }
    notifyListeners();
  }

  Future<void> changePhoto(ImageSource src) async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: src);
    if (pickedImage != null) {
      userImage = pickedImage;
      print('vvvvvvvvvvvvvvvvvvvvvvccccccccccc');
      print(userImage.path);
    }
    notifyListeners();
  }

  // bool get getIsFetched => fetchedExercisesList;
  // List<CreateworkoutModel>? get exercisesList => ConvertedFutureExercisesList;

  List get getPickedExercises => _pickedExercisesIDs;
  bool get getIsLoading => _isLoading;
  bool get getswitchValue => switchValue;
  Workout2Model get getWorkout => _workout;
}
