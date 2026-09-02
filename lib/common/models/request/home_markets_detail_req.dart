import 'package:XSmartPay/common/index.dart';

class HomeMarketsDetailReq {
  String? symbols; // 币种ID

  HomeMarketsDetailReq({
    this.symbols,
  });

  factory HomeMarketsDetailReq.fromJson(Map<String, dynamic> json) {
    return HomeMarketsDetailReq(
      symbols: DataUtils.toStr(json['symbols']),
    );
  }

  Map<String, dynamic> toJson() => {
        'symbols': symbols,
      };
}
