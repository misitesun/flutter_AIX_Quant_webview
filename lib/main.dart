import 'dart:async';

import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:XSmartPay/global.dart';
import 'package:ducafe_ui_core/ducafe_ui_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'common/index.dart';

// Future<void> main() async {
//   await Global.init();
//   runApp(const MyApp());
// }
Future<void> main() async {
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();

    // 添加错误捕获
    FlutterError.onError = (FlutterErrorDetails details) {
      print('Flutter Error: ${details.exception}');
      print('Stack trace: ${details.stack}');
      // 记录错误但不让应用崩溃
    };

    try {
      await Global.init();
      runApp(const MyApp());
    } catch (e) {
      print('应用初始化失败: $e');
      // 即使初始化失败，也要启动应用
      runApp(const MyApp());
    }
  }, (error, stackTrace) {
    print('Dart Error: $error');
    print('Stack trace: $stackTrace');
    // 记录错误但不让应用崩溃
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: const Size(750, 1624), // 设计稿中设备的尺寸(单位随意,建议dp,但在使用过程中必须保持一致)
        splitScreenMode: false, // 支持分屏尺寸
        minTextAdapt: false, // 是否根据宽度/高度中的最小值适配文字
        builder: (context, child) => AdaptiveTheme(
            // 样式
            light: AppTheme.light, // 亮色主题
            dark: AppTheme.dark, // 暗色主题
            initial: ConfigService.to.themeMode, // 初始主题
            debugShowFloatingThemeButton: false, // 显示主题按钮

            builder: (theme, darkTheme) {
              return RefreshConfiguration(
                  headerBuilder: () => const ClassicHeader(), // 自定义刷新头部
                  footerBuilder: () => const ClassicFooter(), // 自定义刷新尾部
                  hideFooterWhenNotFull: true, // 当列表不满一页时,是否隐藏刷新尾部
                  headerTriggerDistance: 80, // 触发刷新的距离
                  maxOverScrollExtent: 100, // 最大的拖动距离
                  footerTriggerDistance: 150, // 触发加载的距离
                  child: GetMaterialApp(
                    debugShowCheckedModeBanner: false,
                    title: 'AIX-Quant',

                    // 主题
                    theme: theme,
                    darkTheme: darkTheme,

                    // 路由
                    initialRoute: '/startPage', // 默认启动页
                    getPages: RoutePages.list,
                    navigatorObservers: [RoutePages.observer],
                    defaultTransition: Transition.rightToLeft,

                    // 多语言
                    translations: Translation(), // 词典
                    localizationsDelegates:
                        Translation.localizationsDelegates, // 代理
                    supportedLocales: Translation.supportedLocales, // 支持的语言种类
                    locale: ConfigService.to.locale, // 当前语言种类
                    fallbackLocale: Translation.fallbackLocale, // 默认语言种类

                    builder: (context, widget) {
                      widget = EasyLoading.init()(
                          context, widget); // EasyLoading 初始化
                      // 不随系统字体缩放比例
                      return MediaQuery(
                        data: MediaQuery.of(context)
                            .copyWith(textScaler: const TextScaler.linear(1.0)),
                        child: widget,
                      );
                    },
                  ));
            }));
  }
}
