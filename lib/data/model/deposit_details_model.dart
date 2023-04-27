import 'dart:convert';

DepositDetailsModel depositDetailsModelFromJson(String str) => DepositDetailsModel.fromJson(json.decode(str));

String depositDetailsModelToJson(DepositDetailsModel data) => json.encode(data.toJson());

class DepositDetailsModel {
  DepositDetailsModel({
    this.status,
    this.data,
    this.msg,
  });

  bool? status;
  DepositDetails? data;
  String? msg;

  factory DepositDetailsModel.fromJson(Map<String, dynamic> json) => DepositDetailsModel(
    status: json["status"],
    data: DepositDetails.fromJson(json["data"]),
    msg: json["msg"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "data": data!.toJson(),
    "msg": msg,
  };
}

class DepositDetails {
  DepositDetails({
    this.addressInfo,
    this.qrCode,
  });

  List<AddressInfo>? addressInfo;
  String? qrCode;

  factory DepositDetails.fromJson(Map<String, dynamic> json) => DepositDetails(
    addressInfo: List<AddressInfo>.from(json["address_info"].map((x) => AddressInfo.fromJson(x))),
    qrCode: json["qrCode"],
  );

  Map<String, dynamic> toJson() => {
    "address_info": List<dynamic>.from(addressInfo!.map((x) => x.toJson())),
    "qrCode": qrCode,
  };
}

class AddressInfo {
  AddressInfo({
    this.id,
    this.addressInfoId,
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
  String? addressInfoId;
  String? userId;
  String? walletId;
  String? address;
  int? chain;
  String? coin;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;

  factory AddressInfo.fromJson(Map<String, dynamic> json) => AddressInfo(
    id: json["_id"],
    addressInfoId: json["id"],
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
    "id": addressInfoId,
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
