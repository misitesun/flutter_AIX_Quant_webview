import 'package:XSmartPay/common/index.dart';

class HomeMarkets {
  int? id;
  String? coin1;
  String? coin2;
  String? logo;
  String? symbol;

  HomeMarkets({this.id, this.coin1, this.coin2, this.logo, this.symbol});

  factory HomeMarkets.fromJson(Map<String, dynamic> json) => HomeMarkets(
        id: DataUtils.toInt(json['id']),
        coin1: DataUtils.toStr(json['coin1']),
        coin2: DataUtils.toStr(json['coin2']),
        logo: DataUtils.toStr(json['logo']),
        symbol: DataUtils.toStr(json['symbol']),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'coin1': coin1,
        'coin2': coin2,
        'logo': logo,
        'symbol': symbol,
      };
}
