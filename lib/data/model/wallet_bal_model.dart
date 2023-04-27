import 'dart:convert';

import 'package:h2_crypto/data/model/wallet_list_model.dart';

WalletBalanceModel walletListModelFromJson(String str) => WalletBalanceModel.fromJson(json.decode(str));

String walletListModelToJson(WalletBalanceModel data) => json.encode(data.toJson());

class WalletBalanceModel {
  WalletBalanceModel({
    this.message,
    this.statusCode,
    this.data,
  });

  String? message;
  int? statusCode;
  WalletList? data;

  factory WalletBalanceModel.fromJson(Map<String, dynamic> json) => WalletBalanceModel(
    message: json["message"],
    statusCode: json["status_code"],
    data: WalletList.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "status_code": statusCode,
    "data":  data!.toJson(),
  };
}

