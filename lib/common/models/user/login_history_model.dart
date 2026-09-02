import 'package:XSmartPay/common/index.dart';

class LoginHistoryModel {
  String? account;
  String? password;
  String? avatar;

  LoginHistoryModel({
    this.account,
    this.password,
    this.avatar,
  });

  factory LoginHistoryModel.fromJson(Map<String, dynamic> json) {
    return LoginHistoryModel(
      account: DataUtils.toStr(json['account']),
      password: DataUtils.toStr(json['password']),
      avatar: DataUtils.toStr(json['avatar']),
    );
  }

  Map<String, dynamic> toJson() => {
        'account': account,
        'password': password,
        'avatar': avatar,
      };
}
