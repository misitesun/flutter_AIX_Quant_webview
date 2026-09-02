class EditUserinfoReq {
  String? avatar;
  String? nickname;

  EditUserinfoReq({this.avatar, this.nickname});

  factory EditUserinfoReq.fromJson(Map<String, dynamic> json) {
    return EditUserinfoReq(
      avatar: json['avatar'] as String?,
      nickname: json['nickname'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'avatar': avatar,
        'nickname': nickname,
      };
}
