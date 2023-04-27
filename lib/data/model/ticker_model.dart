
import 'dart:convert';

TickerDataListModel tickerDataListModelFromJson(String str) => TickerDataListModel.fromJson(json.decode(str));

String tickerDataListModelToJson(TickerDataListModel data) => json.encode(data.toJson());

class TickerDataListModel {
  TickerDataListModel({
    this.message,
    this.statusCode,
    this.data,
  });

  String? message;
  int? statusCode;
  TickerData? data;

  factory TickerDataListModel.fromJson(Map<String, dynamic> json) => TickerDataListModel(
    message: json["message"],
    statusCode: json["status_code"],
    data: TickerData.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "status_code": statusCode,
    "data": data!.toJson(),
  };
}

class TickerData {
  TickerData({
    this.ch,
    this.status,
    this.ts,
    this.data,
  });

  String? ch;
  String? status;
  int? ts;
  List<TickerList>?data;

  factory TickerData.fromJson(Map<String, dynamic> json) => TickerData(
    ch: json["ch"],
    status: json["status"],
    ts: json["ts"],
    data: List<TickerList>.from(json["data"].map((x) => TickerList.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "ch": ch,
    "status": status,
    "ts": ts,
    "data": List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class TickerList {
  TickerList({
    this.id,
    this.open,
    this.close,
    this.low,
    this.high,
    this.amount,
    this.vol,
    this.count,
  });

  int? id;
  double? open;
  double? close;
  double? low;
  double? high;
  double? amount;
  double? vol;
  int? count;

  factory TickerList.fromJson(Map<String, dynamic> json) => TickerList(
    id: json["id"],
    open: json["open"].toDouble(),
    close: json["close"].toDouble(),
    low: json["low"].toDouble(),
    high: json["high"].toDouble(),
    amount: json["amount"].toDouble(),
    vol: json["vol"].toDouble(),
    count: json["count"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "open": open,
    "close": close,
    "low": low,
    "high": high,
    "amount": amount,
    "vol": vol,
    "count": count,
  };
}
