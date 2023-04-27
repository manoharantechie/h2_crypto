import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:moment_dart/moment_dart.dart';
import 'package:h2_crypto/common/colors.dart';
import 'package:h2_crypto/common/custom_button.dart';
import 'package:h2_crypto/common/custom_widget.dart';
import 'package:h2_crypto/common/theme/custom_theme.dart';
import 'package:h2_crypto/data/api_utils.dart';
import 'package:h2_crypto/data/model/get_payment_details_model.dart';
import 'package:h2_crypto/data/model/margin_loan_model.dart';
import 'package:h2_crypto/data/model/my_ad_details_model.dart';
import 'package:h2_crypto/data/model/upload_p2p_model.dart';
import 'package:h2_crypto/screens/p2p/p2p_home.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';


class P2pPayment extends StatefulWidget {
  final MyAdDetailsData postDetailsData;
  final String quantity;

  const P2pPayment(
      {Key? key, required this.postDetailsData, required this.quantity})
      : super(key: key);

  @override
  State<P2pPayment> createState() => _P2pPaymentState();
}

class _P2pPaymentState extends State<P2pPayment> {
  bool loading = false;
  APIUtils apiUtils = APIUtils();
  bool confirmOrder = true;
  bool transfer = false;
  bool aftTransfer = false;
  ScrollController controller = ScrollController();
  String tradeId = "";
  String adType = "";
  String sellerName = "";
  String asset = "";
  String userId = "";
  String sUserId = "";
  String uId = "";
  String quantity = "";
  String imageData = "";
  String previewImageData = "";
  String dateTime = "";
  String amount = "";
  String status = "";
  String postId = "";
  String tId = "";
  final ImagePicker picker = ImagePicker();
  File? imageFile;
  MyAdDetailsData? postDetailsData;
  List<String> paymentType = [];
  List<Payment> paymentDetailas = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("Data"+previewImageData);
    postDetailsData = widget.postDetailsData;
    tId = postDetailsData!.tradeId.toString();
    userId = postDetailsData!.userId!.id.toString();
    sUserId = postDetailsData!.senderuserId!.id.toString();
    sellerName = postDetailsData!.userId!.name.toString();
    quantity = widget.quantity;
    adType = postDetailsData!.adType.toString().toUpperCase();
    amount = postDetailsData!.livePrice.toString();
    asset = postDetailsData!.asset.toString();
    for (int k = 0; k < postDetailsData!.paymentType!.length; k++) {
      paymentType.add(postDetailsData!.paymentType![k]);
    }
    print("paymentType1" + paymentType.length.toString());
    loading = true;
    getPaymentDetails();
    getUserId();
    var bytes1 = utf8.encode("$userId");         // data being hashed
    var digest1 = sha256.convert(bytes1);         // Hashing Process
    print("Digest as bytes: ${digest1.bytes}");   // Print Bytes
    print("Digest as hex string: $digest1");

  }

  getUserId() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    uId = preferences.getString("exp").toString();
    slipUploadStatusChange();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            setState(() {
              Navigator.pop(context);
            });
          },
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Text(
          "P2P Payment Details",
          style: CustomWidget(context: context).CustomSizedTextStyle(22.0,
              Theme.of(context).splashColor, FontWeight.w500, 'FontRegular'),
        ),
        centerTitle: true,
      ),
      backgroundColor: CustomTheme.of(context).primaryColor,
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
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
                  paymentUI(),
                ],
              ),
            ),
            loading
                ? CustomWidget(context: context).loadingIndicator(
                    CustomTheme.of(context).splashColor,
                  )
                : Container(),
          ],
        ),
      ),
    );
  }

  Widget paymentUI() {
    Moment spiritRoverOnMars = Moment(postDetailsData!.createdAt!).toLocal();
    var tot = double.parse(quantity) * double.parse(amount);
    return Column(
      children: [
        Container(
          margin: EdgeInsets.all(5.0),
          decoration: BoxDecoration(
            color: Theme.of(context).indicatorColor,
            borderRadius: BorderRadius.circular(10.0),
          ),
          padding: EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "$adType $asset from $sellerName",
                style: CustomWidget(context: context).CustomSizedTextStyle(
                    18.0,
                    Theme.of(context).splashColor,
                    FontWeight.w500,
                    'FontRegular'),
              ),
              SizedBox(
                height: 5.0,
              ),
              Text(
                "Order number : " + tradeId,
                style: CustomWidget(context: context).CustomSizedTextStyle(
                    14.0,
                    Theme.of(context).splashColor,
                    FontWeight.w500,
                    'FontRegular'),
              ),
              SizedBox(
                height: 10.0,
              ),
              Text(
                "The order is created, Please wait for system confirmation : ",
                style: CustomWidget(context: context).CustomSizedTextStyle(
                    18.0,
                    Theme.of(context).splashColor,
                    FontWeight.w500,
                    'FontRegular'),
              ),
              SizedBox(
                height: 5.0,
              ),
              Text(
                spiritRoverOnMars.format("YYYY MMMM Do - hh:mm:ssa").toString(),
                style: CustomWidget(context: context).CustomSizedTextStyle(
                    14.0,
                    Theme.of(context).splashColor,
                    FontWeight.w500,
                    'FontRegular'),
              ),
              SizedBox(
                height: 5.0,
              ),
            ],
          ),
        ),
        SizedBox(
          height: 15.0,
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
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
                  child: confirmOrder
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
                  color: transfer || aftTransfer
                      ? Theme.of(context).indicatorColor
                      : Color(0xFF919191),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: confirmOrder || transfer
                      ? Text("2",
                          style: CustomWidget(context: context)
                              .CustomSizedTextStyle(12.0, AppColors.whiteColor,
                                  FontWeight.w500, 'FontRegular'))
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
                  color: aftTransfer
                      ? Theme.of(context).indicatorColor
                      : Color(0xFF919191),
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
        ),
        SizedBox(
          height: 15.0,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              children: [
                SizedBox(
                  height: 15.0,
                ),
                confirmOrder
                    ? Column(
                        children: [
                          Text(
                            "Confirm order info",
                            style: CustomWidget(context: context)
                                .CustomSizedTextStyle(
                                    18.0,
                                    Theme.of(context).splashColor,
                                    FontWeight.w500,
                                    'FontRegular'),
                          ),
                          SizedBox(
                            height: 15.0,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                children: [
                                  Text(
                                    "Quantity",
                                    style: CustomWidget(context: context)
                                        .CustomSizedTextStyle(
                                            18.0,
                                            Theme.of(context)
                                                .splashColor
                                                .withOpacity(0.5),
                                            FontWeight.w500,
                                            'FontRegular'),
                                  ),
                                  Text(
                                    quantity + " " + asset,
                                    style: CustomWidget(context: context)
                                        .CustomSizedTextStyle(
                                            16.0,
                                            Colors.white,
                                            FontWeight.w500,
                                            'FontRegular'),
                                  ),
                                ],
                              ),
                              Column(
                                children: [
                                  Text(
                                    "Price",
                                    style: CustomWidget(context: context)
                                        .CustomSizedTextStyle(
                                            18.0,
                                            Theme.of(context)
                                                .splashColor
                                                .withOpacity(0.5),
                                            FontWeight.w500,
                                            'FontRegular'),
                                  ),
                                  Text(
                                    "\u{20B9} $amount",
                                    style: CustomWidget(context: context)
                                        .CustomSizedTextStyle(
                                            16.0,
                                            Colors.white,
                                            FontWeight.w500,
                                            'FontRegular'),
                                  ),
                                ],
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    "Amount",
                                    style: CustomWidget(context: context)
                                        .CustomSizedTextStyle(
                                            18.0,
                                            Theme.of(context)
                                                .splashColor
                                                .withOpacity(0.5),
                                            FontWeight.w500,
                                            'FontRegular'),
                                  ),
                                  Text(
                                    " \u{20B9} $tot",
                                    style: CustomWidget(context: context)
                                        .CustomSizedTextStyle(
                                            16.0,
                                            Colors.white,
                                            FontWeight.w500,
                                            'FontRegular'),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 25.0,
                          ),
                          InkWell(
                            onTap: () {
                              setState(() {
                                confirmOrder = false;
                                transfer = true;
                                aftTransfer = false;
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
                                    "Next",
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
                      )
                    : SizedBox(),
              ],
            ),
            transfer
                ? Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Flexible(
                              child: Text(
                                "Transfer the funds to the seller’s account provided below.",
                                style: CustomWidget(context: context)
                                    .CustomSizedTextStyle(
                                        14.0,
                                        Theme.of(context).splashColor,
                                        FontWeight.w500,
                                        'FontRegular'),
                              ),
                            ),
                            SizedBox(
                              width: 5.0,
                            ),
                            Icon(
                              Icons.error_outlined,
                              color: AppColors.whiteColor,
                              size: 18.0,
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.error_outlined,
                              color: Theme.of(context).indicatorColor,
                              size: 18.0,
                            ),
                            SizedBox(
                              width: 5.0,
                            ),
                            Flexible(
                              child: Text(
                                "H2Crypto only supports real-name verified payment method.",
                                style: CustomWidget(context: context)
                                    .CustomSizedTextStyle(
                                        14.0,
                                        Theme.of(context).indicatorColor,
                                        FontWeight.w500,
                                        'FontRegular'),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Column(
                          children: [
                            postDetailsData!.status == 1 ||
                                    postDetailsData!.status == 4
                                ? Container(
                                    child: Image.network(
                                        postDetailsData!.slipUpload.toString(),
                                        height: 50.0,
                                        width: 50.0),
                                  )
                                : Row(
                                    children: [
                                      Flexible(
                                        child: Container(
                                          child: ListView.builder(
                                            shrinkWrap: true,
                                            controller: controller,
                                            itemCount: paymentType.length,
                                            itemBuilder:
                                                (BuildContext context, int i) {
                                              return Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    paymentType[i].toString() +
                                                        ": ",
                                                    style: CustomWidget(
                                                            context: context)
                                                        .CustomSizedTextStyle(
                                                            16.0,
                                                            Theme.of(context)
                                                                .splashColor
                                                                .withOpacity(
                                                                    0.5),
                                                            FontWeight.w500,
                                                            'FontRegular'),
                                                  ),
                                                  SizedBox(
                                                    height: 25.0,
                                                  ),
                                                ],
                                              );
                                            },
                                          ),
                                        ),
                                      ),
                                      Flexible(
                                        child: Container(
                                          child: ListView.builder(
                                              shrinkWrap: true,
                                              itemCount: paymentDetailas.length,
                                              itemBuilder:
                                                  (BuildContext context,
                                                      index) {
                                                return Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    paymentDetailas[index]
                                                                    .Payment_name
                                                                    .toString()
                                                                    .toLowerCase() ==
                                                                "upi" ||
                                                            paymentDetailas[
                                                                        index]
                                                                    .Payment_name
                                                                    .toString()
                                                                    .toLowerCase() ==
                                                                "paytm"
                                                        ? Column(
                                                            children: [
                                                              Text(
                                                                paymentDetailas[
                                                                        index]
                                                                    .Payment_name
                                                                    .toString(),
                                                                style: CustomWidget(
                                                                        context:
                                                                            context)
                                                                    .CustomSizedTextStyle(
                                                                        14.0,
                                                                        Theme.of(context)
                                                                            .splashColor,
                                                                        FontWeight
                                                                            .w500,
                                                                        'FontRegular'),
                                                              ),
                                                              Text(
                                                                paymentDetailas[
                                                                        index]
                                                                    .upiId
                                                                    .toString(),
                                                                style: CustomWidget(
                                                                        context:
                                                                            context)
                                                                    .CustomSizedTextStyle(
                                                                        14.0,
                                                                        Theme.of(context)
                                                                            .splashColor,
                                                                        FontWeight
                                                                            .w500,
                                                                        'FontRegular'),
                                                              ),
                                                            ],
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .start,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                          )
                                                        : Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .start,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(
                                                                paymentDetailas[
                                                                        index]
                                                                    .name
                                                                    .toString(),
                                                                style: CustomWidget(
                                                                        context:
                                                                            context)
                                                                    .CustomSizedTextStyle(
                                                                        14.0,
                                                                        Theme.of(context)
                                                                            .splashColor,
                                                                        FontWeight
                                                                            .w500,
                                                                        'FontRegular'),
                                                              ),
                                                              Text(
                                                                paymentDetailas[
                                                                        index]
                                                                    .Payment_name
                                                                    .toString(),
                                                                style: CustomWidget(
                                                                        context:
                                                                            context)
                                                                    .CustomSizedTextStyle(
                                                                        14.0,
                                                                        Theme.of(context)
                                                                            .splashColor,
                                                                        FontWeight
                                                                            .w500,
                                                                        'FontRegular'),
                                                              ),
                                                              Text(
                                                                paymentDetailas[
                                                                        index]
                                                                    .accType
                                                                    .toString(),
                                                                style: CustomWidget(
                                                                        context:
                                                                            context)
                                                                    .CustomSizedTextStyle(
                                                                        14.0,
                                                                        Theme.of(context)
                                                                            .splashColor,
                                                                        FontWeight
                                                                            .w500,
                                                                        'FontRegular'),
                                                              ),
                                                              Text(
                                                                paymentDetailas[
                                                                        index]
                                                                    .accNum
                                                                    .toString(),
                                                                style: CustomWidget(
                                                                        context:
                                                                            context)
                                                                    .CustomSizedTextStyle(
                                                                        14.0,
                                                                        Theme.of(context)
                                                                            .splashColor,
                                                                        FontWeight
                                                                            .w500,
                                                                        'FontRegular'),
                                                              ),
                                                              Text(
                                                                paymentDetailas[
                                                                        index]
                                                                    .bankName
                                                                    .toString(),
                                                                style: CustomWidget(
                                                                        context:
                                                                            context)
                                                                    .CustomSizedTextStyle(
                                                                        14.0,
                                                                        Theme.of(context)
                                                                            .splashColor,
                                                                        FontWeight
                                                                            .w500,
                                                                        'FontRegular'),
                                                              ),
                                                            ],
                                                          ),
                                                  ],
                                                );
                                              }),
                                        ),
                                      ),
                                    ],
                                  ),
                            Row(
                              children: [
                                Flexible(
                                  child: InkWell(
                                    onTap: () {
                                      setState(() {
                                        confirmOrder = true;
                                        transfer = false;
                                        aftTransfer = false;
                                      });
                                    },
                                    child: Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.5,
                                        padding: EdgeInsets.only(
                                            top: 10.0, bottom: 10.0),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5.0),
                                          color: Color(0xFF919191),
                                        ),
                                        child: Center(
                                          child: Text(
                                            "Back",
                                            style:
                                                CustomWidget(context: context)
                                                    .CustomSizedTextStyle(
                                                        14.0,
                                                        Theme.of(context)
                                                            .splashColor,
                                                        FontWeight.w500,
                                                        'FontRegular'),
                                          ),
                                        )),
                                  ),
                                ),
                                SizedBox(
                                  width: 10.0,
                                ),
                                Flexible(
                                  child: InkWell(
                                    onTap: () {
                                      setState(() {
                                        confirmOrder = false;
                                        transfer = false;
                                        aftTransfer = true;
                                      });
                                    },
                                    child: Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.5,
                                        padding: EdgeInsets.only(
                                            top: 10.0, bottom: 10.0),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5.0),
                                          color:
                                              Theme.of(context).indicatorColor,
                                        ),
                                        child: Center(
                                          child: Text(
                                            "Next",
                                            style:
                                                CustomWidget(context: context)
                                                    .CustomSizedTextStyle(
                                                        14.0,
                                                        Theme.of(context)
                                                            .splashColor,
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
                      ],
                    ),
                  )
                : SizedBox(),
            aftTransfer
                ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Text(
                          "After tranferring the funds, please upload slip then release funds.",
                          style: CustomWidget(context: context)
                              .CustomSizedTextStyle(
                                  16.0,
                                  Theme.of(context).splashColor,
                                  FontWeight.w500,
                                  'FontRegular'),
                        ),
                        SizedBox(
                          height: 25.0,
                        ),
                        postDetailsData!.status == 3 ||
                                postDetailsData!.status == 4
                            ? SizedBox()
                            : postDetailsData!.status == 1
                                ? Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      uId != sUserId
                                          ? InkWell(
                                              child: Container(
                                                alignment: Alignment.center,
                                                width: 120.0,
                                                padding: const EdgeInsets.only(
                                                    top: 10.0, bottom: 10.0),
                                                decoration: BoxDecoration(
                                                  color: Theme.of(context)
                                                      .indicatorColor,
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                ),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Icon(
                                                      Icons
                                                          .notification_important_outlined,
                                                      color:
                                                          AppColors.whiteColor,
                                                      size: 18.0,
                                                    ),
                                                    SizedBox(
                                                      width: 10.0,
                                                    ),
                                                    Text(
                                                      "Release fund",
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
                                                  ],
                                                ),
                                              ),
                                              onTap: () {
                                                setState(() {
                                                  loading = true;
                                                  doReleaseFund();
                                                });
                                              },
                                            )
                                          : SizedBox(),
                                      SizedBox(
                                        width: 10.0,
                                      ),
                                      InkWell(
                                        child: Container(
                                          alignment: Alignment.center,
                                          width: 120.0,
                                          padding: const EdgeInsets.only(
                                              top: 10.0, bottom: 10.0),
                                          decoration: BoxDecoration(
                                            color: Theme.of(context)
                                                .indicatorColor,
                                            borderRadius:
                                                BorderRadius.circular(5),
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
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
                                            ],
                                          ),
                                        ),
                                        onTap: () {
                                          setState(() {
                                            loading = true;
                                            doCancelTrade();
                                          });
                                        },
                                      ),
                                    ],
                                  )
                                : postDetailsData!.status == 5?InkWell(
                          child: Container(
                            alignment: Alignment.center,
                            width: 120.0,
                            padding: const EdgeInsets.only(
                                top: 10.0, bottom: 10.0),
                            decoration: BoxDecoration(
                              color: Theme.of(context)
                                  .indicatorColor,
                              borderRadius:
                              BorderRadius.circular(5),
                            ),
                            child: Row(
                              mainAxisAlignment:
                              MainAxisAlignment.center,
                              children: [
                                Text(
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
                              ],
                            ),
                          ),
                          onTap: () {
                            setState(() {
                              loading = true;
                              doCancelTrade();
                            });
                          },
                        ):InkWell(
                                    child: Container(
                                      alignment: Alignment.center,
                                      width: 120.0,
                                      padding: const EdgeInsets.only(
                                          top: 10.0, bottom: 10.0),
                                      decoration: BoxDecoration(
                                        color: Theme.of(context).indicatorColor,
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.file_upload_outlined,
                                            color: AppColors.whiteColor,
                                            size: 18.0,
                                          ),
                                          SizedBox(
                                            width: 10.0,
                                          ),
                                          Text(
                                            "Upload",
                                            style:
                                                CustomWidget(context: context)
                                                    .CustomSizedTextStyle(
                                                        12.0,
                                                        Theme.of(context)
                                                            .splashColor,
                                                        FontWeight.w400,
                                                        'FontRegular'),
                                            textAlign: TextAlign.center,
                                          ),
                                        ],
                                      ),
                                    ),
                                    onTap: () {
                                      setState(() {
                                        onRequestPermission();
                                      });
                                    },
                                  ),
                        SizedBox(height: 10.0,),
                        previewImageData==""||previewImageData==null?SizedBox():Container(
                          child: Image.network(
                              previewImageData,
                              height: 50.0,
                              width: 50.0),
                        ),
                        SizedBox(height: 10.0,),
                        previewImageData==""||previewImageData==null?SizedBox():InkWell(
                          child: Container(
                            alignment: Alignment.center,
                            width: 120.0,
                            padding: const EdgeInsets.only(
                                top: 10.0, bottom: 10.0),
                            decoration: BoxDecoration(
                              color: Theme.of(context).indicatorColor,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Text(
                              "Finish",
                              style:
                              CustomWidget(context: context)
                                  .CustomSizedTextStyle(
                                  12.0,
                                  Theme.of(context)
                                      .splashColor,
                                  FontWeight.w400,
                                  'FontRegular'),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          onTap: () {
                            setState(() {
                              Navigator.of(context)
                                  .push(MaterialPageRoute(builder: (context) => P2pHome()));
                            });
                          },
                        ),
                      ],
                    ),
                  )
                : SizedBox(),
          ],
        ),
        SizedBox(
          height: 15.0,
        ),
      ],
    );
  }

  onRequestPermission() async {
    var status = await Permission.storage.status;
    if (status.isDenied) {
      // You can request multiple permissions at once.
      Map<Permission, PermissionStatus> statuses = await [
        Permission.storage,
        Permission.camera,
      ].request();
    } else {
      _pickedImageDialog();
    }
  }

  _pickedImageDialog() {
    showModalBottomSheet<void>(
      //background color for modal bottom screen
      backgroundColor: AppColors.backgroundColor,
      //elevates modal bottom screen
      elevation: 10,
      isScrollControlled: true,
      // gives rounded corner to modal bottom screen
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10.0),
          topRight: Radius.circular(10.0),
        ),
      ),
      // context and builder are
      // required properties in this widget
      context: context,
      builder: (BuildContext context) {
        // we set up a container inside which
        // we create center column and display text

        // Returning SizedBox instead of a Container
        return SingleChildScrollView(
            child: Container(
          padding: EdgeInsets.all(10.0),
          child: Column(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Choose image source",
                      style: CustomWidget(context: context)
                          .CustomSizedTextStyle(16.0, AppColors.blackColor,
                              FontWeight.w600, 'FontRegular'),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 30.0,
              ),
              Container(
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: ButtonCustom(
                              text: "Gallery",
                              iconEnable: false,
                              radius: 5.0,
                              icon: "",
                              textStyle: CustomWidget(context: context)
                                  .CustomSizedTextStyle(
                                      18.0,
                                      AppColors.whiteColor,
                                      FontWeight.w500,
                                      'FontRegular'),
                              iconColor: AppColors.appColor,
                              buttonColor: AppColors.appColor,
                              splashColor: AppColors.appColor,
                              onPressed: () {
                                setState(() {
                                  Navigator.pop(context);
                                  getImage(ImageSource.gallery);
                                });
                              },
                              paddng: 1.0),
                          flex: 4,
                        ),
                        SizedBox(
                          width: 10.0,
                        ),
                        Flexible(
                          child: ButtonCustom(
                              text: "Camera",
                              iconEnable: false,
                              radius: 5.0,
                              icon: "",
                              textStyle: CustomWidget(context: context)
                                  .CustomSizedTextStyle(
                                      18.0,
                                      AppColors.whiteColor,
                                      FontWeight.w500,
                                      'FontRegular'),
                              iconColor: AppColors.appColor,
                              buttonColor: AppColors.appColor,
                              splashColor: AppColors.appColor,
                              onPressed: () {
                                setState(() {
                                  Navigator.pop(context);
                                  getImage(ImageSource.camera);
                                });
                              },
                              paddng: 1.0),
                          flex: 4,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
      },
    );
  }

  /// Get from gallery
  getImage(ImageSource type) async {
    var pickedFile = await picker.getImage(source: type);
    if (pickedFile != null) {
      setState(() {
        imageFile = File(pickedFile.path);
        final bytes = File(imageFile!.path).readAsBytesSync();
        imageData = base64Encode(bytes);
        loading = true;
        uploadImage(tId, imageData);
      });
    }
  }

  slipUploadStatusChange() {
    apiUtils
        .uploadP2PImage2(tId, uId, quantity)
        .then((UploadImageModel loginData) {
      if (loginData.statusCode == 200) {
        setState(() {
          loading = false;
          tradeId = loginData.data!.tradeId.toString();
        });
      }else{
        CustomWidget(context: context)
            .custombar("P2P", loginData.message.toString(), false);
      }
    }).catchError((Object error) {
      print("P2P" + error.toString());
      setState(() {
        loading = false;
      });
    });
  }

  uploadImage(String postId, String image) {
    apiUtils
        .uploadP2PImage(tradeId, postId, uId, quantity, image)
        .then((UploadImageModel loginData) {
      if (loginData.statusCode == 200) {
        setState(() {
          loading = false;
          previewImageData=loginData.data!.slipUpload.toString();
          CustomWidget(context: context)
              .custombar("P2P", loginData.message.toString(), true);
          sentNotification();
        });
      }
    }).catchError((Object error) {
      print("P2PU" + error.toString());
      setState(() {
        loading = false;
      });
    });
  }

  sentNotification() {
    apiUtils
        .p2pNotification(tId, uId)
        .then((LoanModel loginData) {
      if (loginData.statusCode == 200) {
        setState(() {
          loading = false;
          CustomWidget(context: context)
              .custombar("P2P", loginData.message.toString(), true);
        });
      } else {
        CustomWidget(context: context)
            .custombar("P2P", loginData.message.toString(), false);
      }
    }).catchError((Object error) {
      print("P2P" + error.toString());
      setState(() {
        loading = false;
      });
    });
  }

  doCancelTrade() {
    apiUtils.p2pCancelTrade(tId, userId,sUserId).then((LoanModel loginData) {
      if (loginData.statusCode == 200) {
        setState(() {
          loading = false;
          CustomWidget(context: context)
              .custombar("P2P", loginData.message.toString(), true);
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => P2pHome()));
        });
      } else {
        setState((){
          loading = false;
        });
        CustomWidget(context: context)
            .custombar("P2P", loginData.message.toString(), false);
      }
    }).catchError((Object error) {
      print("P2P" + error.toString());
      setState(() {
        loading = false;
      });
    });
  }

  doReleaseFund() {
    apiUtils.p2PRelease(tId).then((UploadImageModel loginData) {
      if (loginData.statusCode == 200) {
        setState(() {
          loading = false;
          CustomWidget(context: context)
              .custombar("P2P", loginData.message.toString(), true);
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => P2pHome()));
        });
      } else {
        CustomWidget(context: context)
            .custombar("P2P", loginData.message.toString(), false);
      }
    }).catchError((Object error) {
      print("P2P Error" + error.toString());
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
          loading = false;
          for (int n = 0; n < paymentType.length; n++) {
            for (int m = 0; m < loginData.data!.pay!.length; m++) {
              if (paymentType[n].toString().toLowerCase() ==
                  loginData.data!.pay![m].Payment_name!
                      .toString()
                      .toLowerCase()) {
                paymentDetailas.add(loginData.data!.pay![m]);
              }
            }
          }
          print("paymentDetailas" + paymentDetailas.length.toString());
        });
      } else {
        setState(() {
          loading = false;
          CustomWidget(context: context)
              .custombar("Payment Method", loginData.message.toString(), false);
        });
      }
    }).catchError((Object error) {
      print("H" + error.toString());
      setState(() {
        loading = false;
      });
    });
  }
}
