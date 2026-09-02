import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'common/index.dart';

class Global {
  static Future<void> init() async {
    // 插件初始化
    WidgetsFlutterBinding.ensureInitialized();

    // 工具类
    await Storage().init();
    Loading();

    // 初始化服务
    Get.put<ConfigService>(ConfigService());
    Get.put<WPHttpService>(WPHttpService());
    Get.put<VersionUpdateManager>(VersionUpdateManager());
    // 初始化配置
    await ConfigService.to.init();

    // // 初始化Socket服务
    // await SocketService().init();
    // // 判断是否已登录，如果已登录则连接WebSocket
    // final token = Storage().getString('token');
    // if (token.isNotEmpty) {
    //   SocketService().connect();
    // }
  }
}
