import 'package:XSmartPay/common/index.dart';

class UserForgotPasswordReq {
  String? email;
  String? verificationCode;
  String? password;

  UserForgotPasswordReq({this.email, this.verificationCode, this.password});

  factory UserForgotPasswordReq.fromJson(Map<String, dynamic> json) {
    return UserForgotPasswordReq(
      email: DataUtils.toStr(json['email']),
      verificationCode: DataUtils.toStr(json['verification_code']),
      password: DataUtils.toStr(json['password']),
    );
  }

  Map<String, dynamic> toJson() => {
        'email': email,
        'verification_code': verificationCode,
        'password': password,
      };
}
