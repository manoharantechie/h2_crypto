import 'dart:convert';

AssetDetailsModel assetDetailsModelFromJson(String str) => AssetDetailsModel.fromJson(json.decode(str));

String assetDetailsModelToJson(AssetDetailsModel data) => json.encode(data.toJson());

class AssetDetailsModel {
  bool? success;
  AssetDetailsResult? result;
  String? message;

  AssetDetailsModel({
    this.success,
    this.result,
    this.message,
  });

  factory AssetDetailsModel.fromJson(Map<String, dynamic> json) => AssetDetailsModel(
    success: json["success"],
    result: AssetDetailsResult.fromJson(json["result"]),
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "result": result!.toJson(),
    "message": message,
  };
}

class AssetDetailsResult {
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

  AssetDetailsResult({
    this.asset,
    this.symbol,
    this.address,
    this.qrcode,
    this.name,
    this.type,
    this.image,
    this.pointValue,
    this.perdayWithdraw,
    this.withdrawCommission,
    this.fee,
    this.balance,
    this.escrow,
    this.total,
  });

  factory AssetDetailsResult.fromJson(Map<String, dynamic> json) => AssetDetailsResult(
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
