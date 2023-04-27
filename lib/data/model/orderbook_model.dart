// To parse this JSON data, do
//
//     final orderBookModel = orderBookModelFromJson(jsonString);

import 'dart:convert';

OrderBookModel orderBookModelFromJson(String str) => OrderBookModel.fromJson(json.decode(str));

String orderBookModelToJson(OrderBookModel data) => json.encode(data.toJson());

class OrderBookModel {
  OrderBookModel({
    this.message,
    this.statusCode,
    this.data,
  });

  String? message;
  int? statusCode;
  OrderBookData? data;

  factory OrderBookModel.fromJson(Map<String, dynamic> json) => OrderBookModel(
    message: json["message"],
    statusCode: json["status_code"],
    data: OrderBookData.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "status_code": statusCode,
    "data": data!.toJson(),
  };
}

class OrderBookData {
  OrderBookData({
    this.buytrade,
    this.selltrade,
    this.pair,
  });

  List<Trade>? buytrade;
  List<Trade>? selltrade;
  String? pair;

  factory OrderBookData.fromJson(Map<String, dynamic> json) => OrderBookData(
    buytrade: List<Trade>.from(json["buytrade"].map((x) => Trade.fromJson(x))),
    selltrade: List<Trade>.from(json["selltrade"].map((x) => Trade.fromJson(x))),
    pair: json["pair"]==null?null: json["pair"],
  );

  Map<String, dynamic> toJson() => {
    "buytrade": List<dynamic>.from(buytrade!.map((x) => x.toJson())),
    "selltrade": List<dynamic>.from(selltrade!.map((x) => x.toJson())),
    "pair": pair,
  };
}

class Trade {
  Trade({
    this.id,
    this.volume,
    this.convertPrice,
  });

  dynamic id;
  dynamic volume;
  dynamic convertPrice;

  factory Trade.fromJson(Map<String, dynamic> json) => Trade(
    id: json["_id"],
    volume: json["volume"],
    convertPrice: json["convert_price"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "volume": volume,
    "convert_price": convertPrice,
  };
}
