// To parse this JSON data, do
//
//     final instantTradeModel = instantTradeModelFromJson(jsonString);

import 'dart:convert';

InstantTradeModel instantTradeModelFromJson(String str) => InstantTradeModel.fromJson(json.decode(str));

String instantTradeModelToJson(InstantTradeModel data) => json.encode(data.toJson());

class InstantTradeModel {
  InstantTradeModel({
    this.message,
    this.statusCode,
    this.data,
  });

  String? message;
  int? statusCode;
  InstantTradeData? data;

  factory InstantTradeModel.fromJson(Map<String, dynamic> json) => InstantTradeModel(
    message: json["message"],
    statusCode: json["status_code"],
    data:json["data"]==null||json["data"]==[]?null: InstantTradeData.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "status_code": statusCode,
    "data": data!.toJson(),
  };
}

class InstantTradeData {
  InstantTradeData({
    this.userId,
    this.tradePairId,
    this.tradeType,
    this.ouid,
    this.symbol,
    this.orderId,
    this.pair,
    this.orderType,
    this.price,
    this.volume,
    this.value,
    this.fees,
    this.commission,
    this.remaining,
    this.stoplimit,
    this.status,
    this.completedStatus,
    this.priceperunit,
    this.leverage,
    this.marketWallet,
    this.baseWallet,
    this.tradeLogic,
    this.convertPrice,
    this.tradeMode,
    this.id,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  String? userId;
  String? tradePairId;
  String? tradeType;
  dynamic ouid;
  dynamic symbol;
  String? orderId;
  String? pair;
  String? orderType;
  dynamic price;
  dynamic volume;
  dynamic value;
  dynamic fees;
  dynamic commission;
  dynamic remaining;
  dynamic stoplimit;
  String? status;
  bool? completedStatus;
  dynamic priceperunit;
  dynamic leverage;
  String? marketWallet;
  String? baseWallet;
  int? tradeLogic;
  dynamic convertPrice;
  int? tradeMode;
  String? id;
  String? createdAt;
  String? updatedAt;
  int? v;

  factory InstantTradeData.fromJson(Map<String, dynamic> json) => InstantTradeData(
    userId: json["user_id"],
    tradePairId: json["trade_pair_id"],
    tradeType: json["trade_type"],
    ouid: json["ouid"],
    symbol: json["symbol"],
    orderId: json["order_id"],
    pair: json["pair"],
    orderType: json["order_type"],
    price: json["price"],
    volume: json["volume"],
    value: json["value"],
    fees: json["fees"],
    commission: json["commission"],
    remaining: json["remaining"],
    stoplimit: json["stoplimit"],
    status: json["status"],
    completedStatus: json["completed_status"],
    priceperunit: json["priceperunit"],
    leverage: json["leverage"],
    marketWallet: json["market_wallet"],
    baseWallet: json["base_wallet"],
    tradeLogic: json["trade_logic"],
    convertPrice: json["convert_price"],
    tradeMode: json["trade_mode"],
    id: json["_id"],
    createdAt: json["createdAt"],
    updatedAt: json["updatedAt"],
    v: json["__v"],
  );

  Map<String, dynamic> toJson() => {
    "user_id": userId,
    "trade_pair_id": tradePairId,
    "trade_type": tradeType,
    "ouid": ouid,
    "symbol": symbol,
    "order_id": orderId,
    "pair": pair,
    "order_type": orderType,
    "price": price,
    "volume": volume,
    "value": value,
    "fees": fees,
    "commission": commission,
    "remaining": remaining,
    "stoplimit": stoplimit,
    "status": status,
    "completed_status": completedStatus,
    "priceperunit": priceperunit,
    "leverage": leverage,
    "market_wallet": marketWallet,
    "base_wallet": baseWallet,
    "trade_logic": tradeLogic,
    "convert_price": convertPrice,
    "trade_mode": tradeMode,
    "_id": id,
    "createdAt": createdAt,
    "updatedAt": updatedAt,
    "__v": v,
  };
}
