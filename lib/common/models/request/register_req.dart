class UserRegisterReq {
  String? email;
  String? password;
  String? verificationCode;
  String? invitationCode;

  UserRegisterReq({
    this.email,
    this.password,
    this.verificationCode,
    this.invitationCode,
  });

  factory UserRegisterReq.fromJson(Map<String, dynamic> json) =>
      UserRegisterReq(
        email: json['email'] as String?,
        password: json['password'] as String?,
        verificationCode: json['verification_code'] as String?,
        invitationCode: json['invitation_code'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'email': email,
        'password': password,
        'verification_code': verificationCode,
        'invitation_code': invitationCode,
      };
}
