import '../index.dart';

/// 后台返回的成功默认是空数组
/// res.statusCode = 200
/// res.data = []
/// 用户 api
/// 直接使用 res.data['code'] 获取数据
class HomeApi {
  // 版本更新
  static Future<VersionUpdateModel> versionUpdate(
      VersionUpdateReq? data) async {
    var res = await WPHttpService.to.get(
      '/api/version',
      params: data?.toJson(),
    );
    return VersionUpdateModel.fromJson(res.data);
  }
}
