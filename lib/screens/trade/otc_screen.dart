import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:h2_crypto/common/colors.dart';
import 'package:h2_crypto/common/custom_widget.dart';
import 'package:h2_crypto/common/theme/custom_theme.dart';
import 'package:h2_crypto/data/model/instant_model.dart';
import 'package:h2_crypto/data/model/instant_value_model.dart';
import 'package:h2_crypto/data/model/trade_pair_detail_data.dart';

import '../../data/api_utils.dart';
import '../../data/model/trade_pair_list_model.dart';

class OTCTradeScreen extends StatefulWidget {
  const OTCTradeScreen({Key? key}) : super(key: key);

  @override
  State<OTCTradeScreen> createState() => OTCTradeScreenState();
}

class OTCTradeScreenState extends State<OTCTradeScreen> {
  TextEditingController amountController = TextEditingController();
  TextEditingController buyAmountController = TextEditingController();
  TextEditingController searchController = TextEditingController();
  TextEditingController searchControllerTwo = TextEditingController();
  ScrollController controller = ScrollController();
  ScrollController controllerOne = ScrollController();
  FocusNode searchFocus = FocusNode();
  List<TradePairList> tradePair = [];
  List<TradePairList> coinOneList = [];
  List<TradePairList> coinTwoList = [];
  List<TradePairList> searchPair = [];
  List<TradePairList> searchPairTwo = [];
  String selectPair = "";
  String livePrice = "";
  String totalPrice = "0.00";
  String selectPairId = "";
  String marketWalletBal = "0.00";
  String baseWalletBal = "0.00";
  String selectPairTwo = "";
  dynamic minBuy=0;
  dynamic maxBuy=0 ;
  dynamic minSell=0;
  dynamic maxSell=0;
  APIUtils apiUtils = APIUtils();
  bool loading = false;
  bool swapVisible = false;
  bool quoteVisible = false;
  bool instantCal = false;
  TradePairList? tPair;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("Swapvisible"+swapVisible.toString());
    loading = true;
    getCoinList();
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
        data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
        child: Scaffold(
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.transparent,
            title: Text(
              "Spot Block Trading",
              style: CustomWidget(context: context).CustomSizedTextStyle(
                  22.0,
                  Theme.of(context).splashColor,
                  FontWeight.w500,
                  'FontRegular'),
            ),
            centerTitle: true,
          ),
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
            child: Padding(
              padding: EdgeInsets.only(left: 10.0, right: 10.0),
              child: Stack(
                children: [
                  otcUI(),
                  loading
                      ? CustomWidget(context: context)
                          .loadingIndicator(AppColors.whiteColor)
                      : Container()
                ],
              ),
            ),
          ),
        ));
  }

  Widget otcUI() {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(
            height: 50.0,
          ),
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                      child: Text(
                    "Sell Token",
                    style: CustomWidget(context: context).CustomSizedTextStyle(
                        12.0,
                        Theme.of(context).splashColor,
                        FontWeight.w500,
                        'FontRegular'),
                  )),
                  Row(
                    children: [
                      Text(
                        "Total Balance: ",
                        style: CustomWidget(context: context)
                            .CustomSizedTextStyle(
                                12.0,
                                Theme.of(context).splashColor,
                                FontWeight.w500,
                                'FontRegular'),
                      ),
                      Text(
                        swapVisible
                            ?baseWalletBal.toString():marketWalletBal.toString(),
                        style: CustomWidget(context: context)
                            .CustomSizedTextStyle(
                                12.0,
                                Theme.of(context).splashColor,
                                FontWeight.w500,
                                'FontRegular'),
                      )
                    ],
                  ),
                ],
              ),
              const SizedBox(
                height: 10.0,
              ),
              swapVisible
                  ? Container(
                padding: EdgeInsets.only(
                    left: 10.0, right: 10.0, top: 10.0, bottom: 10.0),
                decoration: BoxDecoration(
                    color: CustomTheme.of(context)
                        .indicatorColor
                        .withOpacity(0.5),
                    borderRadius: BorderRadius.circular(5.0)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.5,
                          height: 40.0,
                          child: TextField(
                            controller: buyAmountController,
                            keyboardType: const TextInputType.numberWithOptions(
                                decimal: true),
                            style: CustomWidget(context: context)
                                .CustomSizedTextStyle(
                                16.0,
                                Theme.of(context).splashColor,
                                FontWeight.w500,
                                'FontRegular'),
                            onChanged: (value) {
                              setState(() {
                                if(value.isNotEmpty){
                                  doCalcSellInstant(selectPairId);
                                }else{
                                  amountController.clear();
                                  amountController.text="";
                                }
                              });
                            },
                            decoration: InputDecoration(
                                contentPadding: EdgeInsets.only(bottom: 8.0),
                                hintText:  minSell.toString()+" > "+maxSell.toString(),
                                hintStyle: CustomWidget(context: context)
                                    .CustomSizedTextStyle(
                                    16.0,
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
                        showSheeetTwo();
                      },
                      child: Row(
                        children: [
                          coinTwoList.length > 0
                              ? Text(
                            selectPairTwo.toString(),
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
                  ],
                ),
              ):
              Container(
                      padding: EdgeInsets.only(
                          left: 10.0, right: 10.0, top: 10.0, bottom: 10.0),
                      decoration: BoxDecoration(
                          color: CustomTheme.of(context)
                              .indicatorColor
                              .withOpacity(0.5),
                          borderRadius: BorderRadius.circular(5.0)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                              child: Container(
                            width: MediaQuery.of(context).size.width * 0.5,
                            height: 40.0,
                            child: TextField(
                              controller: amountController,
                              keyboardType: const TextInputType.numberWithOptions(
                                  decimal: true),
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                              ],
                              style: CustomWidget(context: context)
                                  .CustomSizedTextStyle(
                                      16.0,
                                      Theme.of(context).splashColor,
                                      FontWeight.w500,
                                      'FontRegular'),
                              onChanged: (value) {
                                setState(() {
                                  if(value.isNotEmpty) {
                                    doCalcInstant(selectPairId);
                                  }else{
                                    buyAmountController.clear();
                                    buyAmountController.text="";
                                  }
                                });
                              },
                              decoration: InputDecoration(
                                  contentPadding: EdgeInsets.only(bottom: 8.0),
                                  hintText: minBuy.toString()+" > "+maxBuy.toString(),
                                  hintStyle: CustomWidget(context: context)
                                      .CustomSizedTextStyle(
                                          16.0,
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
                              showSheeet();
                            },
                            child: coinOneList.length > 0
                                ? Text(
                                    selectPair.toString(),
                                    style: CustomWidget(context: context)
                                        .CustomSizedTextStyle(
                                            16.0,
                                            Theme.of(context).splashColor,
                                            FontWeight.w500,
                                            'FontRegular'),
                                  )
                                : Container(),
                          ),
                        ],
                      ),
                    ),
            ],
          ),
          SizedBox(
            height: 20.0,
          ),
          InkWell(
            onTap: () {
              setState(() {
                if (swapVisible) {
                  swapVisible = false;
                } else {
                  swapVisible = true;
                }
              });
            },
            child: Container(
              padding: EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                  color: CustomTheme.of(context).indicatorColor.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(25.0)),
              child: RotatedBox(
                quarterTurns: 1,
                child: Image.asset(
                  'assets/images/two-arrows.png',
                  height: 20.0,
                  width: 20.0,
                  color: CustomTheme.of(context).splashColor,
                ),
              ),
            ),
          ),
          SizedBox(
            height: 20.0,
          ),
          Container(
              child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                      child: Text(
                    "Buy Token",
                    style: CustomWidget(context: context).CustomSizedTextStyle(
                        12.0,
                        Theme.of(context).splashColor,
                        FontWeight.w500,
                        'FontRegular'),
                  )),
                  Row(
                    children: [
                      Text(
                        "Total Balance: ",
                        style: CustomWidget(context: context)
                            .CustomSizedTextStyle(
                                12.0,
                                Theme.of(context).splashColor,
                                FontWeight.w500,
                                'FontRegular'),
                      ),
                      Text(
                        swapVisible
                            ? marketWalletBal:baseWalletBal.toString(),
                        style: CustomWidget(context: context)
                            .CustomSizedTextStyle(
                                12.0,
                                Theme.of(context).splashColor,
                                FontWeight.w500,
                                'FontRegular'),
                      )
                    ],
                  ),
                ],
              ),
              const SizedBox(
                height: 10.0,
              ),
              swapVisible
                  ? Container(
                padding: EdgeInsets.only(
                    left: 10.0, right: 10.0, top: 10.0, bottom: 10.0),
                decoration: BoxDecoration(
                    color: CustomTheme.of(context)
                        .indicatorColor
                        .withOpacity(0.5),
                    borderRadius: BorderRadius.circular(5.0)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.5,
                          height: 40.0,
                          child: TextField(
                            controller: amountController,
                            keyboardType: const TextInputType.numberWithOptions(
                                decimal: true),
                            style: CustomWidget(context: context)
                                .CustomSizedTextStyle(
                                16.0,
                                Theme.of(context).splashColor,
                                FontWeight.w500,
                                'FontRegular'),
                            onChanged: (value) {
                              setState(() {
                                if(value.isNotEmpty){
                                  doCalcInstant(selectPairId);
                                }else{
                                  buyAmountController.clear();
                                  buyAmountController.text="";
                                }
                              });
                            },
                            decoration: InputDecoration(
                                contentPadding: EdgeInsets.only(bottom: 8.0),
                                hintText: minBuy.toString()+" > "+maxBuy.toString(),
                                hintStyle: CustomWidget(context: context)
                                    .CustomSizedTextStyle(
                                    16.0,
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
                        showSheeet();
                      },
                      child: coinOneList.length > 0
                          ? Text(
                        selectPair.toString(),
                        style: CustomWidget(context: context)
                            .CustomSizedTextStyle(
                            16.0,
                            Theme.of(context).splashColor,
                            FontWeight.w500,
                            'FontRegular'),
                      )
                          : Container(),
                    ),
                  ],
                ),
              ):Container(
                      padding: EdgeInsets.only(
                          left: 10.0, right: 10.0, top: 10.0, bottom: 10.0),
                      decoration: BoxDecoration(
                          color: CustomTheme.of(context)
                              .indicatorColor
                              .withOpacity(0.5),
                          borderRadius: BorderRadius.circular(5.0)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                              child: Container(
                            width: MediaQuery.of(context).size.width * 0.5,
                            height: 40.0,
                            child: TextField(
                              controller: buyAmountController,
                              keyboardType: const TextInputType.numberWithOptions(
                                  decimal: true),
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                              ],
                              style: CustomWidget(context: context)
                                  .CustomSizedTextStyle(
                                      16.0,
                                      Theme.of(context).splashColor,
                                      FontWeight.w500,
                                      'FontRegular'),
                              onChanged: (value) {
                                setState(() {
                                  if(value.isNotEmpty){
                                    doCalcSellInstant(selectPairId);
                                }else{
                                    amountController.clear();
                                    amountController.text="";
                                  }
                                });
                              },
                              decoration: InputDecoration(
                                  contentPadding: EdgeInsets.only(bottom: 8.0),
                                  hintText: minSell.toString()+" > "+maxSell.toString(),
                                  hintStyle: CustomWidget(context: context)
                                      .CustomSizedTextStyle(
                                          16.0,
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
                              showSheeetTwo();
                            },
                            child: Row(
                              children: [
                                coinTwoList.length > 0
                                    ? Text(
                                        selectPairTwo.toString(),
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
                        ],
                      ),
                    )
                  ,
            ],
          )),
          SizedBox(
            height: 20.0,
          ),
          Visibility(
            visible: !quoteVisible,
            child: InkWell(
              onTap: () {
                setState(() {
                  if(amountController.text.isNotEmpty && buyAmountController.text.isNotEmpty){
                    quoteVisible=true;
                  }else{
                    quoteVisible=false;
                    if(swapVisible){
                      CustomWidget(context: context).
                      custombar("OTC","Enter the buy token", false);
                    }else{
                      CustomWidget(context: context).
                      custombar("OTC","Enter the sell token", false);
                    }

                  }

                });
              },
              child: Container(
                  width: MediaQuery.of(context).size.width * 0.5,
                  padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5.0),
                    color: CustomTheme.of(context).selectedRowColor,
                  ),
                  child: Center(
                    child: Text(
                      "Request For Quote",
                      style: CustomWidget(context: context).CustomSizedTextStyle(
                          15.0,
                          Theme.of(context).splashColor,
                          FontWeight.w500,
                          'FontRegular'),
                    ),
                  )),
            ),
          ),

          Visibility(
            visible: quoteVisible,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                  height: 10.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Price",
                      style: CustomWidget(context: context).CustomSizedTextStyle(
                          15.0,
                          Theme.of(context).splashColor,
                          FontWeight.w500,
                          'FontRegular'),
                    ),
                    Text(
                     ("1 "+selectPair)+" = "+(livePrice+" "+selectPairTwo),
                      style: CustomWidget(context: context).CustomSizedTextStyle(
                          15.0,
                          Theme.of(context).splashColor,
                          FontWeight.w500,
                          'FontRegular'),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Invest Price",
                      style: CustomWidget(context: context).CustomSizedTextStyle(
                          15.0,
                          Theme.of(context).splashColor,
                          FontWeight.w500,
                          'FontRegular'),
                    ),
                    Text(
                      (buyAmountController.text+" "+selectPairTwo)+" = "+(amountController.text+" "+selectPair),
                      style: CustomWidget(context: context).CustomSizedTextStyle(
                          15.0,
                          Theme.of(context).splashColor,
                          FontWeight.w500,
                          'FontRegular'),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Receive",
                      style: CustomWidget(context: context).CustomSizedTextStyle(
                          15.0,
                          Theme.of(context).splashColor,
                          FontWeight.w500,
                          'FontRegular'),
                    ),
                    Text(
                      (swapVisible?amountController.text:totalPrice)+" "+(swapVisible?selectPair:selectPairTwo),
                      style: CustomWidget(context: context).CustomSizedTextStyle(
                          15.0,
                          Theme.of(context).selectedRowColor,
                          FontWeight.w500,
                          'FontRegular'),
                    ),
                  ],
                ),
                SizedBox(
                  height: 5.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: (){
                        setState(() {
                          quoteVisible=false;
                        });
                      },
                      child: Container(
                        width:MediaQuery.of(context).size.width*0.4 ,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5.0),
                          color: Theme.of(context).highlightColor,
                        ),
                        alignment: Alignment.center,
                        padding: EdgeInsets.only(top: 10.0,bottom: 10.0),
                        child: Text(
                          "Back",
                          style: CustomWidget(context: context).CustomSizedTextStyle(
                              14.0,
                              Theme.of(context).hintColor,
                              FontWeight.w500,
                              'FontRegular'),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: (){
                        setState(() {
                          loading=true;
                        });
                        doInstantPostTrade(selectPairId);
                      },
                      child: Container(
                        width:MediaQuery.of(context).size.width*0.4 ,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5.0),
                          color: Theme.of(context).selectedRowColor,
                        ),
                        alignment: Alignment.center,
                        padding: EdgeInsets.only(top: 10.0,bottom: 10.0),
                        child: Text(
                          "Accept",
                          style: CustomWidget(context: context).CustomSizedTextStyle(
                              14.0,
                              Theme.of(context).splashColor,
                              FontWeight.w500,
                              'FontRegular'),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(
            height: 10.0,
          ),
        ],
      ),
    );
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
                                setState((){
                                  searchPair=[];
                                  for (int m = 0; m < coinOneList.length; m++) {
                                    if(coinOneList[m].marketAsset!.symbol!.toLowerCase().contains(value.toString().toLowerCase())){
                                      searchPair.add(coinOneList[m]);
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
                                searchPair.addAll(coinOneList);
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
                      height: 20.0,
                    ),
                    Expanded(
                        child: ListView.builder(
                            controller: controllerOne,
                            itemCount: searchPair.length,
                            itemBuilder: ((BuildContext context, int index) {
                              return Column(
                                children: [
                                  InkWell(
                                    onTap: () {
                                      // print(searchPair[index].toString());

                                      setState(() {
                                        selectPair =
                                            searchPair[index].marketAsset!.symbol.toString();
                                        print("selectPair" + selectPair);
                                        coinTwoList = [];
                                        searchPairTwo = [];
                                       /* var seen = Set<String>();
                                        coinTwoList = tradePair.where((student) => seen.add(student.baseAsset!.symbol!)).toList();*/
                                        minBuy= searchPair[index].minBuyQuantity!;
                                        minSell= searchPair[index].minSellQuantity!;
                                        maxBuy= searchPair[index].maxBuyQuantity!;
                                        maxSell= searchPair[index].maxSellQuantity!;
                                        for(int m=0;m<tradePair.length;m++ ){
                                          if(selectPair==tradePair[m].marketAsset!.symbol){
                                            coinTwoList.add(tradePair[m]);
                                          }
                                        }
                                        searchController.clear();
                                        print("coinTwoList" + coinTwoList[0].baseAsset!.symbol.toString());
                                        searchPairTwo=coinTwoList;
                                        selectPairTwo=coinTwoList[0].baseAsset!.symbol.toString();
                                          print("hello");
                                          selectPairId =searchPair[index].id! ;
                                          print(selectPairId);
                                          getCoinDetailsList(selectPairId);
                                          amountController.clear();
                                          buyAmountController.clear();
                                          totalPrice="0.00";
                                        // print(coinTwoList);
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
                                          searchPair[index].marketAsset!.symbol.toString(),
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

  showSheeetTwo() {
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
                              controller: searchControllerTwo,
                              focusNode: searchFocus,
                              enabled: true,
                              onEditingComplete: () {
                                setState(() {
                                  searchFocus.unfocus();
                                });
                              },
                              onChanged: (value) {
                                setState((){
                                  searchPairTwo=[];
                                  for (int m = 0; m < coinTwoList.length; m++) {
                                    if(coinTwoList[m].baseAsset!.symbol!.toLowerCase().contains(value.toString().toLowerCase())){
                                      searchPairTwo.add(coinTwoList[m]);
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
                                searchControllerTwo.clear();
                                searchPairTwo.addAll(coinTwoList);
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
                      height: 20.0,
                    ),
                    Expanded(
                        child: ListView.builder(
                            controller: controller,
                            itemCount: searchPairTwo.length,
                            itemBuilder: ((BuildContext context, int index) {
                              return Column(
                                children: [
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        coinOneList = [];
                                        searchPair = [];
                                        selectPairTwo =
                                        searchPairTwo[index].baseAsset!.symbol.toString();
                                        minBuy= searchPairTwo[index].minBuyQuantity!;
                                        minSell= searchPairTwo[index].minSellQuantity!;
                                        maxBuy= searchPairTwo[index].maxBuyQuantity!;
                                        maxSell= searchPairTwo[index].maxSellQuantity!;
                                        for(int m=0;m<tradePair.length;m++ ){
                                          if(selectPairTwo==tradePair[m].baseAsset!.symbol){
                                            coinOneList.add(tradePair[m]);
                                          }
                                        }
                                        searchControllerTwo.clear();
                                        print("coinOneList" + coinOneList[0].marketAsset!.symbol.toString());
                                        searchPair=coinOneList;
                                        selectPair=coinOneList[0].marketAsset!.symbol.toString();
                                        print("hello");
                                        selectPairId =searchPairTwo[index].id!;
                                        print(selectPairId);
                                        getCoinDetailsList(selectPairId);
                                        amountController.clear();
                                        buyAmountController.clear();
                                        totalPrice="0.00";
                                        print(selectPairTwo);
                                         selectPairId= searchPairTwo[index].id!;
                                        print(selectPairId);
                                         getCoinDetailsList(selectPairId);
                                      });
                                      Navigator.pop(context);
                                      amountController.clear();
                                      buyAmountController.clear();
                                      totalPrice="0.00";
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
                                                searchPairTwo[index]
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
                                          searchPairTwo[index].baseAsset!.symbol.toString(),
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

  getCoinList() {
    apiUtils.getTradePair().then((TradePairListModel loginData) {
      if (loginData.statusCode == 200) {
        setState(() {
          tradePair = loginData.data!;
          // tradePair = tradePair.reversed.toList();
          // searchPair = tradePair.reversed.toList();
          var seen = Set<String>();
          coinOneList = tradePair.where((student) => seen.add(student.marketAsset!.symbol!)).toList();
          print(coinOneList[0].marketAsset!.symbol);
          loading = false;
          searchPair=coinOneList ;
          selectPair = coinOneList[0].marketAsset!.symbol.toString();
          for(int m=0;m<tradePair.length;m++ ){
            if(selectPair==tradePair[m].marketAsset!.symbol){
              coinTwoList.add(tradePair[m]);
            }
          }
          print(coinTwoList.length);
          searchPairTwo = coinTwoList;
          selectPairTwo = coinTwoList[0].baseAsset!.symbol.toString();
          selectPairId = coinOneList[0].id!;
          minBuy=coinOneList[0].minBuyQuantity!;
          minSell=coinOneList[0].minSellQuantity!;
          maxBuy=coinOneList[0].maxBuyQuantity!;
          maxSell=coinOneList[0].maxSellQuantity!;
          print(selectPairId);
          getCoinDetailsList(selectPairId);
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
          loading = false;
            marketWalletBal=loginData.data!.marketWallet!.balance!=null?double.parse(loginData.data!.marketWallet!.balance.toString()).toStringAsFixed(8):"0.00";
            baseWalletBal=loginData.data!.baseWallet!.balance!=null?double.parse(loginData.data!.baseWallet!.balance.toString()).toStringAsFixed(8):"0.00";
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

  doCalcInstant(String tId){
    apiUtils.doInstantCalc(tId,amountController.text,"buy-instant").then((InstantValueModel loginData) {
      if (loginData.statusCode == 200) {
        setState(() {
          loading = false;
            livePrice=loginData.data!.liveprice.toString();
            // totalPrice=loginData.data!.totalvalue.toString();
            double tot=double.parse(livePrice)*double.parse(amountController.text);
          totalPrice=tot.toString();
            buyAmountController.text=tot.toString();

        /*  if(!calcInstant){
            buyAmountController.text=loginData.data!.totalvalue!.toString();
          }else{
            amountController.text=loginData.data!.totalvalue!.toString();
          }*/
        });
      } else {
        setState(() {
          loading = false;
        });
      }
    }).catchError((Object error) {
      print(error);
    });
  }

  doCalcSellInstant(String tId){
    apiUtils.doInstantCalc(tId,buyAmountController.text,"sell-instant").then((InstantValueModel loginData) {
      if (loginData.statusCode == 200) {
        setState(() {
          loading = false;

            livePrice=loginData.data!.liveprice.toString();
            print(livePrice);
            // totalPrice=loginData.data!.totalvalue.toString();
            double tot=double.parse(buyAmountController.text)/double.parse(livePrice);
            print("tot"+tot.toString());
            totalPrice=tot.toString();
            amountController.text=tot.toString();


        /*  if(!calcInstant){
            buyAmountController.text=loginData.data!.totalvalue!.toString();
          }else{
            amountController.text=loginData.data!.totalvalue!.toString();
          }*/
        });
      } else {
        setState(() {
          loading = false;
        });
      }
    }).catchError((Object error) {
      print(error);
    });
  }

  doInstantPostTrade(String tId){
    apiUtils.doInstantTrade(tId,swapVisible?buyAmountController.text:amountController.text,swapVisible?"sell-instant":"buy-instant").then((InstantTradeModel loginData) {
      if (loginData.statusCode == 200) {
        setState(() {
          loading = false;
          quoteVisible=false;
          amountController.clear();
          buyAmountController.clear();
          getCoinDetailsList(tId);
          CustomWidget(context: context).
          custombar("OTC", loginData.message.toString(), true);
        });
      } else {
        setState(() {
          loading = false;
          CustomWidget(context: context).
          custombar("OTC", loginData.message.toString(), false);
        });
      }
    }).catchError((Object error) {
      print(error);
    });
  }


}
