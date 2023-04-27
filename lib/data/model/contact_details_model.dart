
import 'dart:convert';

ContactDetailsModel contactDetailsModelFromJson(String str) => ContactDetailsModel.fromJson(json.decode(str));

String contactDetailsModelToJson(ContactDetailsModel data) => json.encode(data.toJson());

class ContactDetailsModel {
  ContactDetailsModel({
    this.message,
    this.statusCode,
    this.data,
  });

  String? message;
  int? statusCode;
  ContactDetails? data;

  factory ContactDetailsModel.fromJson(Map<String, dynamic> json) => ContactDetailsModel(
    message: json["message"],
    statusCode: json["status_code"],
    data: ContactDetails.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "status_code": statusCode,
    "data": data!.toJson(),
  };
}

class ContactDetails {
  ContactDetails({
    this.phoneNo,
    this.email,
  });

  List<String>? phoneNo;
  List<String>? email;

  factory ContactDetails.fromJson(Map<String, dynamic> json) => ContactDetails(
    phoneNo: List<String>.from(json["phoneNo"].map((x) => x)),
    email: List<String>.from(json["email"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "phoneNo": List<dynamic>.from(phoneNo!.map((x) => x)),
    "email": List<dynamic>.from(email!.map((x) => x)),
  };
}
