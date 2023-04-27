// To parse this JSON data, do
//
//     final loanHistoryModel = loanHistoryModelFromJson(jsonString);

import 'dart:convert';

LoanHistoryModel loanHistoryModelFromJson(String str) => LoanHistoryModel.fromJson(json.decode(str));

String loanHistoryModelToJson(LoanHistoryModel data) => json.encode(data.toJson());

class LoanHistoryModel {
  LoanHistoryModel({
    this.message,
    this.statusCode,
    this.data,
  });

  String? message;
  int? statusCode;
  List<LoanHistoryData>? data;

  factory LoanHistoryModel.fromJson(Map<String, dynamic> json) => LoanHistoryModel(
    message: json["message"],
    statusCode: json["status_code"],
    data: List<LoanHistoryData>.from(json["data"].map((x) => LoanHistoryData.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "status_code": statusCode,
    "data": List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class LoanHistoryData {
  LoanHistoryData({
    this.id,
    this.user,
    this.asset,
    this.wallet,
    this.loan,
    this.loanMode,
    this.assetName,
    this.margin_leverage,
    this.holdBalance,
    this.loanAmount,
    this.v,
  });

  String? id;
  String? user;
  String? asset;
  String? wallet;
  String? loan;
  int? loanMode;
  int? margin_leverage;
  String? assetName;
  dynamic holdBalance;
  dynamic loanAmount;
  dynamic v;

  factory LoanHistoryData.fromJson(Map<String, dynamic> json) => LoanHistoryData(
    id: json["_id"],
    user: json["user"],
    asset: json["asset"],
    wallet: json["wallet"],
    loan: json["loan"],
    loanMode: json["loan_mode"],
    assetName: json["asset_name"],
    holdBalance: json["hold_balance"],
    loanAmount: json["loan_amount"],
    margin_leverage: json["leverage"],
    v: json["__v"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "user": user,
    "asset": asset,
    "wallet": wallet,
    "loan": loan,
    "loan_mode": loanMode,
    "asset_name": assetName,
    "hold_balance": holdBalance,
    "loan_amount": loanAmount,
    "margin_leverage": margin_leverage,
    "__v": v,
  };
}
