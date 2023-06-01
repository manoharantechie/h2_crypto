import 'dart:convert';

DepositDetailsModel depositDetailsModelFromJson(String str) => DepositDetailsModel.fromJson(json.decode(str));

String depositDetailsModelToJson(DepositDetailsModel data) => json.encode(data.toJson());

class DepositDetailsModel {
  bool success;
  DepositDetail result;
  String message;

  DepositDetailsModel({
    required this.success,
    required this.result,
    required this.message,
  });

  factory DepositDetailsModel.fromJson(Map<String, dynamic> json) => DepositDetailsModel(
    success: json["success"],
    result: DepositDetail.fromJson(json["result"]),
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "result": result.toJson(),
    "message": message,
  };
}

class DepositDetail {
  String? asset;
  String? symbol;
  String? address;
  String? qrcode;
  String? name;
  String? type;
  String? image;
  String? pointValue;
  String? perdayWithdraw;
  String? withdrawCommission;
  String? fee;
  String? balance;
  String? escrow;
  String? total;

  DepositDetail({
    required this.asset,
    required this.symbol,
    required this.address,
    required this.qrcode,
    required this.name,
    required this.type,
    required this.image,
    required this.pointValue,
    required this.perdayWithdraw,
    required this.withdrawCommission,
    required this.fee,
    required this.balance,
    required this.escrow,
    required this.total,
  });

  factory DepositDetail.fromJson(Map<String, dynamic> json) => DepositDetail(
    asset: json["asset"],
    symbol: json["symbol"],
    address: json["address"],
    qrcode: json["qrcode"],
    name: json["name"],
    type: json["type"],
    image: json["image"],
    pointValue: json["point_value"],
    perdayWithdraw: json["perday_withdraw"],
    withdrawCommission: json["withdraw_commission"],
    fee: json["fee"],
    balance: json["balance"],
    escrow: json["escrow"],
    total: json["total"],
  );

  Map<String, dynamic> toJson() => {
    "asset": asset,
    "symbol": symbol,
    "address": address,
    "qrcode": qrcode,
    "name": name,
    "type": type,
    "image": image,
    "point_value": pointValue,
    "perday_withdraw": perdayWithdraw,
    "withdraw_commission": withdrawCommission,
    "fee": fee,
    "balance": balance,
    "escrow": escrow,
    "total": total,
  };
}
