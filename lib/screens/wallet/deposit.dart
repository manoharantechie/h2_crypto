import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:h2_crypto/common/custom_widget.dart';
import 'package:h2_crypto/data/api_utils.dart';
import 'package:h2_crypto/data/crypt_model/user_wallet_balance_model.dart';

import '../../../common/localization/localizations.dart';
import '../../../common/theme/custom_theme.dart';

class DepositScreen extends StatefulWidget {
  final String id;

  final List<UserWalletResult> coinList;

  const DepositScreen({Key? key, required this.id, required this.coinList})
      : super(key: key);

  @override
  State<DepositScreen> createState() => _DepositAddressState();
}

class _DepositAddressState extends State<DepositScreen> {
  List<UserWalletResult> coinList = [];
  List<UserWalletResult> searchCoinList = [];
  UserWalletResult? selectedCoin;
  APIUtils apiUtils = APIUtils();
  bool loading = false;
  ScrollController controller = ScrollController();
  List<UserWalletResult>? mugavari;
  int indexVal = 0;
  String address = "";
  String type = "";

  String bank_name = "";
  String bank_address = "";
  String beneficiary_name = "";
  String beneficiary_address = "";
  String bank_routing_number = "";
  String bank_routing_swift = "";
  String bank_account_number = "";
  String sfox_ref_id = "";
  TextEditingController searchController = TextEditingController();
  FocusNode searchFocus = FocusNode();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loading = true;
    coinList = widget.coinList;
    selectedCoin = coinList[int.parse(widget.id)];
    type = selectedCoin!.type.toString();
    print(type);
    getDetails();
    getFiatDetails();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: CustomTheme
            .of(context)
            .primaryColor,
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
                color: CustomTheme
                    .of(context)
                    .splashColor,
                allowDrawingOutsideViewBox: true,
              ),
            )),
        centerTitle: true,
        title: Text(
          AppLocalizations.instance.text("loc_deposit_address"),
          style: TextStyle(
            fontFamily: 'FontSpecial',
            color: CustomTheme
                .of(context)
                .splashColor,
            fontWeight: FontWeight.w500,
            fontSize: 14.0,
          ),
        ),
      ),
      body: Container(
          margin: EdgeInsets.only(left: 0, right: 0, bottom: 0.0),
          height: MediaQuery
              .of(context)
              .size
              .height,
          width: MediaQuery
              .of(context)
              .size
              .width,
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
                    CustomTheme
                        .of(context)
                        .primaryColor,
                    CustomTheme
                        .of(context)
                        .backgroundColor,
                    CustomTheme
                        .of(context)
                        .accentColor,
                  ])),
          child: loading
              ? CustomWidget(context: context).loadingIndicator(
            CustomTheme
                .of(context)
                .splashColor,
          )
              : SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(
                  top: 5.0, bottom: 10.0, right: 15.0, left: 15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InkWell(
                    onTap: () {
                      showSheeet(context);
                    },
                    child: Container(
                      width: MediaQuery
                          .of(context)
                          .size
                          .width,
                      padding: EdgeInsets.fromLTRB(12.0, 10.0, 12, 10.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5.0),
                        color: CustomTheme
                            .of(context)
                            .buttonColor
                            .withOpacity(0.2),
                      ),
                      child: Theme(
                          data: Theme.of(context).copyWith(
                            canvasColor:
                            CustomTheme
                                .of(context)
                                .cardColor,
                          ),
                          child: Row(
                            mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                selectedCoin!.symbol
                                    .toString()
                                    .toUpperCase(),
                                style: CustomWidget(context: context)
                                    .CustomSizedTextStyle(
                                    14.0,
                                    Theme
                                        .of(context)
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
                          )),
                    ),
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  type.toString() == "Type.COIN"
                      ? cryptoDeposit()
                      : fiatDeposit()
                ],
              ),
            ),
          )),
    );
  }

  Widget cryptoDeposit() {
    return Column(
      children: [
        Center(
          child: Container(
            padding: EdgeInsets.all(1),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5), color: Colors.white),
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
                // try {
                //   var imageId = await ImageDownloader.downloadImage(
                //       "https://chart.googleapis.com/chart?chs=250x250&cht=qr&chl=" +
                //           address.toString());
                //   if (imageId == null) {
                //     return;
                //   }
                //   var path =
                //       await ImageDownloader.findPath(imageId);
                // } on PlatformException catch (error) {
                //   print(error);
                // }
              },
              child: Container(
                padding: EdgeInsets.all(4.0),
                width: MediaQuery
                    .of(context)
                    .size
                    .width * 0.3,
                decoration: BoxDecoration(
                  color: CustomTheme
                      .of(context)
                      .cardColor,
                  borderRadius: BorderRadius.all(
                    Radius.circular(2.0),
                  ),
                ),
                child: Center(
                  child: Text(
                    "Save the QR Code",
                    style: CustomWidget(context: context).CustomSizedTextStyle(
                        12.0,
                        Theme
                            .of(context)
                            .buttonColor,
                        FontWeight.w400,
                        'FontRegular'),
                  ),
                ),
              ),
            )),
        const SizedBox(
          height: 30.0,
        ),
        const SizedBox(
          height: 10.0,
        ),
        Container(
          padding: EdgeInsets.all(12.0),
          decoration: BoxDecoration(
            color: CustomTheme
                .of(context)
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
                child: Text(address==""?"Address not generated":address,
                    style: CustomWidget(context: context).CustomSizedTextStyle(
                        12.0,
                        Theme
                            .of(context)
                            .hintColor,
                        FontWeight.w400,
                        'FontRegular')),
              ),
              SizedBox(
                width: 30.0,
              ),
              InkWell(
                onTap: () {
                  if(address=="")
                    {

                    }
                  else
                    {
                      Clipboard.setData(ClipboardData(text: address));
                      CustomWidget(context: context)
                          .custombar("Deposit", "Address was Copied", true);
                    }

                },
                child: Icon(
                  Icons.copy,
                  color: Theme
                      .of(context)
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
              style: CustomWidget(context: context).CustomSizedTextStyle(
                  12.0,
                  Theme
                      .of(context)
                      .hintColor
                      .withOpacity(0.5),
                  FontWeight.w400,
                  'FontRegular'),
              textAlign: TextAlign.justify,
            ),
            SizedBox(
              height: 10.0,
            ),
            Text(
              "Each user may create up to 5 groups of API keys. The platform currently supports most mainstream currencies. For a full list of supported currencies, click here.",
              style: CustomWidget(context: context).CustomSizedTextStyle(
                  12.0,
                  Theme
                      .of(context)
                      .hintColor
                      .withOpacity(0.5),
                  FontWeight.w400,
                  'FontRegular'),
              textAlign: TextAlign.justify,
            ),
            SizedBox(
              height: 10.0,
            ),
            Text(
              "Please keep your API key confidential to protect your account. For security reasons, we recommend you link your IP address with your API key. To link your API Key with multiple addresses, you may separate each of them with a comma such as 192.168.1.1, 192.168.1.2, 192.168.1.3. Each API key can be linked with up to 4 IP addresses.",
              style: CustomWidget(context: context).CustomSizedTextStyle(
                  12.0,
                  Theme
                      .of(context)
                      .hintColor
                      .withOpacity(0.5),
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
    );
  }

  Widget fiatDeposit() {
    return Column(
      children: [
        const SizedBox(
          height: 10.0,
        ),
        Container(
            padding: EdgeInsets.all(12.0),
            decoration: BoxDecoration(
              color: CustomTheme
                  .of(context)
                  .buttonColor
                  .withOpacity(0.2),
              borderRadius: BorderRadius.all(
                Radius.circular(5.0),
              ),
            ),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Bank Name:",
                          style: CustomWidget(context: context)
                              .CustomTextStyle(
                              Theme
                                  .of(context)
                                  .hintColor
                                  .withOpacity(0.6),
                              FontWeight.w500,
                              'FontRegular'),),
                        Text(bank_name,
                            style: CustomWidget(context: context)
                                .CustomSizedTextStyle(
                                12.0,
                                Theme
                                    .of(context)
                                    .buttonColor,
                                FontWeight.w400,
                                'FontRegular')),
                      ],
                    ),
                    SizedBox(
                      width: 30.0,
                    ),
                    InkWell(
                      onTap: () {
                        Clipboard.setData(ClipboardData(text: bank_name));
                        CustomWidget(context: context)
                            .custombar("Deposit", "Bank Name was Copied", true);
                      },
                      child: Icon(
                        Icons.copy,
                        color: Theme
                            .of(context)
                            .buttonColor,
                        size: 15.0,
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 10.0,),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Bank Address:",
                          style: CustomWidget(context: context)
                              .CustomTextStyle(
                              Theme
                                  .of(context)
                                  .hintColor
                                  .withOpacity(0.6),
                              FontWeight.w500,
                              'FontRegular'),),
                        Text(bank_address,
                            style: CustomWidget(context: context)
                                .CustomSizedTextStyle(
                                12.0,
                                Theme
                                    .of(context)
                                    .buttonColor,
                                FontWeight.w400,
                                'FontRegular')),
                      ],
                    ),),
                    SizedBox(
                      width: 30.0,
                    ),
                    InkWell(
                      onTap: () {
                        Clipboard.setData(ClipboardData(text: bank_address));
                        CustomWidget(context: context)
                            .custombar(
                            "Deposit", "Bank Address was Copied", true);
                      },
                      child: Icon(
                        Icons.copy,
                        color: Theme
                            .of(context)
                            .buttonColor,
                        size: 15.0,
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 10.0,),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Beneficiary Name:",
                          style: CustomWidget(context: context)
                              .CustomTextStyle(
                              Theme
                                  .of(context)
                                  .hintColor
                                  .withOpacity(0.6),
                              FontWeight.w500,
                              'FontRegular'),),
                        Text(beneficiary_name,
                            style: CustomWidget(context: context)
                                .CustomSizedTextStyle(
                                12.0,
                                Theme
                                    .of(context)
                                    .buttonColor,
                                FontWeight.w400,
                                'FontRegular')),
                      ],
                    ),
                    SizedBox(
                      width: 30.0,
                    ),
                    InkWell(
                      onTap: () {
                        Clipboard.setData(
                            ClipboardData(text: beneficiary_name));
                        CustomWidget(context: context)
                            .custombar(
                            "Deposit", "Beneficiary Name was Copied", true);
                      },
                      child: Icon(
                        Icons.copy,
                        color: Theme
                            .of(context)
                            .buttonColor,
                        size: 15.0,
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 10.0,),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Beneficiary Addres:",
                          style: CustomWidget(context: context)
                              .CustomTextStyle(
                              Theme
                                  .of(context)
                                  .hintColor
                                  .withOpacity(0.6),
                              FontWeight.w500,
                              'FontRegular'),),
                        Text(beneficiary_address,
                            style: CustomWidget(context: context)
                                .CustomSizedTextStyle(
                                12.0,
                                Theme
                                    .of(context)
                                    .buttonColor,
                                FontWeight.w400,
                                'FontRegular')),
                      ],
                    ),),
                    SizedBox(
                      width: 30.0,
                    ),
                    InkWell(
                      onTap: () {
                        Clipboard.setData(
                            ClipboardData(text: beneficiary_address));
                        CustomWidget(context: context)
                            .custombar(
                            "Deposit", "Beneficiary Addres was Copied", true);
                      },
                      child: Icon(
                        Icons.copy,
                        color: Theme
                            .of(context)
                            .buttonColor,
                        size: 15.0,
                      ),
                    )
                  ],
                ),

                const SizedBox(height: 10.0,),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Bank Routing Number:",
                          style: CustomWidget(context: context)
                              .CustomTextStyle(
                              Theme
                                  .of(context)
                                  .hintColor
                                  .withOpacity(0.6),
                              FontWeight.w500,
                              'FontRegular'),),
                        Text(bank_routing_number,
                            style: CustomWidget(context: context)
                                .CustomSizedTextStyle(
                                12.0,
                                Theme
                                    .of(context)
                                    .buttonColor,
                                FontWeight.w400,
                                'FontRegular')),
                      ],
                    ),),
                    SizedBox(
                      width: 30.0,
                    ),
                    InkWell(
                      onTap: () {
                        Clipboard.setData(
                            ClipboardData(text: bank_routing_number));
                        CustomWidget(context: context)
                            .custombar(
                            "Deposit", "Bank Routing Number was Copied", true);
                      },
                      child: Icon(
                        Icons.copy,
                        color: Theme
                            .of(context)
                            .buttonColor,
                        size: 15.0,
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 10.0,),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Bank Routing Swift:",
                          style: CustomWidget(context: context)
                              .CustomTextStyle(
                              Theme
                                  .of(context)
                                  .hintColor
                                  .withOpacity(0.6),
                              FontWeight.w500,
                              'FontRegular'),),
                        Text(bank_routing_swift,
                            style: CustomWidget(context: context)
                                .CustomSizedTextStyle(
                                12.0,
                                Theme
                                    .of(context)
                                    .buttonColor,
                                FontWeight.w400,
                                'FontRegular')),
                      ],
                    ),),
                    SizedBox(
                      width: 30.0,
                    ),
                    InkWell(
                      onTap: () {
                        Clipboard.setData(
                            ClipboardData(text: bank_routing_swift));
                        CustomWidget(context: context)
                            .custombar(
                            "Deposit", "Bank Routing Swift was Copied", true);
                      },
                      child: Icon(
                        Icons.copy,
                        color: Theme
                            .of(context)
                            .buttonColor,
                        size: 15.0,
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 10.0,),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Bank Account Number:",
                          style: CustomWidget(context: context)
                              .CustomTextStyle(
                              Theme
                                  .of(context)
                                  .hintColor
                                  .withOpacity(0.6),
                              FontWeight.w500,
                              'FontRegular'),),
                        Text(bank_account_number,
                            style: CustomWidget(context: context)
                                .CustomSizedTextStyle(
                                12.0,
                                Theme
                                    .of(context)
                                    .buttonColor,
                                FontWeight.w400,
                                'FontRegular')),
                      ],
                    ),),
                    SizedBox(
                      width: 30.0,
                    ),
                    InkWell(
                      onTap: () {
                        Clipboard.setData(
                            ClipboardData(text: bank_account_number));
                        CustomWidget(context: context)
                            .custombar(
                            "Deposit", "Bank Account Number was Copied", true);
                      },
                      child: Icon(
                        Icons.copy,
                        color: Theme
                            .of(context)
                            .buttonColor,
                        size: 15.0,
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 10.0,),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("User Reference Id:",
                          style: CustomWidget(context: context)
                              .CustomTextStyle(
                              Theme
                                  .of(context)
                                  .hintColor
                                  .withOpacity(0.6),
                              FontWeight.w500,
                              'FontRegular'),),
                        Text(sfox_ref_id,
                            style: CustomWidget(context: context)
                                .CustomSizedTextStyle(
                                12.0,
                                Theme
                                    .of(context)
                                    .buttonColor,
                                FontWeight.w400,
                                'FontRegular')),
                      ],
                    ),),
                    SizedBox(
                      width: 30.0,
                    ),
                    InkWell(
                      onTap: () {
                        Clipboard.setData(
                            ClipboardData(text: sfox_ref_id));
                        CustomWidget(context: context)
                            .custombar(
                            "Deposit", "User Reference Id was Copied", true);
                      },
                      child: Icon(
                        Icons.copy,
                        color: Theme
                            .of(context)
                            .buttonColor,
                        size: 15.0,
                      ),
                    )
                  ],
                ),

              ],
            )
        ),
        const SizedBox(
          height: 30.0,
        ),

      ],
    );
  }

  showSheeet(BuildContext contexts) {
    return showModalBottomSheet(
        context: contexts,
        isScrollControlled: true,
        builder: (context) {
          return StatefulBuilder(
            builder: (BuildContext context, StateSetter setStates) {
              return Container(
                height: MediaQuery
                    .of(context)
                    .size
                    .height * 0.9,
                width: MediaQuery
                    .of(context)
                    .size
                    .width,
                color: Theme
                    .of(context)
                    .primaryColor,
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
                            width: MediaQuery
                                .of(context)
                                .size
                                .width * 0.8,
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
                                  coinList = [];

                                  for (int m = 0;
                                  m < searchCoinList.length;
                                  m++) {
                                    if (searchCoinList[m]
                                        .symbol
                                        .toString()
                                        .toLowerCase()
                                        .contains(value
                                        .toString()
                                        .toLowerCase()) ||
                                        searchCoinList[m]
                                            .symbol
                                            .toString()
                                            .toLowerCase()
                                            .contains(value
                                            .toString()
                                            .toLowerCase())) {
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
                                    color: Theme
                                        .of(context)
                                        .hintColor,
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.w400),
                                filled: true,
                                fillColor: CustomTheme
                                    .of(context)
                                    .backgroundColor
                                    .withOpacity(0.5),
                                border: OutlineInputBorder(
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(5.0)),
                                  borderSide: BorderSide(
                                      color: CustomTheme
                                          .of(context)
                                          .splashColor
                                          .withOpacity(0.5),
                                      width: 1.0),
                                ),
                                disabledBorder: OutlineInputBorder(
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(5.0)),
                                  borderSide: BorderSide(
                                      color: CustomTheme
                                          .of(context)
                                          .splashColor
                                          .withOpacity(0.5),
                                      width: 1.0),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(5.0)),
                                  borderSide: BorderSide(
                                      color: CustomTheme
                                          .of(context)
                                          .splashColor
                                          .withOpacity(0.5),
                                      width: 1.0),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(5.0)),
                                  borderSide: BorderSide(
                                      color: CustomTheme
                                          .of(context)
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
                                  color: Theme
                                      .of(context)
                                      .hintColor,
                                ),
                              )),
                        ),
                        const SizedBox(
                          width: 10.0,
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 15.0,
                    ),
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
                                        setState(() {
                                          selectedCoin = coinList[index];
                                          indexVal = 0;

                                          type =
                                              coinList[index].type.toString();
                                          print(type);
                                          if (type == "Type.COIN") {
                                            loading = true;

                                            address="";
                                            getDetails();
                                          }
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
                                              coinList[index].image.toString(),
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 10.0,
                                          ),
                                          Text(
                                            coinList[index]
                                                .symbol
                                                .toString()
                                                .toUpperCase(),
                                            style: CustomWidget(
                                                context: context)
                                                .CustomSizedTextStyle(
                                                16.0,
                                                Theme
                                                    .of(context)
                                                    .splashColor,
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
                                      width: MediaQuery
                                          .of(context)
                                          .size
                                          .width,
                                      color:
                                      CustomTheme
                                          .of(context)
                                          .backgroundColor,
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

  getDetails() {
    apiUtils
        .getDepositDetails(selectedCoin!.symbol.toString())
        .then((dynamic loginData) {
      setState(() {
        loading = false;
        var listData = loginData;
        if(listData.toString()=="{}")
          {

          }
        else
          {
            address = listData[selectedCoin!.symbol.toString()][0]["address"];
          }

      });
    }).catchError((Object error) {
      print(error);
    });
  }

  getFiatDetails() {
    apiUtils.getFiatDepositDetails().then((dynamic loginData) {
      setState(() {
        loading = false;
        var listData = loginData;
        bank_name = listData['data']['bank_name'];
        bank_address = listData['data']['bank_address'];
        beneficiary_name = listData['data']['beneficiary_name'];
        beneficiary_address = listData['data']['beneficiary_address'];
        bank_routing_number = listData['data']['bank_routing_number'];
        bank_routing_swift = listData['data']['bank_routing_swift'];
        bank_account_number = listData['data']['bank_account_number'];
        sfox_ref_id = listData['data']['sfox_ref_id'];
      });
    }).catchError((Object error) {
      print(error);
    });
  }
}
