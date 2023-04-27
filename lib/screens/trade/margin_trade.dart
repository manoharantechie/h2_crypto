import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:h2_crypto/common/colors.dart';
import 'package:h2_crypto/common/custom_widget.dart';
import 'package:h2_crypto/common/localization/localizations.dart';
import 'package:h2_crypto/common/theme/custom_theme.dart';
import 'package:h2_crypto/data/api_utils.dart';
import 'package:h2_crypto/data/model/common_model.dart';
import 'package:h2_crypto/data/model/margin_loan_model.dart';
import 'package:h2_crypto/data/model/margin_repay_loan_model.dart';
import 'package:h2_crypto/data/model/margin_trade_model.dart';
import 'package:h2_crypto/data/model/margin_transfer_model.dart';
import 'package:h2_crypto/data/model/open_order_list_model.dart';
import 'package:h2_crypto/data/model/trade_pair_detail_data.dart';
import 'package:h2_crypto/data/model/trade_pair_list_model.dart';
import 'package:h2_crypto/data/model/wallet_bal_model.dart';
import 'package:h2_crypto/data/model/wallet_list_model.dart';
import 'package:h2_crypto/screens/trade/trade.dart';
import 'package:web_socket_channel/io.dart';

class MarginTrade extends StatefulWidget {
  const MarginTrade({Key? key}) : super(key: key);

  @override
  State<MarginTrade> createState() => _MarginTradeState();
}

class _MarginTradeState extends State<MarginTrade> with TickerProviderStateMixin {
  ScrollController controller = ScrollController();
  bool loading = false;
  final _formKey = GlobalKey<FormState>();
  bool buySell = true;
  bool loanErr = false;
  List<OpenOrderList> openOrders = [];
  List<OpenOrderList> AllopenOrders = [];
  List<OpenOrderList> historyOrders = [];
  List<LikeStatus> cheerList = [];
  late TabController _tabController;
  String selectedTime = "";
  List<String> chartTime = ["Limit Order", "Market Order"];
  List<String> transferType = ["Loan", "Spot-Margin", "Margin-Spot"];
  TextEditingController amtController = TextEditingController();
  TextEditingController coinController = TextEditingController();

/*  TextEditingController priceController = TextEditingController();
  TextEditingController amountController = TextEditingController();*/
  TextEditingController marginpriceController = TextEditingController();
  TextEditingController marginamountController = TextEditingController();
  APIUtils apiUtils = APIUtils();
  bool buyOption = true;
  bool sellOption = true;
  final List<String> _decimal = ["0.00000001", "0.0001", "0.01"];
  int decimalIndex = 8;
  bool cancelOrder = false;
  bool marginbuySell = true;
  List<TradePairList> tradePair = [];
  List<TradePairList> searchPair = [];
  TradePairList? selectPair;
  WalletList? selectAsset;
  TextEditingController searchController = TextEditingController();
  FocusNode searchFocus = FocusNode();
  TextEditingController searchAssetController = TextEditingController();
  FocusNode searchAssetFocus = FocusNode();
  bool enableTrade = false;
  bool enableLoan = true;
  String balance = "0.00";
  String escrow = "0.00";
  String totalBalance = "0.00";
  String coinName = "";
  String assetName = "";
  String totalAmount = "0.00";
  String price = "0.00";
  String tradeAmount = "0.00";
  String takerFee = "0.00";
  String takerFeeValue = "0.00";
  double _currentSliderValue = 0;

  bool favValue = false;

  String selectedIndex = "";
  String selectedAssetIndex = "";
  IOWebSocketChannel? channelOpenOrder;
  IOWebSocketChannel? livePriceData;
  List<BuySellData> buyData = [];
  List<BuySellData> sellData = [];
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
  String marginTradeAmount = "0.00";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    selectedTime = chartTime.first;
    selectedMarketOrderType = chartTime.first;
    /*selectedMarginType = marginType.first;*/
    selectedMarginTradeType = transferType.first;
    _tabController = TabController(vsync: this, length: 2);

    selectedDecimal = _decimal.first;
    loading = true;
    getCoinList();
    getLoanCoinList();
    /* channelOpenOrder = IOWebSocketChannel.connect(
        Uri.parse("wss://api.huobi.pro/ws"),
        pingInterval: Duration(seconds: 30));
    livePriceData = IOWebSocketChannel.connect(
        Uri.parse("wss://api.huobi.pro/ws"),
        pingInterval: Duration(seconds: 30));*/
    getAllOpenOrder();
    getAllHistory();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomTheme.of(context).primaryColor,
      body: SingleChildScrollView(
        controller: controller,
        child: Container(
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
              SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(
                      height: 10.0,
                    ),
                    marginUI(),
                  ],
                ),
              ),
              loading
                  ? CustomWidget(context: context)
                      .loadingIndicator(AppColors.whiteColor)
                  : Container()
            ],
          ),
        ),
      ),
    );
  }

  Widget marginUI() {
    return Column(
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
                  ],
                ),
              ),
              Row(
                children: [
                  /* Container(
                    height: 35.0,
                    padding: const EdgeInsets.only(
                        left: 10.0, right: 10.0, top: 0.0, bottom: 0.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5.0),
                      color: CustomTheme.of(context).cardColor,
                    ),
                    child: Theme(
                      data: Theme.of(context).copyWith(
                        canvasColor: CustomTheme.of(context).backgroundColor,
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton(
                          items: marginType
                              .map((value) => DropdownMenuItem(
                            child: Text(
                              value,
                              style: CustomWidget(context: context)
                                  .CustomSizedTextStyle(
                                  12.0,
                                  AppColors.whiteColor,
                                  FontWeight.w500,
                                  'FontRegular'),
                            ),
                            value: value,
                          ))
                              .toList(),
                          onChanged: (value) {
                            setState(() {
                              selectedMarginType = value.toString();

                            });
                          },
                          isExpanded: false,
                          value: selectedMarginType,
                          icon: Icon(
                            Icons.keyboard_arrow_down,
                            color: CustomTheme.of(context).splashColor,
                          ),
                        ),
                      ),
                    ),
                  ),*/
                  GestureDetector(
                    onTap: () {
                      enableLoan = true;
                      loanErr = false;
                      showLoanDialog();
                      coinController.clear();
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
                            .CustomSizedTextStyle(12.0, AppColors.whiteColor,
                                FontWeight.w500, 'FontRegular'),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 5.0,
                  ),
                  GestureDetector(
                    onTap: () {
                      enableLoan = false;
                      showLoanDialog();
                      coinController.clear();
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
                            .CustomSizedTextStyle(12.0, AppColors.whiteColor,
                                FontWeight.w500, 'FontRegular'),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 5.0,
                  ),
                  GestureDetector(
                    onTap: () {
                      enableLoan = true;
                      loanErr = false;
                      transferType[1];
                      showLoanDialog();
                      coinController.clear();
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
                            .CustomSizedTextStyle(12.0, AppColors.whiteColor,
                                FontWeight.w500, 'FontRegular'),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 8.0,
                  ),
                  Container(
                    padding: const EdgeInsets.fromLTRB(3, 0, 3, 0),
                    child: InkWell(
                      onTap: () {
                        // Navigator.push(
                        //     context,
                        //     MaterialPageRoute(
                        //       builder: (context) =>
                        //           ChartScreen(id: selectPair!.id.toString()),
                        //     ));
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
                  Container(
                    padding: const EdgeInsets.fromLTRB(3, 0, 3, 0),
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          //
                          // if(favValue){
                          //   addTOFav(selectPair!.pairSymbol.toString(), "2");
                          //
                          // }
                          // else
                          // {
                          //   addTOFav(selectPair!.pairSymbol.toString(), "1");
                          // }
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
                child: MarginOrderWidget(),
                flex: 1,
              ),
              const SizedBox(
                width: 10.0,
              ),
              Flexible(
                child: MarginmarketWidget(),
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
                      10.0,
                      Theme.of(context).splashColor,
                      FontWeight.bold,
                      'FontRegular'),
                ),
                Text(
                  livePrice + " " + coinName,
                  style: CustomWidget(context: context).CustomSizedTextStyle(
                      11.0,
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
                      10.0,
                      Theme.of(context).hintColor.withOpacity(0.5),
                      FontWeight.w500,
                      'FontRegular'),
                ),
                Text(
                  balance + " " + coinName,
                  style: CustomWidget(context: context).CustomSizedTextStyle(
                      11.0,
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
                  "Locked",
                  style: CustomWidget(context: context).CustomSizedTextStyle(
                      10.0,
                      Theme.of(context).hintColor.withOpacity(0.5),
                      FontWeight.w500,
                      'FontRegular'),
                ),
                Text(
                  escrow + " " + coinName,
                  style: CustomWidget(context: context).CustomSizedTextStyle(
                      11.0,
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
                      10.0,
                      Theme.of(context).hintColor.withOpacity(0.5),
                      FontWeight.w500,
                      'FontRegular'),
                ),
                Text(
                  totalBalance + " " + coinName,
                  style: CustomWidget(context: context).CustomSizedTextStyle(
                      11.0,
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
            showOrders();
          },
          child: Padding(
            padding: const EdgeInsets.only(left: 0.0, right: 0.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Open Orders ( " + openOrders.length.toString() + " )",
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
        openOrdersUIS()
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
              builder: (BuildContext context, StateSetter setState) {
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
                        children: <Widget>[openOrdersUI(), HistoryOrdersUI()],
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
          AllopenOrders.length > 0
              ? Container(
              color: Theme.of(context).backgroundColor,
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.82,
              child: SingleChildScrollView(
                controller: controller,
                child: ListView.builder(
                  itemCount: AllopenOrders.length,
                  shrinkWrap: true,
                  controller: controller,
                  itemBuilder: (BuildContext context, int index) {
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
                                      AllopenOrders[index]
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
                                                        .withOpacity(0.5),
                                                    FontWeight.w400,
                                                    'FontRegular'),
                                              ),
                                              Text(
                                                AllopenOrders[index]
                                                    .createdAt
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
                                                AllopenOrders[index]
                                                    .tradeType
                                                    .toString(),
                                                style: CustomWidget(
                                                    context: context)
                                                    .CustomSizedTextStyle(
                                                    14.0,
                                                    AllopenOrders[index]
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
                                                AllopenOrders[index]
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
                                                AllopenOrders[index]
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
                                                "Amount",
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
                                                AllopenOrders[index]
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
                                                AllopenOrders[index]
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
                                                  AllopenOrders[index]
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
      ),
    );
  }

  Widget HistoryOrdersUI() {
    return SingleChildScrollView(
      child: Column(
        children: [
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
                                                        .withOpacity(0.5),
                                                    FontWeight.w400,
                                                    'FontRegular'),
                                              ),
                                              Text(
                                                historyOrders[index]
                                                    .createdAt
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
                                                "Amount",
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
                                                        .withOpacity(0.5),
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
                                                openOrders[index]
                                                    .createdAt
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
                                                "Amount",
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
                color: Theme.of(context).primaryColor.withOpacity(0.5),
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

  Widget MarginOrderWidget() {
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
                      marginbuySell = true;
                      marginpriceController.clear();
                      marginamountController.clear();
                      totalAmount = "0.0";
                      _currentSliderValue = 0;
                      getCoinDetailsList(selectPair!.id.toString());
                      coinName = selectPair!.baseAsset!.symbol.toString();
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
                          color: marginbuySell
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
                                  marginbuySell
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
                    marginbuySell = false;
                    marginpriceController.clear();
                    marginamountController.clear();
                    totalAmount = "0.0";
                    _currentSliderValue = 0;
                    getCoinDetailsList(selectPair!.id.toString());
                    coinName = selectPair!.baseAsset!.symbol.toString();
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
                        color: !marginbuySell
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
                                !marginbuySell
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
                items: chartTime
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
                    selectedMarketOrderType = value.toString();
                    if (selectedMarketOrderType == "Limit Order") {
                      enableTrade = false;
                      marginpriceController.clear();
                      marginamountController.clear();

                      totalAmount = "0.00";
                    } else {
                      marginpriceController.clear();
                      marginamountController.clear();

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
                value: selectedMarketOrderType,
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
                  controller: marginpriceController,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  style: CustomWidget(context: context).CustomSizedTextStyle(
                      13.0,
                      Theme.of(context).splashColor,
                      FontWeight.w500,
                      'FontRegular'),
                  onChanged: (value) {
                    setState(() {
                      price = "0.0";
                      // price = value.toString();
                      marginTradeAmount = "0.00";

                      if (marginpriceController.text.isNotEmpty) {
                        price = marginpriceController.text;
                        if (marginamountController.text.isNotEmpty) {
                          marginTradeAmount =
                              marginamountController.text.toString();
                          if (!marginbuySell) {
                            takerFee = ((double.parse(marginamountController
                                            .text
                                            .toString()) *
                                        double.parse(marginpriceController.text
                                            .toString()) *
                                        double.parse(
                                            takerFeeValue.toString())) /
                                    100)
                                .toStringAsFixed(4);

                            totalAmount = ((double.parse(marginamountController
                                            .text
                                            .toString()) *
                                        double.parse(marginpriceController.text
                                            .toString())) -
                                    double.parse(takerFee))
                                .toStringAsFixed(4);
                          } else {
                            totalAmount = (double.parse(marginamountController
                                        .text
                                        .toString()) *
                                    double.parse(
                                        marginpriceController.text.toString()))
                                .toStringAsFixed(4);
                          }
                        }
                      } else {
                        marginTradeAmount = "0.00";
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
                      marginTradeAmount = "0.00";
                      if (marginpriceController.text.isNotEmpty) {
                        double amount =
                            double.parse(marginpriceController.text);

                        if (amount > 0) {
                          amount = amount - 0.01;
                          marginpriceController.text =
                              amount.toStringAsFixed(2);
                          price = marginpriceController.text;

                          if (marginamountController.text.isNotEmpty) {
                            marginTradeAmount =
                                marginamountController.text.toString();
                            if (!marginbuySell) {
                              takerFee = ((amount *
                                          double.parse(marginamountController
                                              .text
                                              .toString()) *
                                          double.parse(
                                              takerFeeValue.toString())) /
                                      100)
                                  .toStringAsFixed(4);

                              totalAmount = ((double.parse(
                                              marginamountController.text
                                                  .toString()) *
                                          double.parse(marginpriceController
                                              .text
                                              .toString())) -
                                      double.parse(takerFee))
                                  .toStringAsFixed(4);
                            } else {
                              totalAmount = (double.parse(marginamountController
                                          .text
                                          .toString()) *
                                      double.parse(marginpriceController.text
                                          .toString()))
                                  .toStringAsFixed(4);
                            }
                          } else {
                            totalAmount = "0.00";
                          }
                        } else {
                          price = "0.0";
                          marginpriceController.clear();
                          totalAmount = "0.00";
                        }
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
                      if (marginpriceController.text.isNotEmpty) {
                        double amount =
                            double.parse(marginpriceController.text);
                        if (amount >= 0) {
                          amount = amount + 0.01;
                          marginpriceController.text =
                              amount.toStringAsFixed(2);
                          price = marginpriceController.text;
                          if (marginamountController.text.isNotEmpty) {
                            if (!marginbuySell) {
                              takerFee = ((double.parse(marginamountController
                                              .text
                                              .toString()) *
                                          double.parse(marginpriceController
                                              .text
                                              .toString()) *
                                          double.parse(
                                              takerFeeValue.toString())) /
                                      100)
                                  .toStringAsFixed(4);

                              totalAmount = ((double.parse(
                                              marginamountController.text
                                                  .toString()) *
                                          double.parse(marginpriceController
                                              .text
                                              .toString())) -
                                      double.parse(takerFee))
                                  .toStringAsFixed(4);
                            } else {
                              totalAmount = (double.parse(marginamountController
                                          .text
                                          .toString()) *
                                      double.parse(marginpriceController.text
                                          .toString()))
                                  .toStringAsFixed(4);
                            }
                          } else {
                            // priceController.text = "0.01";
                            marginTradeAmount = "0.00";
                          }
                        }
                      } else {
                        marginpriceController.text = "0.01";
                        marginTradeAmount = "0.00";
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
                  controller: marginamountController,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  style: CustomWidget(context: context).CustomSizedTextStyle(
                      13.0,
                      Theme.of(context).splashColor,
                      FontWeight.w500,
                      'FontRegular'),
                  onChanged: (value) {
                    setState(() {
                      price = "0.0";
                      // price = value.toString();
                      totalAmount = "0.00";

                      if (enableTrade) {
                        if (marginamountController.text.isNotEmpty) {
                          totalAmount = (double.parse(
                                      marginamountController.text.toString()) *
                                  double.parse(livePrice))
                              .toStringAsFixed(4);
                        }
                      } else {
                        if (marginpriceController.text.isNotEmpty) {
                          price = marginpriceController.text;
                          if (marginamountController.text.isNotEmpty) {
                            marginTradeAmount =
                                marginamountController.text.toString();
                            if (!marginbuySell) {
                              takerFee = ((double.parse(marginamountController
                                              .text
                                              .toString()) *
                                          double.parse(marginpriceController
                                              .text
                                              .toString()) *
                                          double.parse(
                                              takerFeeValue.toString())) /
                                      100)
                                  .toStringAsFixed(4);

                              totalAmount = ((double.parse(
                                              marginamountController.text
                                                  .toString()) *
                                          double.parse(marginpriceController
                                              .text
                                              .toString())) -
                                      double.parse(takerFee))
                                  .toStringAsFixed(4);
                            } else {
                              totalAmount = (double.parse(marginamountController
                                          .text
                                          .toString()) *
                                      double.parse(marginpriceController.text
                                          .toString()))
                                  .toStringAsFixed(4);
                            }
                          }
                        } else {
                          marginTradeAmount = "0.00";
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
                    marginTradeAmount = "0.0";
                    totalAmount = "0.0";
                    if (enableTrade) {
                      if (marginamountController.text.isNotEmpty) {
                        double amount =
                            double.parse(marginamountController.text);
                        if (amount > 0) {
                          amount = amount - 0.01;
                          marginamountController.text =
                              amount.toStringAsFixed(2);
                          marginTradeAmount = marginamountController.text;
                          totalAmount = (double.parse(
                                      marginamountController.text.toString()) *
                                  double.parse(livePrice))
                              .toStringAsFixed(4);
                        }
                      } else {
                        totalAmount = "0.00";
                      }
                    } else {
                      if (marginamountController.text.isNotEmpty) {
                        double amount =
                            double.parse(marginamountController.text);
                        if (amount > 0) {
                          amount = amount - 0.01;
                          marginamountController.text =
                              amount.toStringAsFixed(2);
                          marginTradeAmount = marginamountController.text;

                          if (marginpriceController.text.isNotEmpty) {
                            if (!marginbuySell) {
                              takerFee = ((amount *
                                          double.parse(marginpriceController
                                              .text
                                              .toString()) *
                                          double.parse(
                                              takerFeeValue.toString())) /
                                      100)
                                  .toStringAsFixed(4);

                              totalAmount = ((double.parse(
                                              marginamountController.text
                                                  .toString()) *
                                          double.parse(marginpriceController
                                              .text
                                              .toString())) -
                                      double.parse(takerFee))
                                  .toStringAsFixed(4);
                            } else {
                              totalAmount = (double.parse(marginamountController
                                          .text
                                          .toString()) *
                                      double.parse(marginpriceController.text
                                          .toString()))
                                  .toStringAsFixed(4);
                            }
                          }
                        } else {
                          marginamountController.clear();
                          marginTradeAmount = "0.0";
                          totalAmount = "0.0";
                          takerFee = "0.00";
                        }
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
                      if (marginamountController.text.isNotEmpty) {
                        double amount =
                            double.parse(marginamountController.text);
                        if (amount > 0) {
                          amount = amount + 0.01;
                          marginamountController.text =
                              amount.toStringAsFixed(2);
                          marginTradeAmount = marginamountController.text;
                          totalAmount = (double.parse(
                                      marginamountController.text.toString()) *
                                  double.parse(livePrice))
                              .toStringAsFixed(4);
                        }
                      } else {
                        totalAmount = "0.00";
                      }
                    } else {
                      if (marginamountController.text.isNotEmpty) {
                        double amount =
                            double.parse(marginamountController.text);
                        if (amount >= 0) {
                          amount = amount + 0.01;
                          marginamountController.text =
                              amount.toStringAsFixed(2);
                          marginTradeAmount = marginamountController.text;
                          if (marginpriceController.text.isNotEmpty) {
                            if (!marginbuySell) {
                              takerFee = ((amount *
                                          double.parse(marginpriceController
                                              .text
                                              .toString()) *
                                          double.parse(
                                              takerFeeValue.toString())) /
                                      100)
                                  .toStringAsFixed(4);

                              totalAmount = ((double.parse(
                                              marginamountController.text
                                                  .toString()) *
                                          double.parse(marginpriceController
                                              .text
                                              .toString())) -
                                      double.parse(takerFee))
                                  .toStringAsFixed(4);
                            } else {
                              totalAmount = (double.parse(marginamountController
                                          .text
                                          .toString()) *
                                      double.parse(marginpriceController.text
                                          .toString()))
                                  .toStringAsFixed(4);
                            }
                          }
                        }
                      } else {
                        marginamountController.text = "0.01";
                        marginTradeAmount = marginamountController.text;
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
              trackHeight: 10.0,
              activeTickMarkColor: CustomTheme.of(context).splashColor,
              inactiveTickMarkColor:
                  CustomTheme.of(context).splashColor.withOpacity(0.5),
              tickMarkShape: RoundSliderTickMarkShape(tickMarkRadius: 5.0),
              trackShape: CustomTrackShape(),
              thumbShape: RoundSliderThumbShape(enabledThumbRadius: 5),
              overlayShape: RoundSliderOverlayShape(overlayRadius: 28.0),
            ),
            child: Slider(
              value: _currentSliderValue,
              max: 100,
              divisions: 4,
              inactiveColor:
                  CustomTheme.of(context).splashColor.withOpacity(0.5),
              activeColor: marginbuySell
                  ? CustomTheme.of(context).indicatorColor
                  : CustomTheme.of(context).scaffoldBackgroundColor,
              onChanged: (double value) {
                setState(() {
                  _currentSliderValue = value;

                  if (_currentSliderValue > 0) {
                    int val = _currentSliderValue.toInt();
                    setState(() {
                      marginpriceController.clear();
                      marginamountController.clear();
                      marginpriceController.text = livePrice;
                      if (marginbuySell) {
                        double perce = ((double.parse(balance) * val) /
                                double.parse(marginpriceController.text)) /
                            100;

                        marginamountController.text =
                            double.parse(perce.toString()).toStringAsFixed(4);
                        double a = double.parse(perce
                            .toString()); // this is the value in my first text field (This is the percentage rate i intend to use)
                        double b = double.parse(livePrice);
                        totalAmount =
                            double.parse((a * b).toString()).toStringAsFixed(4);
                      } else {
                        double perce = (double.parse(balance) * val) / 100;

                        marginamountController.text =
                            double.parse(perce.toString()).toStringAsFixed(4);
                        double a = double.parse(perce
                            .toString()); // this is the value in my first text field (This is the percentage rate i intend to use)
                        double b = double.parse(livePrice);
                        totalAmount =
                            double.parse((a * b).toString()).toStringAsFixed(4);
                      }
                    });
                  } else {
                    marginamountController.text = "0.00";
                    marginpriceController.text = "0.00";
                    totalAmount = "0.00";
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
                totalAmount + " " + coinName,
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
              if (enableTrade) {
                if (marginamountController.text.isNotEmpty) {
                  if (double.parse(balance) >= double.parse(totalAmount)) {
                    loading = true;
                    if (marginbuySell) {
                      placeMarginOrder(false, "buy-market");
                    } else {
                      placeMarginOrder(false, "sell-market");
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
                if (marginpriceController.text.isNotEmpty) {
                  if (marginamountController.text.isNotEmpty) {
                    if (double.parse(balance) >= double.parse(totalAmount)) {
                      loading = true;
                      if (marginbuySell) {
                        placeMarginOrder(true, "buy");
                      } else {
                        placeMarginOrder(true, "sell");
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
            });
          },
          child: Container(
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5.0),
                color: marginbuySell
                    ? CustomTheme.of(context).indicatorColor
                    : CustomTheme.of(context).scaffoldBackgroundColor,
              ),
              child: Center(
                child: Text(
                  marginbuySell
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
            :  Column(
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
                              Text(
                                double.parse(buyData[index].price.toString())
                                    .toStringAsFixed(decimalIndex),
                                style: CustomWidget(context: context)
                                    .CustomSizedTextStyle(
                                    10.0,
                                    Theme.of(context).indicatorColor,
                                    FontWeight.w500,
                                    'FontRegular'),
                              ),
                              Text(
                                double.parse(buyData[index]
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
        ),
        const SizedBox(
          height: 12.0,
        ),
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
                          ],
                        ),
                        SizedBox(
                          height: 15.0,
                        ),
                        Visibility(
                          visible: enableLoan,
                          child: Container(
                            width: MediaQuery.of(gcontext).size.width,
                            height: 35.0,
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
                                  items: transferType
                                      .map((value) => DropdownMenuItem(
                                            child: Text(
                                              value.toString(),
                                              style:
                                                  CustomWidget(context: context)
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
                                    setState(() {
                                      selectedMarginTradeType =
                                          value.toString();
                                      if (selectedMarginTradeType == "Loan") {
                                        amtController.clear();
                                      } else if (selectedMarginTradeType ==
                                          "Spot-Margin") {
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
                          child: Container(
                            padding: EdgeInsets.fromLTRB(5.0, 0.0, 0.0, 0.0),
                            decoration: BoxDecoration(
                              /* border: Border.all(
                                      color: enableTrade? Theme.of(context).hintColor.withOpacity(0.1):CustomTheme.of(context).hintColor.withOpacity(0.5),
                                      width: 1.0),
                                  borderRadius: BorderRadius.circular(5.0),*/
                              color: Colors.transparent,
                            ),
                            child: TextFormField(
                              enabled: true,
                              controller: amtController,
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
                                    vertical: 10.0, horizontal: 10.0),
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
                        ),
                        SizedBox(
                          height: 15.0,
                        ),
                        InkWell(
                          onTap: () {
                            print("Loan" + enableLoan.toString());
                            if (_formKey.currentState!.validate()) {
                              if (enableLoan) {
                                if (amtController.text.isNotEmpty) {
                                  Navigator.pop(context);
                                  if (selectedMarginTradeType == "Loan") {
                                    ssetState(() {
                                      loading = true;
                                    });
                                    marginLoan(
                                        selectedAssetIndex, amtController.text,"1");
                                  } else if (selectedMarginTradeType ==
                                      "Spot-Margin") {
                                    ssetState(() {
                                      loading = true;
                                    });
                                    transferSpottoMargin(
                                        selectedAssetIndex, amtController.text,"1");
                                  } else {
                                    ssetState(() {
                                      loading = true;
                                    });
                                    transferMargintoSpot(
                                        selectedAssetIndex, amtController.text,"1");
                                  }
                                }
                              } else {
                                Navigator.pop(context);
                                ssetState(() {
                                  loading = true;
                                });
                                repayLoan(selectedAssetIndex);
                              }
                            } else {
                              /*ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                    content: Text('Enter the amount'),
                                    behavior: SnackBarBehavior.floating,
                                  ));*/
                              CustomWidget(context: gcontext)
                                  .custombar("Loan", "Enter the amount", false);
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
                                    sellData = [];
                                    searchPair = [];
                                    openOrders = [];

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

                                    /*socketData();
                                    socketLivepriceData();*/
                                    getAllOpenOrder();
                                    getOpenOrder();
                                    getAllHistory();
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
                            shrinkWrap: true,
                            itemCount: searchPair.length,
                            itemBuilder: ((BuildContext context, int index) {
                              return Column(
                                children: [
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        selectPair = searchPair[index];
                                        selectedIndex =
                                            selectPair!.id.toString();
                                        marginpriceController.clear();
                                        marginamountController.clear();
                                        totalAmount = "0.00";
                                        _currentSliderValue = 0;
                                        coinName = selectPair!.baseAsset!.symbol
                                            .toString();
                                        getCoinDetailsList(
                                            selectPair!.id.toString());
                                        // loading = true;
                                        firstCoin = selectPair!
                                            .baseAsset!.symbol
                                            .toString();
                                        secondCoin = selectPair!
                                            .marketAsset!.symbol
                                            .toString();

                                        // livePriceData!.sink.close();

                                        var messageJSON = {
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

                                        /* channelOpenOrder!.sink
                                            .add(json.encode(messageJSON));
                                        channelOpenOrder = IOWebSocketChannel.connect(
                                            Uri.parse("wss://api.huobi.pro/ws"),
                                            pingInterval: Duration(seconds: 30));
                                        livePriceData =
                                            IOWebSocketChannel.connect(
                                                Uri.parse(
                                                    "wss://api.huobi.pro/ws"),
                                                pingInterval:
                                                Duration(seconds: 30));
                                        livePriceData!.sink
                                            .add(json.encode(messageLiveJSON));*/
                                        /*socketLivepriceData();*/
                                        // getAllOpenOrder();
                                        // getOpenOrder();
                                        // getAllHistory();
                                        // checkFav(selectPair!.id.toString());
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
                                    buyData = [];
                                    sellData = [];
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

                                    /* socketData();
                                    socketLivepriceData();*/
                                    getAllOpenOrder();
                                    getOpenOrder();
                                    getAllHistory();
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
                                searchAssetController.clear();
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
                                        print("Index" + selectedAssetIndex);
                                        marginpriceController.clear();
                                        marginamountController.clear();
                                        totalAmount = "0.00";
                                        _currentSliderValue = 0;
                                        assetName = selectAsset!.asset!.symbol
                                            .toString();
                                        coinController.text = selectAsset!
                                            .asset!.symbol
                                            .toString();
                                        getCoinDetailsList(
                                            selectPair!.id.toString());
                                        // loading = true;
                                        firstCoin = selectPair!
                                            .baseAsset!.symbol
                                            .toString();
                                        secondCoin = selectPair!
                                            .marketAsset!.symbol
                                            .toString();

                                        // livePriceData!.sink.close();

                                        var messageJSON = {
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

                                        //  channelOpenOrder!.sink
                                        //      .add(json.encode(messageJSON));
                                        //  channelOpenOrder = IOWebSocketChannel.connect(
                                        //      Uri.parse("wss://api.huobi.pro/ws"),
                                        //      pingInterval: Duration(seconds: 30));
                                        //  livePriceData =
                                        //      IOWebSocketChannel.connect(
                                        //          Uri.parse(
                                        //              "wss://api.huobi.pro/ws"),
                                        //          pingInterval:
                                        //          Duration(seconds: 30));
                                        //  livePriceData!.sink
                                        //      .add(json.encode(messageLiveJSON));
                                        // /* socketLivepriceData();*/
                                        //  getAllOpenOrder();
                                        //  getOpenOrder();
                                        //  getAllHistory();
                                        checkFav(selectPair!.id.toString());
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

  placeMarginOrder(bool check, String type) {
    print("Pairtra" + selectPair!.id.toString());
    apiUtils
        .doMarginPostTrade(
            false,
            selectPair!.id.toString(),
            marginpriceController.text.toString(),
            marginamountController.text.toString(),
            type,
            check,"1","")
        .then((MarginTradeModel loginData) {
      if (loginData.statusCode == 200) {
        setState(() {
          loading = false;
          loading = true;
          marginpriceController.clear();
          marginamountController.clear();
          totalAmount = "0.00";
          _currentSliderValue = 0;
          getAllHistory();
          getOpenOrder();
          getAllOpenOrder();
          getCoinDetailsList(selectPair!.id.toString());

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

  getCoinList() {
    apiUtils.getTradePair().then((TradePairListModel loginData) {
      if (loginData.statusCode == 200) {
        setState(() {
          tradePair = loginData.data!;
          // tradePair = tradePair.reversed.toList();
          // searchPair = tradePair.reversed.toList();
          searchPair = tradePair;
          selectPair = tradePair[0];
          coinName = selectPair!.baseAsset!.symbol.toString();
          takerFeeValue = buySell
              ? selectPair!.buyTradeCommission.toString()
              : selectPair!.sellTradeCommission.toString();

          firstCoin = selectPair!.baseAsset!.symbol.toString();
          secondCoin = selectPair!.marketAsset!.symbol.toString();
          print(selectPair!.marketWallet!.id);
          getOpenOrder();
          getCoinDetailsList(selectPair!.id.toString());
          selectedIndex = selectPair!.id.toString();

          for (int m = 0; m < tradePair.length; m++) {
            cheerList.add(LikeStatus(
              tradePair[m].id.toString(),
              tradePair[m].favorite!,
            ));
          }

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
          takerFeeValue = buySell
              ? selectPair!.buyTradeCommission.toString()
              : selectPair!.sellTradeCommission.toString();

          firstCoin = selectPair!.baseAsset!.symbol.toString();
          secondCoin = selectPair!.marketAsset!.symbol.toString();

          getBalance(marginbuySell
              ? selectPair!.marketWallet!.id.toString()
              : selectPair!.baseWallet!.id.toString());

          var messageJSON = {
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
          /*socketData();
          socketLivepriceData();*/
          getOpenOrder();

          selectedIndex = selectPair!.id.toString();

          for (int m = 0; m < tradePair.length; m++) {
            cheerList.add(LikeStatus(
              tradePair[m].id.toString(),
              tradePair[m].favorite!,
            ));
          }

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
          print("Crypto" + cryptoList.toString());
          for (int i = 0; i < cryptoList.length; i++) {
            if (cryptoList[i].asset!.type == "coin") {
              coinList.add(cryptoList[i]);
              searchAssetPair = coinList;
            }
          }
        });
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

  marginLoan(
    String wallet_id,
    String loan_amount,
    String loan_mode,
  ) {
    apiUtils.doMarginLoan(wallet_id, loan_amount,loan_mode).then((LoanModel loginData) {
      if (loginData.statusCode == 200) {
        setState(() {
          loading = false;
          amtController.clear();
          searchAssetController.clear();
          searchAssetController.text = "";
          amtController.text = "";
          CustomWidget(context: context)
              .custombar("Margin", loginData.message.toString(), true);
        });
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

  repayLoan(String wallet_id) {
    print("Helo");
    apiUtils.doMarginRepayLoan(wallet_id,"",buySell?"1":"2").then((RepayLoanModel loginData) {
      if (loginData.statusCode == 200) {
        setState(() {
          loading = false;
          searchAssetController.clear();
          searchAssetController.text = "";
          CustomWidget(context: context)
              .custombar("Margin", loginData.message.toString(), true);
        });
      } else {
        setState(() {
          loading = false;
          CustomWidget(context: context)
              .custombar("Margin", loginData.message.toString(), false);
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
        .doTransferMargin(wallet_id, bal,loan_mode)
        .then((MarginTransferModel loginData) {
      if (loginData.statusCode == 200) {
        setState(() {
          loading = false;
          amtController.clear();
          amtController.text = "";
          searchAssetController.clear();
          searchAssetController.text = "";
          CustomWidget(context: context)
              .custombar("Margin", loginData.message.toString(), true);
        });
      } else {
        setState(() {
          loading = false;
          CustomWidget(context: context)
              .custombar("Margin", loginData.message.toString(), false);
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
        .doTransferSpot(wallet_id, bal,loan_mode)
        .then((MarginTransferModel loginData) {
      if (loginData.statusCode == 200) {
        setState(() {
          loading = false;
          amtController.clear();
          amtController.text = "";
          searchAssetController.clear();
          searchAssetController.text = "";
          CustomWidget(context: context)
              .custombar("Margin", loginData.message.toString(), true);
        });
      } else {
        setState(() {
          loading = false;
          CustomWidget(context: context)
              .custombar("Margin", loginData.message.toString(), false);
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
    print(marginbuySell
        ? selectPair!.marketWallet!.id.toString()
        : selectPair!.baseWallet!.id.toString());
    apiUtils.getBalance(coin).then((WalletBalanceModel loginData) {
      if (loginData.statusCode == 200) {
        setState(() {
          loading = false;

          balance = double.parse(loginData.data!.marginBalance.toString())
              .toStringAsFixed(4);
          escrow = double.parse(loginData.data!.marginEscrowBalance!.toString())
              .toStringAsFixed(4);
          totalBalance =
              (double.parse(balance) + double.parse(escrow)).toStringAsFixed(4);
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

  getOpenOrder() {
    apiUtils
        .openOrderList(selectPair!.id.toString())
        .then((OpenOrderListModel loginData) {
      if (loginData.statusCode == 200) {
        setState(() {
          // loading = false;
          openOrders = [];
          openOrders = loginData.data!;
          for(int i=0;i<openOrders.length;i++){
            if(selectedIndex==openOrders[i].tradePairId){
              if(openOrders[i].tradeType=="buy"){
                buyData.add(BuySellData(
                  openOrders[i].price.toString(),
                  openOrders[i].volume.toString(),
                ));
              }else if(openOrders[i].tradeType=="sell") {
                sellData.add(BuySellData(
                  openOrders[i].price.toString(),
                  openOrders[i].volume.toString(),
                ));
              }
            }
          }
          print("Sell"+ sellData.length.toString());
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

  updatecancelOrder(String id) {
    apiUtils.cancelTrade(id).then((CommonModel loginData) {
      if (loginData.status == 200) {
        CustomWidget(context: context)
            .custombar("Cancel", loginData.message.toString(), true);
        setState(() {
          loading = false;
          openOrders=[];
          getOpenOrder();
          getAllOpenOrder();
          getAllHistory();
        });

      } else {
        setState(() {
          AllopenOrders = [];
          loading = false;
        });
      }
    }).catchError((Object error) {
      print("Can"+error.toString());
      setState(() {
        loading = false;
      });
    });
  }

  getAllHistory() {
    apiUtils.AllopenOrderList(true).then((OpenOrderListModel loginData) {
      if (loginData.statusCode == 200) {
        setState(() {
          //  loading = false;
          historyOrders = [];
          historyOrders = loginData.data!;
          historyOrders = historyOrders.reversed.toList();
        });
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
}
