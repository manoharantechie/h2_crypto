// To parse this JSON data, do
//
//     final instantValueModel = instantValueModelFromJson(jsonString);

import 'dart:convert';

InstantValueModel instantValueModelFromJson(String str) => InstantValueModel.fromJson(json.decode(str));

String instantValueModelToJson(InstantValueModel data) => json.encode(data.toJson());

class InstantValueModel {
  InstantValueModel({
    this.message,
    this.statusCode,
    this.data,
  });

  String? message;
  int? statusCode;
  InstantValueData? data;

  factory InstantValueModel.fromJson(Map<String, dynamic> json) => InstantValueModel(
    message: json["message"],
    statusCode: json["status_code"],
    data: InstantValueData.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "status_code": statusCode,
    "data": data!.toJson(),
  };
}

class InstantValueData {
  InstantValueData({
    this.totalvalue,
    this.liveprice,
  });

  dynamic totalvalue;
  dynamic liveprice;

  factory InstantValueData.fromJson(Map<String, dynamic> json) => InstantValueData(
    totalvalue: json["totalvalue"],
    liveprice: json["liveprice"],
  );

  Map<String, dynamic> toJson() => {
    "totalvalue": totalvalue,
    "liveprice": liveprice,
  };
}
