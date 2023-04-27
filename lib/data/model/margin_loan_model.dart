// To parse this JSON data, do
//
//     final loanModel = loanModelFromJson(jsonString);

import 'dart:convert';

LoanModel loanModelFromJson(String str) => LoanModel.fromJson(json.decode(str));

String loanModelToJson(LoanModel data) => json.encode(data.toJson());

class LoanModel {
  LoanModel({
    this.message,
    this.statusCode,
  });

  String? message;
  int? statusCode;

  factory LoanModel.fromJson(Map<String, dynamic> json) => LoanModel(
    message: json["message"],
    statusCode: json["status_code"],
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "status_code": statusCode,
  };
}

class Data {
  Data({
    this.futureBalance,
    this.futureEscrowBalance,
    this.marginHoldBalance,
    this.futureHoldBalance,
    this.marginBalance,
    this.marginEscrowBalance,
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
    this.margin_leverage,
    this.future_leverage,
    this.holdBalance,
    this.positionBalance
  });

  dynamic futureBalance;
  dynamic futureEscrowBalance;
  dynamic marginHoldBalance;
  dynamic futureHoldBalance;
  dynamic marginBalance;
  dynamic marginEscrowBalance;
  String? id;
  String? user;
  String? asset;
  List<Mugavari>? mugavari;
  int? destinationTag;
  dynamic balance;
  dynamic escrowBalance;
  int? sitBalance;
  int? spent;
  int? received;
  bool? status;
  int? v;
  int? margin_leverage;
  int? future_leverage;
  dynamic holdBalance;
  dynamic positionBalance;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    futureBalance: json["future_balance"],
    futureEscrowBalance: json["future_escrow_balance"],
    marginHoldBalance: json["margin_hold_balance"],
    futureHoldBalance: json["future_hold_balance"],
    marginBalance: json["margin_balance"],
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
    margin_leverage: json["margin_leverage"],
    future_leverage: json["future_leverage"],
    holdBalance: json["hold_balance"],
    positionBalance: json["position_balance"],
  );

  Map<String, dynamic> toJson() => {
    "future_balance": futureBalance,
    "future_escrow_balance": futureEscrowBalance,
    "margin_hold_balance": marginHoldBalance,
    "future_hold_balance": futureHoldBalance,
    "margin_balance": marginBalance,
    "margin_escrow_balance": marginEscrowBalance,
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
    "margin_leverage": margin_leverage,
    "future_leverage": future_leverage,
    "hold_balance": holdBalance,
    "position_balance":positionBalance
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
