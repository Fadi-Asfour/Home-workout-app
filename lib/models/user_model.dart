import 'package:home_workout_app/constants.dart';
import 'package:home_workout_app/main.dart';
import 'package:intl/intl.dart';

class UserModel {
  int id = -1;
  String fname = '';
  String lname = '';
  String imageUrl = '';
  String role = '';
  int roleId = 0;
  int enteredWorkouts = 0;
  int finishedWorkouts = 0;
  String bio = '';
  Gender gender = Gender.male;
  DateTime birthdate = DateTime.now();
  String countryName = '';
  String email = '';
  bool followed = false;
  String createdAt = '';
  bool isBlocked = false;
  int followers = 0;
  int followings = 0;
  bool i_block = false;
  bool cv = false;
  String height = '0';
  String weight = '0';
  Units heightUnit = Units.cm;
  Units weightUnit = Units.kg;

  UserModel(
      // this.fname,
      // this.lname,
      // this.imageUrl,
      // this.role,
      // this.bio,
      // this.gender,
      // this.enteredWorkouts,
      // this.finishedWorkouts,
      // this.id,
      // this.birthdate,
      // this.countryName,
      // this.email,
      // this.roleId,
      // this.followed,
      );

  UserModel.fromJson(Map<dynamic, dynamic> json) {
    print(json);
    fname = json['data']['user']['fname'] ?? '';
    lname = json['data']['user']['lname'] ?? '';
    imageUrl = json['data']['user']['profile_img'] ?? '';

    if (imageUrl.substring(0, 4) != 'http') {
      imageUrl = '$ip/$imageUrl';
    }

    role = json['data']['user']['role_name'] ?? '';

    id = json['data']['user']['id'] ?? -1;
    // enteredWorkouts = json['data']['user']['enteredWorkouts'] ?? 0;
    // finishedWorkouts = json['data']['user']['finishedWorkouts'] ?? 0;
    bio = json['data']['user']['bio'] ?? '';
    gender =
        json['data']['user']['gender'] == 'male' ? Gender.male : Gender.female;

    try {
      birthdate = DateFormat('yyyy-MM-dd')
          .parse(json['data']['user']['birth_date'] ?? '');
    } catch (e) {
      print('sssssssss');
      // birthdate =
      //     DateFormat('y-m-d').parse(json['data']['user']['birth_date'] ?? '');
    }

    countryName = json['data']['user']['country'] ?? '';
    email = json['data']['user']['email'] ?? '';
    roleId = json['data']['user']['role_id'] ?? 0;

    sharedPreferences.setInt('role_id', roleId);

    followed = json['data']['is_following'] ?? false;
    isBlocked = json['data']['is_blocked'] ?? false;
    followers = json['data']['followers'] ?? 0;
    followings = json['data']['following'] ?? 0;
    i_block = json['data']['I_block'] ?? false;
    print(json['data']['user']['cv']);
    cv = json['data']['user']['cv'] ?? false;
    height = json['data']['user']['height'] ?? '0';
    weight = json['data']['user']['weight'] ?? '0';
    heightUnit =
        json['data']['user']['height_unit'] == 'ft' ? Units.ft : Units.cm;
    weightUnit =
        json['data']['user']['weight_unit'] == 'lb' ? Units.lb : Units.kg;
  }

  UserModel.fromJsonForSearch(Map<dynamic, dynamic> json) {
    print(json);
    fname = json['fname'];
    lname = json['lname'];
    id = json['id'];
    role = json['role'];
    imageUrl = json['img'] ?? '';

    if (imageUrl.substring(0, 4) != 'http') {
      imageUrl = '$ip/$imageUrl';
    }
  }
}
