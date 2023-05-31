import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:h2_crypto/data/crypt_model/coin_list.dart';
import 'package:h2_crypto/data/crypt_model/common_model.dart';
import 'package:h2_crypto/data/crypt_model/open_order_list_model.dart';
import 'package:h2_crypto/data/crypt_model/quote_details_model.dart';
import 'package:h2_crypto/screens/trade/trade_chart.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:h2_crypto/common/custom_widget.dart';
import 'package:h2_crypto/data/api_utils.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:web_socket_channel/io.dart';
import '../../../common/colors.dart';
import '../../../common/localization/localizations.dart';
import '../../../common/theme/custom_theme.dart';

class TradeScreen extends StatefulWidget {
  const TradeScreen({Key? key}) : super(key: key);

  @override
  State<TradeScreen> createState() => _SellTradeScreenState();
}

class _SellTradeScreenState extends State<TradeScreen>
    with TickerProviderStateMixin {
  List<String> marginType = ["Loan", " Repay", "Transfer"];
  List<String> chartTime = [
    "Limit Order",
    "Market Order",
  ];
  List<String> chartTimeFuture = ["Limit Order", "Market Order"];
  List<String> transferType = ["Spot-Margin", "Margin-Spot"];
  List<String> tradeType = ["Spot", "Margin", "Future"];
  List<String> transferFutureType = ["Spot-Future", "Future-Spot"];
  String selectedTime = "";

  List<CoinList> tradePair = [];
  List<CoinList> searchPair = [];
  CoinList? selectPair;

  List<CoinList> QuicktradePair = [];
  List<CoinList> QuickSearchPair = [];
  CoinList? QuickselectPair;
  final _formKey = GlobalKey<FormState>();
  List<OpenOrderList> openOrders = [];
  List<OpenOrderList> historyOrders = [];
  bool buySell = true;
  bool loanErr = false;

  late TabController _tabController, tradeTabController;
  bool spotOption = false;
  bool marginOption = true;

  TextEditingController coinController = TextEditingController();
  TextEditingController priceController = TextEditingController();

  TextEditingController amountController = TextEditingController();
  TextEditingController quickAmountController = TextEditingController();

  APIUtils apiUtils = APIUtils();
  bool buyOption = true;
  bool sellOption = true;
  final List<String> _decimal = [
    "0.01",
    "0.0001",
    "0.00000001",
  ];
  int decimalIndex = 2;
  bool cancelOrder = false;
  ScrollController controller = ScrollController();
  bool loading = false;
  List<LikeStatus> cheerList = [];

  TextEditingController searchController = TextEditingController();
  FocusNode searchFocus = FocusNode();
  TextEditingController searchAssetController = TextEditingController();
  FocusNode searchAssetFocus = FocusNode();
  bool enableTrade = false;

  String balance = "0.00";
  String escrow = "0.00";
  String val = "";
  String totalBalance = "0.00";

  String totalAmount = "0.00";
  String price = "0.00";
  String stopPrice = "0.00";
  String tradeAmount = "0.00";
  String takerFee = "0.00";
  String takerFeeValue = "0.00";
  double _currentSliderValue = 0;

  bool favValue = false;
  String selectedIndex = "";
  String selectedAssetIndex = "";
  String leverageVal = "1";
  String tleverageVal = "1";
  IOWebSocketChannel? channelOpenOrder;

  List<BuySellData> buyData = [];
  List<BuySellData> buyReverseData = [];

  String quoteID = "";
  List<BuySellData> sellData = [];
  List<BuySellData> sellReverseData = [];

  List<CoinList> coinList = [];
  List<CoinList> searchAssetPair = [];

  String firstCoin = "";
  String secondCoin = "";
  String QuickfirstCoin = "";
  String QuicksecondCoin = "";

  String livePrice = "0.00";
  String QuicklivePrice = "0.00";

  bool socketLoader = false;
  String selectedDecimal = "";
  String selectedMarginType = " ";

  String token = "";

  List<BalanceData> availableBalance = [];
  int _remainingTime = 10; //initial time in seconds
  late Timer _timer;
  bool quote = false;
  AnimationController? _animationController;
  Animation? _colorTween;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    selectedTime = chartTime.first;
    _animationController = AnimationController(
        vsync: this, duration: Duration(milliseconds: 10000));
    _colorTween = ColorTween(begin: Colors.grey.withOpacity(0.5), end: Colors.transparent)
        .animate(_animationController!);
    selectedMarginType = marginType.first;

    _tabController = TabController(vsync: this, length: 2);
    tradeTabController = TabController(vsync: this, length: 3);
    selectedDecimal = _decimal.first;
    loading = true;

    getData();

    channelOpenOrder = IOWebSocketChannel.connect(
        Uri.parse("wss://ws.sfox.com/ws"),
        pingInterval: Duration(seconds: 30));
  }

  getData() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      token = preferences.getString("sfox").toString();

      getCoinList();
      getTradeOrders();
    });
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 2), (timer) {
      setState(() {
        if (_remainingTime > 0) {
          _remainingTime = _remainingTime - 1;
        } else {
          quoteID = "";
          quote = false;
          _timer.cancel();
        }
      });
    });
  }

  Future changeColors() async {
    while (true) {
      await new Future.delayed(const Duration(seconds: 2), () {
        if (_animationController!.status == AnimationStatus.completed) {
          _animationController!.reverse();
        } else {
          _animationController!.forward();
        }
      });
    }
  }

  socketConnection() {}

  socketData() {
    setState(() {
      buyData.clear();
      sellData.clear();
      buyData = [];
      sellData = [];
      buyReverseData = [];
      sellReverseData = [];
    });
    channelOpenOrder!.stream.listen(
      (data) {
        if (data != null || data != "null") {
          var decode = jsonDecode(data);

          if (mounted) {
            setState(() {
              loading = false;
              String val = decode["recipient"];

              if (val.toLowerCase() ==
                      "ticker.sfox." + selectPair!.symbol!.toLowerCase() ||
                  val.toLowerCase() ==
                      "ticker.sfox." + QuickselectPair!.symbol!.toLowerCase()) {
                if (marginOption) {
                  var m = decode["payload"]["last"];
                  /*QuicklivePrice = m.toString();*/
                } else {
                  var m = decode["payload"]["last"];
                  livePrice = m.toString();
                }
              } else if (val == "private.user.balances") {
                availableBalance.clear();
                availableBalance = [];
                var list1 = List<dynamic>.from(decode['payload']);
                for (int m = 0; m < list1.length; m++) {
                  availableBalance.add(BalanceData(
                    list1[m]["currency"].toString(),
                    list1[m]["balance"].toString() == "null"
                        ? "0.00"
                        : list1[m]["balance"].toString(),
                    list1[m]["available"].toString() == "null"
                        ? "0.00"
                        : list1[m]["available"].toString(),
                    list1[m]["trading_wallet"].toString() == "null"
                        ? "0.00"
                        : list1[m]["trading_wallet"].toString(),
                  ));
                }
                for (int m = 0; m < availableBalance.length; m++) {
                  if (marginOption) {
                    if (buySell) {
                      if (QuicksecondCoin.toLowerCase() ==
                          availableBalance[m].currency.toLowerCase()) {
                        balance = availableBalance[m].balance;
                        escrow = availableBalance[m].available;
                        totalBalance = availableBalance[m].trading;
                      }
                    } else {
                      if (QuickfirstCoin.toLowerCase() ==
                          availableBalance[m].currency.toLowerCase())
                        balance = availableBalance[m].balance;
                      escrow = availableBalance[m].available;
                      totalBalance = availableBalance[m].trading;
                    }
                  } else {
                    if (buySell) {
                      if (secondCoin.toLowerCase() ==
                          availableBalance[m].currency.toLowerCase()) {
                        balance = availableBalance[m].balance;
                        escrow = availableBalance[m].available;
                        totalBalance = availableBalance[m].trading;
                      }
                    } else {
                      if (firstCoin.toLowerCase() ==
                          availableBalance[m].currency.toLowerCase())
                        balance = availableBalance[m].balance;
                      escrow = availableBalance[m].available;
                      totalBalance = availableBalance[m].trading;
                    }
                  }
                }
              } else if (val == "private.user.open-orders") {
                openOrders = [];
                openOrders.clear();
                openOrders.add(OpenOrderList(
                  id: decode["payload"]["id"],
                  pair: decode["payload"]["pair"],
                  fees: decode["payload"]["fees"],
                  date: decode["timestamp"],
                  filled: decode["payload"]["filled"],
                  filled_amount: decode["payload"]["filled_amount"],
                  orderType: decode["payload"]["action"],
                  price: decode["payload"]["price"],
                  userId: decode["payload"]["client_order_id"],
                  volume: decode["payload"]["quantity"],
                  status: decode["payload"]["status"],
                ));
              } else if (val ==
                  "orderbook.net." + selectPair!.symbol!.toLowerCase()) {
                buyData.clear();
                sellData.clear();
                buyData = [];
                sellData = [];
                var list1 = List<dynamic>.from(decode['payload']['bids']);
                var list2 = List<dynamic>.from(decode['payload']['asks']);
                for (int m = 0; m < list1.length; m++) {
                  buyData.add(BuySellData(
                    list1[m][0].toString(),
                    list1[m][1].toString(),
                  ));
                  buyReverseData.add(BuySellData(
                    list1[m][0].toString(),
                    list1[m][1].toString(),
                  ));
                }
                for (int m = 0; m < list2.length; m++) {
                  sellData.add(BuySellData(
                    list2[m][0].toString(),
                    list2[m][1].toString(),
                  ));
                  sellReverseData.add(BuySellData(
                    list2[m][0].toString(),
                    list2[m][1].toString(),
                  ));
                }
              }

              buyReverseData=buyReverseData.reversed.toList();
              sellReverseData=sellReverseData.reversed.toList();
            });
          }
        }
      },
      onDone: () async {
        await Future.delayed(Duration(seconds: 10));
        String pair = selectPair!.symbol.toString();

        var ofeed = "orderbook.net.$pair";
        var tfeed = "private.user.balances";
        var tickerfeed = "ticker.sfox.$pair";
        var orderfeed = "private.user.open-orders";
        var messageJSON = {
          "type": "subscribe",
          "feeds": [ofeed, tickerfeed, orderfeed, tfeed],
        };
        var authMessage = {
          "type": "authenticate",
          "apiKey": token,
        };
        channelOpenOrder!.sink.add(json.encode(authMessage));
        channelOpenOrder!.sink.add(json.encode(messageJSON));
        socketData();
      },
      onError: (error) => print("Err" + error),
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

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
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
                  Theme.of(context).dialogBackgroundColor,
                ])),
            child: Stack(
              children: [
                Container(
                    child: SingleChildScrollView(
                  controller: controller,
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: CustomTheme.of(context)
                                    .splashColor
                                    .withOpacity(0.5),
                                width: 0.5)),
                        child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
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

                                      priceController.clear();
                                      amountController.clear();
                                      getCoinList();
                                      enableTrade = false;
                                      selectedTime = chartTime.first;
                                    });
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color: marginOption
                                                ? CustomTheme.of(context)
                                                .shadowColor
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
                                                .text("loc_quick_buy_sell"),
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
                                flex: 1,
                              ),
                              Flexible(
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      buySell = true;
                                      selectPair = tradePair[0];
                                      _currentSliderValue = 0;
                                      totalAmount = "0.0";
                                      openOrders = [];
                                      spotOption = true;
                                      marginOption = false;

                                      priceController.clear();
                                      amountController.clear();

                                      enableTrade = false;
                                      selectedTime = chartTime.first;
                                    });
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color: spotOption
                                                ? CustomTheme.of(context)
                                                    .shadowColor
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
                marginOption
                    ? InkWell(
                        onTap: () {
                          showQuickSheeet();
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
                            QuicktradePair.length > 0
                                ? Text(
                                    QuickselectPair!.tradePair.toString(),
                                    style: CustomWidget(context: context)
                                        .CustomSizedTextStyle(
                                            16.0,
                                            Theme.of(context).splashColor,
                                            FontWeight.w500,
                                            'FontRegular'),
                                  )
                                : Container(),
                          ],
                        ),
                      )
                    : InkWell(
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
                                    selectPair!.tradePair.toString(),
                                    style: CustomWidget(context: context)
                                        .CustomSizedTextStyle(
                                            16.0,
                                            Theme.of(context).splashColor,
                                            FontWeight.w500,
                                            'FontRegular'),
                                  )
                                : Container(),
                          ],
                        ),
                      ),
                InkWell(
                  onTap: (){
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) =>  TradeChartScreen(pair: marginOption?QuickfirstCoin.toLowerCase()+"_"+QuicksecondCoin.toLowerCase():firstCoin.toLowerCase()+"_"+secondCoin.toLowerCase())));

                  },
                  child:  SvgPicture.asset('assets/images/chart.svg',height: 25.0,),
                )
              ]),
          const SizedBox(
            height: 10.0,
          ),
          Container(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(
                  child: marginOption ? QuickBuy() : OrderWidget(),
                  flex: 1,
                ),
                const SizedBox(
                  width: 10.0,
                ),
                marginOption
                    ? Container()
                    : Flexible(
                        child: marketWidget(),
                        flex: 1,
                      ),
              ],
            ),
          ),
          const SizedBox(
            height: 15.0,
          ),
          AnimatedBuilder(
            animation: _colorTween!,
            builder: (context, child) => Container(
              color: quote?_colorTween!.value:Colors.transparent,
              child: Column(
                children: [
                  quote
                      ?marginOption ?Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Total "+ (buySell ?  firstCoin:secondCoin),
                        style: CustomWidget(context: context).CustomSizedTextStyle(
                            12.0,
                            Theme.of(context).splashColor,
                            FontWeight.bold,
                            'FontRegular'),
                      ),
                      Text(
                        quickAmountController.text.isEmpty?"0.00":quickAmountController.text,
                        style: CustomWidget(context: context).CustomSizedTextStyle(
                            11.5,
                            Theme.of(context).splashColor,
                            FontWeight.w500,
                            'FontRegular'),
                      ),
                    ],
                  ):Container():Container(),
                  SizedBox(
                    height: 5.0,
                  ),
                  marginOption
                      ?quote?Row(
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
                         QuicklivePrice +
                                " " +
                                (buySell ? secondCoin : firstCoin),
                        style: CustomWidget(context: context).CustomSizedTextStyle(
                            11.5,
                            Theme.of(context).splashColor,
                            FontWeight.w500,
                            'FontRegular'),
                      ),
                    ],
                  ):Container():Row(
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
                         livePrice + " " + (buySell ? secondCoin : firstCoin),
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
                  quote
                      ?marginOption ?Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Total "+ (buySell ?  secondCoin:firstCoin),
                        style: CustomWidget(context: context).CustomSizedTextStyle(
                            12.0,
                            Theme.of(context).splashColor,
                            FontWeight.bold,
                            'FontRegular'),
                      ),
                      Text(
                        totalAmount,
                        style: CustomWidget(context: context).CustomSizedTextStyle(
                            11.5,
                            Theme.of(context).splashColor,
                            FontWeight.w500,
                            'FontRegular'),
                      ),
                    ],
                  ):Container():Container(),


                ],
              ),
            ),
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
                balance + " " + ((buySell ? secondCoin : firstCoin)),
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
          const SizedBox(
            height: 10.0,
          ),
          InkWell(
            onTap: () {
              showOrders();
            },
            child: Padding(
              padding: const EdgeInsets.only(left: 0.0, right: 0.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Open Orders ( " + (openOrders.length.toString()) + " )",
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
          openOrdersUIS(),
        ],
      ),
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
                                      reverse: true,
                                      itemBuilder:
                                          ((BuildContext context, int index) {
                                        return Column(
                                          children: [
                                            InkWell(
                                              onTap: () {
                                                setState(() {
                                                  buySell = true;
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
                                            Theme.of(context).dialogBackgroundColor,
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
                                            Theme.of(context).dialogBackgroundColor,
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
                          Theme.of(context).dialogBackgroundColor,
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
                                decimalIndex = 2;
                              } else if (m == 1) {
                                decimalIndex = 4;
                              } else {
                                decimalIndex = 8;
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

  Widget marketSellWidget() {
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
              child: sellReverseData.length > 0
                  ? ListView.builder(
                  controller: controller,
                  reverse: true,
                  itemCount: sellReverseData.length,
                  itemBuilder:
                  ((BuildContext context, int index) {
                    return Column(
                      children: [
                        InkWell(
                          onTap: () {
                            setState(() {
                              buySell = true;
                            });
                          },
                          child: Row(
                            mainAxisAlignment:
                            MainAxisAlignment
                                .spaceBetween,
                            children: [
                              Text(
                                double.parse(sellReverseData[index]
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
                                double.parse(sellReverseData[index]
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
                          Theme.of(context).dialogBackgroundColor,
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
                            Theme.of(context).dialogBackgroundColor,
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
                    Theme.of(context).dialogBackgroundColor,
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
                                decimalIndex = 2;
                              } else if (m == 1) {
                                decimalIndex = 4;
                              } else {
                                decimalIndex = 8;
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
                    // Moment spiritRoverOnMars =
                    //     Moment(openOrders[index].createdAt!).toLocal();
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
                                      openOrders[index].pair.toString(),
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
                                                "Date",
                                                // spiritRoverOnMars
                                                //     .format(
                                                //         "YYYY MMMM Do - hh:mm:ssa")
                                                //     .toString(),
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
                                                    .orderType
                                                    .toString(),
                                                style: CustomWidget(
                                                        context: context)
                                                    .CustomSizedTextStyle(
                                                        14.0,
                                                        openOrders[index]
                                                                    .orderType
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
                                                cancelTrade(openOrders[index]
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
        Container(
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

                      totalAmount = "0.0";
                      _currentSliderValue = 0;
                      tleverageVal = "1";
                      balance = "0.00";
                      escrow = "0.00";
                      totalBalance = "0.00";

                      firstCoin = selectPair!.baseAsset.toString();
                      secondCoin = selectPair!.marketAsset.toString();
                      for (int m = 0; m < availableBalance.length; m++) {
                        if (buySell) {
                          if (secondCoin.toLowerCase() ==
                              availableBalance[m].currency.toLowerCase()) {
                            balance = availableBalance[m].balance;
                            escrow = availableBalance[m].available;
                            totalBalance = availableBalance[m].trading;
                          }
                        } else {
                          if (firstCoin.toLowerCase() ==
                              availableBalance[m].currency.toLowerCase()) {
                            balance = availableBalance[m].balance;
                            escrow = availableBalance[m].available;
                            totalBalance = availableBalance[m].trading;
                          }
                        }
                      }
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

                    totalAmount = "0.0";
                    _currentSliderValue = 0;
                    tleverageVal = "1";
                    firstCoin = selectPair!.baseAsset.toString();
                    secondCoin = selectPair!.marketAsset.toString();
                    balance = "0.00";
                    escrow = "0.00";
                    totalBalance = "0.00";
                    for (int m = 0; m < availableBalance.length; m++) {
                      if (buySell) {
                        if (secondCoin.toLowerCase() ==
                            availableBalance[m].currency.toLowerCase()) {
                          balance = availableBalance[m].balance;
                          escrow = availableBalance[m].available;
                          totalBalance = availableBalance[m].trading;
                        }
                      } else {
                        if (firstCoin.toLowerCase() ==
                            availableBalance[m].currency.toLowerCase()) {

                          balance = availableBalance[m].balance;
                          escrow = availableBalance[m].available;
                          totalBalance = availableBalance[m].trading;
                        }
                      }
                    }
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
                items:chartTime
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
                      priceController.clear();
                      amountController.clear();
                      totalAmount = "0.00";
                    } else if (selectedTime == "Market Order") {
                      priceController.clear();
                      _currentSliderValue = 0;
                      tleverageVal = "1";
                      amountController.clear();
                      totalAmount = "0.00";
                      enableTrade = true;
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
        !enableTrade?Container(
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

                      tradeAmount = "0.00";

                      if (priceController.text.isNotEmpty) {
                        double amount = double.parse(priceController.text);
                        price = priceController.text;

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
        ):Container(),
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
                        } else {
                          tradeAmount = amountController.text;
                          totalAmount = "0.000";
                        }
                      }
                    });
                  },
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.only(bottom: 8.0),
                      hintText: enableTrade
                          ?buySell?"Buy Total":"Amount":"Quantity",
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
            child: spotOption
                ? Slider(
                    value: _currentSliderValue,
                    max: 100,
                    divisions: 4,
                    label: _currentSliderValue.round().toString(),
                    inactiveColor:
                        CustomTheme.of(context).splashColor.withOpacity(0.5),
                    activeColor: buySell
                        ? CustomTheme.of(context).indicatorColor
                        : CustomTheme.of(context).scaffoldBackgroundColor,
                    onChanged: (double value) {
                      setState(() {
                        _currentSliderValue = value;
                        if (_currentSliderValue > 0) {
                          // print(_currentSliderValue.round().toString());
                          int val = _currentSliderValue.toInt();
                          setState(() {
                            if (spotOption) {
                              priceController.clear();
                              amountController.clear();
                            }
                            if (spotOption) {
                              if (!enableTrade) {
                                priceController.text = livePrice;
                              }
                              if (double.parse(livePrice) > 0) {
                                if (buySell) {
                                  double perce =
                                      ((double.parse(balance) * val) /
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
                                  double perce =
                                      (double.parse(balance) * val) / 100;

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
                          if (spotOption) {
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
                : Slider(
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
                          setState(() {
                            if (_currentSliderValue.round().toString() ==
                                "25") {
                              tleverageVal = "1";
                            } else if (_currentSliderValue.round().toString() ==
                                "50") {
                              tleverageVal = "10";
                            } else if (_currentSliderValue.round().toString() ==
                                "75") {
                              tleverageVal = "50";
                            } else if (_currentSliderValue.round().toString() ==
                                "100") {
                              tleverageVal = "75";
                            }
                          });
                          int val = _currentSliderValue.toInt();
                          setState(() {
                            if (spotOption) {
                              priceController.clear();
                              amountController.clear();
                            }
                            if (spotOption) {
                              if (!enableTrade) {
                                priceController.text = livePrice;
                              }
                              if (double.parse(livePrice) > 0) {
                                if (buySell) {
                                  double perce =
                                      ((double.parse(balance) * val) /
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
                                  double perce =
                                      (double.parse(balance) * val) / 100;

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
                          if (spotOption) {
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
                totalAmount + " " + ((buySell ? secondCoin : firstCoin)),
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
              if (marginOption) {
              } else {
                if (selectedTime == "Limit Order") {
                  if (priceController.text.toString().isEmpty) {
                    CustomWidget(context: context)
                        .custombar("H2Crypto", "Enter the Price", false);
                  } else if (amountController.text.toString().isEmpty) {
                    CustomWidget(context: context)
                        .custombar("H2Crypto", "Enter the Amount", false);
                  } else {
                    loading = true;
                    doPostTrade();
                  }
                } else {
                  if (amountController.text.toString().isEmpty) {
                    CustomWidget(context: context)
                        .custombar("H2Crypto", "Enter the Amount", false);
                  } else {
                    loading = true;
                    doPostTrade();
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

  Widget QuickBuy() {
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
                      quickAmountController.clear();

                      quoteID = "";
                      quote = false;
                      totalAmount = "0.0";
                      _currentSliderValue = 0;
                      tleverageVal = "1";

                      QuickfirstCoin = QuickselectPair!.baseAsset.toString();
                      QuicksecondCoin = QuickselectPair!.marketAsset.toString();
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
                          AppLocalizations.instance
                                  .text("loc_sell_trade_txt5") +
                              " " +
                              QuicksecondCoin,
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
                    quickAmountController.clear();

                    totalAmount = "0.0";
                    _currentSliderValue = 0;
                    tleverageVal = "1";
                    quoteID = "";
                    quote = false;

                    QuickfirstCoin = QuickselectPair!.baseAsset.toString();
                    QuicksecondCoin = QuickselectPair!.marketAsset.toString();
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
                        AppLocalizations.instance.text("loc_sell_trade_txt6") +
                            " " +
                            QuickfirstCoin,
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
        const SizedBox(
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
                  controller: quickAmountController,
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
                      totalAmount = "0.00";

                      if (quickAmountController.text.isNotEmpty) {
                        tradeAmount = quickAmountController.text;
                       /* double amount =
                            double.parse(quickAmountController.text);
                        if (amount >= 0) {
                          tradeAmount = quickAmountController.text;

                          totalAmount = (double.parse(
                                      quickAmountController.text.toString()) *
                                  double.parse(QuicklivePrice))
                              .toStringAsFixed(3);
                          print("totalAmount"+totalAmount);
                        } else {
                          tradeAmount = quickAmountController.text;
                          totalAmount = "0.000";
                        }*/
                      } else {
                        tradeAmount = quickAmountController.text;
                        totalAmount = "0.000";
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
              Container(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      buySell ? QuicksecondCoin : QuickfirstCoin,
                      style: CustomWidget(context: context)
                          .CustomSizedTextStyle(
                              10.0,
                              Theme.of(context).splashColor,
                              FontWeight.w500,
                              'FontRegular'),
                    ),
                    const SizedBox(
                      width: 5.0,
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
        const SizedBox(
          height: 15.0,
        ),
        Container(
          child: Row(
            children: [
              /*Flexible(
                child: InkWell(
                  onTap: () {
                    setState(() {
                      if (double.parse(QuicklivePrice) > 0) {
                        double perce = ((double.parse(balance) * 10) /
                                double.parse(livePrice)) /
                            100;

                        quickAmountController.text =
                            double.parse(perce.toString()).toStringAsFixed(4);
                        double a = double.parse(perce
                            .toString()); // this is the value in my first text field (This is the percentage rate i intend to use)
                        double b = double.parse(livePrice);
                        totalAmount =
                            double.parse((a * b).toString()).toStringAsFixed(4);
                      }
                    });
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 10.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6.0),
                      color:
                          Theme.of(context).bottomAppBarColor.withOpacity(0.5),
                    ),
                    child: Center(
                      child: Text(
                        "10%",
                        style: CustomWidget(context: context)
                            .CustomSizedTextStyle(
                                10.0,
                                Theme.of(context).splashColor,
                                FontWeight.w500,
                                'FontRegular'),
                      ),
                    ),
                  ),
                ),
                flex: 1,
              ),
              const SizedBox(
                width: 5.0,
              ),*/
              Flexible(
                child: InkWell(
                  onTap: () {
                    setState(() {
                      val="25%";
                      if (double.parse(QuicklivePrice) > 0) {
                        double perce = ((double.parse(balance) * 25) /
                                double.parse(livePrice)) /
                            100;

                        quickAmountController.text =
                            double.parse(perce.toString()).toStringAsFixed(4);
                        double a = double.parse(perce
                            .toString()); // this is the value in my first text field (This is the percentage rate i intend to use)
                        double b = double.parse(livePrice);
                        totalAmount =
                            double.parse((a * b).toString()).toStringAsFixed(4);
                      }
                    });
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 10.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6.0),
                      color:
                       val=="25%"?Theme.of(context).shadowColor:Theme.of(context).bottomAppBarColor.withOpacity(0.5),
                    ),
                    child: Center(
                      child: Text(
                        "25%",
                        style: CustomWidget(context: context)
                            .CustomSizedTextStyle(
                                10.0,
                                Theme.of(context).splashColor,
                                FontWeight.w500,
                                'FontRegular'),
                      ),
                    ),
                  ),
                ),
                flex: 1,
              ),
              const SizedBox(
                width: 5.0,
              ),
              Flexible(
                child: InkWell(
                  onTap: () {
                    setState(() {
                      val="50%";
                      if (double.parse(QuicklivePrice) > 0) {
                        double perce = ((double.parse(balance) * 50) /
                                double.parse(livePrice)) /
                            100;


                        quickAmountController.text =
                            double.parse(perce.toString()).toStringAsFixed(4);
                        double a = double.parse(perce
                            .toString()); // this is the value in my first text field (This is the percentage rate i intend to use)
                        double b = double.parse(livePrice);
                        totalAmount =
                            double.parse((a * b).toString()).toStringAsFixed(4);
                      }
                    });
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 10.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6.0),
                      color:
                      val=="50%"?Theme.of(context).shadowColor:Theme.of(context).bottomAppBarColor.withOpacity(0.5),
                    ),
                    child: Center(
                      child: Text(
                        "50%",
                        style: CustomWidget(context: context)
                            .CustomSizedTextStyle(
                                10.0,
                                Theme.of(context).splashColor,
                                FontWeight.w500,
                                'FontRegular'),
                      ),
                    ),
                  ),
                ),
                flex: 1,
              ),
              const SizedBox(
                width: 5.0,
              ),
              Flexible(
                child: InkWell(
                  onTap: () {
                    setState(() {
                      val="75%";
                      if (double.parse(QuicklivePrice) > 0) {
                        double perce = ((double.parse(balance) * 75) /
                                double.parse(livePrice)) /
                            100;

                        quickAmountController.text =
                            double.parse(perce.toString()).toStringAsFixed(4);
                        double a = double.parse(perce
                            .toString()); // this is the value in my first text field (This is the percentage rate i intend to use)
                        double b = double.parse(livePrice);
                        totalAmount =
                            double.parse((a * b).toString()).toStringAsFixed(4);
                      }
                    });
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 10.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6.0),
                      color:
                      val=="75%"?Theme.of(context).shadowColor:Theme.of(context).bottomAppBarColor.withOpacity(0.5),
                    ),
                    child: Center(
                      child: Text(
                        "75%",
                        style: CustomWidget(context: context)
                            .CustomSizedTextStyle(
                                10.0,
                                Theme.of(context).splashColor,
                                FontWeight.w500,
                                'FontRegular'),
                      ),
                    ),
                  ),
                ),
                flex: 1,
              ),
              const SizedBox(
                width: 5.0,
              ),
              Flexible(
                child: InkWell(
                  onTap: () {
                    setState(() {
                      val="100%";
                      if (double.parse(QuicklivePrice) > 0) {
                        double perce = ((double.parse(balance) * 100) /
                                double.parse(livePrice)) /
                            100;

                        quickAmountController.text =
                            double.parse(perce.toString()).toStringAsFixed(4);
                        double a = double.parse(perce
                            .toString()); // this is the value in my first text field (This is the percentage rate i intend to use)
                        double b = double.parse(livePrice);
                        totalAmount =
                            double.parse((a * b).toString()).toStringAsFixed(4);
                      }
                    });
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 10.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6.0),
                      color:
                      val=="100%"?Theme.of(context).shadowColor:Theme.of(context).bottomAppBarColor.withOpacity(0.5),
                    ),
                    child: Center(
                      child: Text(
                        "100%",
                        style: CustomWidget(context: context)
                            .CustomSizedTextStyle(
                                10.0,
                                Theme.of(context).splashColor,
                                FontWeight.w500,
                                'FontRegular'),
                      ),
                    ),
                  ),
                ),
                flex: 1,
              )
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
        InkWell(
          onTap: () {
            setState(() {
              if (quote) {
                if (quoteID == "") {
                  CustomWidget(context: context)
                      .custombar("H2Crypto", "Please Get Quote ", false);
                } else {
                  doQuickTrade();
                  loading = true;
                }
              } else {
                dogetQuote();
                loading = true;
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
                  quote
                      ? buySell
                          ? AppLocalizations.instance
                                  .text("loc_sell_trade_txt5") +
                              " Now " +
                              tradeAmount +
                              " " +
                              QuicksecondCoin
                          : AppLocalizations.instance
                                  .text("loc_sell_trade_txt6") +
                              " Now " +
                              tradeAmount +
                              " " +
                              QuickfirstCoin
                      : buySell?"Buy Preview".toUpperCase():"Sell Preview".toUpperCase(),
                  style: CustomWidget(context: context).CustomSizedTextStyle(
                      14.0,
                      Theme.of(context).splashColor,
                      FontWeight.w500,
                      'FontRegular'),
                ),
              )),
        ),
        SizedBox(
          height: 15.0,
        ),
        quote
            ? Center(
                child: Text(
                  AppLocalizations.instance.text("loc_buy") +
                      " Quote Expire In " +
                      _remainingTime.toString() +
                      " Seconds",
                  style: CustomWidget(context: context).CustomSizedTextStyle(
                      10.0,
                      Theme.of(context).splashColor,
                      FontWeight.w500,
                      'FontRegular'),
                ),
              )
            : Container(),
        SizedBox(
          height: 5.0,
        ),
      ],
    );
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
                        // Moment spiritRoverOnMars =
                        //     Moment(openOrders[index].date!).toLocal();
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
                                          openOrders[index].pair.toString(),
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
                                                    "DatE",
                                                    // spiritRoverOnMars
                                                    //     .format(
                                                    //         "YYYY MMMM Do - hh:mm:ssa")
                                                    //     .toString(),
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
                                                        .orderType
                                                        .toString(),
                                                    style: CustomWidget(
                                                            context: context)
                                                        .CustomSizedTextStyle(
                                                            14.0,
                                                            openOrders[index]
                                                                        .orderType
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
          Container(
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
      ),
    );
  }

  Widget HistoryOrdersUI(StateSetter updateState) {
    return SingleChildScrollView(
      child: Column(
        children: [
          historyOrders.length > 0
              ? Container(
                  color: Theme.of(context).backgroundColor,
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.3,
                  child: ListView.builder(
                    itemCount: historyOrders.length,
                    shrinkWrap: true,
                    controller: controller,
                    itemBuilder: (BuildContext context, int index) {
                      // Moment spiritRoverOnMars =
                      //     Moment(openOrders[index].createdAt!).toLocal();
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
                                            .pair
                                            .toString()
                                            .toUpperCase(),
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
                                                  historyOrders[index]
                                                      .date
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
                                                  historyOrders[index]
                                                      .orderType
                                                      .toString(),
                                                  style: CustomWidget(
                                                          context: context)
                                                      .CustomSizedTextStyle(
                                                          14.0,
                                                          historyOrders[index]
                                                                      .orderType
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
                                                              .withOpacity(0.5),
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
                                                  "Filled Amount",
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
                                                  historyOrders[index]
                                                      .filled_amount
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
    apiUtils.getCoinList().then((CoinListModel loginData) {
      if (loginData.success!) {
        setState(() {
          loading = false;
          tradePair = loginData.result!;
          selectPair = tradePair.first;
          searchPair = loginData.result!;

          for (int m = 0; m < tradePair.length; m++) {
            if (tradePair[m].isinstant.toString() == "1") {
              QuicktradePair.add(tradePair[m]);
            }
          }

          QuickselectPair = QuicktradePair.first;
          QuickSearchPair.addAll(QuicktradePair);
          QuickfirstCoin = QuickselectPair!.baseAsset.toString();
          QuicksecondCoin = QuickselectPair!.marketAsset.toString();
          String pair = selectPair!.symbol.toString();
          firstCoin = selectPair!.baseAsset.toString();
          secondCoin = selectPair!.marketAsset.toString();

          var ofeed = "orderbook.net.$pair";
          var tfeed = "private.user.balances";
          var tickerfeed = "ticker.sfox.$pair";
          var orderfeed = "private.user.open-orders";
          var messageJSON = {
            "type": "subscribe",
            "feeds": [ofeed, tfeed, tickerfeed, orderfeed],
          };
          var authMessage = {
            "type": "authenticate",
            "apiKey": token,
          };
          channelOpenOrder!.sink.add(json.encode(authMessage));
          channelOpenOrder!.sink.add(json.encode(messageJSON));

          socketData();
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

  getTradeOrders() {
    apiUtils.getDoneOrdersDetails().then((dynamic loginData) {
      setState(() {
        List<dynamic> listData = loginData;
        for (int m = 0; m < listData.length; m++) {
          historyOrders.add(OpenOrderList(
            id: listData[m]["id"].toString(),
            pair: listData[m]["pair"].toString(),
            fees: listData[m]["fees"].toString(),
            date: listData[m]["dateupdated"].toString(),
            filled: listData[m]["filled"].toString(),
            filled_amount: listData[m]["filled_amount"].toString(),
            orderType: listData[m]["action"].toString(),
            price: listData[m]["price"].toString(),
            userId: listData[m]["client_order_id"].toString(),
            volume: listData[m]["quantity"].toString() == "0"
                ? listData[m]["amount"].toString()
                : listData[m]["quantity"].toString(),
            status: listData[m]["status"].toString(),
          ));
        }
      });
    }).catchError((Object error) {
      print(error);
    });
  }

  doPostTrade() {
    apiUtils
        .doLimitOrder(
            selectPair!.symbol.toString(),
            buySell ? "buy" : "sell",
            selectedTime == "Limit Order" ? "limit" : "market",
            selectedTime == "Limit Order"
                ? amountController.text.toString()
                : "0.00",
            priceController.text.toString(),
            "",
            enableTrade?false:true)
        .then((dynamic loginData) {
      setState(() {
        List<dynamic> listData = loginData;
        for (int m = 0; m < listData.length; m++) {
          historyOrders.add(OpenOrderList(
            id: listData[m]["id"].toString(),
            pair: listData[m]["pair"].toString(),
            fees: listData[m]["fees"].toString(),
            date: listData[m]["dateupdated"].toString(),
            filled: listData[m]["filled"].toString(),
            filled_amount: listData[m]["filled_amount"].toString(),
            orderType: listData[m]["action"].toString(),
            price: listData[m]["price"].toString(),
            userId: listData[m]["client_order_id"].toString(),
            volume: listData[m]["quantity"].toString() == "0"
                ? listData[m]["amount"].toString()
                : listData[m]["quantity"].toString(),
            status: listData[m]["status"].toString(),
          ));
        }
      });
    }).catchError((Object error) {});
  }

  dogetQuote() {
    apiUtils
        .getQuoteDetails(QuickselectPair!.symbol.toString(),
            buySell ? "buy" : "sell", quickAmountController.text.toString())
        .then((QuoteDetailsModel loginData) {
      setState(() {
        if (loginData.success!) {
          quoteID = loginData.result!.quoteId.toString();
          QuicklivePrice=loginData.result!.buyPrice.toString();
          totalAmount = loginData.result!.amount.toString();
          _remainingTime = 10;
          quote = true;
          _startTimer();
          changeColors();
          loading = false;
        } else {
          loading = false;
          CustomWidget(context: context)
              .custombar("H2Crypto", loginData.message.toString(), false);
        }
      });
    }).catchError((Object error) {
      print(error);
    });
  }

  cancelTrade(String id) {
    apiUtils.cancelTradeOption(id).then((CommonModel loginData) {
      setState(() {
        if (loginData.status!) {
          CustomWidget(context: context)
              .custombar("H2Crypto", loginData.message.toString(), true);

          loading = false;
        } else {
          loading = false;
          CustomWidget(context: context)
              .custombar("H2Crypto", loginData.message.toString(), false);
        }
      });
    }).catchError((Object error) {
      print(error);
    });
  }

  doQuickTrade() {
    apiUtils
        .doLimitOrder(
            QuickselectPair!.symbol.toString(),
            buySell ? "buy" : "sell",
            "instant",
            quickAmountController.text.toString(),
            "",
            quoteID,
            false)
        .then((dynamic loginData) {
      setState(() {
        List<dynamic> listData = loginData;
        for (int m = 0; m < listData.length; m++) {
          historyOrders.add(OpenOrderList(
            id: listData[m]["id"].toString(),
            pair: listData[m]["pair"].toString(),
            fees: listData[m]["fees"].toString(),
            date: listData[m]["dateupdated"].toString(),
            filled: listData[m]["filled"].toString(),
            filled_amount: listData[m]["filled_amount"].toString(),
            orderType: listData[m]["action"].toString(),
            price: listData[m]["price"].toString(),
            userId: listData[m]["client_order_id"].toString(),
            volume: listData[m]["quantity"].toString() == "0"
                ? listData[m]["amount"].toString()
                : listData[m]["quantity"].toString(),
            status: listData[m]["status"].toString(),
          ));
        }
      });
    }).catchError((Object error) {});
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
                                  searchPair = [];
                                  for (int m = 0; m < tradePair.length; m++) {
                                    if (tradePair[m]
                                        .symbol
                                        .toString()
                                        .toLowerCase()
                                        .contains(
                                            value.toString().toLowerCase())) {
                                      searchPair.add(tradePair[m]);
                                    }
                                  }
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
                                      Navigator.pop(context);
                                      buyData = [];
                                      sellData = [];

                                      setState(() {
                                        selectPair = tradePair[index];
                                        String pair =
                                            selectPair!.symbol.toString();

                                        firstCoin =
                                            selectPair!.baseAsset.toString();
                                        secondCoin =
                                            selectPair!.marketAsset.toString();
                                        var ofeed = "orderbook.net.$pair";
                                        balance = "0.00";
                                        escrow = "0.00";
                                        totalBalance = "0.00";

                                        var tickerfeed = "ticker.sfox.$pair";
                                        var orderfeed =
                                            "private.user.open-orders";

                                        var authMessage = {
                                          "type": "authenticate",
                                          "apiKey": token,
                                        };
                                        var messageJSON = {
                                          "type": "subscribe",
                                          "feeds": [
                                            ofeed,
                                            tickerfeed,
                                            orderfeed
                                          ],
                                        };
                                        channelOpenOrder!.sink
                                            .add(json.encode(authMessage));
                                        channelOpenOrder!.sink
                                            .add(json.encode(messageJSON));

                                        for (int m = 0;
                                            m < availableBalance.length;
                                            m++) {
                                          if (buySell) {
                                            if (secondCoin.toLowerCase() ==
                                                availableBalance[m]
                                                    .currency
                                                    .toLowerCase()) {
                                              balance =
                                                  availableBalance[m].balance;
                                              escrow =
                                                  availableBalance[m].available;
                                              totalBalance =
                                                  availableBalance[m].trading;
                                            }
                                          } else {
                                            if (firstCoin.toLowerCase() ==
                                                availableBalance[m]
                                                    .currency
                                                    .toLowerCase()) {

                                              balance =
                                                  availableBalance[m].balance;
                                              escrow =
                                                  availableBalance[m].available;
                                              totalBalance =
                                                  availableBalance[m].trading;
                                            }
                                          }
                                        }
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
                                                searchPair[index]
                                                    .baseAsset!
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
                                              .tradePair
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

  showQuickSheeet() {
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
                                  QuickSearchPair = [];
                                  for (int m = 0;
                                      m < QuicktradePair.length;
                                      m++) {
                                    if (QuicktradePair[m]
                                        .symbol
                                        .toString()
                                        .toLowerCase()
                                        .contains(
                                            value.toString().toLowerCase())) {
                                      QuickSearchPair.add(QuicktradePair[m]);
                                    }
                                  }
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
                            itemCount: QuickSearchPair.length,
                            itemBuilder: ((BuildContext context, int index) {
                              return Column(
                                children: [
                                  InkWell(
                                    onTap: () {
                                      Navigator.pop(context);
                                      buyData = [];
                                      sellData = [];

                                      setState(() {
                                        QuickselectPair =
                                            QuickSearchPair[index];
                                        String pair =
                                            QuickselectPair!.symbol.toString();

                                        QuickfirstCoin = QuickselectPair!
                                            .baseAsset
                                            .toString();
                                        QuicksecondCoin = QuickselectPair!
                                            .marketAsset
                                            .toString();
                                        var ofeed = "orderbook.net.$pair";
                                        balance = "0.00";
                                        escrow = "0.00";
                                        totalBalance = "0.00";
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
                                                QuickSearchPair[index]
                                                    .baseAsset!
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
                                          QuickSearchPair[index]
                                              .tradePair
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

class BalanceData {
  String currency;
  String balance;
  String available;
  String trading;

  BalanceData(this.currency, this.balance, this.available, this.trading);
}
