import 'package:ducafe_ui_core/ducafe_ui_core.dart';
import 'package:flutter/cupertino.dart';

import '../index.dart';

/// 数量编辑
class QuantityWidget extends StatelessWidget {
  // 数量发送改变
  final Function(int quantity) onChange;
  // 数量
  final int quantity;

  const QuantityWidget({
    super.key,
    required this.quantity,
    required this.onChange,
  });

  @override
  Widget build(BuildContext context) {
    return <Widget>[
      // 减号
      <Widget>[
        Icon(
          CupertinoIcons.minus,
          size: 32.w,
          color: const Color(0xff000000),
        ),
      ]
          .toRow(mainAxisAlignment: MainAxisAlignment.center)
          .card(
              color: const Color(0xfff8f8f8),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.w)))
          .tight(width: 56.w, height: 56.w)
          .onTap(() => onChange(quantity - 1 < 0 ? 0 : quantity - 1)),

      // 数量
      TextWidget.body(
        "$quantity",
        size: 24.sp,
        weight: FontWeight.w600,
      ).center().tight(width: 68.w, height: 56.w),

      // 加号
      <Widget>[
        Icon(
          CupertinoIcons.plus,
          size: 32.w,
          color: const Color(0xff000000),
        ),
      ]
          .toRow(mainAxisAlignment: MainAxisAlignment.center)
          .card(
              color: const Color(0xfff8f8f8),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.w)))
          .tight(width: 56.w, height: 56.w)
          .onTap(() => onChange(quantity + 1)),
    ].toRow(mainAxisAlignment: MainAxisAlignment.spaceBetween);
  }
}
