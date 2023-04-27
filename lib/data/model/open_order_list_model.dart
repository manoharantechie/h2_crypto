import 'dart:convert';

OpenOrderListModel openOrderListModelFromJson(String str) => OpenOrderListModel.fromJson(json.decode(str));

String openOrderListModelToJson(OpenOrderListModel data) => json.encode(data.toJson());

class OpenOrderListModel {
  OpenOrderListModel({
    this.message,
    this.statusCode,
    this.data,
  });

  String? message;
  int? statusCode;
  List<OpenOrderList>? data;

  factory OpenOrderListModel.fromJson(Map<String, dynamic> json) => OpenOrderListModel(
    message: json["message"],
    statusCode: json["status_code"],
    data: List<OpenOrderList>.from(json["data"].map((x) => OpenOrderList.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "status_code": statusCode,
    "data": List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class OpenOrderList {
  OpenOrderList({
    this.id,
    this.userId,
    this.tradeType,
    this.tradePairId,
    this.ouid,
    this.symbol,
    this.pair_symbol,
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
    this.statusText,
    this.priceperunit,
    this.leverage,
    this.createdAt,
    this.updatedAt,
    this.v,
    this.additionalInfo,
  });

  String? id;
  dynamic userId;
  dynamic tradePairId;
  dynamic tradeType;
  String? ouid;
  dynamic symbol;
  dynamic pair_symbol;
  String? orderId;
  dynamic pair;
  dynamic orderType;
  dynamic price;
  dynamic volume;
  dynamic value;
  dynamic fees;
  dynamic commission;
  dynamic remaining;
  dynamic stoplimit;
  dynamic status;
  dynamic statusText;
  dynamic priceperunit;
  dynamic leverage;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;
  AdditionalInfo? additionalInfo;

  factory OpenOrderList.fromJson(Map<String, dynamic> json) => OpenOrderList(
    id: json["_id"],
    userId: json["user_id"],
    tradePairId: json["trade_pair_id"],
    tradeType:json["trade_type"],
    ouid: json["ouid"],
    symbol: json["symbol"],
    pair_symbol: json["pair_symbol"],
    orderId: json["order_id"],
    pair:json["pair"],
    orderType: json["order_type"],
    price: json["price"],
    volume: json["volume"],
    value: json["value"],
    fees: json["fees"],
    commission: json["commission"],
    remaining: json["remaining"],
    stoplimit: json["stoplimit"],
    status: json["status"],
    statusText: json["status_text"],
    priceperunit: json["priceperunit"],
    leverage: json["leverage"],
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
    v: json["__v"],
    additionalInfo: json["additional_info"] == null ? AdditionalInfo() : AdditionalInfo.fromJson(json["additional_info"]),
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "user_id":userId,
    "trade_pair_id": tradePairId,
    "trade_type": tradeType,
    "ouid": ouid,
    "symbol": symbol,
    "pair_symbol": pair_symbol,
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
    "status_text": statusText,
    "priceperunit": priceperunit,
    "leverage": leverage,
    "createdAt": createdAt!.toIso8601String(),
    "updatedAt": updatedAt!.toIso8601String(),
    "__v": v,
    "additional_info": additionalInfo == null ? null : additionalInfo!.toJson(),
  };
}

class AdditionalInfo {
  AdditionalInfo({
    this.id,
    this.symbol,
    this.accountId,
    this.clientOrderId,
    this.amount,
    this.price,
    this.createdAt,
    this.type,
    this.fieldAmount,
    this.fieldCashAmount,
    this.fieldFees,
    this.finishedAt,
    this.source,
    this.state,
    this.canceledAt,
  });

  int? id;
  dynamic symbol;
  int? accountId;
  String? clientOrderId;
  String? amount;
  String? price;
  int? createdAt;
  String? type;
  String? fieldAmount;
  String? fieldCashAmount;
  String? fieldFees;
  int? finishedAt;
  String? source;
  dynamic state;
  int? canceledAt;

  factory AdditionalInfo.fromJson(Map<String, dynamic> json) => AdditionalInfo(
    id: json["id"],
    symbol: json["symbol"],
    accountId: json["account-id"],
    clientOrderId: json["client-order-id"],
    amount: json["amount"],
    price: json["price"],
    createdAt: json["created-at"],
    type: json["type"],
    fieldAmount: json["field-amount"],
    fieldCashAmount: json["field-cash-amount"],
    fieldFees: json["field-fees"],
    finishedAt: json["finished-at"],
    source: json["source"],
    state: json["state"],
    canceledAt: json["canceled-at"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "symbol": symbol,
    "account-id": accountId,
    "client-order-id": clientOrderId,
    "amount": amount,
    "price": price,
    "created-at": createdAt,
    "type": type,
    "field-amount": fieldAmount,
    "field-cash-amount": fieldCashAmount,
    "field-fees": fieldFees,
    "finished-at": finishedAt,
    "source": source,
    "state": state,
    "canceled-at": canceledAt,
  };
}



