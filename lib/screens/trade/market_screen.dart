import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:h2_crypto/data/api_utils.dart';
import 'package:h2_crypto/data/crypt_model/coin_list.dart';
import 'package:h2_crypto/data/model/market_list_model.dart';
import 'package:h2_crypto/data/model/new_socket_data.dart';
import 'package:h2_crypto/data/model/socket_data.dart';
import 'package:h2_crypto/data/model/trade_pair_list_model.dart';


import 'package:socket_io_client/socket_io_client.dart';
import 'package:web_socket_channel/io.dart';

import '../../../common/custom_widget.dart';
import '../../../common/localization/localizations.dart';
import '../../../common/theme/custom_theme.dart';

class MarketSceen extends StatefulWidget {
  const MarketSceen({Key? key}) : super(key: key);

  @override
  State<MarketSceen> createState() => _MarketSceen1State();
}

class _MarketSceen1State extends State<MarketSceen>
    with SingleTickerProviderStateMixin {
  bool _flag = true;
  bool _btns = true;

  var array_dta;
  bool loading = false;

  List<MarketListModel> marketList = [];

  APIUtils apiUtils = APIUtils();
  ScrollController controller = ScrollController();
  late TabController _tabController;

  List<CoinList> tradePairList = [];

  IOWebSocketChannel? channelOpenOrder;
  List arrData=[];
  List<SocketData> socktList=[];



  // wss://stream.binance.com:9443/ws
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loading = true;

    _tabController = TabController(vsync: this, length: 1);

    getCoinList();

    channelOpenOrder = IOWebSocketChannel.connect(
        Uri.parse("wss://ws.sfox.com/ws"),
        pingInterval: Duration(seconds: 30));




  }


  socketData() {


    channelOpenOrder!.stream.listen(
          (data) {

        if (data != null || data != "null") {


          setState(() {
            loading=false;

          });

          var decode = jsonDecode(data);
          NewSocketData ss=NewSocketData.fromJson(decode);
          for(int m=0;m<tradePairList.length;m++)
          {
            if(tradePairList[m].symbol.toString().toLowerCase()==ss.payload.pair.toString().toLowerCase())
            {


              double open =
              double.parse(ss.payload.open.toString());
              double close =
              double.parse(ss.payload.last.toString());
              double data = ((close - open) / open)*100;

              tradePairList[m].hrExchange=data.toString();
              tradePairList[m].currentPrice=double.parse(ss.payload.last.toString()).toString();
              tradePairList[m].hrVolume=double.parse(ss.payload.volume.toString()).toString();
            }
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

  dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: CustomTheme.of(context).primaryColor,
        appBar: AppBar(
          backgroundColor: CustomTheme.of(context).primaryColor,
          elevation: 0.0,
          leading: Container(
            width: 0.0,
          ),

          centerTitle: true,
          title: Text(
            "Markets",
            style: CustomWidget(context: context).CustomSizedTextStyle(18.0,
                Theme.of(context).splashColor, FontWeight.w500, 'FontRegular'),
          ),
          actions: <Widget>[
            Container(
                padding: const EdgeInsets.all(15.0),
                child: InkWell(
                  onTap: () {
                    // Navigator.pop(context);
                  },
                  child: SvgPicture.asset(
                    'assets/others/search.svg',
                    height: 24.0,
                    width: 24.0,
                    allowDrawingOutsideViewBox: true,
                    color: CustomTheme.of(context).splashColor,
                  ),
                )),
          ],
        ),
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
          child: Container(
            height: MediaQuery.of(context).size.height * 0.9,
            color: CustomTheme.of(context).primaryColor,
            child: loading
                ? CustomWidget(context: context)
                .loadingIndicator(CustomTheme.of(context).splashColor)
                : Column(
              children: [
                Stack(
                  children: [
                    TabBar(
                      controller: _tabController,
                      labelColor: CustomTheme.of(context).cardColor,
                      //<-- selected text color
                      unselectedLabelColor: CustomTheme.of(context)
                          .splashColor
                          .withOpacity(0.5),
                      // isScrollable: true,
                      indicatorPadding:
                      EdgeInsets.only(left: 10.0, right: 10.0),
                      indicatorColor: CustomTheme.of(context).cardColor,
                      tabs: <Widget>[
                        // Tab(
                        //   text: "Favourites",
                        // ),
                        Tab(
                          text: "Spot",
                        ),
                        // Tab(
                        //   text: "Margin",
                        // ),
                        // Tab(
                        //   text: "Futures",
                        // ),
                      ],
                    ),
                  ],
                ),
                Expanded(
                  child: Container(
                    color: CustomTheme.of(context).backgroundColor,
                    child: TabBarView(
                      controller: _tabController,
                      children: <Widget>[
                        favList(),
                        // spotList()
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ));
  }

  Widget spotList() {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
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
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.fromLTRB(15, 2, 15, 2),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Row(
                        children: [
                          Text(
                            "Name",
                            style: CustomWidget(context: context)
                                .CustomSizedTextStyle(
                                13.0,
                                Theme.of(context)
                                    .hintColor
                                    .withOpacity(0.5),
                                FontWeight.w500,
                                'FontRegular'),
                          ),
                          // Padding(
                          //   padding: EdgeInsets.all(5.0),
                          //   child: Column(
                          //     children: [
                          //       Container(
                          //         padding:
                          //             const EdgeInsets.fromLTRB(0, 0, 0, 0),
                          //         child: InkWell(
                          //           onTap: () {
                          //           setState(() {
                          //             marketList.sort((a, b) => a.pair!.compareTo(b.pair!));
                          //           });
                          //           },
                          //           child: SvgPicture.asset(
                          //             'assets/images/arrow up.svg',
                          //             height: 10.0,
                          //             width: 10.0,
                          //             allowDrawingOutsideViewBox: true,
                          //             color:
                          //                 CustomTheme.of(context).splashColor,
                          //           ),
                          //         ),
                          //       ),
                          //       const SizedBox(
                          //         height: 2.0,
                          //       ),
                          //       Container(
                          //           padding:
                          //               const EdgeInsets.fromLTRB(0, 0, 0, 0),
                          //           child: InkWell(
                          //             onTap: () {
                          //               marketList.sort((a, b) => a.pair!.compareTo(b.pair!));
                          //             },
                          //             child: SvgPicture.asset(
                          //               'assets/images/arrow down.svg',
                          //               height: 10.0,
                          //               width: 10.0,
                          //               allowDrawingOutsideViewBox: true,
                          //               color:
                          //                   CustomTheme.of(context).splashColor,
                          //             ),
                          //           )),
                          //       const SizedBox(
                          //         height: 2.0,
                          //       ),
                          //     ],
                          //   ),
                          // ),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            "/ vol",
                            style: CustomWidget(context: context)
                                .CustomSizedTextStyle(
                                13.0,
                                Theme.of(context)
                                    .hintColor
                                    .withOpacity(0.5),
                                FontWeight.w500,
                                'FontRegular'),
                          ),
                          // Padding(
                          //   padding: EdgeInsets.all(5.0),
                          //   child: Column(
                          //     children: [
                          //       Container(
                          //         padding:
                          //             const EdgeInsets.fromLTRB(0, 0, 0, 0),
                          //         child: InkWell(
                          //           onTap: () {
                          //            setState(() {
                          //              marketList.sort((a, b) => b.pair!.compareTo(a.pair!));
                          //            });
                          //           },
                          //           child: SvgPicture.asset(
                          //             'assets/images/arrow up.svg',
                          //             height: 10.0,
                          //             width: 10.0,
                          //             allowDrawingOutsideViewBox: true,
                          //             color:
                          //                 CustomTheme.of(context).splashColor,
                          //           ),
                          //         ),
                          //       ),
                          //       const SizedBox(
                          //         height: 2.0,
                          //       ),
                          //       Container(
                          //           padding:
                          //               const EdgeInsets.fromLTRB(0, 0, 0, 0),
                          //           child: InkWell(
                          //             onTap: () {
                          //            setState(() {
                          //              marketList.sort((a, b) => b.pair!.compareTo(a.pair!));
                          //            });
                          //             },
                          //             child: SvgPicture.asset(
                          //               'assets/images/arrow down.svg',
                          //               height: 10.0,
                          //               width: 10.0,
                          //               allowDrawingOutsideViewBox: true,
                          //               color:
                          //                   CustomTheme.of(context).splashColor,
                          //             ),
                          //           )),
                          //       const SizedBox(
                          //         height: 2.0,
                          //       ),
                          //     ],
                          //   ),
                          // ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  Row(
                    children: [
                      Text(
                        "Market Price",
                        style: CustomWidget(context: context)
                            .CustomSizedTextStyle(
                            13.0,
                            Theme.of(context).hintColor.withOpacity(0.5),
                            FontWeight.w500,
                            'FontRegular'),
                      ),
                      // Padding(
                      //   padding: EdgeInsets.all(5.0),
                      //   child: Column(
                      //     children: [
                      //       Container(
                      //         padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                      //         child: InkWell(
                      //           onTap: () {
                      //             Navigator.pop(context);
                      //           },
                      //           child: SvgPicture.asset(
                      //             'assets/images/arrow up.svg',
                      //             height: 10.0,
                      //             width: 10.0,
                      //             allowDrawingOutsideViewBox: true,
                      //             color: CustomTheme.of(context).splashColor,
                      //           ),
                      //         ),
                      //       ),
                      //       const SizedBox(
                      //         height: 2.0,
                      //       ),
                      //       Container(
                      //           padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                      //           child: InkWell(
                      //             onTap: () {
                      //               Navigator.pop(context);
                      //             },
                      //             child: SvgPicture.asset(
                      //               'assets/images/arrow down.svg',
                      //               height: 10.0,
                      //               width: 10.0,
                      //               allowDrawingOutsideViewBox: true,
                      //               color: CustomTheme.of(context).splashColor,
                      //             ),
                      //           )),
                      //       const SizedBox(
                      //         height: 2.0,
                      //       ),
                      //     ],
                      //   ),
                      // ),
                    ],
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  Row(
                    children: [
                      Text(
                        "Change",
                        style: CustomWidget(context: context)
                            .CustomSizedTextStyle(
                            13.0,
                            Theme.of(context).hintColor.withOpacity(0.5),
                            FontWeight.w500,
                            'FontRegular'),
                      ),
                      // Padding(
                      //   padding: EdgeInsets.all(5.0),
                      //   child: Column(
                      //     children: [
                      //       Container(
                      //         padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                      //         child: InkWell(
                      //           onTap: () {
                      //             Navigator.pop(context);
                      //           },
                      //           child: SvgPicture.asset(
                      //             'assets/images/arrow up.svg',
                      //             height: 10.0,
                      //             width: 10.0,
                      //             allowDrawingOutsideViewBox: true,
                      //             color: CustomTheme.of(context).splashColor,
                      //           ),
                      //         ),
                      //       ),
                      //       const SizedBox(
                      //         height: 2.0,
                      //       ),
                      //       Container(
                      //           padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                      //           child: InkWell(
                      //             onTap: () {
                      //               Navigator.pop(context);
                      //             },
                      //             child: SvgPicture.asset(
                      //               'assets/images/arrow down.svg',
                      //               height: 10.0,
                      //               width: 10.0,
                      //               allowDrawingOutsideViewBox: true,
                      //               color: CustomTheme.of(context).splashColor,
                      //             ),
                      //           )),
                      //       const SizedBox(
                      //         height: 2.0,
                      //       ),
                      //     ],
                      //   ),
                      // ),
                    ],
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                ],
              ),
              const SizedBox(
                height: 10.0,

              ),
              ListView.builder(
                itemCount: socktList.length,
                shrinkWrap: true,
                controller: controller,
                itemBuilder: (BuildContext context, int index) {
                  double data =   double.parse(socktList[index].socketDataP.toString());
                  return Column(
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    socktList[index].s.toString(),
                                    style: CustomWidget(context: context)
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
                                    double.parse(socktList[index].v.toString())
                                        .toStringAsFixed(4),
                                    style: CustomWidget(context: context)
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
                                    double.parse(socktList[index].c.toString())
                                        .toStringAsFixed(4),
                                    style: CustomWidget(context: context)
                                        .CustomSizedTextStyle(
                                        15.0,
                                        double.parse(data.toString()) >= 0
                                            ? Theme.of(context)
                                            .indicatorColor
                                            : Theme.of(context).canvasColor,
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
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                              ),
                              width: MediaQuery.of(context).size.width,
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
                                      data.toStringAsFixed(2),
                                      style: CustomWidget(context: context)
                                          .CustomSizedTextStyle(
                                          14.0,
                                          Theme.of(context).hintColor,
                                          FontWeight.w500,
                                          'FontRegular'),
                                    ),
                                    decoration: BoxDecoration(
                                        color: double.parse(data.toString()) >= 0
                                            ? Theme.of(context).indicatorColor
                                            : Theme.of(context).canvasColor,
                                        borderRadius: BorderRadius.circular(5.0)),
                                  )),
                            ),
                            flex: 1,
                          ),
                        ],
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                      ),
                      const SizedBox(
                        height: 10.0,
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget favList() {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
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
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.fromLTRB(15, 2, 15, 2),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 10.0,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Row(
                        children: [
                          Text(
                            "Name",
                            style: CustomWidget(context: context)
                                .CustomSizedTextStyle(
                                13.0,
                                Theme.of(context)
                                    .hintColor
                                    .withOpacity(0.5),
                                FontWeight.w500,
                                'FontRegular'),
                          ),
                          // Padding(
                          //   padding: EdgeInsets.all(5.0),
                          //   child: Column(
                          //     children: [
                          //       Container(
                          //         padding:
                          //             const EdgeInsets.fromLTRB(0, 0, 0, 0),
                          //         child: InkWell(
                          //           onTap: () {
                          //             setState(() {
                          //               tradePair.sort((a, b) => a.pair!.compareTo(b.pair!));
                          //             });
                          //           },
                          //           child: SvgPicture.asset(
                          //             'assets/images/arrow up.svg',
                          //             height: 10.0,
                          //             width: 10.0,
                          //             color:
                          //                 CustomTheme.of(context).splashColor,
                          //           ),
                          //         ),
                          //       ),
                          //       const SizedBox(
                          //         height: 2.0,
                          //       ),
                          //       Container(
                          //           padding:
                          //               const EdgeInsets.fromLTRB(0, 0, 0, 0),
                          //           child: InkWell(
                          //             onTap: () {
                          //               setState(() {
                          //                 tradePair.sort((a, b) => a.pair!.compareTo(b.pair!));
                          //               });
                          //             },
                          //             child: SvgPicture.asset(
                          //               'assets/images/arrow down.svg',
                          //               height: 10.0,
                          //               width: 10.0,
                          //               color:
                          //                   CustomTheme.of(context).splashColor,
                          //             ),
                          //           )),
                          //       const SizedBox(
                          //         height: 2.0,
                          //       ),
                          //     ],
                          //   ),
                          // ),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            "/ vol",
                            style: CustomWidget(context: context)
                                .CustomSizedTextStyle(
                                13.0,
                                Theme.of(context)
                                    .hintColor
                                    .withOpacity(0.5),
                                FontWeight.w500,
                                'FontRegular'),
                          ),
                          // Padding(
                          //   padding: EdgeInsets.all(5.0),
                          //   child: Column(
                          //     children: [
                          //       Container(
                          //         padding:
                          //             const EdgeInsets.fromLTRB(0, 0, 0, 0),
                          //         child: InkWell(
                          //           onTap: () {
                          //
                          //
                          //           },
                          //           child: SvgPicture.asset(
                          //             'assets/images/arrow up.svg',
                          //             height: 10.0,
                          //             width: 10.0,
                          //
                          //             color:
                          //                 CustomTheme.of(context).splashColor,
                          //           ),
                          //         ),
                          //       ),
                          //       const SizedBox(
                          //         height: 2.0,
                          //       ),
                          //       Container(
                          //           padding:
                          //               const EdgeInsets.fromLTRB(0, 0, 0, 0),
                          //           child: InkWell(
                          //             onTap: () {
                          //
                          //             },
                          //             child: SvgPicture.asset(
                          //               'assets/images/arrow down.svg',
                          //               height: 10.0,
                          //               width: 10.0,
                          //
                          //               color:
                          //                   CustomTheme.of(context).splashColor,
                          //             ),
                          //           )),
                          //       const SizedBox(
                          //         height: 2.0,
                          //       ),
                          //     ],
                          //   ),
                          // ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  Row(
                    children: [
                      Text(
                        "Market Price",
                        style: CustomWidget(context: context)
                            .CustomSizedTextStyle(
                            13.0,
                            Theme.of(context).hintColor.withOpacity(0.5),
                            FontWeight.w500,
                            'FontRegular'),
                      ),
                      // Padding(
                      //   padding: EdgeInsets.all(5.0),
                      //   child: Column(
                      //     children: [
                      //       Container(
                      //         padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                      //         child: InkWell(
                      //           onTap: () {
                      //             Navigator.pop(context);
                      //           },
                      //           child: SvgPicture.asset(
                      //             'assets/images/arrow up.svg',
                      //             height: 10.0,
                      //             width: 10.0,
                      //             allowDrawingOutsideViewBox: true,
                      //             color: CustomTheme.of(context).splashColor,
                      //           ),
                      //         ),
                      //       ),
                      //       const SizedBox(
                      //         height: 2.0,
                      //       ),
                      //       Container(
                      //           padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                      //           child: InkWell(
                      //             onTap: () {
                      //               Navigator.pop(context);
                      //             },
                      //             child: SvgPicture.asset(
                      //               'assets/images/arrow down.svg',
                      //               height: 10.0,
                      //               width: 10.0,
                      //               allowDrawingOutsideViewBox: true,
                      //               color: CustomTheme.of(context).splashColor,
                      //             ),
                      //           )),
                      //       const SizedBox(
                      //         height: 2.0,
                      //       ),
                      //     ],
                      //   ),
                      // ),
                    ],
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  Row(
                    children: [
                      Text(
                        "Change",
                        style: CustomWidget(context: context)
                            .CustomSizedTextStyle(
                            13.0,
                            Theme.of(context).hintColor.withOpacity(0.5),
                            FontWeight.w500,
                            'FontRegular'),
                      ),
                      // Padding(
                      //   padding: EdgeInsets.all(5.0),
                      //   child: Column(
                      //     children: [
                      //       Container(
                      //         padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                      //         child: InkWell(
                      //           onTap: () {
                      //             Navigator.pop(context);
                      //           },
                      //           child: SvgPicture.asset(
                      //             'assets/images/arrow up.svg',
                      //             height: 10.0,
                      //             width: 10.0,
                      //             allowDrawingOutsideViewBox: true,
                      //             color: CustomTheme.of(context).splashColor,
                      //           ),
                      //         ),
                      //       ),
                      //       const SizedBox(
                      //         height: 2.0,
                      //       ),
                      //       Container(
                      //           padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                      //           child: InkWell(
                      //             onTap: () {
                      //               Navigator.pop(context);
                      //             },
                      //             child: SvgPicture.asset(
                      //               'assets/images/arrow down.svg',
                      //               height: 10.0,
                      //               width: 10.0,
                      //               allowDrawingOutsideViewBox: true,
                      //               color: CustomTheme.of(context).splashColor,
                      //             ),
                      //           )),
                      //       const SizedBox(
                      //         height: 2.0,
                      //       ),
                      //     ],
                      //   ),
                      // ),
                    ],
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                ],
              ),
              const SizedBox(
                height: 10.0,
              ),
              ListView.builder(
                itemCount: tradePairList.length,
                shrinkWrap: true,
                controller: controller,
                itemBuilder: (BuildContext context, int index) {

                  double data = double.parse(tradePairList[index].hrExchange.toString());
                  return Column(
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    tradePairList[index].tradePair.toString(),
                                    style: CustomWidget(context: context)
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
                                    double.parse(tradePairList[index].hrVolume
                                        .toString())
                                        .toStringAsFixed(2),
                                    style: CustomWidget(context: context)
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
                                    double.parse(tradePairList[index]
                                        .currentPrice.toString())
                                        .toStringAsFixed(4),
                                    style: CustomWidget(context: context)
                                        .CustomSizedTextStyle(
                                        15.0,
                                        double.parse(data.toString()) >= 0
                                            ? Theme.of(context)
                                            .indicatorColor
                                            : Theme.of(context).canvasColor,
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
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                              ),
                              width: MediaQuery.of(context).size.width,
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
                                      data.toStringAsFixed(2),
                                      style: CustomWidget(context: context)
                                          .CustomSizedTextStyle(
                                          14.0,
                                          Theme.of(context).hintColor,
                                          FontWeight.w500,
                                          'FontRegular'),
                                    ),
                                    decoration: BoxDecoration(
                                        color: double.parse(data.toString()) >= 0
                                            ? Theme.of(context).indicatorColor
                                            : Theme.of(context).canvasColor,
                                        borderRadius: BorderRadius.circular(5.0)),
                                  )),
                            ),
                            flex: 1,
                          ),
                        ],
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                      ),
                      const SizedBox(
                        height: 10.0,
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  getCoinList() {
    apiUtils.getCoinList().then((CoinListModel loginData) {
      if (loginData.success! ) {
        setState(() {
          loading=false;
          tradePairList = [];
          tradePairList = loginData.result!;
          for(int m=0;m<tradePairList.length;m++)
          {

              arrData.add("ticker.sfox."+tradePairList[m].symbol.toString());


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
      setState(() {
        loading = false;
      });
    });
  }
}
class Tag {
  String name;
  double value;
  double quantity;
  double change;
  String coin;

  Tag(this.name, this.value, this.quantity, this.change, this.coin);

  factory Tag.fromJson(dynamic json) {
    return Tag(
      json['name'] as String,
      json['value'] as double,
      json['quantity'] as double,
      json['change'] as double,
      json['coin'] as String,
    );
  }

  @override
  String toString() {
    return '{ ${this.name},${this.value}, ${this.quantity} ,${this.change},${this.coin}}';
  }
}