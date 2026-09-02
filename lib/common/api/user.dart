import '../index.dart';

/// 后台返回的成功默认是空数组
/// res.statusCode = 200
/// res.data = []
/// 用户 api
class UserApi {
  // 版本更新
  static Future<VersionUpdateModel> versionUpdate(
      VersionUpdateReq? data) async {
    // print('版本更新: ${data?.toJson()}');
    var res = await WPHttpService.to.get(
      '/api/chat/version',
      params: data?.toJson(),
    );
    return VersionUpdateModel.fromJson(res.data);
  }

  // 下载APK
  static Future<String> downloadApk() async {
    var res = await WPHttpService.to.get(
      '/api/chat/download_url',
    );
    return res.data['url'];
  }

  /// 登录
  static Future<UserTokenModel> login(UserLoginReq? data) async {
    var res = await WPHttpService.to.post(
      '/api/app/user/login',
      data: data,
    );
    print('登录: ${res.data}');
    return UserTokenModel.fromJson(res.data['data']);
  }

  /// 注册
  static Future<bool> register(UserRegisterReq? data) async {
    await WPHttpService.to.post(
      '/api/chat/auth/email_register',
      data: data,
    );
    return true;
  }

  /// 发送验证码
  static Future<bool> sendCode(UserSendCodeReq? data) async {
    // print('发送验证码: ${data?.toJson()}');
    await WPHttpService.to.post(
      '/api/chat/auth/email_send',
      data: data,
    );
    return true;
  }

  /// 忘记密码
  static Future<bool> forgotPassword(UserForgotPasswordReq? data) async {
    await WPHttpService.to.post(
      '/api/chat/auth/forget_password',
      data: data,
    );
    return true;
  }

  // 修改登录密码
  static Future<bool> editLoginPassword(EditLoginPasswordReq? data) async {
    await WPHttpService.to.post(
      '/api/chat/users/change_password',
      data: data,
    );
    return true;
  }

  // 获取用户信息
  static Future<UserinfoModel> getUserInfo() async {
    var res = await WPHttpService.to.get(
      '/api/chat/users/my',
    );
    return UserinfoModel.fromJson(res.data);
  }

  // 修改用户信息
  static Future<bool> updateUserInfo(EditUserinfoReq? data) async {
    await WPHttpService.to.post(
      '/api/chat/users/my',
      data: data,
    );
    return true;
  }
}
