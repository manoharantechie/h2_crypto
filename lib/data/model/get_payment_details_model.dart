
import 'dart:convert';

GetPaymentDetailsModel getPaymentDetailsModelFromJson(String str) => GetPaymentDetailsModel.fromJson(json.decode(str));

String getPaymentDetailsModelToJson(GetPaymentDetailsModel data) => json.encode(data.toJson());

class GetPaymentDetailsModel {
  GetPaymentDetailsModel({
    this.message,
    this.statusCode,
    this.data,
  });

  String? message;
  int? statusCode;
  GetPaymentDetails? data;

  factory GetPaymentDetailsModel.fromJson(Map<String, dynamic> json) => GetPaymentDetailsModel(
    message: json["message"],
    statusCode: json["status_code"],
    data: json["data"]==null?null:GetPaymentDetails.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "status_code": statusCode,
    "data": data!.toJson(),
  };
}

class GetPaymentDetails {
  GetPaymentDetails({
    this.id,
    this.userId,
    this.type,
    this.pay,
    this.isDelete,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  String? id;
  String? userId;
  List<String>? type;
  List<Payment>? pay;
  bool? isDelete;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;

  factory GetPaymentDetails.fromJson(Map<String, dynamic> json) => GetPaymentDetails(
    id: json["_id"],
    userId: json["userId"],
    type: List<String>.from(json["type"].map((x) => x)),
    pay: List<Payment>.from(json["pay"].map((x) => Payment.fromJson(x))),
    isDelete: json["isDelete"],
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
    v: json["__v"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "userId": userId,
    "type": List<dynamic>.from(type!.map((x) => x)),
    "pay": List<dynamic>.from(pay!.map((x) => x.toJson())),
    "isDelete": isDelete,
    "createdAt": createdAt!.toIso8601String(),
    "updatedAt": updatedAt!.toIso8601String(),
    "__v": v,
  };
}

class Payment {
  Payment({
    this.isstatus,
    this.name,
    this.Payment_name,
    this.accNum,
    this.ifsc,
    this.bankName,
    this.accType,
    this.branch,
    this.upiId,
    this.qrCode,
  });

  bool? isstatus;
  String? name;
  String? accNum;
  String? ifsc;
  String? bankName;
  String? Payment_name;
  String? accType;
  String? branch;
  String? upiId;
  String? qrCode;

  factory Payment.fromJson(Map<String, dynamic> json) => Payment(
    isstatus: json["isstatus"],
    name: json["name"],
    accNum: json["acc_num"] == null ? null : json["acc_num"],
    ifsc: json["ifsc"] == null ? null : json["ifsc"],
    bankName: json["bank_name"] == null ? null : json["bank_name"],
    Payment_name: json["Payment_name"] == null ? null : json["Payment_name"],
    accType: json["acc_type"] == null ? null : json["acc_type"],
    branch: json["branch"] == null ? null : json["branch"],
    upiId: json["upi_id"] == null ? null : json["upi_id"],
    qrCode: json["qr_code"] == null ? null : json["qr_code"],
  );

  Map<String, dynamic> toJson() => {
    "isstatus": isstatus,
    "name": name,
    "acc_num": accNum == null ? null : accNum,
    "ifsc": ifsc == null ? null : ifsc,
    "bank_name": bankName == null ? null : bankName,
    "Payment_name": Payment_name == null ? null : Payment_name,
    "acc_type": accType == null ? null : accType,
    "branch": branch == null ? null : branch,
    "upi_id": upiId == null ? null : upiId,
    "qr_code": qrCode == null ? null : qrCode,
  };
}
