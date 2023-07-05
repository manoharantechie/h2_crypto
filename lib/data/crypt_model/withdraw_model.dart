import 'dart:convert';

WithdrawModel withdrawModelFromJson(String str) => WithdrawModel.fromJson(json.decode(str));

String withdrawModelToJson(WithdrawModel data) => json.encode(data.toJson());

class WithdrawModel {
  bool? success;
  WithdrawDetails? result;
  String? message;

  WithdrawModel({
    this.success,
    this.result,
    this.message,
  });

  factory WithdrawModel.fromJson(Map<String, dynamic> json) => WithdrawModel(
    success: json["success"],
    result:json["result"]==null || json["result"]=="null" ?WithdrawDetails():WithdrawDetails.fromJson(json["result"]),
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "result": result!.toJson(),
    "message": message,
  };
}

class WithdrawDetails {
  bool? success;
  String? id;
  dynamic atxId;
  dynamic txStatus;
  String? currency;
  dynamic amount;
  String? address;

  WithdrawDetails({
    this.success,
    this.id,
    this.atxId,
    this.txStatus,
    this.currency,
    this.amount,
    this.address,
  });

  factory WithdrawDetails.fromJson(Map<String, dynamic> json) => WithdrawDetails(
    success: json["success"],
    id: json["id"],
    atxId: json["atx_id"],
    txStatus: json["tx_status"],
    currency: json["currency"],
    amount: json["amount"].toDouble(),
    address: json["address"],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "id": id,
    "atx_id": atxId,
    "tx_status": txStatus,
    "currency": currency,
    "amount": amount,
    "address": address,
  };
}
