
import 'dart:convert';

PaymentMethodModel paymentMethodModelFromJson(String str) => PaymentMethodModel.fromJson(json.decode(str));

String paymentMethodModelToJson(PaymentMethodModel data) => json.encode(data.toJson());

class PaymentMethodModel {
  PaymentMethodModel({
    this.message,
    this.statusCode,
    this.data,
  });

  String? message;
  int? statusCode;
  PaymentMethod? data;

  factory PaymentMethodModel.fromJson(Map<String, dynamic> json) => PaymentMethodModel(
    message: json["message"],
    statusCode: json["status_code"],
    data: PaymentMethod.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "status_code": statusCode,
    "data": data!.toJson(),
  };
}

class PaymentMethod {
  PaymentMethod({
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
  List<Pay>? pay;
  bool? isDelete;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;

  factory PaymentMethod.fromJson(Map<String, dynamic> json) => PaymentMethod(
    id: json["_id"],
    userId: json["userId"],
    type: List<String>.from(json["type"].map((x) => x)),
    pay: List<Pay>.from(json["pay"].map((x) => Pay.fromJson(x))),
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

class Pay {
  Pay({
    this.isstatus,
    this.name,
    this.upiId,
    this.qrCode,
  });

  bool? isstatus;
  String? name;
  String? upiId;
  String? qrCode;

  factory Pay.fromJson(Map<String, dynamic> json) => Pay(
    isstatus: json["isstatus"],
    name: json["name"],
    upiId: json["upi_id"],
    qrCode: json["qr_code"],
  );

  Map<String, dynamic> toJson() => {
    "isstatus": isstatus,
    "name": name,
    "upi_id": upiId,
    "qr_code": qrCode,
  };
}
