import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:h2_crypto/common/custom_widget.dart';
import 'package:h2_crypto/common/localization/localizations.dart';
import 'package:h2_crypto/common/theme/custom_theme.dart';
import 'package:h2_crypto/data/api_utils.dart';
import 'package:h2_crypto/data/crypt_model/bank_model.dart';
import 'package:h2_crypto/data/crypt_model/common_model.dart';
import 'package:h2_crypto/screens/bank/add_bank.dart';

class BankScreen extends StatefulWidget {
  const BankScreen({Key? key}) : super(key: key);

  @override
  State<BankScreen> createState() => _BankScreenState();
}

class _BankScreenState extends State<BankScreen> {
  bool loading = false;
  APIUtils apiUtils = APIUtils();

  ScrollController controller = ScrollController();
  List<BankList> bankList = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loading = true;
    getBankList();
  }

  _getRequests() async {
    setState(() {
      loading = true;
      getBankList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: CustomTheme.of(context).primaryColor,
        elevation: 0.0,
        leading: Container(
            padding: const EdgeInsets.all(16.0),
            child: InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: SvgPicture.asset(
                'assets/others/arrow_left.svg',
                height: 22.0,
                width: 22.0,
                allowDrawingOutsideViewBox: true,
                color: CustomTheme.of(context).splashColor,
              ),
            )),
        centerTitle: true,
        actions: [
          Padding(
            padding: EdgeInsets.only(top: 10.0, bottom: 10.0, right: 10.0),
            child: InkWell(
              onTap: () {
                Navigator.of(context)
                    .push(
                      MaterialPageRoute(builder: (_) => AddBankScreen()),
                    )
                    .then((val) => val ? _getRequests() : null);
              },
              child: Container(
                decoration: BoxDecoration(
                    color: CustomTheme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(5.0)),
                padding: EdgeInsets.all(5.0),
                child: Icon(
                  Icons.add,
                  size: 20.0,
                ),
              ),
            ),
          )
        ],
        title: Text(
          "Bank Details",
          style: CustomWidget(context: context).CustomSizedTextStyle(16.0,
              Theme.of(context).splashColor, FontWeight.w400, 'FontRegular'),
        ),
      ),
      body: Container(
        margin: EdgeInsets.only(left: 0, right: 0, bottom: 0.0),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
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
          padding: EdgeInsets.fromLTRB(15.0, 0.0, 15.0, 0.0),
          child: loading
              ? CustomWidget(context: context).loadingIndicator(
                  CustomTheme.of(context).splashColor,
                )
              : bankDetails(),
        ),
      ),
    );
  }

  Widget bankDetails() {
    return Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: CustomTheme.of(context).primaryColor,
        child: Stack(
          children: [
            SizedBox(
              height: 10.0,
            ),
            bankList.length > 0
                ? Container(
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                            begin: Alignment.topRight,
                            end: Alignment.bottomCenter,
                            stops: [
                          0.1,
                          0.5,
                          0.8,
                        ],
                            colors: [
                          CustomTheme.of(context).primaryColor,
                          CustomTheme.of(context).backgroundColor,
                          CustomTheme.of(context).accentColor,
                        ])),
                    width: MediaQuery.of(context).size.width,
                    child: SingleChildScrollView(
                      controller: controller,
                      child: ListView.builder(
                        itemCount: bankList.length,
                        shrinkWrap: true,
                        controller: controller,
                        itemBuilder: (BuildContext context, int index) {
                          return Column(
                            children: [
                              Container(
                                  decoration: BoxDecoration(
                                      color: CustomTheme.of(context).cardColor,
                                      borderRadius: BorderRadius.circular(5.0)),
                                  width: MediaQuery.of(context).size.width,
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(
                                            left: 8.0, right: 8.0, top: 5.0),
                                        child: Row(
                                          children: [
                                            Column(
                                              children: [
                                                Text(
                                                  "Name",
                                                  style: CustomWidget(
                                                          context: context)
                                                      .CustomTextStyle(
                                                          Theme.of(context)
                                                              .highlightColor,
                                                          FontWeight.w400,
                                                          'FontRegular'),
                                                  softWrap: true,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                                Text(
                                                  bankList[index]
                                                      .name1
                                                      .toString(),
                                                  style: CustomWidget(
                                                          context: context)
                                                      .CustomTextStyle(
                                                          Theme.of(context)
                                                              .splashColor,
                                                          FontWeight.w400,
                                                          'FontRegular'),
                                                  softWrap: true,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ],
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                            ),
                                            InkWell(
                                              child: Icon(
                                                Icons.delete_forever,
                                                size: 20.0,
                                                color: Theme.of(context)
                                                    .splashColor,
                                              ),
                                              onTap: () {
                                                deleteDialog(bankList[index]
                                                    .id
                                                    .toString());
                                              },
                                            )
                                          ],
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 5.0,
                                      ),
                                      Container(
                                        height: 0.5,
                                        color:
                                            CustomTheme.of(context).buttonColor,
                                      ),
                                      const SizedBox(
                                        height: 5.0,
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(
                                            left: 8.0, right: 8.0, top: 5.0),
                                        child: Row(
                                          children: [
                                            Column(
                                              children: [
                                                Text(
                                                  "Account Number",
                                                  style: CustomWidget(
                                                          context: context)
                                                      .CustomTextStyle(
                                                          Theme.of(context)
                                                              .highlightColor,
                                                          FontWeight.w400,
                                                          'FontRegular'),
                                                  softWrap: true,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                                Text(
                                                  bankList[index]
                                                      .accountNumber
                                                      .toString(),
                                                  style: CustomWidget(
                                                          context: context)
                                                      .CustomTextStyle(
                                                          Theme.of(context)
                                                              .splashColor,
                                                          FontWeight.w400,
                                                          'FontRegular'),
                                                  softWrap: true,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ],
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                            ),
                                            Column(
                                              children: [
                                                Text(
                                                  "Account Type",
                                                  style: CustomWidget(
                                                          context: context)
                                                      .CustomTextStyle(
                                                          Theme.of(context)
                                                              .highlightColor,
                                                          FontWeight.w400,
                                                          'FontRegular'),
                                                  softWrap: true,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                                Text(
                                                  bankList[index]
                                                      .type
                                                      .toString(),
                                                  style: CustomWidget(
                                                          context: context)
                                                      .CustomTextStyle(
                                                          Theme.of(context)
                                                              .splashColor,
                                                          FontWeight.w400,
                                                          'FontRegular'),
                                                  softWrap: true,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ],
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                            ),
                                          ],
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 5.0,
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(
                                            left: 8.0, right: 8.0, top: 5.0),
                                        child: Row(
                                          children: [
                                            Column(
                                              children: [
                                                Text(
                                                  "Currency",
                                                  style: CustomWidget(
                                                          context: context)
                                                      .CustomTextStyle(
                                                          Theme.of(context)
                                                              .highlightColor,
                                                          FontWeight.w400,
                                                          'FontRegular'),
                                                  softWrap: true,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                                Text(
                                                  bankList[index]
                                                      .currency
                                                      .toString()
                                                      .toUpperCase(),
                                                  style: CustomWidget(
                                                          context: context)
                                                      .CustomTextStyle(
                                                          Theme.of(context)
                                                              .splashColor,
                                                          FontWeight.w400,
                                                          'FontRegular'),
                                                  softWrap: true,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ],
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                            ),
                                            Column(
                                              children: [
                                                Text(
                                                  "Routing Number",
                                                  style: CustomWidget(
                                                          context: context)
                                                      .CustomTextStyle(
                                                          Theme.of(context)
                                                              .highlightColor,
                                                          FontWeight.w400,
                                                          'FontRegular'),
                                                  softWrap: true,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                                Text(
                                                  bankList[index]
                                                      .routingNumber
                                                      .toString(),
                                                  style: CustomWidget(
                                                          context: context)
                                                      .CustomTextStyle(
                                                          Theme.of(context)
                                                              .splashColor,
                                                          FontWeight.w400,
                                                          'FontRegular'),
                                                  softWrap: true,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ],
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                            ),
                                          ],
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 5.0,
                                      ),
                                      Container(
                                        height: 0.5,
                                        color:
                                            CustomTheme.of(context).buttonColor,
                                      ),
                                      const SizedBox(
                                        height: 5.0,
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(
                                            left: 10.0,
                                            right: 10.0,
                                            top: 5.0,
                                            bottom: 5.0),
                                        child: Row(
                                          children: [
                                            Column(
                                              children: [
                                                Text(
                                                  "Bank Name",
                                                  style: CustomWidget(
                                                          context: context)
                                                      .CustomTextStyle(
                                                          Theme.of(context)
                                                              .highlightColor,
                                                          FontWeight.w400,
                                                          'FontRegular'),
                                                  softWrap: true,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                                Text(
                                                  bankList[index]
                                                      .bankName
                                                      .toString(),
                                                  style: CustomWidget(
                                                          context: context)
                                                      .CustomTextStyle(
                                                          Theme.of(context)
                                                              .splashColor,
                                                          FontWeight.w400,
                                                          'FontRegular'),
                                                  softWrap: true,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ],
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                            ),
                                            Column(
                                              children: [
                                                Text(
                                                  "Is International",
                                                  style: CustomWidget(
                                                          context: context)
                                                      .CustomTextStyle(
                                                          Theme.of(context)
                                                              .highlightColor,
                                                          FontWeight.w400,
                                                          'FontRegular'),
                                                  softWrap: true,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                                Text(
                                                  bankList[index]
                                                              .internationalBank
                                                              .toString() ==
                                                          "false"
                                                      ? "NO"
                                                      : "YES",
                                                  style: CustomWidget(
                                                          context: context)
                                                      .CustomTextStyle(
                                                          Theme.of(context)
                                                              .splashColor,
                                                          FontWeight.w400,
                                                          'FontRegular'),
                                                  softWrap: true,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ],
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                            ),
                                          ],
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 5.0,
                                      ),
                                    ],
                                  )),
                            ],
                          );
                        },
                      ),
                    ))
                : Container(
                    margin: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height * 0.38),
                    height: MediaQuery.of(context).size.height * 0.3,
                    color: CustomTheme.of(context).primaryColor,
                    child: Center(
                      child: Text(
                        "No Records Found..!",
                        style: CustomWidget(context: context).CustomTextStyle(
                            Theme.of(context).splashColor,
                            FontWeight.w400,
                            'FontRegular'),
                      ),
                    ),
                  )
          ],
        ));
  }

  getBankList() {
    apiUtils.getBankDetails().then((BankListModel loginData) {
      if (loginData.success!) {
        setState(() {
          loading = false;
          bankList = loginData.result!;
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

  removeBank(String id) {
    apiUtils.removebankDetails(id).then((CommonModel loginData) {
      if (loginData.status!) {
        setState(() {
          CustomWidget(context: context)
              .custombar("H2Crypto", loginData.message.toString(), true);
          getBankList();
        });
      } else {
        setState(() {
          loading = false;
          CustomWidget(context: context)
              .custombar("H2Crypto", loginData.message.toString(), false);
        });
      }
    }).catchError((Object error) {
      setState(() {
        loading = false;
      });
    });
  }

  deleteDialog(String id) {
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
                      "Do you want to Delete bank details?",
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
                              setState(() {
                                loading = true;
                                removeBank(id);
                              });
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
}
