import 'dart:convert';

GoogletfaModel googletfaModelFromJson(String str) => GoogletfaModel.fromJson(json.decode(str));

String googletfaModelToJson(GoogletfaModel data) => json.encode(data.toJson());

class GoogletfaModel {
  GoogletfaModel({
    this.message,
    this.statusCode,
    this.data,
  });

  String? message;
  int? statusCode;
  Googletfa? data;

  factory GoogletfaModel.fromJson(Map<String, dynamic> json) => GoogletfaModel(
    message: json["message"],
    statusCode: json["status_code"],
    data: json["data"]==null|| json["data"]=="null"?Googletfa():Googletfa.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "status_code": statusCode,
    "data": data!.toJson(),
  };
}

class Googletfa {
  Googletfa({
    this.hash,
  });

  String? hash;

  factory Googletfa.fromJson(Map<String, dynamic> json) => Googletfa(
    hash: json["hash"],
  );

  Map<String, dynamic> toJson() => {
    "hash": hash,
  };
}
