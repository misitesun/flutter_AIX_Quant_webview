import 'package:ducafe_ui_core/ducafe_ui_core.dart';
import 'package:flutter/material.dart';

// 排版类型
enum TextWidgetType {
  body,
}

class TextWidget extends StatelessWidget {
  const TextWidget({
    super.key,
    required this.text,
    this.type,
    this.size,
    this.textStyle,
    this.color,
    this.weight,
    this.maxLines,
    this.softWrap,
    this.overflow,
    this.textAlign,
    this.fontStyle,
    this.lineThrough = false,
    this.lineThroughColor,
  });

  /// 文字
  final String text;

  /// 排版类型
  final TextWidgetType? type;

  /// 组件样式
  final TextStyle? textStyle;

  /// 字体样式
  final FontStyle? fontStyle;

  /// 颜色
  final Color? color;

  /// 大小
  final double? size;

  /// 重量
  final FontWeight? weight;

  /// 行数
  final int? maxLines;

  /// 自动换行
  final bool? softWrap;

  /// 溢出
  final TextOverflow? overflow;

  /// 对齐方式
  final TextAlign? textAlign;

  /// 是否显示中划线
  final bool lineThrough;

  /// 中划线颜色
  final Color? lineThroughColor;

  /// body
  const TextWidget.body(
    this.text, {
    super.key,
    this.size,
    this.color,
    this.weight = FontWeight.w400,
    this.maxLines,
    this.softWrap,
    this.overflow,
    this.textAlign,
    this.textStyle,
    this.fontStyle,
    this.lineThrough = false,
    this.lineThroughColor,
  }) : type = TextWidgetType.body;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        color: color,
        fontSize: size ?? 28.sp,
        fontWeight: weight,
        fontStyle: fontStyle,
        decoration: lineThrough ? TextDecoration.lineThrough : null,
        decorationColor: lineThroughColor,
      ),
      maxLines: maxLines,
      softWrap: softWrap,
      overflow: overflow,
      textAlign: textAlign,
    );
  }
}
