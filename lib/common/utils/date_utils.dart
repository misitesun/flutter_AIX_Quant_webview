import 'package:intl/intl.dart';

class DateUtils {
  // 年月日时分
  static String formatYMDHM(DateTime? dateTime) {
    if (dateTime == null) return '';
    return DateFormat('yyyy-MM-dd HH:mm').format(dateTime);
  }

  // 年月日时分秒
  static String formatYMDHMS(DateTime? dateTime) {
    if (dateTime == null) return '';
    return DateFormat('yyyy-MM-dd HH:mm:ss').format(dateTime);
  }

  // 年月日
  static String formatYMD(DateTime? dateTime) {
    if (dateTime == null) return '';
    return DateFormat('yyyy-MM-dd').format(dateTime);
  }

  // 时分
  static String formatHM(DateTime? dateTime) {
    if (dateTime == null) return '';
    return DateFormat('HH:mm').format(dateTime);
  }

  // 获取当前时间
  static String getCurrentTime() {
    return formatYMDHM(DateTime.now());
  }
}
