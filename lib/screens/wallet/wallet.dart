import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:h2_crypto/common/custom_widget.dart';
import 'package:h2_crypto/common/localization/localizations.dart';
import 'package:h2_crypto/common/theme/custom_theme.dart';
import 'package:h2_crypto/data/api_utils.dart';
import 'package:h2_crypto/data/model/wallet_list_model.dart';
import 'package:h2_crypto/screens/wallet/deposit.dart';
import 'package:h2_crypto/screens/wallet/transfer.dart';
import 'package:h2_crypto/screens/wallet/withdraw.dart';

import '../../data/model/balance_list_model.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({Key? key}) : super(key: key);

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  APIUtils apiUtils = APIUtils();
  bool loading = false;
  List<WalletList> coinList = [];
  List<WalletList> searchPair = [];
  ScrollController controller = ScrollController();
  TextEditingController searchController = TextEditingController();
  FocusNode searchFocus = FocusNode();
  String btcBalance="0.00";
  String usdBalance="0.00";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loading = true;
    getCoinList();
    getBalanceList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
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
        child: loading
            ? CustomWidget(context: context).loadingIndicator(
                CustomTheme.of(context).splashColor,
              )
            : assetsUI(),
      ),
    );
  }

  Widget assetsUI() {
    return Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: CustomTheme.of(context).primaryColor,
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                  color: CustomTheme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(5.0)),
              height: MediaQuery.of(context).size.height * 0.19,
              margin: EdgeInsets.only(left: 10.0, right: 10.0, top: 25.0),
              padding: const EdgeInsets.only(left: 20.0, right: 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 5.0,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        AppLocalizations.instance.text("loc_total"),
                        style: CustomWidget(context: context)
                            .CustomSizedTextStyle(
                                16.0,
                                Theme.of(context).splashColor,
                                FontWeight.w500,
                                'FontRegular'),
                      ),
                      const SizedBox(
                        width: 10.0,
                      ),
                      SvgPicture.asset(
                        'assets/icon/eye.svg',
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 5.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        double.parse(btcBalance).toStringAsFixed(8),
                        style: CustomWidget(context: context)
                            .CustomSizedTextStyle(
                                24.0,
                                Theme.of(context).splashColor,
                                FontWeight.w500,
                                'FontRegular'),
                      ),
                      const SizedBox(
                        width: 10.0,
                      ),
                      Text(
                        "BTC",
                        style: CustomWidget(context: context).CustomTextStyle(
                            Theme.of(context).splashColor,
                            FontWeight.w400,
                            'FontRegular'),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 5.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        "~ "+double.parse(usdBalance).toStringAsFixed(2),
                        style: CustomWidget(context: context)
                            .CustomSizedTextStyle(
                                14.0,
                                Theme.of(context).splashColor,
                                FontWeight.w500,
                                'FontRegular'),
                      ),
                      const SizedBox(
                        width: 10.0,
                      ),
                      Text(
                        "(USD)",
                        style: CustomWidget(context: context).CustomTextStyle(
                            Theme.of(context).splashColor,
                            FontWeight.w400,
                            'FontRegular'),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(
                top: MediaQuery.of(context).size.height * 0.24,
              ),
              width: MediaQuery.of(context).size.width,
              child: Column(
                children: [
               Container(

                    height: 45.0,
                    padding: EdgeInsets.only(left: 10.0,right: 10.0),
                    width: MediaQuery.of(context).size.width ,
                    child: TextField(
                      controller: searchController,
                      focusNode: searchFocus,
                      enabled: true,
                      onEditingComplete: () {
                        setState(() {
                          searchFocus.unfocus();
                          coinList=searchPair;
                        });
                      },
                      onChanged: (value) {
                        setState(() {
                          setState(() {
                            coinList = [];
                            for(int m=0;m<searchPair.length;m++)
                            {
                              if(searchPair[m].asset!.symbol.toString().toLowerCase().contains(value.toLowerCase())|| searchPair[m].asset!.assetname.toString().toLowerCase().contains(value.toLowerCase()))
                              {
                                coinList.add(searchPair[m]);
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
                  coinList.length > 0?const SizedBox(height: 10.0,):Container(),
                ],
              ),
            ),
            SizedBox(height: 10.0,),
            coinList.length > 0
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
                    margin: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * 0.35,
                    ),
                    child: SingleChildScrollView(
                      controller: controller,
                      child: Column(
                        children: [

                        SingleChildScrollView(
                          child:   ListView.builder(
                            itemCount: coinList.length,
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
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                            crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                            children: [
                                              Container(
                                                height: 25.0,
                                                width: 25.0,
                                                child: SvgPicture.network(
                                                  "https://cifdaq.in/api/color/" +
                                                      coinList[index]
                                                          .asset!
                                                          .symbol
                                                          .toString()
                                                          .toLowerCase() +
                                                      ".svg",
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 15.0,
                                              ),
                                              Column(
                                                crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    coinList[index]
                                                        .asset!
                                                        .assetname
                                                        .toString(),
                                                    style: CustomWidget(
                                                        context: context)
                                                        .CustomTextStyle(
                                                        Theme.of(context)
                                                            .splashColor,
                                                        FontWeight.w400,
                                                        'FontRegular'),
                                                    softWrap: true,
                                                    overflow: TextOverflow.ellipsis,

                                                  ),
                                                  const SizedBox(
                                                    width: 10.0,
                                                  ),
                                                  Text(
                                                    "( " +
                                                        coinList[index]
                                                            .asset!
                                                            .symbol
                                                            .toString() +
                                                        " )",
                                                    style: CustomWidget(
                                                        context: context)
                                                        .CustomTextStyle(
                                                        Theme.of(context)
                                                            .splashColor,
                                                        FontWeight.normal,
                                                        'FontRegular'),
                                                  ),
                                                ],
                                              )
                                            ],
                                          ),
                                          Text(
                                            double.parse(coinList[index]
                                                .balance
                                                .toString())
                                                .toStringAsFixed(2),
                                            style: CustomWidget(context: context)
                                                .CustomTextStyle(
                                                Theme.of(context).splashColor,
                                                FontWeight.w400,
                                                'FontRegular'),
                                          ),
                                        ],
                                      ),
                                      children: [
                                        Row(
                                          children: [
                                            Column(
                                              children: [
                                                Text(
                                                 "Margin Balance",
                                                  style: CustomWidget(
                                                      context: context)
                                                      .CustomTextStyle(
                                                      Theme.of(context)
                                                          .splashColor,
                                                      FontWeight.w400,
                                                      'FontRegular'),
                                                  softWrap: true,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                                Text(
                                                  coinList[index]
                                                      .marginBalance
                                                      .toString(),
                                                  style: CustomWidget(
                                                      context: context)
                                                      .CustomTextStyle(
                                                      Theme.of(context)
                                                          .splashColor,
                                                      FontWeight.w400,
                                                      'FontRegular'),
                                                  softWrap: true,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                              ],
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                            ),
                                            Column(
                                              children: [
                                                Text(
                                                  "Future Balance",
                                                  style: CustomWidget(
                                                      context: context)
                                                      .CustomTextStyle(
                                                      Theme.of(context)
                                                          .splashColor,
                                                      FontWeight.w400,
                                                      'FontRegular'),
                                                  softWrap: true,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                                Text(
                                                  coinList[index]
                                                      .future_balance
                                                      .toString(),
                                                  style: CustomWidget(
                                                      context: context)
                                                      .CustomTextStyle(
                                                      Theme.of(context)
                                                          .splashColor,
                                                      FontWeight.w400,
                                                      'FontRegular'),
                                                  softWrap: true,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                              ],
                                              crossAxisAlignment: CrossAxisAlignment.end,
                                            ),
                                          ],
                                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                        ),
                                        SizedBox(height: 10.0,),

                                        Padding(
                                          padding: const EdgeInsets.only(
                                              top: 10.0,left: 10.0, right: 10.0),
                                          child: Column(
                                            children: [
                                              const SizedBox(
                                                height: 10.0,
                                              ),
                                              Padding(
                                                padding: EdgeInsets.only(
                                                    left: 10.0, right: 10.0),
                                                child: Row(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                                  crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                                  children: [
                                                    InkWell(
                                                      child: Container(
                                                        decoration: BoxDecoration(
                                                            color: CustomTheme.of(
                                                                context)
                                                                .cardColor,
                                                            borderRadius:
                                                            const BorderRadius
                                                                .all(
                                                                Radius
                                                                    .circular(
                                                                    5.0)),
                                                            border: Border.all(
                                                                color:
                                                                CustomTheme.of(
                                                                    context)
                                                                    .cardColor,
                                                                width: 0.5)),
                                                        padding:
                                                        const EdgeInsets.only(
                                                            top: 8.0,
                                                            bottom: 8.0,
                                                            left: 25.0,
                                                            right: 25.0),
                                                        child: Center(
                                                          child: Text(
                                                            AppLocalizations
                                                                .instance
                                                                .text(
                                                                "loc_deposit"),
                                                            style: CustomWidget(
                                                                context:
                                                                context)
                                                                .CustomTextStyle(
                                                                Theme.of(
                                                                    context)
                                                                    .splashColor,
                                                                FontWeight.w500,
                                                                'FontRegular'),
                                                          ),
                                                        ),
                                                      ),
                                                      onTap: () {
                                                        Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                              builder: (context) =>
                                                                  DepositScreen(
                                                                      id: coinList[
                                                                      index]
                                                                          .id
                                                                          .toString()),
                                                            ));
                                                      },
                                                    ),
                                                    InkWell(
                                                      onTap: () {
                                                        Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                              builder: (context) =>
                                                              const WithDraw(),
                                                            ));
                                                      },
                                                      child: Container(
                                                        decoration: BoxDecoration(
                                                            borderRadius:
                                                            const BorderRadius
                                                                .all(
                                                                Radius
                                                                    .circular(
                                                                    5.0)),
                                                            color: CustomTheme.of(
                                                                context)
                                                                .cardColor,
                                                            border: Border.all(
                                                                color:
                                                                CustomTheme.of(
                                                                    context)
                                                                    .cardColor,
                                                                width: 0.5)),
                                                        padding:
                                                        const EdgeInsets.only(
                                                            top: 8.0,
                                                            bottom: 8.0,
                                                            left: 25.0,
                                                            right: 25.0),
                                                        child: Center(
                                                          child: Text(
                                                            AppLocalizations
                                                                .instance
                                                                .text(
                                                                "loc_withdraw"),
                                                            style: CustomWidget(
                                                                context:
                                                                context)
                                                                .CustomTextStyle(
                                                                Theme.of(
                                                                    context)
                                                                    .splashColor,
                                                                FontWeight.w500,
                                                                'FontRegular'),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
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
                                    color: CustomTheme.of(context).backgroundColor,
                                  )
                                ],
                              );
                            },
                          ),
                        )
                        ],
                      )
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

  getCoinList() {
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

  getBalanceList(){
    apiUtils.getWalletBalance().then((WalletBalModel loginData) {
      print(loginData.statusCode);
      if (loginData.statusCode == 200) {
        setState(() {
          loading = false;
          btcBalance = loginData.data!.btcBalance.toString();
          usdBalance = loginData.data!.usdtBalance.toString();
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


