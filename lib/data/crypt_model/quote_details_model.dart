import 'dart:convert';

QuoteDetailsModel quoteDetailsModelFromJson(String str) => QuoteDetailsModel.fromJson(json.decode(str));

String quoteDetailsModelToJson(QuoteDetailsModel data) => json.encode(data.toJson());

class QuoteDetailsModel {
  bool? success;
  QuoteDetails? result;
  String? message;

  QuoteDetailsModel({
    this.success,
    this.result,
    this.message,
  });

  factory QuoteDetailsModel.fromJson(Map<String, dynamic> json) => QuoteDetailsModel(
    success: json["success"],
    result:json["result"]==null || json["result"]=="null" ?QuoteDetails():QuoteDetails.fromJson(json["result"]),
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "result": result!.toJson(),
    "message": message,
  };
}

class QuoteDetails {
  String? quoteId;
  String? pair;
  String? side;
  DateTime? dateExpiry;
  DateTime? dateQuote;
  double? amount;
  double? quantity;
  double? buyPrice;

  QuoteDetails({
    this.quoteId,
    this.pair,
    this.side,
    this.dateExpiry,
    this.dateQuote,
    this.amount,
    this.quantity,
    this.buyPrice,
  });

  factory QuoteDetails.fromJson(Map<String, dynamic> json) => QuoteDetails(
    quoteId: json["quote_id"],
    pair: json["pair"],
    side: json["side"],
    dateExpiry: DateTime.parse(json["date_expiry"]),
    dateQuote: DateTime.parse(json["date_quote"]),
    amount: json["amount"].toDouble(),
    quantity: json["quantity"].toDouble(),
    buyPrice: json["buy_price"].toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "quote_id": quoteId,
    "pair": pair,
    "side": side,
    "date_expiry": dateExpiry!.toIso8601String(),
    "date_quote": dateQuote!.toIso8601String(),
    "amount": amount,
    "quantity": quantity,
    "buy_price": buyPrice,
  };
}
