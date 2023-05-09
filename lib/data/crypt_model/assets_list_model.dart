import 'dart:convert';

AssetsListModel assetsListModelFromJson(String str) => AssetsListModel.fromJson(json.decode(str));

String assetsListModelToJson(AssetsListModel data) => json.encode(data.toJson());

class AssetsListModel {
  bool? success;
  List<AssetsListResult>? result;
  String? message;

  AssetsListModel({
    this.success,
    this.result,
    this.message,
  });

  factory AssetsListModel.fromJson(Map<String, dynamic> json) => AssetsListModel(
    success: json["success"],
    result: List<AssetsListResult>.from(json["result"].map((x) => AssetsListResult.fromJson(x))),
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "result": List<dynamic>.from(result!.map((x) => x.toJson())),
    "message": message,
  };
}

class AssetsListResult {
  String? asset;
  String? symbol;
  String? name;
  Type? type;
  dynamic pointValue;
  dynamic perdayWithdraw;

  AssetsListResult({
    this.asset,
    this.symbol,
    this.name,
    this.type,
    this.pointValue,
    this.perdayWithdraw,
  });

  factory AssetsListResult.fromJson(Map<String, dynamic> json) => AssetsListResult(
    asset: json["asset"],
    symbol: json["symbol"],
    name: json["name"],
    type: typeValues.map[json["type"]],
    pointValue: json["point_value"],
    perdayWithdraw: json["perday_withdraw"],
  );

  Map<String, dynamic> toJson() => {
    "asset": asset,
    "symbol": symbol,
    "name": name,
    "type": typeValues.reverse[type],
    "point_value": pointValue,
    "perday_withdraw": perdayWithdraw,
  };
}

enum Type { COIN, TOKEN, FIAT }

final typeValues = EnumValues({
  "coin": Type.COIN,
  "fiat": Type.FIAT,
  "token": Type.TOKEN
});

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
