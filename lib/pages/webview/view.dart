import 'package:ducafe_ui_core/ducafe_ui_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:XSmartPay/common/index.dart';
import 'index.dart';

class WebViewPage extends GetView<WebviewController> {
  const WebViewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<WebviewController>(
      init: WebviewController(),
      id: "webView",
      builder: (_) {
        return Scaffold(
          backgroundColor: AppTheme.pageBgColor, // 自定义颜色
          appBar: AppBar(
            backgroundColor: AppTheme.pageBgColor,
            toolbarHeight: 0, // 设置toolbar高度为0
            elevation: 0, // 移除阴影
          ),
          body: SafeArea(
            child: <Widget>[
              WebViewWidget(controller: controller.webViewController),
              // ImgWidget(path: 'assets/img/user.png', width: 100.w, height: 100.w,radius: 50.w,).onTap((){
              //   Get.toNamed('/nodePage');
              // })
              // .positioned(right: 30.w,bottom: 100.w),

              // ImgWidget(path: 'assets/img/user.png', width: 100.w, height: 100.w,radius: 50.w,).onTap((){
              //   controller.downloadImage();
              // })
              // .positioned(left: 30.w,bottom: 100.w),
            ].toStack(),
          ),
        );
      },
    );
  }
}
