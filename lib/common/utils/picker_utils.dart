import 'package:bottom_picker/bottom_picker.dart';
import 'package:ducafe_ui_core/ducafe_ui_core.dart';
import 'package:flutter/material.dart';
import 'package:XSmartPay/common/index.dart';
import 'package:get/get.dart';

/// 选择器工具类
/* 使用示例
PickerUtils.showPicker(
  context: context,
  title: '选择图片',
  items: [
    {'id': 1, 'name': 'USDT'},
    {'id': 2, 'name': 'BTC'},
    {'id': 3, 'name': 'ETH'},
  ],
  onConfirm: (item) {},
  onCancel: () {},
);
*/
class PickerUtils {
  /// 底部单列选择器
  /// [context] 上下文
  /// [title] 选择器标题
  /// [items] 数据列表 [{'id': 1, 'name': '选项1', 'icon': Image对象(可选)}]
  /// [alignment] 选项对齐方式，默认居中对齐
  /// [onConfirm] 确认回调 返回选中项
  /// [onCancel] 取消回调
  static void showPicker({
    required BuildContext context,
    required String title,
    required List<Map<String, dynamic>> items,
    required Function(Map<String, dynamic>) onConfirm,
    required Function() onCancel,
    MainAxisAlignment alignment = MainAxisAlignment.center,
  }) {
    BottomPicker(
      pickerTitle: TextWidget.body(
        title,
        weight: FontWeight.w600,
        size: 30.sp,
        color: AppTheme.colorfff,
      ),
      items: items
          .map(
            (item) => Container(
              padding: EdgeInsets.symmetric(horizontal: 30.w),
              width: double.infinity,
              child: Row(
                mainAxisAlignment: alignment,
                children: [
                  if (item['icon'] != null) ...[
                    SizedBox(
                      width: 40.w,
                      height: 40.w,
                      child: item['icon'],
                    ),
                    SizedBox(width: 10.w),
                  ],
                  TextWidget.body(
                    item['name'].toString(),
                    size: 28.sp,
                    color: AppTheme.colorfff,
                  ),
                ],
              ),
            ),
          )
          .toList(),
      buttonPadding: 0,
      buttonWidth: 690.w,
      titleAlignment: Alignment.center,
      backgroundColor: AppTheme.blockBgColor,
      pickerTextStyle: TextStyle(
        fontSize: 28.sp,
        color: AppTheme.colorfff,
      ),
      closeIconColor: AppTheme.colorfff,
      buttonAlignment: MainAxisAlignment.center,
      displaySubmitButton: true,
      buttonContent: <Widget>[
        TextWidget.body(
          '确定'.tr,
          weight: FontWeight.w600,
          size: 26.sp,
          color: Colors.black,
        ),
      ]
          .toRow(mainAxisAlignment: MainAxisAlignment.center)
          .card(
              color: AppTheme.primary,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.w)))
          .tight(
            height: 80.w,
          ),
      buttonStyle: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(44.w),
      ),
      onSubmit: (index) {
        onConfirm(items[index]);
      },
    ).show(context);
  }
}
