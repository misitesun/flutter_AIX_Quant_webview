import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

/// 底部加载更多组件
class SmartRefresherHeaderWidget extends StatelessWidget {
  /// 下拉刷新文本
  final String? idleText;

  /// 正在刷新文本
  final String? refreshingText;

  /// 刷新完成文本
  final String? completeText;

  /// 刷新失败文本
  final String? failedText;

  /// 释放刷新文本
  final String? releaseText;

  /// 文字颜色
  final Color? textColor;

  const SmartRefresherHeaderWidget({
    super.key,
    this.idleText,
    this.refreshingText,
    this.completeText,
    this.failedText,
    this.releaseText,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return ClassicHeader(
      refreshStyle: RefreshStyle.Follow,
      // backgroundColor: Colors.red,  // 背景色
      textStyle: TextStyle(color: textColor ?? const Color(0xff000000)), // 文字颜色
      idleText: idleText ?? '下拉刷新'.tr,
      refreshingText: refreshingText ?? '正在刷新'.tr,
      completeText: completeText ?? '刷新完成'.tr,
      failedText: failedText ?? '刷新失败'.tr,
      releaseText: releaseText ?? '释放刷新'.tr,
      failedIcon:
          Icon(Icons.error, color: textColor ?? const Color(0xff181818)),
      completeIcon:
          Icon(Icons.done, color: textColor ?? const Color(0xff181818)),
      idleIcon: Icon(Icons.arrow_downward,
          color: textColor ?? const Color(0xff181818)),
      releaseIcon:
          Icon(Icons.refresh, color: textColor ?? const Color(0xff181818)),
    );
  }
}
