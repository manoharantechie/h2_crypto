import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:moment_dart/moment_dart.dart';
import 'package:h2_crypto/common/custom_widget.dart';
import 'package:h2_crypto/data/api_utils.dart';
import 'package:h2_crypto/data/model/allopenorderhistory_model.dart';
import 'package:h2_crypto/data/model/common_model.dart';
import 'package:h2_crypto/data/model/future_open_order_model.dart';
import 'package:h2_crypto/data/model/margin_loan_model.dart';
import 'package:h2_crypto/data/model/margin_repay_loan_model.dart';
import 'package:h2_crypto/data/model/margin_trade_model.dart';
import 'package:h2_crypto/data/model/margin_transfer_model.dart';
import 'package:h2_crypto/data/model/open_order_list_model.dart';
import 'package:h2_crypto/data/model/orderbook_model.dart';
import 'package:h2_crypto/data/model/position_model.dart';
import 'package:h2_crypto/data/model/socket_model.dart';
import 'package:h2_crypto/data/model/trade_pair_detail_data.dart';
import 'package:h2_crypto/data/model/trade_pair_list_model.dart';
import 'package:h2_crypto/data/model/wallet_bal_model.dart';
import 'package:h2_crypto/data/model/wallet_list_model.dart';
import 'package:h2_crypto/screens/trade/chart_screen.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/status.dart' as status;

import '../../../common/colors.dart';
import '../../../common/localization/localizations.dart';
import '../../../common/theme/custom_theme.dart';
import 'package:socket_io_client/socket_io_client.dart';

class TradeScreen extends StatefulWidget {
  const TradeScreen({Key? key}) : super(key: key);

  @override
  State<TradeScreen> createState() => _SellTradeScreenState();
}

class _SellTradeScreenState extends State<TradeScreen>
    with TickerProviderStateMixin {
  List<String> marginType = ["Loan", " Repay", "Transfer"];
  List<String> chartTime = ["Limit Order", "Market Order", "Stop-Limit"];
  List<String> chartTimeFuture = ["Limit Order", "Market Order"];
  List<String> transferType = ["Spot-Margin", "Margin-Spot"];
  List<String> tradeType = ["Spot", "Margin", "Future"];
  List<String> transferFutureType = ["Spot-Future", "Future-Spot"];
  String selectedTime = "";

  List<TradePairList> tradePair = [];
  List<TradePairList> searchPair = [];
  TradePairList? selectPair;
  WalletList? selectAsset;
  final _formKey = GlobalKey<FormState>();
  List<OpenOrderList> openOrders = [];
  List<Trade> orderBook = [];
  List<Trade> orderSellBook = [];
  List<OpenOrderList> AllopenOrders = [];
  List<FutureOpenOrderList> FutureopenOrders = [];
  List<PositionList> Futureposition = [];
  List<AllOpenOrderList> historyOrders = [];
  bool buySell = true;
  bool loanErr = false;
  bool marginbuySell = true;
  late TabController _tabController, tradeTabController;
  bool spotOption = true;
  bool marginOption = false;
  bool marginVisibleOption = false;
  bool tradeOrder = true;
  bool loanVisibleOption = false;
  bool normalTrade = false;
  bool futureOption = false;
  TextEditingController amtController = TextEditingController();
  TextEditingController coinController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController stopPriceController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  TextEditingController marginpriceController = TextEditingController();
  TextEditingController marginamountController = TextEditingController();
  APIUtils apiUtils = APIUtils();
  bool buyOption = true;
  bool sellOption = true;
  final List<String> _decimal = ["0.00000001", "0.0001", "0.01"];
  int decimalIndex = 8;
  bool cancelOrder = false;
  ScrollController controller = ScrollController();
  bool loading = false;
  List<LikeStatus> cheerList = [];

  TextEditingController searchController = TextEditingController();
  FocusNode searchFocus = FocusNode();
  TextEditingController searchAssetController = TextEditingController();
  FocusNode searchAssetFocus = FocusNode();
  bool enableTrade = false;
  bool enableStopLimit = false;
  bool enableLoan = true;
  bool leverageLoan = true;
  String balance = "0.00";
  String escrow = "0.00";
  String totalBalance = "0.00";
  String coinName = "";
  String coinTwoName = "";
  String selectPairSymbol = "";
  String assetName = "";
  String totalAmount = "0.00";
  String price = "0.00";
  String stopPrice = "0.00";
  String tradeAmount = "0.00";
  String takerFee = "0.00";
  String takerFeeValue = "0.00";
  double _currentSliderValue = 0;
  double _leverageSliderValue = 0;
  int _levSliderValue = 0;
  int _tLevSliderValue = 0;

  bool favValue = false;

  String selectedIndex = "";
  String selectedAssetIndex = "";
  String leverageVal = "1";
  String tleverageVal = "1";
  IOWebSocketChannel? channelOpenOrder;
  IOWebSocketChannel? livePriceData;
  List<BuySellData> buyData = [];
  List<BuySellData> marginBuyData = [];
  List<BuySellData> sellData = [];
  List<BuySellData> marginSellData = [];
  List<WalletList> coinList = [];
  List<WalletList> searchAssetPair = [];

  String firstCoin = "";
  String secondCoin = "";

  String livePrice = "0.00";

  bool socketLoader = false;
  String selectedDecimal = "";
  String selectedMarginType = " ";
  String selectedMarketOrderType = "";
  String selectedMarginTradeType = "";
  String selectedHistoryTradeType = "";
  String marginTradeAmount = "0.00";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    selectedTime = chartTime.first;
    selectedMarketOrderType = chartTime.first;
    selectedMarginType = marginType.first;
    selectedHistoryTradeType = tradeType.first;
    selectedMarginTradeType = transferType.first;
    _tabController = TabController(vsync: this, length: 2);
    tradeTabController = TabController(vsync: this, length: 3);
    selectedDecimal = _decimal.first;
    loading = true;
    getCoinList();
    getLoanCoinList();
    channelOpenOrder = IOWebSocketChannel.connect(
        Uri.parse("wss://api.huobi.pro/ws"),
        pingInterval: Duration(seconds: 30));
    livePriceData = IOWebSocketChannel.connect(
        Uri.parse("wss://api.huobi.pro/ws"),
        pingInterval: Duration(seconds: 30));
    getAllOpenOrder();
    getAllHistory("0");
  }

  socketData() {
    setState(() {
      buyData.clear();
      sellData.clear();
      buyData = [];
      sellData = [];
    });
    channelOpenOrder!.stream.listen(
      (data) {
        if (data != null || data != "null") {
          List<int> gzipBytes = data;
          List<int> stringBytes = gzip.decode(gzipBytes);
          var datas = utf8.decode(stringBytes);

          var decode = jsonDecode(datas);
          if (mounted) {
            setState(() {
              if (decode.toString().contains('tick')) {
                loading = false;
                buyData.clear();
                sellData.clear();
                buyData = [];
                sellData = [];
                var list1 = List<dynamic>.from(decode['tick']['bids']);
                var list2 = List<dynamic>.from(decode['tick']['asks']);

                for (int m = 0; m < list1.length; m++) {
                  if (double.parse(list1[m][1].toString()) > 0) {
                    buyData.add(BuySellData(
                      list1[m][0].toString(),
                      list1[m][1].toString(),
                    ));
                  }
                  if (list2[m].toString() != null) {
                    if (double.parse(list2[m][1].toString()) > 0) {
                      sellData.add(BuySellData(
                        list2[m][0].toString(),
                        list2[m][1].toString(),
                      ));
                    }
                  }
                }
              }
            });
          }
        }
      },
      onDone: () async {
        await Future.delayed(Duration(seconds: 10));
        var messageJSON = {
          "sub": "market." +
              firstCoin.toLowerCase() +
              secondCoin.toLowerCase() +
              ".depth.step0",
          "id": "id1"
        };
        channelOpenOrder = IOWebSocketChannel.connect(
            Uri.parse("wss://api.huobi.pro/ws"),
            pingInterval: Duration(seconds: 30));

        channelOpenOrder!.sink.add(json.encode(messageJSON));
        socketData();
      },
      onError: (error) => print("Err" + error),
    );
  }

  socketLivepriceData() {
    // print("LiveMano");
    String pong = "";
    livePriceData!.stream.listen(
      (data) {
        if (data != null || data != "null") {
          List<int> gzipBytes = data;
          List<int> stringBytes = gzip.decode(gzipBytes);
          var datas = utf8.decode(stringBytes);

          var decode = jsonDecode(datas);
          /*   print("Mano");
          print(decode);*/

          if (mounted) {
            setState(() {
              if (decode['tick'] == null || decode['tick'] == "null") {
                //   livePrice="0.00";

                if (decode.toString().contains("ping")) {
                  pong = decode['ping'].toString();
                }
              } else {
                livePrice = decode['tick']['lastPrice'].toString();
              }
            });
          }
        }
      },
      onDone: () async {
        var messageJSON = {
          "pong": pong,
        };

        livePriceData = IOWebSocketChannel.connect(
            Uri.parse("wss://api.huobi.pro/ws"),
            pingInterval: Duration(seconds: 10));

        livePriceData!.sink.add("pong:$pong");
        socketLivepriceData();
      },
      onError: (error) {},
    );
  }

  Widget comingsoon() {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Center(
        child: Text(
          "Coming Soon..!",
          style: CustomWidget(context: context).CustomSizedTextStyle(16.0,
              Theme.of(context).splashColor, FontWeight.w400, 'FontRegular'),
        ),
      ),
    );
  }

  localSocketData() async {
    await apiUtils.socketChatConnection(() {
      print("Hello" + apiUtils.socketChat!.connected.toString());
      if (apiUtils.socketChat!.connected) {
        apiUtils.socketChat!.on(selectPairSymbol.toLowerCase(), (data) {
          if (data != null) {
            if (mounted) {
              setState(() {
                print(data);
                SocketModel loginData = SocketModel.fromJson(data);
                if (loginData.pair.toString().toLowerCase() ==
                    selectPairSymbol.toLowerCase()) {
                  orderBook = [];
                  orderSellBook = [];
                  marginBuyData = [];
                  marginSellData = [];
                  orderBook = loginData.buytrade!;
                  orderSellBook = loginData.selltrade!;
                  if (normalTrade) {
                    for (int i = 0; i < orderBook.length; i++) {
                      marginBuyData.add(BuySellData(
                        orderBook[i].id.toString(),
                        orderBook[i].volume.toString(),
                      ));
                    }
                    for (int i = 0; i < orderSellBook.length; i++) {
                      marginSellData.add(BuySellData(
                        orderSellBook[i].id.toString(),
                        orderSellBook[i].volume.toString(),
                      ));
                    }
                  }
                }
              });

            }
          }
        });
        apiUtils.socketChat!.onDisconnect((_) => print('disconnect Socket'));
      } else {
        print("Error");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return
        /* Container(
      height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.all(10.0),
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    stops: [
                      0.1,
                      0.5,
                      0.9,
                    ],
                    colors: [
                      CustomTheme.of(context).primaryColor,
                      CustomTheme.of(context).backgroundColor,
                      CustomTheme.of(context).accentColor,
                    ])),
      child: DefaultTabController(
        length: 3,
        child: Scaffold(
          backgroundColor: CustomTheme.of(context).primaryColor,
          appBar: AppBar(
            toolbarHeight: 60.0,
            elevation: 0,
            backgroundColor:Colors.transparent,
           title: TabBar(
             padding: EdgeInsets.zero,
             indicatorPadding: EdgeInsets.zero,
             labelPadding: EdgeInsets.zero,
             isScrollable: false,
             labelColor: CustomTheme.of(context).buttonColor,
             // labelPadding: EdgeInsets.only(right: 15.0,left: 15.0),
             //<-- selected text color
             unselectedLabelColor: CustomTheme.of(context)
                 .splashColor
                 .withOpacity(0.5),
             // isScrollable: true,
             onTap: (value) {
               setState(() {
                 if(value.toString() == "0"){
                   spotOption=true;
                   marginOption=false;
                   futureOption=false;
                 }if(value.toString()== "1"){
                   spotOption=false;
                   marginOption=true;
                   futureOption=false;
                 }else if(value.toString()=="2"){
                   spotOption=false;
                   marginOption=false;
                   futureOption=true;
                 }
                 print(value.toString());
               });
             },
             indicator:BoxDecoration(),
             */ /*BoxDecoration(
               border: Border.all(
                 color: CustomTheme.of(context)
                     .buttonColor,
                 width: 0.5,
               ),
             ),*/ /*
             indicatorColor: Colors.transparent,
             tabs: <Tab>[
               Tab(
                 child: Container(
                   decoration: BoxDecoration(
                       border: Border.all(
                           color: spotOption
                               ? CustomTheme.of(context)
                               .buttonColor
                               : CustomTheme.of(context)
                               .splashColor
                               .withOpacity(0.5),
                           width: spotOption ? 1.5 : 0.5)),
                   child: Center(
                       child: Padding(
                         padding: spotOption
                             ? EdgeInsets.only(
                             top: 6.0, bottom: 6.0)
                             : EdgeInsets.only(
                             top: 7.0, bottom: 7.0),
                         child: Text(
                           AppLocalizations.instance
                               .text("loc_sell_trade_txt1"),
                           style: CustomWidget(context: context)
                               .CustomSizedTextStyle(
                               13.0,
                               spotOption
                                   ? CustomTheme.of(context)
                                   .splashColor
                                   : CustomTheme.of(context)
                                   .hintColor
                                   .withOpacity(0.5),
                               FontWeight.w500,
                               'FontRegular'),
                         ),
                       )),
                 ),
               ),
               Tab(
                 child: Container(
                   decoration: BoxDecoration(
                       border: Border.all(
                           color: marginOption
                               ? CustomTheme.of(context)
                               .buttonColor
                               : CustomTheme.of(context)
                               .splashColor
                               .withOpacity(0.5),
                           width: marginOption ? 1.5 : 0.5)),
                   child: Center(
                       child: Padding(
                         padding: marginOption
                             ? EdgeInsets.only(
                             top: 6.0, bottom: 6.0)
                             : EdgeInsets.only(
                             top: 7.0, bottom: 7.0),
                         child: Text(
                           AppLocalizations.instance
                               .text("loc_sell_trade_txt2"),
                           style: CustomWidget(context: context)
                               .CustomSizedTextStyle(
                               13.0,
                               marginOption
                                   ? CustomTheme.of(context)
                                   .splashColor
                                   : CustomTheme.of(context)
                                   .hintColor
                                   .withOpacity(0.5),
                               FontWeight.w500,
                               'FontRegular'),
                         ),
                       )),
                 ),
               ),
               Tab(
                 child: Container(
                   decoration: BoxDecoration(
                       border: Border.all(
                           color: futureOption
                               ? CustomTheme.of(context)
                               .buttonColor
                               : CustomTheme.of(context)
                               .splashColor
                               .withOpacity(0.5),
                           width: futureOption ? 1.5 : 0.5)),
                   child: Center(
                       child: Padding(
                         padding: futureOption
                             ? EdgeInsets.only(
                             top: 6.0, bottom: 6.0)
                             : EdgeInsets.only(
                             top: 7.0, bottom: 7.0),
                         child: Text(
                           AppLocalizations.instance
                               .text("loc_sell_trade_txt3"),
                           style: CustomWidget(context: context)
                               .CustomSizedTextStyle(
                               13.0,
                               futureOption
                                   ? CustomTheme.of(context)
                                   .splashColor
                                   : CustomTheme.of(context)
                                   .hintColor
                                   .withOpacity(0.5),
                               FontWeight.w500,
                               'FontRegular'),
                         ),
                       )),
                 ),
               ),

             ],
             controller: tradeTabController,
           ),
          ),
          body: TabBarView(
            physics: NeverScrollableScrollPhysics(),
            children: [
              spotUI(),
              MarginTrade(),
              comingsoon(),
            ],
            controller: tradeTabController,
          ),
        ),
      ),
    );*/

        MediaQuery(
            data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
            child: Scaffold(
              backgroundColor: CustomTheme.of(context).primaryColor,
              body: Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        stops: [
                      0.1,
                      0.5,
                      0.9,
                    ],
                        colors: [
                      CustomTheme.of(context).primaryColor,
                      CustomTheme.of(context).backgroundColor,
                      CustomTheme.of(context).accentColor,
                    ])),
                child: Stack(
                  children: [
                    Container(
                        child: SingleChildScrollView(
                      controller: controller,
                      child: Column(
                        children: [
                          /* TabBar(
                            isScrollable: false,
                            labelColor: CustomTheme.of(context).splashColor,
                            //<-- selected text color
                            unselectedLabelColor: CustomTheme.of(context)
                                .splashColor
                                .withOpacity(0.5),
                            // isScrollable: true,
                            indicatorPadding:
                            EdgeInsets.only(left: 10.0, right: 10.0),
                            indicatorColor: CustomTheme.of(context).cardColor,
                            tabs: <Tab>[
                              Tab(
                                child: Container(
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: spotOption
                                              ? CustomTheme.of(context)
                                              .buttonColor
                                              : CustomTheme.of(context)
                                              .splashColor
                                              .withOpacity(0.5),
                                          width: spotOption ? 1.5 : 0.5)),
                                  child: Center(
                                      child: Padding(
                                        padding: spotOption
                                            ? EdgeInsets.only(
                                            top: 6.0, bottom: 6.0)
                                            : EdgeInsets.only(
                                            top: 7.0, bottom: 7.0),
                                        child: Text(
                                          AppLocalizations.instance
                                              .text("loc_sell_trade_txt1"),
                                          style: CustomWidget(context: context)
                                              .CustomSizedTextStyle(
                                              13.0,
                                              spotOption
                                                  ? CustomTheme.of(context)
                                                  .splashColor
                                                  : CustomTheme.of(context)
                                                  .hintColor
                                                  .withOpacity(0.5),
                                              FontWeight.w500,
                                              'FontRegular'),
                                        ),
                                      )),
                                ),
                              ),
                              Tab(
                                child: Container(
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: marginOption
                                              ? CustomTheme.of(context)
                                              .buttonColor
                                              : CustomTheme.of(context)
                                              .splashColor
                                              .withOpacity(0.5),
                                          width: marginOption ? 1.5 : 0.5)),
                                  child: Center(
                                      child: Padding(
                                        padding: marginOption
                                            ? EdgeInsets.only(
                                            top: 6.0, bottom: 6.0)
                                            : EdgeInsets.only(
                                            top: 7.0, bottom: 7.0),
                                        child: Text(
                                          AppLocalizations.instance
                                              .text("loc_sell_trade_txt2"),
                                          style: CustomWidget(context: context)
                                              .CustomSizedTextStyle(
                                              13.0,
                                              marginOption
                                                  ? CustomTheme.of(context)
                                                  .splashColor
                                                  : CustomTheme.of(context)
                                                  .hintColor
                                                  .withOpacity(0.5),
                                              FontWeight.w500,
                                              'FontRegular'),
                                        ),
                                      )),
                                ),
                              ),
                              Tab(
                                child: Container(
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: futureOption
                                              ? CustomTheme.of(context)
                                              .buttonColor
                                              : CustomTheme.of(context)
                                              .splashColor
                                              .withOpacity(0.5),
                                          width: futureOption ? 1.5 : 0.5)),
                                  child: Center(
                                      child: Padding(
                                        padding: futureOption
                                            ? EdgeInsets.only(
                                            top: 6.0, bottom: 6.0)
                                            : EdgeInsets.only(
                                            top: 7.0, bottom: 7.0),
                                        child: Text(
                                          AppLocalizations.instance
                                              .text("loc_sell_trade_txt3"),
                                          style: CustomWidget(context: context)
                                              .CustomSizedTextStyle(
                                              13.0,
                                              futureOption
                                                  ? CustomTheme.of(context)
                                                  .splashColor
                                                  : CustomTheme.of(context)
                                                  .hintColor
                                                  .withOpacity(0.5),
                                              FontWeight.w500,
                                              'FontRegular'),
                                        ),
                                      )),
                                ),
                              ),
                            ],
                            controller: tradeTabController,
                          ),
                          Expanded(
                            child: TabBarView(
                              children: <Widget>[spotUI(), MarginTrade(),comingsoon()],
                              controller: tradeTabController,
                            ),
                          ),*/
                          Container(
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color: CustomTheme.of(context)
                                        .splashColor
                                        .withOpacity(0.5),
                                    width: 0.5)),
                            child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Flexible(
                                    child: GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          buySell = true;
                                          selectPair = tradePair[0];
                                          _currentSliderValue = 0;
                                          totalAmount = "0.0";
                                          openOrders = [];
                                          marginBuyData = [];
                                          marginSellData = [];
                                          spotOption = true;
                                          marginOption = false;
                                          enableStopLimit = false;
                                          priceController.clear();
                                          amountController.clear();
                                          stopPriceController.clear();
                                          getCoinList();
                                          loanVisibleOption = false;
                                          marginVisibleOption = false;
                                          futureOption = false;
                                          enableTrade = false;
                                          selectedTime = chartTime.first;
                                        });
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                color: spotOption
                                                    ? CustomTheme.of(context)
                                                        .buttonColor
                                                    : CustomTheme.of(context)
                                                        .splashColor
                                                        .withOpacity(0.5),
                                                width: spotOption ? 1.5 : 0.5)),
                                        child: Center(
                                            child: Padding(
                                          padding: spotOption
                                              ? EdgeInsets.only(
                                                  top: 6.0, bottom: 6.0)
                                              : EdgeInsets.only(
                                                  top: 7.0, bottom: 7.0),
                                          child: Text(
                                            AppLocalizations.instance
                                                .text("loc_sell_trade_txt1"),
                                            style: CustomWidget(
                                                    context: context)
                                                .CustomSizedTextStyle(
                                                    13.0,
                                                    spotOption
                                                        ? CustomTheme.of(
                                                                context)
                                                            .splashColor
                                                        : CustomTheme.of(
                                                                context)
                                                            .hintColor
                                                            .withOpacity(0.5),
                                                    FontWeight.w500,
                                                    'FontRegular'),
                                          ),
                                        )),
                                      ),
                                    ),
                                    flex: 1,
                                  ),
                                  Flexible(
                                    child: GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          buySell = true;
                                          selectPair = tradePair[0];
                                          openOrders = [];
                                          _currentSliderValue = 0;
                                          tleverageVal = "1";
                                          totalAmount = "0.0";
                                          spotOption = false;
                                          marginOption = true;
                                          enableStopLimit = false;
                                          marginVisibleOption = true;
                                          selectedMarginTradeType =
                                              transferType.first;
                                          loanVisibleOption = true;
                                          futureOption = false;
                                          priceController.clear();
                                          amountController.clear();
                                          stopPriceController.clear();
                                          marginBuyData = [];
                                          marginSellData = [];
                                          getCoinList();
                                          // coinController.clear();
                                          enableTrade = false;
                                          selectedTime = chartTime.first;
                                        });
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                color: marginOption
                                                    ? CustomTheme.of(context)
                                                        .buttonColor
                                                    : CustomTheme.of(context)
                                                        .splashColor
                                                        .withOpacity(0.5),
                                                width:
                                                    marginOption ? 1.5 : 0.5)),
                                        child: Center(
                                            child: Padding(
                                          padding: marginOption
                                              ? EdgeInsets.only(
                                                  top: 6.0, bottom: 6.0)
                                              : EdgeInsets.only(
                                                  top: 7.0, bottom: 7.0),
                                          child: Text(
                                            AppLocalizations.instance
                                                .text("loc_sell_trade_txt2"),
                                            style: CustomWidget(
                                                    context: context)
                                                .CustomSizedTextStyle(
                                                    13.0,
                                                    marginOption
                                                        ? CustomTheme.of(
                                                                context)
                                                            .splashColor
                                                        : CustomTheme.of(
                                                                context)
                                                            .hintColor
                                                            .withOpacity(0.5),
                                                    FontWeight.w500,
                                                    'FontRegular'),
                                          ),
                                        )),
                                      ),
                                    ),
                                    flex: 1,
                                  ),
                                  Flexible(
                                    child: GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          buySell = true;
                                          selectPair = tradePair[0];
                                          _currentSliderValue = 0;
                                          tleverageVal = "1";
                                          spotOption = false;
                                          marginOption = false;
                                          selectedMarginTradeType =
                                              transferFutureType.first;
                                          marginVisibleOption = false;
                                          loanVisibleOption = true;
                                          enableStopLimit = false;
                                          priceController.clear();
                                          amountController.clear();
                                          FutureopenOrders = [];
                                          Futureposition = [];
                                          futureOption = true;
                                          marginBuyData = [];
                                          marginSellData = [];
                                          getCoinList();
                                          getFutureOpenOrder();
                                          enableTrade = false;
                                          selectedTime = chartTime.first;
                                          totalAmount = "0.0";
                                        });
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                color: futureOption
                                                    ? CustomTheme.of(context)
                                                        .buttonColor
                                                    : CustomTheme.of(context)
                                                        .splashColor
                                                        .withOpacity(0.5),
                                                width:
                                                    futureOption ? 1.5 : 0.5)),
                                        child: Center(
                                            child: Padding(
                                          padding: futureOption
                                              ? EdgeInsets.only(
                                                  top: 6.0, bottom: 6.0)
                                              : EdgeInsets.only(
                                                  top: 7.0, bottom: 7.0),
                                          child: Text(
                                            AppLocalizations.instance
                                                .text("loc_sell_trade_txt3"),
                                            style: CustomWidget(
                                                    context: context)
                                                .CustomSizedTextStyle(
                                                    13.0,
                                                    futureOption
                                                        ? CustomTheme.of(
                                                                context)
                                                            .splashColor
                                                        : CustomTheme.of(
                                                                context)
                                                            .hintColor
                                                            .withOpacity(0.5),
                                                    FontWeight.w500,
                                                    'FontRegular'),
                                          ),
                                        )),
                                      ),
                                    ),
                                    flex: 1,
                                  ),
                                ]),
                          ),

                          const SizedBox(
                            height: 10.0,
                          ),
                          spotOption
                              ? spotUI()
                              : marginOption
                                  ? spotUI()
                                  : futureOption
                                      ? spotUI()
                                      : comingsoon(),

                          //orderWidget()
                        ],
                      ),
                    )),
                    loading
                        ? CustomWidget(context: context)
                            .loadingIndicator(AppColors.whiteColor)
                        : Container()
                  ],
                ),
              ),
            ));
  }

  Widget spotUI() {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(
            height: 10.0,
          ),
          Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: () {
                    showSheeet();
                  },
                  child: Row(
                    children: [
                      Container(
                        margin: EdgeInsets.fromLTRB(0, 0, 5, 0),
                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                        child: InkWell(
                          child: SvgPicture.asset(
                            'assets/images/menu.svg',
                            height: 20.0,
                            width: 20.0,
                            color: CustomTheme.of(context).splashColor,
                          ),
                        ),
                      ),
                      tradePair.length > 0
                          ? Text(
                              selectPair!.displayName.toString(),
                              style: CustomWidget(context: context)
                                  .CustomSizedTextStyle(
                                      16.0,
                                      Theme.of(context).splashColor,
                                      FontWeight.w500,
                                      'FontRegular'),
                            )
                          : Container(),
                      // Container(
                      //   height: 45.0,
                      //   padding: const EdgeInsets.only(
                      //     top: 2.0,
                      //     bottom: 2.0,
                      //   ),
                      //   child: Center(
                      //     child: Theme(
                      //       data: Theme.of(context).copyWith(
                      //         canvasColor: CustomTheme.of(context).primaryColor,
                      //       ),
                      //       child: DropdownButtonHideUnderline(
                      //         child: DropdownButton(
                      //           items: tradePair
                      //               .map((value) => DropdownMenuItem(
                      //                     child: Text(
                      //                       value.displayName.toString(),
                      //                       style: CustomWidget(context: context)
                      //                           .CustomSizedTextStyle(
                      //                               16.0,
                      //                               Theme.of(context).splashColor,
                      //                               FontWeight.w500,
                      //                               'FontRegular'),
                      //                     ),
                      //                     value: value,
                      //                   ))
                      //               .toList(),
                      //           onChanged: (TradePairList? value) {
                      //             setState(() {
                      //               selectPair = value;
                      //               selectedIndex = selectPair!.id.toString();
                      //               priceController.clear();
                      //               amountController.clear();
                      //               totalAmount = "0.00";
                      //               _currentSliderValue = 0;
                      //               coinName = buySell
                      //                   ? selectPair!.marketAsset!.symbol.toString()
                      //                   : selectPair!.baseAsset!.symbol.toString();
                      //               getBalance(buySell
                      //                   ? selectPair!.marketWallet!.id.toString()
                      //                   : selectPair!.baseWallet!.id.toString());
                      //               loading = true;
                      //               firstCoin =
                      //                   selectPair!.baseAsset!.symbol.toString();
                      //               secondCoin =
                      //                   selectPair!.marketAsset!.symbol.toString();
                      //
                      //               livePriceData!.sink.close();
                      //
                      //               var messageJSON = {
                      //                 "sub": "market." +
                      //                     firstCoin.toLowerCase() +
                      //                     secondCoin.toLowerCase() +
                      //                     ".depth.step0",
                      //                 "id": "id1"
                      //               };
                      //               var messageLiveJSON = {
                      //                 "sub": "market." +
                      //                     firstCoin.toLowerCase() +
                      //                     secondCoin.toLowerCase() +
                      //                     ".ticker",
                      //               };
                      //               channelOpenOrder!.sink
                      //                   .add(json.encode(messageJSON));
                      //               livePriceData = IOWebSocketChannel.connect(
                      //                   Uri.parse("wss://api.huobi.pro/ws"),
                      //                   pingInterval: Duration(seconds: 30));
                      //               livePriceData!.sink
                      //                   .add(json.encode(messageLiveJSON));
                      //               socketLivepriceData();
                      //               getAllOpenOrder();
                      //               getOpenOrder();
                      //               getAllHistory();
                      //             });
                      //           },
                      //           isExpanded: false,
                      //           value: selectPair,
                      //           icon: Container(
                      //             width: 1.0,
                      //           ),
                      //         ),
                      //       ),
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    Visibility(
                      visible: loanVisibleOption,
                      child: Row(
                        children: [
                          /* GestureDetector(
                            onTap: () {
                              enableLoan = false;
                              leverageLoan = true;
                              coinController.text=coinList[0].asset!.symbol.toString();
                              _leverageSliderValue=0;
                              loanErr = false;
                              showLoanDialog();
                              // coinController.clear();
                              amtController.clear();
                            },
                            child: Container(
                              padding: EdgeInsets.all(5.0),
                              decoration: BoxDecoration(
                                color: CustomTheme.of(context).indicatorColor,
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                              child: Text(
                                "Loan",
                                style: CustomWidget(context: context)
                                    .CustomSizedTextStyle(
                                    12.0,
                                    AppColors.whiteColor,
                                    FontWeight.w500,
                                    'FontRegular'),
                              ),
                            ),
                          ),*/
                          SizedBox(
                            width: 5.0,
                          ),
                          /* GestureDetector(
                            onTap: () {
                              enableLoan = false;
                              disableLoan = false;
                              coinController.text=coinList[0].asset!.symbol.toString();
                              showLoanDialog();
                              // coinController.clear();
                              amtController.clear();
                            },
                            child: Container(
                              padding: EdgeInsets.all(5.0),
                              decoration: BoxDecoration(
                                color: CustomTheme.of(context).indicatorColor,
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                              child: Text(
                                "Repay",
                                style: CustomWidget(context: context)
                                    .CustomSizedTextStyle(
                                    12.0,
                                    AppColors.whiteColor,
                                    FontWeight.w500,
                                    'FontRegular'),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 5.0,
                          ),*/
                          GestureDetector(
                            onTap: () {
                              enableLoan = true;
                              leverageLoan = false;
                              loanErr = false;
                              coinController.text =
                                  coinList[0].asset!.symbol.toString();
                              transferType[1];
                              showLoanDialog();
                              // coinController.clear();
                              amtController.clear();
                            },
                            child: Container(
                              padding: EdgeInsets.all(5.0),
                              decoration: BoxDecoration(
                                color: CustomTheme.of(context).indicatorColor,
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                              child: Text(
                                "Transfer",
                                style: CustomWidget(context: context)
                                    .CustomSizedTextStyle(
                                        12.0,
                                        AppColors.whiteColor,
                                        FontWeight.w500,
                                        'FontRegular'),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(
                      width: 8.0,
                    ),
                    Container(
                      padding: const EdgeInsets.fromLTRB(3, 0, 3, 0),
                      child: InkWell(
                        onTap: () {
                         /* Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    ChartScreen(id: selectPair!.id.toString()),
                              ));*/
                        },
                        child: SvgPicture.asset(
                          'assets/images/filter.svg',
                          height: 20.0,
                          width: 20.0,
                          allowDrawingOutsideViewBox: true,
                          color: CustomTheme.of(context).splashColor,
                        ),
                      ),
                    ),
                    // cheerList.length>0? Container(
                    //    padding:
                    //    const EdgeInsets.fromLTRB(3, 0, 3, 0),
                    //    child: InkWell(
                    //      onTap: () {
                    //
                    //      },
                    //      child: SvgPicture.asset(
                    //        'assets/images/star.svg',
                    //        height: 20.0,
                    //        width: 20.0,
                    //        allowDrawingOutsideViewBox: true,
                    //        color:cheerList[]?
                    //        CustomTheme.of(context).splashColor:Colors.yellow,
                    //      ),
                    //    ),
                    //  )
                    Container(
                      padding: const EdgeInsets.fromLTRB(3, 0, 3, 0),
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            if (favValue) {
                              addTOFav(selectPair!.pairSymbol.toString(), "2");
                            } else {
                              addTOFav(selectPair!.pairSymbol.toString(), "1");
                            }
                          });
                        },
                        child: SvgPicture.asset(
                          'assets/images/star.svg',
                          height: 20.0,
                          width: 20.0,
                          allowDrawingOutsideViewBox: true,
                          color: favValue
                              ? Colors.yellow
                              : CustomTheme.of(context).splashColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ]),
          const SizedBox(
            height: 10.0,
          ),
          Container(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(
                  child: OrderWidget(),
                  flex: 1,
                ),
                const SizedBox(
                  width: 10.0,
                ),
                Flexible(
                  child: normalTrade ? MarginmarketWidget() : marketWidget(),
                  flex: 1,
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 15.0,
          ),
          Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Live Price",
                    style: CustomWidget(context: context).CustomSizedTextStyle(
                        12.0,
                        Theme.of(context).splashColor,
                        FontWeight.bold,
                        'FontRegular'),
                  ),
                  Text(
                    livePrice +
                        " " +
                        (futureOption
                            ? coinTwoName
                            : (buySell ? coinTwoName : coinName)),
                    style: CustomWidget(context: context).CustomSizedTextStyle(
                        11.5,
                        Theme.of(context).splashColor,
                        FontWeight.w500,
                        'FontRegular'),
                  ),
                ],
              ),
              SizedBox(
                height: 5.0,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Available",
                    style: CustomWidget(context: context).CustomSizedTextStyle(
                        12.0,
                        Theme.of(context).hintColor.withOpacity(0.5),
                        FontWeight.w500,
                        'FontRegular'),
                  ),
                  Text(
                    balance +
                        " " +
                        (futureOption
                            ? coinTwoName
                            : (buySell ? coinTwoName : coinName)),
                    style: CustomWidget(context: context).CustomSizedTextStyle(
                        11.5,
                        Theme.of(context).splashColor,
                        FontWeight.w500,
                        'FontRegular'),
                  ),
                ],
              ),
              SizedBox(
                height: 5.0,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Frozen amount",
                    style: CustomWidget(context: context).CustomSizedTextStyle(
                        12.0,
                        Theme.of(context).hintColor.withOpacity(0.5),
                        FontWeight.w500,
                        'FontRegular'),
                  ),
                  Text(
                    escrow +
                        " " +
                        (futureOption
                            ? coinTwoName
                            : (buySell ? coinTwoName : coinName)),
                    style: CustomWidget(context: context).CustomSizedTextStyle(
                        11.5,
                        Theme.of(context).splashColor,
                        FontWeight.w500,
                        'FontRegular'),
                  ),
                ],
              ),
              SizedBox(
                height: 5.0,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Total Asset",
                    style: CustomWidget(context: context).CustomSizedTextStyle(
                        12.0,
                        Theme.of(context).hintColor.withOpacity(0.5),
                        FontWeight.w500,
                        'FontRegular'),
                  ),
                  Text(
                    totalBalance +
                        " " +
                        (futureOption
                            ? coinTwoName
                            : (buySell ? coinTwoName : coinName)),
                    style: CustomWidget(context: context).CustomSizedTextStyle(
                        11.5,
                        Theme.of(context).splashColor,
                        FontWeight.w500,
                        'FontRegular'),
                  ),
                ],
              ),
              SizedBox(
                height: 5.0,
              ),
            ],
          ),
          const SizedBox(
            height: 10.0,
          ),
          InkWell(
            onTap: () {
              futureOption ? showFutureOrders() : showOrders();
            },
            child: Padding(
              padding: const EdgeInsets.only(left: 0.0, right: 0.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Open Orders ( " +
                        (futureOption
                            ? FutureopenOrders.length.toString()
                            : openOrders.length.toString()) +
                        " )",
                    style: CustomWidget(context: context).CustomTextStyle(
                        Theme.of(context).splashColor.withOpacity(0.5),
                        FontWeight.w400,
                        'FontRegular'),
                    textAlign: TextAlign.center,
                  ),
                  Row(
                    children: [
                      Text(
                        "Show all",
                        style: CustomWidget(context: context)
                            .CustomSizedTextStyle(
                                12.0,
                                Theme.of(context).splashColor.withOpacity(0.5),
                                FontWeight.w500,
                                'FontRegular'),
                        textAlign: TextAlign.center,
                      ),
                      Icon(
                        Icons.arrow_forward_ios_outlined,
                        color: Theme.of(context).splashColor.withOpacity(0.5),
                        size: 10.0,
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 10.0,
          ),
          futureOption ? futureOpenOrdersUI() : openOrdersUIS(),
        ],
      ),
    );
  }

  Widget MarginmarketWidget() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Text(
                AppLocalizations.instance.text("loc_sell_trade_price") +
                    "\n(" +
                    secondCoin +
                    ")",
                style: CustomWidget(context: context).CustomSizedTextStyle(
                    12.0,
                    Theme.of(context).splashColor.withOpacity(0.5),
                    FontWeight.w500,
                    'FontRegular'),
              ),
            ),
            Expanded(
              child: Text(
                AppLocalizations.instance.text("loc_sell_trade_Qty") +
                    "\n(" +
                    firstCoin +
                    ")",
                style: CustomWidget(context: context).CustomSizedTextStyle(
                    12.0,
                    Theme.of(context).splashColor.withOpacity(0.5),
                    FontWeight.w500,
                    'FontRegular'),
                textAlign: TextAlign.end,
              ),
            )
          ],
        ),
        const SizedBox(
          height: 5.0,
        ),
        socketLoader
            ? Container(
                height: MediaQuery.of(context).size.height * 0.38,
                child: CustomWidget(context: context)
                    .loadingIndicator(AppColors.whiteColor),
              )
            : marginBuyData.length > 0 || marginSellData.length > 0
                ? Column(
                    children: [
                      sellOption
                          ? SizedBox(
                              height: !buyOption
                                  ? MediaQuery.of(context).size.height * 0.34
                                  : MediaQuery.of(context).size.height * 0.17,
                              child: marginSellData.length > 0
                                  ? ListView.builder(
                                      controller: controller,
                                      itemCount: marginSellData.length,
                                      itemBuilder:
                                          ((BuildContext context, int index) {
                                        return Column(
                                          children: [
                                            InkWell(
                                              onTap: () {
                                                setState(() {
                                                  buySell = true;
                                                  if (selectedTime ==
                                                      "Market Order") {
                                                    amountController.text =
                                                        marginSellData[index]
                                                            .quantity
                                                            .toString()
                                                            .replaceAll(
                                                                ",", "");
                                                  } else {
                                                    priceController.text =
                                                        marginSellData[index]
                                                            .price
                                                            .toString()
                                                            .replaceAll(
                                                                ",", "");
                                                    amountController.text =
                                                        marginSellData[index]
                                                            .quantity
                                                            .toString()
                                                            .replaceAll(
                                                                ",", "");
                                                  }
                                                  totalAmount = (double.parse(
                                                              amountController
                                                                  .text
                                                                  .toString()) *
                                                          double.parse(
                                                              priceController
                                                                  .text
                                                                  .toString()))
                                                      .toStringAsFixed(4);
                                                  coinName = selectPair!
                                                      .baseAsset!.symbol
                                                      .toString();
                                                  coinTwoName = selectPair!
                                                      .marketAsset!.symbol
                                                      .toString();
                                                  getCoinDetailsList(selectPair!
                                                      .id
                                                      .toString());
                                                });
                                              },
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    double.parse(marginSellData[
                                                                index]
                                                            .price
                                                            .toString())
                                                        .toStringAsFixed(
                                                            decimalIndex),
                                                    style: CustomWidget(
                                                            context: context)
                                                        .CustomSizedTextStyle(
                                                            10.0,
                                                            Theme.of(context)
                                                                .scaffoldBackgroundColor,
                                                            FontWeight.w500,
                                                            'FontRegular'),
                                                  ),
                                                  Text(
                                                    double.parse(marginSellData[
                                                                index]
                                                            .quantity
                                                            .toString()
                                                            .replaceAll(
                                                                ",", ""))
                                                        .toStringAsFixed(
                                                            decimalIndex),
                                                    style: CustomWidget(
                                                            context: context)
                                                        .CustomSizedTextStyle(
                                                            10.0,
                                                            Theme.of(context)
                                                                .splashColor,
                                                            FontWeight.w500,
                                                            'FontRegular'),
                                                  ),
                                                ],
                                              ),
                                            )
                                          ],
                                        );
                                      }))
                                  : Container(
                                      height: !buyOption
                                          ? MediaQuery.of(context).size.height *
                                              0.38
                                          : MediaQuery.of(context).size.height *
                                              0.17,
                                      decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                              begin: Alignment.topCenter,
                                              end: Alignment.bottomCenter,
                                              // Add one stop for each color
                                              // Values should increase from 0.0 to 1.0
                                              stops: [
                                            0.1,
                                            0.5,
                                            0.9,
                                          ],
                                              colors: [
                                            CustomTheme.of(context)
                                                .primaryColor,
                                            CustomTheme.of(context)
                                                .backgroundColor,
                                            CustomTheme.of(context).accentColor,
                                          ])),
                                      child: Center(
                                        child: Text(
                                          " No Data Found..!",
                                          style: TextStyle(
                                            fontFamily: "FontRegular",
                                            color: CustomTheme.of(context)
                                                .splashColor,
                                          ),
                                        ),
                                      ),
                                    ),
                            )
                          : Container(
                              color: Colors.white,
                            ),
                      const SizedBox(
                        height: 10.0,
                      ),
                      buyOption
                          ? SizedBox(
                              height: !sellOption
                                  ? MediaQuery.of(context).size.height * 0.40
                                  : MediaQuery.of(context).size.height * 0.20,
                              child: marginBuyData.length > 0
                                  ? ListView.builder(
                                      controller: controller,
                                      itemCount: marginBuyData.length,
                                      itemBuilder:
                                          ((BuildContext context, int index) {
                                        return InkWell(
                                            onTap: () {
                                              setState(() {
                                                buySell = false;
                                                if (selectedTime ==
                                                    "Market Order") {
                                                  amountController.text =
                                                      marginBuyData[index]
                                                          .quantity
                                                          .toString()
                                                          .replaceAll(",", "");
                                                } else {
                                                  priceController.text =
                                                      marginBuyData[index]
                                                          .price
                                                          .toString()
                                                          .replaceAll(",", "");
                                                  amountController.text =
                                                      marginBuyData[index]
                                                          .quantity
                                                          .toString()
                                                          .replaceAll(",", "");
                                                }

                                                takerFee = ((double.parse(
                                                                amountController
                                                                    .text
                                                                    .toString()) *
                                                            double.parse(
                                                                priceController
                                                                    .text
                                                                    .toString()) *
                                                            double.parse(
                                                                takerFeeValue
                                                                    .toString())) /
                                                        100)
                                                    .toStringAsFixed(4);
                                                totalAmount = ((double.parse(
                                                            priceController
                                                                .text) *
                                                        double.parse(
                                                            amountController
                                                                .text)))
                                                    .toStringAsFixed(4);
                                                coinName = selectPair!
                                                    .baseAsset!.symbol
                                                    .toString();
                                                coinTwoName = selectPair!
                                                    .marketAsset!.symbol
                                                    .toString();
                                                getCoinDetailsList(
                                                    selectPair!.id.toString());
                                              });
                                            },
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  double.parse(
                                                          marginBuyData[index]
                                                              .price
                                                              .toString())
                                                      .toStringAsFixed(
                                                          decimalIndex),
                                                  style: CustomWidget(
                                                          context: context)
                                                      .CustomSizedTextStyle(
                                                          10.0,
                                                          Theme.of(context)
                                                              .indicatorColor,
                                                          FontWeight.w500,
                                                          'FontRegular'),
                                                ),
                                                Text(
                                                  double.parse(
                                                          marginBuyData[index]
                                                              .quantity
                                                              .toString()
                                                              .replaceAll(
                                                                  ",", ""))
                                                      .toStringAsFixed(
                                                          decimalIndex),
                                                  style: CustomWidget(
                                                          context: context)
                                                      .CustomSizedTextStyle(
                                                          10.0,
                                                          Theme.of(context)
                                                              .splashColor,
                                                          FontWeight.w500,
                                                          'FontRegular'),
                                                ),
                                              ],
                                            ));
                                      }))
                                  : Container(
                                      height: !sellOption
                                          ? MediaQuery.of(context).size.height *
                                              0.40
                                          : MediaQuery.of(context).size.height *
                                              0.20,
                                      decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                              begin: Alignment.topCenter,
                                              end: Alignment.bottomCenter,
                                              // Add one stop for each color
                                              // Values should increase from 0.0 to 1.0
                                              stops: [
                                            0.1,
                                            0.5,
                                            0.9,
                                          ],
                                              colors: [
                                            CustomTheme.of(context)
                                                .primaryColor,
                                            CustomTheme.of(context)
                                                .backgroundColor,
                                            CustomTheme.of(context).accentColor,
                                          ])),
                                      child: Center(
                                        child: Text(
                                          " No Data Found..!",
                                          style: TextStyle(
                                            fontFamily: "FontRegular",
                                            color: CustomTheme.of(context)
                                                .splashColor,
                                          ),
                                        ),
                                      ),
                                    ))
                          : Container(),
                    ],
                  )
                : Container(
                    height: MediaQuery.of(context).size.height * 0.40,
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            // Add one stop for each color
                            // Values should increase from 0.0 to 1.0
                            stops: [
                          0.1,
                          0.5,
                          0.9,
                        ],
                            colors: [
                          CustomTheme.of(context).primaryColor,
                          CustomTheme.of(context).backgroundColor,
                          CustomTheme.of(context).accentColor,
                        ])),
                    child: Center(
                      child: Text(
                        " No Data Found..!",
                        style: TextStyle(
                          fontFamily: "FontRegular",
                          color: CustomTheme.of(context).splashColor,
                        ),
                      ),
                    ),
                  ),

        /* buyData.length > 0 && sellData.length > 0
                ? Column(
                    children: [
                      sellOption
                          ? SizedBox(
                              height: !buyOption
                                  ? MediaQuery.of(context).size.height * 0.34
                                  : MediaQuery.of(context).size.height * 0.17,
                              child: sellData.length > 0
                                  ? ListView.builder(
                                      controller: controller,
                                      itemCount: sellData.length,
                                      itemBuilder:
                                          ((BuildContext context, int index) {
                                        return Column(
                                          children: [
                                            InkWell(
                                              onTap: () {
                                                setState(() {
                                                  marginbuySell = true;
                                                  marginpriceController.text = sellData[index]
                                                      .price
                                                      .toString()
                                                      .replaceAll(",", "");
                                                  marginamountController.text = sellData[index]
                                                      .quantity
                                                      .toString()
                                                      .replaceAll(",", "");
                                                  totalAmount = (double.parse(
                                                      marginamountController.text.toString()) *
                                                      double.parse(
                                                          marginpriceController.text.toString()))
                                                      .toStringAsFixed(4);
                                                  coinName = selectPair!.baseAsset!.symbol.toString();
                                                  getCoinDetailsList(selectPair!.id.toString());
                                                });
                                              },
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Text(
                                                    double.parse(sellData[index].price.toString())
                                                        .toStringAsFixed(decimalIndex),
                                                    style: CustomWidget(context: context)
                                                        .CustomSizedTextStyle(
                                                        10.0,
                                                        Theme.of(context)
                                                            .scaffoldBackgroundColor,
                                                        FontWeight.w500,
                                                        'FontRegular'),
                                                  ),
                                                  Text(
                                                    double.parse(sellData[index]
                                                        .quantity
                                                        .toString()
                                                        .replaceAll(",", ""))
                                                        .toStringAsFixed(decimalIndex),
                                                    style: CustomWidget(context: context)
                                                        .CustomSizedTextStyle(
                                                        10.0,
                                                        Theme.of(context).splashColor,
                                                        FontWeight.w500,
                                                        'FontRegular'),
                                                  ),
                                                ],
                                              ),
                                            )
                                          ],
                                        );
                                      }))
                                  : Container(
                                      height: !buyOption
                                          ? MediaQuery.of(context).size.height *
                                              0.38
                                          : MediaQuery.of(context).size.height *
                                              0.17,
                                      decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                              begin: Alignment.topCenter,
                                              end: Alignment.bottomCenter,
                                              // Add one stop for each color
                                              // Values should increase from 0.0 to 1.0
                                              stops: [
                                            0.1,
                                            0.5,
                                            0.9,
                                          ],
                                              colors: [
                                            CustomTheme.of(context)
                                                .primaryColor,
                                            CustomTheme.of(context)
                                                .backgroundColor,
                                            CustomTheme.of(context).accentColor,
                                          ])),
                                      child: Center(
                                          child: Text(
                                            " No Data Found..!",
                                            style: TextStyle(
                                              fontFamily: "FontRegular",
                                              color: CustomTheme.of(context).splashColor,
                                            ),
                                          ),
                                          ),
                                    ),
                            )
                          : Container(
                              color: Colors.white,
                            ),
                      const SizedBox(
                        height: 10.0,
                      ),
                      buyOption
                          ? SizedBox(
                              height: !sellOption
                                  ? MediaQuery.of(context).size.height * 0.40
                                  : MediaQuery.of(context).size.height * 0.20,
                              child: buyData.length > 0
                                  ? ListView.builder(
                                      controller: controller,
                                      itemCount: buyData.length,
                                      itemBuilder:
                                          ((BuildContext context, int index) {
                                        return InkWell(
                                            onTap: () {
                                              setState(() {
                                                marginbuySell = false;
                                                marginpriceController.text =
                                                    buyData[index]
                                                        .price
                                                        .toString()
                                                        .replaceAll(",", "");
                                                marginamountController.text =
                                                    buyData[index]
                                                        .quantity
                                                        .toString()
                                                        .replaceAll(",", "");

                                                takerFee = ((double.parse(
                                                                marginamountController
                                                                    .text
                                                                    .toString()) *
                                                            double.parse(
                                                                marginpriceController
                                                                    .text
                                                                    .toString()) *
                                                            double.parse(
                                                                takerFeeValue
                                                                    .toString())) /
                                                        100)
                                                    .toStringAsFixed(4);
                                                totalAmount = ((double.parse(
                                                                marginpriceController
                                                                    .text) *
                                                            double.parse(
                                                                marginamountController
                                                                    .text) -
                                                        double.parse(takerFee)))
                                                    .toStringAsFixed(4);
                                                coinName = selectPair!
                                                    .baseAsset!.symbol
                                                    .toString();

                                                getCoinDetailsList(
                                                    selectPair!.id.toString());
                                              });
                                            },
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                // Text(
                                                //   double.parse(buyData[index].price.toString())
                                                //       .toStringAsFixed(decimalIndex),
                                                //   style: CustomWidget(context: context)
                                                //       .CustomSizedTextStyle(
                                                //       10.0,
                                                //       Theme.of(context).indicatorColor,
                                                //       FontWeight.w500,
                                                //       'FontRegular'),
                                                // ),
                                                // Text(
                                                //   double.parse(buyData[index]
                                                //       .quantity
                                                //       .toString()
                                                //       .replaceAll(",", ""))
                                                //       .toStringAsFixed(decimalIndex),
                                                //   style: CustomWidget(context: context)
                                                //       .CustomSizedTextStyle(
                                                //       10.0,
                                                //       Theme.of(context).splashColor,
                                                //       FontWeight.w500,
                                                //       'FontRegular'),
                                                // ),
                                              ],
                                            ));
                                      }))
                                  : Container(
                                      height: !sellOption
                                          ? MediaQuery.of(context).size.height *
                                              0.40
                                          : MediaQuery.of(context).size.height *
                                              0.20,
                                      decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                              begin: Alignment.topCenter,
                                              end: Alignment.bottomCenter,
                                              // Add one stop for each color
                                              // Values should increase from 0.0 to 1.0
                                              stops: [
                                            0.1,
                                            0.5,
                                            0.9,
                                          ],
                                              colors: [
                                            CustomTheme.of(context)
                                                .primaryColor,
                                            CustomTheme.of(context)
                                                .backgroundColor,
                                            CustomTheme.of(context).accentColor,
                                          ])),
                                      child: Center(
                                          child: Text(
                                            " No Data Found..!",
                                            style: TextStyle(
                                              fontFamily: "FontRegular",
                                              color: CustomTheme.of(context).splashColor,
                                            ),
                                          ),
                                          ),
                                    ))
                          : Container(),
                    ],
                  )
                : Container(
                    height: MediaQuery.of(context).size.height * 0.40,
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            // Add one stop for each color
                            // Values should increase from 0.0 to 1.0
                            stops: [
                          0.1,
                          0.5,
                          0.9,
                        ],
                            colors: [
                          CustomTheme.of(context).primaryColor,
                          CustomTheme.of(context).backgroundColor,
                          CustomTheme.of(context).accentColor,
                        ])),
                    child: Center(
                        // child: Text(
                        //   " No Data Found..!",
                        //   style: TextStyle(
                        //     fontFamily: "FontRegular",
                        //     color: CustomTheme.of(context).splashColor,
                        //   ),
                        // ),
                        ),
                  ),*/
        const SizedBox(
          height: 12.0,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              height: 35.0,
              padding: const EdgeInsets.only(
                  left: 10.0, right: 10.0, top: 0.0, bottom: 0.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5.0),
                color: CustomTheme.of(context).cardColor,
              ),
              child: Center(
                child: Theme(
                  data: Theme.of(context).copyWith(
                    canvasColor: CustomTheme.of(context).backgroundColor,
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton(
                      items: _decimal
                          .map((value) => DropdownMenuItem(
                                child: Text(
                                  value,
                                  style: CustomWidget(context: context)
                                      .CustomSizedTextStyle(
                                          12.0,
                                          Theme.of(context).splashColor,
                                          FontWeight.w500,
                                          'FontRegular'),
                                ),
                                value: value,
                              ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedDecimal = value.toString();
                          for (int m = 0; m < _decimal.length; m++) {
                            if (value == _decimal[m]) {
                              if (m == 0) {
                                decimalIndex = 8;
                              } else if (m == 1) {
                                decimalIndex = 4;
                              } else {
                                decimalIndex = 2;
                              }
                            }
                          }
                        });
                      },
                      isExpanded: false,
                      value: selectedDecimal,
                      icon: Icon(
                        Icons.keyboard_arrow_down,
                        color: CustomTheme.of(context).splashColor,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            PopupMenuButton(
              // add icon, by default "3 dot" icon
              // icon: Icon(Icons.book)
                color: CustomTheme.of(context).backgroundColor,
                icon:Container(
                  padding: EdgeInsets.all(3.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: CustomTheme.of(context).cardColor,
                  ),
                  child: SvgPicture.asset(
                    'assets/images/align.svg',
                    height: 30.0,
                  ),
                ),
                itemBuilder: (context){
                  return [
                    PopupMenuItem<int>(
                      value: 0,
                      child: Text(
                        AppLocalizations.instance.text("loc_all").toUpperCase(),
                        style: CustomWidget(context: context).CustomTextStyle(
                            Theme.of(context).splashColor,
                            FontWeight.w500,
                            'FontRegular'),
                        textAlign: TextAlign.center,
                      ),
                    ),

                    PopupMenuItem<int>(
                      value: 1,
                      child: Text(
                        AppLocalizations.instance.text("loc_buy").toUpperCase(),
                        style: CustomWidget(context: context).CustomTextStyle(
                            Theme.of(context).splashColor,
                            FontWeight.w500,
                            'FontRegular'),
                        textAlign: TextAlign.center,
                      ),
                    ),

                    PopupMenuItem<int>(
                      value: 2,
                      child: Text(
                        AppLocalizations.instance
                            .text("loc_sell")
                            .toUpperCase(),
                        style: CustomWidget(context: context).CustomTextStyle(
                            Theme.of(context).splashColor,
                            FontWeight.w500,
                            'FontRegular'),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ];
                },
                onSelected:(value){
                  if(value == 0){
                    setState(() {
                      buyOption = true;
                      sellOption = true;
                    });
                  }else if(value == 1){
                    setState(() {
                      buyOption = true;
                      sellOption = false;
                    });
                  }else if(value == 2){
                    setState(() {
                      buyOption = false;
                      sellOption = true;
                    });
                  }
                }
            ),
           /* InkWell(
              onTap: () {

                showSuccessAlertDialog();
              },
              child: Container(
                padding: EdgeInsets.all(3.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: CustomTheme.of(context).cardColor,
                ),
                child: SvgPicture.asset(
                  'assets/images/align.svg',
                  height: 30.0,
                ),
              ),
            )*/
          ],
        ),
        const SizedBox(
          height: 12.0,
        ),
      ],
    );
  }

  Widget marketWidget() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Text(
                AppLocalizations.instance.text("loc_sell_trade_price") +
                    "\n(" +
                    secondCoin +
                    ")",
                style: CustomWidget(context: context).CustomSizedTextStyle(
                    12.0,
                    Theme.of(context).splashColor.withOpacity(0.5),
                    FontWeight.w500,
                    'FontRegular'),
              ),
            ),
            Expanded(
              child: Text(
                AppLocalizations.instance.text("loc_sell_trade_Qty") +
                    "\n(" +
                    firstCoin +
                    ")",
                style: CustomWidget(context: context).CustomSizedTextStyle(
                    12.0,
                    Theme.of(context).splashColor.withOpacity(0.5),
                    FontWeight.w500,
                    'FontRegular'),
                textAlign: TextAlign.end,
              ),
            )
          ],
        ),
        const SizedBox(
          height: 5.0,
        ),
        socketLoader
            ? Container(
                height: MediaQuery.of(context).size.height * 0.38,
                child: CustomWidget(context: context)
                    .loadingIndicator(AppColors.whiteColor),
              )
            : buyData.length > 0 && sellData.length > 0
                ? Column(
                    children: [
                      sellOption
                          ? SizedBox(
                              height: !buyOption
                                  ? MediaQuery.of(context).size.height * 0.34
                                  : MediaQuery.of(context).size.height * 0.17,
                              child: sellData.length > 0
                                  ? ListView.builder(
                                      controller: controller,
                                      itemCount: sellData.length,
                                      itemBuilder:
                                          ((BuildContext context, int index) {
                                        return Column(
                                          children: [
                                            InkWell(
                                              onTap: () {
                                                setState(() {
                                                  buySell = true;
                                                  priceController.text =
                                                      sellData[index]
                                                          .price
                                                          .toString()
                                                          .replaceAll(",", "");
                                                  amountController.text =
                                                      sellData[index]
                                                          .quantity
                                                          .toString()
                                                          .replaceAll(",", "");
                                                  totalAmount = (double.parse(
                                                              amountController
                                                                  .text
                                                                  .toString()) *
                                                          double.parse(
                                                              priceController
                                                                  .text
                                                                  .toString()))
                                                      .toStringAsFixed(4);
                                                  coinName = selectPair!
                                                      .baseAsset!.symbol
                                                      .toString();
                                                  coinTwoName = selectPair!
                                                      .marketAsset!.symbol
                                                      .toString();
                                                  getCoinDetailsList(selectPair!
                                                      .id
                                                      .toString());
                                                });
                                              },
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    double.parse(sellData[index]
                                                            .price
                                                            .toString())
                                                        .toStringAsFixed(
                                                            decimalIndex),
                                                    style: CustomWidget(
                                                            context: context)
                                                        .CustomSizedTextStyle(
                                                            10.0,
                                                            Theme.of(context)
                                                                .scaffoldBackgroundColor,
                                                            FontWeight.w500,
                                                            'FontRegular'),
                                                  ),
                                                  Text(
                                                    double.parse(sellData[index]
                                                            .quantity
                                                            .toString()
                                                            .replaceAll(
                                                                ",", ""))
                                                        .toStringAsFixed(
                                                            decimalIndex),
                                                    style: CustomWidget(
                                                            context: context)
                                                        .CustomSizedTextStyle(
                                                            10.0,
                                                            Theme.of(context)
                                                                .splashColor,
                                                            FontWeight.w500,
                                                            'FontRegular'),
                                                  ),
                                                ],
                                              ),
                                            )
                                          ],
                                        );
                                      }))
                                  : Container(
                                      height: !buyOption
                                          ? MediaQuery.of(context).size.height *
                                              0.38
                                          : MediaQuery.of(context).size.height *
                                              0.17,
                                      decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                              begin: Alignment.topCenter,
                                              end: Alignment.bottomCenter,
                                              // Add one stop for each color
                                              // Values should increase from 0.0 to 1.0
                                              stops: [
                                            0.1,
                                            0.5,
                                            0.9,
                                          ],
                                              colors: [
                                            CustomTheme.of(context)
                                                .primaryColor,
                                            CustomTheme.of(context)
                                                .backgroundColor,
                                            CustomTheme.of(context).accentColor,
                                          ])),
                                      child: Center(
                                        child: Text(
                                          " No Data Found..!",
                                          style: TextStyle(
                                            fontFamily: "FontRegular",
                                            color: CustomTheme.of(context)
                                                .splashColor,
                                          ),
                                        ),
                                      ),
                                    ),
                            )
                          : Container(
                              color: Colors.white,
                            ),
                      const SizedBox(
                        height: 10.0,
                      ),
                      buyOption
                          ? SizedBox(
                              height: !sellOption
                                  ? MediaQuery.of(context).size.height * 0.40
                                  : MediaQuery.of(context).size.height * 0.20,
                              child: buyData.length > 0
                                  ? ListView.builder(
                                      controller: controller,
                                      itemCount: buyData.length,
                                      itemBuilder:
                                          ((BuildContext context, int index) {
                                        return InkWell(
                                            onTap: () {
                                              setState(() {
                                                buySell = false;
                                                priceController.text =
                                                    buyData[index]
                                                        .price
                                                        .toString()
                                                        .replaceAll(",", "");
                                                amountController.text =
                                                    buyData[index]
                                                        .quantity
                                                        .toString()
                                                        .replaceAll(",", "");

                                                takerFee = ((double.parse(
                                                                amountController
                                                                    .text
                                                                    .toString()) *
                                                            double.parse(
                                                                priceController
                                                                    .text
                                                                    .toString()) *
                                                            double.parse(
                                                                takerFeeValue
                                                                    .toString())) /
                                                        100)
                                                    .toStringAsFixed(4);
                                                totalAmount = ((double.parse(
                                                            priceController
                                                                .text) *
                                                        double.parse(
                                                            amountController
                                                                .text)))
                                                    .toStringAsFixed(4);
                                                coinName = selectPair!
                                                    .baseAsset!.symbol
                                                    .toString();
                                                coinTwoName = selectPair!
                                                    .marketAsset!.symbol
                                                    .toString();
                                                getCoinDetailsList(
                                                    selectPair!.id.toString());
                                              });
                                            },
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  double.parse(buyData[index]
                                                          .price
                                                          .toString())
                                                      .toStringAsFixed(
                                                          decimalIndex),
                                                  style: CustomWidget(
                                                          context: context)
                                                      .CustomSizedTextStyle(
                                                          10.0,
                                                          Theme.of(context)
                                                              .indicatorColor,
                                                          FontWeight.w500,
                                                          'FontRegular'),
                                                ),
                                                Text(
                                                  double.parse(buyData[index]
                                                          .quantity
                                                          .toString()
                                                          .replaceAll(",", ""))
                                                      .toStringAsFixed(
                                                          decimalIndex),
                                                  style: CustomWidget(
                                                          context: context)
                                                      .CustomSizedTextStyle(
                                                          10.0,
                                                          Theme.of(context)
                                                              .splashColor,
                                                          FontWeight.w500,
                                                          'FontRegular'),
                                                ),
                                              ],
                                            ));
                                      }))
                                  : Container(
                                      height: !sellOption
                                          ? MediaQuery.of(context).size.height *
                                              0.40
                                          : MediaQuery.of(context).size.height *
                                              0.20,
                                      decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                              begin: Alignment.topCenter,
                                              end: Alignment.bottomCenter,
                                              // Add one stop for each color
                                              // Values should increase from 0.0 to 1.0
                                              stops: [
                                            0.1,
                                            0.5,
                                            0.9,
                                          ],
                                              colors: [
                                            CustomTheme.of(context)
                                                .primaryColor,
                                            CustomTheme.of(context)
                                                .backgroundColor,
                                            CustomTheme.of(context).accentColor,
                                          ])),
                                      child: Center(
                                        child: Text(
                                          " No Data Found..!",
                                          style: TextStyle(
                                            fontFamily: "FontRegular",
                                            color: CustomTheme.of(context)
                                                .splashColor,
                                          ),
                                        ),
                                      ),
                                    ))
                          : Container(),
                    ],
                  )
                : Container(
                    height: MediaQuery.of(context).size.height * 0.40,
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            // Add one stop for each color
                            // Values should increase from 0.0 to 1.0
                            stops: [
                          0.1,
                          0.5,
                          0.9,
                        ],
                            colors: [
                          CustomTheme.of(context).primaryColor,
                          CustomTheme.of(context).backgroundColor,
                          CustomTheme.of(context).accentColor,
                        ])),
                    child: Center(
                      child: Text(
                        " No Data Found..!",
                        style: TextStyle(
                          fontFamily: "FontRegular",
                          color: CustomTheme.of(context).splashColor,
                        ),
                      ),
                    ),
                  ),
        const SizedBox(
          height: 12.0,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              height: 35.0,
              padding: const EdgeInsets.only(
                  left: 10.0, right: 10.0, top: 0.0, bottom: 0.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5.0),
                color: CustomTheme.of(context).cardColor,
              ),
              child: Center(
                child: Theme(
                  data: Theme.of(context).copyWith(
                    canvasColor: CustomTheme.of(context).backgroundColor,
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton(
                      items: _decimal
                          .map((value) => DropdownMenuItem(
                                child: Text(
                                  value,
                                  style: CustomWidget(context: context)
                                      .CustomSizedTextStyle(
                                          12.0,
                                          Theme.of(context).splashColor,
                                          FontWeight.w500,
                                          'FontRegular'),
                                ),
                                value: value,
                              ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedDecimal = value.toString();
                          for (int m = 0; m < _decimal.length; m++) {
                            if (value == _decimal[m]) {
                              if (m == 0) {
                                decimalIndex = 8;
                              } else if (m == 1) {
                                decimalIndex = 4;
                              } else {
                                decimalIndex = 2;
                              }
                            }
                          }
                        });
                      },
                      isExpanded: false,
                      value: selectedDecimal,
                      icon: Icon(
                        Icons.keyboard_arrow_down,
                        color: CustomTheme.of(context).splashColor,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            InkWell(
              onTap: () {
                showSuccessAlertDialog();
              },
              child: Container(
                padding: EdgeInsets.all(3.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: CustomTheme.of(context).cardColor,
                ),
                child: SvgPicture.asset(
                  'assets/images/align.svg',
                  height: 30.0,
                ),
              ),
            )
          ],
        )
      ],
    );
  }

  Widget openOrdersUIS() {
    return Column(
      children: [
        openOrders.length > 0
            ? Container(
                color: Theme.of(context).backgroundColor,
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.3,
                child: ListView.builder(
                  itemCount: openOrders.length,
                  shrinkWrap: true,
                  controller: controller,
                  itemBuilder: (BuildContext context, int index) {
                    Moment spiritRoverOnMars =
                        Moment(openOrders[index].createdAt!).toLocal();
                    return Column(
                      children: [
                        Theme(
                          data: Theme.of(context)
                              .copyWith(dividerColor: Colors.transparent),
                          child: ExpansionTile(
                            key: PageStorageKey(index.toString()),
                            title: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Pair",
                                      style: CustomWidget(context: context)
                                          .CustomSizedTextStyle(
                                              12.0,
                                              Theme.of(context)
                                                  .splashColor
                                                  .withOpacity(0.5),
                                              FontWeight.w400,
                                              'FontRegular'),
                                    ),
                                    Text(
                                      openOrders[index].pair_symbol.toString(),
                                      style: CustomWidget(context: context)
                                          .CustomSizedTextStyle(
                                              14.0,
                                              Theme.of(context).splashColor,
                                              FontWeight.w400,
                                              'FontRegular'),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  width: 10.0,
                                ),
                                const Icon(
                                  Icons.keyboard_arrow_down_outlined,
                                  color: AppColors.whiteColor,
                                  size: 18.0,
                                )
                              ],
                            ),
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 10.0, right: 10.0),
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(
                                          left: 5.0, right: 5.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Column(
                                            children: [
                                              Text(
                                                "Date",
                                                style: CustomWidget(
                                                        context: context)
                                                    .CustomSizedTextStyle(
                                                        12.0,
                                                        Theme.of(context)
                                                            .splashColor
                                                            .withOpacity(0.5),
                                                        FontWeight.w400,
                                                        'FontRegular'),
                                              ),
                                              Text(
                                                spiritRoverOnMars
                                                    .format(
                                                        "YYYY MMMM Do - hh:mm:ssa")
                                                    .toString(),
                                                style: CustomWidget(
                                                        context: context)
                                                    .CustomSizedTextStyle(
                                                        12.0,
                                                        Theme.of(context)
                                                            .splashColor,
                                                        FontWeight.w400,
                                                        'FontRegular'),
                                              ),
                                            ],
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                          ),
                                          Column(
                                            children: [
                                              Text(
                                                "Type",
                                                style: CustomWidget(
                                                        context: context)
                                                    .CustomSizedTextStyle(
                                                        12.0,
                                                        Theme.of(context)
                                                            .splashColor
                                                            .withOpacity(0.5),
                                                        FontWeight.w400,
                                                        'FontRegular'),
                                              ),
                                              Text(
                                                openOrders[index]
                                                    .tradeType
                                                    .toString(),
                                                style: CustomWidget(
                                                        context: context)
                                                    .CustomSizedTextStyle(
                                                        14.0,
                                                        openOrders[index]
                                                                    .tradeType
                                                                    .toString()
                                                                    .toLowerCase() ==
                                                                "buy"
                                                            ? CustomTheme.of(
                                                                    context)
                                                                .indicatorColor
                                                            : CustomTheme.of(
                                                                    context)
                                                                .scaffoldBackgroundColor,
                                                        FontWeight.w500,
                                                        'FontRegular'),
                                              ),
                                            ],
                                          ),
                                          Column(
                                            children: [
                                              Text(
                                                "Order Type",
                                                style: CustomWidget(
                                                        context: context)
                                                    .CustomSizedTextStyle(
                                                        12.0,
                                                        Theme.of(context)
                                                            .splashColor
                                                            .withOpacity(0.5),
                                                        FontWeight.w400,
                                                        'FontRegular'),
                                              ),
                                              Text(
                                                openOrders[index]
                                                    .orderType
                                                    .toString(),
                                                style: CustomWidget(
                                                        context: context)
                                                    .CustomSizedTextStyle(
                                                        12.0,
                                                        Theme.of(context)
                                                            .splashColor,
                                                        FontWeight.w400,
                                                        'FontRegular'),
                                              ),
                                            ],
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                          )
                                        ],
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10.0,
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(
                                          left: 5.0, right: 5.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Column(
                                            children: [
                                              Text(
                                                "Price",
                                                style: CustomWidget(
                                                        context: context)
                                                    .CustomSizedTextStyle(
                                                        12.0,
                                                        Theme.of(context)
                                                            .splashColor
                                                            .withOpacity(0.5),
                                                        FontWeight.w400,
                                                        'FontRegular'),
                                              ),
                                              Text(
                                                openOrders[index]
                                                    .price
                                                    .toString(),
                                                style: CustomWidget(
                                                        context: context)
                                                    .CustomSizedTextStyle(
                                                        12.0,
                                                        Theme.of(context)
                                                            .splashColor,
                                                        FontWeight.w400,
                                                        'FontRegular'),
                                              ),
                                            ],
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                          ),
                                          Column(
                                            children: [
                                              Text(
                                                "Quantity",
                                                style: CustomWidget(
                                                        context: context)
                                                    .CustomSizedTextStyle(
                                                        12.0,
                                                        Theme.of(context)
                                                            .splashColor
                                                            .withOpacity(0.5),
                                                        FontWeight.w400,
                                                        'FontRegular'),
                                              ),
                                              Text(
                                                openOrders[index]
                                                    .volume
                                                    .toString(),
                                                style: CustomWidget(
                                                        context: context)
                                                    .CustomSizedTextStyle(
                                                        12.0,
                                                        Theme.of(context)
                                                            .splashColor,
                                                        FontWeight.w400,
                                                        'FontRegular'),
                                              ),
                                            ],
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10.0,
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(
                                          left: 5.0, right: 5.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Column(
                                            children: [
                                              Text(
                                                "Total",
                                                style: CustomWidget(
                                                        context: context)
                                                    .CustomSizedTextStyle(
                                                        12.0,
                                                        Theme.of(context)
                                                            .splashColor
                                                            .withOpacity(0.5),
                                                        FontWeight.w400,
                                                        'FontRegular'),
                                              ),
                                              Text(
                                                openOrders[index]
                                                    .value
                                                    .toString(),
                                                style: CustomWidget(
                                                        context: context)
                                                    .CustomSizedTextStyle(
                                                        12.0,
                                                        Theme.of(context)
                                                            .splashColor,
                                                        FontWeight.w400,
                                                        'FontRegular'),
                                              ),
                                            ],
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                          ),
                                          InkWell(
                                            child: Container(
                                              width: 80,
                                              padding: const EdgeInsets.only(
                                                  top: 3.0, bottom: 3.0),
                                              decoration: BoxDecoration(
                                                color: Colors.red,
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                              ),
                                              child: Align(
                                                alignment: Alignment.center,
                                                child: Text(
                                                  "Cancel",
                                                  style: CustomWidget(
                                                          context: context)
                                                      .CustomSizedTextStyle(
                                                          12.0,
                                                          Theme.of(context)
                                                              .splashColor,
                                                          FontWeight.w400,
                                                          'FontRegular'),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                            ),
                                            onTap: () {
                                              setState(() {
                                                loading = true;
                                                updatecancelOrder(
                                                    openOrders[index]
                                                        .id
                                                        .toString());
                                              });
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10.0,
                                    ),
                                  ],
                                ),
                              )
                            ],
                            trailing: Container(
                              width: 1.0,
                              height: 10.0,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 5.0,
                        ),
                        Container(
                          height: 1.0,
                          width: MediaQuery.of(context).size.width,
                          color: Theme.of(context).splashColor,
                        ),
                      ],
                    );
                  },
                ),
              )
            : Container(
                height: MediaQuery.of(context).size.height * 0.3,
                color: Theme.of(context).backgroundColor,
                child: Center(
                  child: Text(
                    "No Records Found..!",
                    style: CustomWidget(context: context).CustomSizedTextStyle(
                        12.0,
                        Theme.of(context).splashColor,
                        FontWeight.w400,
                        'FontRegular'),
                  ),
                ),
              ),
        const SizedBox(
          height: 30.0,
        )
      ],
    );
  }

  Widget openFutureOrdersUIS() {
    return Column(
      children: [
        FutureopenOrders.length > 0
            ? Container(
                color: Theme.of(context).backgroundColor,
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.82,
                child: SingleChildScrollView(
                  controller: controller,
                  child: ListView.builder(
                    itemCount: FutureopenOrders.length,
                    shrinkWrap: true,
                    controller: controller,
                    itemBuilder: (BuildContext context, int index) {
                      Moment spiritRoverOnMars = Moment.parse(
                          FutureopenOrders[index].createdAt!.toString());
                      return Column(
                        children: [
                          Theme(
                            data: Theme.of(context)
                                .copyWith(dividerColor: Colors.transparent),
                            child: ExpansionTile(
                              key: PageStorageKey(index.toString()),
                              title: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Pair",
                                        style: CustomWidget(context: context)
                                            .CustomSizedTextStyle(
                                                12.0,
                                                Theme.of(context)
                                                    .splashColor
                                                    .withOpacity(0.5),
                                                FontWeight.w400,
                                                'FontRegular'),
                                      ),
                                      Text(
                                        FutureopenOrders[index]
                                            .pairSymbol
                                            .toString(),
                                        style: CustomWidget(context: context)
                                            .CustomSizedTextStyle(
                                                14.0,
                                                Theme.of(context).splashColor,
                                                FontWeight.w400,
                                                'FontRegular'),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    width: 10.0,
                                  ),
                                  const Icon(
                                    Icons.keyboard_arrow_down_outlined,
                                    color: AppColors.whiteColor,
                                    size: 18.0,
                                  )
                                ],
                              ),
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 10.0, right: 10.0),
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(
                                            left: 5.0, right: 5.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Column(
                                              children: [
                                                Text(
                                                  "Date",
                                                  style: CustomWidget(
                                                          context: context)
                                                      .CustomSizedTextStyle(
                                                          12.0,
                                                          Theme.of(context)
                                                              .splashColor
                                                              .withOpacity(0.5),
                                                          FontWeight.w400,
                                                          'FontRegular'),
                                                ),
                                                Text(
                                                  spiritRoverOnMars
                                                      .format(
                                                          "YYYY MMMM Do - hh:mm:ssa")
                                                      .toString(),
                                                  style: CustomWidget(
                                                          context: context)
                                                      .CustomSizedTextStyle(
                                                          12.0,
                                                          Theme.of(context)
                                                              .splashColor,
                                                          FontWeight.w400,
                                                          'FontRegular'),
                                                ),
                                              ],
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                            ),
                                            Column(
                                              children: [
                                                Text(
                                                  "Type",
                                                  style: CustomWidget(
                                                          context: context)
                                                      .CustomSizedTextStyle(
                                                          12.0,
                                                          Theme.of(context)
                                                              .splashColor
                                                              .withOpacity(0.5),
                                                          FontWeight.w400,
                                                          'FontRegular'),
                                                ),
                                                Text(
                                                  FutureopenOrders[index]
                                                      .tradeType
                                                      .toString(),
                                                  style: CustomWidget(
                                                          context: context)
                                                      .CustomSizedTextStyle(
                                                          14.0,
                                                          FutureopenOrders[
                                                                          index]
                                                                      .tradeType
                                                                      .toString()
                                                                      .toLowerCase() ==
                                                                  "buy"
                                                              ? CustomTheme.of(
                                                                      context)
                                                                  .indicatorColor
                                                              : CustomTheme.of(
                                                                      context)
                                                                  .scaffoldBackgroundColor,
                                                          FontWeight.w500,
                                                          'FontRegular'),
                                                ),
                                              ],
                                            ),
                                            Column(
                                              children: [
                                                Text(
                                                  "Order Type",
                                                  style: CustomWidget(
                                                          context: context)
                                                      .CustomSizedTextStyle(
                                                          12.0,
                                                          Theme.of(context)
                                                              .splashColor
                                                              .withOpacity(0.5),
                                                          FontWeight.w400,
                                                          'FontRegular'),
                                                ),
                                                Text(
                                                  FutureopenOrders[index]
                                                      .orderType
                                                      .toString(),
                                                  style: CustomWidget(
                                                          context: context)
                                                      .CustomSizedTextStyle(
                                                          12.0,
                                                          Theme.of(context)
                                                              .splashColor,
                                                          FontWeight.w400,
                                                          'FontRegular'),
                                                ),
                                              ],
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                            )
                                          ],
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 10.0,
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(
                                            left: 5.0, right: 5.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Column(
                                              children: [
                                                Text(
                                                  "Price",
                                                  style: CustomWidget(
                                                          context: context)
                                                      .CustomSizedTextStyle(
                                                          12.0,
                                                          Theme.of(context)
                                                              .splashColor
                                                              .withOpacity(0.5),
                                                          FontWeight.w400,
                                                          'FontRegular'),
                                                ),
                                                Text(
                                                  FutureopenOrders[index]
                                                      .price
                                                      .toString(),
                                                  style: CustomWidget(
                                                          context: context)
                                                      .CustomSizedTextStyle(
                                                          12.0,
                                                          Theme.of(context)
                                                              .splashColor,
                                                          FontWeight.w400,
                                                          'FontRegular'),
                                                ),
                                              ],
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                            ),
                                            Column(
                                              children: [
                                                Text(
                                                  "Quantity",
                                                  style: CustomWidget(
                                                          context: context)
                                                      .CustomSizedTextStyle(
                                                          12.0,
                                                          Theme.of(context)
                                                              .splashColor
                                                              .withOpacity(0.5),
                                                          FontWeight.w400,
                                                          'FontRegular'),
                                                ),
                                                Text(
                                                  FutureopenOrders[index]
                                                      .volume
                                                      .toString(),
                                                  style: CustomWidget(
                                                          context: context)
                                                      .CustomSizedTextStyle(
                                                          12.0,
                                                          Theme.of(context)
                                                              .splashColor,
                                                          FontWeight.w400,
                                                          'FontRegular'),
                                                ),
                                              ],
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 10.0,
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(
                                            left: 5.0, right: 5.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Column(
                                              children: [
                                                Text(
                                                  "Total",
                                                  style: CustomWidget(
                                                          context: context)
                                                      .CustomSizedTextStyle(
                                                          12.0,
                                                          Theme.of(context)
                                                              .splashColor
                                                              .withOpacity(0.5),
                                                          FontWeight.w400,
                                                          'FontRegular'),
                                                ),
                                                Text(
                                                  FutureopenOrders[index]
                                                      .value
                                                      .toString(),
                                                  style: CustomWidget(
                                                          context: context)
                                                      .CustomSizedTextStyle(
                                                          12.0,
                                                          Theme.of(context)
                                                              .splashColor,
                                                          FontWeight.w400,
                                                          'FontRegular'),
                                                ),
                                              ],
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                            ),
                                            InkWell(
                                              child: Container(
                                                width: 80,
                                                padding: const EdgeInsets.only(
                                                    top: 3.0, bottom: 3.0),
                                                decoration: BoxDecoration(
                                                  color: Colors.red,
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                ),
                                                child: Align(
                                                  alignment: Alignment.center,
                                                  child: Text(
                                                    "Cancel",
                                                    style: CustomWidget(
                                                            context: context)
                                                        .CustomSizedTextStyle(
                                                            12.0,
                                                            Theme.of(context)
                                                                .splashColor,
                                                            FontWeight.w400,
                                                            'FontRegular'),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ),
                                              ),
                                              onTap: () {
                                                setState(() {
                                                  loading = true;
                                                  updatecancelOrder(
                                                    FutureopenOrders[index]
                                                        .id
                                                        .toString(),
                                                  );
                                                });
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 10.0,
                                      ),
                                    ],
                                  ),
                                )
                              ],
                              trailing: Container(
                                width: 1.0,
                                height: 10.0,
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 5.0,
                          ),
                          Container(
                            height: 1.0,
                            width: MediaQuery.of(context).size.width,
                            color: Theme.of(context).splashColor,
                          ),
                        ],
                      );
                    },
                  ),
                ))
            : Container(
                height: MediaQuery.of(context).size.height * 0.3,
                color: Theme.of(context).backgroundColor,
                child: Center(
                  child: Text(
                    "No Records Found..!",
                    style: CustomWidget(context: context).CustomSizedTextStyle(
                        12.0,
                        Theme.of(context).splashColor,
                        FontWeight.w400,
                        'FontRegular'),
                  ),
                ),
              ),
        const SizedBox(
          height: 30.0,
        )
      ],
    );
  }

  showSuccessAlertDialog() {
    showDialog(
        context: context,
        builder: (BuildContext contexts) {
          return Align(
            alignment: const Alignment(0, 1),
            child: Material(
              color: CustomTheme.of(context).backgroundColor,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0)),
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    InkWell(
                      onTap: () {
                        setState(() {
                          Navigator.pop(contexts);
                          buyOption = true;
                          sellOption = true;
                        });
                      },
                      child: Text(
                        AppLocalizations.instance.text("loc_all").toUpperCase(),
                        style: CustomWidget(context: context).CustomTextStyle(
                            Theme.of(context).splashColor,
                            FontWeight.w500,
                            'FontRegular'),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          Navigator.pop(contexts);
                          buyOption = true;
                          sellOption = false;
                        });
                      },
                      child: Text(
                        AppLocalizations.instance.text("loc_buy").toUpperCase(),
                        style: CustomWidget(context: context).CustomTextStyle(
                            Theme.of(context).splashColor,
                            FontWeight.w500,
                            'FontRegular'),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          Navigator.pop(contexts);
                          buyOption = false;
                          sellOption = true;
                        });
                      },
                      child: Text(
                        AppLocalizations.instance
                            .text("loc_sell")
                            .toUpperCase(),
                        style: CustomWidget(context: context).CustomTextStyle(
                            Theme.of(context).splashColor,
                            FontWeight.w500,
                            'FontRegular'),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
    // show the dialog
  }

  Widget OrderWidget() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            border: Border.all(
                color: CustomTheme.of(context).splashColor.withOpacity(0.3),
                width: 1.0),
            borderRadius: BorderRadius.circular(5.0),
            color: Colors.transparent,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      buySell = true;
                      amountController.clear();
                      priceController.clear();
                      stopPriceController.clear();
                      totalAmount = "0.0";
                      _currentSliderValue = 0;
                      tleverageVal = "1";
                      getCoinDetailsList(selectPair!.id.toString());
                      coinName = selectPair!.baseAsset!.symbol.toString();
                      coinTwoName = selectPair!.marketAsset!.symbol.toString();
                    });
                  },
                  child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(5),
                            topRight: Radius.circular(0),
                            bottomLeft: Radius.circular(5),
                            bottomRight: Radius.circular(0),
                          ),
                          color: buySell
                              ? CustomTheme.of(context).indicatorColor
                              : Colors.transparent),
                      child: Center(
                          child: Padding(
                        padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                        child: Text(
                          AppLocalizations.instance.text("loc_sell_trade_txt5"),
                          style: CustomWidget(context: context)
                              .CustomSizedTextStyle(
                                  13.0,
                                  buySell
                                      ? CustomTheme.of(context).splashColor
                                      : CustomTheme.of(context)
                                          .hintColor
                                          .withOpacity(0.5),
                                  FontWeight.w500,
                                  'FontRegular'),
                        ),
                      ))),
                ),
              ),
              Flexible(
                  child: GestureDetector(
                onTap: () {
                  setState(() {
                    buySell = false;
                    amountController.clear();
                    priceController.clear();
                    stopPriceController.clear();
                    totalAmount = "0.0";
                    _currentSliderValue = 0;
                    tleverageVal = "1";
                    getCoinDetailsList(selectPair!.id.toString());
                    coinName = selectPair!.baseAsset!.symbol.toString();
                    coinTwoName = selectPair!.marketAsset!.symbol.toString();
                  });
                },
                child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(0),
                          topRight: Radius.circular(5),
                          bottomLeft: Radius.circular(0),
                          bottomRight: Radius.circular(5),
                        ),
                        color: !buySell
                            ? CustomTheme.of(context).scaffoldBackgroundColor
                            : Colors.transparent),
                    child: Center(
                        child: Padding(
                      padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                      child: Text(
                        AppLocalizations.instance.text("loc_sell_trade_txt6"),
                        style: CustomWidget(context: context)
                            .CustomSizedTextStyle(
                                13.0,
                                !buySell
                                    ? CustomTheme.of(context).splashColor
                                    : CustomTheme.of(context)
                                        .hintColor
                                        .withOpacity(0.5),
                                FontWeight.w500,
                                'FontRegular'),
                      ),
                    ))),
              ))
            ],
          ),
        ),
        SizedBox(
          height: 15.0,
        ),
        Container(
          width: MediaQuery.of(context).size.width,
          height: 35.0,
          padding: EdgeInsets.fromLTRB(5, 0.0, 5, 0.0),
          decoration: BoxDecoration(
            border: Border.all(
                color: CustomTheme.of(context).hintColor.withOpacity(0.5),
                width: 1.0),
            borderRadius: BorderRadius.circular(5.0),
            color: Colors.transparent,
          ),
          child: Theme(
            data: Theme.of(context).copyWith(
              canvasColor: CustomTheme.of(context).backgroundColor,
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton(
                menuMaxHeight: MediaQuery.of(context).size.height * 0.7,
                items: !futureOption
                    ? chartTime
                        .map((value) => DropdownMenuItem(
                              child: Text(
                                value.toString(),
                                style: CustomWidget(context: context)
                                    .CustomSizedTextStyle(
                                        10.0,
                                        Theme.of(context).errorColor,
                                        FontWeight.w500,
                                        'FontRegular'),
                              ),
                              value: value,
                            ))
                        .toList()
                    : chartTimeFuture
                        .map((value) => DropdownMenuItem(
                              child: Text(
                                value.toString(),
                                style: CustomWidget(context: context)
                                    .CustomSizedTextStyle(
                                        10.0,
                                        Theme.of(context).errorColor,
                                        FontWeight.w500,
                                        'FontRegular'),
                              ),
                              value: value,
                            ))
                        .toList(),
                onChanged: (value) async {
                  setState(() {
                    selectedTime = value.toString();
                    if (selectedTime == "Limit Order") {
                      enableTrade = false;
                      _currentSliderValue = 0;
                      tleverageVal = "1";
                      enableStopLimit = false;
                      priceController.clear();
                      amountController.clear();
                      totalAmount = "0.00";
                    } else if (selectedTime == "Market Order") {
                      priceController.clear();
                      _currentSliderValue = 0;
                      tleverageVal = "1";
                      amountController.clear();
                      enableStopLimit = false;
                      totalAmount = "0.00";
                      enableTrade = true;
                    } else {
                      enableStopLimit = true;
                      _currentSliderValue = 0;
                      tleverageVal = "1";
                      priceController.clear();
                      amountController.clear();
                      stopPriceController.clear();
                      totalAmount = "0.00";
                      enableTrade = false;
                    }
                  });
                },
                hint: Text(
                  "Select Category",
                  style: CustomWidget(context: context).CustomSizedTextStyle(
                      12.0,
                      Theme.of(context).errorColor,
                      FontWeight.w500,
                      'FontRegular'),
                ),
                isExpanded: true,
                value: selectedTime,
                icon: const Icon(
                  Icons.arrow_drop_down,
                  // color: AppColors.otherTextColor,
                ),
              ),
            ),
          ),
        ),
        SizedBox(
          height: 20.0,
        ),
        Container(
          padding: EdgeInsets.fromLTRB(5.0, 0.0, 0.0, 0.0),
          decoration: BoxDecoration(
            border: Border.all(
                color: enableTrade
                    ? Theme.of(context).hintColor.withOpacity(0.1)
                    : CustomTheme.of(context).hintColor.withOpacity(0.5),
                width: 1.0),
            borderRadius: BorderRadius.circular(5.0),
            color: Colors.transparent,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                  child: Container(
                height: 40.0,
                child: TextField(
                  enabled: !enableTrade,
                  controller: priceController,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  style: CustomWidget(context: context).CustomSizedTextStyle(
                      13.0,
                      Theme.of(context).splashColor,
                      FontWeight.w500,
                      'FontRegular'),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                  ],
                  onChanged: (value) {
                    setState(() {
                      price = "0.0";
                      // price = value.toString();
                      tradeAmount = "0.00";

                      if (priceController.text.isNotEmpty) {
                        double amount = double.parse(priceController.text);
                        price = priceController.text;
                        if (enableStopLimit) {
                          if (priceController.text.isNotEmpty &&
                              stopPriceController.text.isNotEmpty) {
                            if ((double.parse(priceController.text.toString()) >
                                double.parse(
                                    stopPriceController.text.toString()))) {
                              takerFee = ((double.parse(
                                              priceController.text.toString()) *
                                          double.parse(amountController.text
                                              .toString()) *
                                          double.parse(
                                              takerFeeValue.toString())) /
                                      100)
                                  .toStringAsFixed(4);

                              totalAmount = (double.parse(
                                          amountController.text.toString()) *
                                      double.parse(
                                          priceController.text.toString()))
                                  .toStringAsFixed(4);
                              /*  totalAmount = ((double.parse(
                                    priceController.text
                                        .toString()) *
                                    double.parse(amountController
                                        .text
                                        .toString())) -
                                    double.parse(takerFee))
                                    .toStringAsFixed(4);*/
                            } else {
                              takerFee = ((double.parse(stopPriceController.text
                                              .toString()) *
                                          double.parse(amountController.text
                                              .toString()) *
                                          double.parse(
                                              takerFeeValue.toString())) /
                                      100)
                                  .toStringAsFixed(4);

                              totalAmount = (double.parse(
                                          amountController.text.toString()) *
                                      double.parse(
                                          stopPriceController.text.toString()))
                                  .toStringAsFixed(4);

                              /*totalAmount = ((double.parse(
                                    stopPriceController.text
                                        .toString()) *
                                    double.parse(amountController
                                        .text
                                        .toString())) -
                                    double.parse(takerFee))
                                    .toStringAsFixed(4);*/
                            }
                          }
                        } else {
                          if (priceController.text.isNotEmpty) {
                            if (!buySell) {
                              takerFee = ((amount *
                                          double.parse(
                                              priceController.text.toString()) *
                                          double.parse(
                                              takerFeeValue.toString())) /
                                      100)
                                  .toStringAsFixed(4);

                              totalAmount = (double.parse(
                                          amountController.text.toString()) *
                                      double.parse(
                                          priceController.text.toString()))
                                  .toStringAsFixed(4);
                            } else {
                              totalAmount = (double.parse(
                                          amountController.text.toString()) *
                                      double.parse(
                                          priceController.text.toString()))
                                  .toStringAsFixed(4);
                            }
                          }
                        }
                        /* if (!buySell) {
                              takerFee = ((amount *
                                  double.parse(amountController.text
                                      .toString()) *
                                  double.parse(
                                      takerFeeValue.toString())) /
                                  100)
                                  .toStringAsFixed(4);

                              totalAmount = ((double.parse(amountController.text
                                  .toString()) *
                                  double.parse(priceController.text
                                      .toString())) -
                                  double.parse(takerFee))
                                  .toStringAsFixed(4);
                            } else {*/
                        /* totalAmount = (double.parse(
                                  amountController.text.toString()) *
                                  double.parse(
                                      priceController.text.toString()))
                                  .toStringAsFixed(4);*/
                        // }
                      } else {
                        tradeAmount = "0.00";
                        totalAmount = "0.00";
                      }
                    });
                  },
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.only(bottom: 8.0),
                      hintText: "Price",
                      hintStyle: CustomWidget(context: context)
                          .CustomSizedTextStyle(
                              12.0,
                              Theme.of(context).splashColor.withOpacity(0.5),
                              FontWeight.w500,
                              'FontRegular'),
                      border: InputBorder.none),
                  textAlign: TextAlign.start,
                ),
              )),
              InkWell(
                onTap: () {
                  if (enableTrade) {
                  } else {
                    setState(() {
                      if (priceController.text.isNotEmpty) {
                        double amount = double.parse(priceController.text);
                        if (amount > 0) {
                          amount = amount - 0.01;
                          priceController.text = amount.toStringAsFixed(2);
                          tradeAmount = priceController.text;
                          if (enableStopLimit) {
                            if (stopPriceController.text.isNotEmpty &&
                                priceController.text.isNotEmpty) {
                              if ((double.parse(
                                      priceController.text.toString()) >
                                  double.parse(
                                      stopPriceController.text.toString()))) {
                                takerFee =
                                    ((double.parse(priceController.text
                                                    .toString()) *
                                                double.parse(amountController
                                                    .text
                                                    .toString()) *
                                                double.parse(
                                                    takerFeeValue.toString())) /
                                            100)
                                        .toStringAsFixed(4);

                                totalAmount = (double.parse(
                                            amountController.text.toString()) *
                                        double.parse(
                                            priceController.text.toString()))
                                    .toStringAsFixed(4);
                                /*  totalAmount = ((double.parse(
                                    priceController.text
                                        .toString()) *
                                    double.parse(amountController
                                        .text
                                        .toString())) -
                                    double.parse(takerFee))
                                    .toStringAsFixed(4);*/
                              } else {
                                takerFee = ((double.parse(stopPriceController
                                                .text
                                                .toString()) *
                                            double.parse(amountController.text
                                                .toString()) *
                                            double.parse(
                                                takerFeeValue.toString())) /
                                        100)
                                    .toStringAsFixed(4);

                                totalAmount = (double.parse(
                                            amountController.text.toString()) *
                                        double.parse(livePrice))
                                    .toStringAsFixed(4);

                                /*totalAmount = ((double.parse(
                                    stopPriceController.text
                                        .toString()) *
                                    double.parse(amountController
                                        .text
                                        .toString())) -
                                    double.parse(takerFee))
                                    .toStringAsFixed(4);*/
                              }
                            }
                          } else {
                            if (priceController.text.isNotEmpty) {
                              if (!buySell) {
                                takerFee = ((amount *
                                            double.parse(priceController.text
                                                .toString()) *
                                            double.parse(
                                                takerFeeValue.toString())) /
                                        100)
                                    .toStringAsFixed(4);

                                totalAmount = (double.parse(
                                            amountController.text.toString()) *
                                        double.parse(
                                            priceController.text.toString()))
                                    .toStringAsFixed(4);
                              } else {
                                totalAmount = (double.parse(
                                            amountController.text.toString()) *
                                        double.parse(
                                            priceController.text.toString()))
                                    .toStringAsFixed(4);
                              }
                            }
                          }
                        }
                      } else {
                        priceController.text = "0.01";
                        tradeAmount = amountController.text;
                        totalAmount = "0.000";
                      }
                    });
                  }
                },
                child: Container(
                    height: 40.0,
                    width: 35.0,
                    padding: const EdgeInsets.only(
                      left: 10.0,
                      right: 10.0,
                    ),
                    decoration: BoxDecoration(
                      color: enableTrade
                          ? Theme.of(context).cardColor.withOpacity(0.2)
                          : CustomTheme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(2),
                    ),
                    child: Center(
                      child: Text(
                        "-",
                        style: CustomWidget(context: context)
                            .CustomSizedTextStyle(
                                20.0,
                                enableTrade
                                    ? Theme.of(context)
                                        .cardColor
                                        .withOpacity(0.5)
                                    : Theme.of(context).splashColor,
                                FontWeight.w500,
                                'FontRegular'),
                      ),
                    )),
              ),
              const SizedBox(
                width: 2.0,
              ),
              InkWell(
                onTap: () {
                  if (enableTrade) {
                  } else {
                    setState(() {
                      if (priceController.text.isNotEmpty) {
                        double amount = double.parse(priceController.text);
                        if (amount >= 0) {
                          amount = amount + 0.01;
                          priceController.text = amount.toStringAsFixed(2);
                          tradeAmount = priceController.text;
                          if (enableStopLimit) {
                            if (stopPriceController.text.isNotEmpty &&
                                priceController.text.isNotEmpty) {
                              if ((double.parse(
                                      priceController.text.toString()) >
                                  double.parse(
                                      stopPriceController.text.toString()))) {
                                takerFee =
                                    ((double.parse(priceController.text
                                                    .toString()) *
                                                double.parse(amountController
                                                    .text
                                                    .toString()) *
                                                double.parse(
                                                    takerFeeValue.toString())) /
                                            100)
                                        .toStringAsFixed(4);

                                totalAmount = (double.parse(
                                            amountController.text.toString()) *
                                        double.parse(
                                            priceController.text.toString()))
                                    .toStringAsFixed(4);
                                /*  totalAmount = ((double.parse(
                                    priceController.text
                                        .toString()) *
                                    double.parse(amountController
                                        .text
                                        .toString())) -
                                    double.parse(takerFee))
                                    .toStringAsFixed(4);*/
                              } else {
                                takerFee = ((double.parse(stopPriceController
                                                .text
                                                .toString()) *
                                            double.parse(amountController.text
                                                .toString()) *
                                            double.parse(
                                                takerFeeValue.toString())) /
                                        100)
                                    .toStringAsFixed(4);

                                totalAmount = (double.parse(
                                            amountController.text.toString()) *
                                        double.parse(livePrice))
                                    .toStringAsFixed(4);

                                /*totalAmount = ((double.parse(
                                    stopPriceController.text
                                        .toString()) *
                                    double.parse(amountController
                                        .text
                                        .toString())) -
                                    double.parse(takerFee))
                                    .toStringAsFixed(4);*/
                              }
                            }
                          } else {
                            if (priceController.text.isNotEmpty) {
                              if (!buySell) {
                                takerFee = ((amount *
                                            double.parse(priceController.text
                                                .toString()) *
                                            double.parse(
                                                takerFeeValue.toString())) /
                                        100)
                                    .toStringAsFixed(4);

                                totalAmount = (double.parse(
                                            amountController.text.toString()) *
                                        double.parse(
                                            priceController.text.toString()))
                                    .toStringAsFixed(4);
                              } else {
                                totalAmount = (double.parse(
                                            amountController.text.toString()) *
                                        double.parse(
                                            priceController.text.toString()))
                                    .toStringAsFixed(4);
                              }
                            }
                          }
                        }
                      } else {
                        priceController.text = "0.01";
                        tradeAmount = amountController.text;
                        totalAmount = "0.000";
                      }
                    });
                  }
                },
                child: Container(
                    height: 40.0,
                    width: 35.0,
                    padding: const EdgeInsets.only(
                      left: 10.0,
                      right: 10.0,
                    ),
                    decoration: BoxDecoration(
                      color: enableTrade
                          ? Theme.of(context).cardColor.withOpacity(0.2)
                          : CustomTheme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(2),
                    ),
                    child: Center(
                      child: Text(
                        "+",
                        style: CustomWidget(context: context)
                            .CustomSizedTextStyle(
                                20.0,
                                enableTrade
                                    ? Theme.of(context)
                                        .cardColor
                                        .withOpacity(0.2)
                                    : Theme.of(context).splashColor,
                                FontWeight.w500,
                                'FontRegular'),
                      ),
                    )),
              ),
            ],
          ),
        ),
        enableTrade
            ? Container()
            : const SizedBox(
                height: 5.0,
              ),
        SizedBox(
          height: 15.0,
        ),
        Container(
          padding: EdgeInsets.fromLTRB(5.0, 0.0, 0.0, 0.0),
          decoration: BoxDecoration(
            border: Border.all(
                color: CustomTheme.of(context).hintColor.withOpacity(0.5),
                width: 1.0),
            borderRadius: BorderRadius.circular(5.0),
            color: Colors.transparent,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                  child: Container(
                height: 40.0,
                child: TextField(
                  controller: amountController,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  style: CustomWidget(context: context).CustomSizedTextStyle(
                      13.0,
                      Theme.of(context).splashColor,
                      FontWeight.w500,
                      'FontRegular'),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                  ],
                  onChanged: (value) {
                    setState(() {
                      price = "0.0";
                      // price = value.toString();
                      totalAmount = "0.00";

                      if (enableTrade) {
                        if (amountController.text.isNotEmpty) {
                          totalAmount =
                              (double.parse(amountController.text.toString()) *
                                      double.parse(livePrice))
                                  .toStringAsFixed(4);
                        }
                      } else {
                        if (amountController.text.isNotEmpty) {
                          double amount = double.parse(amountController.text);
                          if (amount >= 0) {
                            tradeAmount = amountController.text;
                            if (enableStopLimit) {
                              if (stopPriceController.text.isNotEmpty &&
                                  priceController.text.isNotEmpty) {
                                if ((double.parse(
                                        priceController.text.toString()) >
                                    double.parse(
                                        stopPriceController.text.toString()))) {
                                  takerFee =
                                      ((double.parse(priceController.text
                                                      .toString()) *
                                                  double.parse(amountController
                                                      .text
                                                      .toString()) *
                                                  double.parse(takerFeeValue
                                                      .toString())) /
                                              100)
                                          .toStringAsFixed(4);

                                  totalAmount = (double.parse(amountController
                                              .text
                                              .toString()) *
                                          double.parse(
                                              priceController.text.toString()))
                                      .toStringAsFixed(4);
                                  /*  totalAmount = ((double.parse(
                                    priceController.text
                                        .toString()) *
                                    double.parse(amountController
                                        .text
                                        .toString())) -
                                    double.parse(takerFee))
                                    .toStringAsFixed(4);*/
                                } else {
                                  takerFee = ((double.parse(stopPriceController
                                                  .text
                                                  .toString()) *
                                              double.parse(amountController.text
                                                  .toString()) *
                                              double.parse(
                                                  takerFeeValue.toString())) /
                                          100)
                                      .toStringAsFixed(4);

                                  totalAmount = (double.parse(amountController
                                              .text
                                              .toString()) *
                                          double.parse(livePrice))
                                      .toStringAsFixed(4);

                                  /*totalAmount = ((double.parse(
                                    stopPriceController.text
                                        .toString()) *
                                    double.parse(amountController
                                        .text
                                        .toString())) -
                                    double.parse(takerFee))
                                    .toStringAsFixed(4);*/
                                }
                              }
                            } else {
                              if (priceController.text.isNotEmpty) {
                                if (!buySell) {
                                  takerFee = ((amount *
                                              double.parse(priceController.text
                                                  .toString()) *
                                              double.parse(
                                                  takerFeeValue.toString())) /
                                          100)
                                      .toStringAsFixed(4);

                                  totalAmount = (double.parse(amountController
                                              .text
                                              .toString()) *
                                          double.parse(
                                              priceController.text.toString()))
                                      .toStringAsFixed(4);
                                } else {
                                  totalAmount = (double.parse(amountController
                                              .text
                                              .toString()) *
                                          double.parse(
                                              priceController.text.toString()))
                                      .toStringAsFixed(4);
                                }
                              }
                            }
                          }
                        } else {
                          tradeAmount = amountController.text;
                          totalAmount = "0.000";
                        }
                      }
                    });
                  },
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.only(bottom: 8.0),
                      hintText: "Quantity",
                      hintStyle: CustomWidget(context: context)
                          .CustomSizedTextStyle(
                              12.0,
                              Theme.of(context).splashColor.withOpacity(0.5),
                              FontWeight.w500,
                              'FontRegular'),
                      border: InputBorder.none),
                  textAlign: TextAlign.start,
                ),
              )),
              InkWell(
                onTap: () {
                  setState(() {
                    tradeAmount = "0.0";
                    totalAmount = "0.0";
                    if (enableTrade) {
                      if (amountController.text.isNotEmpty) {
                        double amount = double.parse(amountController.text);
                        if (amount > 0) {
                          amount = amount - 0.01;
                          amountController.text = amount.toStringAsFixed(2);
                          tradeAmount = amountController.text;
                          totalAmount =
                              (double.parse(amountController.text.toString()) *
                                      double.parse(livePrice))
                                  .toStringAsFixed(4);
                        }
                      } else {
                        amountController.text = "0.01";
                        tradeAmount = amountController.text;
                        totalAmount = "0.000";
                      }
                    } else {
                      if (amountController.text.isNotEmpty) {
                        double amount = double.parse(amountController.text);
                        if (amount > 0) {
                          amount = amount - 0.01;
                          amountController.text = amount.toStringAsFixed(2);
                          tradeAmount = amountController.text;
                          if (enableStopLimit) {
                            if (stopPriceController.text.isNotEmpty &&
                                priceController.text.isNotEmpty) {
                              if ((double.parse(
                                      priceController.text.toString()) >
                                  double.parse(
                                      stopPriceController.text.toString()))) {
                                takerFee =
                                    ((double.parse(priceController.text
                                                    .toString()) *
                                                double.parse(amountController
                                                    .text
                                                    .toString()) *
                                                double.parse(
                                                    takerFeeValue.toString())) /
                                            100)
                                        .toStringAsFixed(4);

                                totalAmount = (double.parse(
                                            amountController.text.toString()) *
                                        double.parse(
                                            priceController.text.toString()))
                                    .toStringAsFixed(4);
                                /*  totalAmount = ((double.parse(
                                    priceController.text
                                        .toString()) *
                                    double.parse(amountController
                                        .text
                                        .toString())) -
                                    double.parse(takerFee))
                                    .toStringAsFixed(4);*/
                              } else {
                                takerFee = ((double.parse(stopPriceController
                                                .text
                                                .toString()) *
                                            double.parse(amountController.text
                                                .toString()) *
                                            double.parse(
                                                takerFeeValue.toString())) /
                                        100)
                                    .toStringAsFixed(4);

                                totalAmount = (double.parse(
                                            amountController.text.toString()) *
                                        double.parse(livePrice))
                                    .toStringAsFixed(4);

                                /*totalAmount = ((double.parse(
                                    stopPriceController.text
                                        .toString()) *
                                    double.parse(amountController
                                        .text
                                        .toString())) -
                                    double.parse(takerFee))
                                    .toStringAsFixed(4);*/
                              }
                            }
                          } else {
                            if (priceController.text.isNotEmpty) {
                              if (!buySell) {
                                takerFee = ((amount *
                                            double.parse(priceController.text
                                                .toString()) *
                                            double.parse(
                                                takerFeeValue.toString())) /
                                        100)
                                    .toStringAsFixed(4);

                                totalAmount = (double.parse(
                                            amountController.text.toString()) *
                                        double.parse(
                                            priceController.text.toString()))
                                    .toStringAsFixed(4);
                              } else {
                                totalAmount = (double.parse(
                                            amountController.text.toString()) *
                                        double.parse(
                                            priceController.text.toString()))
                                    .toStringAsFixed(4);
                              }
                            }
                          }
                        }
                      } else {
                        amountController.text = "0.01";
                        tradeAmount = amountController.text;
                        totalAmount = "0.000";
                      }
                    }
                  });
                },
                child: Container(
                    height: 40.0,
                    width: 35.0,
                    padding: const EdgeInsets.only(
                      left: 10.0,
                      right: 10.0,
                    ),
                    decoration: BoxDecoration(
                      color: CustomTheme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(2),
                    ),
                    child: Center(
                      child: Text(
                        "-",
                        style: CustomWidget(context: context)
                            .CustomSizedTextStyle(
                                20.0,
                                Theme.of(context).splashColor,
                                FontWeight.w500,
                                'FontRegular'),
                      ),
                    )),
              ),
              const SizedBox(
                width: 2.0,
              ),
              InkWell(
                onTap: () {
                  setState(() {
                    totalAmount = "0.000";
                    if (enableTrade) {
                      if (amountController.text.isNotEmpty) {
                        double amount = double.parse(amountController.text);
                        if (amount > 0) {
                          amount = amount + 0.01;
                          amountController.text = amount.toStringAsFixed(2);
                          tradeAmount = amountController.text;
                          totalAmount =
                              (double.parse(amountController.text.toString()) *
                                      double.parse(livePrice))
                                  .toStringAsFixed(4);
                        }
                      } else {
                        amountController.text = "0.01";
                        tradeAmount = amountController.text;
                        totalAmount = "0.000";
                      }
                    } else {
                      if (amountController.text.isNotEmpty) {
                        double amount = double.parse(amountController.text);
                        if (amount >= 0) {
                          amount = amount + 0.01;
                          amountController.text = amount.toStringAsFixed(2);
                          tradeAmount = amountController.text;
                          if (enableStopLimit) {
                            if (stopPriceController.text.isNotEmpty &&
                                priceController.text.isNotEmpty) {
                              if ((double.parse(
                                      priceController.text.toString()) >
                                  double.parse(
                                      stopPriceController.text.toString()))) {
                                takerFee =
                                    ((double.parse(priceController.text
                                                    .toString()) *
                                                double.parse(amountController
                                                    .text
                                                    .toString()) *
                                                double.parse(
                                                    takerFeeValue.toString())) /
                                            100)
                                        .toStringAsFixed(4);

                                totalAmount = (double.parse(
                                            amountController.text.toString()) *
                                        double.parse(
                                            priceController.text.toString()))
                                    .toStringAsFixed(4);
                                /*  totalAmount = ((double.parse(
                                    priceController.text
                                        .toString()) *
                                    double.parse(amountController
                                        .text
                                        .toString())) -
                                    double.parse(takerFee))
                                    .toStringAsFixed(4);*/
                              } else {
                                takerFee = ((double.parse(stopPriceController
                                                .text
                                                .toString()) *
                                            double.parse(amountController.text
                                                .toString()) *
                                            double.parse(
                                                takerFeeValue.toString())) /
                                        100)
                                    .toStringAsFixed(4);

                                totalAmount = (double.parse(
                                            amountController.text.toString()) *
                                        double.parse(livePrice))
                                    .toStringAsFixed(4);

                                /*totalAmount = ((double.parse(
                                    stopPriceController.text
                                        .toString()) *
                                    double.parse(amountController
                                        .text
                                        .toString())) -
                                    double.parse(takerFee))
                                    .toStringAsFixed(4);*/
                              }
                            }
                          } else {
                            if (priceController.text.isNotEmpty) {
                              if (!buySell) {
                                takerFee = ((amount *
                                            double.parse(priceController.text
                                                .toString()) *
                                            double.parse(
                                                takerFeeValue.toString())) /
                                        100)
                                    .toStringAsFixed(4);

                                totalAmount = (double.parse(
                                            amountController.text.toString()) *
                                        double.parse(
                                            priceController.text.toString()))
                                    .toStringAsFixed(4);
                              } else {
                                totalAmount = (double.parse(
                                            amountController.text.toString()) *
                                        double.parse(
                                            priceController.text.toString()))
                                    .toStringAsFixed(4);
                              }
                            }
                          }
                        }
                      } else {
                        amountController.text = "0.01";
                        tradeAmount = amountController.text;
                        totalAmount = "0.000";
                      }
                    }
                  });
                },
                child: Container(
                    height: 40.0,
                    width: 35.0,
                    padding: const EdgeInsets.only(
                      left: 10.0,
                      right: 10.0,
                    ),
                    decoration: BoxDecoration(
                      color: CustomTheme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(2),
                    ),
                    child: Center(
                      child: Text(
                        "+",
                        style: CustomWidget(context: context)
                            .CustomSizedTextStyle(
                                20.0,
                                Theme.of(context).splashColor,
                                FontWeight.w500,
                                'FontRegular'),
                      ),
                    )),
              ),
            ],
          ),
        ),
        enableStopLimit
            ? SizedBox(
                height: 15.0,
              )
            : Container(),
        enableStopLimit
            ? Container(
                padding: EdgeInsets.fromLTRB(5.0, 0.0, 0.0, 0.0),
                decoration: BoxDecoration(
                  border: Border.all(
                      color: enableTrade
                          ? Theme.of(context).hintColor.withOpacity(0.1)
                          : CustomTheme.of(context).hintColor.withOpacity(0.5),
                      width: 1.0),
                  borderRadius: BorderRadius.circular(5.0),
                  color: Colors.transparent,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                        child: Container(
                      height: 40.0,
                      child: TextField(
                        enabled: !enableTrade,
                        controller: stopPriceController,
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true),
                        style: CustomWidget(context: context)
                            .CustomSizedTextStyle(
                                13.0,
                                Theme.of(context).splashColor,
                                FontWeight.w500,
                                'FontRegular'),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                        ],
                        onChanged: (value) {
                          setState(() {
                            stopPrice = "0.0";
                            // price = value.toString();
                            tradeAmount = "0.00";

                            if (stopPriceController.text.isNotEmpty) {
                              stopPrice = stopPriceController.text;
                              tradeAmount = stopPriceController.text.toString();
                              if (amountController.text.isNotEmpty &&
                                  priceController.text.isNotEmpty) {
                                if (!buySell) {
                                  if ((double.parse(
                                          priceController.text.toString()) >
                                      double.parse(stopPriceController.text
                                          .toString()))) {
                                    takerFee =
                                        ((double.parse(priceController.text
                                                        .toString()) *
                                                    double.parse(
                                                        amountController.text
                                                            .toString()) *
                                                    double.parse(takerFeeValue
                                                        .toString())) /
                                                100)
                                            .toStringAsFixed(4);

                                    totalAmount = (double.parse(priceController
                                                .text
                                                .toString()) *
                                            double.parse(amountController.text
                                                .toString()))
                                        .toStringAsFixed(4);
                                  } else {
                                    takerFee = ((double.parse(
                                                    stopPriceController.text
                                                        .toString()) *
                                                double.parse(amountController
                                                    .text
                                                    .toString()) *
                                                double.parse(
                                                    takerFeeValue.toString())) /
                                            100)
                                        .toStringAsFixed(4);

                                    totalAmount = (double.parse(
                                                stopPriceController.text
                                                    .toString()) *
                                            double.parse(amountController.text
                                                .toString()))
                                        .toStringAsFixed(4);
                                  }
                                } else {
                                  if ((double.parse(
                                          priceController.text.toString()) >
                                      double.parse(stopPriceController.text
                                          .toString()))) {
                                    takerFee =
                                        ((double.parse(priceController.text
                                                        .toString()) *
                                                    double.parse(
                                                        amountController.text
                                                            .toString()) *
                                                    double.parse(takerFeeValue
                                                        .toString())) /
                                                100)
                                            .toStringAsFixed(4);

                                    totalAmount = (double.parse(priceController
                                                .text
                                                .toString()) *
                                            double.parse(amountController.text
                                                .toString()))
                                        .toStringAsFixed(4);
                                    ;
                                  } else {
                                    takerFee = ((double.parse(amountController
                                                    .text
                                                    .toString()) *
                                                double.parse(stopPriceController
                                                    .text
                                                    .toString()) *
                                                double.parse(
                                                    takerFeeValue.toString())) /
                                            100)
                                        .toStringAsFixed(4);

                                    totalAmount = (double.parse(
                                                stopPriceController.text
                                                    .toString()) *
                                            double.parse(amountController.text
                                                .toString()))
                                        .toStringAsFixed(4);
                                  }
                                }
                              }
                            } else {
                              tradeAmount = "0.00";
                              totalAmount = "0.00";
                            }
                          });
                        },
                        decoration: InputDecoration(
                            contentPadding: EdgeInsets.only(bottom: 8.0),
                            hintText: "Stop-Price",
                            hintStyle: CustomWidget(context: context)
                                .CustomSizedTextStyle(
                                    12.0,
                                    Theme.of(context)
                                        .splashColor
                                        .withOpacity(0.5),
                                    FontWeight.w500,
                                    'FontRegular'),
                            border: InputBorder.none),
                        textAlign: TextAlign.start,
                      ),
                    )),
                    InkWell(
                      onTap: () {
                        if (enableTrade) {
                        } else {
                          setState(() {
                            tradeAmount = "0.00";
                            if (stopPriceController.text.isNotEmpty) {
                              double amount =
                                  double.parse(stopPriceController.text);

                              if (amount > 0) {
                                amount = amount - 0.01;
                                stopPriceController.text =
                                    amount.toStringAsFixed(2);
                                stopPrice = stopPriceController.text;

                                if (amountController.text.isNotEmpty) {
                                  tradeAmount =
                                      amountController.text.toString();
                                  takerFee = ((amount *
                                              double.parse(amountController.text
                                                  .toString()) *
                                              double.parse(
                                                  takerFeeValue.toString())) /
                                          100)
                                      .toStringAsFixed(4);

                                  totalAmount = (double.parse(
                                              stopPriceController.text
                                                  .toString()) *
                                          double.parse(
                                              amountController.text.toString()))
                                      .toStringAsFixed(4);
                                } else {
                                  totalAmount = "0.00";
                                }
                              } else {
                                stopPriceController.text = tradeAmount;
                                totalAmount = "0.00";
                              }
                            }else{
                              stopPriceController.text="0.01";
                            }
                          });
                        }
                      },
                      child: Container(
                          height: 40.0,
                          width: 35.0,
                          padding: const EdgeInsets.only(
                            left: 10.0,
                            right: 10.0,
                          ),
                          decoration: BoxDecoration(
                            color: enableTrade
                                ? Theme.of(context).cardColor.withOpacity(0.2)
                                : CustomTheme.of(context).cardColor,
                            borderRadius: BorderRadius.circular(2),
                          ),
                          child: Center(
                            child: Text(
                              "-",
                              style: CustomWidget(context: context)
                                  .CustomSizedTextStyle(
                                      20.0,
                                      enableTrade
                                          ? Theme.of(context)
                                              .cardColor
                                              .withOpacity(0.5)
                                          : Theme.of(context).splashColor,
                                      FontWeight.w500,
                                      'FontRegular'),
                            ),
                          )),
                    ),
                    const SizedBox(
                      width: 2.0,
                    ),
                    InkWell(
                      onTap: () {
                        if (enableTrade) {
                        } else {
                          setState(() {
                            if (stopPriceController.text.isNotEmpty) {
                              double amount =
                                  double.parse(stopPriceController.text);
                              if (amount >= 0) {
                                amount = amount + 0.01;
                                stopPriceController.text =
                                    amount.toStringAsFixed(2);
                                stopPrice = stopPriceController.text;
                                if (amountController.text.isNotEmpty) {
                                  takerFee = ((double.parse(amountController
                                                  .text
                                                  .toString()) *
                                              double.parse(stopPriceController
                                                  .text
                                                  .toString()) *
                                              double.parse(
                                                  takerFeeValue.toString())) /
                                          100)
                                      .toStringAsFixed(4);

                                  totalAmount = (double.parse(
                                              stopPriceController.text
                                                  .toString()) *
                                          double.parse(
                                              amountController.text.toString()))
                                      .toStringAsFixed(4);
                                } else {
                                  // priceController.text = "0.01";
                                  tradeAmount = "0.00";
                                }
                              }
                            } else {
                              stopPriceController.text = "0.01";
                              tradeAmount = "0.00";
                            }
                          });
                        }
                      },
                      child: Container(
                          height: 40.0,
                          width: 35.0,
                          padding: const EdgeInsets.only(
                            left: 10.0,
                            right: 10.0,
                          ),
                          decoration: BoxDecoration(
                            color: enableTrade
                                ? Theme.of(context).cardColor.withOpacity(0.2)
                                : CustomTheme.of(context).cardColor,
                            borderRadius: BorderRadius.circular(2),
                          ),
                          child: Center(
                            child: Text(
                              "+",
                              style: CustomWidget(context: context)
                                  .CustomSizedTextStyle(
                                      20.0,
                                      enableTrade
                                          ? Theme.of(context)
                                              .cardColor
                                              .withOpacity(0.2)
                                          : Theme.of(context).splashColor,
                                      FontWeight.w500,
                                      'FontRegular'),
                            ),
                          )),
                    ),
                  ],
                ),
              )
            : SizedBox(),
        Container(
          child: SliderTheme(
            data: SliderThemeData(
              valueIndicatorColor: CustomTheme.of(context).indicatorColor,
              trackHeight: 10.0,
              activeTickMarkColor: CustomTheme.of(context).splashColor,
              inactiveTickMarkColor:
                  CustomTheme.of(context).splashColor.withOpacity(0.5),
              tickMarkShape: RoundSliderTickMarkShape(tickMarkRadius: 5.0),
              trackShape: CustomTrackShape(),
              thumbShape: RoundSliderThumbShape(enabledThumbRadius: 5),
              overlayShape: RoundSliderOverlayShape(overlayRadius: 28.0),
            ),
            child: spotOption?Slider(
              value: _currentSliderValue,
              max: 100,
              divisions: 4,
              label:_currentSliderValue.round().toString(),
              inactiveColor:
                  CustomTheme.of(context).splashColor.withOpacity(0.5),
              activeColor: buySell
                  ? CustomTheme.of(context).indicatorColor
                  : CustomTheme.of(context).scaffoldBackgroundColor,
              onChanged: (double value) {
                setState(() {
                  _currentSliderValue = value;
                  if (_currentSliderValue > 0) {
                    _tLevSliderValue = _currentSliderValue.toInt();
                    // print(_currentSliderValue.round().toString());
                    int val = _currentSliderValue.toInt();
                    setState(() {
                      if(spotOption){
                        priceController.clear();
                        amountController.clear();
                      }
                      if (spotOption) {
                        if (!enableTrade) {
                          priceController.text = livePrice;
                        }
                        if (double.parse(livePrice) > 0) {
                          if (buySell) {
                            double perce = ((double.parse(balance) * val) /
                                    double.parse(livePrice)) /
                                100;

                            amountController.text =
                                double.parse(perce.toString())
                                    .toStringAsFixed(4);
                            double a = double.parse(perce
                                .toString()); // this is the value in my first text field (This is the percentage rate i intend to use)
                            double b = double.parse(livePrice);
                            totalAmount = double.parse((a * b).toString())
                                .toStringAsFixed(4);
                          } else {
                            double perce = (double.parse(balance) * val) / 100;

                            amountController.text =
                                double.parse(perce.toString())
                                    .toStringAsFixed(4);
                            double a = double.parse(perce
                                .toString()); // this is the value in my first text field (This is the percentage rate i intend to use)
                            double b = double.parse(livePrice);
                            totalAmount = double.parse((a * b).toString())
                                .toStringAsFixed(4);
                          }
                        }
                      }
                    });
                  } else {
                    if(spotOption){
                      amountController.text = "0.00";
                      if (!enableTrade) {
                        priceController.text = "0.00";
                      }
                      totalAmount = "0.00";
                    }
                    tleverageVal = "0";
                  }
                });
              },
            )
                :Slider(
              value: _currentSliderValue,
              max: 100,
              divisions: 4,
              label: tleverageVal,
              inactiveColor:
                  CustomTheme.of(context).splashColor.withOpacity(0.5),
              activeColor: buySell
                  ? CustomTheme.of(context).indicatorColor
                  : CustomTheme.of(context).scaffoldBackgroundColor,
              onChanged: (double value) {
                setState(() {
                  _currentSliderValue = value;
                  if (_currentSliderValue > 0) {
                    _tLevSliderValue = _currentSliderValue.toInt();
                    // print(_currentSliderValue.round().toString());
                    setState(() {
                      if (_currentSliderValue.round().toString() == "25") {
                        tleverageVal = "1";
                      } else if (_currentSliderValue.round().toString() == "50") {
                        tleverageVal = "10";
                      } else if (_currentSliderValue.round().toString() == "75") {
                        tleverageVal = "50";
                      } else if (_currentSliderValue.round().toString() == "100"){
                        tleverageVal = "75";
                      }
                    });
                    int val = _currentSliderValue.toInt();
                    setState(() {
                      if(spotOption){
                        priceController.clear();
                        amountController.clear();
                      }
                      if (spotOption) {
                        if (!enableTrade) {
                          priceController.text = livePrice;
                        }
                        if (double.parse(livePrice) > 0) {
                          if (buySell) {
                            double perce = ((double.parse(balance) * val) /
                                    double.parse(livePrice)) /
                                100;

                            amountController.text =
                                double.parse(perce.toString())
                                    .toStringAsFixed(4);
                            double a = double.parse(perce
                                .toString()); // this is the value in my first text field (This is the percentage rate i intend to use)
                            double b = double.parse(livePrice);
                            totalAmount = double.parse((a * b).toString())
                                .toStringAsFixed(4);
                          } else {
                            double perce = (double.parse(balance) * val) / 100;

                            amountController.text =
                                double.parse(perce.toString())
                                    .toStringAsFixed(4);
                            double a = double.parse(perce
                                .toString()); // this is the value in my first text field (This is the percentage rate i intend to use)
                            double b = double.parse(livePrice);
                            totalAmount = double.parse((a * b).toString())
                                .toStringAsFixed(4);
                          }
                        }
                      }
                    });
                  } else {
                    if(spotOption){
                      amountController.text = "0.00";
                      if (!enableTrade) {
                        priceController.text = "0.00";
                      }
                      totalAmount = "0.00";
                    }
                    tleverageVal = "0";
                  }
                });
              },
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.fromLTRB(5.0, 0.0, 0.0, 0.0),
          decoration: BoxDecoration(
            border: Border.all(
                color: CustomTheme.of(context).hintColor.withOpacity(0.5),
                width: 1.0),
            borderRadius: BorderRadius.circular(5.0),
            color: Colors.transparent,
          ),
          child: Center(
            child: Padding(
              padding: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 10.0),
              child: Text(
                totalAmount +
                    " " +
                    (futureOption
                        ? coinTwoName
                        : (buySell ? coinTwoName : coinName)),
                style: CustomWidget(context: context).CustomSizedTextStyle(
                    13.0,
                    Theme.of(context).splashColor,
                    FontWeight.w500,
                    'FontRegular'),
              ),
            ),
          ),
        ),
        SizedBox(
          height: 15.0,
        ),
        InkWell(
          onTap: () {
            setState(() {
              if(tradeOrder){
                tradeOrder=false;
              if (enableTrade) {
                if (amountController.text.isNotEmpty) {
                  if (double.parse(balance) >= double.parse(totalAmount)) {
                    loading = true;
                    if (buySell) {
                        if (marginVisibleOption) {
                          placeMarginOrder(
                              false, false, "buy-market", "1", tleverageVal);
                        } else if (futureOption) {
                          placeMarginOrder(
                              false, false, "buy-market", "2", tleverageVal);
                        } else {
                          placeMarginOrder(true, false, "buy-market", "0", "");
                        }
                      } else {
                        if (marginVisibleOption) {
                          placeMarginOrder(
                              false, false, "sell-market", "1", tleverageVal);
                        } else if (futureOption) {
                          placeMarginOrder(
                              false, false, "sell-market", "2", tleverageVal);
                        } else {
                          placeMarginOrder(true, false, "sell-market", "0", "");
                        }
                      }
                  } else {
                    CustomWidget(context: context)
                        .custombar("Trade", "Insufficient Balance", false);
                  }
                } else {
                  CustomWidget(context: context)
                      .custombar("Trade", "Enter Trade Quantity", false);
                }
              } else {
                if (priceController.text.isNotEmpty) {
                  if (amountController.text.isNotEmpty) {
                    if (double.parse(balance) >= double.parse(totalAmount)) {
                      if (buySell) {
                        if (marginVisibleOption) {
                          enableStopLimit ? "" : loading = true;
                          placeMarginOrder(
                              false, true, "buy", "1", tleverageVal);
                          if (enableStopLimit) {
                            if (stopPriceController.text.isNotEmpty) {
                              loading = true;
                              stopLimit(
                                  false, "buy-stop-limit", "1", tleverageVal);
                            } else {
                              CustomWidget(context: context).custombar(
                                  "Trade", "Enter the stop limit-price", false);
                            }
                          }
                        } else if (enableStopLimit) {
                          if (stopPriceController.text.isNotEmpty) {
                            loading = true;
                            stopLimit(true, "buy-stop-limit", "0", "");
                          } else {
                            CustomWidget(context: context).custombar(
                                "Trade", "Enter the stop limit-price", false);
                          }
                        } else if (futureOption) {
                          placeMarginOrder(
                              false, true, "buy", "2", tleverageVal);
                        } else {
                          placeMarginOrder(true, true, "buy", "0", "");
                        }
                      } else {
                        if (marginVisibleOption) {
                          placeMarginOrder(
                              false, true, "sell", "1", tleverageVal);
                          if (enableStopLimit) {
                            if (stopPriceController.text.isNotEmpty) {
                              loading = true;
                              stopLimit(
                                  false, "sell-stop-limit", "1", tleverageVal);
                            } else {
                              CustomWidget(context: context).custombar(
                                  "Trade", "Enter the stop limit-price", false);
                            }
                          }
                        } else if (enableStopLimit) {
                          if (stopPriceController.text.isNotEmpty) {
                            loading = true;
                            stopLimit(true, "sell-stop-limit", "0", "");
                          } else {
                            CustomWidget(context: context).custombar(
                                "Trade", "Enter the stop limit-price", false);
                          }
                        } else if (futureOption) {
                          placeMarginOrder(
                              false, true, "sell", "2", tleverageVal);
                        } else {
                          placeMarginOrder(true, true, "sell", "0", "");
                        }
                      }
                    } else {
                      CustomWidget(context: context)
                          .custombar("Trade", "Insufficient Balance", false);
                    }
                  } else {
                    CustomWidget(context: context)
                        .custombar("Trade", "Enter Trade Quantity", false);
                  }
                } else {
                  CustomWidget(context: context)
                      .custombar("Trade", "Enter Trade Price", false);
                }
              }
              }
            });
          },
          child: Container(
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5.0),
                color: buySell
                    ? CustomTheme.of(context).indicatorColor
                    : CustomTheme.of(context).scaffoldBackgroundColor,
              ),
              child: Center(
                child: Text(
                  buySell
                      ? AppLocalizations.instance.text("loc_sell_trade_txt5")
                      : AppLocalizations.instance.text("loc_sell_trade_txt6"),
                  style: CustomWidget(context: context).CustomSizedTextStyle(
                      14.0,
                      Theme.of(context).splashColor,
                      FontWeight.w500,
                      'FontRegular'),
                ),
              )),
        ),
        SizedBox(
          height: 5.0,
        ),
      ],
    );
  }

  showLoanDialog() {
    showModalBottomSheet(
        // expand: true,
        context: context,
        isScrollControlled: true,
        backgroundColor: CustomTheme.of(context).indicatorColor,
        builder: (context) {
          return SingleChildScrollView(
            child: AnimatedPadding(
              duration: Duration(milliseconds: 150),
              curve: Curves.easeOut,
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: StatefulBuilder(
                  builder: (BuildContext gcontext, StateSetter ssetState) {
                return Container(
                  width: MediaQuery.of(gcontext).size.width,
                  color: CustomTheme.of(gcontext).backgroundColor,
                  padding: EdgeInsets.all(15.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        SizedBox(
                          height: 15.0,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Action",
                              style: CustomWidget(context: gcontext)
                                  .CustomSizedTextStyle(
                                      18.0,
                                      Theme.of(context).secondaryHeaderColor,
                                      FontWeight.w500,
                                      'FontRegular'),
                            ),
                            Container(
                              child: Align(
                                  child: InkWell(
                                onTap: () {
                                  Navigator.pop(context);
                                  setState(() {
                                    searchController.clear();
                                    coinController.clear();
                                    // searchPair.addAll(tradePair);
                                  });
                                },
                                child: Icon(
                                  Icons.close,
                                  size: 20.0,
                                  color: Theme.of(context).hintColor,
                                ),
                              )),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 15.0,
                        ),
                        Visibility(
                          visible: enableLoan,
                          child: Container(
                            width: MediaQuery.of(gcontext).size.width,
                            height: 40.0,
                            padding: EdgeInsets.fromLTRB(5, 0.0, 5, 0.0),
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: CustomTheme.of(gcontext)
                                      .hintColor
                                      .withOpacity(0.5),
                                  width: 1.0),
                              borderRadius: BorderRadius.circular(5.0),
                              color: Colors.transparent,
                            ),
                            child: Theme(
                              data: Theme.of(context).copyWith(
                                canvasColor:
                                    CustomTheme.of(context).backgroundColor,
                              ),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton(
                                  menuMaxHeight:
                                      MediaQuery.of(context).size.height,
                                  items: marginVisibleOption
                                      ? transferType
                                          .map((value) => DropdownMenuItem(
                                                child: Text(
                                                  value.toString(),
                                                  style: CustomWidget(
                                                          context: context)
                                                      .CustomSizedTextStyle(
                                                          10.0,
                                                          Theme.of(context)
                                                              .errorColor,
                                                          FontWeight.w500,
                                                          'FontRegular'),
                                                ),
                                                value: value,
                                              ))
                                          .toList()
                                      : transferFutureType
                                          .map((value) => DropdownMenuItem(
                                                child: Text(
                                                  value.toString(),
                                                  style: CustomWidget(
                                                          context: context)
                                                      .CustomSizedTextStyle(
                                                          10.0,
                                                          Theme.of(context)
                                                              .errorColor,
                                                          FontWeight.w500,
                                                          'FontRegular'),
                                                ),
                                                value: value,
                                              ))
                                          .toList(),
                                  onChanged: (value) async {
                                    ssetState(() {
                                      selectedMarginTradeType =
                                          value.toString();
                                      /* if (selectedMarginTradeType == "Loan") {
                                            amtController.clear();
                                          } else*/
                                      if (selectedMarginTradeType ==
                                              "Spot-Margin" ||
                                          selectedMarginTradeType ==
                                              "Spot-Future") {
                                        amtController.clear();
                                      } else {
                                        amtController.clear();
                                      }
                                    });
                                  },
                                  hint: Text(
                                    "Trade Mode",
                                    style: CustomWidget(context: context)
                                        .CustomSizedTextStyle(
                                            12.0,
                                            Theme.of(context).errorColor,
                                            FontWeight.w500,
                                            'FontRegular'),
                                  ),
                                  isExpanded: true,
                                  value: selectedMarginTradeType,
                                  icon: const Icon(
                                    Icons.arrow_drop_down,
                                    // color: AppColors.otherTextColor,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        InkWell(
                          onTap: () {
                            showAssetSheet();
                          },
                          child: Container(
                            padding: EdgeInsets.fromLTRB(5.0, 0.0, 0.0, 0.0),
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: enableTrade
                                      ? Theme.of(context)
                                          .hintColor
                                          .withOpacity(0.1)
                                      : CustomTheme.of(context)
                                          .hintColor
                                          .withOpacity(0.5),
                                  width: 1.0),
                              borderRadius: BorderRadius.circular(5.0),
                              color: Colors.transparent,
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Flexible(
                                    child: Container(
                                  height: 40.0,
                                  child: TextField(
                                    enabled: false,
                                    controller: coinController,
                                    keyboardType:
                                        const TextInputType.numberWithOptions(
                                            decimal: true),
                                    style: CustomWidget(context: context)
                                        .CustomSizedTextStyle(
                                            13.0,
                                            Theme.of(context).splashColor,
                                            FontWeight.w500,
                                            'FontRegular'),
                                    onChanged: (value) {
                                      setState(() {
                                        if (value.isEmpty) {
                                          coinController.text = "";
                                        }
                                      });
                                    },
                                    decoration: InputDecoration(
                                        contentPadding:
                                            EdgeInsets.only(bottom: 8.0),
                                        hintText: "Asset",
                                        hintStyle:
                                            CustomWidget(context: gcontext)
                                                .CustomSizedTextStyle(
                                                    12.0,
                                                    Theme.of(gcontext)
                                                        .splashColor
                                                        .withOpacity(0.5),
                                                    FontWeight.w500,
                                                    'FontRegular'),
                                        border: InputBorder.none),
                                    textAlign: TextAlign.start,
                                  ),
                                )),
                                const SizedBox(
                                  width: 2.0,
                                ),
                                InkWell(
                                  onTap: () {
                                    showAssetSheet();
                                  },
                                  child: Container(
                                      height: 40.0,
                                      width: 35.0,
                                      padding: const EdgeInsets.only(
                                        left: 10.0,
                                        right: 10.0,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.transparent,
                                        borderRadius: BorderRadius.circular(2),
                                      ),
                                      child: Center(
                                        child: Icon(
                                          Icons.arrow_drop_down,
                                          color: Theme.of(context)
                                              .splashColor
                                              .withOpacity(0.5),
                                        ),
                                      )),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        Visibility(
                          visible: enableLoan,
                          child: TextFormField(
                            enabled: true,
                            controller: amtController,
                            keyboardType: const TextInputType.numberWithOptions(
                                decimal: true),
                            style: CustomWidget(context: context)
                                .CustomSizedTextStyle(
                                    13.0,
                                    Theme.of(context).splashColor,
                                    FontWeight.w500,
                                    'FontRegular'),
                            onChanged: (value) {
                              ssetState(() {
                                value.isEmpty
                                    ? loanErr = true
                                    : loanErr = false;
                              });
                            },
                            validator: (text) {
                              if (text == null || text.isEmpty) {
                                return 'Amount is empty';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              errorText: loanErr ? 'Amount is empty' : '',
                              errorMaxLines: 1,
                              errorStyle: TextStyle(
                                height: 0,
                                color:
                                    Theme.of(context).scaffoldBackgroundColor,
                              ),
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 8.0, horizontal: 12.0),
                              hintText: "Amount",
                              hintStyle: CustomWidget(context: context)
                                  .CustomSizedTextStyle(
                                      12.0,
                                      Theme.of(context)
                                          .splashColor
                                          .withOpacity(0.5),
                                      FontWeight.w500,
                                      'FontRegular'),
                              border: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: enableTrade
                                        ? Theme.of(context)
                                            .hintColor
                                            .withOpacity(0.1)
                                        : CustomTheme.of(context)
                                            .hintColor
                                            .withOpacity(0.5),
                                    width: 1.0),
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                            ),
                            textAlign: TextAlign.start,
                          ),
                        ),
                        Visibility(
                          visible: leverageLoan,
                          child: Container(
                            child: SliderTheme(
                              data: SliderThemeData(
                                valueIndicatorColor:
                                    CustomTheme.of(context).indicatorColor,
                                trackHeight: 10.0,
                                activeTickMarkColor:
                                    CustomTheme.of(context).splashColor,
                                inactiveTickMarkColor: CustomTheme.of(context)
                                    .splashColor
                                    .withOpacity(0.5),
                                tickMarkShape: RoundSliderTickMarkShape(
                                    tickMarkRadius: 5.0),
                                trackShape: CustomTrackShape(),
                                thumbShape: RoundSliderThumbShape(
                                    enabledThumbRadius: 5),
                                overlayShape: RoundSliderOverlayShape(
                                    overlayRadius: 28.0),
                              ),
                              child: Slider(
                                value: _leverageSliderValue,
                                max: 100,
                                divisions: 4,
                                label: leverageVal.toString() + "x",
                                inactiveColor: CustomTheme.of(context)
                                    .splashColor
                                    .withOpacity(0.5),
                                activeColor: buySell
                                    ? CustomTheme.of(context).indicatorColor
                                    : CustomTheme.of(context)
                                        .scaffoldBackgroundColor,
                                onChanged: (double value) {
                                  ssetState(() {
                                    _leverageSliderValue = value;

                                    if (_leverageSliderValue > 0) {
                                      _levSliderValue =
                                          _leverageSliderValue.toInt();
                                      print(_levSliderValue);
                                      setState(() {
                                        if (_levSliderValue == 25) {
                                          leverageVal = "1";
                                        } else if (_levSliderValue == 50) {
                                          leverageVal = "10";
                                        } else if (_levSliderValue == 75) {
                                          leverageVal = "50";
                                        } else {
                                          leverageVal = "100";
                                        }
                                      });
                                    }
                                  });
                                },
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 15.0,
                        ),
                        InkWell(
                          onTap: () {
                            print("Loan" + enableLoan.toString());
                            if (_formKey.currentState!.validate()) {
                              Navigator.pop(context);
                              if (marginVisibleOption) {
                                if (leverageLoan) {
                                  ssetState(() {
                                    loading = true;
                                  });
                                  marginLoan(
                                      selectedAssetIndex, leverageVal, "1");
                                } else {
                                  if (amtController.text.isNotEmpty &&
                                      coinController.text.isNotEmpty) {
                                    if (selectedMarginTradeType ==
                                        "Spot-Margin") {
                                      ssetState(() {
                                        loading = true;
                                      });
                                      transferSpottoMargin(selectedAssetIndex,
                                          amtController.text, "1");
                                    } else {
                                      ssetState(() {
                                        loading = true;
                                      });
                                      transferMargintoSpot(selectedAssetIndex,
                                          amtController.text, "1");
                                    }
                                  }
                                }
                              } else if (futureOption) {
                                if (leverageLoan) {
                                  ssetState(() {
                                    loading = true;
                                  });
                                  marginLoan(
                                      selectedAssetIndex, leverageVal, "2");
                                } else {
                                  if (amtController.text.isNotEmpty &&
                                      coinController.text.isNotEmpty) {
                                    if (selectedMarginTradeType ==
                                        "Spot-Future") {
                                      ssetState(() {
                                        loading = true;
                                      });
                                      transferSpottoMargin(selectedAssetIndex,
                                          amtController.text, "2");
                                    } else {
                                      ssetState(() {
                                        loading = true;
                                      });
                                      transferMargintoSpot(selectedAssetIndex,
                                          amtController.text, "2");
                                    }
                                  }
                                }
                              } else {
                                Navigator.pop(context);
                                // ssetState(() {
                                //   loading = true;
                                // });
                                // repayLoan(selectedAssetIndex);
                              }
                            } else {
                              /*ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                    content: Text('Enter the amount'),
                                    behavior: SnackBarBehavior.floating,
                                  ));*/
                              /* CustomWidget(context: gcontext)
                                      .custombar("Loan", "Enter the amount", false);*/
                            }
                          },
                          child: Container(
                              width: MediaQuery.of(context).size.width,
                              padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5.0),
                                color: CustomTheme.of(context).indicatorColor,
                              ),
                              child: Center(
                                child: Text(
                                  AppLocalizations.instance.text("loc_confirm"),
                                  style: CustomWidget(context: context)
                                      .CustomSizedTextStyle(
                                          14.0,
                                          Theme.of(context).splashColor,
                                          FontWeight.w500,
                                          'FontRegular'),
                                ),
                              )),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          );
        });
  }

  showOrders() {
    showBarModalBottomSheet(
        expand: true,
        context: context,
        backgroundColor: CustomTheme.of(context).backgroundColor,
        builder: (context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter ssetState) {
            return Container(
              color: CustomTheme.of(context).backgroundColor,
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: cancelOrder
                  ? CustomWidget(context: context).loadingIndicator(
                      CustomTheme.of(context).splashColor,
                    )
                  : NestedScrollView(
                      controller: controller,
                      headerSliverBuilder:
                          (BuildContext context, bool innerBoxIsScrolled) {
                        //<-- headerSliverBuilder
                        return <Widget>[
                          SliverAppBar(
                            backgroundColor:
                                CustomTheme.of(context).backgroundColor,
                            pinned: true,
                            //<-- pinned to true
                            floating: true,
                            //<-- floating to true
                            expandedHeight: 40.0,
                            forceElevated: innerBoxIsScrolled,
                            //<-- forceElevated to innerBoxIsScrolled
                            bottom: TabBar(
                              isScrollable: false,
                              labelColor: CustomTheme.of(context).splashColor,
                              //<-- selected text color
                              unselectedLabelColor: CustomTheme.of(context)
                                  .splashColor
                                  .withOpacity(0.5),
                              // isScrollable: true,
                              indicatorPadding:
                                  EdgeInsets.only(left: 10.0, right: 10.0),
                              indicatorColor: CustomTheme.of(context).cardColor,
                              tabs: <Tab>[
                                Tab(
                                  text: "Open Orders",
                                ),
                                Tab(
                                  text: "Order History",
                                ),
                              ],
                              controller: _tabController,
                            ),
                          ),
                        ];
                      },
                      body: Container(
                        color: CustomTheme.of(context).backgroundColor,
                        height: MediaQuery.of(context).size.height * 0.9,
                        child: TabBarView(
                          children: <Widget>[
                            openOrdersUI(),
                            HistoryOrdersUI(ssetState)
                          ],
                          controller: _tabController,
                        ),
                      ),
                    ),
            );
          });
        });
  }

  showFutureOrders() {
    showBarModalBottomSheet(
        expand: true,
        context: context,
        backgroundColor: CustomTheme.of(context).backgroundColor,
        builder: (context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter ssetState) {
            return Container(
              color: CustomTheme.of(context).backgroundColor,
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: cancelOrder
                  ? CustomWidget(context: context).loadingIndicator(
                      CustomTheme.of(context).splashColor,
                    )
                  : NestedScrollView(
                      controller: controller,
                      headerSliverBuilder:
                          (BuildContext context, bool innerBoxIsScrolled) {
                        //<-- headerSliverBuilder
                        return <Widget>[
                          SliverAppBar(
                            backgroundColor:
                                CustomTheme.of(context).backgroundColor,
                            pinned: true,
                            //<-- pinned to true
                            floating: true,
                            //<-- floating to true
                            expandedHeight: 40.0,
                            forceElevated: innerBoxIsScrolled,
                            //<-- forceElevated to innerBoxIsScrolled
                            bottom: TabBar(
                              isScrollable: false,
                              labelColor: CustomTheme.of(context).splashColor,
                              //<-- selected text color
                              unselectedLabelColor: CustomTheme.of(context)
                                  .splashColor
                                  .withOpacity(0.5),
                              // isScrollable: true,
                              indicatorPadding:
                                  EdgeInsets.only(left: 10.0, right: 10.0),
                              indicatorColor: CustomTheme.of(context).cardColor,
                              tabs: <Tab>[
                                Tab(
                                  text: "Position",
                                ),
                                Tab(
                                  text: "Open Orders",
                                ),
                                Tab(
                                  text: "Order History",
                                ),
                              ],
                              controller: tradeTabController,
                            ),
                          ),
                        ];
                      },
                      body: Container(
                        color: CustomTheme.of(context).backgroundColor,
                        height: MediaQuery.of(context).size.height * 0.9,
                        child: TabBarView(
                          children: <Widget>[
                            positionUI(),
                            futureOpenOrdersUI(),
                            HistoryOrdersUI(ssetState)
                          ],
                          controller: tradeTabController,
                        ),
                      ),
                    ),
            );
          });
        });
  }

  Widget openOrdersUI() {
    return SingleChildScrollView(
      child: Column(
        children: [
          openOrders.length > 0
              ? Container(
                  color: Theme.of(context).backgroundColor,
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.82,
                  child: SingleChildScrollView(
                    controller: controller,
                    child: ListView.builder(
                      itemCount: openOrders.length,
                      shrinkWrap: true,
                      controller: controller,
                      itemBuilder: (BuildContext context, int index) {
                        Moment spiritRoverOnMars =
                            Moment(openOrders[index].createdAt!).toLocal();
                        return Column(
                          children: [
                            Theme(
                              data: Theme.of(context)
                                  .copyWith(dividerColor: Colors.transparent),
                              child: ExpansionTile(
                                key: PageStorageKey(index.toString()),
                                title: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Pair",
                                          style: CustomWidget(context: context)
                                              .CustomSizedTextStyle(
                                                  12.0,
                                                  Theme.of(context)
                                                      .splashColor
                                                      .withOpacity(0.5),
                                                  FontWeight.w400,
                                                  'FontRegular'),
                                        ),
                                        Text(
                                          openOrders[index]
                                              .pair_symbol
                                              .toString(),
                                          style: CustomWidget(context: context)
                                              .CustomSizedTextStyle(
                                                  14.0,
                                                  Theme.of(context).splashColor,
                                                  FontWeight.w400,
                                                  'FontRegular'),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      width: 10.0,
                                    ),
                                    const Icon(
                                      Icons.keyboard_arrow_down_outlined,
                                      color: AppColors.whiteColor,
                                      size: 18.0,
                                    )
                                  ],
                                ),
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 10.0, right: 10.0),
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.only(
                                              left: 5.0, right: 5.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Column(
                                                children: [
                                                  Text(
                                                    "Date",
                                                    style: CustomWidget(
                                                            context: context)
                                                        .CustomSizedTextStyle(
                                                            12.0,
                                                            Theme.of(context)
                                                                .splashColor
                                                                .withOpacity(
                                                                    0.5),
                                                            FontWeight.w400,
                                                            'FontRegular'),
                                                  ),
                                                  Text(
                                                    spiritRoverOnMars
                                                        .format(
                                                            "YYYY MMMM Do - hh:mm:ssa")
                                                        .toString(),
                                                    style: CustomWidget(
                                                            context: context)
                                                        .CustomSizedTextStyle(
                                                            12.0,
                                                            Theme.of(context)
                                                                .splashColor,
                                                            FontWeight.w400,
                                                            'FontRegular'),
                                                  ),
                                                ],
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                              ),
                                              Column(
                                                children: [
                                                  Text(
                                                    "Type",
                                                    style: CustomWidget(
                                                            context: context)
                                                        .CustomSizedTextStyle(
                                                            12.0,
                                                            Theme.of(context)
                                                                .splashColor
                                                                .withOpacity(
                                                                    0.5),
                                                            FontWeight.w400,
                                                            'FontRegular'),
                                                  ),
                                                  Text(
                                                    openOrders[index]
                                                        .tradeType
                                                        .toString(),
                                                    style: CustomWidget(
                                                            context: context)
                                                        .CustomSizedTextStyle(
                                                            14.0,
                                                            openOrders[index]
                                                                        .tradeType
                                                                        .toString()
                                                                        .toLowerCase() ==
                                                                    "buy"
                                                                ? CustomTheme.of(
                                                                        context)
                                                                    .indicatorColor
                                                                : CustomTheme.of(
                                                                        context)
                                                                    .scaffoldBackgroundColor,
                                                            FontWeight.w500,
                                                            'FontRegular'),
                                                  ),
                                                ],
                                              ),
                                              Column(
                                                children: [
                                                  Text(
                                                    "Order Type",
                                                    style: CustomWidget(
                                                            context: context)
                                                        .CustomSizedTextStyle(
                                                            12.0,
                                                            Theme.of(context)
                                                                .splashColor
                                                                .withOpacity(
                                                                    0.5),
                                                            FontWeight.w400,
                                                            'FontRegular'),
                                                  ),
                                                  Text(
                                                    openOrders[index]
                                                        .orderType
                                                        .toString(),
                                                    style: CustomWidget(
                                                            context: context)
                                                        .CustomSizedTextStyle(
                                                            12.0,
                                                            Theme.of(context)
                                                                .splashColor,
                                                            FontWeight.w400,
                                                            'FontRegular'),
                                                  ),
                                                ],
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.end,
                                              )
                                            ],
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 10.0,
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(
                                              left: 5.0, right: 5.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Column(
                                                children: [
                                                  Text(
                                                    "Price",
                                                    style: CustomWidget(
                                                            context: context)
                                                        .CustomSizedTextStyle(
                                                            12.0,
                                                            Theme.of(context)
                                                                .splashColor
                                                                .withOpacity(
                                                                    0.5),
                                                            FontWeight.w400,
                                                            'FontRegular'),
                                                  ),
                                                  Text(
                                                    openOrders[index]
                                                        .price
                                                        .toString(),
                                                    style: CustomWidget(
                                                            context: context)
                                                        .CustomSizedTextStyle(
                                                            12.0,
                                                            Theme.of(context)
                                                                .splashColor,
                                                            FontWeight.w400,
                                                            'FontRegular'),
                                                  ),
                                                ],
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                              ),
                                              Column(
                                                children: [
                                                  Text(
                                                    "Quantity",
                                                    style: CustomWidget(
                                                            context: context)
                                                        .CustomSizedTextStyle(
                                                            12.0,
                                                            Theme.of(context)
                                                                .splashColor
                                                                .withOpacity(
                                                                    0.5),
                                                            FontWeight.w400,
                                                            'FontRegular'),
                                                  ),
                                                  Text(
                                                    openOrders[index]
                                                        .volume
                                                        .toString(),
                                                    style: CustomWidget(
                                                            context: context)
                                                        .CustomSizedTextStyle(
                                                            12.0,
                                                            Theme.of(context)
                                                                .splashColor,
                                                            FontWeight.w400,
                                                            'FontRegular'),
                                                  ),
                                                ],
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.end,
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 10.0,
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(
                                              left: 5.0, right: 5.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Column(
                                                children: [
                                                  Text(
                                                    "Total",
                                                    style: CustomWidget(
                                                            context: context)
                                                        .CustomSizedTextStyle(
                                                            12.0,
                                                            Theme.of(context)
                                                                .splashColor
                                                                .withOpacity(
                                                                    0.5),
                                                            FontWeight.w400,
                                                            'FontRegular'),
                                                  ),
                                                  Text(
                                                    openOrders[index]
                                                        .value
                                                        .toString(),
                                                    style: CustomWidget(
                                                            context: context)
                                                        .CustomSizedTextStyle(
                                                            12.0,
                                                            Theme.of(context)
                                                                .splashColor,
                                                            FontWeight.w400,
                                                            'FontRegular'),
                                                  ),
                                                ],
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                              ),
                                              InkWell(
                                                child: Container(
                                                  width: 80,
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 3.0,
                                                          bottom: 3.0),
                                                  decoration: BoxDecoration(
                                                    color: Colors.red,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                  ),
                                                  child: Align(
                                                    alignment: Alignment.center,
                                                    child: Text(
                                                      "Cancel",
                                                      style: CustomWidget(
                                                              context: context)
                                                          .CustomSizedTextStyle(
                                                              12.0,
                                                              Theme.of(context)
                                                                  .splashColor,
                                                              FontWeight.w400,
                                                              'FontRegular'),
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                  ),
                                                ),
                                                onTap: () {
                                                  setState(() {
                                                    Navigator.pop(context);
                                                    loading = true;
                                                    updatecancelOrder(
                                                      openOrders[index]
                                                          .id
                                                          .toString(),
                                                    );
                                                  });
                                                },
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 10.0,
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                                trailing: Container(
                                  width: 1.0,
                                  height: 10.0,
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 5.0,
                            ),
                            Container(
                              height: 1.0,
                              width: MediaQuery.of(context).size.width,
                              color: Theme.of(context).splashColor,
                            ),
                          ],
                        );
                      },
                    ),
                  ))
              : Container(
                  height: MediaQuery.of(context).size.height * 0.3,
                  color: Theme.of(context).backgroundColor,
                  child: Center(
                    child: Text(
                      "No Records Found..!",
                      style: CustomWidget(context: context)
                          .CustomSizedTextStyle(
                              12.0,
                              Theme.of(context).splashColor,
                              FontWeight.w400,
                              'FontRegular'),
                    ),
                  ),
                ),
          const SizedBox(
            height: 30.0,
          )
        ],
      ),
    );
  }

  Widget futureOpenOrdersUI() {
    return SingleChildScrollView(
      child: Column(
        children: [
          FutureopenOrders.length > 0
              ? Container(
                  color: Theme.of(context).backgroundColor,
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.82,
                  child: SingleChildScrollView(
                    controller: controller,
                    child: ListView.builder(
                      itemCount: FutureopenOrders.length,
                      shrinkWrap: true,
                      controller: controller,
                      itemBuilder: (BuildContext context, int index) {
                        Moment spiritRoverOnMars =
                            Moment(FutureopenOrders[index].createdAt!)
                                .toLocal();
                        return Column(
                          children: [
                            Theme(
                              data: Theme.of(context)
                                  .copyWith(dividerColor: Colors.transparent),
                              child: ExpansionTile(
                                key: PageStorageKey(index.toString()),
                                title: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Pair",
                                          style: CustomWidget(context: context)
                                              .CustomSizedTextStyle(
                                                  12.0,
                                                  Theme.of(context)
                                                      .splashColor
                                                      .withOpacity(0.5),
                                                  FontWeight.w400,
                                                  'FontRegular'),
                                        ),
                                        Text(
                                          FutureopenOrders[index]
                                              .pairSymbol
                                              .toString(),
                                          style: CustomWidget(context: context)
                                              .CustomSizedTextStyle(
                                                  14.0,
                                                  Theme.of(context).splashColor,
                                                  FontWeight.w400,
                                                  'FontRegular'),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      width: 10.0,
                                    ),
                                    const Icon(
                                      Icons.keyboard_arrow_down_outlined,
                                      color: AppColors.whiteColor,
                                      size: 18.0,
                                    )
                                  ],
                                ),
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 10.0, right: 10.0),
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.only(
                                              left: 5.0, right: 5.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Column(
                                                children: [
                                                  Text(
                                                    "Date",
                                                    style: CustomWidget(
                                                            context: context)
                                                        .CustomSizedTextStyle(
                                                            12.0,
                                                            Theme.of(context)
                                                                .splashColor
                                                                .withOpacity(
                                                                    0.5),
                                                            FontWeight.w400,
                                                            'FontRegular'),
                                                  ),
                                                  Text(
                                                    spiritRoverOnMars
                                                        .format(
                                                            "YYYY MMMM Do - hh:mm:ssa")
                                                        .toString(),
                                                    style: CustomWidget(
                                                            context: context)
                                                        .CustomSizedTextStyle(
                                                            12.0,
                                                            Theme.of(context)
                                                                .splashColor,
                                                            FontWeight.w400,
                                                            'FontRegular'),
                                                  ),
                                                ],
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                              ),
                                              Column(
                                                children: [
                                                  Text(
                                                    "Type",
                                                    style: CustomWidget(
                                                            context: context)
                                                        .CustomSizedTextStyle(
                                                            12.0,
                                                            Theme.of(context)
                                                                .splashColor
                                                                .withOpacity(
                                                                    0.5),
                                                            FontWeight.w400,
                                                            'FontRegular'),
                                                  ),
                                                  Text(
                                                    FutureopenOrders[index]
                                                        .tradeType
                                                        .toString(),
                                                    style: CustomWidget(
                                                            context: context)
                                                        .CustomSizedTextStyle(
                                                            14.0,
                                                            FutureopenOrders[
                                                                            index]
                                                                        .tradeType
                                                                        .toString()
                                                                        .toLowerCase() ==
                                                                    "buy"
                                                                ? CustomTheme.of(
                                                                        context)
                                                                    .indicatorColor
                                                                : CustomTheme.of(
                                                                        context)
                                                                    .scaffoldBackgroundColor,
                                                            FontWeight.w500,
                                                            'FontRegular'),
                                                  ),
                                                ],
                                              ),
                                              Column(
                                                children: [
                                                  Text(
                                                    "Order Type",
                                                    style: CustomWidget(
                                                            context: context)
                                                        .CustomSizedTextStyle(
                                                            12.0,
                                                            Theme.of(context)
                                                                .splashColor
                                                                .withOpacity(
                                                                    0.5),
                                                            FontWeight.w400,
                                                            'FontRegular'),
                                                  ),
                                                  Text(
                                                    FutureopenOrders[index]
                                                        .orderType
                                                        .toString(),
                                                    style: CustomWidget(
                                                            context: context)
                                                        .CustomSizedTextStyle(
                                                            12.0,
                                                            Theme.of(context)
                                                                .splashColor,
                                                            FontWeight.w400,
                                                            'FontRegular'),
                                                  ),
                                                ],
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.end,
                                              )
                                            ],
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 10.0,
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(
                                              left: 5.0, right: 5.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Column(
                                                children: [
                                                  Text(
                                                    "Price",
                                                    style: CustomWidget(
                                                            context: context)
                                                        .CustomSizedTextStyle(
                                                            12.0,
                                                            Theme.of(context)
                                                                .splashColor
                                                                .withOpacity(
                                                                    0.5),
                                                            FontWeight.w400,
                                                            'FontRegular'),
                                                  ),
                                                  Text(
                                                    FutureopenOrders[index]
                                                        .price
                                                        .toString(),
                                                    style: CustomWidget(
                                                            context: context)
                                                        .CustomSizedTextStyle(
                                                            12.0,
                                                            Theme.of(context)
                                                                .splashColor,
                                                            FontWeight.w400,
                                                            'FontRegular'),
                                                  ),
                                                ],
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                              ),
                                              Column(
                                                children: [
                                                  Text(
                                                    "Quantity",
                                                    style: CustomWidget(
                                                            context: context)
                                                        .CustomSizedTextStyle(
                                                            12.0,
                                                            Theme.of(context)
                                                                .splashColor
                                                                .withOpacity(
                                                                    0.5),
                                                            FontWeight.w400,
                                                            'FontRegular'),
                                                  ),
                                                  Text(
                                                    FutureopenOrders[index]
                                                        .volume
                                                        .toString(),
                                                    style: CustomWidget(
                                                            context: context)
                                                        .CustomSizedTextStyle(
                                                            12.0,
                                                            Theme.of(context)
                                                                .splashColor,
                                                            FontWeight.w400,
                                                            'FontRegular'),
                                                  ),
                                                ],
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.end,
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 10.0,
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(
                                              left: 5.0, right: 5.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Column(
                                                children: [
                                                  Text(
                                                    "Total",
                                                    style: CustomWidget(
                                                            context: context)
                                                        .CustomSizedTextStyle(
                                                            12.0,
                                                            Theme.of(context)
                                                                .splashColor
                                                                .withOpacity(
                                                                    0.5),
                                                            FontWeight.w400,
                                                            'FontRegular'),
                                                  ),
                                                  Text(
                                                    FutureopenOrders[index]
                                                        .value
                                                        .toString(),
                                                    style: CustomWidget(
                                                            context: context)
                                                        .CustomSizedTextStyle(
                                                            12.0,
                                                            Theme.of(context)
                                                                .splashColor,
                                                            FontWeight.w400,
                                                            'FontRegular'),
                                                  ),
                                                ],
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                              ),
                                              InkWell(
                                                child: Container(
                                                  width: 80,
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 3.0,
                                                          bottom: 3.0),
                                                  decoration: BoxDecoration(
                                                    color: Colors.red,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                  ),
                                                  child: Align(
                                                    alignment: Alignment.center,
                                                    child: Text(
                                                      "Cancel",
                                                      style: CustomWidget(
                                                              context: context)
                                                          .CustomSizedTextStyle(
                                                              12.0,
                                                              Theme.of(context)
                                                                  .splashColor,
                                                              FontWeight.w400,
                                                              'FontRegular'),
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                  ),
                                                ),
                                                onTap: () {
                                                  setState(() {
                                                    Navigator.pop(context);
                                                    loading = true;
                                                    updatecancelOrder(
                                                      FutureopenOrders[index]
                                                          .id
                                                          .toString(),
                                                    );
                                                  });
                                                },
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 10.0,
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                                trailing: Container(
                                  width: 1.0,
                                  height: 10.0,
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 5.0,
                            ),
                            Container(
                              height: 1.0,
                              width: MediaQuery.of(context).size.width,
                              color: Theme.of(context).splashColor,
                            ),
                          ],
                        );
                      },
                    ),
                  ))
              : Container(
                  height: MediaQuery.of(context).size.height * 0.3,
                  color: Theme.of(context).backgroundColor,
                  child: Center(
                    child: Text(
                      "No Records Found..!",
                      style: CustomWidget(context: context)
                          .CustomSizedTextStyle(
                              12.0,
                              Theme.of(context).splashColor,
                              FontWeight.w400,
                              'FontRegular'),
                    ),
                  ),
                ),
          const SizedBox(
            height: 30.0,
          )
        ],
      ),
    );
  }

  Widget positionUI() {
    return SingleChildScrollView(
      child: Column(
        children: [
          Futureposition.length > 0
              ? Container(
                  color: Theme.of(context).backgroundColor,
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.82,
                  child: SingleChildScrollView(
                    controller: controller,
                    child: ListView.builder(
                      itemCount: Futureposition.length,
                      shrinkWrap: true,
                      controller: controller,
                      itemBuilder: (BuildContext context, int index) {
                        Moment spiritRoverOnMars = Moment.parse(
                            Futureposition[index].createdAt!.toString());
                        var pnl;
                        if (Futureposition[index].tradeType.toString() ==
                            "buy") {
                          pnl = (double.parse(
                                      Futureposition[index].price.toString()) -
                                  double.parse(livePrice)) *
                              double.parse(
                                  Futureposition[index].volume.toString());
                        } else {
                          pnl = (double.parse(livePrice) -
                                  double.parse(
                                      Futureposition[index].price.toString())) *
                              double.parse(
                                  Futureposition[index].volume.toString());
                        }
                        return Column(
                          children: [
                            Theme(
                              data: Theme.of(context)
                                  .copyWith(dividerColor: Colors.transparent),
                              child: ExpansionTile(
                                key: PageStorageKey(index.toString()),
                                title: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Pair",
                                          style: CustomWidget(context: context)
                                              .CustomSizedTextStyle(
                                                  12.0,
                                                  Theme.of(context)
                                                      .splashColor
                                                      .withOpacity(0.5),
                                                  FontWeight.w400,
                                                  'FontRegular'),
                                        ),
                                        Text(
                                          Futureposition[index].pair.toString(),
                                          style: CustomWidget(context: context)
                                              .CustomSizedTextStyle(
                                                  14.0,
                                                  Theme.of(context).splashColor,
                                                  FontWeight.w400,
                                                  'FontRegular'),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      width: 10.0,
                                    ),
                                    const Icon(
                                      Icons.keyboard_arrow_down_outlined,
                                      color: AppColors.whiteColor,
                                      size: 18.0,
                                    )
                                  ],
                                ),
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 10.0, right: 10.0),
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.only(
                                              left: 5.0, right: 5.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Column(
                                                children: [
                                                  Text(
                                                    "Date",
                                                    style: CustomWidget(
                                                            context: context)
                                                        .CustomSizedTextStyle(
                                                            12.0,
                                                            Theme.of(context)
                                                                .splashColor
                                                                .withOpacity(
                                                                    0.5),
                                                            FontWeight.w400,
                                                            'FontRegular'),
                                                  ),
                                                  Text(
                                                    spiritRoverOnMars
                                                        .format(
                                                            "YYYY MMMM Do - hh:mm:ssa")
                                                        .toString(),
                                                    style: CustomWidget(
                                                            context: context)
                                                        .CustomSizedTextStyle(
                                                            12.0,
                                                            Theme.of(context)
                                                                .splashColor,
                                                            FontWeight.w400,
                                                            'FontRegular'),
                                                  ),
                                                ],
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                              ),
                                              Column(
                                                children: [
                                                  Text(
                                                    "Order Type",
                                                    style: CustomWidget(
                                                            context: context)
                                                        .CustomSizedTextStyle(
                                                            12.0,
                                                            Theme.of(context)
                                                                .splashColor
                                                                .withOpacity(
                                                                    0.5),
                                                            FontWeight.w400,
                                                            'FontRegular'),
                                                  ),
                                                  Text(
                                                    Futureposition[index]
                                                        .orderType
                                                        .toString(),
                                                    style: CustomWidget(
                                                            context: context)
                                                        .CustomSizedTextStyle(
                                                            12.0,
                                                            Theme.of(context)
                                                                .splashColor,
                                                            FontWeight.w400,
                                                            'FontRegular'),
                                                  ),
                                                ],
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.end,
                                              )
                                            ],
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 10.0,
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(
                                              left: 5.0, right: 5.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Column(
                                                children: [
                                                  Text(
                                                    "Price",
                                                    style: CustomWidget(
                                                            context: context)
                                                        .CustomSizedTextStyle(
                                                            12.0,
                                                            Theme.of(context)
                                                                .splashColor
                                                                .withOpacity(
                                                                    0.5),
                                                            FontWeight.w400,
                                                            'FontRegular'),
                                                  ),
                                                  Text(
                                                    Futureposition[index]
                                                        .price
                                                        .toString(),
                                                    style: CustomWidget(
                                                            context: context)
                                                        .CustomSizedTextStyle(
                                                            12.0,
                                                            Theme.of(context)
                                                                .splashColor,
                                                            FontWeight.w400,
                                                            'FontRegular'),
                                                  ),
                                                ],
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                              ),
                                              Column(
                                                children: [
                                                  Text(
                                                    "Quantity",
                                                    style: CustomWidget(
                                                            context: context)
                                                        .CustomSizedTextStyle(
                                                            12.0,
                                                            Theme.of(context)
                                                                .splashColor
                                                                .withOpacity(
                                                                    0.5),
                                                            FontWeight.w400,
                                                            'FontRegular'),
                                                  ),
                                                  Text(
                                                    Futureposition[index]
                                                        .volume
                                                        .toString(),
                                                    style: CustomWidget(
                                                            context: context)
                                                        .CustomSizedTextStyle(
                                                            12.0,
                                                            Theme.of(context)
                                                                .splashColor,
                                                            FontWeight.w400,
                                                            'FontRegular'),
                                                  ),
                                                ],
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.end,
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 10.0,
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(
                                              left: 5.0, right: 5.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Column(
                                                children: [
                                                  Text(
                                                    "Total",
                                                    style: CustomWidget(
                                                            context: context)
                                                        .CustomSizedTextStyle(
                                                            12.0,
                                                            Theme.of(context)
                                                                .splashColor
                                                                .withOpacity(
                                                                    0.5),
                                                            FontWeight.w400,
                                                            'FontRegular'),
                                                  ),
                                                  Text(
                                                    Futureposition[index]
                                                        .value
                                                        .toString(),
                                                    style: CustomWidget(
                                                            context: context)
                                                        .CustomSizedTextStyle(
                                                            12.0,
                                                            Theme.of(context)
                                                                .splashColor,
                                                            FontWeight.w400,
                                                            'FontRegular'),
                                                  ),
                                                ],
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                              ),
                                              Column(
                                                children: [
                                                  Text(
                                                    "Margin Ratio",
                                                    style: CustomWidget(
                                                            context: context)
                                                        .CustomSizedTextStyle(
                                                            12.0,
                                                            Theme.of(context)
                                                                .splashColor
                                                                .withOpacity(
                                                                    0.5),
                                                            FontWeight.w400,
                                                            'FontRegular'),
                                                  ),
                                                  Text(
                                                    Futureposition[index]
                                                        .margin_ratio
                                                        .toString(),
                                                    style: CustomWidget(
                                                            context: context)
                                                        .CustomSizedTextStyle(
                                                            12.0,
                                                            Theme.of(context)
                                                                .splashColor,
                                                            FontWeight.w400,
                                                            'FontRegular'),
                                                  ),
                                                ],
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.end,
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 10.0,
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(
                                              left: 5.0, right: 5.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Column(
                                                children: [
                                                  Text(
                                                    "Margin",
                                                    style: CustomWidget(
                                                            context: context)
                                                        .CustomSizedTextStyle(
                                                            12.0,
                                                            Theme.of(context)
                                                                .splashColor
                                                                .withOpacity(
                                                                    0.5),
                                                            FontWeight.w400,
                                                            'FontRegular'),
                                                  ),
                                                  Text(
                                                    Futureposition[index]
                                                        .margin_amount
                                                        .toString(),
                                                    style: CustomWidget(
                                                            context: context)
                                                        .CustomSizedTextStyle(
                                                            12.0,
                                                            Theme.of(context)
                                                                .splashColor,
                                                            FontWeight.w400,
                                                            'FontRegular'),
                                                  ),
                                                ],
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                              ),
                                              Column(
                                                children: [
                                                  Text(
                                                    "PNL (ROE%)",
                                                    style: CustomWidget(
                                                            context: context)
                                                        .CustomSizedTextStyle(
                                                            12.0,
                                                            Theme.of(context)
                                                                .splashColor
                                                                .withOpacity(
                                                                    0.5),
                                                            FontWeight.w400,
                                                            'FontRegular'),
                                                  ),
                                                  Text(
                                                    pnl.toString(),
                                                    style: CustomWidget(
                                                            context: context)
                                                        .CustomSizedTextStyle(
                                                            12.0,
                                                            Theme.of(context)
                                                                .splashColor,
                                                            FontWeight.w400,
                                                            'FontRegular'),
                                                  ),
                                                ],
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.end,
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 10.0,
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(
                                              left: 5.0, right: 5.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              InkWell(
                                                child: Container(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.4,
                                                    padding: EdgeInsets.only(
                                                        top: 10.0,
                                                        bottom: 10.0),
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5.0),
                                                      color: Futureposition[
                                                                      index]
                                                                  .tradeType
                                                                  .toString() ==
                                                              "buy"
                                                          ? CustomTheme.of(
                                                                  context)
                                                              .indicatorColor
                                                          : CustomTheme.of(
                                                                  context)
                                                              .scaffoldBackgroundColor,
                                                    ),
                                                    child: Center(
                                                      child: Text(
                                                        Futureposition[index]
                                                                    .tradeType
                                                                    .toString() ==
                                                                "buy"
                                                            ? AppLocalizations
                                                                    .instance
                                                                    .text(
                                                                        "loc_sell_trade_txt5") +
                                                                " Limit"
                                                            : AppLocalizations
                                                                    .instance
                                                                    .text(
                                                                        "loc_sell_trade_txt6") +
                                                                " Limit",
                                                        style: CustomWidget(
                                                                context:
                                                                    context)
                                                            .CustomSizedTextStyle(
                                                                14.0,
                                                                Theme.of(
                                                                        context)
                                                                    .splashColor,
                                                                FontWeight.w500,
                                                                'FontRegular'),
                                                      ),
                                                    )),
                                                onTap: () {
                                                  placeMarginOrder(
                                                      true,
                                                      true,
                                                      Futureposition[index]
                                                          .tradeType
                                                          .toString(),
                                                      "3",
                                                      "");
                                                },
                                              ),
                                              InkWell(
                                                child: Container(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.4,
                                                    padding: EdgeInsets.only(
                                                        top: 10.0,
                                                        bottom: 10.0),
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5.0),
                                                      color: Futureposition[
                                                                      index]
                                                                  .tradeType
                                                                  .toString() ==
                                                              "buy"
                                                          ? CustomTheme.of(
                                                                  context)
                                                              .indicatorColor
                                                          : CustomTheme.of(
                                                                  context)
                                                              .scaffoldBackgroundColor,
                                                    ),
                                                    child: Center(
                                                      child: Text(
                                                        Futureposition[index]
                                                                    .tradeType
                                                                    .toString() ==
                                                                "buy"
                                                            ? AppLocalizations
                                                                    .instance
                                                                    .text(
                                                                        "loc_sell_trade_txt5") +
                                                                " Market"
                                                            : AppLocalizations
                                                                    .instance
                                                                    .text(
                                                                        "loc_sell_trade_txt6") +
                                                                " Market",
                                                        style: CustomWidget(
                                                                context:
                                                                    context)
                                                            .CustomSizedTextStyle(
                                                                14.0,
                                                                Theme.of(
                                                                        context)
                                                                    .splashColor,
                                                                FontWeight.w500,
                                                                'FontRegular'),
                                                      ),
                                                    )),
                                                onTap: () {
                                                  placeMarginOrder(
                                                      true,
                                                      false,
                                                      Futureposition[index]
                                                                  .tradeType
                                                                  .toString() ==
                                                              "buy"
                                                          ? "buy-market"
                                                          : "sell-market",
                                                      "3",
                                                      "");
                                                },
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 10.0,
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                                trailing: Container(
                                  width: 1.0,
                                  height: 10.0,
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 5.0,
                            ),
                            Container(
                              height: 1.0,
                              width: MediaQuery.of(context).size.width,
                              color: Theme.of(context).splashColor,
                            ),
                          ],
                        );
                      },
                    ),
                  ))
              : Container(
                  height: MediaQuery.of(context).size.height * 0.3,
                  color: Theme.of(context).backgroundColor,
                  child: Center(
                    child: Text(
                      "No Records Found..!",
                      style: CustomWidget(context: context)
                          .CustomSizedTextStyle(
                              12.0,
                              Theme.of(context).splashColor,
                              FontWeight.w400,
                              'FontRegular'),
                    ),
                  ),
                ),
          const SizedBox(
            height: 30.0,
          ),
        ],
      ),
    );
  }

  Widget HistoryOrdersUI(StateSetter updateState) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: 40.0,
              padding: EdgeInsets.fromLTRB(5, 0.0, 5, 0.0),
              decoration: BoxDecoration(
                border: Border.all(
                    color: CustomTheme.of(context).hintColor.withOpacity(0.5),
                    width: 1.0),
                borderRadius: BorderRadius.circular(5.0),
                color: Colors.transparent,
              ),
              child: Theme(
                data: Theme.of(context).copyWith(
                  canvasColor: CustomTheme.of(context).backgroundColor,
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton(
                    menuMaxHeight: MediaQuery.of(context).size.height,
                    items: tradeType
                        .map((value) => DropdownMenuItem(
                              child: Text(
                                value.toString(),
                                style: CustomWidget(context: context)
                                    .CustomSizedTextStyle(
                                        10.0,
                                        Theme.of(context).errorColor,
                                        FontWeight.w500,
                                        'FontRegular'),
                              ),
                              value: value,
                            ))
                        .toList(),
                    onChanged: (value) async {
                      updateState(() {
                        selectedHistoryTradeType = value.toString();
                        if (selectedHistoryTradeType == "Spot") {
                          print(selectedHistoryTradeType);
                          getFutureAllHistory("0", updateState);
                        } else if (selectedHistoryTradeType == "Margin") {
                          print(selectedHistoryTradeType);
                          getFutureAllHistory("1", updateState);
                        } else {
                          getFutureAllHistory("2", updateState);
                        }
                      });
                    },
                    hint: Text(
                      "Trade Mode",
                      style: CustomWidget(context: context)
                          .CustomSizedTextStyle(
                              12.0,
                              Theme.of(context).errorColor,
                              FontWeight.w500,
                              'FontRegular'),
                    ),
                    isExpanded: true,
                    value: selectedHistoryTradeType,
                    icon: const Icon(
                      Icons.arrow_drop_down,
                      // color: AppColors.otherTextColor,
                    ),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 10.0,
          ),
          historyOrders.length > 0
              ? Container(
                  color: Theme.of(context).backgroundColor,
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.82,
                  child: SingleChildScrollView(
                    controller: controller,
                    child: ListView.builder(
                      itemCount: historyOrders.length,
                      shrinkWrap: true,
                      controller: controller,
                      itemBuilder: (BuildContext context, int index) {
                        Moment spiritRoverOnMars =
                            Moment(historyOrders[index].createdAt!).toLocal();
                        return Column(
                          children: [
                            Theme(
                              data: Theme.of(context)
                                  .copyWith(dividerColor: Colors.transparent),
                              child: ExpansionTile(
                                key: PageStorageKey(index.toString()),
                                title: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Pair",
                                          style: CustomWidget(context: context)
                                              .CustomSizedTextStyle(
                                                  12.0,
                                                  Theme.of(context)
                                                      .splashColor
                                                      .withOpacity(0.5),
                                                  FontWeight.w400,
                                                  'FontRegular'),
                                        ),
                                        Text(
                                          historyOrders[index]
                                              .pairSymbol
                                              .toString(),
                                          style: CustomWidget(context: context)
                                              .CustomSizedTextStyle(
                                                  14.0,
                                                  Theme.of(context).splashColor,
                                                  FontWeight.w400,
                                                  'FontRegular'),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      width: 10.0,
                                    ),
                                    const Icon(
                                      Icons.keyboard_arrow_down_outlined,
                                      color: AppColors.whiteColor,
                                      size: 18.0,
                                    )
                                  ],
                                ),
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 10.0, right: 10.0),
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.only(
                                              left: 5.0, right: 5.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Column(
                                                children: [
                                                  Text(
                                                    "Date",
                                                    style: CustomWidget(
                                                            context: context)
                                                        .CustomSizedTextStyle(
                                                            12.0,
                                                            Theme.of(context)
                                                                .splashColor
                                                                .withOpacity(
                                                                    0.5),
                                                            FontWeight.w400,
                                                            'FontRegular'),
                                                  ),
                                                  Text(
                                                    spiritRoverOnMars
                                                        .format(
                                                            "YYYY MMMM Do - hh:mm:ssa")
                                                        .toString(),
                                                    style: CustomWidget(
                                                            context: context)
                                                        .CustomSizedTextStyle(
                                                            12.0,
                                                            Theme.of(context)
                                                                .splashColor,
                                                            FontWeight.w400,
                                                            'FontRegular'),
                                                  ),
                                                ],
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                              ),
                                              Column(
                                                children: [
                                                  Text(
                                                    "Type",
                                                    style: CustomWidget(
                                                            context: context)
                                                        .CustomSizedTextStyle(
                                                            12.0,
                                                            Theme.of(context)
                                                                .splashColor
                                                                .withOpacity(
                                                                    0.5),
                                                            FontWeight.w400,
                                                            'FontRegular'),
                                                  ),
                                                  Text(
                                                    historyOrders[index]
                                                        .tradeType
                                                        .toString(),
                                                    style: CustomWidget(
                                                            context: context)
                                                        .CustomSizedTextStyle(
                                                            14.0,
                                                            historyOrders[index]
                                                                        .tradeType
                                                                        .toString()
                                                                        .toLowerCase() ==
                                                                    "buy"
                                                                ? CustomTheme.of(
                                                                        context)
                                                                    .indicatorColor
                                                                : CustomTheme.of(
                                                                        context)
                                                                    .scaffoldBackgroundColor,
                                                            FontWeight.w500,
                                                            'FontRegular'),
                                                  ),
                                                ],
                                              ),
                                              Column(
                                                children: [
                                                  Text(
                                                    "Order Type",
                                                    style: CustomWidget(
                                                            context: context)
                                                        .CustomSizedTextStyle(
                                                            12.0,
                                                            Theme.of(context)
                                                                .splashColor
                                                                .withOpacity(
                                                                    0.5),
                                                            FontWeight.w400,
                                                            'FontRegular'),
                                                  ),
                                                  Text(
                                                    historyOrders[index]
                                                        .orderType
                                                        .toString(),
                                                    style: CustomWidget(
                                                            context: context)
                                                        .CustomSizedTextStyle(
                                                            12.0,
                                                            Theme.of(context)
                                                                .splashColor,
                                                            FontWeight.w400,
                                                            'FontRegular'),
                                                  ),
                                                ],
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.end,
                                              )
                                            ],
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 10.0,
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(
                                              left: 5.0, right: 5.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Column(
                                                children: [
                                                  Text(
                                                    "Price",
                                                    style: CustomWidget(
                                                            context: context)
                                                        .CustomSizedTextStyle(
                                                            12.0,
                                                            Theme.of(context)
                                                                .splashColor
                                                                .withOpacity(
                                                                    0.5),
                                                            FontWeight.w400,
                                                            'FontRegular'),
                                                  ),
                                                  Text(
                                                    historyOrders[index]
                                                        .price
                                                        .toString(),
                                                    style: CustomWidget(
                                                            context: context)
                                                        .CustomSizedTextStyle(
                                                            12.0,
                                                            Theme.of(context)
                                                                .splashColor,
                                                            FontWeight.w400,
                                                            'FontRegular'),
                                                  ),
                                                ],
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                              ),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    "Fee",
                                                    style: CustomWidget(
                                                            context: context)
                                                        .CustomSizedTextStyle(
                                                            12.0,
                                                            Theme.of(context)
                                                                .splashColor
                                                                .withOpacity(
                                                                    0.5),
                                                            FontWeight.w400,
                                                            'FontRegular'),
                                                  ),
                                                  Text(
                                                    historyOrders[index]
                                                        .fees
                                                        .toString(),
                                                    style: CustomWidget(
                                                            context: context)
                                                        .CustomSizedTextStyle(
                                                            14.0,
                                                            Theme.of(context)
                                                                .splashColor,
                                                            FontWeight.w400,
                                                            'FontRegular'),
                                                  ),
                                                ],
                                              ),
                                              Column(
                                                children: [
                                                  Text(
                                                    "Quantity",
                                                    style: CustomWidget(
                                                            context: context)
                                                        .CustomSizedTextStyle(
                                                            12.0,
                                                            Theme.of(context)
                                                                .splashColor
                                                                .withOpacity(
                                                                    0.5),
                                                            FontWeight.w400,
                                                            'FontRegular'),
                                                  ),
                                                  Text(
                                                    historyOrders[index]
                                                        .volume
                                                        .toString(),
                                                    style: CustomWidget(
                                                            context: context)
                                                        .CustomSizedTextStyle(
                                                            12.0,
                                                            Theme.of(context)
                                                                .splashColor,
                                                            FontWeight.w400,
                                                            'FontRegular'),
                                                  ),
                                                ],
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.end,
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 10.0,
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(
                                              left: 5.0, right: 5.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Column(
                                                children: [
                                                  Text(
                                                    "Total",
                                                    style: CustomWidget(
                                                            context: context)
                                                        .CustomSizedTextStyle(
                                                            12.0,
                                                            Theme.of(context)
                                                                .splashColor
                                                                .withOpacity(
                                                                    0.5),
                                                            FontWeight.w400,
                                                            'FontRegular'),
                                                  ),
                                                  Text(
                                                    historyOrders[index]
                                                        .value
                                                        .toString(),
                                                    style: CustomWidget(
                                                            context: context)
                                                        .CustomSizedTextStyle(
                                                            12.0,
                                                            Theme.of(context)
                                                                .splashColor,
                                                            FontWeight.w400,
                                                            'FontRegular'),
                                                  ),
                                                ],
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                              ),

                                              Column(
                                                children: [
                                                  Text(
                                                    "Status",
                                                    style: CustomWidget(
                                                            context: context)
                                                        .CustomSizedTextStyle(
                                                            12.0,
                                                            Theme.of(context)
                                                                .splashColor
                                                                .withOpacity(
                                                                    0.5),
                                                            FontWeight.w400,
                                                            'FontRegular'),
                                                  ),
                                                  Text(
                                                    historyOrders[index]
                                                        .status
                                                        .toString(),
                                                    style: CustomWidget(
                                                            context: context)
                                                        .CustomSizedTextStyle(
                                                            12.0,
                                                            historyOrders[index]
                                                                        .status
                                                                        .toString() ==
                                                                    "canceled"
                                                                ? Theme.of(
                                                                        context)
                                                                    .scaffoldBackgroundColor
                                                                : Theme.of(
                                                                        context)
                                                                    .selectedRowColor,
                                                            FontWeight.w500,
                                                            'FontRegular'),
                                                  ),
                                                ],
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                              ),
                                              // InkWell(
                                              //   child: Container(
                                              //     width: 80,
                                              //     padding: const EdgeInsets.only(
                                              //         top: 3.0, bottom: 3.0),
                                              //     decoration: BoxDecoration(
                                              //       color: Colors.red,
                                              //       borderRadius:
                                              //       BorderRadius.circular(5),
                                              //     ),
                                              //     child: Align(
                                              //       alignment: Alignment.center,
                                              //       child: Text(
                                              //         "Cancel",
                                              //         style: CustomWidget(
                                              //             context: context)
                                              //             .CustomSizedTextStyle(
                                              //             12.0,
                                              //             Theme.of(context)
                                              //                 .splashColor,
                                              //             FontWeight.w400,
                                              //             'FontRegular'),
                                              //         textAlign: TextAlign.center,
                                              //       ),
                                              //     ),
                                              //   ),
                                              //   onTap: () {
                                              //     setState(() {
                                              //       loading = true;
                                              //       updatecancelOrder(
                                              //         AllopenOrders[index]
                                              //             .id
                                              //             .toString(),
                                              //       );
                                              //     });
                                              //   },
                                              // ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 10.0,
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                                trailing: Container(
                                  width: 1.0,
                                  height: 10.0,
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 5.0,
                            ),
                            Container(
                              height: 1.0,
                              width: MediaQuery.of(context).size.width,
                              color: Theme.of(context).splashColor,
                            ),
                          ],
                        );
                      },
                    ),
                  ))
              : Container(
                  height: MediaQuery.of(context).size.height * 0.3,
                  color: Theme.of(context).backgroundColor,
                  child: Center(
                    child: Text(
                      "No Records Found..!",
                      style: CustomWidget(context: context)
                          .CustomSizedTextStyle(
                              12.0,
                              Theme.of(context).splashColor,
                              FontWeight.w400,
                              'FontRegular'),
                    ),
                  ),
                ),
          const SizedBox(
            height: 30.0,
          )
        ],
      ),
    );
  }

  getCoinList() {
    apiUtils.getTradePair().then((TradePairListModel loginData) {
      if (loginData.statusCode == 200) {
        setState(() {
          buyData = [];
          marginBuyData = [];
          sellData = [];
          marginSellData = [];
          marginBuyData.clear();
          marginSellData.clear();
          tradePair = loginData.data!;
          // tradePair = tradePair.reversed.toList();
          // searchPair = tradePair.reversed.toList();
          searchPair = tradePair;
          selectPair = tradePair[0];
          coinName = selectPair!.baseAsset!.symbol.toString();
          selectPairSymbol = selectPair!.pairSymbol.toString();
          coinTwoName = selectPair!.marketAsset!.symbol.toString();
          takerFeeValue = buySell
              ? selectPair!.buyTradeCommission.toString()
              : selectPair!.sellTradeCommission.toString();

          firstCoin = selectPair!.baseAsset!.symbol.toString();
          secondCoin = selectPair!.marketAsset!.symbol.toString();

          getCoinDetailsList(selectPair!.id.toString());
          if (selectPair!.tradeLogic == 0) {
            normalTrade = true;
            channelOpenOrder!.sink.close(status.goingAway);
            livePriceData!.sink.close(status.goingAway);
            getOpenOrder();
            getOrderBook();
          } else {
            normalTrade = false;
            getOpenOrder();
            socketData();
            socketLivepriceData();
          }

          /* var messageJSON = {
            "sub": "market." +
                firstCoin.toLowerCase() +
                secondCoin.toLowerCase() +
                ".depth.step0",
            "id": "id1"
          };
          var messageLiveJSON = {
            "sub": "market." +
                firstCoin.toLowerCase() +
                secondCoin.toLowerCase() +
                ".ticker",
          };
          channelOpenOrder!.sink.add(json.encode(messageJSON));
          livePriceData!.sink.add(json.encode(messageLiveJSON));


          selectedIndex = selectPair!.id.toString();

          for (int m = 0; m < tradePair.length; m++) {
            cheerList.add(LikeStatus(
              tradePair[m].id.toString(),
              tradePair[m].favorite!,
            ));
          }*/

          loading = false;
        });
      } else {
        setState(() {
          //loading = false;
        });
      }
    }).catchError((Object error) {
      print(error);
    });
  }

  getCoinDetailsList(String id) {
    apiUtils.getTradePairDetails(id).then((TradepairDetailsModel loginData) {
      if (loginData.statusCode == 200) {
        setState(() {
          // tradePair = tradePair.reversed.toList();
          // searchPair = tradePair.reversed.toList();
          searchPair = tradePair;
          selectPair = loginData.data!;
          coinName = selectPair!.baseAsset!.symbol.toString();
          coinTwoName = selectPair!.marketAsset!.symbol.toString();
          takerFeeValue = buySell
              ? selectPair!.buyTradeCommission.toString()
              : selectPair!.sellTradeCommission.toString();

          firstCoin = selectPair!.baseAsset!.symbol.toString();
          secondCoin = selectPair!.marketAsset!.symbol.toString();
          if (futureOption) {
            getBalance(selectPair!.marketWallet!.id.toString());
          } else {
            getBalance(buySell
                ? selectPair!.marketWallet!.id.toString()
                : selectPair!.baseWallet!.id.toString());
          }

          selectedIndex = selectPair!.id.toString();

          for (int m = 0; m < tradePair.length; m++) {
            cheerList.add(LikeStatus(
              tradePair[m].id.toString(),
              tradePair[m].favorite!,
            ));
          }
          livePrice = selectPair!.price.toString();
          loading = false;
        });
      } else {
        setState(() {
          //loading = false;
        });
      }
    }).catchError((Object error) {
      print(error);
    });
  }

  getLoanCoinList() {
    apiUtils.getWalletList().then((WalletListModel loginData) {
      if (loginData.statusCode == 200) {
        setState(() {
          loading = false;
          var cryptoList = loginData.data!;

          for (int i = 0; i < cryptoList.length; i++) {
            if (cryptoList[i].asset!.type == "coin") {
              coinList.add(cryptoList[i]);
              searchAssetPair = coinList;
            }
          }
          if (coinController.text.isEmpty) {
            coinController.text = coinList[0].asset!.symbol.toString();
            selectedAssetIndex = searchAssetPair[0].id.toString();
          }
        });
      } else {
        setState(() {
          loading = false;
        });
      }
    }).catchError((Object error) {
      print("hai");
      print(error);

      setState(() {
        loading = false;
      });
    });
  }

  marginLoan(
    String wallet_id,
    String loan_amount,
    String loan_mode,
  ) {
    apiUtils
        .doMarginLoan(wallet_id, loan_amount, loan_mode)
        .then((LoanModel loginData) {
      if (loginData.statusCode == 200) {
        setState(() {
          loading = false;
          amtController.clear();
          searchAssetController.clear();
          searchAssetController.text = "";
          amtController.text = "";
          getBalance(buySell
              ? selectPair!.marketWallet!.id.toString()
              : selectPair!.baseWallet!.id.toString());
          CustomWidget(context: context).custombar(
              marginVisibleOption ? "Margin" : "Future",
              loginData.message.toString(),
              true);
        });
      } else if (loginData.statusCode == 202) {
        setState(() {
          loading = false;
          CustomWidget(context: context).custombar(
              marginVisibleOption ? "Margin" : "Future",
              loginData.message.toString(),
              false);
        });
      } else {
        setState(() {
          loading = false;
          if (loginData.message.toString() ==
              "Margin Proceed with 1x leverage") {
            CustomWidget(context: context).custombar(
                marginVisibleOption ? "Margin" : "Future",
                loginData.message.toString(),
                true);
          } else {
            CustomWidget(context: context).custombar(
                marginVisibleOption ? "Margin" : "Future",
                loginData.message.toString(),
                false);
          }
        });
      }
    }).catchError((Object error) {
      print(error);
      setState(() {
        loading = false;
      });
    });
  }

  repayLoan(String wallet_id) {
    print("Helo");
    apiUtils
        .doMarginRepayLoan(wallet_id, "", marginVisibleOption ? "1" : "2")
        .then((RepayLoanModel loginData) {
      if (loginData.statusCode == 200) {
        setState(() {
          loading = false;
          searchAssetController.clear();
          searchAssetController.text = "";
          CustomWidget(context: context).custombar(
              marginVisibleOption ? "Margin" : "Future",
              loginData.message.toString(),
              true);
        });
      } else {
        setState(() {
          loading = false;
          CustomWidget(context: context).custombar(
              marginVisibleOption ? "Margin" : "Future",
              loginData.message.toString(),
              false);
        });
      }
    }).catchError((Object error) {
      print(error);
      setState(() {
        loading = false;
      });
    });
  }

  transferMargintoSpot(
    String wallet_id,
    String bal,
    String loan_mode,
  ) {
    apiUtils
        .doTransferMargin(wallet_id, bal, loan_mode)
        .then((MarginTransferModel loginData) {
      if (loginData.statusCode == 200) {
        setState(() {
          loading = false;
          amtController.clear();
          amtController.text = "";
          searchAssetController.clear();
          searchAssetController.text = "";
          getBalance(buySell
              ? selectPair!.marketWallet!.id.toString()
              : selectPair!.baseWallet!.id.toString());
          CustomWidget(context: context).custombar(
              marginVisibleOption ? "Margin" : "Future",
              loginData.message.toString(),
              true);
        });
      } else {
        setState(() {
          loading = false;
          CustomWidget(context: context).custombar(
              marginVisibleOption ? "Margin" : "Future",
              loginData.message.toString(),
              false);
        });
      }
    }).catchError((Object error) {
      print(error);
      setState(() {
        loading = false;
      });
    });
  }

  transferSpottoMargin(
    String wallet_id,
    String bal,
    String loan_mode,
  ) {
    apiUtils
        .doTransferSpot(wallet_id, bal, loan_mode)
        .then((MarginTransferModel loginData) {
      if (loginData.statusCode == 200) {
        setState(() {
          loading = false;
          amtController.clear();
          amtController.text = "";
          searchAssetController.clear();
          searchAssetController.text = "";
          getBalance(buySell
              ? selectPair!.marketWallet!.id.toString()
              : selectPair!.baseWallet!.id.toString());
          CustomWidget(context: context).custombar(
              marginVisibleOption ? "Margin" : "Future",
              loginData.message.toString(),
              true);
        });
      } else {
        setState(() {
          loading = false;
          CustomWidget(context: context).custombar(
              marginVisibleOption ? "Margin" : "Future",
              loginData.message.toString(),
              false);
        });
      }
    }).catchError((Object error) {
      print(error);
      setState(() {
        loading = false;
      });
    });
  }

  getBalance(String coin) {
    print(buySell
        ? selectPair!.marketWallet!.id.toString()
        : selectPair!.baseWallet!.id.toString());
    apiUtils.getBalance(coin).then((WalletBalanceModel loginData) {
      if (loginData.statusCode == 200) {
        setState(() {
          loading = false;
          if (marginVisibleOption) {
            balance = double.parse(loginData.data!.marginBalance.toString())
                .toStringAsFixed(8);
            escrow =
                double.parse(loginData.data!.marginEscrowBalance!.toString())
                    .toStringAsFixed(4);
            totalBalance = (double.parse(balance) + double.parse(escrow))
                .toStringAsFixed(4);
          } else if (futureOption) {
            balance = double.parse(loginData.data!.future_balance.toString())
                .toStringAsFixed(8);
            escrow =
                double.parse(loginData.data!.future_escrow_balance!.toString())
                    .toStringAsFixed(4);
            totalBalance = (double.parse(balance) + double.parse(escrow))
                .toStringAsFixed(4);
          } else {
            balance = double.parse(loginData.data!.balance.toString())
                .toStringAsFixed(8);
            escrow = double.parse(loginData.data!.escrowBalance!.toString())
                .toStringAsFixed(4);
            totalBalance = (double.parse(balance) + double.parse(escrow))
                .toStringAsFixed(4);
          }
        });
      } else {
        setState(() {
          // loading = false;
        });
      }
    }).catchError((Object error) {
      print("test");
      print(error);
      setState(() {
        //   loading = false;
      });
    });
  }

  placeOrder(bool check, String type) {
    print("Hello" + selectPair!.id.toString());
    apiUtils
        .placeTradeOrder(
            selectPair!.id.toString(),
            priceController.text.toString(),
            amountController.text.toString(),
            type,
            check)
        .then((CommonModel loginData) {
      if (loginData.status == 200) {
        setState(() {
          loading = false;
          loading = true;
          priceController.clear();
          amountController.clear();
          totalAmount = "0.00";
          _currentSliderValue = 0;
          getAllHistory("0");
          getOpenOrder();
          getAllOpenOrder();
          getBalance(buySell
              ? selectPair!.marketWallet!.id.toString()
              : selectPair!.baseWallet!.id.toString());

          CustomWidget(context: context)
              .custombar("Place Order", loginData.message.toString(), true);
        });
      } else {
        setState(() {
          loading = false;
          CustomWidget(context: context)
              .custombar("Place Order", loginData.message.toString(), false);
        });
      }
    }).catchError((Object error) {
      print(error);
      setState(() {
        loading = false;
      });
    });
  }

  placeMarginOrder(bool spotTrade, bool check, String type, String tradeMode,
      String leverage) {
    apiUtils
        .doMarginPostTrade(
            spotTrade,
            selectPair!.id.toString(),
            amountController.text.toString(),
            priceController.text.toString(),
            type,
            check,
            tradeMode,
            leverage)
        .then((MarginTradeModel loginData) {
      if (loginData.statusCode == 200) {
        setState(() {
          tradeOrder=true;
          loading = false;
          loading = true;
          priceController.clear();
          amountController.clear();
          marginBuyData = [];
          marginSellData = [];
          orderBook = [];
          orderSellBook = [];
          totalAmount = "0.00";
          _currentSliderValue = 0;
          getAllHistory("0");
          getOpenOrder();
          getOrderBook();
          getAllOpenOrder();
          getBalance(buySell
              ? selectPair!.marketWallet!.id.toString()
              : selectPair!.baseWallet!.id.toString());

          CustomWidget(context: context)
              .custombar("Place Order", loginData.message.toString(), true);
        });
      } else {
        setState(() {
          loading = false;
          CustomWidget(context: context)
              .custombar("Place Order", loginData.message.toString(), false);
        });
      }
    }).catchError((Object error) {
      print(error);
      setState(() {
        loading = false;
      });
    });
  }

  stopLimit(
    bool spotStop,
    String type,
    String tradeMode,
    String leverage,
  ) {
    apiUtils
        .doStopLimit(
            spotStop,
            selectPair!.id.toString(),
            priceController.text.toString(),
            stopPriceController.text.toString(),
            amountController.text.toString(),
            type,
            tradeMode,
            leverage)
        .then((CommonModel loginData) {
      if (loginData.status == 200) {
        setState(() {
          loading = false;
          loading = true;
          marginBuyData = [];
          marginSellData = [];
          orderBook = [];
          orderSellBook = [];
          priceController.clear();
          stopPriceController.clear();
          amountController.clear();
          totalAmount = "0.00";
          _currentSliderValue = 0;
          getAllHistory("0");
          getOpenOrder();
          getOrderBook();
          getAllOpenOrder();
          getBalance(buySell
              ? selectPair!.marketWallet!.id.toString()
              : selectPair!.baseWallet!.id.toString());

          CustomWidget(context: context)
              .custombar("Stop Limit", loginData.message.toString(), true);
        });
      } else {
        setState(() {
          loading = false;
          CustomWidget(context: context)
              .custombar("Stop Limit", loginData.message.toString(), false);
        });
      }
    }).catchError((Object error) {
      print(error);
      setState(() {
        loading = false;
      });
    });
  }

  addTOFav(String id, String type) {
    apiUtils.addToFav(id, type).then((CommonModel loginData) {
      if (loginData.status == 200) {
        setState(() {
          for (int m = 0; m < cheerList.length; m++) {
            if (id == cheerList[m].id) {
              if (type == "1") {
                cheerList[m].status = true;
              } else {
                cheerList[m].status = false;
              }
            }
          }
          checkFav(id);
        });
        CustomWidget(context: context)
            .custombar("Favorite", loginData.message.toString(), true);
      } else {
        setState(() {
          loading = false;
        });
      }
    }).catchError((Object error) {
      print(error);

      setState(() {
        loading = false;
      });
    });
  }

  getOpenOrder() {
    apiUtils
        .openOrderList(selectPair!.id.toString())
        .then((OpenOrderListModel loginData) {
      if (loginData.statusCode == 200) {
        setState(() {
          // loading = false;
          openOrders = [];
          openOrders = loginData.data!;
          /*if (normalTrade) {
            for (int i = 0; i < openOrders.length; i++) {
              if (selectedIndex == openOrders[i].tradePairId) {
                if (openOrders[i].tradeType == "buy") {
                  marginBuyData.add(BuySellData(
                    openOrders[i].price.toString(),
                    openOrders[i].volume.toString(),
                  ));
                } else if (openOrders[i].tradeType == "sell") {
                  marginSellData.add(BuySellData(
                    openOrders[i].price.toString(),
                    openOrders[i].volume.toString(),
                  ));
                }
              }
            }
            print("BuyData" + marginBuyData.length.toString());
          }*/
        });
      } else {
        setState(() {
          openOrders = [];
          //  loading = false;
        });
      }
    }).catchError((Object error) {
      print(error);
      setState(() {
        loading = false;
      });
    });
  }

  getOrderBook() {
    apiUtils
        .getOrderBook(selectPair!.pairSymbol.toString())
        .then((OrderBookModel loginData) {
      if (loginData.statusCode == 200) {
        setState(() {
          // loading = false;
            orderBook = [];
          orderSellBook = [];
          localSocketData();
          orderBook = loginData.data!.buytrade!;
          orderSellBook = loginData.data!.selltrade!;
           if (normalTrade) {
            for (int i = 0; i < orderBook.length; i++) {
              marginBuyData.add(BuySellData(
                orderBook[i].id.toString(),
                orderBook[i].volume.toString(),
              ));
            }
            for (int i = 0; i < orderSellBook.length; i++) {
              marginSellData.add(BuySellData(
                orderSellBook[i].id.toString(),
                orderSellBook[i].volume.toString(),
              ));
            }
            print("BuyData" + marginBuyData.length.toString());
          }
        });
      } else {
        setState(() {
          orderBook = [];
          orderSellBook = [];
          //  loading = false;
        });
      }
    }).catchError((Object error) {
      print(error);
      setState(() {
        loading = false;
      });
    });
  }

  getAllOpenOrder() {
    apiUtils.AllopenOrderList(false).then((OpenOrderListModel loginData) {
      if (loginData.statusCode == 200) {
        setState(() {
          //   loading = false;
          AllopenOrders = [];
          AllopenOrders = loginData.data!;
        });
      } else {
        setState(() {
          AllopenOrders = [];
          loading = false;
        });
      }
    }).catchError((Object error) {
      setState(() {
        // loading = false;
      });
    });
  }

  getFutureOpenOrder() {
    apiUtils.FutureOpenOrderList().then((FutureOpenOrderModel loginData) {
      if (loginData.statusCode == 200) {
        setState(() {
          //   loading = false;
          FutureopenOrders = [];
          FutureopenOrders = loginData.data!;
          getPositionOrder();
        });
      } else {
        setState(() {
          FutureopenOrders = [];
          loading = false;
        });
      }
    }).catchError((Object error) {
      setState(() {
        // loading = false;
      });
    });
  }

  getPositionOrder() {
    apiUtils.FuturePositionList().then((PositionOrderModel loginData) {
      if (loginData.statusCode == 200) {
        setState(() {
          //   loading = false;
          Futureposition = [];
          Futureposition = loginData.data!;
          // for (int m = 0; m < Futureposition.length; m++) {
          //   if(selectedIndex==Futureposition[m].tradePairId){
          //     Futureposition.add(Futureposition[m]);
          //   }
          // }
        });
      } else {
        setState(() {
          Futureposition = [];
          loading = false;
        });
      }
    }).catchError((Object error) {
      setState(() {
        // loading = false;
      });
    });
  }

  getAllHistory(String tradeType) {
    print(tradeType);
    apiUtils.AllopenOrderHistory(tradeType).then((AllOpenOrderModel loginData) {
      if (loginData.statusCode == 200) {
        setState(() {
          //  loading = false;
          historyOrders = [];

          historyOrders.clear();
          historyOrders = loginData.data!;
          // historyOrders = historyOrders.reversed.toList();
        });
      } else {
        setState(() {
          historyOrders = [];
          loading = false;
        });
      }
    }).catchError((Object error) {
      print(error);
      setState(() {
        loading = false;
      });
    });
  }

  getFutureAllHistory(String tradeType, StateSetter setState) {
    print(tradeType);
    apiUtils.AllopenOrderHistory(tradeType).then((AllOpenOrderModel loginData) {
      if (loginData.statusCode == 200) {
        setState(() {
          //  loading = false;
          historyOrders = [];
          historyOrders.clear();
          historyOrders = loginData.data!;
          // historyOrders = historyOrders.reversed.toList();
        });
      } else {
        setState(() {
          historyOrders = [];
          loading = false;
        });
      }
    }).catchError((Object error) {
      print(error);
      setState(() {
        loading = false;
      });
    });
  }

  updatecancelOrder(String id) {
    apiUtils.cancelTrade(id).then((CommonModel loginData) {
      if (loginData.status == 200) {
        setState(() {
          loading = false;
          openOrders = [];
          FutureopenOrders = [];
          AllopenOrders = [];
          marginBuyData = [];
          marginSellData = [];
          getOpenOrder();
          getFutureOpenOrder();
          getOrderBook();
          getAllOpenOrder();
          getAllHistory("0");
          if (futureOption) {
            getBalance(selectPair!.marketWallet!.id.toString());
          } else {
            getBalance(buySell
                ? selectPair!.marketWallet!.id.toString()
                : selectPair!.baseWallet!.id.toString());
          }
        });
        CustomWidget(context: context)
            .custombar("Cancel", loginData.message.toString(), true);
      } else {
        setState(() {
          AllopenOrders = [];
          loading = false;
        });
      }
    }).catchError((Object error) {
      print(error);
      setState(() {
        loading = false;
      });
    });
  }

  showSheeet() {
    return showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) {
          return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Container(
                height: MediaQuery.of(context).size.height * 0.9,
                width: MediaQuery.of(context).size.width,
                color: Theme.of(context).primaryColor,
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 20.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: 10.0),
                          child: Container(
                            height: 45.0,
                            padding: EdgeInsets.only(left: 20.0),
                            width: MediaQuery.of(context).size.width * 0.8,
                            child: TextField(
                              controller: searchController,
                              focusNode: searchFocus,
                              enabled: true,
                              onEditingComplete: () {
                                setState(() {
                                  searchFocus.unfocus();
                                });
                              },
                              onChanged: (value) {
                                setState(() {
                                  setState(() {
                                    buyData = [];
                                    marginBuyData = [];
                                    sellData = [];
                                    marginSellData = [];
                                    marginBuyData.clear();
                                    marginSellData.clear();
                                    searchPair = [];

                                    for (int m = 0; m < tradePair.length; m++) {
                                      if (tradePair[m]
                                              .baseAsset!
                                              .symbol
                                              .toString()
                                              .toLowerCase()
                                              .contains(value
                                                  .toString()
                                                  .toLowerCase()) ||
                                          tradePair[m]
                                              .marketAsset!
                                              .symbol
                                              .toString()
                                              .toLowerCase()
                                              .contains(value
                                                  .toString()
                                                  .toLowerCase()) ||
                                          tradePair[m]
                                              .displayName
                                              .toString()
                                              .toLowerCase()
                                              .contains(value
                                                  .toString()
                                                  .toLowerCase())) {
                                        searchPair.add(tradePair[m]);
                                      }
                                    }
                                  });
                                });
                              },
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.only(
                                    left: 12, right: 0, top: 8, bottom: 8),
                                hintText: "Search",
                                hintStyle: TextStyle(
                                    fontFamily: "FontRegular",
                                    color: Theme.of(context).hintColor,
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.w400),
                                filled: true,
                                fillColor: CustomTheme.of(context)
                                    .backgroundColor
                                    .withOpacity(0.5),
                                border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5.0)),
                                  borderSide: BorderSide(
                                      color: CustomTheme.of(context)
                                          .splashColor
                                          .withOpacity(0.5),
                                      width: 1.0),
                                ),
                                disabledBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5.0)),
                                  borderSide: BorderSide(
                                      color: CustomTheme.of(context)
                                          .splashColor
                                          .withOpacity(0.5),
                                      width: 1.0),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5.0)),
                                  borderSide: BorderSide(
                                      color: CustomTheme.of(context)
                                          .splashColor
                                          .withOpacity(0.5),
                                      width: 1.0),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5.0)),
                                  borderSide: BorderSide(
                                      color: CustomTheme.of(context)
                                          .splashColor
                                          .withOpacity(0.5),
                                      width: 1.0),
                                ),
                                errorBorder: const OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5)),
                                  borderSide:
                                      BorderSide(color: Colors.red, width: 0.0),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          child: Align(
                              child: InkWell(
                            onTap: () {
                              Navigator.pop(context);
                              setState(() {
                                searchController.clear();
                                searchPair.addAll(tradePair);
                              });
                            },
                            child: Icon(
                              Icons.close,
                              size: 20.0,
                              color: Theme.of(context).hintColor,
                            ),
                          )),
                        ),
                        const SizedBox(
                          width: 10.0,
                        )
                      ],
                    ),
                    Expanded(
                        child: ListView.builder(
                            controller: controller,
                            itemCount: searchPair.length,
                            itemBuilder: ((BuildContext context, int index) {
                              return Column(
                                children: [
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        buyData = [];
                                        marginBuyData = [];
                                        sellData = [];
                                        marginSellData = [];
                                        marginBuyData.clear();
                                        marginSellData.clear();
                                        selectPair = searchPair[index];
                                        selectedIndex =
                                            selectPair!.id.toString();
                                        selectPairSymbol =
                                            selectPair!.pairSymbol.toString();
                                        priceController.clear();
                                        amountController.clear();
                                        totalAmount = "0.00";
                                        _currentSliderValue = 0;
                                        coinName = selectPair!.baseAsset!.symbol
                                            .toString();
                                        coinTwoName = selectPair!
                                            .marketAsset!.symbol
                                            .toString();
                                        getCoinDetailsList(
                                            selectPair!.id.toString());
                                        loading = true;
                                        firstCoin = selectPair!
                                            .baseAsset!.symbol
                                            .toString();
                                        secondCoin = selectPair!
                                            .marketAsset!.symbol
                                            .toString();
                                        Navigator.pop(context);
                                      });
                                      searchController.clear();
                                      livePriceData!.sink
                                          .close(status.goingAway);
                                      channelOpenOrder!.sink
                                          .close(status.goingAway);
                                      if (selectPair!.tradeLogic == 1) {
                                        normalTrade = false;
                                        channelOpenOrder =
                                            IOWebSocketChannel.connect(
                                                Uri.parse(
                                                    "wss://api.huobi.pro/ws"),
                                                pingInterval:
                                                    Duration(seconds: 30));
                                        livePriceData =
                                            IOWebSocketChannel.connect(
                                                Uri.parse(
                                                    "wss://api.huobi.pro/ws"),
                                                pingInterval:
                                                    Duration(seconds: 30));
                                        socketData();
                                        socketLivepriceData();
                                        getOpenOrder();
                                        getFutureOpenOrder();
                                        getAllOpenOrder();
                                        getAllHistory("0");
                                        checkFav(selectPair!.id.toString());
                                      } else {
                                        normalTrade = true;
                                        livePriceData!.sink
                                            .close(status.goingAway);
                                        channelOpenOrder!.sink
                                            .close(status.goingAway);
                                        getOpenOrder();
                                        getFutureOpenOrder();
                                        getOrderBook();
                                        getAllOpenOrder();
                                        getAllHistory("0");
                                        checkFav(selectPair!.id.toString());
                                      }
                                    },
                                    child: Row(
                                      children: [
                                        const SizedBox(
                                          width: 20.0,
                                        ),
                                        Container(
                                          height: 25.0,
                                          width: 25.0,
                                          child: SvgPicture.network(
                                            "https://cifdaq.in/api/color/" +
                                                searchPair[index]
                                                    .baseAsset!
                                                    .assetname
                                                    .toString()
                                                    .toLowerCase() +
                                                ".svg",
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 10.0,
                                        ),
                                        Text(
                                          searchPair[index]
                                              .displayName
                                              .toString(),
                                          style: CustomWidget(context: context)
                                              .CustomSizedTextStyle(
                                                  16.0,
                                                  Theme.of(context).splashColor,
                                                  FontWeight.w500,
                                                  'FontRegular'),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 5.0,
                                  ),
                                  Container(
                                    height: 1.0,
                                    width: MediaQuery.of(context).size.width,
                                    color:
                                        CustomTheme.of(context).backgroundColor,
                                  ),
                                  const SizedBox(
                                    height: 5.0,
                                  ),
                                ],
                              );
                            }))),
                  ],
                ),
              );
            },
          );
        });
  }

  showAssetSheet() {
    return showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) {
          return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Container(
                height: MediaQuery.of(context).size.height * 0.9,
                width: MediaQuery.of(context).size.width,
                color: Theme.of(context).primaryColor,
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 20.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: 10.0),
                          child: Container(
                            height: 45.0,
                            padding: EdgeInsets.only(left: 20.0),
                            width: MediaQuery.of(context).size.width * 0.8,
                            child: TextField(
                              controller: searchAssetController,
                              focusNode: searchAssetFocus,
                              enabled: true,
                              onEditingComplete: () {
                                setState(() {
                                  searchAssetFocus.unfocus();
                                });
                              },
                              onChanged: (value) {
                                setState(() {
                                  setState(() {
                                    searchAssetPair = [];
                                    for (int m = 0; m < coinList.length; m++) {
                                      if (coinList[m]
                                          .asset!
                                          .symbol
                                          .toString()
                                          .toLowerCase()
                                          .contains(
                                              value.toString().toLowerCase())) {
                                        searchAssetPair.add(coinList[m]);
                                      }
                                    }
                                  });
                                });
                              },
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.only(
                                    left: 12, right: 0, top: 8, bottom: 8),
                                hintText: "Search",
                                hintStyle: TextStyle(
                                    fontFamily: "FontRegular",
                                    color: Theme.of(context).hintColor,
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.w400),
                                filled: true,
                                fillColor: CustomTheme.of(context)
                                    .backgroundColor
                                    .withOpacity(0.5),
                                border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5.0)),
                                  borderSide: BorderSide(
                                      color: CustomTheme.of(context)
                                          .splashColor
                                          .withOpacity(0.5),
                                      width: 1.0),
                                ),
                                disabledBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5.0)),
                                  borderSide: BorderSide(
                                      color: CustomTheme.of(context)
                                          .splashColor
                                          .withOpacity(0.5),
                                      width: 1.0),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5.0)),
                                  borderSide: BorderSide(
                                      color: CustomTheme.of(context)
                                          .splashColor
                                          .withOpacity(0.5),
                                      width: 1.0),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5.0)),
                                  borderSide: BorderSide(
                                      color: CustomTheme.of(context)
                                          .splashColor
                                          .withOpacity(0.5),
                                      width: 1.0),
                                ),
                                errorBorder: const OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5)),
                                  borderSide:
                                      BorderSide(color: Colors.red, width: 0.0),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Container(
                          child: Align(
                              child: InkWell(
                            onTap: () {
                              Navigator.pop(context);
                              setState(() {
                                searchAssetController.clear();
                                amountController.clear();
                                searchAssetPair.addAll(coinList);
                              });
                            },
                            child: Icon(
                              Icons.close,
                              size: 20.0,
                              color: Theme.of(context).hintColor,
                            ),
                          )),
                        ),
                        const SizedBox(
                          width: 10.0,
                        )
                      ],
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Expanded(
                        child: ListView.builder(
                            controller: controller,
                            itemCount: searchAssetPair.length,
                            itemBuilder: ((BuildContext context, int index) {
                              return Column(
                                children: [
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        selectAsset = searchAssetPair[index];
                                        selectedAssetIndex =
                                            selectAsset!.id.toString();
                                        amtController.clear();
                                        totalAmount = "0.00";
                                        _currentSliderValue = 0;
                                        assetName = selectAsset!.asset!.symbol
                                            .toString();
                                        coinController.text = selectAsset!
                                            .asset!.symbol
                                            .toString();
                                        searchAssetController.clear();
                                        searchAssetPair = [];
                                        coinList = [];
                                        getLoanCoinList();
                                        /*getBalance(buySell
                                            ? selectPair!.marketWallet!.id.toString()
                                            : selectPair!.baseWallet!.id.toString());*/
                                        /*loading = true;*/
                                        firstCoin = selectPair!
                                            .baseAsset!.symbol
                                            .toString();
                                        secondCoin = selectPair!
                                            .marketAsset!.symbol
                                            .toString();
                                        Navigator.pop(context);
                                      });
                                    },
                                    child: Row(
                                      children: [
                                        const SizedBox(
                                          width: 20.0,
                                        ),
                                        Container(
                                          height: 25.0,
                                          width: 25.0,
                                          child: SvgPicture.network(
                                            "https://cifdaq.in/api/color/" +
                                                searchAssetPair[index]
                                                    .asset!
                                                    .assetname
                                                    .toString()
                                                    .toLowerCase() +
                                                ".svg",
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 10.0,
                                        ),
                                        Text(
                                          searchAssetPair[index]
                                              .asset!
                                              .symbol
                                              .toString(),
                                          style: CustomWidget(context: context)
                                              .CustomSizedTextStyle(
                                                  16.0,
                                                  Theme.of(context).splashColor,
                                                  FontWeight.w500,
                                                  'FontRegular'),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 5.0,
                                  ),
                                  Container(
                                    height: 1.0,
                                    width: MediaQuery.of(context).size.width,
                                    color:
                                        CustomTheme.of(context).backgroundColor,
                                  ),
                                  const SizedBox(
                                    height: 5.0,
                                  ),
                                ],
                              );
                            }))),
                  ],
                ),
              );
            },
          );
        });
  }

  checkFav(String id) {
    for (int m = 0; m < cheerList.length; m++) {
      if (id == cheerList[m].id) {
        setState(() {
          favValue = cheerList[m].status;
        });
      }
    }
  }
}

class CustomTrackShape extends RoundedRectSliderTrackShape {
  Rect getPreferredRect({
    required RenderBox parentBox,
    Offset offset = Offset.zero,
    required SliderThemeData sliderTheme,
    bool isEnabled = false,
    bool isDiscrete = false,
  }) {
    final double? trackHeight = sliderTheme.trackHeight;
    final double? trackLeft = offset.dx;
    final double? trackTop =
        offset.dy + (parentBox.size.height - trackHeight!) / 2;
    final double? trackWidth = parentBox.size.width;
    return Rect.fromLTWH(trackLeft!, trackTop!, trackWidth!, trackHeight);
  }
}

class BuySellData {
  String price;
  String quantity;

  BuySellData(this.price, this.quantity);
}

class LikeStatus {
  String id;
  bool status;

  LikeStatus(this.id, this.status);
}
