import 'package:XSmartPay/common/index.dart';

class HomeKlineReq {
  String? symbol;
  String? interval;
  int? limit;

  HomeKlineReq({this.symbol, this.interval, this.limit});

  factory HomeKlineReq.fromJson(Map<String, dynamic> json) => HomeKlineReq(
        symbol: DataUtils.toStr(json['symbol']),
        interval: DataUtils.toStr(json['interval']),
        limit: DataUtils.toInt(json['limit']),
      );

  Map<String, dynamic> toJson() => {
        'symbol': symbol,
        'interval': interval,
        'limit': limit,
      };
}
