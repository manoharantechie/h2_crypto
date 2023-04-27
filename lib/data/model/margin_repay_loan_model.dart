// To parse this JSON data, do
//
//     final repayLoanModel = repayLoanModelFromJson(jsonString);

import 'dart:convert';

RepayLoanModel repayLoanModelFromJson(String str) => RepayLoanModel.fromJson(json.decode(str));

String repayLoanModelToJson(RepayLoanModel data) => json.encode(data.toJson());

class RepayLoanModel {
  RepayLoanModel({
    this.message,
    this.statusCode,
    this.data,
  });

  String? message;
  int? statusCode;
  RepayData? data;

  factory RepayLoanModel.fromJson(Map<String, dynamic> json) => RepayLoanModel(
    message: json["message"],
    statusCode: json["status_code"],
    data:json["data"]==null||json["data"]==""?null: RepayData.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "status_code": statusCode,
    "data": data!.toJson(),
  };
}

class RepayData {
  RepayData({
    this.marginEscrowBalance,
    this.margin_hold_balance,
    this.future_hold_balance,
    this.future_balance,
    this.id,
    this.user,
    this.asset,
    this.mugavari,
    this.destinationTag,
    this.balance,
    this.escrowBalance,
    this.sitBalance,
    this.spent,
    this.received,
    this.status,
    this.v,
    this.holdBalance,
    this.marginBalance,
  });

  dynamic marginEscrowBalance;
  dynamic margin_hold_balance;
  dynamic future_hold_balance;
  dynamic future_balance;
  String? id;
  String? user;
  String? asset;
  List<Mugavari>? mugavari;
  int? destinationTag;
  dynamic balance;
  dynamic escrowBalance;
  dynamic sitBalance;
  int? spent;
  int? received;
  bool? status;
  int? v;
  dynamic holdBalance;
  dynamic marginBalance;

  factory RepayData.fromJson(Map<String, dynamic> json) => RepayData(
    marginEscrowBalance: json["margin_escrow_balance"],
    id: json["_id"],
    user: json["user"],
    asset: json["asset"],
    mugavari: List<Mugavari>.from(json["mugavari"].map((x) => Mugavari.fromJson(x))),
    destinationTag: json["destination_tag"],
    balance: json["balance"],
    escrowBalance: json["escrow_balance"],
    sitBalance: json["sit_balance"],
    spent: json["spent"],
    received: json["received"],
    status: json["status"],
    v: json["__v"],
    holdBalance: json["hold_balance"],
    marginBalance: json["margin_balance"],
    margin_hold_balance: json["margin_hold_balance"],
    future_hold_balance: json["future_hold_balance"],
    future_balance: json["future_balance"],
  );

  Map<String, dynamic> toJson() => {
    "margin_escrow_balance": marginEscrowBalance,
    "margin_hold_balance": margin_hold_balance,
    "future_hold_balance": future_hold_balance,
    "_id": id,
    "user": user,
    "asset": asset,
    "mugavari": List<dynamic>.from(mugavari!.map((x) => x.toJson())),
    "destination_tag": destinationTag,
    "balance": balance,
    "escrow_balance": escrowBalance,
    "sit_balance": sitBalance,
    "spent": spent,
    "received": received,
    "status": status,
    "__v": v,
    "hold_balance": holdBalance,
    "margin_balance": marginBalance,
    "future_hold_balance": future_hold_balance,
    "future_balance": future_balance,
  };
}

class Mugavari {
  Mugavari({
    this.userId,
    this.currency,
    this.address,
    this.addressTag,
    this.chain,
  });

  int? userId;
  String? currency;
  String? address;
  String? addressTag;
  String? chain;

  factory Mugavari.fromJson(Map<String, dynamic> json) => Mugavari(
    userId: json["userId"],
    currency: json["currency"],
    address: json["address"],
    addressTag: json["addressTag"],
    chain: json["chain"],
  );

  Map<String, dynamic> toJson() => {
    "userId": userId,
    "currency": currency,
    "address": address,
    "addressTag": addressTag,
    "chain": chain,
  };
}
