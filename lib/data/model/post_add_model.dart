
import 'dart:convert';

PostAddModel postAddModelFromJson(String str) => PostAddModel.fromJson(json.decode(str));

String postAddModelToJson(PostAddModel data) => json.encode(data.toJson());

class PostAddModel {
  PostAddModel({
    this.message,
    this.statusCode,
    this.data,
  });

  String? message;
  int? statusCode;
  PostAdd? data;

  factory PostAddModel.fromJson(Map<String, dynamic> json) => PostAddModel(
    message: json["message"],
    statusCode: json["status_code"],
    data:json["data"]==null?null: PostAdd.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "status_code": statusCode,
    "data": data!.toJson(),
  };
}

class PostAdd {
  PostAdd({
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
    this.id,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  String? userId;
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
  dynamic tradeId;
  dynamic slipUpload;
  bool? isDelete;
  String? id;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;

  factory PostAdd.fromJson(Map<String, dynamic> json) => PostAdd(
    userId: json["userId"],
    adType: json["ad_type"],
    asset: json["asset"],
    cash: json["cash"],
    livePrice: json["live_price"],
    quantity: json["quantity"],
    minLimit: json["min_limit"],
    maxLimit: json["max_limit"],
    paymentType: List<String>.from(json["payment_type"].map((x) => x)),
    status: json["status"],
    statusText: json["status_text"],
    tradeId: json["trade_id"],
    slipUpload: json["slip_upload"],
    isDelete: json["isDelete"],
    id: json["_id"],
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
    v: json["__v"],
  );

  Map<String, dynamic> toJson() => {
    "userId": userId,
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
    "_id": id,
    "createdAt": createdAt!.toIso8601String(),
    "updatedAt": updatedAt!.toIso8601String(),
    "__v": v,
  };
}
