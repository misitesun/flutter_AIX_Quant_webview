import 'package:XSmartPay/common/index.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';

class XSmartPayWebViewController extends GetxController {
  late final WebViewController webViewController;

  @override
  void onInit() {
    super.onInit();
    webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(AppTheme.pageBgColor)
      ..loadRequest(Uri.parse(Constants.xspayUrl));
  }

  @override
  void onClose() {
    webViewController.clearCache();
    super.onClose();
  }
}
