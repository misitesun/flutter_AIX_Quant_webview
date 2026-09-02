import 'dart:io';
import 'package:dio/dio.dart';
import 'package:ducafe_ui_core/ducafe_ui_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:app_installer/app_installer.dart';
import 'package:XSmartPay/common/index.dart';

/// 版本更新管理器（全局单例）
/// 负责管理应用的版本更新、下载任务、状态管理
class VersionUpdateManager extends GetxService {
  static VersionUpdateManager get to => Get.find();

  // 下载状态
  final RxBool isDownloading = false.obs;
  final RxDouble downloadProgress = 0.0.obs;
  final Rx<String> downloadStatus = '准备下载...'.obs;

  // 下载任务控制
  CancelToken? _cancelToken;
  String? _currentApkUrl;
  OverlayEntry? _progressOverlay;

  // 版本信息
  String? _latestVersion;
  String? _updateDescription;

  @override
  void onInit() {
    super.onInit();
    _initListeners();
  }

  @override
  void onClose() {
    cancelDownload();
    _removeProgressOverlay();
    super.onClose();
  }

  /// 初始化监听器
  void _initListeners() {
    // 监听下载状态变化
    ever(isDownloading, (downloading) {
      if (downloading) {
        _showProgressOverlay();
      } else {
        _removeProgressOverlay();
      }
    });
  }

  /// 检查是否有正在进行的下载任务
  bool hasActiveDownload() => isDownloading.value;

  /// 获取当前下载进度
  double getCurrentProgress() => downloadProgress.value;

  /// 开始下载APK
  Future<void> startDownload({
    required String apkUrl,
    required String version,
    String? description,
  }) async {
    // 如果已经在下载中，不重复下载
    if (isDownloading.value) {
      Loading.toast('下载任务进行中'.tr + '：${downloadProgress.value.toInt()}%');
      return;
    }

    try {
      isDownloading.value = true;
      downloadProgress.value = 0;
      downloadStatus.value = '开始下载...'.tr;
      _currentApkUrl = apkUrl;
      _latestVersion = version;
      _updateDescription = description;

      // 创建取消令牌
      _cancelToken = CancelToken();

      // 获取存储目录
      final dir = await getExternalStorageDirectory();
      if (dir == null) {
        throw Exception('无法获取存储目录'.tr);
      }

      final apkPath = '${dir.path}/app-update.apk';

      // 删除旧的APK文件
      final oldFile = File(apkPath);
      if (await oldFile.exists()) {
        await oldFile.delete();
      }

      downloadStatus.value = '下载中...'.tr;

      // 开始下载
      await Dio().download(
        apkUrl,
        apkPath,
        cancelToken: _cancelToken,
        onReceiveProgress: (received, total) {
          if (total != -1) {
            final progress = (received / total * 100);
            downloadProgress.value = progress;
            downloadStatus.value = '下载中...'.tr + ' ${progress.toInt()}%';
          }
        },
      );

      // 下载完成
      if (!_cancelToken!.isCancelled) {
        downloadStatus.value = '下载完成，准备安装...'.tr;
        await _installApk(apkPath);
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.cancel) {
        downloadStatus.value = '下载已取消'.tr;
        Loading.toast('下载已取消'.tr);
      } else {
        downloadStatus.value = '下载失败'.tr;
        Loading.error('下载失败'.tr + '：${e.message}');
      }
    } catch (e) {
      downloadStatus.value = '下载失败'.tr;
      Loading.error('下载失败'.tr + '：$e');
    } finally {
      // 延迟重置状态，让用户看到最终状态
      Future.delayed(const Duration(seconds: 1), () {
        isDownloading.value = false;
        downloadProgress.value = 0;
        downloadStatus.value = '准备下载...'.tr;
        _cancelToken = null;
        _currentApkUrl = null;
      });
    }
  }

  /// 取消下载
  void cancelDownload() {
    if (_cancelToken != null && !_cancelToken!.isCancelled) {
      _cancelToken?.cancel('用户取消下载'.tr);
      downloadStatus.value = '下载已取消'.tr;
      isDownloading.value = false;
      downloadProgress.value = 0;
      _cancelToken = null;
      _currentApkUrl = null;
      Loading.toast('下载已取消'.tr);
    }
  }

  /// 安装APK
  Future<void> _installApk(String apkPath) async {
    try {
      if (Platform.isAndroid) {
        // 检查文件是否存在
        final file = File(apkPath);
        if (!await file.exists()) {
          throw Exception('APK文件不存在'.tr);
        }

        // 安装APK
        await AppInstaller.installApk(apkPath);
        Loading.success('开始安装应用'.tr);
      } else {
        Loading.error('仅支持Android设备'.tr);
      }
    } catch (e) {
      Loading.error('安装失败'.tr + '：$e');
    }
  }

  /// 显示全局进度提示
  void _showProgressOverlay() {
    if (_progressOverlay != null) return;

    _progressOverlay = OverlayEntry(
      builder: (context) => Positioned(
        top: 100.w, // 右上角位置
        right: 30.w,
        child: _buildProgressWidget(),
      ),
    );

    // 延迟添加，确保上下文可用
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final overlay = Overlay.of(Get.context!);
      overlay.insert(_progressOverlay!);
    });
  }

  /// 移除全局进度提示
  void _removeProgressOverlay() {
    _progressOverlay?.remove();
    _progressOverlay = null;
  }

  /// 构建进度组件 - 右上角悬浮样式
  Widget _buildProgressWidget() {
    return Obx(
      () => AnimatedOpacity(
        duration: const Duration(milliseconds: 300),
        opacity: isDownloading.value ? 1.0 : 0.0,
        child: isDownloading.value
            ? GestureDetector(
                onTap: () => _showCancelConfirmDialog(),
                child: Container(
                  width: 140.w,
                  height: 140.w,
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.75), // 半透明背景
                    borderRadius: BorderRadius.circular(20.w),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.3),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // 圆形进度指示器
                      SizedBox(
                        width: 100.w,
                        height: 100.w,
                        child: CircularProgressIndicator(
                          value: downloadProgress.value / 100,
                          strokeWidth: 6.w,
                          backgroundColor: Colors.white.withValues(alpha: 0.2),
                          valueColor: AlwaysStoppedAnimation<Color>(
                            AppTheme.primary,
                          ),
                        ),
                      ),
                      // 中心内容
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // 下载图标
                          Icon(
                            Icons.download_rounded,
                            size: 32.sp,
                            color: Colors.white,
                          ),
                          SizedBox(height: 6.w),
                          // 百分比文字
                          TextWidget.body(
                            '${downloadProgress.value.toInt()}%',
                            size: 20.sp,
                            color: Colors.white,
                            weight: FontWeight.w600,
                          ),
                        ],
                      ),
                      // 右上角关闭按钮
                      Positioned(
                        top: 6.w,
                        right: 6.w,
                        child: Container(
                          width: 32.w,
                          height: 32.w,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.2),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.close,
                            size: 18.sp,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            : const SizedBox.shrink(),
      ),
    );
  }

  /// 显示取消确认对话框
  void _showCancelConfirmDialog() {
    showGeneralDialog(
      context: Get.context!,
      pageBuilder: (context, animation, secondaryAnimation) {
        return DialogWidget(
          title: '取消下载'.tr,
          // description: '确定要取消当前下载任务吗？'.tr,
          content: TextWidget.body(
            '确定要取消当前下载任务吗？'.tr,
            color: AppTheme.color666,
          ),
          onConfirm: () {
            Get.back();
            cancelDownload();
          },
        );
      },
    );
  }

  /// 显示下载状态
  void showDownloadStatus() {
    if (isDownloading.value) {
      Loading.toast(
        '下载任务进行中'.tr + '：${downloadProgress.value.toInt()}%',
      );
    } else {
      Loading.toast('当前没有下载任务'.tr);
    }
  }

  /// 重试下载
  Future<void> retryDownload() async {
    if (_currentApkUrl != null) {
      await startDownload(
        apkUrl: _currentApkUrl!,
        version: _latestVersion ?? '',
        description: _updateDescription,
      );
    }
  }
}
