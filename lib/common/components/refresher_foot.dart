import 'package:ducafe_ui_core/ducafe_ui_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

/// 底部加载更多组件
class SmartRefresherFooterWidget extends StatelessWidget {
  /// 底部高度
  final double? height;

  /// 图标大小
  final double? iconSize;

  /// 没有更多数据文本
  final String? noDataText;

  /// 文字颜色
  final Color? textColor;

  const SmartRefresherFooterWidget({
    super.key,
    this.iconSize,
    this.height,
    this.noDataText,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return ClassicFooter(
      height: height ?? 60 + MediaQuery.of(context).padding.bottom + 30, // 底部高度
      loadingIcon: const CupertinoActivityIndicator().tight(
        width: iconSize ?? 25,
        height: iconSize ?? 25,
      ), // 加载中
      textStyle: TextStyle(color: textColor ?? const Color(0xff999999)), // 文字颜色
      outerBuilder: (child) => child.center().height(height ?? 60), // 内容
      noDataText: noDataText ?? '没有更多数据'.tr,
      loadingText: '加载中...'.tr,
      failedText: '加载失败'.tr,
      canLoadingText: '加载中...'.tr,
    );
  }
}
