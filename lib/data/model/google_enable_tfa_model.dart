
import 'dart:convert';

GoogleEnabletfaModel googleEnabletfaModelFromJson(String str) => GoogleEnabletfaModel.fromJson(json.decode(str));

String googleEnabletfaModelToJson(GoogleEnabletfaModel data) => json.encode(data.toJson());

class GoogleEnabletfaModel {
  GoogleEnabletfaModel({
    this.message,
    this.statusCode,
    this.data,
  });

  String? message;
  int? statusCode;
  Data? data;

  factory GoogleEnabletfaModel.fromJson(Map<String, dynamic> json) => GoogleEnabletfaModel(
    message: json["message"],
    statusCode: json["status_code"],
    data: json["data"]==null|| json["data"]=="null"?Data():Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "status_code": statusCode,
    "data": data!.toJson(),
  };
}

class Data {
  Data({
    this.verified,
  });

  bool? verified;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    verified: json["verified"],
  );

  Map<String, dynamic> toJson() => {
    "verified": verified,
  };
}
