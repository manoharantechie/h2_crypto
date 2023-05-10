import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../common/custom_widget.dart';
import '../../common/localization/localizations.dart';
import '../../common/textformfield_custom.dart';
import '../../common/theme/custom_theme.dart';

class QuickBuySellScreen extends StatefulWidget {
  const QuickBuySellScreen({Key? key}) : super(key: key);

  @override
  State<QuickBuySellScreen> createState() => _QuickBuySellScreenState();
}

class _QuickBuySellScreenState extends State<QuickBuySellScreen> {

  bool buy = true;
  bool sell = false;
  TextEditingController quantity = TextEditingController();
  FocusNode quantityFocus = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: CustomTheme.of(context).primaryColor,
        elevation: 0.0,
        leading: Container(
          padding: const EdgeInsets.all(18.0),
          // child: InkWell(
          //   onTap: () {
          //     Navigator.pop(context);
          //   },
          //   child: SvgPicture.asset(
          //     'assets/others/arrow_left.svg',
          //     height: 8.0,
          //     width: 8.0,
          //     color: CustomTheme.of(context).splashColor,
          //     allowDrawingOutsideViewBox: true,
          //   ),
          // )
        ),
        centerTitle: true,
        title: Text(
          AppLocalizations.instance.text("loc_quick_buy_sell"),
          style: CustomWidget(context: context).CustomSizedTextStyle(16.0,
              Theme.of(context).splashColor, FontWeight.w500, 'FontRegular'),
        ),
      ),
      body: Container(
        color: CustomTheme.of(context).hoverColor,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.only(top: 5.0),
              padding: EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 20.0),
              color: CustomTheme.of(context).primaryColor,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              AppLocalizations.instance.text("loc_max_buy"),
                              style: CustomWidget(context: context)
                                  .CustomTextStyle(
                                  CustomTheme.of(context).indicatorColor,
                                  FontWeight.w500,
                                  'FontRegular'),
                            ),
                            const SizedBox(width: 8.0,),
                            Text(
                              "BTC",
                              style: CustomWidget(context: context)
                                  .CustomTextStyle(
                                  CustomTheme.of(context).indicatorColor,
                                  FontWeight.w500,
                                  'FontRegular'),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10.0,),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              AppLocalizations.instance.text("loc_max_sell"),
                              style: CustomWidget(context: context)
                                  .CustomTextStyle(
                                  CustomTheme.of(context).scaffoldBackgroundColor,
                                  FontWeight.w500,
                                  'FontRegular'),
                            ),
                            const SizedBox(width: 8.0,),
                            Text(
                              "BTC",
                              style: CustomWidget(context: context)
                                  .CustomTextStyle(
                                  CustomTheme.of(context).scaffoldBackgroundColor,
                                  FontWeight.w500,
                                  'FontRegular'),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.currency_bitcoin,
                              color: CustomTheme.of(context).splashColor,
                              size: 20.0,
                            ),
                            const SizedBox(width: 8.0,),
                            Text(
                              "0.00002585",
                              style: CustomWidget(context: context)
                                  .CustomTextStyle(
                                  CustomTheme.of(context).indicatorColor,
                                  FontWeight.w500,
                                  'FontRegular'),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10.0,),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.currency_bitcoin,
                              color: CustomTheme.of(context).splashColor,
                              size: 20.0,
                            ),
                            const SizedBox(width: 8.0,),
                            Text(
                              "0.00002585",
                              style: CustomWidget(context: context)
                                  .CustomTextStyle(
                                  CustomTheme.of(context).scaffoldBackgroundColor,
                                  FontWeight.w500,
                                  'FontRegular'),
                            ),
                          ],
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(height: 5.0,),
            Container(
              padding: EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 20.0),
              color: CustomTheme.of(context).primaryColor,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              buy = true;
                              sell = false;
                            });
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            padding: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 10.0),
                            decoration: buy
                                ? BoxDecoration(
                              borderRadius: BorderRadius.circular(6.0),
                              color: Theme.of(context).indicatorColor,
                            )
                                : BoxDecoration(
                              borderRadius: BorderRadius.circular(6.0),
                              color: Theme.of(context)
                                  .bottomAppBarColor
                                  .withOpacity(0.5),
                            ),
                            child: Center(
                              child: Text(
                                AppLocalizations.instance.text("loc_buy") + " BTC",
                                style: CustomWidget(context: context)
                                    .CustomSizedTextStyle(
                                    16.0,
                                    buy
                                        ? Theme.of(context).primaryColor
                                        : Theme.of(context).splashColor,
                                    FontWeight.w600,
                                    'FontRegular'),
                              ),
                            ),
                          ),
                        ),
                        flex: 1,
                      ),
                      const SizedBox(
                        width: 10.0,
                      ),
                      Flexible(
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              buy = false;
                              sell = true;
                            });
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            padding: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 10.0),
                            decoration: sell
                                ? BoxDecoration(
                              borderRadius: BorderRadius.circular(6.0),
                              color:
                              Theme.of(context).scaffoldBackgroundColor,
                            )
                                : BoxDecoration(
                              borderRadius: BorderRadius.circular(6.0),
                              color: Theme.of(context)
                                  .bottomAppBarColor
                                  .withOpacity(0.5),
                            ),
                            child: Center(
                              child: Text(
                                AppLocalizations.instance.text("loc_sell") + " BTC",
                                style: CustomWidget(context: context)
                                    .CustomSizedTextStyle(
                                    16.0,
                                    sell
                                        ? Theme.of(context).primaryColor
                                        : Theme.of(context).splashColor,
                                    FontWeight.w600,
                                    'FontRegular'),
                              ),
                            ),
                          ),
                        ),
                        flex: 1,
                      )
                    ],
                  ),
                  const SizedBox(height: 20.0,),
                  Container(
                    padding: EdgeInsets.fromLTRB(5.0, 5.0, 10.0, 5.0),
                    decoration: BoxDecoration(
                      color: Theme.of(context).bottomAppBarColor.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(6.0)
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(child: TextFormFieldCustom(
                          onEditComplete: () {
                            quantityFocus.unfocus();
                            // FocusScope.of(context).requestFocus(emailPassFocus);
                          },
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          radius: 5.0,
                          error: "Enter Quantity",
                          textColor: CustomTheme.of(context).splashColor,
                          borderColor: Colors.transparent,
                          fillColor: Colors.transparent,
                          textInputAction: TextInputAction.next,
                          focusNode: quantityFocus,
                          maxlines: 1,
                          text: '',
                          hintText: "Quantity",
                          // inputFormatters: [
                          //   FilteringTextInputFormatter.allow(RegExp(r'[A-Za-z@0-9.]')),
                          // ],
                          obscureText: false,
                          suffix: Container(
                            width: 0.0,
                          ),
                          textChanged: (value) {},
                          onChanged: () {},
                          validator: (value) {

                          },
                          enabled: true,
                          textInputType: TextInputType.number,
                          controller: quantity,
                          hintStyle: CustomWidget(context: context).CustomTextStyle(
                              Theme.of(context).splashColor.withOpacity(0.5),
                              FontWeight.w300,
                              'FontRegular'),
                          textStyle: CustomWidget(context: context).CustomTextStyle(
                              Theme.of(context).splashColor, FontWeight.w400, 'FontRegular'),
                        ), flex: 1,),
                        Flexible(child: Container(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                "0.001",
                                style: CustomWidget(context: context)
                                    .CustomSizedTextStyle(
                                    16.0,
                                    Theme.of(context).splashColor,
                                    FontWeight.w600,
                                    'FontRegular'),
                              ),
                              const SizedBox(width: 5.0,),
                              Container(
                                padding: EdgeInsets.all(3.0),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Theme.of(context).selectedRowColor,
                                ),
                                child: Icon(
                                  Icons.currency_bitcoin,
                                  color: Theme.of(context).primaryColor,
                                  size: 20.0,
                                ),
                              ),
                              const SizedBox(width: 5.0,),
                              Text(
                                "BTC",
                                style: CustomWidget(context: context)
                                    .CustomSizedTextStyle(
                                    16.0,
                                    Theme.of(context).splashColor,
                                    FontWeight.w600,
                                    'FontRegular'),
                              )
                            ],
                          ),
                        ), flex: 1,)
                      ],
                    ),
                  ),
                  const SizedBox(height: 10.0,),
                  Container(
                    child: Row(
                      children: [
                        Flexible(child: InkWell(
                          onTap: () {
                            setState(() {

                            });
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            padding: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 10.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6.0),
                              color: Theme.of(context)
                                  .bottomAppBarColor
                                  .withOpacity(0.5),
                            ),
                            child: Center(
                              child: Text(
                                "10%",
                                style: CustomWidget(context: context)
                                    .CustomSizedTextStyle(
                                    16.0,
                                    Theme.of(context).splashColor,
                                    FontWeight.w600,
                                    'FontRegular'),
                              ),
                            ),
                          ),
                        ),flex: 1,),
                        const SizedBox(width: 5.0,),
                        Flexible(child: InkWell(
                          onTap: () {
                            setState(() {

                            });
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            padding: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 10.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6.0),
                              color: Theme.of(context)
                                  .bottomAppBarColor
                                  .withOpacity(0.5),
                            ),
                            child: Center(
                              child: Text(
                                "25%",
                                style: CustomWidget(context: context)
                                    .CustomSizedTextStyle(
                                    16.0,
                                    Theme.of(context).splashColor,
                                    FontWeight.w600,
                                    'FontRegular'),
                              ),
                            ),
                          ),
                        ),flex: 1,),
                        const SizedBox(width: 5.0,),
                        Flexible(child: InkWell(
                          onTap: () {
                            setState(() {

                            });
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            padding: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 10.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6.0),
                              color: Theme.of(context)
                                  .bottomAppBarColor
                                  .withOpacity(0.5),
                            ),
                            child: Center(
                              child: Text(
                                "50%",
                                style: CustomWidget(context: context)
                                    .CustomSizedTextStyle(
                                    16.0,
                                    Theme.of(context).splashColor,
                                    FontWeight.w600,
                                    'FontRegular'),
                              ),
                            ),
                          ),
                        ),flex: 1,),
                        const SizedBox(width: 5.0,),
                        Flexible(child: InkWell(
                          onTap: () {
                            setState(() {
                              buy = false;
                              sell = true;
                            });
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            padding: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 10.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6.0),
                              color: Theme.of(context)
                                  .bottomAppBarColor
                                  .withOpacity(0.5),
                            ),
                            child: Center(
                              child: Text(
                                "75%",
                                style: CustomWidget(context: context)
                                    .CustomSizedTextStyle(
                                    16.0,
                                    Theme.of(context).splashColor,
                                    FontWeight.w600,
                                    'FontRegular'),
                              ),
                            ),
                          ),
                        ),flex: 1,),
                        const SizedBox(width: 5.0,),
                        Flexible(child: InkWell(
                          onTap: () {
                            setState(() {

                            });
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            padding: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 10.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6.0),
                              color: Theme.of(context)
                                  .bottomAppBarColor
                                  .withOpacity(0.5),
                            ),
                            child: Center(
                              child: Text(
                                "100%",
                                style: CustomWidget(context: context)
                                    .CustomSizedTextStyle(
                                    16.0,
                                    Theme.of(context).splashColor,
                                    FontWeight.w600,
                                    'FontRegular'),
                              ),
                            ),
                          ),
                        ),flex: 1,)
                      ],
                    ),
                  ),
                  const SizedBox(height: 30.0,),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () {
                          setState(() {

                          });
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.fromLTRB(0.0, 14.0, 0.0, 14.0),
                          decoration:  BoxDecoration(
                            borderRadius: BorderRadius.circular(6.0),
                            color:
                            Theme.of(context).indicatorColor,
                          ),
                          child: Center(
                            child: Text(
                              AppLocalizations.instance.text("loc_buy") +" Now"+" 0.001"+" BTC",
                              style: CustomWidget(context: context)
                                  .CustomSizedTextStyle(
                                  16.0,
                                  Theme.of(context).primaryColor,
                                  FontWeight.w600,
                                  'FontRegular'),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10.0,),
                      Center(
                        child: Text(
                          AppLocalizations.instance.text("loc_buy") +" Quote Expire In"+" 8"+" Seconds",
                          style: CustomWidget(context: context)
                              .CustomSizedTextStyle(
                              14.0,
                              Theme.of(context).splashColor,
                              FontWeight.w500,
                              'FontRegular'),
                        ),
                      ),
                      const SizedBox(height: 20.0,),
                      Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Flexible(child:  Text(
                                  AppLocalizations.instance.text("loc_tot")+" BTC",
                                  style: CustomWidget(context: context)
                                      .CustomSizedTextStyle(
                                      16,
                                      CustomTheme.of(context).splashColor,
                                      FontWeight.w600,
                                      'FontRegular'),
                                ),flex: 1,),
                                Flexible(child: Text(
                                  "0.00100000"+" BTC",
                                  style: CustomWidget(context: context)
                                      .CustomSizedTextStyle(
                                      16,
                                      CustomTheme.of(context).splashColor,
                                      FontWeight.w600,
                                      'FontRegular'),
                                ),flex: 1,)
                              ],
                            ),
                            const SizedBox(height: 10.0,),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Flexible(child:  Text(
                                  AppLocalizations.instance.text("loc_sell_trade_price"),
                                  style: CustomWidget(context: context)
                                      .CustomSizedTextStyle(
                                      16,
                                      CustomTheme.of(context).splashColor,
                                      FontWeight.w500,
                                      'FontRegular'),
                                ),flex: 1,),
                                Flexible(child: Text(
                                  "25,375.73"+" /"+" BTC",
                                  style: CustomWidget(context: context)
                                      .CustomSizedTextStyle(
                                      16,
                                      CustomTheme.of(context).splashColor,
                                      FontWeight.w500,
                                      'FontRegular'),
                                ),flex: 1,)
                              ],
                            ),
                            const SizedBox(height: 10.0,),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Flexible(child:  Text(
                                  AppLocalizations.instance.text("loc_fee"),
                                  style: CustomWidget(context: context)
                                      .CustomSizedTextStyle(
                                      16,
                                      CustomTheme.of(context).splashColor,
                                      FontWeight.w500,
                                      'FontRegular'),
                                ),flex: 1,),
                                Flexible(child: Text(
                                  "\$ "+"0.00",
                                  style: CustomWidget(context: context)
                                      .CustomSizedTextStyle(
                                      16,
                                      CustomTheme.of(context).splashColor,
                                      FontWeight.w500,
                                      'FontRegular'),
                                ),flex: 1,)
                              ],
                            ),
                            const SizedBox(height: 10.0,),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Flexible(child:  Text(
                                  AppLocalizations.instance.text("loc_tot")+" USD",
                                  style: CustomWidget(context: context)
                                      .CustomSizedTextStyle(
                                      16,
                                      CustomTheme.of(context).splashColor,
                                      FontWeight.w500,
                                      'FontRegular'),
                                ),flex: 1,),
                                Flexible(child: Text(
                                  "\$ "+"28.45235",
                                  style: CustomWidget(context: context)
                                      .CustomSizedTextStyle(
                                      16,
                                      CustomTheme.of(context).splashColor,
                                      FontWeight.w500,
                                      'FontRegular'),
                                ),flex: 1,)
                              ],
                            ),
                          ],
                        ),
                      )
                    ],
                  )

                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
