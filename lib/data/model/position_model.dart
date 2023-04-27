// To parse this JSON data, do
//
//     final positionOrderModel = positionOrderModelFromJson(jsonString);

import 'dart:convert';

PositionOrderModel positionOrderModelFromJson(String str) => PositionOrderModel.fromJson(json.decode(str));

String positionOrderModelToJson(PositionOrderModel data) => json.encode(data.toJson());

class PositionOrderModel {
  PositionOrderModel({
    this.message,
    this.statusCode,
    this.data,
  });

  String? message;
  int? statusCode;
  List<PositionList>? data;

  factory PositionOrderModel.fromJson(Map<String, dynamic> json) => PositionOrderModel(
    message: json["message"],
    statusCode: json["status_code"],
    data: List<PositionList>.from(json["data"].map((x) => PositionList.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "status_code": statusCode,
    "data": List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class PositionList {
  PositionList({
    this.id,
    this.ouid,
    this.symbol,
    this.orderId,
    this.pair,
    this.tradeType,
    this.orderType,
    this.price,
    this.volume,
    this.value,
    this.fees,
    this.commission,
    this.remaining,
    this.positionBalance,
    this.stoplimit,
    this.status,
    this.completedStatus,
    this.priceperunit,
    this.margin_ratio,
    this.margin_amount,
    this.loan_amount,
    this.leverage,
    this.tradeLogic,
    this.convertPrice,
    this.tradeMode,
    this.loan_id,
    this.createdAt,
    this.updatedAt,
    this.v,
    this.tradePairId,
    this.userId,
  });

  String? id;
  dynamic ouid;
  dynamic symbol;
  dynamic orderId;
  String? pair;
  dynamic orderType;
  dynamic tradeType;
  dynamic price;
  dynamic volume;
  dynamic value;
  dynamic fees;
  dynamic commission;
  dynamic remaining;
  dynamic positionBalance;
  dynamic stoplimit;
  String? status;
  bool? completedStatus;
  dynamic priceperunit;
  dynamic margin_ratio;
  dynamic margin_amount;
  dynamic loan_amount;
  dynamic leverage;
  dynamic convert_price;
  int? tradeLogic;
  int? convertPrice;
  int? tradeMode;
  String? loan_id;
  String? createdAt;
  String? updatedAt;
  int? v;
  String? tradePairId;
  String? userId;

  factory PositionList.fromJson(Map<String, dynamic> json) => PositionList(
    id: json["_id"],
    ouid: json["ouid"],
    symbol: json["symbol"],
    orderId: json["order_id"],
    pair: json["pair"],
    tradeType: json["trade_type"],
    orderType: json["order_type"],
    price: json["price"],
    volume: json["volume"],
    value: json["value"],
    fees: json["fees"],
    commission: json["commission"],
    remaining: json["remaining"],
    positionBalance: json["position_balance"],
    stoplimit: json["stoplimit"],
    status: json["status"],
    completedStatus: json["completed_status"],
    priceperunit: json["priceperunit"],
    margin_ratio: json["margin_ratio"],
    margin_amount: json["margin_amount"],
    loan_amount: json["loan_amount"],
    leverage: json["leverage"],
    tradeLogic: json["trade_logic"],
    convertPrice: json["convert_price"],
    tradeMode: json["trade_mode"],
    loan_id: json["loan_id"],
    createdAt: json["createdAt"],
    updatedAt: json["updatedAt"],
    v: json["__v"],
    tradePairId: json["trade_pair_id"],
    userId: json["user_id"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "ouid": ouid,
    "symbol": symbol,
    "order_id": orderId,
    "pair": pair,
    "trade_type": tradeType,
    "order_type": orderType,
    "price": price,
    "volume": volume,
    "value": value,
    "fees": fees,
    "commission": commission,
    "remaining": remaining,
    "position_balance": positionBalance,
    "stoplimit": stoplimit,
    "status": status,
    "completed_status": completedStatus,
    "priceperunit": priceperunit,
    "margin_ratio": margin_ratio,
    "margin_amount": margin_amount,
    "loan_amount": loan_amount,
    "leverage": leverage,
    "trade_logic": tradeLogic,
    "convert_price": convertPrice,
    "trade_mode": tradeMode,
    "loan_id": loan_id,
    "createdAt": createdAt,
    "updatedAt": updatedAt,
    "__v": v,
    "trade_pair_id": tradePairId,
    "user_id": userId,
  };
}
