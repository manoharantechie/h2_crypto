// To parse this JSON data, do
//
//     final tradepairDetailsModel = tradepairDetailsModelFromJson(jsonString);

import 'dart:convert';

import 'package:h2_crypto/data/model/trade_pair_list_model.dart';

TradepairDetailsModel tradepairDetailsModelFromJson(String str) => TradepairDetailsModel.fromJson(json.decode(str));

String tradepairDetailsModelToJson(TradepairDetailsModel data) => json.encode(data.toJson());

class TradepairDetailsModel {
  TradepairDetailsModel({
    this.message,
    this.statusCode,
    this.data,
  });

  String? message;
  int? statusCode;
  TradePairList? data;

  factory TradepairDetailsModel.fromJson(Map<String, dynamic> json) => TradepairDetailsModel(
    message: json["message"],
    statusCode: json["status_code"],
    data: TradePairList.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "status_code": statusCode,
    "data": data!.toJson(),
  };
}


