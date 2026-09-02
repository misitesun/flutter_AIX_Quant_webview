import 'dart:ui';

import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:XSmartPay/common/index.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';

/// 配置服务
class ConfigService extends GetxService {
  // 这是一个单例写法
  static ConfigService get to => Get.find();

  // 主题变化通知
  final RxBool themeChanged = false.obs;

  // 是否首次打开app
  bool get isAlreadyOpen => Storage().getBool('already_open');
  // 标记已打开app
  void setAlreadyOpen() {
    Storage().setBool('already_open', true);
  }

  // 包信息
  PackageInfo? _platform;
  // 获取包信息
  Future<void> getPlatform() async {
    _platform = await PackageInfo.fromPlatform();
  }

  // 版本号
  String get version => _platform?.version ?? '-';

  // 多语言
  Locale locale = PlatformDispatcher.instance.locale;
  // 初始 语言
  void initLocale() {
    var langCode = Storage().getString(Constants.storageLanguageCode);
    if (langCode.isEmpty) {
      // 如果本地为空，设置个默认的语言
      ConfigService.to.setLanguage(const Locale('zh', 'CN'));
    }
    if (langCode.isEmpty) return;
    var index = Translation.supportedLocales.indexWhere((element) {
      return element.languageCode == langCode;
    });
    if (index < 0) return;
    locale = Translation.supportedLocales[index];
  }

  // 切换 语言
  void setLanguage(Locale value) {
    locale = value;
    Get.updateLocale(value);
    Storage().setString(Constants.storageLanguageCode, value.languageCode);
  }

  // 主题
  AdaptiveThemeMode themeMode = AdaptiveThemeMode.dark;
  // 初始 主题
  Future<void> initTheme() async {
    final savedThemeMode = await AdaptiveTheme.getThemeMode();
    themeMode = savedThemeMode ?? AdaptiveThemeMode.dark;
  }

  // 切换 主题
  Future<void> setThemeMode(String themeKey) async {
    // 保存之前，先更新本地变量
    switch (themeKey) {
      case "light":
        themeMode = AdaptiveThemeMode.light;
        AdaptiveTheme.of(Get.context!).setLight();
        break;
      case "dark":
        themeMode = AdaptiveThemeMode.dark;
        AdaptiveTheme.of(Get.context!).setDark();
        break;
      case "system":
        themeMode = AdaptiveThemeMode.system;
        AdaptiveTheme.of(Get.context!).setSystem();
        break;
    }

    // 设置系统样式
    AppTheme.setSystemStyle();

    // 添加一个主题变化通知
    themeChanged.toggle();

    // 强制刷新整个应用
    Get.forceAppUpdate();
  }

  // 集中初始化
  Future<ConfigService> init() async {
    await getPlatform();
    await initTheme();
    initLocale();
    return this;
  }
}
