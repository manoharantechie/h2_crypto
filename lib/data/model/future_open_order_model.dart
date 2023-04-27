// To parse this JSON data, do
//
//     final futureOpenOrderModel = futureOpenOrderModelFromJson(jsonString);

import 'dart:convert';

FutureOpenOrderModel futureOpenOrderModelFromJson(String str) => FutureOpenOrderModel.fromJson(json.decode(str));

String futureOpenOrderModelToJson(FutureOpenOrderModel data) => json.encode(data.toJson());

class FutureOpenOrderModel {
  FutureOpenOrderModel({
    this.message,
    this.statusCode,
    this.data,
  });

  String? message;
  int? statusCode;
  List<FutureOpenOrderList>? data;

  factory FutureOpenOrderModel.fromJson(Map<String, dynamic> json) => FutureOpenOrderModel(
    message: json["message"],
    statusCode: json["status_code"],
    data: List<FutureOpenOrderList>.from(json["data"].map((x) => FutureOpenOrderList.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "status_code": statusCode,
    "data": List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class FutureOpenOrderList {
  FutureOpenOrderList({
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
  DateTime? createdAt;
  String? updatedAt;
  String? pairSymbol;

  factory FutureOpenOrderList.fromJson(Map<String, dynamic> json) => FutureOpenOrderList(
    id: json["_id"],
    userId: json["user_id"],
    tradePairId: json["trade_pair_id"],
    tradeType: json["trade_type"],
    ouid: json["ouid"],
    orderId: json["order_id"],
    pair: json["pair"],
    orderType: json["order_type"],
    price: json["price"],
    volume: json["volume"].toDouble(),
    value: json["value"],
    fees: json["fees"],
    commission: json["commission"],
    remaining: json["remaining"].toDouble(),
    stoplimit: json["stoplimit"],
    status: json["status"],
    priceperunit: json["priceperunit"],
    leverage: json["leverage"],
    createdAt:  DateTime.parse(json["createdAt"]),
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
    "createdAt": createdAt!.toIso8601String(),
    "updatedAt": updatedAt,
    "pair_symbol": pairSymbol,
  };
}
