// To parse this JSON data, do
//
//     final purchasedAdsHistoryData = purchasedAdsHistoryDataFromJson(jsonString);

import 'dart:convert';

import 'package:h2_crypto/data/model/my_ad_details_model.dart';

PurchasedAdsHistoryData purchasedAdsHistoryDataFromJson(String str) => PurchasedAdsHistoryData.fromJson(json.decode(str));

String purchasedAdsHistoryDataToJson(PurchasedAdsHistoryData data) => json.encode(data.toJson());

class PurchasedAdsHistoryData {
  PurchasedAdsHistoryData({
    this.message,
    this.statusCode,
    this.data,
  });

  String? message;
  int? statusCode;
  List<MyAdDetailsData>? data;

  factory PurchasedAdsHistoryData.fromJson(Map<String, dynamic> json) => PurchasedAdsHistoryData(
    message: json["message"],
    statusCode: json["status_code"],
    data: List<MyAdDetailsData>.from(json["data"].map((x) => MyAdDetailsData.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "status_code": statusCode,
    "data": List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class PurchasedData {
  PurchasedData({
    this.id,
    this.senderuserId,
    this.userId,
    this.adType,
    this.asset,
    this.cash,
    this.livePrice,
    this.quantity,
    this.minLimit,
    this.maxLimit,
    this.paymentType,
    this.status,
    this.statusText,
    this.tradeId,
    this.slipUpload,
    this.isDelete,
    this.createdAt,
    this.updatedAt,
  });

  String? id;
  UserId? senderuserId;
  UserId? userId;
  String? adType;
  String? asset;
  String? cash;
  dynamic livePrice;
  dynamic quantity;
  dynamic minLimit;
  dynamic maxLimit;
  List<String>? paymentType;
  int? status;
  String? statusText;
  int? tradeId;
  String? slipUpload;
  bool? isDelete;
  DateTime? createdAt;
  DateTime? updatedAt;

  factory PurchasedData.fromJson(Map<String, dynamic> json) => PurchasedData(
    id: json["_id"],
    senderuserId: UserId.fromJson(json["senderuserId"]),
    userId: UserId.fromJson(json["userId"]),
    adType: json["ad_type"],
    asset: json["asset"],
    cash: json["cash"],
    livePrice: json["live_price"].toDouble(),
    quantity: json["quantity"],
    minLimit: json["min_limit"],
    maxLimit: json["max_limit"],
    paymentType: List<String>.from(json["payment_type"].map((x) => x)),
    status: json["status"],
    statusText: json["status_text"],
    tradeId: json["trade_id"],
    slipUpload: json["slip_upload"],
    isDelete: json["isDelete"],
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "senderuserId": senderuserId!.toJson(),
    "userId": userId!.toJson(),
    "ad_type": adType,
    "asset": asset,
    "cash": cash,
    "live_price": livePrice,
    "quantity": quantity,
    "min_limit": minLimit,
    "max_limit": maxLimit,
    "payment_type": List<dynamic>.from(paymentType!.map((x) => x)),
    "status": status,
    "status_text": statusText,
    "trade_id": tradeId,
    "slip_upload": slipUpload,
    "isDelete": isDelete,
    "createdAt": createdAt!.toIso8601String(),
    "updatedAt": updatedAt!.toIso8601String(),
  };
}

class UserId {
  UserId({
    this.id,
    this.name,
    this.email,
  });

  String? id;
  String? name;
  String? email;

  factory UserId.fromJson(Map<String, dynamic> json) => UserId(
    id: json["_id"],
    name: json["name"],
    email: json["email"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "name": name,
    "email": email,
  };
}
