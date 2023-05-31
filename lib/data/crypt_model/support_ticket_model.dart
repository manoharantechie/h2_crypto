// To parse this JSON data, do
//
//     final supportTicketListData = supportTicketListDataFromJson(jsonString);

import 'dart:convert';

SupportTicketListData supportTicketListDataFromJson(String str) => SupportTicketListData.fromJson(json.decode(str));

String supportTicketListDataToJson(SupportTicketListData data) => json.encode(data.toJson());

class SupportTicketListData {
  bool? sucess;
  List<SupportTicketListResult>? result;
  String? message;

  SupportTicketListData({
     this.sucess,
     this.result,
     this.message,
  });

  factory SupportTicketListData.fromJson(Map<String, dynamic> json) => SupportTicketListData(
    sucess: json["sucess"],
    result: List<SupportTicketListResult>.from(json["result"].map((x) => SupportTicketListResult.fromJson(x))),
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "sucess": sucess,
    "result": List<dynamic>.from(result!.map((x) => x.toJson())),
    "message": message,
  };
}

class SupportTicketListResult {
  int? id;
  int? uid;
  String? ticketId;
  String? subject;
  String? message;
  int? status;
  int? closedStatus;
  DateTime? createdAt;
  DateTime? updatedAt;

  SupportTicketListResult({
     this.id,
     this.uid,
     this.ticketId,
     this.subject,
     this.message,
     this.status,
     this.closedStatus,
     this.createdAt,
     this.updatedAt,
  });

  factory SupportTicketListResult.fromJson(Map<String, dynamic> json) => SupportTicketListResult(
    id: json["id"],
    uid: json["uid"],
    ticketId: json["ticket_id"],
    subject: json["subject"],
    message: json["message"],
    status: json["status"],
    closedStatus: json["closed_status"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "uid": uid,
    "ticket_id": ticketId,
    "subject": subject,
    "message": message,
    "status": status,
    "closed_status": closedStatus,
    "created_at": createdAt!.toIso8601String(),
    "updated_at": updatedAt!.toIso8601String(),
  };
}
