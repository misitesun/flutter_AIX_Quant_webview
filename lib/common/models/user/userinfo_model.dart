class UserinfoModel {
  int? id;
  dynamic gender;
  String? nickname;
  String? avatar;
  bool? isFriend;
  String? email;
  String? referralCode;

  UserinfoModel({
    this.id,
    this.gender,
    this.nickname,
    this.avatar,
    this.isFriend,
    this.email,
    this.referralCode,
  });

  factory UserinfoModel.fromJson(Map<String, dynamic> json) => UserinfoModel(
        id: json['id'] as int?,
        gender: json['gender'] as dynamic,
        nickname: json['nickname'] as String?,
        avatar: json['avatar'] as String?,
        isFriend: json['is_friend'] as bool?,
        email: json['email'] as String?,
        referralCode: json['referral_code'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'gender': gender,
        'nickname': nickname,
        'avatar': avatar,
        'is_friend': isFriend,
        'email': email,
        'referral_code': referralCode,
      };
}
