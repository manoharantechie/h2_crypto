import 'dart:convert';

TermsConditionModel termsConditionFromJson(String str) => TermsConditionModel.fromJson(json.decode(str));

String termsConditionToJson(TermsConditionModel data) => json.encode(data.toJson());

class TermsConditionModel {
  TermsConditionModel({
    this.message,
    this.statusCode,
    this.data,
  });

  String? message;
  int? statusCode;
  List<Terms>? data;

  factory TermsConditionModel.fromJson(Map<String, dynamic> json) => TermsConditionModel(
    message: json["message"],
    statusCode: json["status_code"],
    data: List<Terms>.from(json["data"].map((x) => Terms.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "status_code": statusCode,
    "data": List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class Terms {
  Terms({
    this.id,
    this.cmsType,
    this.cmsInfo,
    this.cmsInfoType,
    this.updatedAt,
  });

  String? id;
  int? cmsType;
  String? cmsInfo;
  String? cmsInfoType;
  DateTime? updatedAt;

  factory Terms.fromJson(Map<String, dynamic> json) => Terms(
    id: json["_id"],
    cmsType: json["cms_type"],
    cmsInfo: json["cms_info"],
    cmsInfoType: json["cms_info_type"],
    updatedAt: DateTime.parse(json["updatedAt"]),
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "cms_type": cmsType,
    "cms_info": cmsInfo,
    "cms_info_type": cmsInfoType,
    "updatedAt": updatedAt!.toIso8601String(),
  };
}
