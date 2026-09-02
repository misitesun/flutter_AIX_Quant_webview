import 'package:ducafe_ui_core/ducafe_ui_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../index.dart';

/**
 * 富文本输入框
<Widget>[
  RichInputWidget(
    placeholder: '请输入直播公告，最多150字符',
    maxLines: 4, // 设置最大行数
    defaultStyle: RichTextStyle(
      fontSize: 28.sp,
      color: Colors.black,
    ),
    controller: controller.noticeController,
  ).expanded()
].toRow()
.paddingAll(30.w)
.backgroundColor(AppTheme.pageBgColor)
.clipRRect(all: 20.w)

*/

/// 富文本样式
class RichTextStyle {
  final Color? color;
  final double? fontSize;
  final FontWeight? fontWeight;
  final FontStyle? fontStyle;
  final TextDecoration? decoration;
  final Color? backgroundColor;

  RichTextStyle({
    this.color,
    this.fontSize,
    this.fontWeight,
    this.fontStyle,
    this.decoration,
    this.backgroundColor,
  });

  TextStyle toTextStyle() {
    return TextStyle(
      color: color ?? AppTheme.colorfff,
      fontSize: fontSize ?? 28.sp,
      fontWeight: fontWeight,
      fontStyle: fontStyle,
      decoration: decoration,
      backgroundColor: backgroundColor,
    );
  }
}

class RichInputWidget extends StatefulWidget {
  const RichInputWidget({
    super.key,
    this.controller,
    this.placeholder,
    this.prefix,
    this.suffix,
    this.cleanable = true,
    this.readOnly = false,
    this.onChanged,
    this.keyboardType,
    this.autofocus,
    this.defaultStyle,
    this.maxLines = 1,
  });

  /// 输入框控制器
  final TextEditingController? controller;

  /// 占位符
  final String? placeholder;

  /// 前缀
  final Widget? prefix;

  /// 后缀
  final Widget? suffix;

  /// 是否可清空
  final bool? cleanable;

  /// 是否只读
  final bool? readOnly;

  /// 输入变化回调
  final Function(String)? onChanged;

  /// 输入法类型
  final TextInputType? keyboardType;

  /// 自动焦点
  final bool? autofocus;

  /// 默认文本样式
  final RichTextStyle? defaultStyle;

  /// 最大行数
  final int maxLines;

  @override
  State<RichInputWidget> createState() => _RichInputWidgetState();
}

class _RichInputWidgetState extends State<RichInputWidget> {
  late TextEditingController controller;
  FocusNode focusNode = FocusNode();
  bool? hasFocus;
  bool showClean = false;
  late RichTextStyle currentStyle;
  List<TextSpan> textSpans = [];

  Widget? prefix;
  Widget? suffix;

  @override
  void initState() {
    super.initState();

    controller = widget.controller ?? TextEditingController();
    hasFocus = focusNode.hasFocus;
    focusNode.addListener(_onFocusChange);
    prefix = widget.prefix;
    suffix = widget.suffix;
    currentStyle = widget.defaultStyle ?? RichTextStyle();
  }

  @override
  void didUpdateWidget(RichInputWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != oldWidget.controller) {
      controller = widget.controller ?? TextEditingController();
    }
  }

  @override
  void dispose() {
    focusNode.dispose();
    super.dispose();
  }

  // 监听是否失去焦点
  void _onFocusChange() {
    setState(() {
      hasFocus = focusNode.hasFocus;
    });
  }

  // 更新富文本片段
  void _updateTextSpans() {
    textSpans = [
      TextSpan(
        text: controller.text,
        style: currentStyle.toTextStyle(),
      ),
    ];
  }

  // 清除所有内容
  void clear() {
    controller.clear();
    setState(() {
      showClean = false;
    });
    widget.onChanged?.call("");
  }

  // 设置文本样式
  void setStyle(RichTextStyle style) {
    setState(() {
      currentStyle = style;
      _updateTextSpans();
    });
  }

  Widget _buildView() {
    // 清除按钮
    Widget? cleanButton = widget.cleanable == true && showClean == true
        ? const Icon(
            Icons.cancel,
            size: 20,
            color: AppTheme.color999,
          ).onTap(clear)
        : null;

    // 占位文本
    Widget? placeholder = controller.text.isEmpty &&
            hasFocus == false &&
            widget.placeholder != null
        ? Align(
            alignment: Alignment.centerLeft,
            child: TextWidget.body(
              widget.placeholder!,
              color: AppTheme.color999,
              size: 28.sp,
            ),
          )
        : null;

    // 输入区域
    Widget inputArea = Stack(
      children: [
        if (placeholder != null)
          Positioned(
            left: 0,
            top: -1,
            child: Center(child: placeholder),
          ),
        EditableText(
          controller: controller,
          focusNode: focusNode,
          readOnly: widget.readOnly ?? false,
          style: currentStyle.toTextStyle(),
          cursorColor: AppTheme.colorfff,
          backgroundCursorColor: Colors.transparent,
          onTapOutside: (tapOutside) {
            focusNode.unfocus();
          },
          onChanged: (value) {
            setState(() {
              showClean = value.isNotEmpty;
            });
            widget.onChanged?.call(value);
          },
          keyboardType: widget.keyboardType,
          autofocus: widget.autofocus ?? false,
          maxLines: widget.maxLines,
          textAlign: TextAlign.left,
          textDirection: TextDirection.ltr,
          textWidthBasis: TextWidthBasis.parent,
          textHeightBehavior: const TextHeightBehavior(
            applyHeightToFirstAscent: true,
            applyHeightToLastDescent: true,
          ),
          strutStyle: StrutStyle(
            fontSize: currentStyle.fontSize ?? 28.sp,
          ),
          textCapitalization: TextCapitalization.none,
          enableInteractiveSelection: true,
          expands: false,
          showCursor: true,
        ),
        if (cleanButton != null)
          Positioned(
            right: 0,
            top: 0,
            bottom: 0,
            child: Center(child: cleanButton),
          ),
      ],
    );

    // 返回
    return Container(
      padding: const EdgeInsets.all(0),
      decoration: const BoxDecoration(
        color: Colors.transparent,
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
        decoration: const BoxDecoration(
          color: Colors.transparent,
        ),
        child: <Widget>[
          if (prefix != null) prefix!,
          Expanded(child: inputArea),
          if (suffix != null)
            Padding(
              padding: const EdgeInsets.only(left: 0),
              child: suffix!,
            ),
        ].toRowSpace(
          space: 25.w,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildView();
  }
}
