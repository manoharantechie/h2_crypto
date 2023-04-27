import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:h2_crypto/common/custom_widget.dart';


import '../../../common/custom_button.dart';
import '../../../common/custom_widget.dart';
import '../../../common/localization/localizations.dart';
import '../../../common/theme/custom_theme.dart';

class TransferScreen extends StatefulWidget {
  const TransferScreen({Key? key}) : super(key: key);

  @override
  State<TransferScreen> createState() => _TransferScreenState();
}

class _TransferScreenState extends State<TransferScreen> {
  List<String> chartTime = ["Margin", "Fiat"];
  String selectedTime = "";

  bool selectedBtn = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    selectedTime = chartTime.first;
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
                height: 22.0,
                width: 22.0,
                allowDrawingOutsideViewBox: true,
                color: CustomTheme.of(context).splashColor,
              ),
            )),
        centerTitle: true,
        title: Text(
          AppLocalizations.instance.text("loc_transfer_head"),
          style: CustomWidget(context: context)
              .CustomSizedTextStyle(
              16.0,
              Theme.of(context).splashColor,
              FontWeight.w400,
              'FontRegular'),
        ),
        actions: <Widget>[
          Container(
            padding: const EdgeInsets.fromLTRB(0.0, 20.0, 10.0, 0.0),
            child: Text(
              AppLocalizations.instance.text("loc_transfer_head2"),
              style: CustomWidget(context: context)
                  .CustomSizedTextStyle(
                  12.0,
                  Theme.of(context).hintColor.withOpacity(0.5),
                  FontWeight.w400,
                  'FontRegular'),
            ),
          ),
        ],
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
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.all(15.0),
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color:
                          CustomTheme.of(context).buttonColor.withOpacity(0.2),
                      borderRadius: BorderRadius.all(
                        Radius.circular(5.0),
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              margin: EdgeInsets.fromLTRB(10, 5, 10, 0),
                              width: 8.0,
                              height: 8.0,
                              decoration: BoxDecoration(
                                  color: CustomTheme.of(context).indicatorColor,
                                  borderRadius: BorderRadius.circular(5.0)),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  "Spot",
                                  style: CustomWidget(context: context)
                                      .CustomSizedTextStyle(
                                      14.0,
                                      Theme.of(context).indicatorColor,
                                      FontWeight.w400,
                                      'FontRegular'),
                                ),
                                Text(
                                  "Avail balance",
                                  style: CustomWidget(context: context)
                                      .CustomSizedTextStyle(
                                      10.0,
                                      Theme.of(context).hintColor.withOpacity(0.5),
                                      FontWeight.w400,
                                      'FontRegular'),
                                ),
                                Text(
                                  "0",
                                  style: CustomWidget(context: context)
                                      .CustomSizedTextStyle(
                                      10.0,
                                      Theme.of(context).hintColor,
                                      FontWeight.w400,
                                      'FontRegular'),
                                ),
                                Text(
                                  "USDT",
                                  style: CustomWidget(context: context)
                                      .CustomSizedTextStyle(
                                      10.0,
                                      Theme.of(context).hintColor,
                                      FontWeight.w400,
                                      'FontRegular'),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Stack(
                              alignment: Alignment.center,
                              children: <Widget>[
                                Container(
                                  // margin: EdgeInsets.fromLTRB(10, 5, 10, 0),
                                  width: 1.0,
                                  height: 75.0,
                                  // height: 20.0,
                                  decoration: BoxDecoration(
                                      color: CustomTheme.of(context)
                                          .hintColor
                                          .withOpacity(0.5),
                                      borderRadius: BorderRadius.circular(5.0)),
                                ),
                                SizedBox(
                                  height: 10.0,
                                ),
                                Container(
                                  width: 45,
                                  height: 45,
                                  decoration: BoxDecoration(
                                      color:
                                          CustomTheme.of(context).buttonColor,
                                      borderRadius:
                                          BorderRadius.circular(25.0)),
                                  padding: const EdgeInsets.all(10.0),
                                  child: SvgPicture.asset(
                                    'assets/images/transfer.svg',
                                    height: 18.0,
                                    width: 18.0,
                                    allowDrawingOutsideViewBox: true,
                                    color: CustomTheme.of(context).hintColor,
                                  ),
                                ),
                                SizedBox(
                                  height: 10.0,
                                ),
                              ],
                            ),
                          ],
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              margin: EdgeInsets.fromLTRB(10, 12, 10, 0),
                              width: 8.0,
                              height: 8.0,
                              decoration: BoxDecoration(
                                  color: CustomTheme.of(context)
                                      .scaffoldBackgroundColor,
                                  borderRadius: BorderRadius.circular(5.0)),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.24,
                                  height: 30.0,
                                  padding:
                                      EdgeInsets.fromLTRB(2.0, 0.0, 5, 0.0),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: CustomTheme.of(context)
                                            .hintColor
                                            .withOpacity(0.0),
                                        width: 0.0),
                                    borderRadius: BorderRadius.circular(5.0),
                                    color: Colors.transparent,
                                  ),
                                  child: Theme(
                                    data: Theme.of(context).copyWith(
                                      canvasColor: CustomTheme.of(context)
                                          .backgroundColor,
                                    ),
                                    child: DropdownButtonHideUnderline(
                                      child: DropdownButton(
                                        menuMaxHeight:
                                            MediaQuery.of(context).size.height *
                                                0.5,
                                        items: chartTime
                                            .map((value) => DropdownMenuItem(
                                                  child: Text(
                                                    value.toString(),
                                                    style: CustomWidget(context: context)
                                                        .CustomSizedTextStyle(
                                                        14.0,
                                                        Theme.of(context).scaffoldBackgroundColor,
                                                        FontWeight.w400,
                                                        'FontRegular'),
                                                  ),
                                                  value: value,
                                                ))
                                            .toList(),
                                        onChanged: (value) async {
                                          setState(() {
                                            selectedTime = value.toString();
                                          });
                                        },
                                        hint: Text(
                                          "Select Category",
                                          style: CustomWidget(context: context)
                                              .CustomSizedTextStyle(
                                              12.0,
                                              Theme.of(context).errorColor,
                                              FontWeight.w500,
                                              'FontRegular'),
                                        ),
                                        isExpanded: true,
                                        value: selectedTime,
                                        icon: const Icon(
                                          Icons.arrow_drop_down,
                                          // color: AppColors.otherTextColor,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Text(
                                  "Avail balance",
                                  style: CustomWidget(context: context)
                                      .CustomSizedTextStyle(
                                      10.0,
                                      Theme.of(context).hintColor.withOpacity(0.5),
                                      FontWeight.w400,
                                      'FontRegular'),
                                ),
                                Text(
                                  "0",
                                  style: CustomWidget(context: context)
                                      .CustomSizedTextStyle(
                                      10.0,
                                      Theme.of(context).hintColor,
                                      FontWeight.w400,
                                      'FontRegular'),
                                ),
                                Text(
                                  "USDT",
                                  style: CustomWidget(context: context)
                                      .CustomSizedTextStyle(
                                      10.0,
                                      Theme.of(context).hintColor,
                                      FontWeight.w400,
                                      'FontRegular'),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(10.0, 5, 10.0, 5),
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 1.0,
                        color: CustomTheme.of(context)
                            .buttonColor
                            .withOpacity(0.5),
                      ),
                      color: Colors.transparent,
                      borderRadius: BorderRadius.all(
                        Radius.circular(5.0),
                      ),
                    ),
                    child: Row(
                      children: [
                        Flexible(
                          child: TextField(
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'BTC/USDT',
                              hintStyle: TextStyle(
                                fontSize: 13.0,
                                color: CustomTheme.of(context).buttonColor,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ),
                        Flexible(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Padding(
                                padding: EdgeInsets.fromLTRB(0, 0, 8, 0),
                                child: Text(
                                  "Select trading pair",
                                  style: CustomWidget(context: context)
                                      .CustomSizedTextStyle(
                                      12.0,
                                      Theme.of(context).hintColor.withOpacity(0.5),
                                      FontWeight.w400,
                                      'FontRegular'),
                                ),
                              ),
                              Container(
                                  padding: const EdgeInsets.all(3.0),
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.pop(context);
                                    },
                                    child: SvgPicture.asset(
                                      'assets/images/arrow_right.svg',
                                      height: 15.0,
                                      width: 15.0,
                                      allowDrawingOutsideViewBox: true,
                                      color: CustomTheme.of(context).hintColor,
                                    ),
                                  )),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                      ],
                    ),
                  ),
                const  SizedBox(
                    height: 10.0,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Container(
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                              border: Border.all(
                                width: 1.0,
                                color: CustomTheme.of(context)
                                    .buttonColor
                                    .withOpacity(0.5),
                              ),
                              color: selectedBtn
                                  ? Colors.transparent
                                  : CustomTheme.of(context)
                                      .hintColor
                                      .withOpacity(0.2),
                              borderRadius: BorderRadius.all(
                                Radius.circular(10.0),
                              ),
                            ),
                            padding: const EdgeInsets.all(16.0),
                            child: InkWell(
                              onTap: () {
                                setState(() {
                                  selectedBtn = true;
                                });
                              },
                              child: Text(
                                "USDT",
                                textAlign: TextAlign.center,
                                style: CustomWidget(context: context)
                                    .CustomSizedTextStyle(
                                    13.0,
                                    selectedBtn
                                        ? CustomTheme.of(context).buttonColor
                                        : CustomTheme.of(context).hintColor,
                                    FontWeight.w400,
                                    'FontRegular'),
                              ),
                            )),
                        flex: 1,
                      ),
                      const SizedBox(
                        width: 20.0,
                      ),
                      Flexible(
                        child: Container(
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                              border: Border.all(
                                width: 1.0,
                                color: CustomTheme.of(context)
                                    .buttonColor
                                    .withOpacity(0.5),
                              ),
                              color: !selectedBtn
                                  ? Colors.transparent
                                  : CustomTheme.of(context)
                                      .hintColor
                                      .withOpacity(0.2),
                              borderRadius: BorderRadius.all(
                                Radius.circular(10.0),
                              ),
                            ),
                            padding: const EdgeInsets.all(16.0),
                            child: InkWell(
                              onTap: () {
                                setState(() {
                                  selectedBtn = false;
                                });
                              },
                              child: Text(
                                "BTC",
                                textAlign: TextAlign.center,
                                style: CustomWidget(context: context)
                                    .CustomSizedTextStyle(
                                    13.0,
                                    !selectedBtn
                                        ? CustomTheme.of(context).buttonColor
                                        : CustomTheme.of(context).hintColor,
                                    FontWeight.w400,
                                    'FontRegular'),
                              ),
                            )),
                        flex: 1,
                      )
                    ],
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Container(
                    height: 50.0,
                    child: TextField(
                      enabled: true,
                      textDirection: TextDirection.ltr,
                      style: TextStyle(
                        fontSize: 16.0,
                        color: Colors.white,
                        fontWeight: FontWeight.w400,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Amount(USDT)',
                        contentPadding: EdgeInsets.only(top: 5.0, left: 10.0),
                        suffixIcon: Container(
                          width: 70.0,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Container(
                                margin: EdgeInsets.fromLTRB(10, 5, 10, 0),
                                width: 1.0,
                                height: 20.0,
                                decoration: BoxDecoration(
                                    color: CustomTheme.of(context)
                                        .hintColor
                                        .withOpacity(0.5),
                                    borderRadius: BorderRadius.circular(5.0)),
                              ),
                              Container(
                                margin: EdgeInsets.fromLTRB(5, 5, 5, 0),
                                child: Text(
                                  "All",
                                  style: CustomWidget(context: context)
                                      .CustomSizedTextStyle(
                                      12.0,
                                      Theme.of(context).hintColor.withOpacity(0.5),
                                      FontWeight.w400,
                                      'FontRegular'),
                                ),
                              ),
                              const SizedBox(
                                width: 10.0,
                              )
                            ],
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          borderSide: BorderSide(
                              color: CustomTheme.of(context)
                                  .buttonColor
                                  .withOpacity(0.5),
                              width: 1.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          borderSide: BorderSide(
                              color: CustomTheme.of(context)
                                  .buttonColor
                                  .withOpacity(0.5),
                              width: 1.0),
                        ),
                        hintStyle: TextStyle(
                          fontSize: 13.0,
                          color: CustomTheme.of(context).splashColor,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ),

                const  SizedBox(
                    height: 60.0,
                  ),
                  Text(
                    "You have to transfer your asset to the relevant account before trading. No handing fee for transfer between accounts.",
                    style: CustomWidget(context: context)
                        .CustomSizedTextStyle(
                        13.0,
                        Theme.of(context).hintColor.withOpacity(0.5),
                        FontWeight.w400,
                        'FontRegular'),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  ButtonCustom(
                      text: AppLocalizations.instance.text("loc_transfer_head"),
                      iconEnable: false,
                      radius: 5.0,
                      icon: "",
                      textStyle: CustomWidget(context: context)
                          .CustomSizedTextStyle(
                          13.0,
                          Theme.of(context).splashColor,
                          FontWeight.w500,
                          'FontRegular'),
                      iconColor: CustomTheme.of(context).buttonColor,
                      buttonColor: CustomTheme.of(context).buttonColor,
                      splashColor: CustomTheme.of(context).buttonColor,
                      onPressed: () {
                        // Navigator.push(
                        //     context,
                        //     MaterialPageRoute(
                        //       builder: (context) => const SetNameScreen3(),
                        //     ));
                      },
                      paddng: 0.0),
                  SizedBox(
                    height: 10.0,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
