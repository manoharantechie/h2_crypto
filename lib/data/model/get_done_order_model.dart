import 'dart:convert';

List<OrderDoneOrdersModel> orderDoneOrdersModelFromJson(String str) => List<OrderDoneOrdersModel>.from(json.decode(str).map((x) => OrderDoneOrdersModel.fromJson(x)));

String orderDoneOrdersModelToJson(List<OrderDoneOrdersModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class OrderDoneOrdersModel {
  dynamic id;
  dynamic sideId;
  String? action;
  dynamic algorithmId;
  String? algorithm;
  String? type;
  String? pair;
  double? quantity;
  dynamic price;
  dynamic amount;
  double? netMarketAmount;
  double? filled;
  double? vwap;
  double? filledAmount;
  double? fees;
  double? netProceeds;
  String? status;
  dynamic statusCode;
  String? routingOption;
  String? routingType;
  String? timeInForce;
  dynamic expires;
  DateTime? dateupdated;
  String? clientOrderId;
  String? userTxId;
  String? oAction;
  dynamic algoId;
  AlgorithmOptions? algorithmOptions;
  String? destination;

  OrderDoneOrdersModel({
    this.id,
    this.sideId,
    this.action,
    this.algorithmId,
    this.algorithm,
    this.type,
    this.pair,
    this.quantity,
    this.price,
    this.amount,
    this.netMarketAmount,
    this.filled,
    this.vwap,
    this.filledAmount,
    this.fees,
    this.netProceeds,
    this.status,
    this.statusCode,
    this.routingOption,
    this.routingType,
    this.timeInForce,
    this.expires,
    this.dateupdated,
    this.clientOrderId,
    this.userTxId,
    this.oAction,
    this.algoId,
    this.algorithmOptions,
    this.destination,
  });

  factory OrderDoneOrdersModel.fromJson(Map<String, dynamic> json) => OrderDoneOrdersModel(
    id: json["id"],
    sideId: json["side_id"],
    action: json["action"],
    algorithmId: json["algorithm_id"],
    algorithm: json["algorithm"],
    type: json["type"],
    pair: json["pair"],
    quantity: json["quantity"].toDouble(),
    price: json["price"],
    amount: json["amount"],
    netMarketAmount: json["net_market_amount"].toDouble(),
    filled: json["filled"].toDouble(),
    vwap: json["vwap"].toDouble(),
    filledAmount: json["filled_amount"].toDouble(),
    fees: json["fees"].toDouble(),
    netProceeds: json["net_proceeds"].toDouble(),
    status: json["status"],
    statusCode: json["status_code"],
    routingOption: json["routing_option"],
    routingType: json["routing_type"],
    timeInForce: json["time_in_force"],
    expires: json["expires"],
    dateupdated: DateTime.parse(json["dateupdated"]),
    clientOrderId: json["client_order_id"],
    userTxId: json["user_tx_id"],
    oAction: json["o_action"],
    algoId: json["algo_id"],
    algorithmOptions: AlgorithmOptions.fromJson(json["algorithm_options"]),
    destination: json["destination"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "side_id": sideId,
    "action": action,
    "algorithm_id": algorithmId,
    "algorithm": algorithm,
    "type": type,
    "pair": pair,
    "quantity": quantity,
    "price": price,
    "amount": amount,
    "net_market_amount": netMarketAmount,
    "filled": filled,
    "vwap": vwap,
    "filled_amount": filledAmount,
    "fees": fees,
    "net_proceeds": netProceeds,
    "status": status,
    "status_code": statusCode,
    "routing_option": routingOption,
    "routing_type": routingType,
    "time_in_force": timeInForce,
    "expires": expires,
    "dateupdated": dateupdated!.toIso8601String(),
    "client_order_id": clientOrderId,
    "user_tx_id": userTxId,
    "o_action": oAction,
    "algo_id": algoId,
    "algorithm_options": algorithmOptions!.toJson(),
    "destination": destination,
  };
}

class AlgorithmOptions {
  dynamic maxSlippage;

  AlgorithmOptions({
    this.maxSlippage,
  });

  factory AlgorithmOptions.fromJson(Map<String, dynamic> json) => AlgorithmOptions(
    maxSlippage: json["max_slippage"],
  );

  Map<String, dynamic> toJson() => {
    "max_slippage": maxSlippage,
  };
}
