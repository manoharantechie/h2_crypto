// To parse this JSON data, do
//
//     final allOpenOrderModel = allOpenOrderModelFromJson(jsonString);

import 'dart:convert';

AllOpenOrderModel allOpenOrderModelFromJson(String str) => AllOpenOrderModel.fromJson(json.decode(str));

String allOpenOrderModelToJson(AllOpenOrderModel data) => json.encode(data.toJson());

class AllOpenOrderModel {
  AllOpenOrderModel({
    this.message,
    this.statusCode,
    this.data,
  });

  String? message;
  int? statusCode;
  List<AllOpenOrderList>? data;

  factory AllOpenOrderModel.fromJson(Map<String, dynamic> json) => AllOpenOrderModel(
    message: json["message"],
    statusCode: json["status_code"],
    data:  List<AllOpenOrderList>.from(json["data"].map((x) => AllOpenOrderList.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "status_code": statusCode,
    "data": List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class AllOpenOrderList {
  AllOpenOrderList({
    this.id,
    this.userId,
    this.tradePairId,
    this.tradeType,
    this.ouid,
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
    this.priceperunit,
    this.leverage,
    this.tradeMode,
    this.createdAt,
    this.updatedAt,
    this.pairSymbol,
  });

  String? id;
  String? userId;
  String? tradePairId;
  String? tradeType;
  dynamic ouid;
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
  dynamic priceperunit;
  dynamic leverage;
  int? tradeMode;
  DateTime? createdAt;
  String? updatedAt;
  String? pairSymbol;

  factory AllOpenOrderList.fromJson(Map<String, dynamic> json) => AllOpenOrderList(
    id: json["_id"],
    userId: json["user_id"],
    tradePairId: json["trade_pair_id"],
    tradeType: json["trade_type"],
    ouid: json["ouid"],
    orderId: json["order_id"],
    pair: json["pair"],
    orderType:json["order_type"],
    price: json["price"].toDouble(),
    volume: json["volume"].toDouble(),
    value: json["value"].toDouble(),
    fees: json["fees"].toDouble(),
    commission: json["commission"],
    remaining: json["remaining"].toDouble(),
    stoplimit: json["stoplimit"].toDouble(),
    status:json["status"],
    priceperunit: json["priceperunit"],
    leverage: json["leverage"],
    tradeMode: json["trade_mode"],
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: json["updatedAt"],
    pairSymbol: json["pair_symbol"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "user_id": userId,
    "trade_pair_id": tradePairId,
    "trade_type": tradeType,
    "ouid": ouid,
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
    "priceperunit": priceperunit,
    "leverage": leverage,
    "trade_mode": tradeMode,
    "createdAt": createdAt!.toIso8601String(),
    "updatedAt": updatedAt,
    "pair_symbol": pairSymbol,
  };
}


