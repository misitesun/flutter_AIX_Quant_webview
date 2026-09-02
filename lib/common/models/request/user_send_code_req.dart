import 'package:XSmartPay/common/index.dart';

class UserSendCodeReq {
  String? email;
  String? type;

  UserSendCodeReq({this.email, this.type});

  factory UserSendCodeReq.fromJson(Map<String, dynamic> json) =>
      UserSendCodeReq(
        email: DataUtils.toStr(json['email']),
        type: DataUtils.toStr(json['type']),
      );

  Map<String, dynamic> toJson() => {
        'email': email,
        'type': type,
      };
}
