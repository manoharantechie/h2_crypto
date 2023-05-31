import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:h2_crypto/common/bottom_nav.dart';
import 'package:h2_crypto/common/custom_widget.dart';
import 'package:h2_crypto/common/localization/localizations.dart';
import 'package:h2_crypto/common/theme/custom_theme.dart';
import 'package:h2_crypto/data/api_utils.dart';
import 'package:h2_crypto/data/crypt_model/coin_list.dart';
import 'package:h2_crypto/data/crypt_model/market_list_model.dart';
import 'package:h2_crypto/data/crypt_model/new_socket_data.dart';
import 'package:h2_crypto/data/crypt_model/user_wallet_balance_model.dart';

import 'package:h2_crypto/screens/basic/side_menu.dart';

import 'package:h2_crypto/screens/side_menu/others/notify_screen.dart';
import 'package:h2_crypto/screens/side_menu/others/support_list.dart';
import 'package:h2_crypto/screens/trade/market_screen.dart';
import 'package:h2_crypto/screens/trade/trade.dart';
import 'package:h2_crypto/screens/wallet/transaction_history.dart';
import 'package:h2_crypto/screens/wallet/wallet.dart';
import 'package:h2_crypto/screens/wallet/withdraw.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:web_socket_channel/io.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home>
    with WidgetsBindingObserver, SingleTickerProviderStateMixin {
  final PageStorageBucket bucket = PageStorageBucket();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  PageStorageKey? _pagekey;
  ScrollController controller = ScrollController();
  ScrollController _scrollController = ScrollController();
  APIUtils apiUtils = APIUtils();
  int? currentIndex;
  int? selectIndex;

  List<MarketListModel> marketList = [];
  List<String> bannerList = [];

  bool unSelected = true;

  late Widget screen = Container();
  late Widget _page2;
  late Widget _page3;
  bool loading = false;
  late Widget _page4;
  late Widget _page5;
  late TabController _tabController;
  List<Widget> bottomPage = [];
  bool dashView = false;
  int slideIndex = 0;
  List<BottomNavItem>? _bottomItems;
  List<UserWalletResult> coinList = [];

  List<CoinList> tradePairList = [];

  IOWebSocketChannel? channelOpenOrder;
  List arrData = [];
  List grid_name = ["Withdraw", "Exchange", "Market", "Support"];

  List grid_img = [
    "assets/bottom/wallet.svg",
    "assets/images/transfer.svg",
    "assets/bottom/market.svg",
    "assets/sidemenu/support.svg"
  ];

  void onSelectItem(int index) async {
    setState(() {
      selectIndex = index;
      if (index == 0) {
        dashView = true;
      } else {
        dashView = false;
        currentIndex = index;
        screen = bottomPage[index - 1];
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    currentIndex = 0;
    selectIndex = 0;

    channelOpenOrder = IOWebSocketChannel.connect(
        Uri.parse("wss://ws.sfox.com/ws"),
        pingInterval: Duration(seconds: 30));
    bottomPage = [
      MarketSceen(),
      TradeScreen(),
      TransactionHistory(),
      WalletScreen()
    ];
    dashView = true;
    _bottomItems = createBottomItems();
    loading = true;

    loading = true;

    getCoinList();
    getPairList();

    _tabController = TabController(vsync: this, length: 3);
  }

  socketData() {
    channelOpenOrder!.stream.listen(
      (data) {
        if (data != null || data != "null") {
          var decode = jsonDecode(data);

          if (mounted) {
            setState(() {
              NewSocketData ss = NewSocketData.fromJson(decode);
              for (int m = 0; m < tradePairList.length; m++) {
                if (tradePairList[m].symbol.toString().toLowerCase() ==
                    ss.payload.pair.toString().toLowerCase()) {
                  double open = double.parse(ss.payload.open.toString());
                  double close = double.parse(ss.payload.last.toString());
                  double data = ((close - open) / open) * 100;
                  tradePairList[m].hrExchange = data.toString();
                  tradePairList[m].currentPrice =
                      double.parse(ss.payload.last.toString()).toString();
                  tradePairList[m].hrVolume =
                      double.parse(ss.payload.volume.toString()).toString();
                }
              }
            });
          }

          // print("Mano");
        }
      },
      onDone: () async {
        await Future.delayed(Duration(seconds: 10));
        var messageJSON = {
          "type": "subscribe",
          "feeds": arrData,
        };

        channelOpenOrder = IOWebSocketChannel.connect(
            Uri.parse("wss://ws.sfox.com/ws"),
            pingInterval: Duration(seconds: 30));

        channelOpenOrder!.sink.add(json.encode(messageJSON));
        channelOpenOrder!.sink.add(json.encode(messageJSON));
        socketData();
      },
      onError: (error) => print("Err" + error),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return showSuccesssAlertDialog();
      },
      child: Scaffold(
        backgroundColor: CustomTheme.of(context).primaryColor,
        key: _scaffoldKey,
        appBar: currentIndex == 0
            ? AppBar(
                backgroundColor: CustomTheme.of(context).primaryColor,
                elevation: 0.0,
                title: Image.asset(
                  'assets/icon/logo.png',
                  height: 35.0,
                ),
                centerTitle: true,
                leading: InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SideMenu(),
                          ));
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                      child: SvgPicture.asset(
                        'assets/others/menu.svg',
                        height: 15.0,
                        color: CustomTheme.of(context).shadowColor,
                      ),
                    )),
                actions: [
                  InkWell(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => NotifyScreen(),
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                        child: SvgPicture.asset(
                          'assets/others/notify.svg',
                          height: 15.0,
                          color: CustomTheme.of(context).shadowColor,
                        ),
                      ))
                ],
              )
            : PreferredSize(
                child: Container(), preferredSize: const Size(10.0, 0.0)),
        body: Container(
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
                CustomTheme.of(context).dialogBackgroundColor,
              ])),
          child: Stack(
            children: [
              // PageStorage(child: assetsUI(), bucket: bucket),
              PageStorage(
                  child: dashView ? DashBoard() : screen, bucket: bucket),
            ],
          ),
        ),
        //
        // bottomNavigationBar: SizedBox(
        //     height: 70.0,
        //     child: Container(
        //       decoration: BoxDecoration(
        //         color: CustomTheme.of(context).shadowColor,
        //       ),
        //       child: Container(
        //         margin: const EdgeInsets.only(left: 5.0, right: 5.0, bottom: 5.0),
        //         decoration: BoxDecoration(
        //           color: CustomTheme.of(context).shadowColor,
        //         ),
        //         child: BottomNavigationBar(
        //           elevation: 0.0,
        //
        //           type: BottomNavigationBarType.fixed,
        //           //
        //           items: bottomItems(),
        //           currentIndex: currentIndex,
        //           showSelectedLabels: true,
        //           backgroundColor:currentIndex==selectIndex? CustomTheme.of(context).shadowColor: CustomTheme.of(context).bottomAppBarColor,
        //           selectedLabelStyle: !unSelected
        //               ? CustomWidget(context: context).CustomSizedTextStyle(
        //                   12.0,
        //                   Theme.of(context).splashColor.withOpacity(0.5),
        //                   FontWeight.normal,
        //                   'FontRegular')
        //               : CustomWidget(context: context).CustomSizedTextStyle(
        //                   12.0,
        //                   Theme.of(context).splashColor,
        //                   FontWeight.normal,
        //                   'FontRegular'),
        //           selectedItemColor: CustomTheme.of(context).splashColor,
        //           unselectedItemColor:
        //               CustomTheme.of(context).splashColor.withOpacity(0.5),
        //           showUnselectedLabels: true,
        //           onTap: (index) {
        //             setState(() {
        //               onSelectItem(index);
        //               currentIndex = index;
        //               selectIndex=index;
        //             });
        //           },
        //         ),
        //       ),
        //     )),
        bottomNavigationBar: BottomNav(
          index: currentIndex,
          selectedIndex: selectIndex,
          elevation: 10.0,
          color: CustomTheme.of(context).bottomAppBarColor,
          iconStyle: IconStyle(
            color: CustomTheme.of(context).splashColor.withOpacity(0.5),
            onSelectColor: CustomTheme.of(context).splashColor,
            size: 25.0,
          ),
          bgStyle: BgStyle(
            color: CustomTheme.of(context).bottomAppBarColor.withOpacity(0.5),
            onSelectColor: CustomTheme.of(context).shadowColor,
          ),
          labelStyle: LabelStyle(
            visible: true,
            textStyle: CustomWidget(context: context).CustomTextStyle(
                Theme.of(context).splashColor.withOpacity(0.5),
                FontWeight.normal,
                'FontRegular'),
            onSelectTextStyle: CustomWidget(context: context).CustomTextStyle(
                Theme.of(context).splashColor,
                FontWeight.normal,
                'FontRegular'),
          ),
          onTap: (i) {
            setState(() {
              onSelectItem(i);
              currentIndex = i;
            });
          },
          items: _bottomItems,
        ),
      ),
    );
  }

  showSuccesssAlertDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0)), //this right here
            child: Container(
              decoration: new BoxDecoration(
                  color: CustomTheme.of(context).splashColor,
                  borderRadius: BorderRadius.circular(5.0)),
              height: MediaQuery.of(context).size.height * 0.24,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Are you sure?".toUpperCase(),
                      style: CustomWidget(context: context)
                          .CustomSizedTextStyle(
                              16.0,
                              Theme.of(context).shadowColor,
                              FontWeight.bold,
                              'FontRegular'),
                    ),
                    Container(
                        margin: EdgeInsets.only(top: 7.0, bottom: 10.0),
                        height: 2.0,
                        color: CustomTheme.of(context).shadowColor),
                    Text(
                      "Do you want to exit an App",
                      style: CustomWidget(context: context)
                          .CustomSizedTextStyle(
                              16.0,
                              Theme.of(context).shadowColor,
                              FontWeight.w500,
                              'FontRegular'),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Row(
                      children: [
                        SizedBox(
                          child: InkWell(
                            child: Container(
                              width: 100,
                              height: 40,
                              margin: const EdgeInsets.fromLTRB(
                                  10.0, 10.0, 10.0, 0.0),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                    colors: [
                                      CustomTheme.of(context).shadowColor,
                                      CustomTheme.of(context).shadowColor
                                    ],
                                    begin: Alignment.topRight,
                                    end: Alignment.bottomLeft,
                                    stops: [0.0, 1.0],
                                    tileMode: TileMode.clamp),
                                borderRadius: BorderRadius.circular(25),
                              ),
                              child: Align(
                                alignment: Alignment.center,
                                child: Text(
                                  "ok".toUpperCase(),
                                  style: CustomWidget(context: context)
                                      .CustomSizedTextStyle(
                                          15.0,
                                          Theme.of(context).splashColor,
                                          FontWeight.w500,
                                          'FontRegular'),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                            onTap: () {
                              SystemNavigator.pop();
                            },
                          ),
                        ),
                        SizedBox(
                          child: InkWell(
                            child: Container(
                              width: 100,
                              height: 40,
                              margin: const EdgeInsets.fromLTRB(
                                  10.0, 10.0, 10.0, 0.0),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                    colors: [
                                      CustomTheme.of(context).shadowColor,
                                      CustomTheme.of(context).shadowColor,
                                    ],
                                    begin: Alignment.topRight,
                                    end: Alignment.bottomLeft,
                                    stops: [0.0, 1.0],
                                    tileMode: TileMode.clamp),
                                borderRadius: BorderRadius.circular(25),
                              ),
                              child: Align(
                                alignment: Alignment.center,
                                child: Text(
                                  "Cancel".toUpperCase(),
                                  style: CustomWidget(context: context)
                                      .CustomSizedTextStyle(
                                          15.0,
                                          Theme.of(context).splashColor,
                                          FontWeight.w500,
                                          'FontRegular'),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        )
                      ],
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                    )
                  ],
                ),
              ),
            ),
          );
        });
    // show the dialog
  }

  Widget DashBoard() {
    return Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.only(left: 10.0, right: 10.0),
        child: SingleChildScrollView(
          child: loading
              ? CustomWidget(context: context).loadingIndicator(
                  CustomTheme.of(context).splashColor,
                )
              : Column(
                  children: [
                    const SizedBox(
                      height: 10.0,
                    ),

                    const SizedBox(
                      height: 10.0,
                    ),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: indicators(bannerList.length, slideIndex)),
                    /*const SizedBox(
                      height: 10.0,
                    ),
                    Row(
                      children: [
                        SvgPicture.asset(
                          'assets/others/speaker.svg',
                          color: CustomTheme.of(context).shadowColor,
                        ),
                        const SizedBox(
                          width: 10.0,
                        ),
                        Flexible(
                          child: Text(
                            "H2Crypto launches JOE/USDT on margin trading ",
                            style: TextStyle(
                              color: CustomTheme.of(context).splashColor,
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 10.0,
                        ),
                        SvgPicture.asset(
                          'assets/others/print.svg',
                        ),
                      ],
                    ),*/
                    const SizedBox(
                      height: 10.0,
                    ),
                    marketList.isNotEmpty
                        ? Container(
                            height: 85,
                            padding:
                                const EdgeInsets.only(top: 10.0, left: 10.0),
                            decoration: BoxDecoration(
                                color: CustomTheme.of(context)
                                    .shadowColor
                                    .withOpacity(0.2),
                                borderRadius: BorderRadius.circular(5)),
                            child: Center(
                              child: ListView.builder(
                                itemCount: marketList.length,
                                scrollDirection: Axis.horizontal,
                                shrinkWrap: true,
                                controller: controller,
                                itemBuilder: (BuildContext context, int index) {
                                  double open = double.parse(marketList[index]
                                      .tick!['open']
                                      .toString());
                                  double close = double.parse(marketList[index]
                                      .tick!['close']
                                      .toString());
                                  double data = (open - close) / 100;
                                  return GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        currentIndex = 1;
                                        dashView = false;
                                        onSelectItem(2);
                                      });
                                    },
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const SizedBox(
                                          height: 5.0,
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Text(
                                                  marketList[index]
                                                      .pair
                                                      .toString(),
                                                  style: CustomWidget(
                                                          context: context)
                                                      .CustomSizedTextStyle(
                                                          14.0,
                                                          Theme.of(context)
                                                              .splashColor
                                                              .withOpacity(0.5),
                                                          FontWeight.w500,
                                                          'FontRegular'),
                                                ),
                                                const SizedBox(
                                                  width: 3.0,
                                                ),
                                                Text(
                                                  data.toStringAsFixed(2),
                                                  style: CustomWidget(
                                                          context: context)
                                                      .CustomSizedTextStyle(
                                                          12.0,
                                                          double.parse(data
                                                                      .toString()) >=
                                                                  0
                                                              ? Theme.of(
                                                                      context)
                                                                  .indicatorColor
                                                              : Theme.of(
                                                                      context)
                                                                  .canvasColor,
                                                          FontWeight.w600,
                                                          'FontRegular'),
                                                  textAlign: TextAlign.start,
                                                ),
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 5.0,
                                            ),
                                            Text(
                                              double.parse(marketList[index]
                                                      .tick!['lastPrice']
                                                      .toString())
                                                  .toStringAsFixed(8),
                                              style:
                                                  CustomWidget(context: context)
                                                      .CustomSizedTextStyle(
                                                          14.0,
                                                          Color(0xFFDD2942),
                                                          FontWeight.w600,
                                                          'FontRegular'),
                                            ),
                                            const SizedBox(
                                              height: 5.0,
                                            ),
                                            Text(
                                              "\$ " +
                                                  double.parse(marketList[index]
                                                          .tick!['lastPrice']
                                                          .toString())
                                                      .toStringAsFixed(8),
                                              style:
                                                  CustomWidget(context: context)
                                                      .CustomSizedTextStyle(
                                                          14.0,
                                                          Theme.of(context)
                                                              .splashColor,
                                                          FontWeight.w400,
                                                          'FontRegular'),
                                              textAlign: TextAlign.start,
                                            ),
                                          ],
                                        ),
                                        const SizedBox(
                                          width: 20.0,
                                        )
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ))
                        : Container(),
                    const SizedBox(
                      height: 10.0,
                    ),
                    Image.asset(
                      'assets/others/banner.png',
                      fit: BoxFit.fitHeight,
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),

                    Container(
                      child: GridView.builder(
                        padding: EdgeInsets.zero,
                        controller: _scrollController,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 4,
                          crossAxisSpacing: 20,
                          mainAxisSpacing: 20,
                        ),
                        // physics: ScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: grid_name.length,
                        itemBuilder: (BuildContext context, index) {
                          return InkWell(
                            onTap: () {
                              if (index == 0) {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => WithDraw(
                                        id: "0",
                                        coinList: coinList,
                                      ),
                                    ));
                              } else if (index == 1) {
                                onSelectItem(2);
                              } else if (index == 2) {
                                onSelectItem(1);
                              }else{
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => SupportTicketList(),
                                    ));
                              }
                            },
                            child: Container(
                                // padding: EdgeInsets.only(
                                //     top: 5.0,
                                //     bottom: 5.0,
                                //     right: 12.0,
                                //     left: 12.0),
                                decoration: BoxDecoration(
                                  // color: Theme.of(context).focusColor,
                                  border: Border.all(
                                      width: 1.0,
                                      color: Theme.of(context)
                                          .splashColor
                                          .withOpacity(0.5)),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                alignment: Alignment.center,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SvgPicture.asset(
                                      grid_img[index].toString(),
                                      height: 25.0,
                                      color: Theme.of(context).shadowColor,
                                    ),
                                    SizedBox(
                                      height: 10.0,
                                    ),
                                    Text(
                                      // AppLocalizations.instance.text("loc_widthdraw"),
                                      grid_name[index].toString(),
                                      style: CustomWidget(context: context)
                                          .CustomSizedTextStyle(
                                              12.0,
                                              Theme.of(context).splashColor,
                                              FontWeight.w500,
                                              'FontRegular'),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                )),
                          );
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Top Cryptocurency",
                          style: CustomWidget(context: context)
                              .CustomSizedTextStyle(
                                  15.0,
                                  Theme.of(context).splashColor,
                                  FontWeight.w500,
                                  'FontRegular'),
                          textAlign: TextAlign.center,
                        ),
                        Column(
                          children: [
                            InkWell(
                              onTap: (){

                              },
                              child: Text(
                                "See All",
                                style: CustomWidget(context: context)
                                    .CustomSizedTextStyle(
                                        12.0,
                                        Theme.of(context).shadowColor,
                                        FontWeight.w500,
                                        'FontRegular'),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            const SizedBox(
                              height: 3.0,
                            ),
                            Container(
                              width: 50,
                              height: 1.0,
                              decoration: BoxDecoration(
                                  color: Theme.of(context).primaryColor),
                            )
                          ],
                        )
                      ],
                    ),

                    SizedBox(
                      height: 20.0,
                    ),

                    // coinList.length > 0
                    //     ? Container(
                    //     width: MediaQuery.of(context).size.width,
                    //     child: SingleChildScrollView(
                    //         controller: controller,
                    //         child: Column(
                    //           children: [
                    //             SingleChildScrollView(
                    //               child: ListView.builder(
                    //                 itemCount: 5,
                    //                 shrinkWrap: true,
                    //                 controller: controller,
                    //                 itemBuilder: (BuildContext context, int index) {
                    //                   return Column(
                    //                     children: [
                    //                       Container(
                    //                         padding: EdgeInsets.only(left: 15.0, right: 15.0, bottom: 15.0, top: 15.0),
                    //                         decoration: BoxDecoration(
                    //                             border: Border.all(width: 1.0,color: CustomTheme.of(context).splashColor.withOpacity(0.5),),
                    //                             borderRadius: BorderRadius.circular(10.0)
                    //                         ),
                    //                         child: Row(
                    //                           mainAxisAlignment:
                    //                           MainAxisAlignment.spaceBetween,
                    //                           children: [
                    //                             Row(
                    //                               mainAxisAlignment:
                    //                               MainAxisAlignment
                    //                                   .spaceEvenly,
                    //                               crossAxisAlignment:
                    //                               CrossAxisAlignment.center,
                    //                               children: [
                    //                                 Container(
                    //                                   height: 40.0,
                    //                                   width: 40.0,
                    //                                   decoration: BoxDecoration(
                    //                                     borderRadius:
                    //                                     BorderRadius.circular(
                    //                                         5.0),
                    //                                     color: CustomTheme.of(
                    //                                         context)
                    //                                         .cardColor,
                    //                                   ),
                    //                                   padding:
                    //                                   EdgeInsets.all(5.0),
                    //                                   child: SvgPicture.network(
                    //                                     coinList[index]
                    //                                         .image
                    //                                         .toString(),
                    //                                     fit: BoxFit.cover,
                    //                                   ),
                    //                                 ),
                    //                                 const SizedBox(
                    //                                   width: 15.0,
                    //                                 ),
                    //                                 Column(
                    //                                   crossAxisAlignment:
                    //                                   CrossAxisAlignment
                    //                                       .start,
                    //                                   children: [
                    //                                     Text(
                    //                                       coinList[index]
                    //                                           .name
                    //                                           .toString(),
                    //                                       style: CustomWidget(
                    //                                           context:
                    //                                           context)
                    //                                           .CustomTextStyle(
                    //                                           Theme.of(
                    //                                               context)
                    //                                               .splashColor,
                    //                                           FontWeight.w400,
                    //                                           'FontRegular'),
                    //                                       softWrap: true,
                    //                                       overflow: TextOverflow
                    //                                           .ellipsis,
                    //                                     ),
                    //                                     const SizedBox(
                    //                                       width: 10.0,
                    //                                     ),
                    //                                     Text(
                    //                                       "( " +
                    //                                           coinList[index]
                    //                                               .symbol
                    //                                               .toString()
                    //                                               .toUpperCase() +
                    //                                           " )",
                    //                                       style: CustomWidget(
                    //                                           context:
                    //                                           context)
                    //                                           .CustomTextStyle(
                    //                                           Theme.of(
                    //                                               context)
                    //                                               .splashColor,
                    //                                           FontWeight
                    //                                               .normal,
                    //                                           'FontRegular'),
                    //                                     ),
                    //                                   ],
                    //                                 )
                    //                               ],
                    //                             ),
                    //                             Text(
                    //                               coinList[index]
                    //                                   .balance
                    //                                   .toString(),
                    //                               style: CustomWidget(
                    //                                   context: context)
                    //                                   .CustomTextStyle(
                    //                                   Theme.of(context)
                    //                                       .splashColor,
                    //                                   FontWeight.w400,
                    //                                   'FontRegular'),
                    //                             ),
                    //                           ],
                    //                         ),
                    //                       ),
                    //                       const SizedBox(
                    //                         height: 15.0,
                    //                       ),
                    //
                    //                     ],
                    //                   );
                    //                 },
                    //               ),
                    //             )
                    //           ],
                    //         )))

                    tradePairList.length > 0
                        ? ListView.builder(
                            itemCount: 10,
                            shrinkWrap: true,
                            controller: controller,
                            itemBuilder: (BuildContext context, int index) {
                              double data = double.parse(
                                  tradePairList[index].hrExchange.toString());
                              return Column(
                                children: [
                                  Row(
                                    children: [
                                      Flexible(
                                        child: Container(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                tradePairList[index]
                                                    .tradePair
                                                    .toString(),
                                                style: CustomWidget(
                                                        context: context)
                                                    .CustomSizedTextStyle(
                                                        13.0,
                                                        Theme.of(context)
                                                            .hintColor
                                                            .withOpacity(0.5),
                                                        FontWeight.w500,
                                                        'FontRegular'),
                                              ),
                                              const SizedBox(
                                                height: 5.0,
                                              ),
                                              Text(
                                                double.parse(
                                                        tradePairList[index]
                                                            .hrVolume
                                                            .toString())
                                                    .toStringAsFixed(2),
                                                style: CustomWidget(
                                                        context: context)
                                                    .CustomSizedTextStyle(
                                                        12.0,
                                                        Theme.of(context)
                                                            .hintColor
                                                            .withOpacity(0.5),
                                                        FontWeight.w500,
                                                        'FontRegular'),
                                              ),
                                            ],
                                          ),
                                        ),
                                        flex: 2,
                                      ),
                                      Flexible(
                                        child: Container(
                                          child: Column(
                                            children: [
                                              Text(
                                                double.parse(
                                                        tradePairList[index]
                                                            .currentPrice
                                                            .toString())
                                                    .toStringAsFixed(4),
                                                style: CustomWidget(
                                                        context: context)
                                                    .CustomSizedTextStyle(
                                                        15.0,
                                                        double.parse(data
                                                                    .toString()) >=
                                                                0
                                                            ? Theme.of(context)
                                                                .indicatorColor
                                                            : Theme.of(context)
                                                                .canvasColor,
                                                        FontWeight.w500,
                                                        'FontRegular'),
                                              ),
                                              const SizedBox(
                                                height: 5.0,
                                              ),
                                              // Text(
                                              //   "\$ " +
                                              //       double.parse(marketList[index]
                                              //               .tick!['lastPrice']
                                              //               .toString())
                                              //           .toStringAsFixed(8),
                                              //   style: CustomWidget(context: context)
                                              //       .CustomSizedTextStyle(
                                              //           12.0,
                                              //           Theme.of(context)
                                              //               .hintColor
                                              //               .withOpacity(0.5),
                                              //           FontWeight.w500,
                                              //           'FontRegular'),
                                              // ),
                                            ],
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                          ),
                                          width:
                                              MediaQuery.of(context).size.width,
                                        ),
                                        flex: 2,
                                      ),
                                      Flexible(
                                        child: Container(
                                          child: Center(
                                              child: Container(
                                            padding: EdgeInsets.only(
                                                left: 15.0,
                                                right: 15.0,
                                                top: 8.0,
                                                bottom: 8.0),
                                            child: Text(
                                              data.toStringAsFixed(2)+"%",
                                              style:
                                                  CustomWidget(context: context)
                                                      .CustomSizedTextStyle(
                                                          10.0,
                                                          Theme.of(context)
                                                              .hintColor,
                                                          FontWeight.w500,
                                                          'FontRegular'),
                                            ),
                                            decoration: BoxDecoration(
                                                color: double.parse(
                                                            data.toString()) >=
                                                        0
                                                    ? Theme.of(context)
                                                        .indicatorColor
                                                    : Theme.of(context)
                                                        .canvasColor,
                                                borderRadius:
                                                    BorderRadius.circular(5.0)),
                                          )),
                                        ),
                                        flex: 1,
                                      ),
                                    ],
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                  ),
                                  const SizedBox(
                                    height: 10.0,
                                  ),
                                ],
                              );
                            },
                          )
                        : Container(
                            height: MediaQuery.of(context).size.height * 0.3,
                            color: CustomTheme.of(context).primaryColor,
                            child: Center(
                              child: Text(
                                "No Records Found..!",
                                style: CustomWidget(context: context)
                                    .CustomTextStyle(Colors.white,
                                        FontWeight.w400, 'FontRegular'),
                              ),
                            ),
                          ),

                    SizedBox(
                      height: 20.0,
                    ),
                  ],
                ),
        ));
  }

  getCoinList() {
    apiUtils.walletBalanceInfo().then((UserWalletBalanceModel loginData) {
      if (loginData.success!) {
        setState(() {
          loading = false;
          coinList = loginData.result!;

          coinList..sort((a, b) => b.balance!.compareTo(a.balance!));
        });
      } else {
        setState(() {
          loading = false;
        });
      }
    }).catchError((Object error) {
      setState(() {
        loading = false;
      });
    });
  }

  getPairList() {
    apiUtils.getCoinList().then((CoinListModel loginData) {
      if (loginData.success!) {
        setState(() {
          loading = false;

          tradePairList = [];

          tradePairList = loginData.result!;

          tradePairList
            ..sort((a, b) => double.parse(b.currentPrice.toString())
                .compareTo(double.parse(a.currentPrice.toString())));

          for (int m = 0; m < tradePairList.length; m++) {
            arrData.add("ticker.sfox." + tradePairList[m].symbol.toString());
          }

          loading = false;

          var messageJSON = {
            "type": "subscribe",
            "feeds": arrData,
          };
          channelOpenOrder!.sink.add(json.encode(messageJSON));
          socketData();
        });
      } else {
        setState(() {
          loading = false;
        });
      }
    }).catchError((Object error) {
      print("testErr");
      print(error);
      setState(() {
        loading = false;
      });
    });
  }

  List<Widget> indicators(imagesLength, currentIndex) {
    return List<Widget>.generate(imagesLength, (index) {
      return Container(
        margin: EdgeInsets.all(3),
        width: 25,
        height: 2.5,
        decoration: BoxDecoration(
            color: currentIndex == index
                ? CustomTheme.of(context).splashColor
                : CustomTheme.of(context).splashColor.withOpacity(0.2),
            shape: BoxShape.rectangle),
      );
    });
  }

  StoreData(String name, String uid) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString("name", name);
    preferences.setString("uid", uid);
  }

  List<BottomNavItem> createBottomItems() {
    final bottomItems = [
      new BottomNavItem("assets/bottom/home.svg", label: "loc_side_home"),
      new BottomNavItem("assets/bottom/market.svg", label: "loc_markets"),
      new BottomNavItem("assets/bottom/trade.svg", label: "loc_side_trade"),
      new BottomNavItem("assets/bottom/future.svg", label: "loc_side_future"),
      new BottomNavItem("assets/bottom/wallet.svg", label: "loc_side_assets"),
    ];
    return bottomItems;
  }

  List<BottomNavigationBarItem> bottomItems() {
    return [
      BottomNavigationBarItem(
        icon: Padding(
          child: SvgPicture.asset(
            'assets/bottom/home.svg',
            height: 22.0,
            width: 22.0,
            color: CustomTheme.of(context).splashColor.withOpacity(0.5),
          ),
          padding: EdgeInsets.only(bottom: 8.0),
        ),
        activeIcon: Padding(
          child: SvgPicture.asset(
            'assets/bottom/home.svg',
            height: 22.0,
            width: 22.0,
            color: CustomTheme.of(context).splashColor.withOpacity(0.5),
          ),
          padding: EdgeInsets.only(bottom: 8.0),
        ),
        label: AppLocalizations.instance.text("loc_side_home"),
      ),
      BottomNavigationBarItem(
        icon: Padding(
          child: SvgPicture.asset(
            'assets/bottom/market.svg',
            height: 22.0,
            width: 22.0,
            color: CustomTheme.of(context).splashColor.withOpacity(0.5),
          ),
          padding: EdgeInsets.only(bottom: 8.0),
        ),
        activeIcon: Padding(
          child: SvgPicture.asset(
            'assets/bottom/market.svg',
            height: 22.0,
            width: 22.0,
            color: CustomTheme.of(context).splashColor.withOpacity(0.5),
          ),
          padding: EdgeInsets.only(bottom: 8.0),
        ),
        label: AppLocalizations.instance.text("loc_markets"),
      ),
      BottomNavigationBarItem(
        icon: Padding(
          child: SvgPicture.asset(
            'assets/bottom/trade.svg',
            height: 22.0,
            width: 22.0,
            color: CustomTheme.of(context).splashColor.withOpacity(0.5),
          ),
          padding: EdgeInsets.only(bottom: 8.0),
        ),
        activeIcon: Padding(
          child: SvgPicture.asset(
            'assets/bottom/trade.svg',
            height: 22.0,
            width: 22.0,
            color: CustomTheme.of(context).splashColor.withOpacity(0.5),
          ),
          padding: EdgeInsets.only(bottom: 8.0),
        ),
        label: AppLocalizations.instance.text("loc_side_trade"),
      ),
      BottomNavigationBarItem(
        icon: Padding(
          child: SvgPicture.asset(
            'assets/bottom/future.svg',
            height: 22.0,
            width: 22.0,
            color: CustomTheme.of(context).splashColor.withOpacity(0.5),
          ),
          padding: EdgeInsets.only(bottom: 8.0),
        ),
        activeIcon: Padding(
          child: SvgPicture.asset(
            'assets/bottom/future.svg',
            height: 22.0,
            width: 22.0,
            color: CustomTheme.of(context).splashColor.withOpacity(0.5),
          ),
          padding: EdgeInsets.only(bottom: 8.0),
        ),
        label: AppLocalizations.instance.text("loc_side_future"),
      ),
      BottomNavigationBarItem(
        icon: Padding(
          child: SvgPicture.asset(
            'assets/bottom/wallet.svg',
            height: 22.0,
            width: 22.0,
            color: CustomTheme.of(context).splashColor.withOpacity(0.5),
          ),
          padding: EdgeInsets.only(bottom: 8.0),
        ),
        activeIcon: Padding(
          child: SvgPicture.asset(
            'assets/bottom/wallet.svg',
            height: 22.0,
            width: 22.0,
            color: CustomTheme.of(context).splashColor.withOpacity(0.5),
          ),
          padding: EdgeInsets.only(bottom: 8.0),
        ),
        label: AppLocalizations.instance.text("loc_side_assets"),
      ),
    ];
  }
}
