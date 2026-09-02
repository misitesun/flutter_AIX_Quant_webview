import 'dart:io';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:XSmartPay/common/index.dart';
import 'package:image_gallery_saver_plus/image_gallery_saver_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:get/get.dart';

/// 图片保存工具类
/// 支持保存网络图片到本地相册
/// 自动处理iOS和Android的权限适配
class ImageSaverHelper {
  static final Dio _dio = Dio();

  /// 保存网络图片到相册
  /// [imageUrl] 图片链接
  /// [fileName] 文件名（可选，默认使用时间戳）
  /// [quality] 图片质量（0-100，默认100）
  /// [showLoading] 是否显示加载弹窗（默认true）
  /// [showResult] 是否显示结果提示（默认true）
  /// Returns: 是否保存成功
  static Future<bool> saveNetworkImage(
    String imageUrl, {
    String? fileName,
    int quality = 100,
    bool showLoading = true,
    bool showResult = true,
  }) async {
    if (imageUrl.isEmpty) {
      if (showResult) Loading.error('图片地址不能为空'.tr);
      return false;
    }

    if (showLoading) Loading.show();

    try {
      // 1. 检查权限
      if (!await _checkAndRequestPermission()) {
        return false;
      }

      // 2. 下载图片
      final imageData = await _downloadImage(imageUrl);
      if (imageData == null) {
        if (showResult) Loading.error('下载图片失败'.tr);
        return false;
      }

      // 3. 生成文件名
      final name = fileName ?? "image_${DateTime.now().millisecondsSinceEpoch}";

      // 4. 保存到相册
      final result = await ImageGallerySaverPlus.saveImage(
        imageData,
        quality: quality,
        name: name,
      );

      if (result != null && result['isSuccess']) {
        if (showResult) Loading.success('保存成功'.tr);
        return true;
      } else {
        if (showResult) Loading.error('保存失败，请确保已授予存储权限'.tr);
        return false;
      }
    } catch (e) {
      if (showResult) Loading.error('保存失败：${e.toString()}'.tr);
      return false;
    } finally {
      if (showLoading) Loading.dismiss();
    }
  }

  /// 保存本地图片文件到相册
  /// [imagePath] 本地图片路径
  /// [fileName] 文件名（可选，默认使用时间戳）
  /// [quality] 图片质量（0-100，默认100）
  /// [showLoading] 是否显示加载弹窗（默认true）
  /// [showResult] 是否显示结果提示（默认true）
  /// Returns: 是否保存成功
  static Future<bool> saveLocalImage(
    String imagePath, {
    String? fileName,
    int quality = 100,
    bool showLoading = true,
    bool showResult = true,
  }) async {
    if (imagePath.isEmpty) {
      if (showResult) Loading.error('图片路径不能为空'.tr);
      return false;
    }

    if (showLoading) Loading.show();

    try {
      // 1. 检查权限
      if (!await _checkAndRequestPermission()) {
        return false;
      }

      // 2. 读取本地文件
      final file = File(imagePath);
      if (!await file.exists()) {
        if (showResult) Loading.error('图片文件不存在'.tr);
        return false;
      }

      final imageData = await file.readAsBytes();

      // 3. 生成文件名
      final name = fileName ?? "image_${DateTime.now().millisecondsSinceEpoch}";

      // 4. 保存到相册
      final result = await ImageGallerySaverPlus.saveImage(
        imageData,
        quality: quality,
        name: name,
      );

      if (result != null && result['isSuccess']) {
        if (showResult) Loading.success('保存成功'.tr);
        return true;
      } else {
        if (showResult) Loading.error('保存失败，请确保已授予存储权限'.tr);
        return false;
      }
    } catch (e) {
      if (showResult) Loading.error('保存失败：${e.toString()}'.tr);
      return false;
    } finally {
      if (showLoading) Loading.dismiss();
    }
  }

  /// 保存内存图片到相册（Uint8List）
  static Future<bool> saveUint8ListImage(
    Uint8List imageData, {
    String? fileName,
    int quality = 100,
    bool showLoading = true,
    bool showResult = true,
  }) async {
    if (imageData.isEmpty) {
      if (showResult) Loading.error('图片数据为空'.tr);
      return false;
    }

    if (showLoading) Loading.show();

    try {
      // 1. 检查权限
      if (!await _checkAndRequestPermission()) {
        return false;
      }

      // 2. 生成文件名
      final name = fileName ?? "image_${DateTime.now().millisecondsSinceEpoch}";

      // 3. 保存到相册
      final result = await ImageGallerySaverPlus.saveImage(
        imageData,
        quality: quality,
        name: name,
      );

      if (result != null && result['isSuccess']) {
        if (showResult) Loading.success('保存成功'.tr);
        return true;
      } else {
        if (showResult) Loading.error('保存失败，请确保已授予存储权限'.tr);
        return false;
      }
    } catch (e) {
      if (showResult) Loading.error('保存失败：${e.toString()}'.tr);
      return false;
    } finally {
      if (showLoading) Loading.dismiss();
    }
  }

  /// 下载网络图片
  /// [imageUrl] 图片链接
  /// Returns: 图片字节数据
  static Future<Uint8List?> _downloadImage(String imageUrl) async {
    try {
      final response = await _dio.get(
        imageUrl,
        options: Options(
          responseType: ResponseType.bytes,
          // 设置超时时间
          sendTimeout: const Duration(seconds: 30),
          receiveTimeout: const Duration(seconds: 30),
        ),
      );

      if (response.statusCode == 200) {
        return Uint8List.fromList(response.data);
      }
      return null;
    } catch (e) {
      print('下载图片失败: $e');
      return null;
    }
  }

  /// 检查并请求权限
  /// Returns: 是否获得权限
  static Future<bool> _checkAndRequestPermission() async {
    try {
      if (Platform.isIOS) {
        // iOS权限处理
        var status = await Permission.photos.status;
        if (status.isDenied) {
          status = await Permission.photos.request();
        }

        if (status.isPermanentlyDenied) {
          Loading.error('请在设置中开启照片访问权限'.tr);
          // 可以引导用户去设置页面
          await openAppSettings();
          return false;
        }

        return status.isGranted;
      } else if (Platform.isAndroid) {
        // Android权限处理
        try {
          final androidInfo = await DeviceInfoPlugin().androidInfo;
          final sdkInt = androidInfo.version.sdkInt;

          PermissionStatus status;
          if (sdkInt >= 30) {
            // Android 11 (API 30) 及以上，使用 manageExternalStorage
            status = await Permission.manageExternalStorage.status;
            if (status.isDenied) {
              status = await Permission.manageExternalStorage.request();
            }
          } else {
            // Android 10 (API 29) 及以下，使用存储权限
            status = await Permission.storage.status;
            if (status.isDenied) {
              status = await Permission.storage.request();
            }
          }

          if (status.isPermanentlyDenied) {
            Loading.error('请在设置中开启存储权限'.tr);
            await openAppSettings();
            return false;
          }

          if (!status.isGranted) {
            Loading.error('需要存储权限才能保存图片'.tr);
            return false;
          }
          return true;
        } catch (e) {
          print('获取Android设备信息失败: $e');
          // 如果无法获取设备信息，尝试使用存储权限
          var status = await Permission.storage.status;
          if (status.isDenied) {
            status = await Permission.storage.request();
          }
          return status.isGranted;
        }
      }

      return true;
    } catch (e) {
      print('权限检查失败：$e');
      Loading.error('权限检查失败：${e.toString()}'.tr);
      return false;
    }
  }

  /// 检查是否有权限（不请求）
  /// Returns: 是否有权限
  static Future<bool> hasPermission() async {
    try {
      if (Platform.isIOS) {
        var status = await Permission.photos.status;
        return status.isGranted;
      } else if (Platform.isAndroid) {
        final androidInfo = await DeviceInfoPlugin().androidInfo;
        final sdkInt = androidInfo.version.sdkInt;

        PermissionStatus status;
        if (sdkInt >= 30) {
          status = await Permission.manageExternalStorage.status;
        } else {
          status = await Permission.storage.status;
        }

        return status.isGranted;
      }
      return true;
    } catch (e) {
      return false;
    }
  }
}
