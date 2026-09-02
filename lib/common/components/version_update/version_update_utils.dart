import 'package:XSmartPay/common/index.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'version_update_dialog.dart';

/// 版本更新工具类
/// 提供版本检查、对话框显示等功能
class VersionUpdateUtil {
  /// 检查并显示更新
  static void checkUpdate({
    required String currentVersion,
    required String latestVersion,
    required String description,
    required String apkUrl,
    required int isForce,
    bool showDialogIfDownloading = true, // 如果正在下载是否显示对话框
  }) {
    // 检查是否有正在进行的下载任务
    final manager = VersionUpdateManager.to;
    if (manager.hasActiveDownload()) {
      if (showDialogIfDownloading) {
        // 显示下载状态
        manager.showDownloadStatus();
      }
      return;
    }

    // 检查是否需要更新
    if (_shouldUpdate(currentVersion, latestVersion)) {
      _showUpdateDialog(
        currentVersion: currentVersion,
        latestVersion: latestVersion,
        description: description,
        apkUrl: apkUrl,
        isForce: isForce,
      );
    }
  }

  /// 显示更新弹窗
  static void _showUpdateDialog({
    required String currentVersion,
    required String latestVersion,
    required String description,
    required String apkUrl,
    required int isForce,
  }) {
    Get.dialog(
      VersionUpdateDialog(
        currentVersion: currentVersion,
        latestVersion: latestVersion,
        description: description,
        apkUrl: apkUrl,
        isForce: isForce,
        onUpdate: () => _startDownload(apkUrl, latestVersion, description),
        onCancel: () => Get.back(),
      ),
      barrierDismissible: isForce == 0, // 强制更新时不能点击外部关闭
      barrierColor: Colors.black.withValues(alpha: 0.7),
      transitionDuration: const Duration(milliseconds: 200),
      transitionCurve: Curves.easeInOut,
      useSafeArea: true,
    );
  }

  /// 开始下载
  static Future<void> _startDownload(
    String apkUrl,
    String version,
    String description,
  ) async {
    // if (PlatformUtils().isIOS) {

    // }
    // 打开浏览器
    launchUrl(Uri.parse(apkUrl));
    Get.back();
    return;

    // 使用全局管理器开始下载
    // await VersionUpdateManager.to.startDownload(
    //   apkUrl: apkUrl,
    //   version: version,
    //   description: description,
    // );
  }

  /// 比较版本号
  /// 返回 true 表示 latestVersion > currentVersion
  static bool _shouldUpdate(String currentVersion, String latestVersion) {
    try {
      List<int> current = currentVersion
          .split('.')
          .map((e) => int.tryParse(e.trim()) ?? 0)
          .toList();
      List<int> latest = latestVersion
          .split('.')
          .map((e) => int.tryParse(e.trim()) ?? 0)
          .toList();

      // 补齐版本号长度
      final maxLength =
          current.length > latest.length ? current.length : latest.length;

      while (current.length < maxLength) {
        current.add(0);
      }
      while (latest.length < maxLength) {
        latest.add(0);
      }

      // 逐位比较
      for (int i = 0; i < maxLength; i++) {
        if (latest[i] > current[i]) return true;
        if (latest[i] < current[i]) return false;
      }

      return false; // 版本号相同
    } catch (e) {
      // 版本号解析失败，默认不更新
      return false;
    }
  }

  /// 手动检查是否有下载任务
  static bool hasActiveDownload() {
    return VersionUpdateManager.to.hasActiveDownload();
  }

  /// 显示当前下载状态
  static void showDownloadStatus() {
    VersionUpdateManager.to.showDownloadStatus();
  }

  /// 取消当前下载
  static void cancelDownload() {
    VersionUpdateManager.to.cancelDownload();
  }
}
