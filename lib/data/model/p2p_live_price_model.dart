// To parse this JSON data, do
//
//     final p2PLivePriceModel = p2PLivePriceModelFromJson(jsonString);

import 'dart:convert';

P2PLivePriceModel p2PLivePriceModelFromJson(String str) => P2PLivePriceModel.fromJson(json.decode(str));

String p2PLivePriceModelToJson(P2PLivePriceModel data) => json.encode(data.toJson());

class P2PLivePriceModel {
  P2PLivePriceModel({
    this.message,
    this.statusCode,
    this.data,
  });

  String? message;
  int? statusCode;
  P2PLivePrice? data;

  factory P2PLivePriceModel.fromJson(Map<String, dynamic> json) => P2PLivePriceModel(
    message: json["message"],
    statusCode: json["status_code"],
    data: P2PLivePrice.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "status_code": statusCode,
    "data": data!.toJson(),
  };
}

class P2PLivePrice {
  P2PLivePrice({
    this.symbol,
    this.baseAsset,
    this.quoteAsset,
    this.openPrice,
    this.lowPrice,
    this.highPrice,
    this.lastPrice,
    this.volume,
    this.bidPrice,
    this.askPrice,
    this.at,
  });

  String? symbol;
  String? baseAsset;
  String? quoteAsset;
  String? openPrice;
  String? lowPrice;
  String? highPrice;
  String? lastPrice;
  String? volume;
  String? bidPrice;
  String? askPrice;
  int? at;

  factory P2PLivePrice.fromJson(Map<String, dynamic> json) => P2PLivePrice(
    symbol: json["symbol"],
    baseAsset: json["baseAsset"],
    quoteAsset: json["quoteAsset"],
    openPrice: json["openPrice"],
    lowPrice: json["lowPrice"],
    highPrice: json["highPrice"],
    lastPrice: json["lastPrice"],
    volume: json["volume"],
    bidPrice: json["bidPrice"],
    askPrice: json["askPrice"],
    at: json["at"],
  );

  Map<String, dynamic> toJson() => {
    "symbol": symbol,
    "baseAsset": baseAsset,
    "quoteAsset": quoteAsset,
    "openPrice": openPrice,
    "lowPrice": lowPrice,
    "highPrice": highPrice,
    "lastPrice": lastPrice,
    "volume": volume,
    "bidPrice": bidPrice,
    "askPrice": askPrice,
    "at": at,
  };
}
