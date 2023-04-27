import 'dart:convert';

CoinBalanceModel coinBalanceModelFromJson(String str) => CoinBalanceModel.fromJson(json.decode(str));

String coinBalanceModelToJson(CoinBalanceModel data) => json.encode(data.toJson());

class CoinBalanceModel {
  CoinBalanceModel({
    this.status,
    this.data,
    this.msg,
  });

  bool? status;
  CoinBalanceData? data;
  String? msg;

  factory CoinBalanceModel.fromJson(Map<String, dynamic> json) => CoinBalanceModel(
    status: json["status"],
    data: CoinBalanceData.fromJson(json["data"]),
    msg: json["msg"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "data": data!.toJson(),
    "msg": msg,
  };
}

class CoinBalanceData {
  CoinBalanceData({
    this.findData,
    this.addressData,
    this.walletData,
  });

  FindData? findData;
  List<AddressDatum>? addressData;
  WalletData? walletData;

  factory CoinBalanceData.fromJson(Map<String, dynamic> json) => CoinBalanceData(
    findData: FindData.fromJson(json["findData"]),
    addressData: List<AddressDatum>.from(json["addressData"].map((x) => AddressDatum.fromJson(x))),
    walletData: WalletData.fromJson(json["walletData"]),
  );

  Map<String, dynamic> toJson() => {
    "findData": findData!.toJson(),
    "addressData": List<dynamic>.from(addressData!.map((x) => x.toJson())),
    "walletData": walletData!.toJson(),
  };
}

class AddressDatum {
  AddressDatum({
    this.id,
    this.addressDatumId,
    this.userId,
    this.walletId,
    this.address,
    this.chain,
    this.coin,
    this.createdAt,
    this.updatedAt,
    this.v,

  });

  String? id;
  String? addressDatumId;
  String? userId;
  String? walletId;
  String? address;
  int? chain;
  String? coin;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;


  factory AddressDatum.fromJson(Map<String, dynamic> json) => AddressDatum(
    id: json["_id"],
    addressDatumId: json["id"],
    userId: json["userId"],
    walletId: json["walletId"],
    address: json["address"],
    chain: json["chain"],
    coin: json["coin"],
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
    v: json["__v"],

  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "id": addressDatumId,
    "userId": userId,
    "walletId": walletId,
    "address": address,
    "chain": chain,
    "coin": coin,
    "createdAt": createdAt!.toIso8601String(),
    "updatedAt": updatedAt!.toIso8601String(),
    "__v": v,
  };
}

class Wallet {
  Wallet();

  factory Wallet.fromJson(Map<String, dynamic> json) => Wallet(
  );

  Map<String, dynamic> toJson() => {
  };
}

class FindData {
  FindData({
    this.id,
    this.source,
    this.type,
    this.withdrawType,
    this.coinname,
    this.decimalP,
    this.url,
    this.contractaddress,
    this.abiarray,
    this.image,
    this.createdAt,
    this.updatedAt,
  });

  String? id;
  String? source;
  String? type;
  String? withdrawType;
  String? coinname;
  String? decimalP;
  String? url;
  String? contractaddress;
  String? abiarray;
  String? image;
  String? createdAt;
  String? updatedAt;

  factory FindData.fromJson(Map<String, dynamic> json) => FindData(
    id: json["_id"],
    source: json["source"],
    type: json["type"],
    withdrawType: json["withdraw_type"],
    coinname: json["coinname"],
    decimalP: json["decimal_p"],
    url: json["url"],
    contractaddress: json["contractaddress"],
    abiarray: json["abiarray"],
    image: json["image"],
    createdAt: json["created_at"],
    updatedAt: json["updated_at"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "source": source,
    "type": type,
    "withdraw_type": withdrawType,
    "coinname": coinname,
    "decimal_p": decimalP,
    "url": url,
    "contractaddress": contractaddress,
    "abiarray": abiarray,
    "image": image,
    "created_at": createdAt,
    "updated_at": updatedAt,
  };
}

class WalletData {
  WalletData({
    this.balance,
    this.escrowBalance,
    this.total,
  });

  String? balance;
  String? escrowBalance;
  String? total;

  factory WalletData.fromJson(Map<String, dynamic> json) => WalletData(
    balance: json["balance"],
    escrowBalance: json["escrow_balance"],
    total: json["total"],
  );

  Map<String, dynamic> toJson() => {
    "balance": balance,
    "escrow_balance": escrowBalance,
    "total": total,
  };
}
