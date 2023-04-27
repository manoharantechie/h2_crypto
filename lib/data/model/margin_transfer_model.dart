// To parse this JSON data, do
//
//     final marginTransferModel = marginTransferModelFromJson(jsonString);

import 'dart:convert';

MarginTransferModel marginTransferModelFromJson(String str) => MarginTransferModel.fromJson(json.decode(str));

String marginTransferModelToJson(MarginTransferModel data) => json.encode(data.toJson());

class MarginTransferModel {
  MarginTransferModel({
    this.message,
    this.statusCode,

  });

  String? message;
  int? statusCode;


  factory MarginTransferModel.fromJson(Map<String, dynamic> json) => MarginTransferModel(
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
    this.holdBalance,
    this.marginBalance,
  });

  dynamic marginEscrowBalance;
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

  factory Data.fromJson(Map<String, dynamic> json) => Data(
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
  );

  Map<String, dynamic> toJson() => {
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
    "hold_balance": holdBalance,
    "margin_balance": marginBalance,
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
