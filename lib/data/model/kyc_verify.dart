import 'dart:convert';

KycVerifyDetails kycVerifyDetailsFromJson(String str) => KycVerifyDetails.fromJson(json.decode(str));

String kycVerifyDetailsToJson(KycVerifyDetails data) => json.encode(data.toJson());

class KycVerifyDetails {
  bool? success;
  String? message;
  KycVerifyResult? result;

  KycVerifyDetails({
    this.success,
    this.message,
    this.result,
  });

  factory KycVerifyDetails.fromJson(Map<String, dynamic> json) => KycVerifyDetails(
    success: json["success"],
    message: json["message"],
    result: KycVerifyResult.fromJson(json["result"]),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "result": result!.toJson(),
  };
}

class KycVerifyResult {
  dynamic uid;
  String? fname;
  String? lname;
  DateTime? dob;
  String? city;
  String? phoneNo;
  String? zipCode;
  String? state;
  String? genderType;
  String? country;
  String? addressLine1;
  String? addressLine2;
  String? idType;
  String? idNumber;
  String? frontImg;
  String? backImg;
  dynamic status;
  DateTime? updatedAt;
  DateTime? createdAt;
  dynamic id;

  KycVerifyResult({
    this.uid,
    this.fname,
    this.lname,
    this.dob,
    this.city,
    this.phoneNo,
    this.zipCode,
    this.state,
    this.genderType,
    this.country,
    this.addressLine1,
    this.addressLine2,
    this.idType,
    this.idNumber,
    this.frontImg,
    this.backImg,
    this.status,
    this.updatedAt,
    this.createdAt,
    this.id,
  });

  factory KycVerifyResult.fromJson(Map<String, dynamic> json) => KycVerifyResult(
    uid: json["uid"],
    fname: json["fname"],
    lname: json["lname"],
    dob: DateTime.parse(json["dob"]),
    city: json["city"],
    phoneNo: json["phone_no"],
    zipCode: json["zip_code"],
    state: json["state"],
    genderType: json["gender_type"],
    country: json["country"],
    addressLine1: json["address_line1"],
    addressLine2: json["address_line2"],
    idType: json["id_type"],
    idNumber: json["id_number"],
    frontImg: json["front_img"],
    backImg: json["back_img"],
    status: json["status"],
    updatedAt: DateTime.parse(json["updated_at"]),
    createdAt: DateTime.parse(json["created_at"]),
    id: json["id"],
  );

  Map<String, dynamic> toJson() => {
    "uid": uid,
    "fname": fname,
    "lname": lname,
    "dob": "${dob!.year.toString().padLeft(4, '0')}-${dob!.month.toString().padLeft(2, '0')}-${dob!.day.toString().padLeft(2, '0')}",
    "city": city,
    "phone_no": phoneNo,
    "zip_code": zipCode,
    "state": state,
    "gender_type": genderType,
    "country": country,
    "address_line1": addressLine1,
    "address_line2": addressLine2,
    "id_type": idType,
    "id_number": idNumber,
    "front_img": frontImg,
    "back_img": backImg,
    "status": status,
    "updated_at": updatedAt!.toIso8601String(),
    "created_at": createdAt!.toIso8601String(),
    "id": id,
  };
}
