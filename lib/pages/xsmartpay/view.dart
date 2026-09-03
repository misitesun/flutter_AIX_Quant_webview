import 'package:XSmartPay/common/index.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'index.dart';

class XSmartPayWebViewPage extends GetView<XSmartPayWebViewController> {
  const XSmartPayWebViewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<XSmartPayWebViewController>(
      init: XSmartPayWebViewController(),
      builder: (controller) {
        return Scaffold(
          backgroundColor: AppTheme.pageBgColor,
          appBar: AppBar(
            backgroundColor: AppTheme.pageBgColor,
            toolbarHeight: 0,
            elevation: 0,
          ),
          body: SafeArea(
            child: WebViewWidget(controller: controller.webViewController),
          ),
        );
      },
    );
  }
}
