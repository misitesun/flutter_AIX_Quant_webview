import 'package:ducafe_ui_core/ducafe_ui_core.dart';
import 'package:XSmartPay/common/index.dart';
import 'package:flutter/material.dart';

class ButtonWidget extends StatelessWidget {
  /// 按钮文本
  final String text;

  /// 按钮宽度，单位.w
  final double? width;

  /// 按钮高度，单位.w
  final double? height;

  /// 按钮背景色
  final Color backgroundColor;

  /// 按钮文字颜色
  final Color textColor;

  /// 按钮文字大小，单位.sp
  final double fontSize;

  /// 按钮圆角大小，单位.w
  final double borderRadius;

  /// 按钮左侧图标
  final IconData? icon;

  /// 图标颜色，默认与文字颜色相同
  final Color? iconColor;

  /// 图标大小，单位.w
  final double iconSize;

  /// 图标与文字间距，单位.w
  final double iconSpacing;

  /// 按钮点击事件
  final VoidCallback? onTap;

  /// 按钮是否禁用
  final bool disabled;

  /// 禁用时的背景色
  final Color disabledBackgroundColor;

  /// 禁用时的文字颜色
  final Color disabledTextColor;

  /// 按钮内边距
  final EdgeInsetsGeometry? padding;

  /// 按钮外边距
  final EdgeInsetsGeometry? margin;

  /// 是否显示阴影
  final bool showShadow;

  /// 阴影颜色
  final Color shadowColor;

  /// 阴影偏移
  final Offset shadowOffset;

  /// 阴影模糊半径
  final double shadowBlurRadius;

  /// 水波纹颜色，默认为白色半透明
  final Color? splashColor;

  /// 高亮颜色，默认为白色微透明
  final Color? highlightColor;

  /// 是否显示边框
  final bool showBorder;

  /// 边框颜色
  final Color borderColor;

  /// 边框宽度
  final double borderWidth;
  const ButtonWidget({
    super.key,
    required this.text,
    this.width,
    this.height = 88,
    this.backgroundColor = AppTheme.primary,
    this.textColor = Colors.white,
    this.fontSize = 26,
    this.borderRadius = 44,
    this.icon,
    this.iconColor,
    this.iconSize = 32,
    this.iconSpacing = 10,
    this.onTap,
    this.disabled = false,
    this.disabledBackgroundColor = const Color(0xFFCCCCCC),
    this.disabledTextColor = const Color(0xFF999999),
    this.padding,
    this.margin,
    this.showShadow = false,
    this.shadowColor = const Color(0x40000000),
    this.shadowOffset = const Offset(0, 4),
    this.shadowBlurRadius = 44,
    this.splashColor,
    this.highlightColor,
    this.showBorder = false,
    this.borderColor = AppTheme.primary,
    this.borderWidth = 1.0,
  });

  @override
  Widget build(BuildContext context) {
    // 确定实际使用的颜色
    final Color actualBackgroundColor =
        disabled ? disabledBackgroundColor : backgroundColor;
    final Color actualTextColor = disabled ? disabledTextColor : textColor;
    final Color actualIconColor =
        disabled ? disabledTextColor : (iconColor ?? textColor);

    // 构建按钮内容
    Widget buttonContent = Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // 如果有图标，则显示图标
        if (icon != null) ...[
          Icon(
            icon,
            size: iconSize.w,
            color: actualIconColor,
          ),
          SizedBox(width: iconSpacing.w),
        ],

        // 按钮文本
        TextWidget.body(
          text,
          color: actualTextColor,
          size: fontSize.sp,
          weight: FontWeight.w400,
        ),
      ],
    );

    // 使用Material和InkWell实现水波纹效果
    Widget button = Container(
      margin: margin,
      decoration: showShadow
          ? BoxDecoration(
              borderRadius: BorderRadius.circular(borderRadius.w),
              boxShadow: [
                BoxShadow(
                  color: shadowColor,
                  offset: shadowOffset,
                  blurRadius: shadowBlurRadius,
                ),
              ],
            )
          : null,
      child: Material(
        color: actualBackgroundColor,
        borderRadius: BorderRadius.circular(borderRadius.w),
        child: InkWell(
          onTap: disabled ? null : onTap,
          splashColor: splashColor ?? Colors.white.withOpacity(0.3),
          highlightColor: highlightColor ?? Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(borderRadius.w),
          child: padding != null
              ? Padding(
                  padding: padding!,
                  child: buttonContent,
                )
              : Center(child: buttonContent),
        ),
      ).decorated(
        border: showBorder
            ? Border.all(color: borderColor, width: borderWidth)
            : null,
        borderRadius: BorderRadius.circular(borderRadius.w),
      ),
    );

    // 设置固定宽高
    if (width != null || height != null) {
      button = SizedBox(
        width: width?.w,
        height: height?.w,
        child: button,
      );
    }

    return button;
  }
}
