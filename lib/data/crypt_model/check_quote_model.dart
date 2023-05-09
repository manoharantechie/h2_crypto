import 'dart:convert';

CheckQuoteModel checkQuoteModelFromJson(String str) => CheckQuoteModel.fromJson(json.decode(str));

String checkQuoteModelToJson(CheckQuoteModel data) => json.encode(data.toJson());

class CheckQuoteModel {
  bool? success;
  CheckQuoteResult? result;
  String? message;

  CheckQuoteModel({
    this.success,
    this.result,
    this.message,
  });

  factory CheckQuoteModel.fromJson(Map<String, dynamic> json) => CheckQuoteModel(
    success: json["success"],
    result: CheckQuoteResult.fromJson(json["result"]),
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "result": result!.toJson(),
    "message": message,
  };
}

class CheckQuoteResult {
  String? quoteId;
  String? pair;
  String? side;
  DateTime? dateExpiry;
  DateTime? dateQuote;
  double? amount;
  double? quantity;
  double? buyPrice;

  CheckQuoteResult({
    this.quoteId,
    this.pair,
    this.side,
    this.dateExpiry,
    this.dateQuote,
    this.amount,
    this.quantity,
    this.buyPrice,
  });

  factory CheckQuoteResult.fromJson(Map<String, dynamic> json) => CheckQuoteResult(
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
