
import 'dart:convert';

PositonHistoryModel positonHistoryModelFromJson(String str) => PositonHistoryModel.fromJson(json.decode(str));

String positonHistoryModelToJson(PositonHistoryModel data) => json.encode(data.toJson());

class PositonHistoryModel {
  PositonHistoryModel({
    this.message,
    this.statusCode,
    this.data,
  });

  String? message;
  dynamic? statusCode;
  List<PositonHistory>? data;

  factory PositonHistoryModel.fromJson(Map<String, dynamic> json) => PositonHistoryModel(
    message: json["message"],
    statusCode: json["status_code"],
    data: List<PositonHistory>.from(json["data"].map((x) => PositonHistory.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "status_code": statusCode,
    "data": List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class PositonHistory {
  PositonHistory({
    this.id,
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
    this.positionBalance,
    this.stoplimit,
    this.status,
    this.completedStatus,
    this.priceperunit,
    this.leverage,
    this.tradeLogic,
    this.convertPrice,
    this.tradeMode,
    this.createdAt,
    this.updatedAt,
    this.v,
    this.tradePairId,
    this.userId,
  });

  String? id;
  dynamic? ouid;
  dynamic? symbol;
  dynamic? orderId;
  String? pair;
  String? orderType;
  dynamic? price;
  dynamic? volume;
  dynamic? value;
  dynamic? fees;
  dynamic? commission;
  dynamic? remaining;
  dynamic? positionBalance;
  dynamic? stoplimit;
  String? status;
  bool? completedStatus;
  dynamic? priceperunit;
  dynamic? leverage;
  dynamic? tradeLogic;
  dynamic? convertPrice;
  dynamic? tradeMode;
  DateTime? createdAt;
  DateTime? updatedAt;
  dynamic? v;
  String? tradePairId;
  String? userId;

  factory PositonHistory.fromJson(Map<String, dynamic> json) => PositonHistory(
    id: json["_id"],
    ouid: json["ouid"] == null ? null : json["ouid"],
    symbol: json["symbol"] == null ? null : json["symbol"],
    orderId: json["order_id"] == null ? null : json["order_id"],
    pair: json["pair"],
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
    priceperunit: json["priceperunit"] == null ? null : json["priceperunit"],
    leverage: json["leverage"] == null ? null : json["leverage"],
    tradeLogic: json["trade_logic"],
    convertPrice: json["convert_price"],
    tradeMode: json["trade_mode"],
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
    v: json["__v"],
    tradePairId: json["trade_pair_id"],
    userId: json["user_id"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "ouid": ouid == null ? null : ouid,
    "symbol": symbol == null ? null : symbol,
    "order_id": orderId == null ? null : orderId,
    "pair": pair,
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
    "priceperunit": priceperunit == null ? null : priceperunit,
    "leverage": leverage == null ? null : leverage,
    "trade_logic": tradeLogic,
    "convert_price": convertPrice,
    "trade_mode": tradeMode,
    "createdAt": createdAt!.toIso8601String(),
    "updatedAt": updatedAt!.toIso8601String(),
    "__v": v,
    "trade_pair_id": tradePairId,
    "user_id": userId,
  };
}
