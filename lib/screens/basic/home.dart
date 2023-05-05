import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:h2_crypto/common/bottom_nav.dart';
import 'package:h2_crypto/common/custom_widget.dart';
import 'package:h2_crypto/common/localization/localizations.dart';
import 'package:h2_crypto/common/theme/custom_theme.dart';
import 'package:h2_crypto/data/api_utils.dart';
import 'package:h2_crypto/data/model/banner_list_model.dart';
import 'package:h2_crypto/data/model/market_list_model.dart';
import 'package:h2_crypto/data/model/user_details_model.dart';
import 'package:h2_crypto/screens/basic/side_menu.dart';
import 'package:h2_crypto/screens/p2p/p2p_home.dart';
import 'package:h2_crypto/screens/side_menu/others/notify_screen.dart';
import 'package:h2_crypto/screens/trade/market_screen.dart';
import 'package:h2_crypto/screens/trade/otc_screen.dart';
import 'package:h2_crypto/screens/trade/trade.dart';
import 'package:h2_crypto/screens/wallet/transaction_history.dart';
import 'package:h2_crypto/screens/wallet/wallet.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart';

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
  int? selectIndex ;
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

  List grid_name = [
    "Withdraw",
    "Exchange",
    "Market",
    "Support"
  ];

  List grid_img = [
    "assets/bottom/wallet.svg",
    "assets/images/transfer.svg",
    "assets/bottom/market.svg",
    "assets/sidemenu/support.svg"
  ];


  void onSelectItem(int index) async {
    setState(() {
      selectIndex=index;
      if (index == 0) {
        dashView = true;

      } else {
        dashView = false;
        currentIndex = index;
        screen = bottomPage[index - 1];
        print(currentIndex);
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

    bottomPage = [
      MarketSceen(),
      TradeScreen(),
      TransactionHistory(),
      WalletScreen()
    ];
    dashView = true;
    _bottomItems = createBottomItems();
    getBannerList();
    loading = true;

    loading = true;
    getDetails();


    _tabController = TabController(vsync: this, length: 3);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop:()async{
       return showSuccesssAlertDialog();
      },
      child: Scaffold(
        backgroundColor:    CustomTheme.of(context).primaryColor,
        key: _scaffoldKey,
        appBar: currentIndex == 0
            ? AppBar(
                backgroundColor: CustomTheme.of(context).primaryColor,
                elevation: 0.0,
                // title: InkWell(
                //   onTap: () {
                //     Navigator.push(
                //         context,
                //         MaterialPageRoute(
                //           builder: (context) =>
                //               SearchScreen(),
                //         ));
                //   },
                //   child: Container(
                //     width: MediaQuery.of(context).size.width,
                //     height: 40.0,
                //     decoration: BoxDecoration(
                //         color:
                //             CustomTheme.of(context).buttonColor.withOpacity(0.2),
                //         borderRadius: BorderRadius.circular(5.0),
                //         border: Border.all(
                //             color: CustomTheme.of(context)
                //                 .buttonColor
                //                 .withOpacity(0.5),
                //             width: 0.2)),
                //     child: Row(
                //       children: [
                //         const SizedBox(
                //           width: 5.0,
                //         ),
                //         Icon(
                //           Icons.search_rounded,
                //           color: CustomTheme.of(context).buttonColor,
                //           size: 15.0,
                //         ),
                //         const SizedBox(
                //           width: 10.0,
                //         ),
                //         Text(
                //           AppLocalizations.instance.text('loc_search'),
                //           style: CustomWidget(context: context)
                //               .CustomSizedTextStyle(
                //                   13.0,
                //                   Theme.of(context).buttonColor,
                //                   FontWeight.w300,
                //                   'FontRegular'),
                //         ),
                //       ],
                //     ),
                //   ),
                // ),
          title:  Image.asset('assets/icon/logo.png',height: 35.0,),
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
                        color: CustomTheme.of(context).buttonColor,
                      ),
                    )),
                actions: [
                  InkWell(
                      onTap: () {

                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => NotifyScreen(

                            ),
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                        child: SvgPicture.asset(
                          'assets/others/notify.svg',
                          height: 15.0,
                          color: CustomTheme.of(context).buttonColor,
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
                CustomTheme.of(context).accentColor,
              ])),
          child: Stack(
            children: [
              // PageStorage(child: assetsUI(), bucket: bucket),
              PageStorage(child: dashView ? DashBoard() : screen, bucket: bucket),
            ],
          ),
        ),
        //
        // bottomNavigationBar: SizedBox(
        //     height: 70.0,
        //     child: Container(
        //       decoration: BoxDecoration(
        //         color: CustomTheme.of(context).buttonColor,
        //       ),
        //       child: Container(
        //         margin: const EdgeInsets.only(left: 5.0, right: 5.0, bottom: 5.0),
        //         decoration: BoxDecoration(
        //           color: CustomTheme.of(context).buttonColor,
        //         ),
        //         child: BottomNavigationBar(
        //           elevation: 0.0,
        //
        //           type: BottomNavigationBarType.fixed,
        //           //
        //           items: bottomItems(),
        //           currentIndex: currentIndex,
        //           showSelectedLabels: true,
        //           backgroundColor:currentIndex==selectIndex? CustomTheme.of(context).buttonColor: CustomTheme.of(context).bottomAppBarColor,
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
            onSelectColor: CustomTheme.of(context).buttonColor,
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
              currentIndex=i;

            });
          },
          items: _bottomItems,
        ),
      ),
    );
  }



  getSocketData() async {
    await apiUtils.socketChatConnection(() {
      if (apiUtils.socketChat!.connected) {
        apiUtils.socketChat!.emit('join', 'test');
        apiUtils.socketChat!.on('reply', (data) {
          var resp = data
              .map<MarketListModel>((json) => MarketListModel.fromJson(json))
              .toList();
          if (mounted) {
            setState(() {
              marketList = [];
              marketList.clear;
              marketList = resp;
              loading = false;
            });
          }
        });
        apiUtils.socketChat!.onDisconnect((_) => print('disconnect'));
      } else {}
    });
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
                          Theme.of(context).buttonColor,
                          FontWeight.bold,
                          'FontRegular'),
                    ),
                    Container(
                        margin: EdgeInsets.only(top: 7.0, bottom: 10.0),
                        height: 2.0,
                        color: CustomTheme.of(context).buttonColor),
                    Text(
                      "Do you want to exit an App",
                      style: CustomWidget(context: context)
                          .CustomSizedTextStyle(
                          16.0,
                          Theme.of(context).buttonColor,
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
                                      CustomTheme.of(context).buttonColor,
                                      CustomTheme.of(context).buttonColor
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
                                      CustomTheme.of(context).buttonColor,
                                      CustomTheme.of(context).buttonColor,
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
                    bannerList.isNotEmpty
                        ? Container(
                            height: MediaQuery.of(context).size.height * 0.23,
                            width: MediaQuery.of(context).size.width,
                            child: CarouselSlider(
                              options: CarouselOptions(
                                onPageChanged: (index, reason) {
                                  setState(() {
                                    slideIndex = index;
                                  });
                                },
                                autoPlay: true,
                                aspectRatio: 1.0,
                                enlargeCenterPage: true,
                                viewportFraction: 1,
                              ),
                              items: bannerList
                                  .map((item) => Container(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        padding: EdgeInsets.all(1),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5.0),
                                          color: CustomTheme.of(context)
                                              .backgroundColor,
                                        ),
                                        child: Image.network(
                                          APIUtils.baseURL + item,
                                          fit: BoxFit.cover,
                                        ),
                                      ))
                                  .toList(),
                            ),
                          )
                        : Container(),
                    const SizedBox(
                      height: 10.0,
                    ),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: indicators(bannerList.length, slideIndex)),
                    const SizedBox(
                      height: 10.0,
                    ),
                    Row(
                      children: [
                        SvgPicture.asset(
                          'assets/others/speaker.svg',
                          color: CustomTheme.of(context).buttonColor,
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
                    ),
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
                                    .buttonColor
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
                                    onTap: (){
                                      setState(() {
                                        currentIndex=1;
                                        dashView=false;
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
                                                      14.0,
                                                      double.parse(data
                                                          .toString()) >=
                                                          0
                                                          ? Theme.of(context)
                                                          .indicatorColor
                                                          : Theme.of(context)
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
                    // GridView.builder(
                    //   itemCount: grid_name.length,
                    //   shrinkWrap: true,
                    //   gridDelegate:
                    //   SliverGridDelegateWithFixedCrossAxisCount(
                    //     childAspectRatio: 2.0,
                    //     crossAxisCount: 2,
                    //     crossAxisSpacing: 20.0,
                    //     mainAxisSpacing: 20.0,
                    //   ),
                    //   itemBuilder: (BuildContext context, int index) {
                    //     return Row(
                    //       crossAxisAlignment: CrossAxisAlignment.center,
                    //       // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    //       children: [
                    //         InkWell(
                    //           onTap: () {
                    //
                    //           },
                    //           child: Container(
                    //             padding: EdgeInsets.only(
                    //                 top: 5.0,
                    //                 bottom: 5.0,
                    //                 right: 12.0,
                    //                 left: 12.0),
                    //               decoration: BoxDecoration(
                    //                 color: Theme.of(context).focusColor,
                    //                 border: Border.all(
                    //                     width: 1.0,
                    //                     color: Theme.of(context).splashColor.withOpacity(0.5)),
                    //                 borderRadius: BorderRadius.circular(10.0),
                    //               ),
                    //               alignment: Alignment.center,
                    //               child: Column(
                    //                 crossAxisAlignment: CrossAxisAlignment.center,
                    //                 mainAxisAlignment: MainAxisAlignment.center,
                    //                 children: [
                    //                   SvgPicture.asset(
                    //                     grid_img[index].toString(),
                    //                     height: 25.0,
                    //                     color: Theme.of(context).buttonColor,
                    //                   ),
                    //                   SizedBox(
                    //                     height: 10.0,
                    //                   ),
                    //                   Text(
                    //                     // AppLocalizations.instance.text("loc_widthdraw"),
                    //                     grid_name[index].toString(),
                    //                     style: CustomWidget(context: context)
                    //                         .CustomSizedTextStyle(
                    //                         12.0,
                    //                         Theme.of(context).splashColor,
                    //                         FontWeight.w500,
                    //                         'FontRegular'),
                    //                     textAlign: TextAlign.center,
                    //                   ),
                    //                 ],
                    //               )),
                    //         ),
                    //         const SizedBox(
                    //           width: 0.0,
                    //         )
                    //       ],
                    //     );
                    //   },
                    // ),
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
                                      color: Theme.of(context).splashColor.withOpacity(0.5)),
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
                                      color: Theme.of(context).buttonColor,
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

                            },
                            child: Container(
                              // padding: EdgeInsets.only(
                              //     top: 5.0,
                              //     bottom: 5.0,
                              //     right: 12.0,
                              //     left: 12.0),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).focusColor,
                                  border: Border.all(
                                      width: 1.0,
                                      color: Theme.of(context).splashColor.withOpacity(0.5)),
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
                                      color: Theme.of(context).buttonColor,
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

                  ],
                ),
        ));
  }

  getBannerList() {
    apiUtils.getBannerList().then((BannerImageListModel loginData) {
      if (loginData.statusCode.toString() == "200") {
        setState(() {
          loading = false;

          for (int m = 0; m < loginData.data!.length; m++) {
            bannerList.add(loginData.data![m].imgUrl!);
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

  getDetails() {
    apiUtils.getUserDetails().then((UserDetailsModel loginData) {
      if (loginData.statusCode.toString() == "200") {
        setState(() {
          loading = false;
          StoreData(
              loginData.data!.name.toString(), loginData.data!.id.toString());
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
        icon:Padding(
          child:  SvgPicture.asset(
            'assets/bottom/home.svg',
            height: 22.0,
            width: 22.0,
            color: CustomTheme.of(context).splashColor.withOpacity(0.5),
          ),
          padding: EdgeInsets.only(bottom: 8.0),
        ),
        activeIcon: Padding(
          child:  SvgPicture.asset(
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
        icon:Padding(
          child:  SvgPicture.asset(
            'assets/bottom/market.svg',
            height: 22.0,
            width: 22.0,
            color: CustomTheme.of(context).splashColor.withOpacity(0.5),
          ),
          padding: EdgeInsets.only(bottom: 8.0),
        ),
        activeIcon: Padding(
          child:  SvgPicture.asset(
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
          child:  SvgPicture.asset(
            'assets/bottom/trade.svg',
            height: 22.0,
            width: 22.0,
            color: CustomTheme.of(context).splashColor.withOpacity(0.5),
          ),
          padding: EdgeInsets.only(bottom: 8.0),
        ),
        activeIcon:Padding(
          child:  SvgPicture.asset(
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
          child:  SvgPicture.asset(
            'assets/bottom/future.svg',
            height: 22.0,
            width: 22.0,
            color: CustomTheme.of(context).splashColor.withOpacity(0.5),
          ),
          padding: EdgeInsets.only(bottom: 8.0),
        ),
        activeIcon:Padding(
          child:  SvgPicture.asset(
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
          child:  SvgPicture.asset(
            'assets/bottom/wallet.svg',
            height: 22.0,
            width: 22.0,
            color: CustomTheme.of(context).splashColor.withOpacity(0.5),
          ),
          padding: EdgeInsets.only(bottom: 8.0),
        ),
        activeIcon: Padding(
          child:  SvgPicture.asset(
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
