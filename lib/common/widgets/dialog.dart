import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ducafe_ui_core/ducafe_ui_core.dart';
import 'package:XSmartPay/common/index.dart';
/* 
  使用示例：

  DialogWidget.show(
    title: '修改昵称',
    description: '请输入新的昵称',
    // 或者使用自定义内容
    // content: TextField(
    //   decoration: InputDecoration(
    //     hintText: '请输入用户名',
    //   ),
    // ),
    cancelText: '取消',
    confirmText: '确定',
    titleColor: Colors.white,
    descriptionColor: Colors.white,
    cancelButtonColor: Colors.white,
    confirmButtonColor: AppTheme.primary,
    onCancel: () {
      // 取消操作
    },
    onConfirm: () {
      // 确认操作
    },
  );
  
*/

/// 自定义中间弹窗组件
class DialogWidget extends StatelessWidget {
  /// 标题
  final String title;

  /// 简介文本，如果提供了content，则此属性将被忽略
  final String? description;

  /// 简介widget，优先级高于description
  final Widget? content;

  /// 取消按钮文案
  final String cancelText;

  /// 确认按钮文案
  final String confirmText;

  /// 标题文字颜色
  final Color? titleColor;

  /// 简介文字颜色
  final Color? descriptionColor;

  /// 取消按钮颜色
  final Color? cancelButtonColor;

  /// 确认按钮颜色
  final Color? confirmButtonColor;

  /// 取消回调
  final VoidCallback? onCancel;

  /// 确认回调
  final VoidCallback? onConfirm;

  /// 背景颜色
  final Color? backgroundColor;

  /// 弹窗宽度
  final double? width;

  const DialogWidget({
    Key? key,
    required this.title,
    this.description,
    this.content,
    this.cancelText = '取消',
    this.confirmText = '确定',
    this.titleColor,
    this.descriptionColor,
    this.cancelButtonColor,
    this.confirmButtonColor,
    this.onCancel,
    this.onConfirm,
    this.backgroundColor,
    this.width,
  }) : super(key: key);

  /// 显示弹窗
  static Future<T?> show<T>({
    required String title,
    String? description,
    Widget? content,
    String cancelText = '取消',
    String confirmText = '确定',
    Color? titleColor,
    Color? descriptionColor,
    Color? cancelButtonColor,
    Color? confirmButtonColor,
    VoidCallback? onCancel,
    VoidCallback? onConfirm,
    Color? backgroundColor,
    double? width,
    bool barrierDismissible = true,
  }) {
    return showDialog<T>(
      context: Get.context!,
      barrierDismissible: barrierDismissible,
      builder: (context) => DialogWidget(
        title: title,
        description: description,
        content: content,
        cancelText: cancelText,
        confirmText: confirmText,
        titleColor: titleColor,
        descriptionColor: descriptionColor,
        cancelButtonColor: cancelButtonColor,
        confirmButtonColor: confirmButtonColor,
        onCancel: onCancel,
        onConfirm: onConfirm,
        backgroundColor: backgroundColor,
        width: width,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: Container(
        width: width ?? 590.w,
        decoration: BoxDecoration(
          color: backgroundColor ?? AppTheme.blockBgColor,
          borderRadius: BorderRadius.circular(20.w),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 标题
            Padding(
              padding: EdgeInsets.only(top: 30.w),
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 32.sp,
                  fontWeight: FontWeight.bold,
                  color: titleColor ?? AppTheme.colorfff,
                ),
                textAlign: TextAlign.center,
              ),
            ),

            // 内容区域
            Padding(
              padding: EdgeInsets.fromLTRB(30.w, 20.w, 30.w, 30.w),
              child: content ??
                  (description != null
                      ? Text(
                          description!,
                          style: TextStyle(
                            fontSize: 28.sp,
                            color: descriptionColor ?? AppTheme.colorfff,
                          ),
                          textAlign: TextAlign.center,
                        )
                      : null),
            ),

            // 按钮区域
            Container(
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: AppTheme.dividerColor,
                    width: 1,
                  ),
                ),
              ),
              child: Row(
                children: [
                  // 取消按钮
                  Expanded(
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          Navigator.of(context).pop();
                          onCancel?.call();
                        },
                        child: Container(
                          height: 100.w,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            border: Border(
                              right: BorderSide(
                                color: AppTheme.dividerColor,
                                width: 1,
                              ),
                            ),
                          ),
                          child: Text(
                            cancelText.tr,
                            style: TextStyle(
                              fontSize: 28.sp,
                              color: cancelButtonColor ?? AppTheme.colorfff,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  // 确认按钮
                  Expanded(
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          // Navigator.of(context).pop();
                          onConfirm?.call();
                        },
                        child: Container(
                          height: 100.w,
                          alignment: Alignment.center,
                          child: Text(
                            confirmText.tr,
                            style: TextStyle(
                              fontSize: 28.sp,
                              color: confirmButtonColor ?? AppTheme.primary,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
