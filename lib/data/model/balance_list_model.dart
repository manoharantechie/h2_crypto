import 'dart:convert';

WalletBalModel walletBalanceModelFromJson(String str) => WalletBalModel.fromJson(json.decode(str));

String walletBalanceModelToJson(WalletBalModel data) => json.encode(data.toJson());

class WalletBalModel {
  WalletBalModel({
    this.message,
    this.statusCode,
    this.data,
  });

  String? message;
  int? statusCode;
  WalletBalance? data;

  factory WalletBalModel.fromJson(Map<String, dynamic> json) => WalletBalModel(
    message: json["message"],
    statusCode: json["status_code"],
    data: WalletBalance.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "status_code": statusCode,
    "data": data!.toJson(),
  };
}

class WalletBalance {
  WalletBalance({
    this.btcBalance,
    this.usdtBalance,
  });

  double? btcBalance;
  double? usdtBalance;

  factory WalletBalance.fromJson(Map<String, dynamic> json) => WalletBalance(
    btcBalance: json["btc_balance"].toDouble(),
    usdtBalance: json["usdt_balance"].toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "btc_balance": btcBalance,
    "usdt_balance": usdtBalance,
  };
}
