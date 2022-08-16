import 'package:flutter/material.dart';
import 'package:home_workout_app/Api%20services/create_challenge_api.dart';
import 'package:home_workout_app/constants.dart';
import 'package:home_workout_app/models/create_challenge_model.dart';
import 'package:image_picker/image_picker.dart';

class CreateChallengesViewModel with ChangeNotifier {
  XFile userImage = XFile('');
  Future<List<CreateChallengeModel>>? futurechallengesList;
  List<String>? dropDownList = [];
  String dropDownNewValue = '';
  List<CreateChallengeModel>? ConvertedFuturechallengesList;
  bool fetchedList = false;
  bool isTime = false;
  DateTime challengeDate = DateTime.now();
  bool dateIsSelected = false;
  int? hours;
  int? minuites;
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

  changeIsTime() {
    isTime = !isTime;
    notifyListeners();
  }

  String? checkName(String name, String lang) {
    if (name.isEmpty) {
      return lang == 'en' ? ' Enter name' : ' أدخل الاسم ';
    } else
      return null;
  }

  String? checkDescription(String name, String lang) {
    if (name.isEmpty) {
      return lang == 'en' ? ' Enter description' : ' أدخل الوصف ';
    } else
      return null;
  }

  String? checkRepetition(String name, String lang) {
    if (name.isEmpty) {
      return lang == 'en' ? ' Enter repetition' : ' أدخل التكرار ';
    } else
      return null;
  }

  String? checkHours(String name, String lang) {
    if (name.isEmpty) {
      return lang == 'en' ? ' Enter hours' : ' أدخل الساعات ';
    } else
      return null;
  }

  String? checkMinuites(String name, String lang) {
    if (name.isEmpty) {
      return lang == 'en' ? ' Enter minuites' : ' أدخل الدقائق ';
    } else
      return null;
  }

  getSumOfTime(String h, String m) {
    hours = int.parse(h);
    minuites = int.parse(m);
    return (hours! * 60 * 60) + (minuites! * 60);
  }

  resetData() {
    userImage = XFile('');
    dropDownList = [];
    dropDownNewValue = '';
    fetchedList = false;
    isTime = false;
    challengeDate = DateTime.now();
    hours = 0;
    minuites = 0;
    ConvertedFuturechallengesList?.clear();
    notifyListeners();
  }

  changechallengeDate(BuildContext context) async {
    final selectedchallengeDate = await showDatePicker(
      builder: (context, child) => Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: orangeColor,
              onPrimary: Colors.white,
              onSurface: orangeColor,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                primary: orangeColor,
              ),
            ),
          ),
          child: child!),
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2150),
    );
    if (selectedchallengeDate != null) {
      challengeDate = selectedchallengeDate;
      dateIsSelected = true;
      notifyListeners();
    }
  }

  postChallengeInfo(
      String nameVal,
      String end_timeVal,
      String countVal,
      String ex_idVal,
      String timeVal,
      XFile imgVal,
      String descVal,
      String lang) async {
    CreateChallengeModel? result;
    try {
      await CreateChallengeAPI.createChallenge(
              CreateChallengeModel(
                  name: nameVal,
                  end_time: end_timeVal,
                  time: timeVal,
                  count: countVal,
                  ex_id: ex_idVal,
                  img: imgVal,
                  desc: descVal),
              lang)
          .then((value) {
        print(value);
        result = value;
      });
    } catch (e) {
      print("create challenge in GeneralChallengesViewModel error: $e");
    }

    return result;
  }

  getChallengesList(String lang) {
    return CreateChallengeAPI().getChallengesList(lang);
  }

  setdropDownNewValue(String dropDownNewVal) {
    dropDownNewValue = dropDownNewVal;
    notifyListeners();
  }

  getIdOfDropDownValue() {
    for (int i = 0; i < ConvertedFuturechallengesList!.length; i++) {
      if (dropDownNewValue == ConvertedFuturechallengesList![i].name) {
        return ConvertedFuturechallengesList![i].id;
      }
    }
  }

  getData(String lang, int page) async {
    try {
      futurechallengesList = CreateChallengeAPI().getChallengesList(lang);
      ConvertedFuturechallengesList = await futurechallengesList;
      // print(ConvertedFuturechallengesList!.length);
      if (ConvertedFuturechallengesList != null) {
        for (var i = 0; i < ConvertedFuturechallengesList!.length; i++) {
          dropDownList?.add(ConvertedFuturechallengesList![i].name.toString());
          // dropDownList!.insert('v');
          print(dropDownList![i]);
          print(ConvertedFuturechallengesList![i].name.toString());
          // dropDownList![i] = '$i';
          print('dddddddddddd');
          print(dropDownList![i]);
        }
        dropDownNewValue = ConvertedFuturechallengesList![0].name.toString();
        for (var i = 0; i < ConvertedFuturechallengesList!.length; i++) {
          print(ConvertedFuturechallengesList![i].id);
        }
      }

      // for (int i = 0; i < dropDownList.length; i++) {
      //   // dropDownList?.add(ConvertedFuturechallengesList![i].name.toString());
      //   print(dropDownList![i]);
      // }
      // ConvertedFuturechallengesList.forEach((element) async {
      //   dropDownList?.add(ConvertedFuturechallengesList!(element).toString());
      //   // dropDownList.add(l(element));
      // });
      fetchedList = true;
      notifyListeners();
      return futurechallengesList;
    } catch (e) {
      print('drop down in create challnege error $e');
    }
  }
}
