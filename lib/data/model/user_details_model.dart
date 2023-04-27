import 'dart:convert';

UserDetailsModel userDetailsModelFromJson(String str) => UserDetailsModel.fromJson(json.decode(str));

String userDetailsModelToJson(UserDetailsModel data) => json.encode(data.toJson());

class UserDetailsModel {
  UserDetailsModel({
    this.message,
    this.statusCode,
    this.data,
  });

  String? message;
  int? statusCode;
  UserDetails? data;

  factory UserDetailsModel.fromJson(Map<String, dynamic> json) => UserDetailsModel(
    message: json["message"],
    statusCode: json["status_code"],
    data: json["data"]=="[]"|| json["data"]==null?UserDetails():UserDetails.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "status_code": statusCode,
    "data": data!.toJson(),
  };
}

class UserDetails {
  UserDetails({
    this.id,
    this.signupType,
    this.emailVerify,
    this.mobileVerify,
    this.kycStatus,
    this.referralId,
    this.referedBy,
    this.f2AEnable,
    this.name,
  });

  String? id;
  int? signupType;
  bool? emailVerify;
  bool? mobileVerify;
  int? kycStatus;
  String? referralId;
  dynamic referedBy;
  bool? f2AEnable;
  String? name;

  factory UserDetails.fromJson(Map<String, dynamic> json) => UserDetails(
    id: json["_id"],
    signupType: json["signup_type"],
    emailVerify: json["email_verify"],
    mobileVerify: json["mobile_verify"],
    kycStatus: json["kyc_status"],
    referralId: json["referral_id"],
    referedBy: json["refered_by"],
    f2AEnable: json["f2A_enable"],
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "signup_type": signupType,
    "email_verify": emailVerify,
    "mobile_verify": mobileVerify,
    "kyc_status": kycStatus,
    "referral_id": referralId,
    "refered_by": referedBy,
    "f2A_enable": f2AEnable,
    "name": name,
  };
}
