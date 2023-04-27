import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:h2_crypto/common/colors.dart';
import 'package:h2_crypto/common/custom_widget.dart';
import 'package:h2_crypto/common/localization/localizations.dart';
import 'package:h2_crypto/common/theme/custom_theme.dart';
import 'package:h2_crypto/data/model/get_payment_details_model.dart';
import 'package:h2_crypto/data/model/get_post_ad_model.dart';
import 'package:h2_crypto/data/model/my_ad_details_model.dart';
import 'package:h2_crypto/data/model/my_ads_model.dart';
import 'package:h2_crypto/data/model/p2p_live_price_model.dart';
import 'package:h2_crypto/data/model/purchased_ad_model.dart';
import 'package:h2_crypto/screens/basic/home.dart';
import 'package:h2_crypto/screens/p2p/p2p_myAd_details.dart';
import 'package:h2_crypto/screens/p2p/p2p_payment_details.dart';
import 'package:h2_crypto/screens/side_menu/profile/payment_method.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/api_utils.dart';
import '../../data/model/post_add_model.dart';

class P2pHome extends StatefulWidget {
  const P2pHome({Key? key}) : super(key: key);

  @override
  State<P2pHome> createState() => _P2pHomeState();
}

enum AssetCoin { BTC, USDT }

enum PriceType { Fixed, Float }

enum CashType { INR }

class _P2pHomeState extends State<P2pHome> with TickerProviderStateMixin {
  ScrollController controller = ScrollController();
  bool newAd = true;
  bool myAd = false;
  bool myAdDetails = false;
  bool myPurchaseAd = false;
  bool campaign = false;
  bool createadgrp = false;
  bool cretaeAd = false;
  bool buySell = true;
  bool fixedVal = true;
  bool imps = false;
  bool upi = false;
  bool neft = false;
  bool _validate = false;
  bool _validateQuantity  = false;
  bool _minvalidate = false;
  bool _minvalvalidate = false;
  bool _maxvalidate = false;
  final paymentformKey = GlobalKey<FormState>();
  List<MyAdDetailsData> postDataListValue = [];
  List<MyAdDetailsData> postDataList = [];
  List<MyAdsData> myAdssDataList = [];
  List<MyAdsData> myAdsDataList = [];
  List<MyAdDetailsData> purchaseAdssDataList = [];
  List<MyAdDetailsData> purchaseAdsDataList = [];
  List<String> coinlist = [];
  List<String> myAdType = ["Buy","Sell"];
  List<String> chartTime = ["Ten", "Twenty", "Thirty"];
  List<String> faitlist = ["Fiat", "Twenty", "Thirty"];
  List<String> Payments = ["Payment", "Twenty", "Thirty"];
  List<String> Region = ["All Regions", "Twenty", "Thirty"];
  String selectedValue = "";
  String selectedMyAdValue = "";
  String selectedPurchaseAdValue = "";
  String selectedVal = "";
  String selectedFiat = "";
  String selectedPay = "";
  String userId = "";
  String error = "";
  String selectedRegion = "";
  late TabController tabController;
  TextEditingController amountController = TextEditingController();
  TextEditingController amountgroupController = TextEditingController();
  TextEditingController quantityController = TextEditingController();
  TextEditingController minController = TextEditingController();
  TextEditingController maxController = TextEditingController();
  List advertise = [];
  String buycash = "";
  String sellcash = "";
  String selCoin = "btc";
  TextEditingController priceController = TextEditingController();
  AssetCoin buyassetCoin = AssetCoin.BTC;
  AssetCoin sellassetCoin = AssetCoin.BTC;
  CashType cashType = CashType.INR;
  PriceType priceType = PriceType.Fixed;
  APIUtils apiUtils = APIUtils();
  bool loading = false;
  P2PLivePrice? selectAssetPrice;
  PostAdd? postAddData;
  String type = "sell";
  String typeView = "buy";
  List<String>cPayments=[];
  List<String> pay_type=[];
  String paymentType = "";
  String payType = "";
  List<ListTileModel> checkboxItems = [];

  // String price = selectAssetPrice!.lastPrice.toString();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      /*  selectedVal=chartTime.first.toString();
      selectedFiat=faitlist.first.toString();
      selectedPay=Payments.first.toString();
      selectedRegion=Region.first.toString();*/
      selectedMyAdValue=myAdType.first.toString();
      selectedPurchaseAdValue=myAdType.first.toString();
      readJson();
      getAssetLivePrice();
      tabController = TabController(vsync: this, length: 2);
      getUserId();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              setState(() {
                 /* Navigator.pop(context);*/
                if(cretaeAd) {
                  campaign = false;
                  createadgrp = true;
                  cretaeAd=false;
                  _validate = false;
                  _maxvalidate = false;
                  _minvalidate = false;
                }else if(createadgrp){
                  campaign = true;
                  createadgrp = false;
                  _validate = false;
                  _maxvalidate = false;
                  _minvalidate = false;
                }else{
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>Home()));
                }

              });
            },
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
          title: Text(
            "P2P",
            style: CustomWidget(context: context).CustomSizedTextStyle(22.0,
                Theme.of(context).splashColor, FontWeight.w500, 'FontRegular'),
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
          child: Stack(
            children: [
              SingleChildScrollView(
                controller: controller,
                child: Column(
                  children: [
                    SizedBox(
                      height: 5.0,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                     height: 30.0,
                      decoration:BoxDecoration(
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
                                  campaign = false;
                                  cretaeAd = false;
                                  createadgrp = false;
                                  newAd = true;
                                  myAd = false;
                                  myAdDetails = false;
                                  myPurchaseAd = false;
                                  quantityController.clear();
                                });
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: newAd
                                            ? CustomTheme.of(context)
                                            .buttonColor
                                            : CustomTheme.of(context)
                                            .splashColor
                                            .withOpacity(0.5),
                                        width: newAd ? 1.5 : 0.5)),
                                child: Center(
                                    child: Padding(
                                      padding: EdgeInsets.all(5.0),
                                      child: Text(
                                        AppLocalizations.instance
                                            .text("loc_p2p_home_txt3"),
                                        style: CustomWidget(context: context)
                                            .CustomSizedTextStyle(
                                            13.0,
                                            newAd
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
                            flex: 2,
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  if (checkboxItems.isEmpty) {

                                    Navigator.of(context)
                                        .push(
                                      MaterialPageRoute(
                                          builder: (_) =>Payment_Method_Screen( )),
                                    )
                                        .then((val) {
                                      (val == true || val == null) ? _getRequests() : null;
                                    });
                                  } else {
                                    campaign=true;
                                    newAd = false;
                                    myAd = false;
                                    myAdDetails = false;
                                    myPurchaseAd = false;
                                    quantityController.clear();
                                  }
                                });
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: campaign||cretaeAd||createadgrp
                                            ? CustomTheme.of(context)
                                            .buttonColor
                                            : CustomTheme.of(context)
                                            .splashColor
                                            .withOpacity(0.5),
                                        width: campaign||cretaeAd||createadgrp ? 1.5 : 0.5)),
                                child: Center(
                                    child: Padding(
                                      padding: EdgeInsets.all(5.0),
                                      child: Text(
                                        AppLocalizations.instance
                                            .text("loc_p2p_new_ad_txt3"),
                                        style: CustomWidget(context: context)
                                            .CustomSizedTextStyle(
                                            13.0,
                                            campaign||cretaeAd||createadgrp
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
                          ),
                          Flexible(child: GestureDetector(
                            onTap: () {
                              setState(() {
                                campaign = false;
                                cretaeAd = false;
                                createadgrp = false;
                                newAd = false;
                                myAd = true;
                                myPurchaseAd = false;
                                quantityController.clear();
                              });
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: myAd||myAdDetails
                                          ? CustomTheme.of(context)
                                          .buttonColor
                                          : CustomTheme.of(context)
                                          .splashColor
                                          .withOpacity(0.5),
                                      width: myAd||myAdDetails ? 1.5 : 0.5)),
                              child: Center(
                                  child: Padding(
                                    padding: EdgeInsets.all(5.0),
                                    child: Text(
                                      AppLocalizations.instance
                                          .text("loc_p2p_my_ad_txt3"),
                                      style: CustomWidget(context: context)
                                          .CustomSizedTextStyle(
                                          13.0,
                                          myAd||myAdDetails
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
                          ),flex: 1,),
                          Flexible(
                            child:   GestureDetector(
                              onTap: () {
                                setState(() {
                                  campaign = false;
                                  cretaeAd = false;
                                  createadgrp = false;
                                  newAd = false;
                                  myAd = false;
                                  myAdDetails = false;
                                  myPurchaseAd = true;
                                  quantityController.clear();
                                });
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: myPurchaseAd
                                            ? CustomTheme.of(context)
                                            .buttonColor
                                            : CustomTheme.of(context)
                                            .splashColor
                                            .withOpacity(0.5),
                                        width: myPurchaseAd ? 1.5 : 0.5)),
                                child: Center(
                                    child: Padding(
                                      padding: EdgeInsets.all(5.0),
                                      child: Text(
                                        AppLocalizations.instance
                                            .text("loc_p2p_my_purchase_ad_txt3"),
                                        // maxLines: 1,
                                        // overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontSize:  13.0,
                                          color:  myPurchaseAd
                                              ? CustomTheme.of(context)
                                              .splashColor
                                              : CustomTheme.of(context)
                                              .hintColor
                                              .withOpacity(0.5),
                                          fontFamily: 'FontRegular',
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    )),
                              ),
                            ),
                            flex: 2,
                          )
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    campaign
                        ? postTradeUI()
                        : createadgrp
                        ? postTradeUI():cretaeAd
                        ? postTradeUI():Column(
                                children: [
                                  newAd?OrderWidget():SizedBox(),
                                  SizedBox(
                                    height: 15.0,
                                  ),
                                  newAd
                                      ? openOrdersUIS()
                                      : myAd
                                          ? myAdsUIS():myPurchaseAd?purchaseAdsUIS()
                                          : Container(
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.3,
                                              color: Theme.of(context)
                                                  .primaryColor
                                                  .withOpacity(0.5),
                                              child: Center(
                                                child: Text(
                                                  "No Records Found..!",
                                                  style: CustomWidget(
                                                          context: context)
                                                      .CustomSizedTextStyle(
                                                          12.0,
                                                          Theme.of(context)
                                                              .splashColor,
                                                          FontWeight.w400,
                                                          'FontRegular'),
                                                ),
                                              ),
                                            ),
                                ],
                              ),
                  ],
                ),
              ),
              loading
                  ? CustomWidget(context: context).loadingIndicator(
                      CustomTheme.of(context).splashColor,
                    )
                  : Container()
            ],
          ),
        ),
      ),
    );
  }

  Widget OrderWidget() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(
          height: 15.0,
        ),
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
                      postDataList = [];
                      coinlist = [];
                      postDataListValue = [];
                      type = "sell";
                      getAllpostAd("sell", "");
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
                    postDataList = [];
                    coinlist = [];
                    postDataListValue = [];
                    type = "buy";
                    getAllpostAd("buy", "");
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
          height: 45.0,
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
                items: coinlist
                    .map((value) => DropdownMenuItem(
                          child: Text(
                            value.toString(),
                            style: CustomWidget(context: context)
                                .CustomSizedTextStyle(
                                    12.0,
                                    Theme.of(context).errorColor,
                                    FontWeight.w500,
                                    'FontRegular'),
                          ),
                          value: value,
                        ))
                    .toList(),
                onChanged: (value) async {
                  setState(() {
                    selectedValue = value.toString();
                    loading=true;
                    postDataList= [];
                    getAllpostAd(type, selectedValue);
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
                value: selectedValue,
                icon: const Icon(
                  Icons.arrow_drop_down,
                  // color: AppColors.otherTextColor,
                ),
              ),
            ),
          ),
        ),
        SizedBox(
          height: 10.0,
        ),
        /* Container(
          padding: EdgeInsets.fromLTRB(5.0, 0.0, 0.0, 0.0),
          decoration: BoxDecoration(
            border: Border.all(
                color: CustomTheme.of(context).hintColor.withOpacity(0.5),
                width: 1.0),
            borderRadius: BorderRadius.circular(5.0),
            color: Colors.transparent,
          ),
          height: 45.0,
          child: TextField(
            controller: amountController,
            keyboardType:
            const TextInputType.numberWithOptions(decimal: true),
            style: CustomWidget(context: context).CustomSizedTextStyle(
                12.0,
                Theme.of(context).splashColor,
                FontWeight.w500,
                'FontRegular'),
            onChanged: (value) {
              setState(() {
              });
            },
            decoration: InputDecoration(
                contentPadding: EdgeInsets.only(bottom: 8.0),
                hintText: "Quantity",
                hintStyle: CustomWidget(context: context)
                    .CustomSizedTextStyle(
                    12.0,
                    Theme.of(context).splashColor,
                    FontWeight.w500,
                    'FontRegular'),
                border: InputBorder.none),
            textAlign: TextAlign.start,
          ),
        ),
        SizedBox(
          height: 15.0,
        ),
        Container(
          width: MediaQuery.of(context).size.width,
          height: 45.0,
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
                        12.0,
                        Theme.of(context).errorColor,
                        FontWeight.w500,
                        'FontRegular'),
                  ),
                  value: value,
                ))
                    .toList(),
                onChanged: (value) async {
                  setState(() {
                    selectedVal = value.toString();
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
                value: selectedVal,
                icon: const Icon(
                  Icons.arrow_drop_down,
                  // color: AppColors.otherTextColor,
                ),
              ),
            ),
          ),
        ),
        SizedBox(
          height: 15.0,
        ),
        Container(
          width: MediaQuery.of(context).size.width,
          height: 45.0,
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
                items: faitlist
                    .map((value) => DropdownMenuItem(
                  child: Text(
                    value.toString(),
                    style: CustomWidget(context: context)
                        .CustomSizedTextStyle(
                        12.0,
                        Theme.of(context).errorColor,
                        FontWeight.w500,
                        'FontRegular'),
                  ),
                  value: value,
                ))
                    .toList(),
                onChanged: (value) async {
                  setState(() {
                    selectedFiat = value.toString();
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
                value: selectedFiat,
                icon: const Icon(
                  Icons.arrow_drop_down,
                  // color: AppColors.otherTextColor,
                ),
              ),
            ),
          ),
        ),
        SizedBox(
          height: 15.0,
        ),
        Container(
          width: MediaQuery.of(context).size.width,
          height: 45.0,
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
                items: Payments
                    .map((value) => DropdownMenuItem(
                  child: Text(
                    value.toString(),
                    style: CustomWidget(context: context)
                        .CustomSizedTextStyle(
                        12.0,
                        Theme.of(context).errorColor,
                        FontWeight.w500,
                        'FontRegular'),
                  ),
                  value: value,
                ))
                    .toList(),
                onChanged: (value) async {
                  setState(() {
                    selectedPay = value.toString();
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
                value: selectedPay,
                icon: const Icon(
                  Icons.arrow_drop_down,
                  // color: AppColors.otherTextColor,
                ),
              ),
            ),
          ),
        ),
        SizedBox(
          height: 15.0,
        ),
        Container(
          width: MediaQuery.of(context).size.width,
          height: 45.0,
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
                items: Region
                    .map((value) => DropdownMenuItem(
                  child: Text(
                    value.toString(),
                    style: CustomWidget(context: context)
                        .CustomSizedTextStyle(
                        12.0,
                        Theme.of(context).errorColor,
                        FontWeight.w500,
                        'FontRegular'),
                  ),
                  value: value,
                ))
                    .toList(),
                onChanged: (value) async {
                  setState(() {
                    selectedRegion = value.toString();
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
                value: selectedRegion,
                icon: const Icon(
                  Icons.arrow_drop_down,
                  // color: AppColors.otherTextColor,
                ),
              ),
            ),
          ),
        ),
        SizedBox(
          height: 15.0,
        ),*/
      ],
    );
  }

  Widget postTradeUI() {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 10.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: 40.0,
                width: 40.0,
                decoration: BoxDecoration(
                  color: Theme.of(context).indicatorColor,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: campaign
                      ? Text(
                          "1",
                          style: CustomWidget(context: context)
                              .CustomSizedTextStyle(12.0, AppColors.whiteColor,
                                  FontWeight.w500, 'FontRegular'),
                        )
                      : Icon(
                          Icons.done_outlined,
                          color: AppColors.whiteColor,
                        ),
                ),
              ),
              Container(
                alignment: Alignment.center,
                color: AppColors.whiteColor,
                height: 2.0,
                width: MediaQuery.of(context).size.width * 0.3,
              ),
              Container(
                height: 40.0,
                width: 40.0,
                decoration: BoxDecoration(
                  color: cretaeAd||createadgrp ? Theme.of(context).indicatorColor : Color(0xFF919191),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: !cretaeAd?Text(
                    "2",
                    style: CustomWidget(context: context).CustomSizedTextStyle(
                        12.0,
                        AppColors.whiteColor,
                        FontWeight.w500,
                        'FontRegular'),
                  ): Icon(
                  Icons.done_outlined,
                  color: AppColors.whiteColor,
                ),
                ),
              ),
              Container(
                alignment: Alignment.center,
                color: AppColors.whiteColor,
                height: 2.0,
                width: MediaQuery.of(context).size.width * 0.3,
              ),
              Container(
                height: 40.0,
                width: 40.0,
                decoration: BoxDecoration(
                  color: cretaeAd ? Theme.of(context).indicatorColor : Color(0xFF919191),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    "3",
                    style: CustomWidget(context: context).CustomSizedTextStyle(
                        12.0,
                        AppColors.whiteColor,
                        FontWeight.w500,
                        'FontRegular'),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 10.0,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 20.0,
              ),
              Expanded(
                child: Text(
                  "Select master blaster campaign settings",
                  style: CustomWidget(context: context).CustomSizedTextStyle(
                      14.0,
                      Theme.of(context).splashColor,
                      FontWeight.w500,
                      'FontRegular'),
                ),
              ),
              Expanded(
                child: Text(
                  "Create an ad group with payment",
                  style: CustomWidget(context: context).CustomSizedTextStyle(
                      14.0,
                      Theme.of(context).splashColor,
                      FontWeight.w500,
                      'FontRegular'),
                ),
              ),
              Expanded(
                child: Center(
                  child: Text(
                    "Create an ad",
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
          SizedBox(
            height: 20.0,
          ),
          Container(
            height: cretaeAd?MediaQuery.of(context).size.height * 0.4:MediaQuery.of(context).size.height * 0.4,
            child: campaign
                ? NestedScrollView(
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
                            onTap: (v) {
                              print(v);
                              if (v == 0) {
                                typeView = "buy";
                              } else {
                                typeView = "sell";
                              }
                            },
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
                                text: "I want to Buy",
                              ),
                              Tab(
                                text: "I want to Sell",
                              ),
                            ],
                            controller: tabController,
                          ),
                        ),
                      ];
                    },
                    body: Container(
                      color: CustomTheme.of(context).backgroundColor,
                      height: MediaQuery.of(context).size.height,
                      child: TabBarView(
                        children: <Widget>[buyUI(), sellUI()],
                        controller: tabController,
                      ),
                    ),
                  )
                : createadgrp
                    ? Column(
                        children: [
                          SizedBox(
                            height: 10.0,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(
                              5.0,
                            ),
                            child: TextField(
                              controller: amountgroupController,
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                      decimal: true),
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                              ],
                              style: CustomWidget(context: context)
                                  .CustomSizedTextStyle(
                                      13.0,
                                      Theme.of(context).splashColor,
                                      FontWeight.w500,
                                      'FontRegular'),
                              onChanged: (value) {
                                setState(() {
                                  if (value.isEmpty) {
                                    _validate = true;
                                    _maxvalidate=true;
                                    maxController.clear();
                                  } else {
                                    _validate = false;
                                    _maxvalidate=false;
                                    maxController.text = value.toString();
                                  }
                                });
                              },
                              decoration: InputDecoration(
                                errorText: _validate
                                    ? 'Enter the Quantity'
                                    : null,
                                errorStyle: CustomWidget(context: context)
                                    .CustomSizedTextStyle(
                                        12.0,
                                        Theme.of(context)
                                            .scaffoldBackgroundColor,
                                        FontWeight.w500,
                                        'FontRegular'),
                                contentPadding: // Text Field height
                                    EdgeInsets.symmetric(
                                        vertical: 10.0, horizontal: 10.0),
                                hintText: "Quantity",
                                hintStyle: CustomWidget(context: context)
                                    .CustomSizedTextStyle(
                                        12.0,
                                        Theme.of(context)
                                            .splashColor
                                            .withOpacity(0.5),
                                        FontWeight.w500,
                                        'FontRegular'),
                                errorBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: CustomTheme.of(context)
                                        .hintColor
                                        .withOpacity(0.5),
                                    width: 1.0,
                                  ),
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                                disabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: CustomTheme.of(context)
                                        .hintColor
                                        .withOpacity(0.5),
                                    width: 1.0,
                                  ),
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: CustomTheme.of(context)
                                        .hintColor
                                        .withOpacity(0.5),
                                    width: 1.0,
                                  ),
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: CustomTheme.of(context)
                                        .hintColor
                                        .withOpacity(0.5),
                                    width: 1.0,
                                  ),
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                              ),
                              textAlign: TextAlign.start,
                            ),
                          ),
                          SizedBox(
                            height: 15.0,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Flexible(
                                  child: TextField(
                                    controller: minController,
                                    keyboardType:
                                        const TextInputType.numberWithOptions(
                                            decimal: true),
                                    inputFormatters: <TextInputFormatter>[
                                      FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                                    ],
                                    style: CustomWidget(context: context)
                                        .CustomSizedTextStyle(
                                            13.0,
                                            Theme.of(context).splashColor,
                                            FontWeight.w500,
                                            'FontRegular'),
                                    onChanged: (value) {
                                      setState(() {
                                        if (value.isEmpty) {
                                          _minvalidate = true;
                                        } else {
                                          _minvalidate = false;
                                          if (double.parse(
                                                  maxController.text.toString()) <
                                              double.parse(minController.text
                                                  .toString())) {
                                            _minvalvalidate = true;
                                            minController.clear();
                                          } else {
                                            _minvalvalidate = false;
                                          }
                                        }
                                      });
                                    },
                                    decoration: InputDecoration(
                                      errorText: _minvalidate
                                          ? 'Enter the Min limit'
                                          : _minvalvalidate
                                              ? "Min value less than maxlimit"
                                              : null,
                                      errorStyle: CustomWidget(context: context)
                                          .CustomSizedTextStyle(
                                              12.0,
                                              Theme.of(context)
                                                  .scaffoldBackgroundColor,
                                              FontWeight.w500,
                                              'FontRegular'),
                                      contentPadding: // Text Field height
                                          EdgeInsets.symmetric(
                                              vertical: 10.0, horizontal: 10.0),
                                      hintText: "Min Limit",
                                      hintStyle: CustomWidget(context: context)
                                          .CustomSizedTextStyle(
                                              12.0,
                                              Theme.of(context)
                                                  .splashColor
                                                  .withOpacity(0.5),
                                              FontWeight.w500,
                                              'FontRegular'),
                                      suffixIcon: Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 15.0),
                                        child: Text(
                                          "INR",
                                          textAlign: TextAlign.center,
                                          style: CustomWidget(context: context)
                                              .CustomSizedTextStyle(
                                                  12.0,
                                                  Theme.of(context)
                                                      .splashColor
                                                      .withOpacity(0.5),
                                                  FontWeight.w500,
                                                  'FontRegular'),
                                        ),
                                      ),
                                      disabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: CustomTheme.of(context)
                                              .hintColor
                                              .withOpacity(0.5),
                                          width: 1.0,
                                        ),
                                        borderRadius: BorderRadius.circular(5.0),
                                      ),
                                      errorBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: CustomTheme.of(context)
                                              .hintColor
                                              .withOpacity(0.5),
                                          width: 1.0,
                                        ),
                                        borderRadius: BorderRadius.circular(5.0),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: CustomTheme.of(context)
                                              .hintColor
                                              .withOpacity(0.5),
                                          width: 1.0,
                                        ),
                                        borderRadius: BorderRadius.circular(5.0),
                                      ),
                                      border: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: CustomTheme.of(context)
                                              .hintColor
                                              .withOpacity(0.5),
                                          width: 1.0,
                                        ),
                                        borderRadius: BorderRadius.circular(5.0),
                                      ),
                                    ),
                                    textAlign: TextAlign.start,
                                  ),
                                ),
                                SizedBox(
                                  width: 5.0,
                                ),
                                Flexible(
                                  child: TextField(
                                    controller: maxController,
                                    enabled: false,
                                    keyboardType:
                                        const TextInputType.numberWithOptions(
                                            decimal: true),
                                    inputFormatters: <TextInputFormatter>[
                                      FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                                    ],
                                    style: CustomWidget(context: context)
                                        .CustomSizedTextStyle(
                                            12.0,
                                            Theme.of(context).splashColor,
                                            FontWeight.w500,
                                            'FontRegular'),
                                    onChanged: (value) {
                                      setState(() {
                                        if (value.isEmpty) {
                                          _maxvalidate = true;
                                        } else {
                                          _maxvalidate = false;
                                        }
                                      });
                                    },
                                    decoration: InputDecoration(
                                      errorText: _maxvalidate
                                          ? 'Enter the Max limit'
                                          : null,
                                      errorStyle: CustomWidget(context: context)
                                          .CustomSizedTextStyle(
                                              12.0,
                                              Theme.of(context)
                                                  .scaffoldBackgroundColor,
                                              FontWeight.w500,
                                              'FontRegular'),
                                      contentPadding: // Text Field height
                                          EdgeInsets.symmetric(
                                              vertical: 10.0, horizontal: 10.0),
                                      hintText: "Max Limit",
                                      hintStyle: CustomWidget(context: context)
                                          .CustomSizedTextStyle(
                                              12.0,
                                              Theme.of(context)
                                                  .splashColor
                                                  .withOpacity(0.5),
                                              FontWeight.w500,
                                              'FontRegular'),
                                      suffixIcon: Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 15.0),
                                        child: Text(
                                          "INR",
                                          textAlign: TextAlign.center,
                                          style: CustomWidget(context: context)
                                              .CustomSizedTextStyle(
                                                  12.0,
                                                  Theme.of(context)
                                                      .splashColor
                                                      .withOpacity(0.5),
                                                  FontWeight.w500,
                                                  'FontRegular'),
                                        ),
                                      ),
                                      disabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: CustomTheme.of(context)
                                              .hintColor
                                              .withOpacity(0.5),
                                          width: 1.0,
                                        ),
                                        borderRadius: BorderRadius.circular(5.0),
                                      ),
                                      errorBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                            color: CustomTheme.of(context)
                                                .hintColor
                                                .withOpacity(0.5),
                                            width: 1.0,
                                          ),
                                          borderRadius: BorderRadius.circular(5.0),
                                        ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: CustomTheme.of(context)
                                              .hintColor
                                              .withOpacity(0.5),
                                          width: 1.0,
                                        ),
                                        borderRadius: BorderRadius.circular(5.0),
                                      ),
                                      border: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: CustomTheme.of(context)
                                              .hintColor
                                              .withOpacity(0.5),
                                          width: 1.0,
                                        ),
                                        borderRadius: BorderRadius.circular(5.0),
                                      ),
                                    ),
                                    textAlign: TextAlign.start,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 20.0,
                          ),
                          InkWell(
                            onTap: () {
                              setState(() {
                                if (amountgroupController.text.isEmpty &&
                                    minController.text.isEmpty &&
                                    maxController.text.isEmpty) {
                                  _validate = true;
                                  _maxvalidate = true;
                                  _minvalidate = true;
                                } else {
                                  checkboxItems=[];
                                  cPayments=[];
                                  for(int m=0;m<pay_type.length;m++){
                                    checkboxItems.add(ListTileModel(
                                        false,
                                        pay_type[m].toString()
                                    ));
                                  }
                                  showPaymentDialog();
                                }
                              });
                            },
                            child: Container(
                                width: MediaQuery.of(context).size.width * 0.5,
                                padding:
                                    EdgeInsets.only(top: 10.0, bottom: 10.0),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5.0),
                                  color: Theme.of(context).indicatorColor,
                                ),
                                child: Center(
                                  child: Text(
                                    "Choose Payment".toUpperCase(),
                                    style: CustomWidget(context: context)
                                        .CustomSizedTextStyle(
                                            14.0,
                                            Theme.of(context).splashColor,
                                            FontWeight.w500,
                                            'FontRegular'),
                                  ),
                                )),
                          ),
                          SizedBox(height: 10.0,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Selected Payment Method : ",
                                style: CustomWidget(context: context).CustomSizedTextStyle(
                                    18.0,
                                    Theme.of(context).splashColor,
                                    FontWeight.w500,
                                    'FontRegular'),
                              ),
                              Flexible(
                                child: Text(
                                  payType==""?"-":payType.toString(),
                                  style: CustomWidget(context: context).CustomSizedTextStyle(
                                      18.0,
                                      Theme.of(context).splashColor,
                                      FontWeight.w500,
                                      'FontRegular'),
                                ),
                              ),
                            ],
                          ),
                        ],
                      )
                    :cretaeAd?Column(
                        children: [
                          Center(
                            child: Text(
                              "Please confirm the details before creating an ad. Once created it cannot be edited or deleted",
                              style: CustomWidget(context: context).CustomSizedTextStyle(
                                  16.0,
                                  Theme.of(context).splashColor,
                                  FontWeight.w500,
                                  'FontRegular'),
                            ),
                          ),
                          SizedBox(height: 10.0,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Ad Type : ",
                                style: CustomWidget(context: context).CustomSizedTextStyle(
                                    18.0,
                                    Theme.of(context).splashColor,
                                    FontWeight.w500,
                                    'FontRegular'),
                              ),
                              Text(
                                typeView.toString().toUpperCase(),
                                style: CustomWidget(context: context).CustomSizedTextStyle(
                                    16.0,
                                    Theme.of(context).splashColor,
                                    FontWeight.w500,
                                    'FontRegular'),
                              ),
                            ],
                          ),
                          SizedBox(height: 10.0,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Asset : ",
                                style: CustomWidget(context: context).CustomSizedTextStyle(
                                    18.0,
                                    Theme.of(context).splashColor,
                                    FontWeight.w500,
                                    'FontRegular'),
                              ),
                              Text(
                                selCoin.toString().toUpperCase(),
                                style: CustomWidget(context: context).CustomSizedTextStyle(
                                    16.0,
                                    Theme.of(context).splashColor,
                                    FontWeight.w500,
                                    'FontRegular'),
                              ),
                            ],
                          ),
                          SizedBox(height: 10.0,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Live Price : ",
                                style: CustomWidget(context: context).CustomSizedTextStyle(
                                    18.0,
                                    Theme.of(context).splashColor,
                                    FontWeight.w500,
                                    'FontRegular'),
                              ),
                              Text(
                                selectAssetPrice!.lastPrice.toString(),
                                style: CustomWidget(context: context).CustomSizedTextStyle(
                                    16.0,
                                    Theme.of(context).splashColor,
                                    FontWeight.w500,
                                    'FontRegular'),
                              ),
                            ],
                          ),
                          SizedBox(height: 10.0,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Quantity : ",
                                style: CustomWidget(context: context).CustomSizedTextStyle(
                                    18.0,
                                    Theme.of(context).splashColor,
                                    FontWeight.w500,
                                    'FontRegular'),
                              ),
                              Text(
                                amountgroupController.text.toString(),
                                style: CustomWidget(context: context).CustomSizedTextStyle(
                                    16.0,
                                    Theme.of(context).splashColor,
                                    FontWeight.w500,
                                    'FontRegular'),
                              ),
                            ],
                          ),
                          SizedBox(height: 10.0,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Min : ",
                                style: CustomWidget(context: context).CustomSizedTextStyle(
                                    18.0,
                                    Theme.of(context).splashColor,
                                    FontWeight.w500,
                                    'FontRegular'),
                              ),
                              Text(
                                minController.text.toString(),
                                style: CustomWidget(context: context).CustomSizedTextStyle(
                                    16.0,
                                    Theme.of(context).splashColor,
                                    FontWeight.w500,
                                    'FontRegular'),
                              ),
                            ],
                          ),
                          SizedBox(height: 10.0,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Max : ",
                                style: CustomWidget(context: context).CustomSizedTextStyle(
                                    18.0,
                                    Theme.of(context).splashColor,
                                    FontWeight.w500,
                                    'FontRegular'),
                              ),
                              Text(
                                maxController.text.toString(),
                                style: CustomWidget(context: context).CustomSizedTextStyle(
                                    16.0,
                                    Theme.of(context).splashColor,
                                    FontWeight.w500,
                                    'FontRegular'),
                              ),
                            ],
                          ),
                          SizedBox(height: 10.0,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Payment Type : ",
                                style: CustomWidget(context: context).CustomSizedTextStyle(
                                    18.0,
                                    Theme.of(context).splashColor,
                                    FontWeight.w500,
                                    'FontRegular'),
                              ),
                              Text(
                                payType==""?"-":payType.toString().toUpperCase(),
                                style: CustomWidget(context: context).CustomSizedTextStyle(
                                    16.0,
                                    Theme.of(context).splashColor,
                                    FontWeight.w500,
                                    'FontRegular'),
                              ),
                            ],
                          ),

                        ],
                      ):SizedBox(),
          ),
          SizedBox(
            height: 15.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              !campaign
                  ? Flexible(
                      child: InkWell(
                        onTap: () {
                          setState(() {
                              if(cretaeAd) {
                                campaign = false;
                                createadgrp = true;
                                cretaeAd=false;
                                _validate = false;
                                _maxvalidate = false;
                                _minvalidate = false;
                              }else{
                                campaign = true;
                                createadgrp = false;
                                _validate = false;
                                _maxvalidate = false;
                                _minvalidate = false;
                              }
                          });
                        },
                        child: Container(
                            width: MediaQuery.of(context).size.width * 0.5,
                            padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5.0),
                              color: Color(0xFF919191),
                            ),
                            child: Center(
                              child: Text(
                                "Back",
                                style: CustomWidget(context: context)
                                    .CustomSizedTextStyle(
                                        14.0,
                                        Theme.of(context).splashColor,
                                        FontWeight.w500,
                                        'FontRegular'),
                              ),
                            )),
                      ),
                    )
                  : SizedBox(),
              SizedBox(
                width: 10.0,
              ),
              Flexible(
                child: InkWell(
                  onTap: () {
                    setState(() {
                      if (selCoin == " ") {
                        CustomWidget(context: context)
                            .custombar("P2P", "Please Select Asset", false);
                      } else {
                            if(campaign){
                              campaign = false;
                              createadgrp = true;
                              cretaeAd = false;
                            } else if(createadgrp){
                              if (amountgroupController.text.isEmpty &&
                                  minController.text.isEmpty &&
                                  maxController.text.isEmpty) {
                                _validate = true;
                                _maxvalidate = true;
                                _minvalidate = true;
                              }else{
                                campaign = false;
                                createadgrp = false;
                                cretaeAd = true;
                              }
                            }else{
                              loading = true;
                              doPostAd();
                            }
                      }
                    });
                  },
                  child: Container(
                      width: MediaQuery.of(context).size.width * 0.5,
                      padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5.0),
                        color: Theme.of(context).indicatorColor,
                      ),
                      child: Center(
                        child: Text(
                          cretaeAd?"Finish":"Next",
                          style: CustomWidget(context: context)
                              .CustomSizedTextStyle(
                                  14.0,
                                  Theme.of(context).splashColor,
                                  FontWeight.w500,
                                  'FontRegular'),
                        ),
                      )),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget createAndGroup() {
    return Column(
      children: [
        SizedBox(
          height: 10.0,
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
          height: 45.0,
          child: TextField(
            controller: amountgroupController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            style: CustomWidget(context: context).CustomSizedTextStyle(13.0,
                Theme.of(context).splashColor, FontWeight.w500, 'FontRegular'),
            onChanged: (value) {
              setState(() {});
            },
            decoration: InputDecoration(
                contentPadding: EdgeInsets.only(bottom: 8.0),
                hintText: "Quantity",
                hintStyle: CustomWidget(context: context).CustomSizedTextStyle(
                    12.0,
                    Theme.of(context).splashColor.withOpacity(0.5),
                    FontWeight.w500,
                    'FontRegular'),
                border: InputBorder.none),
            textAlign: TextAlign.start,
          ),
        ),
        SizedBox(
          height: 15.0,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Flexible(
              child: Container(
                padding: EdgeInsets.fromLTRB(5.0, 0.0, 0.0, 0.0),
                decoration: BoxDecoration(
                  border: Border.all(
                      color: CustomTheme.of(context).hintColor.withOpacity(0.5),
                      width: 1.0),
                  borderRadius: BorderRadius.circular(5.0),
                  color: Colors.transparent,
                ),
                height: 45.0,
                child: TextField(
                  controller: minController,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  style: CustomWidget(context: context).CustomSizedTextStyle(
                      13.0,
                      Theme.of(context).splashColor,
                      FontWeight.w500,
                      'FontRegular'),
                  onChanged: (value) {
                    setState(() {});
                  },
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.only(bottom: 8.0),
                      hintText: "Min Limit",
                      hintStyle: CustomWidget(context: context)
                          .CustomSizedTextStyle(
                              12.0,
                              Theme.of(context).splashColor.withOpacity(0.5),
                              FontWeight.w500,
                              'FontRegular'),
                      suffixIcon: Text(
                        "INR",
                        textAlign: TextAlign.center,
                        style: CustomWidget(context: context)
                            .CustomSizedTextStyle(
                            12.0,
                            Theme.of(context)
                                .splashColor
                                .withOpacity(0.5),
                            FontWeight.w500,
                            'FontRegular'),
                      ),
                      border: InputBorder.none),
                  textAlign: TextAlign.start,
                ),
              ),
            ),
            Flexible(
              child: Container(
                padding: EdgeInsets.fromLTRB(5.0, 0.0, 0.0, 0.0),
                decoration: BoxDecoration(
                  border: Border.all(
                      color: CustomTheme.of(context).hintColor.withOpacity(0.5),
                      width: 1.0),
                  borderRadius: BorderRadius.circular(5.0),
                  color: Colors.transparent,
                ),
                height: 40.0,
                child: TextField(
                  controller: maxController,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  style: CustomWidget(context: context).CustomSizedTextStyle(
                      13.0,
                      Theme.of(context).splashColor,
                      FontWeight.w500,
                      'FontRegular'),
                  onChanged: (value) {
                    setState(() {});
                  },
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.only(bottom: 8.0),
                      hintText: "Max Limit",
                      hintStyle: CustomWidget(context: context)
                          .CustomSizedTextStyle(
                              12.0,
                              Theme.of(context).splashColor.withOpacity(0.5),
                              FontWeight.w500,
                              'FontRegular'),
                      suffixIcon: Text(
                        "INR",
                        textAlign: TextAlign.center,
                        style: CustomWidget(context: context)
                            .CustomSizedTextStyle(
                                12.0,
                                Theme.of(context)
                                    .splashColor
                                    .withOpacity(0.5),
                                FontWeight.w500,
                                'FontRegular'),
                      ),
                      border: InputBorder.none),
                  textAlign: TextAlign.start,
                ),
              ),
            ),
          ],
        ),
        SizedBox(
          height: 10.0,
        ),
        InkWell(
          onTap: () {
            showPaymentDialog();
          },
          child: Container(
              width: MediaQuery.of(context).size.width * 0.5,
              padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5.0),
                color: Theme.of(context).indicatorColor,
              ),
              child: Center(
                child: Text(
                  "Add Payment".toUpperCase(),
                  style: CustomWidget(context: context).CustomSizedTextStyle(
                      14.0,
                      Theme.of(context).splashColor,
                      FontWeight.w500,
                      'FontRegular'),
                ),
              )),
        ),
      ],
    );
  }

  showPaymentDialog() {
    showModalBottomSheet(
        isDismissible: false,
        context: context,
        backgroundColor: CustomTheme.of(context).backgroundColor,
        builder: (context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter ssetState) {
            return Container(
              height: MediaQuery.of(context).size.height * 0.5,
              width: MediaQuery.of(context).size.width,
              color: CustomTheme.of(context).backgroundColor,
              padding: EdgeInsets.all(15.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Payment Method".toUpperCase(),
                    style: CustomWidget(context: context).CustomSizedTextStyle(
                        18.0,
                        Theme.of(context).splashColor,
                        FontWeight.w500,
                        'FontRegular'),
                  ),
                  SizedBox(height: 10.0),
                  Container(
                    height: 220.0,
                    child: ListView(
                        children: checkboxItems
                            .map((item) => CheckboxListTile(
                                  value: item.enabled,
                                  onChanged: (bool? enabled) {
                                    ssetState(() {
                                      item.enabled = enabled!;
                                      if(item.enabled){
                                        cPayments.add(item.text);
                                      }else{
                                        cPayments.remove(item.text);
                                      }
                                      print("paymentT"+cPayments.toString());
                                      payType=cPayments.join(",");
                                      paymentType=cPayments.join(",");
                                      /*paymentType=cPayments.map((e) => '"${e}"').join(",");*/
                                        print("pType"+paymentType);
                                    });
                                  },
                                  title: new Text(
                                    item.text,
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                  controlAffinity:
                                      ListTileControlAffinity.leading,
                                  activeColor: Theme.of(context).indicatorColor,
                                ))
                            .toList()),
                  ),
                  /* Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Row(
                            children: [
                              Checkbox(
                                checkColor: Colors.white,
                                activeColor: Theme.of(context).indicatorColor,
                                value: imps,
                                onChanged: (bool? value) {
                                  ssetState(() {
                                    imps = value!;
                                    if (imps){
                                      paymentType = "imps";
                                    }
                                  });
                                },
                              ),
                              SizedBox(width: 10.0,),
                              Text(
                                "IMPS".toUpperCase(),
                                style: CustomWidget(context: context).CustomSizedTextStyle(
                                    14.0,
                                    Theme.of(context).splashColor,
                                    FontWeight.w500,
                                    'FontRegular'),
                              ),

                            ],
                          ),
                        ),
                        Flexible(
                          child: Row(
                            children: [
                              Checkbox(
                                checkColor: Colors.white,
                                activeColor: Theme.of(context).indicatorColor,
                                value: upi,
                                onChanged: (bool? value) {
                                  ssetState(() {
                                    upi = value!;
                                    if (upi){
                                      paymentType = "upi";
                                    }
                                  });
                                },
                              ),
                              SizedBox(width: 10.0,),
                              Text(
                                "UPI".toUpperCase(),
                                style: CustomWidget(context: context).CustomSizedTextStyle(
                                    14.0,
                                    Theme.of(context).splashColor,
                                    FontWeight.w500,
                                    'FontRegular'),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10.0),
                    Row(
                      children: [
                        Checkbox(
                          checkColor: Colors.white,
                          activeColor: Theme.of(context).indicatorColor,
                          value: neft,
                          onChanged: (bool? value) {
                            ssetState(() {
                              neft = value!;
                              if (neft){
                                paymentType = "neft";
                              }
                            });
                          },
                        ),
                        Text(
                          "NEFT".toUpperCase(),
                          style: CustomWidget(context: context).CustomSizedTextStyle(
                              14.0,
                              Theme.of(context).splashColor,
                              FontWeight.w500,
                              'FontRegular'),
                        ),
                      ],
                    ),*/
                  SizedBox(height: 10.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () {
                          setState(() {
                            if (paymentType.isEmpty) {
                              Navigator.of(context).pop(true);
                              CustomWidget(context: context).custombar("P2P",
                                  "Please Choose the Payment Method", false);
                            } else {
                              Navigator.of(context).pop(true);
                            }
                          });
                        },
                        child: Container(
                            width: MediaQuery.of(context).size.width * 0.4,
                            padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5.0),
                              color: Color(0xFFf0c21b),
                            ),
                            child: Center(
                              child: Text(
                                "Submit".toUpperCase(),
                                style: CustomWidget(context: context)
                                    .CustomSizedTextStyle(
                                        14.0,
                                        Theme.of(context).splashColor,
                                        FontWeight.w500,
                                        'FontRegular'),
                              ),
                            )),
                      ),
                      InkWell(
                        onTap: () {
                          setState(() {
                              Navigator.of(context).pop(true);
                          });
                        },
                        child: Container(
                            width: MediaQuery.of(context).size.width * 0.4,
                            padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5.0),
                              color: Color(0xFFf0c21b),
                            ),
                            child: Center(
                              child: Text(
                                "Close".toUpperCase(),
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
                ],
              ),
            );
          });
        });
  }

  Widget buyUI() {
    return Container(
      color: Theme.of(context).backgroundColor,
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            "Asset",
            style: CustomWidget(context: context).CustomSizedTextStyle(
                14.0, AppColors.whiteColor, FontWeight.w700, 'FontRegular'),
          ),
          Row(
            children: [
              Flexible(
                child: ListTile(
                  title: const Text('BTC'),
                  leading: Radio<AssetCoin>(
                    value: AssetCoin.BTC,
                    groupValue: buyassetCoin,
                    activeColor: Theme.of(context).indicatorColor,
                    onChanged: (AssetCoin? value) {
                      setState(() {
                        print("suba" + value.toString());
                        buyassetCoin = value!;
                        if (buyassetCoin == AssetCoin.BTC) {
                          selCoin = "btc";
                        }
                        getAssetLivePrice();
                      });
                    },
                  ),
                ),
              ),
              Flexible(
                child: ListTile(
                  title: const Text('USDT'),
                  leading: Radio<AssetCoin>(
                    value: AssetCoin.USDT,
                    groupValue: buyassetCoin,
                    activeColor: Theme.of(context).indicatorColor,
                    onChanged: (AssetCoin? value) {
                      setState(() {
                        print("bash" + value.toString());
                        buyassetCoin = value!;
                        if (buyassetCoin == AssetCoin.USDT) {
                          selCoin = "usdt";
                        }
                        getAssetLivePrice();
                      });
                    },
                  ),
                ),
              ),
            ],
          ),

          SizedBox(
            height: 10.0,
          ),
          Text(
            "with Cash",
            style: CustomWidget(context: context).CustomSizedTextStyle(
                14.0, AppColors.whiteColor, FontWeight.w700, 'FontRegular'),
          ),
          Flexible(
            child: ListTile(
              title: const Text('INR'),
              leading: Radio<CashType>(
                value: CashType.INR,
                groupValue: cashType,
                activeColor: Theme.of(context).indicatorColor,
                onChanged: (value) {
                  setState(() {
                    print("jklkl" + value.toString());
                    buycash = value.toString();
                  });
                },
              ),
            ),
          ),
          SizedBox(
            height: 10.0,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                "Your Price",
                style: CustomWidget(context: context).CustomSizedTextStyle(
                    14.0, AppColors.whiteColor, FontWeight.w700, 'FontRegular'),
              ),
              Text(
                "\u{20B9} " + selectAssetPrice!.lastPrice.toString(),
                style: CustomWidget(context: context).CustomSizedTextStyle(
                    12.0, AppColors.whiteColor, FontWeight.w700, 'FontRegular'),
              ),
            ],
          ),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //   crossAxisAlignment: CrossAxisAlignment.start,
          //   children: [
          //
          //     // Column(
          //     //   mainAxisAlignment: MainAxisAlignment.end,
          //     //   crossAxisAlignment: CrossAxisAlignment.end,
          //     //   children: [
          //     //     Row(
          //     //       children: [
          //     //         Text(
          //     //           "Highest Order Price",
          //     //           style: CustomWidget(context: context).CustomSizedTextStyle(
          //     //               14.0,
          //     //               AppColors.whiteColor,
          //     //               FontWeight.w700,
          //     //               'FontRegular'),
          //     //         ),
          //     //         SizedBox(width: 5.0,),
          //     //         Icon(
          //     //           Icons.error_outlined,
          //     //           color: AppColors.whiteColor,
          //     //           size: 18.0,
          //     //         ),
          //     //       ],
          //     //     ),
          //     //     Text(
          //     //       "\u{20B9} "+ selectAssetPrice!.highPrice.toString(),
          //     //       style: CustomWidget(context: context).CustomSizedTextStyle(
          //     //           12.0,
          //     //           AppColors.whiteColor,
          //     //           FontWeight.w700,
          //     //           'FontRegular'),
          //     //     ),
          //     //   ],
          //     // ),
          //   ],
          // ),
          SizedBox(
            height: 10.0,
          ),
          // Text(
          //   "Price Type",
          //   style: CustomWidget(context: context).CustomSizedTextStyle(
          //       14.0,
          //       AppColors.whiteColor,
          //       FontWeight.w700,
          //       'FontRegular'),
          // ),
          // Row(
          //   children: [
          //     Flexible(
          //       child: ListTile(
          //         title: const Text('Fixed'),
          //         leading: Radio<PriceType>(
          //           value:PriceType.Fixed,
          //           groupValue:priceType,
          //           activeColor:Theme.of(context).indicatorColor,
          //           onChanged: (PriceType? value) {
          //             setState(() {
          //               priceType = value!;
          //               priceController.text="1476512.0";
          //               fixedVal=true;
          //             });
          //           },
          //         ),
          //       ),
          //     ),
          //
          //     Flexible(
          //       child: ListTile(
          //         title: const Text('Float'),
          //         leading: Radio<PriceType>(
          //           value:PriceType.Float,
          //           groupValue:priceType,
          //           activeColor:Theme.of(context).indicatorColor,
          //           onChanged: (PriceType? value) {
          //             setState(() {
          //               priceType = value!;
          //               priceController.text="100";
          //               fixedVal=false;
          //             });
          //           },
          //         ),
          //       ),
          //     ),
          //   ],
          // ),
          // SizedBox(height: 10.0,),
          // Text(
          //   "Fixed",
          //   style: CustomWidget(context: context).CustomSizedTextStyle(
          //       14.0,
          //       AppColors.whiteColor,
          //       FontWeight.w700,
          //       'FontRegular'),
          // ),
          // SizedBox(height: 10.0,),
          // Container(
          //   padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
          //   decoration: BoxDecoration(
          //     border: Border.all(
          //         color:CustomTheme.of(context).hintColor.withOpacity(0.5),
          //         width: 1.0),
          //     borderRadius: BorderRadius.circular(5.0),
          //     color: Colors.transparent,
          //   ),
          //   child: Row(
          //     crossAxisAlignment: CrossAxisAlignment.center,
          //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //     children: [
          //       InkWell(
          //         onTap: () {
          //           setState(() {
          //             if(!fixedVal){
          //               if (priceController.text.isNotEmpty) {
          //                 double amount = double.parse(priceController.text);
          //                 if (amount >= 0) {
          //                   amount = amount - 0.01;
          //                   priceController.text = amount.toStringAsFixed(2);
          //                 } else {
          //                   priceController.text = "0.01";
          //                 }
          //               }
          //             }
          //           });
          //         },
          //         child: Container(
          //             height: 40.0,
          //             width: 35.0,
          //             padding: const EdgeInsets.only(
          //               left: 10.0,
          //               right: 10.0,
          //             ),
          //             decoration: BoxDecoration(
          //               color: CustomTheme.of(context).cardColor,
          //               borderRadius: BorderRadius.circular(2),
          //             ),
          //             child: Center(
          //               child: Text(
          //                 "-",
          //                 style: CustomWidget(context: context)
          //                     .CustomSizedTextStyle(
          //                     20.0,
          //                     Theme.of(context).splashColor,
          //                     FontWeight.w500,
          //                     'FontRegular'),
          //               ),
          //             )),
          //       ),
          //       const SizedBox(
          //         width: 2.0,
          //       ),
          //       Flexible(
          //           child: Container(
          //             height: 40.0,
          //             child: TextField(
          //               controller: priceController,
          //               keyboardType:
          //               const TextInputType.numberWithOptions(decimal: true),
          //               style: CustomWidget(context: context).CustomSizedTextStyle(
          //                   13.0,
          //                   Theme.of(context).splashColor,
          //                   FontWeight.w500,
          //                   'FontRegular'),
          //               onChanged: (value) {
          //                 setState(() {
          //
          //                 });
          //               },
          //               decoration: InputDecoration(
          //                   contentPadding: EdgeInsets.only(bottom: 8.0),
          //                   hintText: "Price",
          //                   hintStyle: CustomWidget(context: context)
          //                       .CustomSizedTextStyle(
          //                       12.0,
          //                       Theme.of(context).splashColor.withOpacity(0.5),
          //                       FontWeight.w500,
          //                       'FontRegular'),
          //                   border: InputBorder.none),
          //               textAlign: TextAlign.start,
          //             ),
          //           )),
          //
          //       const SizedBox(
          //         width: 2.0,
          //       ),
          //       InkWell(
          //         onTap: () {
          //             setState(() {
          //               if(!fixedVal){
          //                 if (priceController.text.isNotEmpty) {
          //                   double amount = double.parse(priceController.text);
          //                   if (amount >= 0) {
          //                     amount = amount + 0.01;
          //                     priceController.text = amount.toStringAsFixed(2);
          //                   }
          //                 } else {
          //                   priceController.text = "0.01";
          //                 }
          //               }
          //             });
          //         },
          //         child: Container(
          //             height: 40.0,
          //             width: 35.0,
          //             padding: const EdgeInsets.only(
          //               left: 10.0,
          //               right: 10.0,
          //             ),
          //             decoration: BoxDecoration(
          //               color:CustomTheme.of(context).cardColor,
          //               borderRadius: BorderRadius.circular(2),
          //             ),
          //             child: Center(
          //               child: Text(
          //                 "+",
          //                 style: CustomWidget(context: context)
          //                     .CustomSizedTextStyle(
          //                     20.0,
          //                    Theme.of(context).splashColor,
          //                     FontWeight.w500,
          //                     'FontRegular'),
          //               ),
          //             )),
          //       ),
          //     ],
          //   ),
          // ),
        ],
      ),
    );
  }

  Widget sellUI() {
    return Container(
      color: Theme.of(context).backgroundColor,
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            "Asset",
            style: CustomWidget(context: context).CustomSizedTextStyle(
                14.0, AppColors.whiteColor, FontWeight.w700, 'FontRegular'),
          ),
          Row(
            children: [
              Flexible(
                child: ListTile(
                  title: const Text('BTC'),
                  leading: Radio<AssetCoin>(
                    value: AssetCoin.BTC,
                    groupValue: sellassetCoin,
                    activeColor: Theme.of(context).indicatorColor,
                    onChanged: (AssetCoin? value) {
                      setState(() {
                        sellassetCoin = value!;
                        if (sellassetCoin == AssetCoin.BTC) {
                          selCoin = "btc";
                        }
                        print(value.toString());
                        getAssetLivePrice();
                      });
                    },
                  ),
                ),
              ),
              Flexible(
                child: ListTile(
                  title: const Text('USDT'),
                  leading: Radio<AssetCoin>(
                    value: AssetCoin.USDT,
                    groupValue: sellassetCoin,
                    activeColor: Theme.of(context).indicatorColor,
                    onChanged: (AssetCoin? value) {
                      setState(() {
                        sellassetCoin = value!;
                        if (sellassetCoin == AssetCoin.USDT) {
                          selCoin = "usdt";
                        }
                        getAssetLivePrice();
                      });
                    },
                  ),
                ),
              ),
            ],
          ),

          SizedBox(
            height: 10.0,
          ),
          Text(
            "with Cash",
            style: CustomWidget(context: context).CustomSizedTextStyle(
                14.0, AppColors.whiteColor, FontWeight.w700, 'FontRegular'),
          ),
          Flexible(
            child: ListTile(
              title: const Text('INR'),
              leading: Radio<CashType>(
                value: CashType.INR,
                groupValue: cashType,
                activeColor: Theme.of(context).indicatorColor,
                onChanged: (value) {
                  setState(() {
                    print("jklkl" + value.toString());
                    buycash = value.toString();
                  });
                },
              ),
            ),
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "Your Price",
                    style: CustomWidget(context: context).CustomSizedTextStyle(
                        14.0,
                        AppColors.whiteColor,
                        FontWeight.w700,
                        'FontRegular'),
                  ),
                  Text(
                    "\u{20B9} " + selectAssetPrice!.lastPrice.toString(),
                    style: CustomWidget(context: context).CustomSizedTextStyle(
                        12.0,
                        AppColors.whiteColor,
                        FontWeight.w700,
                        'FontRegular'),
                  ),
                ],
              ),
              // Column(
              //   mainAxisAlignment: MainAxisAlignment.end,
              //   crossAxisAlignment: CrossAxisAlignment.end,
              //   children: [
              //     Row(
              //       children: [
              //         Text(
              //           "Highest Order Price",
              //           style: CustomWidget(context: context).CustomSizedTextStyle(
              //               14.0,
              //               AppColors.whiteColor,
              //               FontWeight.w700,
              //               'FontRegular'),
              //         ),
              //         SizedBox(width: 5.0,),
              //         Icon(
              //           Icons.error_outlined,
              //           color: AppColors.whiteColor,
              //             size: 18.0
              //         ),
              //       ],
              //     ),
              //     Text(
              //       "\u{20B9} "+ selectAssetPrice!.highPrice.toString(),
              //       style: CustomWidget(context: context).CustomSizedTextStyle(
              //           12.0,
              //           AppColors.whiteColor,
              //           FontWeight.w700,
              //           'FontRegular'),
              //     ),
              //   ],
              // ),
            ],
          ),
          SizedBox(
            height: 10.0,
          ),
          // Text(
          //   "Price Type",
          //   style: CustomWidget(context: context).CustomSizedTextStyle(
          //       14.0,
          //       AppColors.whiteColor,
          //       FontWeight.w700,
          //       'FontRegular'),
          // ),
          // Row(
          //   children: [
          //     Flexible(
          //       child: ListTile(
          //         title: const Text('Fixed'),
          //         leading: Radio<PriceType>(
          //           value:PriceType.Fixed,
          //           groupValue:priceType,
          //           activeColor:Theme.of(context).indicatorColor,
          //           onChanged: (PriceType? value) {
          //             setState(() {
          //               priceType = value!;
          //               priceController.text="1476512.0";
          //               fixedVal=true;
          //             });
          //           },
          //         ),
          //       ),
          //     ),
          //
          //     Flexible(
          //       child: ListTile(
          //         title: const Text('Float'),
          //         leading: Radio<PriceType>(
          //           value:PriceType.Float,
          //           groupValue:priceType,
          //           activeColor:Theme.of(context).indicatorColor,
          //           onChanged: (PriceType? value) {
          //             setState(() {
          //               priceType = value!;
          //               priceController.text="100";
          //               fixedVal=false;
          //             });
          //           },
          //         ),
          //       ),
          //     ),
          //   ],
          // ),
          // SizedBox(height: 10.0,),
          // Text(
          //   "Fixed",
          //   style: CustomWidget(context: context).CustomSizedTextStyle(
          //       14.0,
          //       AppColors.whiteColor,
          //       FontWeight.w700,
          //       'FontRegular'),
          // ),
          // SizedBox(height: 10.0,),
          // Container(
          //   padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
          //   decoration: BoxDecoration(
          //     border: Border.all(
          //         color:CustomTheme.of(context).hintColor.withOpacity(0.5),
          //         width: 1.0),
          //     borderRadius: BorderRadius.circular(5.0),
          //     color: Colors.transparent,
          //   ),
          //   child: Row(
          //     crossAxisAlignment: CrossAxisAlignment.center,
          //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //     children: [
          //       InkWell(
          //         onTap: () {
          //           setState(() {
          //             if(!fixedVal){
          //               if (priceController.text.isNotEmpty) {
          //                 double amount = double.parse(priceController.text);
          //                 if (amount >= 0) {
          //                   amount = amount - 0.01;
          //                   priceController.text = amount.toStringAsFixed(2);
          //                 } else {
          //                   priceController.text = "0.01";
          //                 }
          //               }
          //             }
          //           });
          //         },
          //         child: Container(
          //             height: 40.0,
          //             width: 35.0,
          //             padding: const EdgeInsets.only(
          //               left: 10.0,
          //               right: 10.0,
          //             ),
          //             decoration: BoxDecoration(
          //               color: CustomTheme.of(context).cardColor,
          //               borderRadius: BorderRadius.circular(2),
          //             ),
          //             child: Center(
          //               child: Text(
          //                 "-",
          //                 style: CustomWidget(context: context)
          //                     .CustomSizedTextStyle(
          //                     20.0,
          //                     Theme.of(context).splashColor,
          //                     FontWeight.w500,
          //                     'FontRegular'),
          //               ),
          //             )),
          //       ),
          //       const SizedBox(
          //         width: 2.0,
          //       ),
          //       Flexible(
          //           child: Container(
          //             height: 40.0,
          //             child: TextField(
          //               controller: priceController,
          //               keyboardType:
          //               const TextInputType.numberWithOptions(decimal: true),
          //               style: CustomWidget(context: context).CustomSizedTextStyle(
          //                   13.0,
          //                   Theme.of(context).splashColor,
          //                   FontWeight.w500,
          //                   'FontRegular'),
          //               onChanged: (value) {
          //                 setState(() {
          //
          //
          //                 });
          //               },
          //               decoration: InputDecoration(
          //                   contentPadding: EdgeInsets.only(bottom: 8.0),
          //                   hintText: "Price",
          //                   hintStyle: CustomWidget(context: context)
          //                       .CustomSizedTextStyle(
          //                       12.0,
          //                       Theme.of(context).splashColor.withOpacity(0.5),
          //                       FontWeight.w500,
          //                       'FontRegular'),
          //                   border: InputBorder.none),
          //               textAlign: TextAlign.start,
          //             ),
          //           )),
          //
          //       const SizedBox(
          //         width: 2.0,
          //       ),
          //       InkWell(
          //         onTap: () {
          //           setState(() {
          //             if(!fixedVal){
          //               if (priceController.text.isNotEmpty) {
          //                 double amount = double.parse(priceController.text);
          //                 if (amount >= 0) {
          //                   amount = amount + 0.01;
          //                   priceController.text = amount.toStringAsFixed(2);
          //                 }
          //               } else {
          //                 priceController.text = "0.01";
          //               }
          //             }
          //           });
          //         },
          //         child: Container(
          //             height: 40.0,
          //             width: 35.0,
          //             padding: const EdgeInsets.only(
          //               left: 10.0,
          //               right: 10.0,
          //             ),
          //             decoration: BoxDecoration(
          //               color:CustomTheme.of(context).cardColor,
          //               borderRadius: BorderRadius.circular(2),
          //             ),
          //             child: Center(
          //               child: Text(
          //                 "+",
          //                 style: CustomWidget(context: context)
          //                     .CustomSizedTextStyle(
          //                     20.0,
          //                     Theme.of(context).splashColor,
          //                     FontWeight.w500,
          //                     'FontRegular'),
          //               ),
          //             )),
          //       ),
          //     ],
          //   ),
          // ),
        ],
      ),
    );
  }

  Widget openOrdersUIS() {
    return Column(
      children: [
        postDataList.isNotEmpty
            ? Container(
                color: Theme.of(context).backgroundColor,
                child: ListView.builder(
                  itemCount: postDataList.length,
                  shrinkWrap: true,
                  controller: controller,
                  itemBuilder: (BuildContext context, int index) {
                    final input = postDataList[index].paymentType.toString();
                    final removedBrackets =
                        input.substring(1, input.length - 1);
                    final parts = removedBrackets.split(', ');
                    var joined = parts.map((part) => "$part").join(', ');
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
                                      "Advertisers (Completion rate)",
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
                                      postDataList[index]
                                              .userId!
                                              .name
                                              .toString() +
                                          "(" +
                                          postDataList[index]
                                              .tradeId
                                              .toString()
                                              .toString() +
                                          ")",
                                      style: CustomWidget(context: context)
                                          .CustomSizedTextStyle(
                                              13.0,
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
                                                postDataList[index]
                                                    .livePrice
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
                                                "Available",
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
                                                postDataList[index]
                                                    .quantity
                                                    .toString()+" "+postDataList[index]
                                                    .asset
                                                    .toString(),
                                                style: CustomWidget(
                                                        context: context)
                                                    .CustomSizedTextStyle(
                                                        14.0,
                                                        Theme.of(context)
                                                            .splashColor,
                                                        FontWeight.w500,
                                                        'FontRegular'),
                                              ),
                                            ],
                                          ),
                                          Column(
                                            children: [
                                              Text(
                                                "Payment",
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
                                                joined.toString().toUpperCase(),
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
                                      height: 15.0,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 5.0,right: 5.0),
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            children: [
                                              Text(
                                                "Limit",
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
                                                "Min: " +
                                                    postDataList[index]
                                                        .minLimit
                                                        .toString() +
                                                    " " +
                                                    postDataList[index]
                                                        .asset
                                                        .toString() +
                                                    " - " +
                                                    "Max: " +
                                                    postDataList[index]
                                                        .maxLimit
                                                        .toString() +
                                                    " " +
                                                    postDataList[index]
                                                        .asset
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
                                            mainAxisAlignment: MainAxisAlignment.start,
                                          ),
                                          InkWell(
                                            child: Container(
                                              width: 120.0,
                                              padding: const EdgeInsets.only(
                                                  top: 10.0, bottom: 10.0),
                                              decoration: BoxDecoration(
                                                color: postDataList[index]
                                                    .adType
                                                    .toString().toLowerCase()=="sell"?Theme.of(context).indicatorColor:Theme.of(context).scaffoldBackgroundColor,
                                                borderRadius:
                                                BorderRadius.circular(5),
                                              ),
                                              child: Align(
                                                alignment: Alignment.center,
                                                child: Text(
                                                 (postDataList[index]
                                                      .adType
                                                      .toString().toLowerCase()=="sell"?"BUY":"SELL")+" "+postDataList[index]
                                                      .asset
                                                      .toString(),
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
                                                 showConfirmDialog(postDataList[index]
                                                     .asset
                                                     .toString(),postDataList[index]
                                                     .adType
                                                     .toString(),postDataList[index]
                                                     .minLimit
                                                     .toString(), postDataList[index]
                                                     .maxLimit
                                                     .toString(),postDataList[index]);
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
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
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

  Widget myAdsUIS() {
    return Column(
      children: [
        SizedBox(
          height: 15.0,
        ),
        Container(
          width: MediaQuery.of(context).size.width,
          height: 45.0,
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
                items: myAdType
                    .map((value) => DropdownMenuItem(
                  child: Text(
                    value.toString(),
                    style: CustomWidget(context: context)
                        .CustomSizedTextStyle(
                        12.0,
                        Theme.of(context).errorColor,
                        FontWeight.w500,
                        'FontRegular'),
                  ),
                  value: value,
                ))
                    .toList(),
                onChanged: (value) async {
                  setState(() {
                    selectedMyAdValue = value.toString();
                    loading=true;
                    myAdsDataList= [];
                    getMypostAd(selectedMyAdValue);
                  });
                },
                hint: Text(
                  "Select Ad Type",
                  style: CustomWidget(context: context).CustomSizedTextStyle(
                      12.0,
                      Theme.of(context).errorColor,
                      FontWeight.w500,
                      'FontRegular'),
                ),
                isExpanded: true,
                value: selectedMyAdValue,
                icon: const Icon(
                  Icons.arrow_drop_down,
                  // color: AppColors.otherTextColor,
                ),
              ),
            ),
          ),
        ),
        SizedBox(
          height: 10.0,
        ),
        myAdsDataList.isNotEmpty
            ? Container(
                color: Theme.of(context).backgroundColor,
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: ListView.builder(
                  itemCount: myAdsDataList.length,
                  shrinkWrap: true,
                  controller: controller,
                  itemBuilder: (BuildContext context, int index) {
                    final input = myAdsDataList[index].paymentType.toString();
                    final removedBrackets =
                        input.substring(1, input.length - 1);
                    final parts = removedBrackets.split(', ');
                    var joined = parts.map((part) => "$part").join(', ');
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
                                      "Advertisers (Completion rate)",
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
                                      myAdsDataList[index]
                                              .userId!
                                              .name
                                              .toString() +
                                          "(" +
                                          myAdsDataList[index]
                                              .tradeId
                                              .toString()
                                              .toString() +
                                          ")",
                                      style: CustomWidget(context: context)
                                          .CustomSizedTextStyle(
                                              13.0,
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
                                                myAdsDataList[index]
                                                    .livePrice
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
                                                "Ad Type",
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
                                                myAdsDataList[index]
                                                    .adType
                                                    .toString().toUpperCase(),
                                                style: CustomWidget(
                                                        context: context)
                                                    .CustomSizedTextStyle(
                                                        14.0,
                                                        Theme.of(context)
                                                            .splashColor,
                                                        FontWeight.w500,
                                                        'FontRegular'),
                                              ),
                                            ],
                                          ),
                                          Column(
                                            children: [
                                              Text(
                                                "Available",
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
                                                myAdsDataList[index]
                                                    .quantity
                                                    .toString()+
                                                    " " +
                                                    myAdsDataList[index]
                                                        .asset
                                                        .toString(),
                                                style: CustomWidget(
                                                        context: context)
                                                    .CustomSizedTextStyle(
                                                        14.0,
                                                        Theme.of(context)
                                                            .splashColor,
                                                        FontWeight.w500,
                                                        'FontRegular'),
                                              ),
                                            ],
                                          ),
                                          Column(
                                            children: [
                                              Text(
                                                "Payment",
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
                                                joined.toString().toUpperCase(),
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
                                    Padding(
                                      padding: const EdgeInsets.only(left: 5.0,right: 5.0),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Column(
                                            children: [
                                              Text(
                                                "Limit",
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
                                                "Min: " +
                                                    myAdsDataList[index]
                                                        .minLimit
                                                        .toString() +
                                                    " " +
                                                    myAdsDataList[index]
                                                        .asset
                                                        .toString() +
                                                    " - " +
                                                    "Max: " +
                                                    myAdsDataList[index]
                                                        .maxLimit
                                                        .toString() +
                                                    " " +
                                                    myAdsDataList[index]
                                                        .asset
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
                                            mainAxisAlignment: MainAxisAlignment.start,
                                          ),
                                          InkWell(
                                            child: Container(
                                              width: 120.0,
                                              padding: const EdgeInsets.only(
                                                  top: 10.0, bottom: 10.0),
                                              decoration: BoxDecoration(
                                                color: Theme.of(context).indicatorColor,
                                                borderRadius:
                                                BorderRadius.circular(5),
                                              ),
                                              child: Align(
                                                alignment: Alignment.center,
                                                child: Text(
                                                  "View Ad Details",
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
                                                 print(myAdsDataList[index]
                                                     .tradeId
                                                     .toString());
                                                 Navigator.of(context).push(
                                                     MaterialPageRoute(
                                                         builder: (context) =>
                                                             MyAdDetailsPage(tradeId: myAdsDataList[index]
                                                                 .tradeId
                                                                 .toString(),)));
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
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
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



  showConfirmDialog(String asset,String type,String minLimit,String maxLimit,MyAdDetailsData postDetailsData) {
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
                      child: Column(
                        children: [
                          SizedBox(
                            height: 15.0,
                          ),
                          Text(
                            "Quantity",
                            style: CustomWidget(
                                context: context)
                                .CustomSizedTextStyle(
                                18.0,
                                Theme.of(context)
                                    .splashColor,
                                FontWeight.w400,
                                'FontRegular'),
                          ),
                          SizedBox(
                            height: 15.0,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(
                              5.0,
                            ),
                            child: TextField(
                              controller: quantityController,
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
                                ssetState(() {
                                  if (value.isEmpty) {
                                    _validateQuantity = true;
                                    error="Quantity Can\'t Be Empty";
                                  } else {
                                    if(double.parse(minLimit.toString())>double.parse(value.toString())){
                                      _validateQuantity = true;
                                      error="Give a amount between min and max limit";
                                    }else if(double.parse(maxLimit.toString())<double.parse(
                                        value.toString())){
                                      _validateQuantity = true;
                                      error="Give a amount between min and max limit";
                                    }else{
                                      _validateQuantity = false;
                                    }
                                  }
                                });
                              },
                              decoration: InputDecoration(
                                errorText: _validateQuantity
                                    ? error:null,
                                errorStyle: CustomWidget(context: context)
                                    .CustomSizedTextStyle(
                                    12.0,
                                    Theme.of(context)
                                        .scaffoldBackgroundColor,
                                    FontWeight.w500,
                                    'FontRegular'),
                                contentPadding: // Text Field height
                                EdgeInsets.symmetric(
                                    vertical: 10.0, horizontal: 10.0),
                                hintText: "Quantity",
                                hintStyle: CustomWidget(context: context)
                                    .CustomSizedTextStyle(
                                    12.0,
                                    Theme.of(context)
                                        .splashColor
                                        .withOpacity(0.5),
                                    FontWeight.w500,
                                    'FontRegular'),
                                suffixIcon: Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 15.0),
                                  child: Text(
                                   asset,
                                    textAlign: TextAlign.center,
                                    style: CustomWidget(context: context)
                                        .CustomSizedTextStyle(
                                        12.0,
                                        Theme.of(context)
                                            .splashColor
                                            .withOpacity(0.5),
                                        FontWeight.w500,
                                        'FontRegular'),
                                  ),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: CustomTheme.of(context)
                                        .hintColor
                                        .withOpacity(0.5),
                                    width: 1.0,
                                  ),
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                                disabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: CustomTheme.of(context)
                                        .hintColor
                                        .withOpacity(0.5),
                                    width: 1.0,
                                  ),
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: CustomTheme.of(context)
                                        .hintColor
                                        .withOpacity(0.5),
                                    width: 1.0,
                                  ),
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: CustomTheme.of(context)
                                        .hintColor
                                        .withOpacity(0.5),
                                    width: 1.0,
                                  ),
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                              ),
                              textAlign: TextAlign.start,
                            ),
                          ),
                          SizedBox(
                            height: 15.0,
                          ),
                          Row(
                            children: [
                              Text(
                                "Min-limit : " +
                                        minLimit
                                        .toString(),
                                style: CustomWidget(
                                    context: context)
                                    .CustomSizedTextStyle(
                                    16.0,
                                    Theme.of(context)
                                        .splashColor,
                                    FontWeight.w400,
                                    'FontRegular'),
                              ),
                              Text(
                                    " - ",
                                style: CustomWidget(
                                    context: context)
                                    .CustomSizedTextStyle(
                                    16.0,
                                    Theme.of(context)
                                        .splashColor,
                                    FontWeight.w400,
                                    'FontRegular'),
                              ),

                              Text(
                                    "Max-limit : " +
                                        maxLimit
                                        .toString(),
                                style: CustomWidget(
                                    context: context)
                                    .CustomSizedTextStyle(
                                    16.0,
                                    Theme.of(context)
                                        .splashColor,
                                    FontWeight.w400,
                                    'FontRegular'),
                              ),
                            ],
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          ),
                          SizedBox(
                            height: 15.0,
                          ),
                          Row(
                            children: [
                              InkWell(
                                onTap: () {
                                  ssetState((){
                                    if (quantityController.text.isNotEmpty) {
                                      Navigator.of(context).pop(true);
                                      if(double.parse(minLimit.toString())>double.parse(quantityController.text)||
                                          double.parse(maxLimit.toString())<double.parse(quantityController.text)){
                                        _validateQuantity=true;
                                        error="Give a amount between min and max limit";
                                      }else{
                                        Navigator.of(context).push(MaterialPageRoute(builder: (context)=>P2pPayment(postDetailsData: postDetailsData,
                                          quantity: quantityController.text.toString(),)));
                                      }
                                    }else{
                                      _validateQuantity=true;
                                      error="Enter the quantity";
                                    }
                                  });

                                },
                                child: Container(
                                    width: MediaQuery.of(context).size.width*0.3,
                                    padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5.0),
                                      color: type
                                          .toString().toLowerCase()=="sell"?Theme.of(context).indicatorColor:Theme.of(context).scaffoldBackgroundColor,
                                    ),
                                    child: Center(
                                      child: Text(
                                        type=="sell"?AppLocalizations.instance.text("loc_buy"):AppLocalizations.instance.text("loc_sell"),
                                        style: CustomWidget(context: context)
                                            .CustomSizedTextStyle(
                                            14.0,
                                            Theme.of(context).splashColor,
                                            FontWeight.w500,
                                            'FontRegular'),
                                      ),
                                    )),
                              ),
                              SizedBox(width: 5.0,),
                              InkWell(
                                onTap: () {
                                 Navigator.of(context).pop(true);
                                 ssetState((){
                                   _validateQuantity=false;
                                   quantityController.clear();
                                 });
                                },
                                child: Container(
                                    width: MediaQuery.of(context).size.width*0.3,
                                    padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5.0),
                                      color: type
                                          .toString().toLowerCase()=="sell"?Theme.of(context).indicatorColor:Theme.of(context).scaffoldBackgroundColor,
                                    ),
                                    child: Center(
                                      child: Text(
                                        AppLocalizations.instance.text("loc_cancel"),
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
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.start,
                          ),
                        ],
                      ),
                    );
                  }),
            ),
          );
        });
  }


  Widget purchaseAdsUIS() {
    return Column(
      children: [
        SizedBox(
          height: 15.0,
        ),
        Container(
          width: MediaQuery.of(context).size.width,
          height: 45.0,
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
                items: myAdType
                    .map((value) => DropdownMenuItem(
                  child: Text(
                    value.toString(),
                    style: CustomWidget(context: context)
                        .CustomSizedTextStyle(
                        12.0,
                        Theme.of(context).errorColor,
                        FontWeight.w500,
                        'FontRegular'),
                  ),
                  value: value,
                ))
                    .toList(),
                onChanged: (value) async {
                  setState(() {
                    selectedPurchaseAdValue = value.toString();
                    loading=true;
                    purchaseAdsDataList= [];
                    getPurchasepostAd(selectedPurchaseAdValue);
                  });
                },
                hint: Text(
                  "Select Ad Type",
                  style: CustomWidget(context: context).CustomSizedTextStyle(
                      12.0,
                      Theme.of(context).errorColor,
                      FontWeight.w500,
                      'FontRegular'),
                ),
                isExpanded: true,
                value: selectedPurchaseAdValue,
                icon: const Icon(
                  Icons.arrow_drop_down,
                  // color: AppColors.otherTextColor,
                ),
              ),
            ),
          ),
        ),
        SizedBox(
          height: 10.0,
        ),
        purchaseAdsDataList.isNotEmpty
            ? Container(
                color: Theme.of(context).backgroundColor,
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: ListView.builder(
                  itemCount: purchaseAdsDataList.length,
                  shrinkWrap: true,
                  controller: controller,
                  itemBuilder: (BuildContext context, int index) {
                    final input = purchaseAdsDataList[index].paymentType.toString();
                    final removedBrackets =
                        input.substring(1, input.length - 1);
                    final parts = removedBrackets.split(', ');
                    var joined = parts.map((part) => "$part").join(', ');
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
                                      "Advertisers (Completion rate)",
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
                                      purchaseAdsDataList[index]
                                              .senderuserId!
                                              .name
                                              .toString() +
                                          "(" +
                                          purchaseAdsDataList[index]
                                              .tradeId
                                              .toString()+
                                          ")",
                                      style: CustomWidget(context: context)
                                          .CustomSizedTextStyle(
                                              13.0,
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
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                                                "Buy/Sell from",
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
                                                purchaseAdsDataList[index]
                                                    .userId!
                                                    .name
                                                    .toString(),
                                                style: CustomWidget(context: context)
                                                    .CustomSizedTextStyle(
                                                    13.0,
                                                    Theme.of(context).splashColor,
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
                                                "Ad Type",
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
                                                purchaseAdsDataList[index]
                                                    .adType
                                                    .toString(),
                                                style: CustomWidget(
                                                        context: context)
                                                    .CustomSizedTextStyle(
                                                        14.0,
                                                        Theme.of(context)
                                                            .splashColor,
                                                        FontWeight.w500,
                                                        'FontRegular'),
                                              ),
                                            ],
                                          ),
                                          Column(
                                            children: [
                                              Text(
                                                "Available",
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
                                                purchaseAdsDataList[index]
                                                    .quantity
                                                    .toString()+
                                                    " " +
                                                    purchaseAdsDataList[index]
                                                        .asset
                                                        .toString(),
                                                style: CustomWidget(
                                                        context: context)
                                                    .CustomSizedTextStyle(
                                                        14.0,
                                                        Theme.of(context)
                                                            .splashColor,
                                                        FontWeight.w500,
                                                        'FontRegular'),
                                              ),
                                            ],
                                          ),
                                          Column(
                                            children: [
                                              Text(
                                                "Payment",
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
                                                joined.toString(),
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
                                    Padding(
                                      padding: const EdgeInsets.only(left: 5.0,right: 5.0),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            children: [
                                              Text(
                                                "Limit",
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
                                                "Min: " +
                                                    purchaseAdsDataList[index]
                                                        .minLimit
                                                        .toString() +
                                                    " " +
                                                    purchaseAdsDataList[index]
                                                        .asset
                                                        .toString() +
                                                    " - " +
                                                    "Max: " +
                                                    purchaseAdsDataList[index]
                                                        .maxLimit
                                                        .toString() +
                                                    " " +
                                                    purchaseAdsDataList[index]
                                                        .asset
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
                                            mainAxisAlignment: MainAxisAlignment.start,
                                          ),
                                          purchaseAdsDataList[index].status==3||purchaseAdsDataList[index].status==4?SizedBox():InkWell(
                                            child: Container(
                                              width: 120.0,
                                              padding: const EdgeInsets.only(
                                                  top: 10.0, bottom: 10.0),
                                              decoration: BoxDecoration(
                                                color: Theme.of(context).indicatorColor,
                                                borderRadius:
                                                BorderRadius.circular(5),
                                              ),
                                              child: Align(
                                                alignment: Alignment.center,
                                                child: Text(
                                                  "View",
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
                                                Navigator.of(context).push(MaterialPageRoute(builder: (context)=>P2pPayment(postDetailsData: purchaseAdsDataList[index],
                                                  quantity: purchaseAdsDataList[index].quantity.toString(),)));
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


  _getRequests() async {
    setState(() {
      loading = true;
      getPaymentDetails();
    });
  }
  getUserId() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    userId = preferences.getString("exp").toString();
    getAllpostAd(type, "");
    getPaymentDetails();
    getMypostAd("buy");
    getPurchasepostAd("buy");
  }

  // Fetch content from the json file
  Future<void> readJson() async {
    final String response =
        await rootBundle.loadString('assets/json/sample.json');
    final data = await json.decode(response);
    setState(() {
      advertise = data["items"];
      print(advertise);
    });
  }

  doPostAd() {
    print("Last price" + selectAssetPrice!.lastPrice.toString());
    apiUtils.Allpostadd(
            userId,
           typeView,
            selCoin,
            "INR",
            amountgroupController.text,
            minController.text,
            maxController.text,
            paymentType,
            selectAssetPrice!.lastPrice.toString())
        .then((PostAddModel loginData) {
      if (loginData.statusCode == 200) {
        setState(() {
          loading = false;
          postAddData = loginData.data!;
          CustomWidget(context: context)
              .custombar("P2P", loginData.message.toString(), true);
          amountgroupController.text="";
          maxController.text="";
          minController.text="";
          imps = false;
          upi = false;
          neft = false;
          campaign = false;
          createadgrp = false;
          cretaeAd = false;
          newAd=true;
          getAllpostAd("buy", "");
        });
      }else{
        setState(() {
          loading = false;
          CustomWidget(context: context)
              .custombar("P2P", loginData.message.toString(), false);
        });
      }
    }).catchError((Object error) {
      print(error);
      setState(() {
        loading = false;
      });
    });
  }

  getAssetLivePrice() {
    apiUtils.getLiveAssetValue(selCoin).then((P2PLivePriceModel loginData) {
      if (loginData.statusCode == 200) {
        setState(() {
          selectAssetPrice = loginData.data!;
        });
      }
    }).catchError((Object error) {
      setState(() {
        loading = false;
      });
    });
  }

  getAllpostAd(String type, String par) {
    apiUtils.getAd(userId, type).then((GetPostAdData loginData) {
      if (loginData.statusCode == 200) {
        setState(() {
          loading = false;
          postDataListValue = loginData.data!;
          for (int i = 0; i < postDataListValue.length; i++) {
            coinlist.add(postDataListValue[i].asset!);
          }
          coinlist = coinlist.toSet().toList();
          if (par == "") {
            selectedValue = coinlist.first.toString();
          } else {
            selectedValue = par;
          }
          for (int i = 0; i < postDataListValue.length; i++) {
            if (selectedValue.toString().toLowerCase() ==
                postDataListValue[i].asset!.toString().toLowerCase())
              postDataList.add(postDataListValue[i]);
          }


        });
      }
    }).catchError((Object error) {
      setState(() {
        loading = false;
      });
    });
  }

  getMypostAd(String adType) {
    apiUtils.getMyAd(userId).then((MyAdsHistoryData loginData) {
      if (loginData.statusCode == 200) {
        setState(() {
          myAdssDataList = loginData.data!;
          for(int i=0;i<myAdssDataList.length;i++){
            if(myAdssDataList[i].adType.toString().toLowerCase()==adType.toString().toLowerCase()){
              myAdsDataList.add(myAdssDataList[i]);
            }
          }
          loading = false;
        });
      }
    }).catchError((Object error) {
      setState(() {
        loading = false;
      });
    });
  }


  getPurchasepostAd(String adType) {
    apiUtils.getPurchaseAd(userId).then((PurchasedAdsHistoryData loginData) {
      if (loginData.statusCode == 200) {
        setState(() {
          loading = false;
          purchaseAdssDataList = loginData.data!;
          for(int i=0;i<purchaseAdssDataList.length;i++){
            if(purchaseAdssDataList[i].adType.toString().toLowerCase()==adType.toString().toLowerCase()){
              purchaseAdsDataList.add(purchaseAdssDataList[i]);
            }
          }
        });
      }
    }).catchError((Object error) {
      setState(() {
        loading = false;
      });
    });
  }

  getPaymentDetails() {
    apiUtils
        .getpay_details(userId, "true")
        .then((GetPaymentDetailsModel loginData) {
      if (loginData.statusCode == 200) {
        setState(() {
          pay_type=[];
          pay_type=loginData.data!.type!;
          loading=false;
          for(int m=0;m<pay_type.length;m++){
            checkboxItems.add(ListTileModel(
                false,
                pay_type[m].toString()
            ));
          }
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

class ListTileModel {
  bool enabled;
  String text;

  ListTileModel(this.enabled, this.text);
}
