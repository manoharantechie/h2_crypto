import 'dart:convert';

LoginDetailsModel loginDetailsModelFromJson(String str) => LoginDetailsModel.fromJson(json.decode(str));

String loginDetailsModelToJson(LoginDetailsModel data) => json.encode(data.toJson());

class LoginDetailsModel {
  LoginDetailsModel({
    this.success,
    this.result,
    this.message,
  });

  bool? success;
  LoginDetails? result;
  String? message;

  factory LoginDetailsModel.fromJson(Map<String, dynamic> json) => LoginDetailsModel(
    success: json["success"],
    result: json["result"]==null || json["result"]=="null"?LoginDetails():LoginDetails.fromJson(json["result"]),
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "result": result!.toJson(),
    "message": message,
  };
}

class LoginDetails {
  LoginDetails({
    this.accessToken,
    this.tokenType,
    this.expiresAt,
    this.userDetails,
  });

  String? accessToken;
  String? tokenType;
  DateTime? expiresAt;
  UserDetails? userDetails;

  factory LoginDetails.fromJson(Map<String, dynamic> json) => LoginDetails(
    accessToken: json["access_token"],
    tokenType: json["token_type"],
    expiresAt: DateTime.parse(json["expires_at"]),
    userDetails: UserDetails.fromJson(json["user_details"]),
  );

  Map<String, dynamic> toJson() => {
    "access_token": accessToken,
    "token_type": tokenType,
    "expires_at": expiresAt!.toIso8601String(),
    "user_details": userDetails!.toJson(),
  };
}

class UserDetails {
  UserDetails({
    this.firstName,
    this.lastName,
    this.email,
    this.kycVerify,
    this.emailVerify,
    this.smsVerify,
    this.sfoxId,
    this.sfoxKey,
  });

  String? firstName;
  String? lastName;
  String? email;
  dynamic kycVerify;
  dynamic emailVerify;
  dynamic smsVerify;
  String? sfoxId;
  dynamic sfoxKey;

  factory UserDetails.fromJson(Map<String, dynamic> json) => UserDetails(
    firstName: json["first_name"],
    lastName: json["last_name"],
    email: json["email"],
    kycVerify: json["kyc_verify"],
    emailVerify: json["email_verify"],
    smsVerify: json["sms_verify"],
    sfoxId: json["sfox_id"],
    sfoxKey: json["sfox_key"],
  );

  Map<String, dynamic> toJson() => {
    "first_name": firstName,
    "last_name": lastName,
    "email": email,
    "kyc_verify": kycVerify,
    "email_verify": emailVerify,
    "sms_verify": smsVerify,
    "sfox_id": sfoxId,
    "sfox_key": sfoxKey,
  };
}
