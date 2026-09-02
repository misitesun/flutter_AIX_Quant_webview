import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'index.dart';

/// 语言代码：https://en.wikipedia.org/wiki/List_of_ISO_639_language_codes
/// 中文：zh
/// 繁体中文：zh-TW
/// 英文：en
/// 日文：ja
/// 韩文：ko
/// 泰语：th
/// 越南：vi
/// 印地：hi
/// 印尼：id
/// 俄文：ru
/// 法文：fr
/// 德文：de
/// 意大利文：it
/// 西班牙文：es
/// 葡萄牙文：pt
/// 荷兰文：nl
///
///
/// 国家代码：https://en.wikipedia.org/wiki/List_of_ISO_3166_country_codes
/// 中国：CN
/// 台湾：TW
/// 美国：US
/// 日本：JP
/// 韩国：KR
/// 泰国：TH
/// 越南：VN
/// 印地：IN
/// 印尼：ID
/// 俄罗斯：RU
/// 法国：FR
/// 德国：DE
/// 意大利：IT
/// 西班牙：ES
/// 葡萄牙：PT
/// 荷兰：NL

/// 翻译类
class Translation extends Translations {
  // 当前系统语言
  // static Locale? get locale => Get.deviceLocale;

  // 默认语言 Locale(语言代码, 国家代码)
  static const fallbackLocale = Locale('zh', 'CN');

  // 支持语言列表
  static const supportedLocales = [
    Locale('zh', 'CN'),
    Locale('zh', 'TW'),
    Locale('en', 'US'),
  ];

  // 代理
  static const localizationsDelegates = [
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
  ];

  // 语言代码对应的翻译文本
  @override
  Map<String, Map<String, String>> get keys => {
        'zh_CN': localeZh,
        'zh_TW': localeTw,
        'en_US': localeEn,
      };
}
