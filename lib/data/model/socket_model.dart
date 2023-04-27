// To parse this JSON data, do
//
//     final socketModel = socketModelFromJson(jsonString);

import 'dart:convert';

import 'package:h2_crypto/data/model/orderbook_model.dart';

SocketModel socketModelFromJson(String str) => SocketModel.fromJson(json.decode(str));

String socketModelToJson(SocketModel data) => json.encode(data.toJson());

class SocketModel {
  SocketModel({
    this.buytrade,
    this.selltrade,
    this.pair,
  });

  List<Trade>? buytrade;
  List<Trade>? selltrade;
  String? pair;

  factory SocketModel.fromJson(Map<String, dynamic> json) => SocketModel(
    buytrade: List<Trade>.from(json["buytrade"].map((x) => Trade.fromJson(x))),
    selltrade: List<Trade>.from(json["selltrade"].map((x) => Trade.fromJson(x))),
    pair: json["pair"],
  );

  Map<String, dynamic> toJson() => {
    "buytrade": List<dynamic>.from(buytrade!.map((x) => x.toJson())),
    "selltrade": List<dynamic>.from(selltrade!.map((x) => x.toJson())),
    "pair": pair,
  };
}

