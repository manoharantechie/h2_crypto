import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:h2_crypto/common/colors.dart';
import 'package:h2_crypto/common/custom_widget.dart';
import 'package:h2_crypto/common/localization/localizations.dart';
import 'package:h2_crypto/common/theme/custom_theme.dart';
import 'package:h2_crypto/data/api_utils.dart';
import 'package:h2_crypto/data/model/loan_history_model.dart';
import 'package:h2_crypto/data/model/margin_repay_loan_model.dart';
import 'package:h2_crypto/data/model/trade_pair_list_model.dart';
import 'package:h2_crypto/data/model/wallet_list_model.dart';

class LoanHistory extends StatefulWidget {
  const LoanHistory({Key? key}) : super(key: key);

  @override
  State<LoanHistory> createState() => _LoanHistoryState();
}

class _LoanHistoryState extends State<LoanHistory> {
  APIUtils apiUtils = APIUtils();
  bool loading = false;
  bool futureRepay = true;
  TextEditingController coinController = TextEditingController();
  TextEditingController searchController = TextEditingController();
  FocusNode searchFocus = FocusNode();
  List<WalletList> coinList = [];
  List<WalletList> searchPair = [];
  ScrollController controller = ScrollController();
  String walletId = "";
  String loanTaken = "";
  String loanTopaid = "";
  String leverageVal = "";
  String loanMod = "";
  String sloanType = "";
  String assetName = "";
  String loanStatus = "";
  String selectLoanMode = "";
  String selectLoanType = "";
  List<String> loanType = ["Pending", "Paid"];
  List<String> loanMode = ["Margin", "Future"];
  List<LoanHistoryData> loanData=[];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    selectLoanType = loanType.first.toString();
    selectLoanMode = loanMode.first.toString();
    sloanType = selectLoanType.toLowerCase().toString();
    loanMod = "1";
    loading = true;
    getCoinList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Text(
          "Loan History",
          style: CustomWidget(context: context).CustomSizedTextStyle(22.0,
              Theme.of(context).splashColor, FontWeight.w500, 'FontRegular'),
        ),
        centerTitle: true,
      ),
      backgroundColor: CustomTheme.of(context).primaryColor,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  SizedBox(
                    height: 20.0,
                  ),
                  InkWell(
                    onTap: () {
                      showCoinList();
                    },
                    child: Container(
                      padding: EdgeInsets.fromLTRB(5.0, 0.0, 0.0, 0.0),
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: CustomTheme.of(context)
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
                                  contentPadding: EdgeInsets.only(bottom: 8.0),
                                  hintText: "Asset",
                                  hintStyle: CustomWidget(context: context)
                                      .CustomSizedTextStyle(
                                          12.0,
                                          Theme.of(context)
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
                              showCoinList();
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Flexible(
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: 40.0,
                          padding: EdgeInsets.fromLTRB(5, 0.0, 5, 0.0),
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: CustomTheme.of(context)
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
                                items: loanMode
                                    .map((value) => DropdownMenuItem(
                                          child: Text(
                                            value.toString(),
                                            style:
                                                CustomWidget(context: context)
                                                    .CustomSizedTextStyle(
                                                        13.0,
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
                                    selectLoanMode = value.toString();
                                    if (selectLoanMode == "Margin") {
                                      loanMod = "1";
                                      loading = true;
                                      futureRepay = true;
                                      getLoanHistoryData(
                                          walletId, sloanType, loanMod);
                                    } else {
                                      loanMod = "2";
                                      loading = true;
                                      futureRepay = false;
                                      getLoanHistoryData(
                                          walletId, sloanType, loanMod);

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
                                value: selectLoanMode,
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
                        width: 5.0,
                      ),
                      Flexible(
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: 40.0,
                          padding: EdgeInsets.fromLTRB(5, 0.0, 5, 0.0),
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: CustomTheme.of(context)
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
                                items: loanType
                                    .map((value) => DropdownMenuItem(
                                          child: Text(
                                            value.toString(),
                                            style:
                                                CustomWidget(context: context)
                                                    .CustomSizedTextStyle(
                                                        13.0,
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
                                    selectLoanType = value.toString();
                                    print("selectLoanType" +
                                        selectLoanType.toString());
                                    sloanType =
                                        selectLoanType.toLowerCase().toString();
                                    loading = true;
                                    getLoanHistoryData(
                                        walletId, sloanType, loanMod);
                                  });
                                },
                                hint: Text(
                                  "Loan Status",
                                  style: CustomWidget(context: context)
                                      .CustomSizedTextStyle(
                                          12.0,
                                          Theme.of(context).errorColor,
                                          FontWeight.w500,
                                          'FontRegular'),
                                ),
                                isExpanded: true,
                                value: selectLoanType,
                                icon: const Icon(
                                  Icons.arrow_drop_down,
                                  // color: AppColors.otherTextColor,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  loanUI(),
                ],
              ),
            ),
          ),
          loading
              ? CustomWidget(context: context)
                  .loadingIndicator(AppColors.whiteColor)
              : Container(),
        ],
      ),
    );
  }

  Widget loanUI() {
    return loanData.length > 0 ? ListView.builder(
        itemCount: loanData.length,
        controller: controller,
        shrinkWrap: true,
        itemBuilder: (BuildContext context,int index){
          return Container(
            padding: EdgeInsets.only(left: 15.0,right: 10.0,top: 10.0),
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: CustomTheme.of(context).buttonColor.withOpacity(0.2),
              borderRadius: BorderRadius.all(
                Radius.circular(5.0),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(0.0, 0.0, 15.0, 0.0),
                      child: Text(
                        "Asset Name : ",
                        style: CustomWidget(context: context)
                            .CustomSizedTextStyle(
                            14.0,
                            Theme.of(context).hintColor,
                            FontWeight.w400,
                            'FontRegular'),
                      ),
                    ),
                    Text(
                      loanData[index].assetName.toString(),
                      style: CustomWidget(context: context)
                          .CustomSizedTextStyle(
                          14.0,
                          Theme.of(context).hintColor.withOpacity(0.5),
                          FontWeight.w400,
                          'FontRegular'),
                    ),
                  ],
                ),
                SizedBox(
                  height: 8.0,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(0.0, 0.0, 15.0, 0.0),
                      child: Text(
                        "Loan Amount : ",
                        style: CustomWidget(context: context)
                            .CustomSizedTextStyle(
                            14.0,
                            Theme.of(context).hintColor,
                            FontWeight.w400,
                            'FontRegular'),
                      ),
                    ),
                    Text(
                      loanData[index].loanAmount.toString(),
                      style: CustomWidget(context: context)
                          .CustomSizedTextStyle(
                          14.0,
                          Theme.of(context).hintColor.withOpacity(0.5),
                          FontWeight.w400,
                          'FontRegular'),
                    ),
                  ],
                ),
                SizedBox(
                  height: 8.0,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(0.0, 0.0, 15.0, 0.0),
                      child: Text(
                        "Loan To be paid : ",
                        style: CustomWidget(context: context)
                            .CustomSizedTextStyle(
                            14.0,
                            Theme.of(context).hintColor,
                            FontWeight.w400,
                            'FontRegular'),
                      ),
                    ),
                    Text(
                      loanData[index].holdBalance.toString(),
                      style: CustomWidget(context: context)
                          .CustomSizedTextStyle(
                          14.0,
                          Theme.of(context).hintColor.withOpacity(0.5),
                          FontWeight.w400,
                          'FontRegular'),
                    ),
                  ],
                ),
                SizedBox(
                  height: 8.0,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(0.0, 0.0, 15.0, 0.0),
                      child: Text(
                        "Leverage : ",
                        style: CustomWidget(context: context)
                            .CustomSizedTextStyle(
                            14.0,
                            Theme.of(context).hintColor,
                            FontWeight.w400,
                            'FontRegular'),
                      ),
                    ),
                    Text(
                      loanData[index].margin_leverage.toString(),
                      style: CustomWidget(context: context)
                          .CustomSizedTextStyle(
                          14.0,
                          Theme.of(context).hintColor.withOpacity(0.5),
                          FontWeight.w400,
                          'FontRegular'),
                    ),
                  ],
                ),
                SizedBox(
                  height: 8.0,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(0.0, 0.0, 15.0, 0.0),
                      child: Text(
                        "Status  : ",
                        style: CustomWidget(context: context)
                            .CustomSizedTextStyle(
                            14.0,
                            Theme.of(context).hintColor,
                            FontWeight.w400,
                            'FontRegular'),
                      ),
                    ),
                    Text(
                      loanData[index].loan.toString(),
                      style: CustomWidget(context: context)
                          .CustomSizedTextStyle(
                          14.0,
                          Theme.of(context).hintColor.withOpacity(0.5),
                          FontWeight.w400,
                          'FontRegular'),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20.0,
                ),
                loanData[index].loan.toString() == "pending"
                    ? Visibility(
                  visible: futureRepay,
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        loading = true;
                      });
                      repayLoan(loanData[index].wallet.toString(), loanData[index].id.toString(), loanMod);
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
                            AppLocalizations.instance
                                .text("loc_repay_loan"),
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
                    : Container(),
              ],
            ),
          );
        }
    ):Container(
      height: MediaQuery.of(context).size.height,
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
        child: Text(
          " No records Found..!",
          style: TextStyle(
            fontFamily: "FontRegular",
            color: CustomTheme.of(context).splashColor,
          ),
        ),
      ),
    );
  }

  showCoinList() {
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
                                    searchPair = [];
                                    for (int m = 0; m < coinList.length; m++) {
                                      if (coinList[m]
                                              .asset!
                                              .symbol
                                              .toString()
                                              .toLowerCase()
                                              .contains(value.toLowerCase()) ||
                                          coinList[m]
                                              .asset!
                                              .assetname
                                              .toString()
                                              .toLowerCase()
                                              .contains(value.toLowerCase())) {
                                        searchPair.add(coinList[m]);
                                      }
                                    }
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
                                searchPair.addAll(coinList);
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
                                      setState(() {
                                        coinController.text = searchPair[index]
                                            .asset!
                                            .assetname
                                            .toString();
                                        walletId =
                                            searchPair[index].id.toString();
                                        loading = true;
                                        searchController.clear();
                                        getLoanHistoryData(
                                            walletId, sloanType, loanMod);
                                        getCoinListHistory();
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
                                                    .asset!
                                                    .symbol
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
                                              .asset!
                                              .assetname
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

  getCoinList() {
    apiUtils.getWalletList().then((WalletListModel loginData) {
      print(loginData.statusCode);
      if (loginData.statusCode == 200) {
        setState(() {
          loading = false;
          coinList = loginData.data!;
          searchPair = loginData.data!;
          coinController.text = coinList[0].asset!.assetname.toString();
          walletId = coinList[0].id.toString();
          getLoanHistoryData(walletId, sloanType, loanMod);
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

  getCoinListHistory() {
    apiUtils.getWalletList().then((WalletListModel loginData) {
      print(loginData.statusCode);
      if (loginData.statusCode == 200) {
        setState(() {
          loading = false;
          coinList = loginData.data!;
          searchPair = loginData.data!;
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

  getLoanHistoryData(
    String wallet_id,
    String loan_status,
    String loan_mode,
  ) {
    apiUtils
        .getLoanHistory(wallet_id, loan_status, loan_mode)
        .then((LoanHistoryModel loginData) {
      print("Test");
      if (loginData.statusCode == 200) {
        setState(() {
          loading = false;
          loanData = loginData.data!;
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

  repayLoan(String wallet_id, String loan_history_id, String loan_mode) {
    apiUtils
        .doMarginRepayLoan(wallet_id, loan_history_id, loan_mode)
        .then((RepayLoanModel loginData) {
      if (loginData.statusCode == 200) {
        setState(() {
          loading = false;
          searchController.clear();
          loanData=[];
          getLoanHistoryData(walletId,sloanType,loanMod);
          CustomWidget(context: context)
              .custombar("Loan History", loginData.message.toString(), true);
        });
      } else {
        setState(() {
          loading = false;
          CustomWidget(context: context)
              .custombar("Loan History", loginData.message.toString(), false);
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
