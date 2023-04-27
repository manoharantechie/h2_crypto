import 'dart:convert';

WalletListModel walletListModelFromJson(String str) => WalletListModel.fromJson(json.decode(str));

String walletListModelToJson(WalletListModel data) => json.encode(data.toJson());

class WalletListModel {
  WalletListModel({
    this.message,
    this.statusCode,
    this.data,
  });

  String? message;
  int? statusCode;
  List<WalletList>? data;

  factory WalletListModel.fromJson(Map<String, dynamic> json) => WalletListModel(
    message: json["message"],
    statusCode: json["status_code"],
    data: List<WalletList>.from(json["data"].map((x) => WalletList.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "status_code": statusCode,
    "data": List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class WalletList {
  WalletList({
    this.id,
    this.user,
    this.asset,
    this.mugavari,
    this.destinationTag,
    this.balance,
    this.escrowBalance,
    this.sitBalance,
    this.spent,
    this.received,
    this.status,
    this.v,
    this.holdBalance,
    this.marginBalance,
    this.future_balance,
    this.marginEscrowBalance,
    this.future_escrow_balance,
    this.positionBalance,
    this.margin_leverage,
    this.future_leverage,
  });

  String? id;
  dynamic user;
  Asset? asset;
  List<Mugavari>? mugavari;
  int? destinationTag;
  dynamic balance;
  dynamic escrowBalance;
  dynamic sitBalance;
  dynamic spent;
  dynamic received;
  bool? status;
  int? v;
  int? margin_leverage;
  int? future_leverage;
  dynamic holdBalance;
  dynamic marginBalance;
  dynamic future_balance;
  dynamic future_escrow_balance;
  dynamic marginEscrowBalance;
  dynamic positionBalance;

  factory WalletList.fromJson(Map<String, dynamic> json) => WalletList(
    id: json["_id"],
    user: json["user"],
    asset:json["asset"]==null || json["asset"]=="null"?Asset(): Asset.fromJson(json["asset"]),
    mugavari:json["mugavari"]==[]||json["mugavari"]==null?null:List<Mugavari>.from(json["mugavari"].map((x) => Mugavari.fromJson(x))),
    destinationTag: json["destination_tag"],
    balance: json["balance"],
    escrowBalance: json["escrow_balance"],
    sitBalance: json["sit_balance"],
    spent: json["spent"],
    received: json["received"],
    status: json["status"],
    v: json["__v"],
    margin_leverage: json["margin_leverage"],
    future_leverage: json["future_leverage"],
    holdBalance: json["hold_balance"] == null||json["hold_balance"] == "null" ? null : json["hold_balance"],
    marginBalance: json["margin_balance"] == null|| json["margin_balance"] == "null" ? null : json["margin_balance"],
    future_balance: json["future_balance"] == null|| json["future_balance"] == "null" ? null : json["future_balance"],
    future_escrow_balance: json["future_escrow_balance"] == null|| json["future_escrow_balance"] == "null" ? null : json["future_escrow_balance"],
    marginEscrowBalance: json["margin_escrow_balance"] == null||json["margin_escrow_balance"] == "null" ? null : json["margin_escrow_balance"],
    positionBalance: json["position_balance"] == null||json["position_balance"] == "null" ? null : json["position_balance"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "user": user,
    "asset": asset!.toJson(),
    "mugavari": List<dynamic>.from(mugavari!.map((x) => x.toJson())),
    "destination_tag": destinationTag,
    "balance": balance,
    "escrow_balance": escrowBalance,
    "sit_balance": sitBalance,
    "spent": spent,
    "received": received,
    "status": status,
    "__v": v,
    "margin_leverage": margin_leverage,
    "future_leverage": future_leverage,
    "hold_balance": holdBalance == null ? null : holdBalance,
    "margin_balance": marginBalance == null ? null : marginBalance,
    "future_balance": future_balance == null ? null : future_balance,
    "margin_escrow_balance": marginEscrowBalance == null ? null : marginEscrowBalance,
    "future_escrow_balance": future_escrow_balance == null ? null : future_escrow_balance,
    "position_balance": positionBalance == null ? null : positionBalance,
  };
}

class Asset {
  Asset({
    this.id,
    this.assetname,
    this.symbol,
    this.pointValue,
    this.netfee,
    this.type,
    this.withdrawCommission,
    this.withdrawLimitPerTransaction,
    this.minDeposit,
    this.minWithdraw,
    this.maxWithdraw,
    this.withdrawType,
    this.status,
    this.v,
  });

  String? id;
  String? assetname;
  String? symbol;
  int? pointValue;
  int? netfee;
  dynamic type;
  int? withdrawCommission;
  int? withdrawLimitPerTransaction;
  dynamic minDeposit;
  dynamic minWithdraw;
  int? maxWithdraw;
  dynamic withdrawType;
  bool? status;
  int? v;

  factory Asset.fromJson(Map<String, dynamic> json) => Asset(
    id: json["_id"],
    assetname: json["assetname"],
    symbol: json["symbol"],
    pointValue: json["point_value"],
    netfee: json["netfee"],
    type: json["type"],
    withdrawCommission: json["withdraw_commission"],
    withdrawLimitPerTransaction: json["withdraw_limit_per_transaction"],
    minDeposit: json["min_deposit"],
    minWithdraw: json["min_withdraw"],
    maxWithdraw: json["max_withdraw"],
    withdrawType: json["withdraw_type"],
    status: json["status"],
    v: json["__v"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "assetname": assetname,
    "symbol": symbol,
    "point_value": pointValue,
    "netfee": netfee,
    "type": type,
    "withdraw_commission": withdrawCommission,
    "withdraw_limit_per_transaction": withdrawLimitPerTransaction,
    "min_deposit": minDeposit,
    "min_withdraw": minWithdraw,
    "max_withdraw": maxWithdraw,
    "withdraw_type": withdrawType,
    "status": status,
    "__v": v,
  };
}



class Mugavari {
  Mugavari({
    this.userId,
    this.currency,
    this.address,
    this.addressTag,
    this.chain,
  });

  int? userId;
  dynamic currency;
  String? address;
  String? addressTag;
  String? chain;

  factory Mugavari.fromJson(Map<String, dynamic> json) => Mugavari(
    userId: json["userId"],
    currency:json["currency"],
    address: json["address"],
    addressTag: json["addressTag"],
    chain: json["chain"],
  );

  Map<String, dynamic> toJson() => {
    "userId": userId,
    "currency": currency,
    "address": address,
    "addressTag": addressTag,
    "chain": chain,
  };
}


