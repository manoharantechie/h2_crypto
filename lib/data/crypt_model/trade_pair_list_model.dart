import 'dart:convert';

TradePairListModel tradePairListModelFromJson(String str) => TradePairListModel.fromJson(json.decode(str));

String tradePairListModelToJson(TradePairListModel data) => json.encode(data.toJson());

class TradePairListModel {
  TradePairListModel({
    this.message,
    this.statusCode,
    this.data,
  });

  String? message;
  int? statusCode;
  List<TradePairList>? data;

  factory TradePairListModel.fromJson(Map<String, dynamic> json) => TradePairListModel(
    message: json["message"],
    statusCode: json["status_code"],
    data: json["data"]==null || json["data"]=="null"?[]:List<TradePairList>.from(json["data"].map((x) => TradePairList.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "status_code": statusCode,
    "data": List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class TradePairList {
  TradePairList({
    this.id,
    this.baseAsset,
    this.marketAsset,
    this.pairSymbol,
    this.minBuyPrice,
    this.maxBuyPrice,
    this.minSellPrice,
    this.maxSellPrice,
    this.minBuyQuantity,
    this.maxBuyQuantity,
    this.minSellQuantity,
    this.maxSellQuantity,
    this.pointValueBase,
    this.pointValueMarket,
    this.buyTradeCommission,
    this.sellTradeCommission,
    this.buyTradeCommissionType,
    this.sellTradeCommissionType,
    this.status,
    this.tradeCap,
    this.tradeCapValue,
    this.v,
    this.tradeLogic,
    this.displayName,
    this.favorite,
    this.baseWallet,
    this.marketWallet,
    this.price,
  });

  String? id;
  Asset? baseAsset;
  Asset? marketAsset;
  String? pairSymbol;
  dynamic minBuyPrice;
  dynamic maxBuyPrice;
  dynamic minSellPrice;
  dynamic maxSellPrice;
  dynamic minBuyQuantity;
  dynamic maxBuyQuantity;
  dynamic minSellQuantity;
  dynamic maxSellQuantity;
  dynamic pointValueBase;
  dynamic pointValueMarket;
  dynamic buyTradeCommission;
  dynamic sellTradeCommission;
  dynamic buyTradeCommissionType;
  dynamic sellTradeCommissionType;
  bool? status;
  dynamic tradeCap;
  dynamic tradeCapValue;
  dynamic tradeLogic;
  int? v;
  String? displayName;
  bool? favorite;
  Wallet? baseWallet;
  Wallet? marketWallet;
  dynamic price;

  factory TradePairList.fromJson(Map<String, dynamic> json) => TradePairList(
    id: json["_id"],
    baseAsset: json["base_asset"]==null || json["base_asset"]=="null"?Asset():Asset.fromJson(json["base_asset"]),
    marketAsset: json["market_asset"]==null || json["market_asset"]=="null"?Asset(): Asset.fromJson(json["market_asset"]),
    pairSymbol: json["pair_symbol"],
    minBuyPrice: json["min_buy_price"],
    maxBuyPrice: json["max_buy_price"],
    minSellPrice: json["min_sell_price"],
    maxSellPrice: json["max_sell_price"],
    minBuyQuantity: json["min_buy_quantity"],
    maxBuyQuantity: json["max_buy_quantity"],
    minSellQuantity: json["min_sell_quantity"],
    maxSellQuantity: json["max_sell_quantity"],
    pointValueBase: json["point_value_base"],
    pointValueMarket: json["point_value_market"],
    buyTradeCommission: json["buy_trade_commission"],
    sellTradeCommission: json["sell_trade_commission"],
    buyTradeCommissionType: json["buy_trade_commission_type"],
    sellTradeCommissionType: json["sell_trade_commission_type"],
    status: json["status"],
    tradeCap: json["trade_cap"],
    tradeCapValue: json["trade_cap_value"],
    tradeLogic: json["trade_logic"],
    v: json["__v"],
    displayName: json["display_name"],
    favorite: json["favorite"],
    price: json["price"],
    baseWallet: json["base_wallet"]==null || json["base_wallet"]=="null"?Wallet():Wallet.fromJson(json["base_wallet"]),
    marketWallet:json["market_wallet"]==null || json["market_wallet"]=="null"?Wallet(): Wallet.fromJson(json["market_wallet"]),
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "base_asset": baseAsset!.toJson(),
    "market_asset": marketAsset!.toJson(),
    "pair_symbol": pairSymbol,
    "min_buy_price": minBuyPrice,
    "max_buy_price": maxBuyPrice,
    "min_sell_price": minSellPrice,
    "max_sell_price": maxSellPrice,
    "min_buy_quantity": minBuyQuantity,
    "max_buy_quantity": maxBuyQuantity,
    "min_sell_quantity": minSellQuantity,
    "max_sell_quantity": maxSellQuantity,
    "point_value_base": pointValueBase,
    "point_value_market": pointValueMarket,
    "buy_trade_commission": buyTradeCommission,
    "sell_trade_commission": sellTradeCommission,
    "buy_trade_commission_type":buyTradeCommissionType,
    "sell_trade_commission_type": sellTradeCommissionType,
    "status": status,
    "trade_cap": tradeCap,
    "trade_cap_value": tradeCapValue,
    "trade_logic": tradeLogic,
    "__v": v,
    "display_name": displayName,
    "favorite": favorite,
    "price": price,
    "base_wallet": baseWallet!.toJson(),
    "market_wallet": marketWallet!.toJson(),
  };
}

class Asset {
  Asset({
    this.id,
    this.assetname,
    this.symbol,
    this.pointValue,
    this.netfee,
    this.type,
    this.withdrawCommission,
    this.withdrawLimitPerTransaction,
    this.minDeposit,
    this.minWithdraw,
    this.maxWithdraw,
    this.withdrawType,
    this.status,
    this.v,
  });

  String? id;
  String? assetname;
  String? symbol;
  int? pointValue;
  dynamic netfee;
  dynamic type;
  dynamic withdrawCommission;
  dynamic withdrawLimitPerTransaction;
  dynamic minDeposit;
  dynamic minWithdraw;
  dynamic maxWithdraw;
  dynamic withdrawType;
  bool? status;
  int? v;

  factory Asset.fromJson(Map<String, dynamic> json) => Asset(
    id: json["_id"],
    assetname: json["assetname"],
    symbol: json["symbol"],
    pointValue: json["point_value"],
    netfee: json["netfee"],
    type: json["type"],
    withdrawCommission: json["withdraw_commission"],
    withdrawLimitPerTransaction: json["withdraw_limit_per_transaction"],
    minDeposit: json["min_deposit"].toDouble(),
    minWithdraw: json["min_withdraw"].toDouble(),
    maxWithdraw: json["max_withdraw"],
    withdrawType: json["withdraw_type"],
    status: json["status"],
    v: json["__v"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "assetname": assetname,
    "symbol": symbol,
    "point_value": pointValue,
    "netfee": netfee,
    "type": type,
    "withdraw_commission": withdrawCommission,
    "withdraw_limit_per_transaction": withdrawLimitPerTransaction,
    "min_deposit": minDeposit,
    "min_withdraw": minWithdraw,
    "max_withdraw": maxWithdraw,
    "withdraw_type": withdrawType,
    "status": status,
    "__v": v,
  };
}



class Wallet {
  Wallet({
    this.id,
    this.user,
    this.asset,
    this.mugavari,
    this.destinationTag,
    this.balance,
    this.escrowBalance,
    this.sitBalance,
    this.spent,
    this.received,
    this.status,
    this.v,
    this.margin_balance,
    this.margin_escrow_balance,
    this.hold_balance,
    this.position_balance,
    this.futureEscrowBalance,
    this.futureBalance,
  });

  String? id;
  dynamic user;
  String? asset;
  List<Mugavari>? mugavari;
  int? destinationTag;
  dynamic balance;
  dynamic escrowBalance;
  dynamic sitBalance;
  dynamic spent;
  dynamic received;
  bool? status;
  int? v;
  dynamic margin_balance;
  dynamic margin_escrow_balance;
  dynamic hold_balance;
  dynamic position_balance;
  dynamic futureEscrowBalance;
  dynamic futureBalance;

  factory Wallet.fromJson(Map<String, dynamic> json) => Wallet(
    id: json["_id"],
    user: json["user"],
    asset: json["asset"],
    mugavari: List<Mugavari>.from(json["mugavari"].map((x) => Mugavari.fromJson(x))),
    destinationTag: json["destination_tag"],
    balance: json["balance"],
    escrowBalance: json["escrow_balance"],
    sitBalance: json["sit_balance"],
    spent: json["spent"],
    received: json["received"],
    status: json["status"],
    v: json["__v"],
    margin_balance: json["margin_balance"]==null?null:json["margin_balance"],
    margin_escrow_balance: json["margin_escrow_balance"]==null?null:json["margin_escrow_balance"],
    hold_balance: json["hold_balance"]==null?null:json["hold_balance"],
    position_balance: json["position_balance"]==null?null:json["position_balance"],
    futureEscrowBalance: json["future_escrow_balance"] == null ? null : json["future_escrow_balance"],
    futureBalance: json["future_balance"] == null ? null : json["future_balance"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "user": user,
    "asset": asset,
    "mugavari": List<dynamic>.from(mugavari!.map((x) => x.toJson())),
    "destination_tag": destinationTag,
    "balance": balance,
    "escrow_balance": escrowBalance,
    "sit_balance": sitBalance,
    "spent": spent,
    "received": received,
    "status": status,
    "__v": v,
    "margin_balance": margin_balance,
    "margin_escrow_balance": margin_escrow_balance,
    "hold_balance": hold_balance,
    "position_balance": position_balance,
    "future_escrow_balance": futureEscrowBalance == null ? null : futureEscrowBalance,
    "future_balance": futureBalance == null ? null : futureBalance,
  };
}

class Mugavari {
  Mugavari({
    this.userId,
    this.currency,
    this.address,
    this.addressTag,
    this.chain,
  });

  int? userId;
  dynamic currency;
  dynamic address;
  String? addressTag;
  String? chain;

  factory Mugavari.fromJson(Map<String, dynamic> json) => Mugavari(
    userId: json["userId"],
    currency: json["currency"],
    address: json["address"],
    addressTag: json["addressTag"],
    chain: json["chain"],
  );

  Map<String, dynamic> toJson() => {
    "userId": userId,
    "currency": currency,
    "address": address,
    "addressTag": addressTag,
    "chain": chain,
  };
}



