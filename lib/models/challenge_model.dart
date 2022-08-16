class ChallengeModel {
  int? id;
  String? name;
  String? desc;
  String? img;
  String? end_time;
  int? total_count;
  int? my_count;
  String? created_at;
  String? sub_count;
  String? rate;
  String? user_img;
  String? user_name;
  int? user_id;
  int? role_id;
  String? message;
  bool? is_time;
  bool? is_sub;
  bool? is_active;
  int? statusCode;
  String? subs;
  String? calory;
  int? count;
  int? ex_id;
  ChallengeModel(
      {this.id,
      this.name,
      this.desc,
      this.img,
      this.end_time,
      this.total_count,
      this.my_count,
      this.created_at,
      this.sub_count,
      this.message,
      this.rate,
      this.user_img,
      this.user_name,
      this.user_id,
      this.statusCode,
      this.role_id,
      this.is_time,
      this.is_sub,
      this.is_active,
      this.subs,
      this.calory,
      this.count,
      this.ex_id});
  // to convert data from json to dart object
  factory ChallengeModel.fromJson(Map<String, dynamic> user) => ChallengeModel(
      message: user['message'] ?? '',
      statusCode: user['status'] ?? 0,
      id: user['id'] ?? 0,
      ex_id: user['ex_id'] ?? 0,
      user_id: user['user_id'] ?? 0,
      name: user['name'] ?? '',
      user_name: user['user_name'] ?? '',
      desc: user['desc'] ?? '',
      img: user['img'] ?? '',
      end_time: user['end_time'] ?? '',
      role_id: user['role_id'] ?? 0,
      total_count: user['total_count'] ?? 0,
      my_count: user['my_count'] ?? 0,
      created_at: user['created_at'] ?? '',
      sub_count: user['sub_count'] ?? '',
      user_img: user['user_img'] ?? '',
      is_time: user['is_time'] ?? false,
      is_sub: user['is_sub'] ?? false,
      is_active: user['is_active'] ?? false,
      calory: user['ca'] ?? '');
  factory ChallengeModel.fromJsonForParticipate(Map<String, dynamic> user) =>
      ChallengeModel(
        message: user['message'] ?? '',
        statusCode: user['status'] ?? 0,
        is_sub: user['is_sub'] ?? false,
        subs: user['subs'] ?? '',
      );
  factory ChallengeModel.fromJsonWithErrors(Map<String, dynamic> user) =>
      ChallengeModel(message: user['message'], statusCode: user['status'] ?? 0);
  // to convert data to json
  Map<String, dynamic> toJson() => {
        'count': count.toString(),
      };
}
