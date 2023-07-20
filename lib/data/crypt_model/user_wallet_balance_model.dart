import 'dart:convert';

UserWalletBalanceModel userWalletBalanceModelFromJson(String str) => UserWalletBalanceModel.fromJson(json.decode(str));

String userWalletBalanceModelToJson(UserWalletBalanceModel data) => json.encode(data.toJson());

class UserWalletBalanceModel {
  bool? success;
  List<UserWalletResult>? result;
  String? message;
  String? usdTotal;

  UserWalletBalanceModel({
    this.success,
    this.result,
    this.message,
    this.usdTotal,
  });

  factory UserWalletBalanceModel.fromJson(Map<String, dynamic> json) => UserWalletBalanceModel(
    success: json["success"],
    result: List<UserWalletResult>.from(json["result"].map((x) => UserWalletResult.fromJson(x))),
    message: json["message"],
    usdTotal: json["usdTotal"],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "result": List<dynamic>.from(result!.map((x) => x.toJson())),
    "message": message,
    "usdTotal": usdTotal,
  };
}

class UserWalletResult {
  String? asset;
  String? symbol;
  String? name;
  dynamic type;
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
    type: json["type"],
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
    "type": type,
    "image": image,
    "point_value": pointValue,
    "perday_withdraw": perdayWithdraw,
    "withdraw_commission": withdrawCommission,
    "balance": balance,
    "escrow": escrow,
    "total": total,
  };
}


