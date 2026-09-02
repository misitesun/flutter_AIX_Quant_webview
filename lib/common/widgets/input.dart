import 'package:ducafe_ui_core/ducafe_ui_core.dart';
import 'package:flutter/material.dart';

import '../index.dart';

class InputWidget extends StatefulWidget {
  const InputWidget({
    super.key,
    this.controller,
    this.placeholder,
    this.prefix,
    this.suffix,
    this.obscureText = false,
    this.cleanable = true,
    this.readOnly = false,
    this.onChanged,
    this.onBlur,
    this.keyboardType,
    this.autofocus,
    this.style,
    this.padding,
    this.textAlign,
    // required this.focusNode,
    // required this.style,
    // required this.cursorColor,
    // required this.backgroundCursorColor,
  });

  /// 输入框控制器
  final TextEditingController? controller;

  /// 占位符
  final String? placeholder;

  /// 前缀
  final Widget? prefix;

  /// 后缀
  final Widget? suffix;

  /// 是否隐藏文本
  final bool? obscureText;

  /// 是否可清空
  final bool? cleanable;

  /// 是否只读
  final bool? readOnly;

  /// 输入变化回调
  final Function(String)? onChanged;

  /// 失去焦点回调
  final VoidCallback? onBlur;

  /// 输入法类型
  final TextInputType? keyboardType;

  /// 自动焦点
  final bool? autofocus;

  /// 输入框文本样式
  final TextStyle? style;

  /// 自定义内边距
  final EdgeInsetsGeometry? padding;

  /// 输入框文本对齐方式
  final TextAlign? textAlign;

  // final FocusNode focusNode;
  // final TextStyle style;
  // final Color cursorColor;
  // final Color backgroundCursorColor;

  @override
  State<InputWidget> createState() => _InputWidgetState();
}

class _InputWidgetState extends State<InputWidget> {
  late TextEditingController controller;
  FocusNode focusNode = FocusNode();
  bool? hasFocus;
  bool? showPassword = false;
  bool showClean = false;

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
  }

  // 监听是否失去焦点
  void _onFocusChange() {
    setState(() {
      hasFocus = focusNode.hasFocus;
    });
    if (!focusNode.hasFocus) {
      widget.onBlur?.call();
    }
  }

  Widget _buildView() {
    // 显示密码按钮
    if (widget.obscureText == true) {
      suffix = Icon(
        showPassword == true ? Icons.visibility : Icons.visibility_off,
        size: 20,
        color: AppTheme.color999,
      ).ripple().clipOval().gestures(
            onTap: () => setState(() {
              showPassword = !showPassword!;
            }),
          );
    }

    // 清除按钮
    Widget? cleanButton = widget.cleanable == true && showClean == true
        ? const Icon(
            Icons.cancel,
            size: 20,
            color: AppTheme.color999,
          ).onTap(() {
            controller.clear();
            setState(() {
              showClean = false;
            });
            widget.onChanged?.call("");
          })
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
          ).height(80.w)
        : null;

    // 2 输入框
    Widget textField = TextField(
      textAlign: widget.textAlign ?? TextAlign.start,
      controller: controller,
      focusNode: focusNode,
      readOnly: widget.readOnly ?? false,
      style: widget.style ??
          TextStyle(
            color: AppTheme.colorfff,
            fontSize: 28.sp,
          ),
      cursorColor: AppTheme.colorfff,
      // backgroundCursorColor: Colors.transparent,
      onTapOutside: (tapOutside) {
        focusNode.unfocus();
      },
      obscureText: widget.obscureText == true && showPassword == false,
      onChanged: (value) {
        setState(() {
          showClean = value.isNotEmpty;
        });
        widget.onChanged?.call(value);
      },
      keyboardType: widget.keyboardType,
      autofocus: widget.autofocus ?? false,
      maxLines: 1, // 限制为单行
      textAlignVertical: TextAlignVertical.center,
      decoration: const InputDecoration(
        border: InputBorder.none, // 去掉默认边框
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.transparent, width: 1), // 灰色线
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.transparent, width: 2), // 红色线
        ),
        contentPadding: EdgeInsets.only(bottom: 14),
      ),
    ).height(80.w);

    // 输入区域
    Widget inputArea = Stack(
      children: [
        // if (placeholder != null) Positioned.fill(child: placeholder),
        if (placeholder != null)
          Positioned(
            left: 0,
            top: 0,
            child: Center(child: placeholder),
          ),
        textField.padding(right: 0),
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
      padding: widget.padding ?? const EdgeInsets.all(0),
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
