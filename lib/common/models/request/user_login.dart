class UserLoginReq {
  String? account;
  String? password;
  int? type;
  String? googleCode;
  String? signature;

  UserLoginReq(
      {this.account,
      this.password,
      this.type,
      this.googleCode,
      this.signature});

  factory UserLoginReq.fromJson(Map<String, dynamic> json) => UserLoginReq(
        account: json['account'] as String?,
        password: json['password'] as String?,
        type: json['type'] as int?,
        googleCode: json['google_code'] as String?,
        signature: json['signature'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'account': account,
        'password': password,
        'type': type,
        'google_code': googleCode,
        'signature': signature,
      };
}
