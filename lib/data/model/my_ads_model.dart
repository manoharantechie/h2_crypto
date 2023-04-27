// To parse this JSON data, do
//
//     final myAdsHistoryData = myAdsHistoryDataFromJson(jsonString);

import 'dart:convert';

MyAdsHistoryData myAdsHistoryDataFromJson(String str) => MyAdsHistoryData.fromJson(json.decode(str));

String myAdsHistoryDataToJson(MyAdsHistoryData data) => json.encode(data.toJson());

class MyAdsHistoryData {
  MyAdsHistoryData({
    this.message,
    this.statusCode,
    this.data,
  });

  String? message;
  int? statusCode;
  List<MyAdsData>? data;

  factory MyAdsHistoryData.fromJson(Map<String, dynamic> json) => MyAdsHistoryData(
    message: json["message"],
    statusCode: json["status_code"],
    data: List<MyAdsData>.from(json["data"].map((x) => MyAdsData.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "status_code": statusCode,
    "data": List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class MyAdsData {
  MyAdsData({
    this.id,
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
  UserId? userId;
  String? adType;
  String? asset;
  String? cash;
  dynamic livePrice;
  dynamic quantity;
  dynamic minLimit;
  dynamic maxLimit;
  List<dynamic>? paymentType;
  int? status;
  String? statusText;
  dynamic tradeId;
  dynamic slipUpload;
  bool? isDelete;
  DateTime? createdAt;
  DateTime? updatedAt;

  factory MyAdsData.fromJson(Map<String, dynamic> json) => MyAdsData(
    id: json["_id"],
    userId: UserId.fromJson(json["userId"]),
    adType: json["ad_type"],
    asset: json["asset"],
    cash: json["cash"],
    livePrice: json["live_price"],
    quantity: json["quantity"],
    minLimit: json["min_limit"],
    maxLimit: json["max_limit"],
    paymentType: List<dynamic>.from(json["payment_type"]),
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
    "userId": userId!.toJson(),
    "ad_type": adType,
    "asset":asset,
    "cash": cash,
    "live_price": livePrice,
    "quantity": quantity,
    "min_limit": minLimit,
    "max_limit": maxLimit,
    "payment_type": List<dynamic>.from(paymentType!),
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

  String ? id;
  String ? name;
  String? email;

  factory UserId.fromJson(Map<String, dynamic> json) => UserId(
    id: json["_id"],
    name: json["name"],
    email: json["email"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "name": name,
    "email":email,
  };
}


