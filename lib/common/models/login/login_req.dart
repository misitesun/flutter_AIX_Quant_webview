class LoginReq {
  String? mobile;
  String? password;

  LoginReq({this.mobile, this.password});

  factory LoginReq.fromJson(Map<String, dynamic> json) => LoginReq(
        mobile: json['mobile'] as String?,
        password: json['password'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'mobile': mobile,
        'password': password,
      };
}
