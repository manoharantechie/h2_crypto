import 'dart:convert';

NewSocketData newSocketDataFromJson(String str) => NewSocketData.fromJson(json.decode(str));

String newSocketDataToJson(NewSocketData data) => json.encode(data.toJson());

class NewSocketData {
  NewSocketData({
    required this.sequence,
    required this.recipient,
    required this.timestamp,
    required this.payload,
  });

  int sequence;
  String recipient;
  double timestamp;
  Payload payload;

  factory NewSocketData.fromJson(Map<String, dynamic> json) => NewSocketData(
    sequence: json["sequence"],
    recipient: json["recipient"],
    timestamp: json["timestamp"]?.toDouble(),
    payload: Payload.fromJson(json["payload"]),
  );

  Map<String, dynamic> toJson() => {
    "sequence": sequence,
    "recipient": recipient,
    "timestamp": timestamp,
    "payload": payload.toJson(),
  };
}

class Payload {
  Payload({
    required this.amount,
    required this.exchange,
    required this.high,
    required this.last,
    required this.low,
    required this.open,
    required this.pair,
    required this.route,
    required this.source,
    required this.timestamp,
    required this.volume,
    required this.vwap,
  });

  dynamic amount;
  String exchange;
  dynamic high;
  dynamic last;
  dynamic low;
  dynamic open;
  String pair;
  String route;
  String source;
  DateTime timestamp;
  dynamic volume;
  dynamic vwap;

  factory Payload.fromJson(Map<String, dynamic> json) => Payload(
    amount: json["amount"]?.toDouble(),
    exchange: json["exchange"],
    high: json["high"]?.toDouble(),
    last: json["last"]?.toDouble(),
    low: json["low"]?.toDouble(),
    open: json["open"]?.toDouble(),
    pair: json["pair"],
    route: json["route"],
    source: json["source"],
    timestamp: DateTime.parse(json["timestamp"]),
    volume: json["volume"]?.toDouble(),
    vwap: json["vwap"]?.toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "amount": amount,
    "exchange": exchange,
    "high": high,
    "last": last,
    "low": low,
    "open": open,
    "pair": pair,
    "route": route,
    "source": source,
    "timestamp": timestamp.toIso8601String(),
    "volume": volume,
    "vwap": vwap,
  };
}
