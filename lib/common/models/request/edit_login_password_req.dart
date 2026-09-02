class EditLoginPasswordReq {
  String? oldPassword;
  String? newPassword;

  EditLoginPasswordReq({this.oldPassword, this.newPassword});

  factory EditLoginPasswordReq.fromJson(Map<String, dynamic> json) {
    return EditLoginPasswordReq(
      oldPassword: json['old_password'] as String?,
      newPassword: json['new_password'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'old_password': oldPassword,
        'new_password': newPassword,
      };
}
