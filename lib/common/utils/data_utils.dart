class DataUtils {
  /// 将任意值转换为int类型
  static int? toInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is double) return value.toInt();
    if (value is String) {
      return int.tryParse(value.replaceAll(RegExp(r'[^0-9-]'), ''));
    }
    return null;
  }

  /// 将任意值转换为double类型
  static double? toDouble(dynamic value) {
    if (value == null) return null;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) {
      return double.tryParse(value.replaceAll(RegExp(r'[^0-9.-]'), ''));
    }
    return null;
  }

  /// 将任意值转换为String类型
  static String? toStr(dynamic value) {
    // 改名为 toStr
    if (value == null) return null;
    return value.toString();
  }

  /// 将任意值转换为bool类型
  static bool? toBool(dynamic value) {
    if (value == null) return null;
    if (value is bool) return value;
    if (value is int) return value != 0;
    if (value is String) {
      value = value.toLowerCase().trim();
      if (value == 'true' || value == '1') return true;
      if (value == 'false' || value == '0') return false;
    }
    return null;
  }

  /// 检查字符串是否有效（非空且长度大于0）
  static bool isValidString(dynamic value) {
    return toStr(value)?.isNotEmpty == true;
  }

  /// 截取地址/字符串，保留头尾，显示  0xff****hide
  static String formatAddress(String? address,
      {int prefixLength = 4, int suffixLength = 4}) {
    if (address == null || address.isEmpty) return '';
    if (address.length <= prefixLength + suffixLength) return address;

    String prefix = address.substring(0, prefixLength);
    String suffix = address.substring(address.length - suffixLength);
    return '$prefix****$suffix';
  }

  /// 格式化数字为固定小数位，不进行四舍五入
  /// [value] 需要格式化的数值
  /// [places] 小数位数，默认2位
  static String formatNumber(dynamic value, {int places = 2}) {
    if (value == null) return '0.${List.filled(places, '0').join()}';

    // 转换为字符串
    String numStr = value.toString();

    // 如果包含小数点
    if (numStr.contains('.')) {
      List<String> parts = numStr.split('.');
      String intPart = parts[0];
      String decimalPart = parts[1];

      // 如果小数部分长度超过指定位数，直接截取
      if (decimalPart.length > places) {
        decimalPart = decimalPart.substring(0, places);
      }
      // 如果小数部分长度不足指定位数，补0
      else if (decimalPart.length < places) {
        decimalPart = decimalPart.padRight(places, '0');
      }

      return '$intPart.$decimalPart';
    }
    // 如果是整数
    else {
      return '$numStr.${'0' * places}';
    }
  }
}
