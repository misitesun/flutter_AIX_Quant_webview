import 'package:XSmartPay/common/index.dart';

class HomeKlineHeadPriceModel {
  String? symbol;
  String? priceChange;
  String? priceChangePercent;
  String? weightedAvgPrice;
  String? prevClosePrice;
  String? lastPrice;
  String? lastQty;
  String? bidPrice;
  String? bidQty;
  String? askPrice;
  String? askQty;
  String? openPrice;
  String? highPrice;
  String? lowPrice;
  String? volume;
  String? quoteVolume;
  int? openTime;
  int? closeTime;
  int? firstId;
  int? lastId;
  int? count;

  HomeKlineHeadPriceModel({
    this.symbol,
    this.priceChange,
    this.priceChangePercent,
    this.weightedAvgPrice,
    this.prevClosePrice,
    this.lastPrice,
    this.lastQty,
    this.bidPrice,
    this.bidQty,
    this.askPrice,
    this.askQty,
    this.openPrice,
    this.highPrice,
    this.lowPrice,
    this.volume,
    this.quoteVolume,
    this.openTime,
    this.closeTime,
    this.firstId,
    this.lastId,
    this.count,
  });

  factory HomeKlineHeadPriceModel.fromJson(Map<String, dynamic> json) {
    return HomeKlineHeadPriceModel(
      symbol: DataUtils.toStr(json['symbol']),
      priceChange: DataUtils.toStr(json['priceChange']),
      priceChangePercent: DataUtils.toStr(json['priceChangePercent']),
      weightedAvgPrice: DataUtils.toStr(json['weightedAvgPrice']),
      prevClosePrice: DataUtils.toStr(json['prevClosePrice']),
      lastPrice: DataUtils.toStr(json['lastPrice']),
      lastQty: DataUtils.toStr(json['lastQty']),
      bidPrice: DataUtils.toStr(json['bidPrice']),
      bidQty: DataUtils.toStr(json['bidQty']),
      askPrice: DataUtils.toStr(json['askPrice']),
      askQty: DataUtils.toStr(json['askQty']),
      openPrice: DataUtils.toStr(json['openPrice']),
      highPrice: DataUtils.toStr(json['highPrice']),
      lowPrice: DataUtils.toStr(json['lowPrice']),
      volume: DataUtils.toStr(json['volume']),
      quoteVolume: DataUtils.toStr(json['quoteVolume']),
      openTime: DataUtils.toInt(json['openTime']),
      closeTime: DataUtils.toInt(json['closeTime']),
      firstId: DataUtils.toInt(json['firstId']),
      lastId: DataUtils.toInt(json['lastId']),
      count: DataUtils.toInt(json['count']),
    );
  }

  Map<String, dynamic> toJson() => {
        'symbol': symbol,
        'priceChange': priceChange,
        'priceChangePercent': priceChangePercent,
        'weightedAvgPrice': weightedAvgPrice,
        'prevClosePrice': prevClosePrice,
        'lastPrice': lastPrice,
        'lastQty': lastQty,
        'bidPrice': bidPrice,
        'bidQty': bidQty,
        'askPrice': askPrice,
        'askQty': askQty,
        'openPrice': openPrice,
        'highPrice': highPrice,
        'lowPrice': lowPrice,
        'volume': volume,
        'quoteVolume': quoteVolume,
        'openTime': openTime,
        'closeTime': closeTime,
        'firstId': firstId,
        'lastId': lastId,
        'count': count,
      };
}
