import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:h2_crypto/common/custom_widget.dart';
import 'package:h2_crypto/data/api_utils.dart';
import 'package:h2_crypto/data/model/wallet_list_model.dart';

import '../../../common/localization/localizations.dart';
import '../../../common/theme/custom_theme.dart';

class DepositScreen extends StatefulWidget {
  final String id;

  const DepositScreen({Key? key, required this.id}) : super(key: key);

  @override
  State<DepositScreen> createState() => _DepositAddressState();
}

class _DepositAddressState extends State<DepositScreen> {
  List<WalletList> coinList = [];
  List<WalletList> searchCoinList = [];
  WalletList? selectedCoin;
  APIUtils apiUtils = APIUtils();
  bool loading = false;
  ScrollController controller = ScrollController();
  List<Mugavari>? mugavari;
  int indexVal = 0;
  String address = "";

  TextEditingController searchController = TextEditingController();
  FocusNode searchFocus = FocusNode();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loading = true;
    getCoinList();
  }

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
                height: 10.0,
                width: 10.0,
                color: CustomTheme.of(context).splashColor,
                allowDrawingOutsideViewBox: true,
              ),
            )),
        centerTitle: true,
        title: Text(
          AppLocalizations.instance.text("loc_deposit_address"),
          style: TextStyle(
            fontFamily: 'FontSpecial',
            color: CustomTheme.of(context).splashColor,
            fontWeight: FontWeight.w500,
            fontSize: 14.0,
          ),
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
        child: loading
            ? CustomWidget(context: context).loadingIndicator(
                CustomTheme.of(context).splashColor,
              )
            : SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(
                top: 5.0, bottom: 10.0, right: 15.0, left: 15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InkWell(
                  onTap: (){
                    showSheeet(context);
                  },
                  child:   Container(
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.fromLTRB(12.0, 10.0, 12,10.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5.0),
                      color: CustomTheme.of(context)
                          .buttonColor
                          .withOpacity(0.2),
                    ),
                    child: Theme(
                        data: Theme.of(context).copyWith(
                          canvasColor: CustomTheme.of(context).cardColor,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              selectedCoin!.asset!.symbol.toString(),
                              style: CustomWidget(context: context)
                                  .CustomSizedTextStyle(
                                  14.0,
                                  Theme.of(context)
                                      .splashColor,
                                  FontWeight.w400,
                                  'FontRegular'),
                            ),
                            Row(
                              children: [
                                // Text(
                                //   selectedCoin!.asset!.type.toString(),
                                //   style: CustomWidget(context: context)
                                //       .CustomSizedTextStyle(
                                //       14.0,
                                //       Theme.of(context)
                                //           .hintColor
                                //           .withOpacity(0.5),
                                //       FontWeight.w400,
                                //       'FontRegular'),
                                // ),
                                const SizedBox(
                                  width: 5.0,
                                ),
                                Icon(
                                  Icons.arrow_forward_ios_rounded,
                                  size: 15.0,
                                  // color: AppColors.otherTextColor,
                                ),
                              ],
                            )
                          ],
                        )
                    ),
                  ),
                ),
                // Container(
                //   width: MediaQuery.of(context).size.width,
                //   padding: EdgeInsets.fromLTRB(12.0, 0.0, 12, 0.0),
                //   decoration: BoxDecoration(
                //     borderRadius: BorderRadius.circular(5.0),
                //     color: CustomTheme.of(context)
                //         .buttonColor
                //         .withOpacity(0.2),
                //   ),
                //   child: Theme(
                //     data: Theme.of(context).copyWith(
                //       canvasColor: CustomTheme.of(context).cardColor,
                //     ),
                //     child: DropdownButtonHideUnderline(
                //       child: DropdownButton(
                //           menuMaxHeight:
                //           MediaQuery.of(context).size.height * 0.7,
                //           items: coinList
                //               .map((value) => DropdownMenuItem(
                //             child: Text(
                //               value.asset!.symbol.toString(),
                //               style: CustomWidget(context: context)
                //                   .CustomSizedTextStyle(
                //                   14.0,
                //                   Theme.of(context).hintColor,
                //                   FontWeight.w400,
                //                   'FontRegular'),
                //             ),
                //             value: value,
                //           ))
                //               .toList(),
                //           onChanged: (value) async {
                //             setState(() {
                //               selectedCoin = value as WalletList?;
                //               indexVal = 0;
                //               mugavari!.clear();
                //               mugavari = [];
                //               mugavari = selectedCoin!.mugavari;
                //               address=mugavari![0].address.toString();
                //             });
                //           },
                //           hint: Text(
                //             "Select Category",
                //             style: CustomWidget(context: context)
                //                 .CustomSizedTextStyle(
                //                 14.0,
                //                 Theme.of(context)
                //                     .hintColor
                //                     .withOpacity(0.5),
                //                 FontWeight.w400,
                //                 'FontRegular'),
                //           ),
                //           isExpanded: true,
                //           value: selectedCoin,
                //           icon: Row(
                //             children: [
                //               Text(
                //                 selectedCoin!.asset!.type.toString(),
                //                 style: CustomWidget(context: context)
                //                     .CustomSizedTextStyle(
                //                     14.0,
                //                     Theme.of(context)
                //                         .hintColor
                //                         .withOpacity(0.5),
                //                     FontWeight.w400,
                //                     'FontRegular'),
                //               ),
                //               const SizedBox(
                //                 width: 5.0,
                //               ),
                //               Icon(
                //                 Icons.arrow_forward_ios_rounded,
                //                 size: 15.0,
                //                 // color: AppColors.otherTextColor,
                //               ),
                //             ],
                //           )),
                //     ),
                //   ),
                // ),
                const SizedBox(
                  height: 20.0,
                ),
                mugavari!.length > 0
                    ? Container(
                  child: ListView.builder(
                    itemCount: mugavari!.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (BuildContext context, int index) {
                      return Row(
                        children: [
                          InkWell(
                            onTap: () {
                              setState(() {
                                indexVal = index;
                                address=mugavari![index].address.toString();
                              });
                            },
                            child: Container(
                                padding: EdgeInsets.fromLTRB(
                                    15.0, 0.0, 15.0, 0.0),
                                decoration: BoxDecoration(

                                  border: Border.all(
                                      color: CustomTheme.of(context)
                                          .cardColor,
                                      width: 1.0),
                                  borderRadius:
                                  BorderRadius.circular(5.0),
                                  color: indexVal==index?CustomTheme.of(context)
                                      .buttonColor
                                      .withOpacity(0.5):CustomTheme.of(context)
                                      .cardColor
                                      .withOpacity(0.2),
                                ),
                                child: Center(
                                  child: Text(
                                    mugavari![index]
                                        .chain
                                        .toString()
                                        .toUpperCase(),
                                    style:
                                    CustomWidget(context: context)
                                        .CustomSizedTextStyle(
                                        14.0,
                                        Theme.of(context)
                                            .hintColor,
                                        FontWeight.w400,
                                        'FontRegular'),
                                  ),
                                )),
                          ),
                          const SizedBox(
                            width: 10.0,
                          )
                        ],
                      );
                    },
                  ),
                  height: 35.0,
                )
                    : Container(),
                const SizedBox(
                  height: 20.0,
                ),
                Center(
                  child: Container(
                    padding: EdgeInsets.all(1),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.white),
                    child: Image.network(
                      "https://chart.googleapis.com/chart?chs=250x250&cht=qr&chl=" +
                          address.toString(),
                      height: 155.0,
                      width: 150.0,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20.0,
                ),
                Center(
                    child: InkWell(
                      onTap: () async {
                        //try {
                        //   var imageId = await ImageDownloader.downloadImage(
                        //       "https://chart.googleapis.com/chart?chs=250x250&cht=qr&chl=" +
                        //           address.toString());
                        //   if (imageId == null) {
                        //     return;
                        //   }
                        //   var path = await ImageDownloader.findPath(imageId);
                        // } on PlatformException catch (error) {
                        //   print(error);
                        // }
                      },
                      child: Container(
                        padding: EdgeInsets.all(4.0),
                        width: MediaQuery.of(context).size.width * 0.3,
                        decoration: BoxDecoration(
                          color: CustomTheme.of(context).cardColor,
                          borderRadius: BorderRadius.all(
                            Radius.circular(2.0),
                          ),
                        ),
                        child: Center(
                          child: Text(
                            "Save the QR Code",
                            style: CustomWidget(context: context)
                                .CustomSizedTextStyle(
                                12.0,
                                Theme.of(context).buttonColor,
                                FontWeight.w400,
                                'FontRegular'),
                          ),
                        ),
                      ),
                    )),
                const SizedBox(
                  height: 30.0,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "ERC-20Deposit Address",
                      style: CustomWidget(context: context)
                          .CustomSizedTextStyle(
                          12.0,
                          Theme.of(context).buttonColor,
                          FontWeight.w400,
                          'FontRegular'),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10.0,
                ),
                Container(
                  padding: EdgeInsets.all(12.0),
                  decoration: BoxDecoration(
                    color: CustomTheme.of(context)
                        .buttonColor
                        .withOpacity(0.2),
                    borderRadius: BorderRadius.all(
                      Radius.circular(5.0),
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Text(
                            address,
                            style: CustomWidget(context: context)
                                .CustomSizedTextStyle(
                                12.0,
                                Theme.of(context).hintColor,
                                FontWeight.w400,
                                'FontRegular')),
                      ),
                      SizedBox(
                        width: 30.0,
                      ),
                      InkWell(
                        onTap: () {
                          Clipboard.setData(ClipboardData(text: address));
                          CustomWidget(context: context).custombar(
                              "Deposit", "Address was Copied", true);
                        },
                        child: Icon(
                        Icons.copy,
                        color: Theme.of(context)
                            .buttonColor,
                        size: 22.0,
                      ),
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  height: 30.0,
                ),
                Column(
                  children: [
                    Text(
                      "H2Crypto’s API allows users to make market inquiries, trade automatically and perform various other tasks. You may find out more here ",
                      style: CustomWidget(context: context)
                          .CustomSizedTextStyle(
                          12.0,
                          Theme.of(context).hintColor.withOpacity(0.5),
                          FontWeight.w400,
                          'FontRegular'),
                      textAlign: TextAlign.justify,
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Text(
                      "Each user may create up to 5 groups of API keys. The platform currently supports most mainstream currencies. For a full list of supported currencies, click here.",
                      style: CustomWidget(context: context)
                          .CustomSizedTextStyle(
                          12.0,
                          Theme.of(context).hintColor.withOpacity(0.5),
                          FontWeight.w400,
                          'FontRegular'),
                      textAlign: TextAlign.justify,
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Text(
                      "Please keep your API key confidential to protect your account. For security reasons, we recommend you link your IP address with your API key. To link your API Key with multiple addresses, you may separate each of them with a comma such as 192.168.1.1, 192.168.1.2, 192.168.1.3. Each API key can be linked with up to 4 IP addresses.",
                      style: CustomWidget(context: context)
                          .CustomSizedTextStyle(
                          12.0,
                          Theme.of(context).hintColor.withOpacity(0.5),
                          FontWeight.w400,
                          'FontRegular'),
                      textAlign: TextAlign.justify,
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 15.0,
                ),
              ],
            ),
          ),
        )
      ),
    );
  }
  showSheeet(BuildContext contexts) {
    return showModalBottomSheet(
        context: contexts,
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
                                    coinList=[];





                                    for (int m = 0; m < searchCoinList.length; m++) {
                                      if (searchCoinList[m]
                                          .asset!.assetname
                                          .toString()
                                          .toLowerCase()
                                          .contains(value
                                          .toString()
                                          .toLowerCase()) ||
                                          searchCoinList[m]
                                              .asset!
                                              .symbol
                                              .toString()
                                              .toLowerCase()
                                              .contains(value
                                              .toString()
                                              .toLowerCase()) ) {
                                        coinList.add(searchCoinList[m]);
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
                                    coinList.addAll(searchCoinList);
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
                    const SizedBox(height: 15.0,),
                    Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(top: 15.0),
                          child: ListView.builder(
                              controller: controller,
                              itemCount: coinList.length,
                              itemBuilder: ((BuildContext context, int index) {
                                return Column(
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        printAll();
                                        setState(() {
                                          selectedCoin=coinList[index];
                                          indexVal = 0;
                                                        mugavari!.clear();
                                                        mugavari = [];
                                                        mugavari = selectedCoin!.mugavari;
                                                        address=mugavari![0].address.toString();
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
                                                  coinList[index]
                                                      .asset!
                                                      .assetname
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
                                            coinList[index]
                                                .asset!.symbol
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
                              })),
                        )),
                  ],
                ),
              );
            },
          );
        });
  }
  getCoinList() {
    apiUtils.getWalletList().then((WalletListModel loginData) {
      if (loginData.statusCode == 200) {
        setState(() {
          loading = false;
          coinList = loginData.data!;
          searchCoinList = loginData.data!;

          if(widget.id==null || widget.id=="")
            {
              selectedCoin = coinList[0];

              mugavari = selectedCoin!.mugavari;

              if (mugavari!.length > 0) {
                address = mugavari![0].address.toString();
              }
            }
          else
            {
              for(int m=0;m<coinList.length;m++)
                {
                  if(coinList[m].id.toString()==widget.id)
                    {
                      selectedCoin = coinList[m];

                      mugavari = selectedCoin!.mugavari;

                      if (mugavari!.length > 0) {
                        address = mugavari![0].address.toString();
                      }
                    }
                }
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
  printAll(){
    print("Mano");
    setState(() {
    //  selectedCoin=coinList[0];
    });
  }
}
