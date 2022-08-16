class ForgetPasswordModel {
  // int? id;
  // String? f_name;
  // String? l_name;
  String? email;
  String? password;
  String? password_confirmation;
  // String? m_token;
  // String? mac;

  // String? profile_img;
  // String? access_token;
  // String? refresh_token;
  // String? expire_at;

  String? c_name;
  String? verification_code;

  int? statusCode;
  String? message;
  ForgetPasswordModel({
    this.verification_code,
    this.c_name,
    this.message,
    this.statusCode,
    this.email,
    this.password,
    this.password_confirmation,
  });
  // to convert data from json to dart object
  factory ForgetPasswordModel.fromJson(Map<String, dynamic> user) =>
      ForgetPasswordModel(
        message: user['message'] ?? '',
        statusCode: user['status'] ?? 0,
      );
  factory ForgetPasswordModel.fromJsonWithErrors(Map<String, dynamic> user) =>
      ForgetPasswordModel(
          message: user['message'], statusCode: user['status'] ?? 0);
  //to convert data to json
  // Map<String, dynamic> toJson() => {
  //       'code': verification_code,
  //       'c_name': c_name,
  //     };
  Map<String, dynamic> emailToJson() => {
        'email': email,
        'c_name': c_name,
      };
}
