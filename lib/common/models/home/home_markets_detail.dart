import 'package:XSmartPay/common/index.dart';

class HomeMarketsDetail {
  int? id;
  String? coin1;
  String? coin2;
  String? logo;
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

  HomeMarketsDetail({
    this.id,
    this.coin1,
    this.coin2,
    this.logo,
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

  factory HomeMarketsDetail.fromJson(Map<String, dynamic> json) {
    return HomeMarketsDetail(
      id: DataUtils.toInt(json['id']),
      coin1: DataUtils.toStr(json['coin1']),
      coin2: DataUtils.toStr(json['coin2']),
      logo: DataUtils.toStr(json['logo']),
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
        'id': id,
        'coin1': coin1,
        'coin2': coin2,
        'logo': logo,
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

  HomeMarketsDetail copyWith({
    int? id,
    String? coin1,
    String? coin2,
    String? logo,
    String? symbol,
    String? priceChange,
    String? priceChangePercent,
    String? weightedAvgPrice,
    String? prevClosePrice,
    String? lastPrice,
    String? lastQty,
    String? bidPrice,
    String? bidQty,
    String? askPrice,
    String? askQty,
    String? openPrice,
    String? highPrice,
    String? lowPrice,
    String? volume,
    String? quoteVolume,
    int? openTime,
    int? closeTime,
    int? firstId,
    int? lastId,
    int? count,
  }) {
    return HomeMarketsDetail(
      id: id ?? this.id,
      coin1: coin1 ?? this.coin1,
      coin2: coin2 ?? this.coin2,
      logo: logo ?? this.logo,
      symbol: symbol ?? this.symbol,
      priceChange: priceChange ?? this.priceChange,
      priceChangePercent: priceChangePercent ?? this.priceChangePercent,
      weightedAvgPrice: weightedAvgPrice ?? this.weightedAvgPrice,
      prevClosePrice: prevClosePrice ?? this.prevClosePrice,
      lastPrice: lastPrice ?? this.lastPrice,
      lastQty: lastQty ?? this.lastQty,
      bidPrice: bidPrice ?? this.bidPrice,
      bidQty: bidQty ?? this.bidQty,
      askPrice: askPrice ?? this.askPrice,
      askQty: askQty ?? this.askQty,
      openPrice: openPrice ?? this.openPrice,
      highPrice: highPrice ?? this.highPrice,
      lowPrice: lowPrice ?? this.lowPrice,
      volume: volume ?? this.volume,
      quoteVolume: quoteVolume ?? this.quoteVolume,
      openTime: openTime ?? this.openTime,
      closeTime: closeTime ?? this.closeTime,
      firstId: firstId ?? this.firstId,
      lastId: lastId ?? this.lastId,
      count: count ?? this.count,
    );
  }
}
