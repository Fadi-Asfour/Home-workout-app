import 'package:image_picker/image_picker.dart';

class CreateChallengeModel {
  int? id;
  String? name;
  String? message;
  XFile? img;
  String? end_time;
  String? time;
  String? count;
  String? ex_id;
  String? desc;
  String? ca;

  int? statusCode;
  CreateChallengeModel(
      {this.id,
      this.name,
      this.message,
      this.statusCode,
      this.img,
      this.end_time,
      this.time,
      this.count,
      this.ex_id,
      this.desc,
      this.ca});
  // to convert data from json to dart object
  factory CreateChallengeModel.fromJson(Map<String, dynamic> user) =>
      CreateChallengeModel(
        message: user['message'] ?? '',
        statusCode: user['status'] ?? 0,
        // id: user['id'] ?? 0,
        // name: user['name'] ?? '',
        // desc: user['desc'] ?? '',
        // img: user['img'] ?? '',
        // end_time: user['end_time'] ?? '',
        // role_id: user['role_id'] ?? 0,
        // total_count: user['total_count'] ?? '',
        // my_count: user['my_count'] ?? '',
        // created_at: user['created_at'] ?? '',
        // sub_count: user['sub_count'] ?? '',
        // user_img: user['user_img'] ?? '',
        // is_time: user['is_time'] ?? false,
        // is_sub: user['is_sub'] ?? false,
        // is_active: user['is_active'] ?? false,
      );
  factory CreateChallengeModel.fromChallengesJson(Map<String, dynamic> user) =>
      CreateChallengeModel(
        // message: user['message'] ?? '',
        // statusCode: user['status'] ?? 0,
        id: user['id'] ?? 0,
        name: user['name'] ?? '',
        // img: user['img'] ?? '',
        //  ca: user['ca'] ?? '',
      );
  factory CreateChallengeModel.fromJsonWithErrors(Map<String, dynamic> user) =>
      CreateChallengeModel(
          message: user['message'], statusCode: user['status'] ?? 0);

  // to convert data to json
  Map<String, dynamic> toJson() => {
        'name': name,
        'end_time': end_time,
        'time': time,
        'count': count,
        'ex_id': ex_id,
        'img': img,
        'desc': desc
      };
}
