// To parse this JSON data, do
//
//     final marginTradeModel = marginTradeModelFromJson(jsonString);

import 'dart:convert';

MarginTradeModel marginTradeModelFromJson(String str) => MarginTradeModel.fromJson(json.decode(str));

String marginTradeModelToJson(MarginTradeModel data) => json.encode(data.toJson());

class MarginTradeModel {
  MarginTradeModel({
    this.message,
    this.statusCode,
    /*this.data,*/
  });

  String? message;
  int? statusCode;
 /* Data? data;*/

  factory MarginTradeModel.fromJson(Map<String, dynamic> json) => MarginTradeModel(
    message: json["message"],
    statusCode: json["status_code"],
   /* data: json["data"]==""||json["data"]==null?Data():Data.fromJson(json["data"]),*/
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "status_code": statusCode,
    /*"data": data!.toJson(),*/
  };
}

class Data {
  Data({
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
  int? convertPrice;
  int? tradeMode;
  String? id;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
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
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
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
    "createdAt": createdAt!.toIso8601String(),
    "updatedAt": updatedAt!.toIso8601String(),
    "__v": v,
  };
}
