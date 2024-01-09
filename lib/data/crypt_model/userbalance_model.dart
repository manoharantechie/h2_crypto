import 'dart:convert';

UserBalanceModel userBalanceModelFromJson(String str) => UserBalanceModel.fromJson(json.decode(str));

String userBalanceModelToJson(UserBalanceModel data) => json.encode(data.toJson());

class UserBalanceModel {
  bool? success;
  String? result;
  String? balance;
  String? message;

  UserBalanceModel({
    this.success,
    this.result,
    this.balance,
    this.message,
  });

  factory UserBalanceModel.fromJson(Map<String, dynamic> json) => UserBalanceModel(
    success: json["success"],
    result: json["result"],
    balance: json["balance"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "result": result,
    "balance": balance,
    "message": message,
  };
}
