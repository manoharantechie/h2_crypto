// To parse this JSON data, do
//
//     final chatDataModel = chatDataModelFromJson(jsonString);

import 'dart:convert';

ChatDataModel chatDataModelFromJson(String str) => ChatDataModel.fromJson(json.decode(str));

String chatDataModelToJson(ChatDataModel data) => json.encode(data.toJson());

class ChatDataModel {
  ChatDataModel({
    this.id,
    this.chatId,
    this.userId2,
    this.message,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  String? id;
  String? chatId;
  String? userId2;
  List<Message>? message;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;

  factory ChatDataModel.fromJson(Map<String, dynamic> json) => ChatDataModel(
    id: json["_id"],
    chatId: json["chatId"],
    userId2: json["userId2"],
    message: List<Message>.from(json["message"].map((x) => Message.fromJson(x))),
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
    v: json["__v"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "chatId": chatId,
    "userId2": userId2,
    "message": List<dynamic>.from(message!.map((x) => x.toJson())),
    "createdAt": createdAt!.toIso8601String(),
    "updatedAt": updatedAt!.toIso8601String(),
    "__v": v,
  };
}

class Message {
  Message({
    this.room,
    this.author,
    this.message,
    this.time,
  });

  String? room;
  String? author;
  String? message;
  String? time;

  factory Message.fromJson(Map<String, dynamic> json) => Message(
    room: json["room"],
    author: json["author"],
    message: json["message"],
    time: json["time"],
  );

  Map<String, dynamic> toJson() => {
    "room": room,
    "author": author,
    "message": message,
    "time": time,
  };
}
