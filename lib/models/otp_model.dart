class OTPModel {
  // int? id;
  // String? f_name;
  // String? l_name;

  // String? password;
  // String? password_confirmation;
  // String? m_token;
  // String? mac;

  // String? profile_img;
  // String? access_token;
  // String? refresh_token;
  // String? expire_at;
  String? email;
  String? c_name;
  String? verification_code;

  int? statusCode;
  String? message;
  String? forgetPasswordCode;
  OTPModel(
      {this.verification_code,
      this.c_name,
      this.message,
      this.statusCode,
      this.forgetPasswordCode,
      this.email});
  // to convert data from json to dart object
  factory OTPModel.fromJson(Map<String, dynamic> user) => OTPModel(
        // id: user['data']['user']['id'] ?? 0,
        // f_name: user['data']['user']['f_name'] ?? '',
        // l_name: user['data']['user']['l_name'] ?? '',
        // email: user['data']['user']['email'] ?? '',
        // profile_img: user['data']['user']['profile_img'] ?? '',
        // access_token: user['data']['access_token'] ?? '',
        // refresh_token: user['data']['refresh_token'] ?? '',

        message: user['message'] ?? '',
        statusCode: user['status'] ?? 0,
        forgetPasswordCode: user['data']['code'] ?? '',
      );
  factory OTPModel.fromJsonWithErrors(Map<String, dynamic> user) =>
      OTPModel(message: user['message'], statusCode: user['status'] ?? 0);
  //to convert data to json
  Map<String, dynamic> toJson() => {
        'code': verification_code,
        'c_name': c_name,
      };
  Map<String, dynamic> emailToJson() => {
        'email': email,
        'c_name': c_name,
      };
}
