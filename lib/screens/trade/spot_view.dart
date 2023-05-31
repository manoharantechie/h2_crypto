import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';


import '../../../common/custom_widget.dart';
import '../../../common/theme/custom_theme.dart';

class SpotView extends StatefulWidget {
  const SpotView({Key? key}) : super(key: key);

  @override
  State<SpotView> createState() => _SpotViewState();
}

class _SpotViewState extends State<SpotView> {

  bool selectedBtn = true;

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
        title: Text(
          "MX",
          style: CustomWidget(context: context)
              .CustomSizedTextStyle(
              16.0,
              Theme.of(context).splashColor,
              FontWeight.w400,
              'FontRegular'),
        ),
        actions: <Widget>[

          Container(
               padding: const EdgeInsets.fromLTRB(15.0,0.0,15.0,0.0),
              child: Center(
                child: Text(
                  "D/W History",
                  style: CustomWidget(context: context)
                      .CustomSizedTextStyle(
                      13.0,
                      Theme.of(context).splashColor,
                      FontWeight.w400,
                      'FontRegular'),
                ),
              )
          ),
        ],
      ),
      body: Container(
        margin: EdgeInsets.only(left: 0, right: 0, bottom: 0.0),
        padding: EdgeInsets.fromLTRB(15.0, 0.0, 15.0, 0.0),
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
                  CustomTheme.of(context).dialogBackgroundColor,
                ])),
        child: SingleChildScrollView (
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.only(top: 15.0,bottom: 10.0),
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.28,
                  decoration: BoxDecoration(
                    color:
                    CustomTheme.of(context).shadowColor.withOpacity(0.2),
                    borderRadius: BorderRadius.all(
                      Radius.circular(5.0),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        child:   Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              'assets/images/spot_logo.svg',
                              height: 40.0,
                              width: 40.0,
                            ),
                            SizedBox(
                              width: 10.0,
                            ),
                            Text(
                              "MX",
                              style: CustomWidget(context: context)
                                  .CustomSizedTextStyle(
                                  14.0,
                                  Theme.of(context).splashColor,
                                  FontWeight.w400,
                                  'FontRegular'),
                            ),
                            Text(
                              "-MX Token",
                              style: CustomWidget(context: context)
                                  .CustomSizedTextStyle(
                                  12.0,
                                  Theme.of(context).splashColor.withOpacity(0.5),
                                  FontWeight.w400,
                                  'FontRegular'),
                            ),
                          ],
                        ),
                        width: MediaQuery.of(context).size.width,
                      ),
                      SizedBox(
                        height: 5.0,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          const SizedBox(width: 15.0,),
                          Column(
                            children: [
                              Text(
                                "Available",
                                style: CustomWidget(context: context)
                                    .CustomSizedTextStyle(
                                    12.0,
                                    Theme.of(context).splashColor.withOpacity(0.5),
                                    FontWeight.w400,
                                    'FontRegular'),
                              ),
                              Text(
                                "0",
                                style: CustomWidget(context: context)
                                    .CustomSizedTextStyle(
                                    14.0,
                                    Theme.of(context).splashColor,
                                    FontWeight.w400,
                                    'FontRegular'),
                              ),
                            ],
                          ),

                          Container(
                            width: 1.0,
                            height: 40.0,
                            decoration: BoxDecoration(
                                color: CustomTheme.of(context)
                                    .splashColor
                                    .withOpacity(0.5),
                                borderRadius: BorderRadius.circular(5.0)),
                          ),

                          Column(
                            children: [
                              Text(
                                "Frozen",
                                style: CustomWidget(context: context)
                                    .CustomSizedTextStyle(
                                    12.0,
                                    Theme.of(context).splashColor.withOpacity(0.5),
                                    FontWeight.w400,
                                    'FontRegular'),
                              ),
                              Text(
                                "0",
                                style: CustomWidget(context: context)
                                    .CustomSizedTextStyle(
                                    14.0,
                                    Theme.of(context).splashColor,
                                    FontWeight.w400,
                                    'FontRegular'),
                              ),
                            ],
                          ),
                          SizedBox(height: 5.0,),
                        ],
                      ),
                      SizedBox(
                        height: 5.0,
                      ),

                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Valuation : ",
                            style: CustomWidget(context: context)
                                .CustomSizedTextStyle(
                                10.0,
                                Theme.of(context).splashColor.withOpacity(0.5),
                                FontWeight.w400,
                                'FontRegular'),
                          ),

                          Text(
                            "0.00000000 BTC ~0.00 USD",
                            style: CustomWidget(context: context)
                                .CustomSizedTextStyle(
                                10.0,
                                Theme.of(context).splashColor.withOpacity(0.5),
                                FontWeight.w400,
                                'FontRegular'
                            ),
                          ),
                        ],
                      ),

                    ],
                  ),
                ),
                SizedBox(height: 20.0,),

                Container(
                  child: Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            "Trade",
                            style: CustomWidget(context: context)
                                .CustomSizedTextStyle(
                                14.0,
                                Theme.of(context).hintColor,
                                FontWeight.w400,
                                'FontRegular'
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 15.0,),

                      Container(
                        padding: EdgeInsets.fromLTRB(15.0,5.0,15.0,5.0),
                        decoration: BoxDecoration(
                          border: Border.all(width: 1.0, color: CustomTheme.of(context).shadowColor.withOpacity(0.5),),
                            borderRadius: BorderRadius.all(Radius.circular(25.0), ),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Text(
                                  "MX",
                                  style: CustomWidget(context: context)
                                      .CustomSizedTextStyle(
                                      14.0,
                                      Theme.of(context).hintColor,
                                      FontWeight.w400,
                                      'FontRegular'
                                  ),
                                ),
                                Text(
                                  "/ETH",
                                  style: CustomWidget(context: context)
                                      .CustomSizedTextStyle(
                                      14.0,
                                      Theme.of(context).hintColor.withOpacity(0.5),
                                      FontWeight.w400,
                                      'FontRegular'
                                  ),
                                ),
                              ],
                            ),


                            Text(
                              "+0.53%",
                              style: CustomWidget(context: context)
                                  .CustomSizedTextStyle(
                                  14.0,
                                  Theme.of(context).indicatorColor,
                                  FontWeight.w400,
                                  'FontRegular'
                              ),
                            ),

                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  "1.9420",
                                  style: CustomWidget(context: context)
                                      .CustomSizedTextStyle(
                                      12.0,
                                      Theme.of(context).hintColor,
                                      FontWeight.w400,
                                      'FontRegular'
                                  ),
                                ),

                                Text(
                                  "~1.94 USD",
                                  style: CustomWidget(context: context)
                                      .CustomSizedTextStyle(
                                      12.0,
                                      Theme.of(context).hintColor.withOpacity(0.5),
                                      FontWeight.w400,
                                      'FontRegular'
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                      SizedBox(height: 10.0,),

                      Container(
                        padding: EdgeInsets.fromLTRB(15.0,5.0,15.0,5.0),
                        decoration: BoxDecoration(
                          border: Border.all(width: 1.0, color: CustomTheme.of(context).shadowColor.withOpacity(0.5),),
                          borderRadius: BorderRadius.all(Radius.circular(25.0), ),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Text(
                                  "MX",
                                  style: CustomWidget(context: context)
                                      .CustomSizedTextStyle(
                                      14.0,
                                      Theme.of(context).hintColor,
                                      FontWeight.w400,
                                      'FontRegular'
                                  ),
                                ),
                                Text(
                                  "/USDT",
                                  style: CustomWidget(context: context)
                                      .CustomSizedTextStyle(
                                      14.0,
                                      Theme.of(context).hintColor.withOpacity(0.5),
                                      FontWeight.w400,
                                      'FontRegular'
                                  ),
                                ),
                              ],
                            ),


                            Text(
                              "+0.53%",
                              style: CustomWidget(context: context)
                                  .CustomSizedTextStyle(
                                  14.0,
                                  Theme.of(context).indicatorColor,
                                  FontWeight.w400,
                                  'FontRegular'
                              ),
                            ),

                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  "1.9420",
                                  style: CustomWidget(context: context)
                                      .CustomSizedTextStyle(
                                      12.0,
                                      Theme.of(context).hintColor,
                                      FontWeight.w400,
                                      'FontRegular'
                                  ),
                                ),

                                Text(
                                  "~1.94 USD",
                                  style: CustomWidget(context: context)
                                      .CustomSizedTextStyle(
                                      12.0,
                                      Theme.of(context).hintColor.withOpacity(0.5),
                                      FontWeight.w400,
                                      'FontRegular'
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                      SizedBox(height: 15.0,),

                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Join PoS",
                            style: CustomWidget(context: context)
                                .CustomSizedTextStyle(
                                14.0,
                                Theme.of(context).hintColor,
                                FontWeight.w400,
                                'FontRegular'
                            ),
                          ),

                          Text(
                            "Yield rate",
                            style: CustomWidget(context: context)
                                .CustomSizedTextStyle(
                                14.0,
                                Theme.of(context).hintColor,
                                FontWeight.w400,
                                'FontRegular'
                            ),
                          ),

                          Text(
                            "Operating",
                            style: CustomWidget(context: context)
                                .CustomSizedTextStyle(
                                14.0,
                                Theme.of(context).hintColor,
                                FontWeight.w400,
                                'FontRegular'
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 200.0,),

                      Container(
                        child:  Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  decoration: BoxDecoration(
                                    color: selectedBtn
                                        ? CustomTheme.of(context).shadowColor
                                        : CustomTheme.of(context).hintColor.withOpacity(0.5),
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(2.0),
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
                                      "Deposit",
                                      textAlign: TextAlign.center,
                                      style: CustomWidget(context: context)
                                          .CustomSizedTextStyle(
                                          13.0,
                                          Theme.of(context).hintColor,
                                          FontWeight.w400,
                                          'FontRegular'
                                      ),
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
                                    color: !selectedBtn
                                        ? CustomTheme.of(context).shadowColor: CustomTheme.of(context).hintColor.withOpacity(0.5),
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(2.0),
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
                                      "Withdrawal",
                                      textAlign: TextAlign.center,
                                      style: CustomWidget(context: context)
                                          .CustomSizedTextStyle(
                                          13.0,
                                          Theme.of(context).hintColor,
                                          FontWeight.w400,
                                          'FontRegular'
                                      ),
                                    ),
                                  )),
                              flex: 1,
                            )
                          ],
                        ),

                      ),
                      SizedBox(height: 15.0,),

                    ],
                  ),
                ),
              ],
            )
        ),
      ),
    );
  }
}
