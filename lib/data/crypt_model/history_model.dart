import 'dart:convert';

TransHistoryListModel transHistoryListModelFromJson(String str) => TransHistoryListModel.fromJson(json.decode(str));

String transHistoryListModelToJson(TransHistoryListModel data) => json.encode(data.toJson());

class TransHistoryListModel {
  bool? success;
  List<TransHistoryList>? result;
  String? message;

  TransHistoryListModel({
    this.success,
    this.result,
    this.message,
  });

  factory TransHistoryListModel.fromJson(Map<String, dynamic> json) => TransHistoryListModel(
    success: json["success"],
    result: List<TransHistoryList>.from(json["result"].map((x) => TransHistoryList.fromJson(x))),
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "result": List<dynamic>.from(result!.map((x) => x.toJson())),
    "message": message,
  };
}

class TransHistoryList {
  dynamic id;
  dynamic atxid;
  String? orderId;
  String? clientOrderId;
  DateTime? day;
  String? action;
  String? currency;
  String? memo;
  dynamic amount;
  dynamic netProceeds;
  dynamic price;
  dynamic fees;
  String? status;
  String? holdExpires;
  String? txHash;
  String? algoName;
  String? algoId;
  dynamic accountBalance;
  dynamic accountTransferFee;
  String? description;
  String? walletDisplayId;
  String? addedByUserEmail;
  String? symbol;
  dynamic timestamp;

  TransHistoryList({
    this.id,
    this.atxid,
    this.orderId,
    this.clientOrderId,
    this.day,
    this.action,
    this.currency,
    this.memo,
    this.amount,
    this.netProceeds,
    this.price,
    this.fees,
    this.status,
    this.holdExpires,
    this.txHash,
    this.algoName,
    this.algoId,
    this.accountBalance,
    this.accountTransferFee,
    this.description,
    this.walletDisplayId,
    this.addedByUserEmail,
    this.symbol,
    this.timestamp,
  });

  factory TransHistoryList.fromJson(Map<String, dynamic> json) => TransHistoryList(
    id: json["id"],
    atxid: json["atxid"],
    orderId: json["order_id"],
    clientOrderId: json["client_order_id"],
    day: DateTime.parse(json["day"]),
    action: json["action"],
    currency: json["currency"],
    memo: json["memo"],
    amount: json["amount"].toDouble(),
    netProceeds: json["net_proceeds"].toDouble(),
    price: json["price"].toDouble(),
    fees: json["fees"].toDouble(),
    status: json["status"],
    holdExpires: json["hold_expires"],
    txHash: json["tx_hash"],
    algoName: json["algo_name"],
    algoId: json["algo_id"],
    accountBalance: json["account_balance"].toDouble(),
    accountTransferFee: json["AccountTransferFee"],
    description: json["description"],
    walletDisplayId: json["wallet_display_id"],
    addedByUserEmail: json["added_by_user_email"],
    symbol: json["symbol"],
    timestamp: json["timestamp"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "atxid": atxid,
    "order_id": orderId,
    "client_order_id": clientOrderId,
    "day": day!.toIso8601String(),
    "action": action,
    "currency": currency,
    "memo": memo,
    "amount": amount,
    "net_proceeds": netProceeds,
    "price": price,
    "fees": fees,
    "status": status,
    "hold_expires": holdExpires,
    "tx_hash": txHash,
    "algo_name": algoName,
    "algo_id": algoId,
    "account_balance": accountBalance,
    "AccountTransferFee": accountTransferFee,
    "description": description,
    "wallet_display_id": walletDisplayId,
    "added_by_user_email": addedByUserEmail,
    "symbol": symbol,
    "timestamp": timestamp,
  };
}
