import 'package:XSmartPay/pages/start/index.dart';
import 'package:XSmartPay/pages/webview/index.dart';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'observers.dart';

class RoutePages {
  static final RouteObserver<Route> observer = RouteObservers();
  static List<String> history = [];
  // 列表
  static List<GetPage> list = [
    ////////////////////////////////////////////////////////////////////////////
    // 启动逻辑页面
    GetPage(
      name: '/startPage', // 启动逻辑页面
      page: () => const StartPage(),
    ),
    GetPage(
      name: '/webviewPage', //
      page: () => const WebViewPage(),
    ),
  ];
}
