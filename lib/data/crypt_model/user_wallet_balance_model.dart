import 'dart:convert';

UserWalletBalanceModel userWalletBalanceModelFromJson(String str) => UserWalletBalanceModel.fromJson(json.decode(str));

String userWalletBalanceModelToJson(UserWalletBalanceModel data) => json.encode(data.toJson());

class UserWalletBalanceModel {
  bool? success;
  List<UserWalletResult>? result;
  String? message;

  UserWalletBalanceModel({
    this.success,
    this.result,
    this.message,
  });

  factory UserWalletBalanceModel.fromJson(Map<String, dynamic> json) => UserWalletBalanceModel(
    success: json["success"],
    result: List<UserWalletResult>.from(json["result"].map((x) => UserWalletResult.fromJson(x))),
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "result": List<dynamic>.from(result!.map((x) => x.toJson())),
    "message": message,
  };
}

class UserWalletResult {
  String? asset;
  String? symbol;
  String? name;
  Type? type;
  String? image;
  String? pointValue;
  String? perdayWithdraw;
  String? withdrawCommission;
  String? balance;
  String? escrow;
  String? total;

  UserWalletResult({
    this.asset,
    this.symbol,
    this.name,
    this.type,
    this.image,
    this.pointValue,
    this.perdayWithdraw,
    this.withdrawCommission,
    this.balance,
    this.escrow,
    this.total,
  });

  factory UserWalletResult.fromJson(Map<String, dynamic> json) => UserWalletResult(
    asset: json["asset"],
    symbol: json["symbol"],
    name: json["name"],
    type: typeValues.map[json["type"]],
    image: json["image"],
    pointValue: json["point_value"],
    perdayWithdraw: json["perday_withdraw"],
    withdrawCommission: json["withdraw_commission"],
    balance: json["balance"],
    escrow: json["escrow"],
    total: json["total"],
  );

  Map<String, dynamic> toJson() => {
    "asset": asset,
    "symbol": symbol,
    "name": name,
    "type": typeValues.reverse[type],
    "image": image,
    "point_value": pointValue,
    "perday_withdraw": perdayWithdraw,
    "withdraw_commission": withdrawCommission,
    "balance": balance,
    "escrow": escrow,
    "total": total,
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
