import 'dart:convert';

RefreshTokenModel refreshTokenModelFromJson(String str) => RefreshTokenModel.fromJson(json.decode(str));

String refreshTokenModelToJson(RefreshTokenModel data) => json.encode(data.toJson());

class RefreshTokenModel {
  RefreshTokenModel({
    this.message,
    this.statusCode,
    this.data,
  });

  String? message;
  int? statusCode;
  RefreshToken? data;

  factory RefreshTokenModel.fromJson(Map<String, dynamic> json) => RefreshTokenModel(
    message: json["message"],
    statusCode: json["status_code"],
    data: RefreshToken.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "status_code": statusCode,
    "data": data!.toJson(),
  };
}

class RefreshToken {
  RefreshToken({
    this.accessToken,
  });

  AccessToken? accessToken;

  factory RefreshToken.fromJson(Map<String, dynamic> json) => RefreshToken(
    accessToken: AccessToken.fromJson(json["accessToken"]),
  );

  Map<String, dynamic> toJson() => {
    "accessToken": accessToken!.toJson(),
  };
}

class AccessToken {
  AccessToken({
    this.token,
    this.exp,
  });

  String? token;
  int? exp;

  factory AccessToken.fromJson(Map<String, dynamic> json) => AccessToken(
    token: json["token"],
    exp: json["exp"],
  );

  Map<String, dynamic> toJson() => {
    "token": token,
    "exp": exp,
  };
}
