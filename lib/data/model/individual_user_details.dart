
import 'dart:convert';

IndividualUserDetailsModel individualUserDetailsModelFromJson(String str) => IndividualUserDetailsModel.fromJson(json.decode(str));

String individualUserDetailsModelToJson(IndividualUserDetailsModel data) => json.encode(data.toJson());

class IndividualUserDetailsModel {
  bool? success;
  IndividualUserResult? result;
  String? message;

  IndividualUserDetailsModel({
    this.success,
    this.result,
    this.message,
  });

  factory IndividualUserDetailsModel.fromJson(Map<String, dynamic> json) => IndividualUserDetailsModel(
    success: json["success"],
    result: IndividualUserResult.fromJson(json["result"]),
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "result": result!.toJson(),
    "message": message,
  };
}

class IndividualUserResult {
  dynamic id;
  String? role;
  String? clientAccount;
  String? sfoxAccess;
  DateTime? expiredAccess;
  String? firstName;
  String? lastName;
  String? email;
  DateTime? emailVerifiedAt;
  String? phoneCountry;
  String? phoneNo;
  dynamic phoneVerified;
  dynamic country;
  String? nationality;
  DateTime? dob;
  dynamic profileimg;
  dynamic address;
  dynamic twofa;
  dynamic twofaStatus;
  dynamic google2FaVerify;
  dynamic emailVerify;
  dynamic kycVerify;
  dynamic companyType;
  dynamic businessName;
  dynamic businessCountry;
  dynamic businessEmail;
  dynamic businessFirstName;
  dynamic businessMiddleName;
  dynamic businessLastName;
  dynamic status;
  String? statusText;
  dynamic isEmail;
  dynamic isSms;
  dynamic freeze;
  dynamic reason;
  dynamic verifyToken;
  String? ipaddr;
  dynamic apiToken;
  String? device;
  String? location;
  String? type;
  String? mobileUser;
  dynamic isAddress;
  String? referralId;
  dynamic parentId;
  dynamic activationToken;
  DateTime? createdAt;
  DateTime? updatedAt;

  IndividualUserResult({
    this.id,
    this.role,
    this.clientAccount,
    this.sfoxAccess,
    this.expiredAccess,
    this.firstName,
    this.lastName,
    this.email,
    this.emailVerifiedAt,
    this.phoneCountry,
    this.phoneNo,
    this.phoneVerified,
    this.country,
    this.nationality,
    this.dob,
    this.profileimg,
    this.address,
    this.twofa,
    this.twofaStatus,
    this.google2FaVerify,
    this.emailVerify,
    this.kycVerify,
    this.companyType,
    this.businessName,
    this.businessCountry,
    this.businessEmail,
    this.businessFirstName,
    this.businessMiddleName,
    this.businessLastName,
    this.status,
    this.statusText,
    this.isEmail,
    this.isSms,
    this.freeze,
    this.reason,
    this.verifyToken,
    this.ipaddr,
    this.apiToken,
    this.device,
    this.location,
    this.type,
    this.mobileUser,
    this.isAddress,
    this.referralId,
    this.parentId,
    this.activationToken,
    this.createdAt,
    this.updatedAt,
  });

  factory IndividualUserResult.fromJson(Map<String, dynamic> json) => IndividualUserResult(
    id: json["id"],
    role: json["role"],
    clientAccount: json["client_account"],
    sfoxAccess: json["sfox_access"],
    expiredAccess: DateTime.parse(json["expired_access"]),
    firstName: json["first_name"],
    lastName: json["last_name"],
    email: json["email"],
    emailVerifiedAt: DateTime.parse(json["email_verified_at"]),
    phoneCountry: json["phone_country"],
    phoneNo: json["phone_no"],
    phoneVerified: json["phone_verified"],
    country: json["country"],
    nationality: json["nationality"],
    dob: DateTime.parse(json["dob"]),
    profileimg: json["profileimg"],
    address: json["address"],
    twofa: json["twofa"],
    twofaStatus: json["twofa_status"],
    google2FaVerify: json["google2fa_verify"],
    emailVerify: json["email_verify"],
    kycVerify: json["kyc_verify"],
    companyType: json["company_type"],
    businessName: json["business_name"],
    businessCountry: json["business_country"],
    businessEmail: json["business_email"],
    businessFirstName: json["business_first_name"],
    businessMiddleName: json["business_middle_name"],
    businessLastName: json["business_last_name"],
    status: json["status"],
    statusText: json["status_text"],
    isEmail: json["is_email"],
    isSms: json["is_sms"],
    freeze: json["freeze"],
    reason: json["reason"],
    verifyToken: json["verifyToken"],
    ipaddr: json["ipaddr"],
    apiToken: json["api_token"],
    device: json["device"],
    location: json["location"],
    type: json["type"],
    mobileUser: json["mobile_user"],
    isAddress: json["is_address"],
    referralId: json["referral_id"],
    parentId: json["parent_id"],
    activationToken: json["activation_token"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "role": role,
    "client_account": clientAccount,
    "sfox_access": sfoxAccess,
    "expired_access": expiredAccess!.toIso8601String(),
    "first_name": firstName,
    "last_name": lastName,
    "email": email,
    "email_verified_at": emailVerifiedAt!.toIso8601String(),
    "phone_country": phoneCountry,
    "phone_no": phoneNo,
    "phone_verified": phoneVerified,
    "country": country,
    "nationality": nationality,
    "dob": "${dob!.year.toString().padLeft(4, '0')}-${dob!.month.toString().padLeft(2, '0')}-${dob!.day.toString().padLeft(2, '0')}",
    "profileimg": profileimg,
    "address": address,
    "twofa": twofa,
    "twofa_status": twofaStatus,
    "google2fa_verify": google2FaVerify,
    "email_verify": emailVerify,
    "kyc_verify": kycVerify,
    "company_type": companyType,
    "business_name": businessName,
    "business_country": businessCountry,
    "business_email": businessEmail,
    "business_first_name": businessFirstName,
    "business_middle_name": businessMiddleName,
    "business_last_name": businessLastName,
    "status": status,
    "status_text": statusText,
    "is_email": isEmail,
    "is_sms": isSms,
    "freeze": freeze,
    "reason": reason,
    "verifyToken": verifyToken,
    "ipaddr": ipaddr,
    "api_token": apiToken,
    "device": device,
    "location": location,
    "type": type,
    "mobile_user": mobileUser,
    "is_address": isAddress,
    "referral_id": referralId,
    "parent_id": parentId,
    "activation_token": activationToken,
    "created_at": createdAt!.toIso8601String(),
    "updated_at": updatedAt!.toIso8601String(),
  };
}
