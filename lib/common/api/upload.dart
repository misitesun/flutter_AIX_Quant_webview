import 'package:dio/dio.dart';
import 'dart:io';
import '../index.dart';

class UploadApi {
  /// 上传单张图片
  static Future<String> uploadImage(File file, String url) async {
    // 创建 FormData
    String fileName = file.path.split('/').last;
    FormData formData = FormData.fromMap({
      "upload": await MultipartFile.fromFile(
        file.path,
        filename: fileName,
      ),
    });
    // 发送请求
    var res = await WPHttpService.to.post(
      url,
      data: formData,
      options: Options(
        contentType: "multipart/form-data",
      ),
    );
    // 假设接口返回图片URL
    return res.data['url'] ?? '';
  }

  /// 上传多张图片
  static Future<List<String>> uploadImages(List<File> files) async {
    // 构建多文件上传
    var formList = [];
    for (var file in files) {
      String fileName = file.path.split('/').last;
      formList.add(await MultipartFile.fromFile(
        file.path,
        filename: fileName,
      ));
    }

    FormData formData = FormData.fromMap({
      "upload": formList, // 后端接收多个文件的参数名仍为 file
    });

    // 发送请求
    var res = await WPHttpService.to.post(
      '/api/uploads/oss',
      data: formData,
      options: Options(
        contentType: "multipart/form-data",
      ),
    );

    // 假设接口返回图片URL列表
    List<String> urls = [];
    if (res.data['data'] != null) {
      for (var url in res.data['data']) {
        urls.add(url.toString());
      }
    }
    return urls;
  }
}
