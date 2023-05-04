import 'dart:convert';

class OpenOrderList {
  OpenOrderList({
    this.id,
    this.userId,
    this.filled_amount,
    this.filled,
    this.pair,
    this.orderType,
    this.price,
    this.volume,
    this.fees,
    this.date,
    this.status
  });

  String? id;
  dynamic userId;
  dynamic filled;
  dynamic filled_amount;

  dynamic pair;
  dynamic orderType;
  dynamic price;
  dynamic volume;

  dynamic fees;
  String? date;
  String? status;
}
