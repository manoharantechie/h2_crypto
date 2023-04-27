import 'dart:convert';

import 'dart:convert';

SentOtpModel sentOtpModelFromJson(String str) => SentOtpModel.fromJson(json.decode(str));

String sentOtpModelToJson(SentOtpModel data) => json.encode(data.toJson());

class SentOtpModel {
  SentOtpModel({
    this.message,
    this.statusCode,
    this.data,
  });

  String? message;
  int? statusCode;
  SentOtp? data;

  factory SentOtpModel.fromJson(Map<String, dynamic> json) => SentOtpModel(
    message: json["message"],
    statusCode: json["status_code"],
    data: json["data"]==null || json["data"]=="null"?SentOtp():SentOtp.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "status_code": statusCode,
    "data": data!.toJson(),
  };
}

class SentOtp {
  SentOtp({
    this.accessToken,
    this.refreshToken,
  });

  Token? accessToken;
  Token? refreshToken;

  factory SentOtp.fromJson(Map<String, dynamic> json) => SentOtp(
    accessToken: Token.fromJson(json["accessToken"]),
    refreshToken: Token.fromJson(json["refreshToken"]),
  );

  Map<String, dynamic> toJson() => {
    "accessToken": accessToken!.toJson(),
    "refreshToken": refreshToken!.toJson(),
  };
}

class Token {
  Token({
    this.token,
    this.exp,
  });

  String? token;
  int? exp;

  factory Token.fromJson(Map<String, dynamic> json) => Token(
    token: json["token"],
    exp: json["exp"],
  );

  Map<String, dynamic> toJson() => {
    "token": token,
    "exp": exp,
  };
}
