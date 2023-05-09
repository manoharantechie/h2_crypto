import 'dart:convert';

List<MarketListModel> marketListModelFromJson(String str) => List<MarketListModel>.from(json.decode(str).map((x) => MarketListModel.fromJson(x)));

String marketListModelToJson(List<MarketListModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class MarketListModel {
  MarketListModel({
    this.ch,
    this.pair,
    this.ts,
    this.tick,
  });

  String? ch;
  String? pair;
  int? ts;
  Map<String, double>? tick;

  factory MarketListModel.fromJson(Map<String, dynamic> json) => MarketListModel(
    ch: json["ch"],
    pair: json["dn"],
    ts: json["ts"],
    tick: Map.from(json["tick"]).map((k, v) => MapEntry<String, double>(k, v.toDouble())),
  );

  Map<String, dynamic> toJson() => {
    "ch": ch,
    "dn": pair,
    "ts": ts,
    "tick": Map.from(tick!).map((k, v) => MapEntry<String, dynamic>(k, v)),
  };
}
