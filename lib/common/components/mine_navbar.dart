import 'package:ducafe_ui_core/ducafe_ui_core.dart';
import 'package:flutter/material.dart';
import 'package:XSmartPay/common/index.dart';
import 'package:get/get.dart';

class MineNavBar extends StatelessWidget implements PreferredSizeWidget {
  final double height;
  final Color? backgroundColor;
  final Widget? leftWidget;
  final Widget? titleWidget;
  final Widget? rightWidget;
  final bool showBack;

  const MineNavBar({
    super.key,
    this.height = 45,
    this.backgroundColor,
    this.leftWidget,
    this.titleWidget,
    this.rightWidget,
    this.showBack = true,
  });

  @override
  Size get preferredSize => Size.fromHeight(height);

  @override
  Widget build(BuildContext context) {
    Widget? left = leftWidget;
    // 只要传入leftWidget就不显示返回按钮
    if (left == null && showBack) {
      left = <Widget>[
        Icon(Icons.arrow_back_ios_new, color: AppTheme.colorfff, size: 20),
      ].toRow().width(40).onTap(() {
        Get.back();
      });
    }

    final double statusBarHeight = MediaQuery.of(context).padding.top;
    return Container(
      height: height + statusBarHeight,
      padding: EdgeInsets.only(
        top: statusBarHeight,
        left: 30.w,
        right: 30.w,
      ),
      color: backgroundColor ?? AppTheme.navBgColor,
      child: Stack(
        children: [
          // 左右组件层 - 确保垂直居中
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: left ?? const SizedBox(width: 40),
              ),
              const Spacer(),
              Align(
                alignment: Alignment.centerRight,
                child: rightWidget ?? const SizedBox(width: 40),
              ),
            ],
          ),
          // 标题居中层 - 确保水平和垂直都居中
          Positioned.fill(
            child: Center(
              child: titleWidget ?? const SizedBox.shrink(),
            ),
          ),
        ],
      ),
    );
  }
}
