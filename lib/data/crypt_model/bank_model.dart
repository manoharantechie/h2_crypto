import 'dart:convert';

BankListModel bankListModelFromJson(String str) => BankListModel.fromJson(json.decode(str));

String bankListModelToJson(BankListModel data) => json.encode(data.toJson());

class BankListModel {
  bool? success;
  List<BankList>? result;
  String? message;
  Kycdata? kycdata;

  BankListModel({
    this.success,
    this.result,
    this.message,
    this.kycdata,
  });

  factory BankListModel.fromJson(Map<String, dynamic> json) => BankListModel(
    success: json["success"],
    result: List<BankList>.from(json["result"].map((x) => BankList.fromJson(x))),
    message: json["message"],
    kycdata: Kycdata.fromJson(json["kycdata"]),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "result": List<dynamic>.from(result!.map((x) => x.toJson())),
    "message": message,
    "kycdata": kycdata!.toJson(),
  };
}

class Kycdata {
  int? id;
  int? uid;
  String? fname;
  String? lname;
  DateTime? dob;
  String? city;
  String? state;
  String? country;
  String? phoneNo;
  int? zipCode;
  String? genderType;
  String? addressLine1;
  String? addressLine2;
  dynamic telegramName;
  String? idType;
  String? idNumber;
  dynamic idExp;
  String? frontImg;
  String? backImg;
  String? selfieImg;
  dynamic proofpaper;
  int? status;
  dynamic remark;
  DateTime? createdAt;
  DateTime? updatedAt;

  Kycdata({
    this.id,
    this.uid,
    this.fname,
    this.lname,
    this.dob,
    this.city,
    this.state,
    this.country,
    this.phoneNo,
    this.zipCode,
    this.genderType,
    this.addressLine1,
    this.addressLine2,
    this.telegramName,
    this.idType,
    this.idNumber,
    this.idExp,
    this.frontImg,
    this.backImg,
    this.selfieImg,
    this.proofpaper,
    this.status,
    this.remark,
    this.createdAt,
    this.updatedAt,
  });

  factory Kycdata.fromJson(Map<String, dynamic> json) => Kycdata(
    id: json["id"],
    uid: json["uid"],
    fname: json["fname"],
    lname: json["lname"],
    dob: DateTime.parse(json["dob"]),
    city: json["city"],
    state: json["state"],
    country: json["country"],
    phoneNo: json["phone_no"],
    zipCode: json["zip_code"],
    genderType: json["gender_type"],
    addressLine1: json["address_line1"],
    addressLine2: json["address_line2"],
    telegramName: json["telegram_name"],
    idType: json["id_type"],
    idNumber: json["id_number"],
    idExp: json["id_exp"],
    frontImg: json["front_img"],
    backImg: json["back_img"],
    selfieImg: json["selfie_img"],
    proofpaper: json["proofpaper"],
    status: json["status"],
    remark: json["remark"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "uid": uid,
    "fname": fname,
    "lname": lname,
    "dob": "${dob!.year.toString().padLeft(4, '0')}-${dob!.month.toString().padLeft(2, '0')}-${dob!.day.toString().padLeft(2, '0')}",
    "city": city,
    "state": state,
    "country": country,
    "phone_no": phoneNo,
    "zip_code": zipCode,
    "gender_type": genderType,
    "address_line1": addressLine1,
    "address_line2": addressLine2,
    "telegram_name": telegramName,
    "id_type": idType,
    "id_number": idNumber,
    "id_exp": idExp,
    "front_img": frontImg,
    "back_img": backImg,
    "selfie_img": selfieImg,
    "proofpaper": proofpaper,
    "status": status,
    "remark": remark,
    "created_at": createdAt!.toIso8601String(),
    "updated_at": updatedAt!.toIso8601String(),
  };
}

class BankList {
  String? id;
  String? status;
  int? requiresVerification;
  int? requiresSupport;
  String? routingNumber;
  String? accountNumber;
  String? name1;
  String? currency;
  String? type;
  String? bankName;
  bool? achEnabled;
  bool? internationalBank;
  String? refId;

  BankList({
    this.id,
    this.status,
    this.requiresVerification,
    this.requiresSupport,
    this.routingNumber,
    this.accountNumber,
    this.name1,
    this.currency,
    this.type,
    this.bankName,
    this.achEnabled,
    this.internationalBank,
    this.refId,
  });

  factory BankList.fromJson(Map<String, dynamic> json) => BankList(
    id: json["id"],
    status: json["status"],
    requiresVerification: json["requires_verification"],
    requiresSupport: json["requires_support"],
    routingNumber: json["routing_number"],
    accountNumber: json["account_number"],
    name1: json["name1"],
    currency: json["currency"],
    type: json["type"],
    bankName: json["bank_name"],
    achEnabled: json["ach_enabled"],
    internationalBank: json["international_bank"],
    refId: json["ref_id"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "status": status,
    "requires_verification": requiresVerification,
    "requires_support": requiresSupport,
    "routing_number": routingNumber,
    "account_number": accountNumber,
    "name1": name1,
    "currency": currency,
    "type": type,
    "bank_name": bankName,
    "ach_enabled": achEnabled,
    "international_bank": internationalBank,
    "ref_id": refId,
  };
}
