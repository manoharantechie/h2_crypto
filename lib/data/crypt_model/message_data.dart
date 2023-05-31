// To parse this JSON data, do
//
//     final getMessageData = getMessageDataFromJson(jsonString);

import 'dart:convert';

GetMessageData getMessageDataFromJson(String str) => GetMessageData.fromJson(json.decode(str));

String getMessageDataToJson(GetMessageData data) => json.encode(data.toJson());

class GetMessageData {
  bool? success;
  List<MessageResult>? result;
  String? message;

  GetMessageData({
    this.success,
    this.result,
    this.message,
  });

  factory GetMessageData.fromJson(Map<String, dynamic> json) => GetMessageData(
    success: json["success"],
    result: List<MessageResult>.from(json["result"].map((x) => MessageResult.fromJson(x))),
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "result": List<dynamic>.from(result!.map((x) => x.toJson())),
    "message": message,
  };
}

class MessageResult {
  int? id;
  int? uid;
  String? ticketid;
  String? message;
  dynamic reply;
  int? userStatus;
  int? adminStatus;
  String? createdAt;
  DateTime? updatedAt;

  MessageResult({
    this.id,
    this.uid,
    this.ticketid,
    this.message,
    this.reply,
    this.userStatus,
    this.adminStatus,
    this.createdAt,
    this.updatedAt,
  });

  factory MessageResult.fromJson(Map<String, dynamic> json) => MessageResult(
    id: json["id"],
    uid: json["uid"],
    ticketid: json["ticketid"],
    message: json["message"],
    reply: json["reply"],
    userStatus: json["user_status"],
    adminStatus: json["admin_status"],
    createdAt: json["created_at"],
    updatedAt: DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "uid": uid,
    "ticketid": ticketid,
    "message": message,
    "reply": reply,
    "user_status": userStatus,
    "admin_status": adminStatus,
    "created_at": createdAt!,
    "updated_at": updatedAt!.toIso8601String(),
  };
}
