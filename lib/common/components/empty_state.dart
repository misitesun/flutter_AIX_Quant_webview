import 'package:ducafe_ui_core/ducafe_ui_core.dart';
import 'package:flutter/material.dart';

class EmptyWidget extends StatelessWidget {
  final String? message;
  final String? imagePath;
  final double? imageWidth;
  final double? imageHeight;
  final VoidCallback? onTap;
  final Widget? customButton;

  const EmptyWidget({
    super.key,
    this.message = '暂无数据',
    this.imagePath = 'assets/img/nodata.png',
    this.imageWidth = 350,
    this.imageHeight = 241,
    this.onTap,
    this.customButton,
  });

  // 预定义的空状态类型
  factory EmptyWidget.cart() {
    return const EmptyWidget(
      message: '购物车空空如也',
      imagePath: 'assets/img/nodata.png',
    );
  }

  factory EmptyWidget.order() {
    return const EmptyWidget(
      message: '暂无订单数据',
      imagePath: 'assets/img/nodata.png',
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              imagePath!,
              width: imageWidth!.w,
              height: imageHeight!.w,
              fit: BoxFit.contain,
            ),
            SizedBox(height: 20.w),
            Text(
              message!,
              style: TextStyle(
                fontSize: 24.sp,
                color: Colors.grey,
              ),
            ),
            if (customButton != null) ...[
              SizedBox(height: 20.w),
              customButton!,
            ],
          ],
        ),
      ),
    );
  }
}
