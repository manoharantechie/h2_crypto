// To parse this JSON data, do
//
//     final uploadImageModel = uploadImageModelFromJson(jsonString);

import 'dart:convert';

UploadImageModel uploadImageModelFromJson(String str) => UploadImageModel.fromJson(json.decode(str));

String uploadImageModelToJson(UploadImageModel data) => json.encode(data.toJson());

class UploadImageModel {
  UploadImageModel({
    this.message,
    this.statusCode,
    this.data,
  });

  String? message;
  int? statusCode;
  UploadData? data;

  factory UploadImageModel.fromJson(Map<String, dynamic> json) => UploadImageModel(
    message: json["message"],
    statusCode: json["status_code"],
    data: json["data"]==null?null:UploadData.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "status_code": statusCode,
    "data": data!.toJson(),
  };
}

class UploadData {
  UploadData({
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
    this.purchaseId,
    this.slipUpload,
    this.isDelete,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  String? id;
  String? userId;
  String? adType;
  String? asset;
  String? cash;
  double? livePrice;
  int? quantity;
  int? minLimit;
  int? maxLimit;
  List<String>? paymentType;
  int? status;
  String? statusText;
  dynamic tradeId;
  dynamic purchaseId;
  dynamic slipUpload;
  bool? isDelete;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;

  factory UploadData.fromJson(Map<String, dynamic> json) => UploadData(
    id: json["_id"],
    userId: json["userId"],
    adType: json["ad_type"],
    asset: json["asset"],
    cash: json["cash"],
    livePrice: json["live_price"].toDouble(),
    quantity: json["quantity"],
    minLimit: json["min_limit"],
    maxLimit: json["max_limit"],
    paymentType: json["payment_type"] == null ? [] :List<String>.from(json["payment_type"].map((x) => x)),
    status: json["status"],
    statusText: json["status_text"],
    tradeId: json["trade_id"],
    purchaseId: json["purchase_id"],
    slipUpload: json["slip_upload"],
    isDelete: json["isDelete"],
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
    v: json["__v"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "userId": userId,
    "ad_type": adType,
    "asset": asset,
    "cash": cash,
    "live_price": livePrice,
    "quantity": quantity,
    "min_limit": minLimit,
    "max_limit": maxLimit,
    "payment_type":paymentType == null ? [] : List<dynamic>.from(paymentType!.map((x) => x)),
    "status": status,
    "status_text": statusText,
    "trade_id": tradeId,
    "purchase_id": purchaseId,
    "slip_upload": slipUpload,
    "isDelete": isDelete,
    "createdAt": createdAt!.toIso8601String(),
    "updatedAt": updatedAt!.toIso8601String(),
    "__v": v,
  };
}
