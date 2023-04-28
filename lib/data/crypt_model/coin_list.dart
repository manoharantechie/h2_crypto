// To parse this JSON data, do
//
//     final coinListModel = coinListModelFromJson(jsonString);

import 'dart:convert';

CoinListModel coinListModelFromJson(String str) => CoinListModel.fromJson(json.decode(str));

String coinListModelToJson(CoinListModel data) => json.encode(data.toJson());

class CoinListModel {
  bool? success;
  List<CoinList>? result;
  String? message;

  CoinListModel({
    this.success,
    this.result,
    this.message,
  });

  factory CoinListModel.fromJson(Map<String, dynamic> json) => CoinListModel(
    success: json["success"],
    result: List<CoinList>.from(json["result"].map((x) => CoinList.fromJson(x))),
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "result": List<dynamic>.from(result!.map((x) => x.toJson())),
    "message": message,
  };
}

class CoinList {
  String? tradePair;
  String? symbol;
  String? baseAsset;
  dynamic marketAsset;
  String? hrVolume;
  String? currentPrice;
  String? hrExchange;
  int? coinoneDecimal;
  int? cointwoDecimal;

  CoinList({
    this.tradePair,
    this.symbol,
    this.baseAsset,
    this.marketAsset,
    this.hrVolume,
    this.currentPrice,
    this.hrExchange,
    this.coinoneDecimal,
    this.cointwoDecimal,
  });

  factory CoinList.fromJson(Map<String, dynamic> json) => CoinList(
    tradePair: json["trade_pair"],
    symbol: json["symbol"],
    baseAsset: json["base_asset"],
    marketAsset: json["market_asset"],
    hrVolume: json["hr_volume"],
    currentPrice: json["current_price"],
    hrExchange: json["hr_exchange"],
    coinoneDecimal: json["coinone_decimal"],
    cointwoDecimal: json["cointwo_decimal"],
  );

  Map<String, dynamic> toJson() => {
    "trade_pair": tradePair,
    "symbol": symbol,
    "base_asset": baseAsset,
    "market_asset":marketAsset,
    "hr_volume": hrVolume,
    "current_price": currentPrice,
    "hr_exchange": hrExchange,
    "coinone_decimal": coinoneDecimal,
    "cointwo_decimal": cointwoDecimal,
  };
}


