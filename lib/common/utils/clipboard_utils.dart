import 'package:clipboard/clipboard.dart';
import 'package:XSmartPay/common/index.dart';
import 'package:get/get.dart';

/// 剪贴板工具类
/* 使用示例
ClipboardUtils.copy('复制内容');
ClipboardUtils.paste();
*/
class ClipboardUtils {
  /// 复制文本到剪贴板
  static Future<void> copy(String text, {String? toastMsg}) async {
    try {
      await FlutterClipboard.copy(text);
      // 显示复制成功提示，如果有自定义提示消息则使用自定义消息
      Loading.success(toastMsg ?? '复制成功'.tr);
    } catch (e) {
      Loading.error('复制失败'.tr);
    }
  }

  /// 从剪贴板获取文本
  static Future<String> paste() async {
    try {
      final String value = await FlutterClipboard.paste();
      return value;
    } catch (e) {
      Loading.error('获取剪贴板内容失败'.tr);
      return '';
    }
  }
}
