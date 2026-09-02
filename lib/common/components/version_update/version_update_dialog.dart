import 'package:XSmartPay/common/index.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ducafe_ui_core/ducafe_ui_core.dart';

/// 版本更新对话框
/// 显示版本信息、更新描述、更新按钮
class VersionUpdateDialog extends StatelessWidget {
  final String currentVersion; // 当前版本
  final String latestVersion; // 最新版本
  final String? description; // 更新描述
  final String? apkUrl; // APK下载地址
  final int isForce; // 是否强制更新 0:否 1:是
  final VoidCallback? onCancel; // 取消回调
  final Function() onUpdate; // 更新回调

  const VersionUpdateDialog({
    super.key,
    required this.currentVersion,
    required this.latestVersion,
    this.description,
    this.apkUrl,
    this.isForce = 0,
    this.onCancel,
    required this.onUpdate,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppTheme.pageBgColor,
      elevation: 0,
      child: Container(
        width: 590.w,
        decoration: BoxDecoration(
          color: AppTheme.blockBgColor,
          borderRadius: BorderRadius.circular(20.w),
        ),
        child: Stack(
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // 更新图片
                ImgWidget(
                  path: 'assets/img/update.png',
                  width: 590.w,
                  height: 280.w,
                  fit: BoxFit.contain,
                ),
                SizedBox(height: 20.w),

                // 标题
                TextWidget.body(
                  '发现新版本'.tr,
                  textAlign: TextAlign.center,
                  weight: FontWeight.w600,
                  size: 32.sp,
                ),
                SizedBox(height: 16.w),

                // 版本号对比
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextWidget.body(
                      currentVersion,
                      size: 26.sp,
                      color: AppTheme.color999,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: Icon(
                        Icons.arrow_forward_rounded,
                        size: 28.sp,
                        color: AppTheme.primary,
                      ),
                    ),
                    TextWidget.body(
                      latestVersion,
                      size: 26.sp,
                      color: AppTheme.primary,
                      weight: FontWeight.w600,
                    ),
                  ],
                ),
                SizedBox(height: 24.w),

                // 更新描述
                Container(
                  width: 530.w,
                  constraints: BoxConstraints(
                    minHeight: 100.w,
                    maxHeight: 200.w,
                  ),
                  padding: EdgeInsets.all(24.w),
                  decoration: BoxDecoration(
                    color: AppTheme.blockTwoBgColor,
                    borderRadius: BorderRadius.circular(12.w),
                  ),
                  child: SingleChildScrollView(
                    child: TextWidget.body(
                      description ?? '发现新版本，建议立即更新'.tr,
                      size: 24.sp,
                      textAlign: TextAlign.left,
                    ),
                  ),
                ),
                SizedBox(height: 30.w),

                // 更新按钮 - 不再显示下载进度，由全局悬浮窗显示
                ButtonWidget(
                  text: '立即更新'.tr,
                  width: 530,
                  height: 88,
                  margin: const EdgeInsets.all(0),
                  onTap: onUpdate,
                ),
                SizedBox(height: 30.w),
              ],
            ),

            // 关闭按钮（仅非强制更新时显示）
            if (isForce == 0)
              Positioned(
                right: 20.w,
                top: 20.w,
                child: GestureDetector(
                  onTap: () {
                    onCancel?.call();
                    Get.back();
                  },
                  child: Container(
                    width: 40.w,
                    height: 40.w,
                    decoration: BoxDecoration(
                      color: Colors.black26,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.close,
                      color: Colors.white,
                      size: 24.w,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
