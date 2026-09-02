class LoginTokenModel {
  String? accessToken;

  LoginTokenModel({this.accessToken});

  factory LoginTokenModel.fromJson(Map<String, dynamic> json) {
    return LoginTokenModel(
      accessToken: json['access_token'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'access_token': accessToken,
      };
}
