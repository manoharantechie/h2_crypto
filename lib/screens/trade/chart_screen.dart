import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:k_chart/chart_translations.dart';
import 'package:k_chart/entity/k_line_entity.dart';
import 'package:k_chart/k_chart_widget.dart';
import 'package:k_chart/renderer/index.dart';
import 'package:k_chart/utils/index.dart';
import 'package:h2_crypto/common/colors.dart';
import 'package:h2_crypto/common/custom_widget.dart';
import 'package:h2_crypto/common/theme/custom_theme.dart';
import 'package:h2_crypto/data/api_utils.dart';
import 'package:h2_crypto/data/model/TickerListModel.dart';
import 'package:h2_crypto/data/model/ticker_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart';
import 'package:web_socket_channel/io.dart';

class ChartScreen extends StatefulWidget {

  final String id;
  const ChartScreen({
    Key? key, required this.id,
  }) : super(key: key);

  @override
  State<ChartScreen> createState() => _ChartScreenState();
}

class _ChartScreenState extends State<ChartScreen>  with SingleTickerProviderStateMixin{
  String balance = "0.00";
  List<String> tradeoption = ["Buy", "Sell"];
  String selecedOption = "";
  String id = "";
  APIUtils apiUtils = APIUtils();
  List<KLineEntity>? datas;
  bool showLoading = true;
  MainState _mainState = MainState.MA;
  bool isLine = true;
  bool isChinese = false;
  bool _hideGrid = false;
  int indexVal = 0;

  List<TickerList> tickerList = [];
  List<String> chartList = ["Line", "Candle"];
  String low = "0.0";
  String high = "0.0";
  List<String> chartTime = [
    "1m",
    "15m",
    "30",
    "1d",
  ];

  String lastPrice = "0.0";
  String lastPriceUSD = "0.0";
  String highPrice = "0.0";
  String lowPrice = "0.0";
  String volume = "0.0";
  String usdBalance = "0.0";
  GlobalKey globalKeysc = GlobalKey(debugLabel: 'c');
  String selectedTime = "";
  bool isChangeUI = false;
  bool _isTrendLine = false;
  bool loggedIn = false;
  ChartStyle chartStyle = ChartStyle();
  ChartColors chartColors = ChartColors();
  ScrollController controller = ScrollController();

  // List<PairDetails> _coinList = [];
  // List<PairDetails> _socketcoinList = [];
  // PairDetails? selectedPair;
  bool data = false;

  String valueData = "";
  String valueID = "";

  List<String> array_dta = [];
  String price = "0.00";
  String onChange = "0.00";
  List<DynamicTicker> dynamicTicketr = [];
  bool loading = false;
  bool loading1 = false;
  final ScrollController _scrollViewController = ScrollController();
  IOWebSocketChannel? channelOpenOrder;
  late TabController _tabController;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    setState(() {
      loading = true;
    });
    selecedOption = tradeoption[0];
    _tabController = TabController(vsync: this, length: 2);
    //getSocketData();

    // channelOpenOrder = IOWebSocketChannel.connect(
    //     Uri.parse("wss://stream.binance.com:9443/ws"),
    //     pingInterval: Duration(seconds: 30));
    chartColors.lineFillColor =  Color(0xFF001F1C);

    chartColors.lineFillInsideColor = Color(0xFF136E82);
    chartColors.kLineColor = Color(0xFF136E82);
    chartColors.upColor=Color(0xFF001F1C);
    getData();
    id=widget.id;
    getChart();
    selectedTime = chartTime[0];
    chartColors.bgColor = [Color(0xFF001F1C), Color(0xFF001F1C)];
  }

  getData() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    valueID = preferences.getString("p_id").toString();
    valueData = preferences.getString("p_val").toString();

  }


  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
        data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
        child: Scaffold(
          body: Container(
            margin: EdgeInsets.only(left: 0, right: 0, bottom: 0.0),
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
            child: Stack(
              children: [
                loading
                    ? CustomWidget(context: context)
                    .loadingIndicator( CustomTheme.of(context).splashColor,)
                    : SingleChildScrollView(
                  controller: _scrollViewController,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Container(
                              child: Column(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                crossAxisAlignment:
                                CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    lastPriceUSD.toString(),
                                    style: CustomWidget(context: context)
                                        .CustomSizedTextStyle(
                                        24.0,
                                        Theme
                                            .of(context)
                                            .splashColor,
                                        FontWeight.w400,
                                        'FontRegular'),
                                  ),
                                  const SizedBox(
                                    height: 20.0,
                                  ),
                                  Column(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        usdBalance.toString() + " USD",

                                        style: CustomWidget(context: context)
                                            .CustomSizedTextStyle(
                                            16.0,
                                            Theme
                                                .of(context)
                                                .splashColor,
                                            FontWeight.w400,
                                            'FontRegular'),
                                      ),
                                      const SizedBox(
                                        width: 10.0,
                                      ),

                                    ],
                                  )
                                ],
                              ),
                            ),
                            flex: 2,
                          ),
                          const SizedBox(
                            width: 10.0,
                          ),
                          Flexible(
                            child: Container(
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                    CrossAxisAlignment.end,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "High",
                                            style: CustomWidget(
                                                context: context)
                                                .CustomSizedTextStyle(
                                                12.0,
                                                Theme
                                                    .of(context)
                                                    .splashColor
                                                    .withOpacity(0.5),
                                                FontWeight.w400,
                                                'FontRegular'),
                                          ),
                                          const SizedBox(
                                            height: 3.0,
                                          ),
                                          Text(
                                            highPrice,
                                            style: CustomWidget(
                                                context: context)
                                                .CustomSizedTextStyle(
                                                12.0,
                                                Theme
                                                    .of(context)
                                                    .splashColor,
                                                FontWeight.w400,
                                                'FontRegular'),
                                          ),
                                        ],
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.end,
                                        children: [
                                          Text(
                                            "VOL" + "(" + "secondCoin" + ")",
                                            style: CustomWidget(
                                                context: context)
                                                .CustomSizedTextStyle(
                                                12.0,
                                                Theme
                                                    .of(context)
                                                    .splashColor
                                                    .withOpacity(0.5),
                                                FontWeight.w400,
                                                'FontRegular'),
                                          ),
                                          const SizedBox(
                                            height: 3.0,
                                          ),
                                          Text(
                                            volume,
                                            style: CustomWidget(
                                                context: context)
                                                .CustomSizedTextStyle(
                                                12.0,
                                                Theme
                                                    .of(context)
                                                    .splashColor,
                                                FontWeight.w400,
                                                'FontRegular'),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 10.0,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                    CrossAxisAlignment.center,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Low",
                                            style: CustomWidget(
                                                context: context)
                                                .CustomSizedTextStyle(
                                                12.0,
                                                Theme
                                                    .of(context)
                                                    .splashColor
                                                    .withOpacity(0.5),
                                                FontWeight.w400,
                                                'FontRegular'),
                                          ),
                                          const SizedBox(
                                            height: 3.0,
                                          ),
                                          Text(
                                            lowPrice,
                                            style: CustomWidget(
                                                context: context)
                                                .CustomSizedTextStyle(
                                                12.0,
                                                Theme
                                                    .of(context)
                                                    .splashColor,
                                                FontWeight.w400,
                                                'FontRegular'),
                                          ),
                                        ],
                                      ),

                                    ],
                                  )
                                ],
                              ),
                            ),
                            flex: 2,
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [

                          isLine
                              ? button("Candle",
                              onPressed: () => isLine = false)
                              : button("Line",
                              onPressed: () => isLine = true),
                          Container(
                            height: 40.0,
                            child: ListView.builder(
                                itemCount: chartTime.length,
                                shrinkWrap: true,
                                scrollDirection: Axis.horizontal,
                                physics: NeverScrollableScrollPhysics(),
                                itemBuilder:
                                    (BuildContext context, int index) {
                                  return Row(
                                    children: [
                                      InkWell(
                                        child: Container(
                                          padding: const EdgeInsets.only(
                                              left: 10.0, right: 10.0),
                                          decoration: BoxDecoration(
                                              color: indexVal == index
                                                  ? CustomTheme
                                                  .of(context)
                                                  .buttonColor
                                                  .withOpacity(0.5)
                                                  : CustomTheme
                                                  .of(context)
                                                  .cardColor
                                                  .withOpacity(0.2),
                                              borderRadius:
                                              BorderRadius.all(
                                                  Radius.circular(
                                                      5.0))),
                                          child: Center(
                                            child: Text(
                                              chartTime[index].toString(),
                                              style:

                                              CustomWidget(context: context)
                                                  .CustomSizedTextStyle(
                                                  14.0,
                                                  Theme
                                                      .of(context)
                                                      .splashColor,
                                                  FontWeight.w400,
                                                  'FontRegular'),
                                            ),
                                          ),
                                        ),
                                        onTap: () {
                                          setState(() {
                                            indexVal = index;

                                            // if (indexVal == 0) {
                                            //   chartURL =
                                            //       "https://smdex.io/chart/" +
                                            //           firstCoin
                                            //               .toLowerCase() +
                                            //           "_" +
                                            //           secondCoin
                                            //               .toLowerCase() +
                                            //           "_" +
                                            //           "mob.json";
                                            // } else if (indexVal == 1) {
                                            //   chartURL =
                                            //       "https://smdex.io/chart/" +
                                            //           firstCoin
                                            //               .toLowerCase() +
                                            //           "_" +
                                            //           secondCoin
                                            //               .toLowerCase() +
                                            //           "_1h_" +
                                            //           "mob.json";
                                            // } else if (indexVal == 2) {
                                            //   chartURL =
                                            //       "https://smdex.io/chart/" +
                                            //           firstCoin
                                            //               .toLowerCase() +
                                            //           "_" +
                                            //           secondCoin
                                            //               .toLowerCase() +
                                            //           "_2h_" +
                                            //           "mob.json";
                                            // }
                                            // else if (indexVal == 3) {
                                            //   chartURL =
                                            //       "https://smdex.io/chart/" +
                                            //           firstCoin
                                            //               .toLowerCase() +
                                            //           "_" +
                                            //           secondCoin
                                            //               .toLowerCase() +
                                            //           "_d_" +
                                            //           "mob.json";
                                            // }else {
                                            //   chartURL =
                                            //       "https://smdex.io/chart/" +
                                            //           firstCoin
                                            //               .toLowerCase() +
                                            //           "_" +
                                            //           secondCoin
                                            //               .toLowerCase() +
                                            //           "_" +
                                            //           "mob.json";
                                            // }
                                            //
                                            // loading1 = true;
                                            // getChart();
                                          });
                                        },
                                      ),
                                      const SizedBox(
                                        width: 15.0,
                                      ),
                                    ],
                                  );
                                }),
                          ),
                          InkWell(
                            onTap: () {
                              // Navigator.of(context).push(
                              //     MaterialPageRoute(
                              //         builder: (context) =>
                              //             FullScreenChart(
                              //               chartURL: chartURL,
                              //               isLine: isLine,
                              //             )));
                            },
                            child: SvgPicture.asset(
                                'assets/icon/zoom.svg',
                                color: Theme
                                    .of(context)
                                    .splashColor
                                    .withOpacity(0.5),
                                height: 25.0),
                          )
                        ],
                      ),
                      loading1
                          ? Container(
                        color:  CustomTheme.of(context).primaryColor,
                        height: 300,
                        child: CustomWidget(context: context)
                            .loadingIndicator( CustomTheme.of(context).splashColor,),
                      )
                          : Container(
                        color:  CustomTheme.of(context).primaryColor,
                        height: 300,
                        child: Stack(children: <Widget>[
                          Container(
                            width: double.infinity,
                            color:  CustomTheme.of(context).primaryColor,
                            child: KChartWidget(
                              datas,
                              chartStyle,
                              chartColors,
                              isLine: isLine,
                              onSecondaryTap: () {},
                              isTrendLine: true,
                              mainState: _mainState,
                              volHidden: false,
                              secondaryState: SecondaryState.NONE,
                              fixedLength: 2,
                              timeFormat: TimeFormat
                                  .YEAR_MONTH_DAY_WITH_HOUR,
                              translations: kChartTranslations,
                              showNowPrice: true,
                              //`isChinese` is Deprecated, Use `translations` instead.
                              isChinese: isChinese,
                              flingRatio: 0.4,
                              hideGrid: _hideGrid,
                              isTapShowInfoDialog: false,
                              maDayList: [1, 100, 1000],
                            ),
                          ),
                        ]),
                      ),
                      Container(
                        height: MediaQuery
                            .of(context)
                            .size
                            .height * 0.65,
                        child: NestedScrollView(
                          controller: _scrollViewController,
                          headerSliverBuilder: (BuildContext context,
                              bool innerBoxIsScrolled) {
                            //<-- headerSliverBuilder
                            return <Widget>[
                              SliverAppBar(
                                backgroundColor:
                                AppColors.backgroundColor,
                                pinned: true,
                                //<-- pinned to true
                                floating: true,
                                //<-- floating to true
                                expandedHeight: 40.0,
                                forceElevated: innerBoxIsScrolled,
                                //<-- forceElevated to innerBoxIsScrolled
                                bottom: TabBar(
                                  labelColor: CustomTheme
                                      .of(context)
                                      .cardColor,
                                  //<-- selected text color
                                  unselectedLabelColor: CustomTheme
                                      .of(context)
                                      .splashColor
                                      .withOpacity(0.5),
                                  // isScrollable: true,
                                  indicatorPadding:
                                  EdgeInsets.only(left: 10.0, right: 10.0),
                                  indicatorColor: CustomTheme
                                      .of(context)
                                      .cardColor,
                                  isScrollable: false,
                                  indicatorWeight: 1,

                                  tabs: <Tab>[
                                    Tab(
                                      text: "Order Book",
                                    ),
                                    Tab(
                                      text: "Market Trades",
                                    ),
                                  ],
                                  controller: _tabController,
                                ),
                              ),
                            ];
                          },
                          body: Container(
                            color: AppColors.backgroundColor,
                            child: TabBarView(
                              children: <Widget>[
                                Container(),
                                Container(),
                              ],
                              controller: _tabController,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  Widget button(String text, {VoidCallback? onPressed}) {
    return TextButton(
      onPressed: () {
        if (onPressed != null) {
          onPressed();
          setState(() {});
        }
      },
      child: Text(text),
      style: TextButton.styleFrom(
        primary: Colors.black,
        minimumSize: const Size(88, 44),
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(5.0)),
        ),
        backgroundColor: Colors.blueAccent.withOpacity(0.1),
      ),
    );
  }

  getChart() {
    setState(() {
      loading = true;
      datas = [];
    });
    apiUtils.getChartData(id, selectedTime).then((dynamic loginData) {
      setState(() {
        loading = false;

        final parsed = jsonDecode(loginData);
        final list = parsed.toList();

        datas = list.map((item) =>
            KLineEntity.fromJson(item as Map<String, dynamic>)).toList().cast<
            KLineEntity>();
        print(datas!.length);
        int m = datas!.length;
        low = datas![0].low.toStringAsFixed(2);
        high = datas![0].high.toStringAsFixed(2);
        DataUtil.calculate(datas!);
      });
    }).catchError((Object error) {
      print(error);
      setState(() {
        loading = false;
      });
    });
  }

}
class ChartData{
  double open;
  double high;
  double low;
  double close;
  double vol;
  double amount;
  int time;
  ChartData(this.open,this.high,this.low,this.close,this.vol,this.amount,this.time);

}
