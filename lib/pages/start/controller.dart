import 'package:XSmartPay/common/index.dart';
import 'package:get/get.dart';

class StartController extends GetxController {
  StartController();

  _jumpToPage() {
    // 延迟1秒
    Future.delayed(const Duration(seconds: 1)).then((_) {
      // 第一次打开app，标记已打开
      ConfigService().setAlreadyOpen();
      Get.offAllNamed('/webviewPage');
    });
  }

  _initData() {
    update(["start"]);
    _jumpToPage();
  }

  @override
  void onReady() {
    super.onReady();
    _initData();
  }
}
