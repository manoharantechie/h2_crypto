import 'dart:convert';

DepositHistoryModel depositHistoryModelFromJson(String str) => DepositHistoryModel.fromJson(json.decode(str));

String depositHistoryModelToJson(DepositHistoryModel data) => json.encode(data.toJson());

class DepositHistoryModel {
  DepositHistoryModel({
    this.message,
    this.statusCode,
    this.data,
  });

  String? message;
  int? statusCode;
  List<DepositHistory>? data;

  factory DepositHistoryModel.fromJson(Map<String, dynamic> json) => DepositHistoryModel(
    message: json["message"],
    statusCode: json["status_code"],
    data: List<DepositHistory>.from(json["data"].map((x) => DepositHistory.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "status_code": statusCode,
    "data": List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class DepositHistory {
  DepositHistory({
    this.id,
    this.fromAddress,
    this.toAddress,
    this.amount,
    this.asset,
    this.transactionType,
    this.createdTime,
    this.type,
  });

  String? id;
  String? fromAddress;
  String? toAddress;
  dynamic amount;
  String? asset;
  String? transactionType;
  String? type;
  int? createdTime;

  factory DepositHistory.fromJson(Map<String, dynamic> json) => DepositHistory(
    id: json["_id"],
    fromAddress: json["from_address"] == null ? null : json["from_address"],
    toAddress: json["to_address"],
    amount: json["amount"],
    asset: json["asset"],
    transactionType: json["transaction_type"],
    type: json["asset_type"],
    createdTime: json["created_time"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "from_address": fromAddress == null ? null : fromAddress,
    "to_address": toAddress,
    "amount": amount,
    "asset": asset,
    "transaction_type": transactionType,
    "asset_type": type,
    "created_time": createdTime,
  };
}
