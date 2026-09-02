import 'package:XSmartPay/common/index.dart';

class KlineData {
  final double amount;
  final double open;
  final double close;
  final double high;
  final int time;
  final int count;
  final double low;
  final double vol;

  KlineData({
    required this.amount,
    required this.open,
    required this.close,
    required this.high,
    required this.time,
    required this.count,
    required this.low,
    required this.vol,
  });

  factory KlineData.fromJson(List<dynamic> json) {
    return KlineData(
      amount: DataUtils.toDouble(json[5]) ?? 0, // 成交量
      open: DataUtils.toDouble(json[1]) ?? 0, // 开盘价
      close: DataUtils.toDouble(json[4]) ?? 0, // 收盘价
      high: DataUtils.toDouble(json[2]) ?? 0, // 最高价
      time: DataUtils.toInt(json[0]) ?? 0, // 时间
      count: DataUtils.toInt(json[8]) ?? 0, // 笔数
      low: DataUtils.toDouble(json[3]) ?? 0, // 最低价
      vol: DataUtils.toDouble(json[7]) ?? 0, // 24小时成交量
    );
  }

  Map<String, dynamic> toJson() => {
        'amount': amount,
        'open': open,
        'close': close,
        'high': high,
        'time': time,
        'count': count,
        'low': low,
        'vol': vol,
      };
}
