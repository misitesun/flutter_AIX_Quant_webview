import 'package:ducafe_ui_core/ducafe_ui_core.dart';
import 'package:flutter/material.dart';
import 'package:XSmartPay/common/index.dart';
import 'package:get/get.dart';

/// 底部操作表
/* 使用示例
ActionSheetUtil.showActionSheet(
  context: context,
  title: '选择图片',
  items: [
    {'id': 1, 'title': '相机', 'type': 'camera'},
  ],
  onConfirm: (item) {},
);
*/
class ActionSheetUtil {
  /// 底部操作表
  /// [context] 上下文
  /// [title] 标题
  /// [items] 选项列表 [{'id': 1, 'title': '相机', 'type': 'camera'}]
  /// [onConfirm] 确认回调 返回选中项
  static void showActionSheet({
    required BuildContext context,
    required String title,
    required List<Map<String, dynamic>> items,
    required Function(Map<String, dynamic>) onConfirm,
  }) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: AppTheme.blockBgColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30.w),
            topRight: Radius.circular(30.w),
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 标题
              Container(
                height: 100.w,
                alignment: Alignment.center,
                child: TextWidget.body(
                  title,
                  size: 30.sp,
                  weight: FontWeight.w600,
                  color: AppTheme.colorfff,
                ),
              ),

              // 选项列表
              ...items.map((item) => GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                      onConfirm(item);
                    },
                    child: Container(
                      height: 100.w,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        border: Border(
                          top: BorderSide(
                            color: AppTheme.dividerColor,
                            width: 1,
                          ),
                        ),
                      ),
                      child: TextWidget.body(
                        item['title'],
                        size: 28.sp,
                        color: AppTheme.colorfff,
                      ),
                    ),
                  )),

              // 间隔
              Container(
                height: 16.w,
                color: AppTheme.dividerColor,
              ),

              // 取消按钮
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  height: 100.w,
                  alignment: Alignment.center,
                  color: Colors.transparent,
                  child: TextWidget.body(
                    '取消'.tr,
                    size: 28.sp,
                    color: AppTheme.colorfff,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
