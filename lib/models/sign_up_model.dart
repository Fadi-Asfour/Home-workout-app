class SignUpModel {
  int? id;
  String? f_name;
  String? l_name;
  String? email;
  String? password;
  String? password_confirmation;
  String? m_token;
  String? mac;
  String? c_name;
  String? profile_img;
  String? access_token;
  String? refresh_token;
  String? token_expiration;
  int? statusCode;
  int? role_id;
  String? role_name;
  String? message;
  bool? googleProvider;
  bool? is_verified;
  bool? is_info;
  SignUpModel({
    this.id,
    this.f_name,
    this.l_name,
    this.email,
    this.password,
    this.password_confirmation,
    this.m_token,
    this.mac,
    this.c_name,
    this.message,
    this.profile_img,
    this.access_token,
    this.refresh_token,
    this.token_expiration,
    this.statusCode,
    this.role_id,
    this.role_name,
    this.googleProvider,
    this.is_verified,
    this.is_info,
    /*  required this.email,
    required this.password,
    required this.token,
    */
  });
  // to convert data from json to dart object
  factory SignUpModel.fromJson(Map<String, dynamic> user) => SignUpModel(
        message: user['message'] ?? '',
        statusCode: user['status'] ?? 0,
        id: user['data']['user']['id'] ?? 0,
        f_name: user['data']['user']['f_name'] ?? '',
        l_name: user['data']['user']['l_name'] ?? '',
        email: user['data']['user']['email'] ?? '',
        profile_img: user['data']['user']['profile_img'] ?? '',
        access_token: user['data']['access_token'] ?? '',
        refresh_token: user['data']['refresh_token'] ?? '',
        token_expiration: user['data']['expire_at'] ?? '',
        role_id: user['data']['user']['role_id'] ?? 0,
        role_name: user['data']['user']['role_name'] ?? '',
        googleProvider: user['data']['provider'] ?? false,
        is_verified: user['data']['is_verified'] ?? false,
        is_info: user['data']['is_info'] ?? false,
      );
  factory SignUpModel.fromJsonWithErrors(Map<String, dynamic> user) =>
      SignUpModel(
          message: user['message'] ?? '', statusCode: user['status'] ?? 0);
  //to convert data to json
  Map<String, dynamic> toJson() => {
        'f_name': f_name,
        'l_name': l_name,
        'email': email,
        'password': password,
        'password_confirmation': password_confirmation,
        'm_token': m_token,
        // 'mac': mac,
        'c_name': c_name
      };
}
