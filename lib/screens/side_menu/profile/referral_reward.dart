import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';


import '../../../common/custom_widget.dart';
import '../../../common/localization/localizations.dart';
import '../../../common/theme/custom_theme.dart';


class RefferralReward extends StatefulWidget {
  const RefferralReward({Key? key}) : super(key: key);

  @override
  State<RefferralReward> createState() => _RefferralRewardState();
}

class _RefferralRewardState extends State<RefferralReward> {
  bool _btns1 = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: CustomTheme.of(context).primaryColor,
        elevation: 0.0,
        leading: Container(
            padding: const EdgeInsets.all(16.0),
            child: InkWell(
              onTap: (){
                Navigator.pop(context);
              },
              child: SvgPicture.asset(
                'assets/others/arrow_left.svg',
                height: 22.0,
                width: 22.0,
                allowDrawingOutsideViewBox: true,
                color: CustomTheme.of(context).splashColor,
              ),
            )
        ),
        centerTitle: true,
        title: Text(
          AppLocalizations.instance
              .text("loc_ref_rew-head"),
          style: CustomWidget(context: context)
              .CustomSizedTextStyle(
              16.0,
              Theme.of(context).splashColor,
              FontWeight.w500,
              'FontRegular'),
        ),
        actions: <Widget>[
          Container(

              padding: const EdgeInsets.all(15.0),
              child: InkWell(
                onTap: (){
                },
                child: SvgPicture.asset(
                  'assets/images/transfer.svg',
                  height: 24.0,
                  width: 24.0,
                  allowDrawingOutsideViewBox: true,
                  color: CustomTheme.of(context).splashColor,
                ),
              )
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
                stops: [0.1, 0.5, 0.9,],
                colors: [CustomTheme.of(context).primaryColor,CustomTheme.of(context).backgroundColor, CustomTheme.of(context).accentColor,])),
        child: SingleChildScrollView(
          child: SafeArea(
            child: Container(
              // padding: EdgeInsets.only(top: 5.0,bottom: 10.0,right: 10.0, left: 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.only(top: 5.0,bottom: 5.0,right: 10.0, left: 10.0),
                    decoration: BoxDecoration(
                      color: CustomTheme.of(context).buttonColor.withOpacity(0.2),
                    ),
                    child: Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "My referral",
                                  style: CustomWidget(context: context)
                                      .CustomSizedTextStyle(
                                      12.0,
                                      Theme.of(context).splashColor.withOpacity(0.5),
                                      FontWeight.w400,
                                      'FontRegular'),
                                ),

                                SizedBox(height: 10.0,),

                                Text(
                                  "0",
                                  style: CustomWidget(context: context)
                                      .CustomSizedTextStyle(
                                      10.0,
                                      Theme.of(context).splashColor,
                                      FontWeight.w400,
                                      'FontRegular'),
                                ),
                              ],
                            ), flex: 1,),

                            Flexible(child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Cumulative Rewards",
                                  style: CustomWidget(context: context)
                                      .CustomSizedTextStyle(
                                      12.0,
                                      Theme.of(context).splashColor.withOpacity(0.5),
                                      FontWeight.w400,
                                      'FontRegular'),
                                ),
                                SizedBox(height: 10.0,),
                                Text(
                                  "0",
                                  style: CustomWidget(context: context)
                                      .CustomSizedTextStyle(
                                      10.0,
                                      Theme.of(context).splashColor,
                                      FontWeight.w400,
                                      'FontRegular'),
                                ),
                              ],
                            ), flex: 1,),

                            Flexible(child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Spot rewards",
                                  style: CustomWidget(context: context)
                                      .CustomSizedTextStyle(
                                      12.0,
                                      Theme.of(context).splashColor.withOpacity(0.5),
                                      FontWeight.w400,
                                      'FontRegular'),
                                ),
                                SizedBox(height: 10.0,),
                                Text(
                                  "0",
                                  style: CustomWidget(context: context)
                                      .CustomSizedTextStyle(
                                      10.0,
                                      Theme.of(context).splashColor,
                                      FontWeight.w400,
                                      'FontRegular'),
                                ),
                              ],
                            ), flex: 1,),

                          ],
                        ),
                        SizedBox(height: 15.0,),

                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(child:  Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Margin rewards",
                                  style: CustomWidget(context: context)
                                      .CustomSizedTextStyle(
                                      12.0,
                                      Theme.of(context).splashColor.withOpacity(0.5),
                                      FontWeight.w400,
                                      'FontRegular'),
                                ),
                                SizedBox(height: 10.0,),
                                Text(
                                  "0",
                                  style: CustomWidget(context: context)
                                      .CustomSizedTextStyle(
                                      10.0,
                                      Theme.of(context).splashColor,
                                      FontWeight.w400,
                                      'FontRegular'),
                                ),
                              ],
                            ),flex: 1,),

                            Flexible(child:  Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Margin rewards",
                                  style: CustomWidget(context: context)
                                      .CustomSizedTextStyle(
                                      12.0,
                                      Theme.of(context).splashColor.withOpacity(0.5),
                                      FontWeight.w400,
                                      'FontRegular'),
                                ),
                                SizedBox(height: 10.0,),

                                Text(
                                  "0",
                                  style: CustomWidget(context: context)
                                      .CustomSizedTextStyle(
                                      10.0,
                                      Theme.of(context).splashColor,
                                      FontWeight.w400,
                                      'FontRegular'),
                                ),
                              ],
                            ),flex: 1,),

                            Flexible(child:  Container(),flex: 1,)

                          ],
                        ),
                        SizedBox(height: 15.0,),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10.0,),

                  Container(
                    padding: EdgeInsets.only(top: 5.0,bottom: 10.0,right: 15.0, left: 15.0),
                    child: Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "*All amount are settled in USDT.",
                              style: CustomWidget(context: context)
                                  .CustomSizedTextStyle(
                                  12.0,
                                  Theme.of(context).splashColor.withOpacity(0.5),
                                  FontWeight.w400,
                                  'FontRegular'),
                            ),

                            Row(
                              children: [
                                SvgPicture.asset(
                                  'assets/images/form.svg',
                                  height: 20.0,
                                  width: 20.0,
                                  allowDrawingOutsideViewBox: true,
                                ),
                                SizedBox(width: 5.0,),

                                Text(
                                  "Recording",
                                  style: CustomWidget(context: context)
                                      .CustomSizedTextStyle(
                                      12.0,
                                      Theme.of(context).buttonColor,
                                      FontWeight.w400,
                                      'FontRegular'),
                                ),

                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 10.0,),

                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [

                            ElevatedButton(onPressed: () {
                              setState((){

                                _btns1=true;
                              });
                            },
                              style: TextButton.styleFrom(
                                backgroundColor: !_btns1? CustomTheme.of(context).buttonColor:CustomTheme.of(context).hintColor, // Background Color
                              ),
                              child: Text(
                                "Share poster",
                                style: CustomWidget(context: context)
                                    .CustomSizedTextStyle(
                                    9.0,
                                    !_btns1 ?CustomTheme.of(context).hintColor: CustomTheme.of(context).buttonColor,
                                    FontWeight.w500,
                                    'FontRegular'),
                              ),
                            ),

                            ElevatedButton(onPressed: () {
                              setState((){

                                _btns1=false;
                              });
                            },
                              style: TextButton.styleFrom(
                                backgroundColor: _btns1 ? CustomTheme.of(context).buttonColor:CustomTheme.of(context).hintColor, // Background Color
                              ),
                              child: Text(
                                "Share Link",
                                style: CustomWidget(context: context)
                                    .CustomSizedTextStyle(
                                    9.0,
                                    _btns1 ?CustomTheme.of(context).hintColor: CustomTheme.of(context).buttonColor,
                                    FontWeight.w500,
                                    'FontRegular'),
                              ),
                            ),

                            ElevatedButton(onPressed: () {
                              setState((){

                                _btns1=false;
                              });
                            },
                              style: TextButton.styleFrom(
                                backgroundColor: _btns1 ? CustomTheme.of(context).buttonColor:CustomTheme.of(context).hintColor, // Background Color
                              ),
                              child: Text(
                                "Face-to-face invitation",
                                style: CustomWidget(context: context)
                                    .CustomSizedTextStyle(
                                    9.0,
                                    _btns1 ?CustomTheme.of(context).hintColor: CustomTheme.of(context).buttonColor,
                                    FontWeight.w500,
                                    'FontRegular'),
                              ),
                            ),

                          ],
                        ),
                        const SizedBox(height: 15.0,),

                        Row(
                          children: [
                            Text(
                              "Referral Event Reward Rules",
                              style: CustomWidget(context: context)
                                  .CustomSizedTextStyle(
                                  13.0,
                                  Theme.of(context).splashColor,
                                  FontWeight.w400,
                                  'FontRegular'),
                            ),
                          ],
                        ),
                        const SizedBox(height: 15.0,),

                        Column(
                          children: [
                            Text(
                              "1. Users can complete registration by sharing promotion codes or promotion links. For each spot trade, ETF transaction and futures trade generated by their friends, the sharer can receive a corresponding proportion of service fee reward. For friends who are invited to open an account by the sharer after December 18, 2020, the friends can also get a 10% commission reward separately. ",
                              style: CustomWidget(context: context)
                                  .CustomSizedTextStyle(
                                  10.0,
                                  Theme.of(context).splashColor,
                                  FontWeight.w400,
                                  'FontRegular'),
                            ),
                            SizedBox(height: 10.0,),

                            Text(
                              "2. Commission Structure for Spot & ETF trades: The commission received by the referrer is dependent on their daily/average MX Token holdings. The formula is as follows: ",
                              style: CustomWidget(context: context)
                                  .CustomSizedTextStyle(
                                  10.0,
                                  Theme.of(context).splashColor,
                                  FontWeight.w400,
                                  'FontRegular'),
                            ),
                            SizedBox(height: 10.0,),

                            Text(
                              "(1) Users with less than 10,000 MX Tokens will receive 30% of the trading fees generated by their referees as commission. ",
                              style: CustomWidget(context: context)
                                  .CustomSizedTextStyle(
                                  10.0,
                                  Theme.of(context).splashColor,
                                  FontWeight.w400,
                                  'FontRegular'),
                            ),


                            Text(
                              "(2) Users with between 10,000 to 100,000 MX Tokens will receive 40% of the trading fees generated by their referees as commission. ",
                              style: CustomWidget(context: context)
                                  .CustomSizedTextStyle(
                                  10.0,
                                  Theme.of(context).splashColor,
                                  FontWeight.w400,
                                  'FontRegular'),
                            ),

                            Text(
                              "(3) Users with more than 100,000 MX Tokens will receive 50% of the trading fees generated by their referees as commission. ",
                              style: CustomWidget(context: context)
                                  .CustomSizedTextStyle(
                                  10.0,
                                  Theme.of(context).splashColor,
                                  FontWeight.w400,
                                  'FontRegular'),
                            ),

                            Text(
                              "(4)H2Crypto Community Node Partners can contact official platform staff directly to learn more about the increased rewards they are entitled to. ",
                              style: CustomWidget(context: context)
                                  .CustomSizedTextStyle(
                                  10.0,
                                  Theme.of(context).splashColor,
                                  FontWeight.w400,
                                  'FontRegular'),
                            ),
                            SizedBox(height: 10.0,),

                            Text(
                              "Commission Structure for Futures Trades: The commission received by the referrer is dependent on their daily/average MX Token holdings.The formula is as follows: ",
                              style: CustomWidget(context: context)
                                  .CustomSizedTextStyle(
                                  10.0,
                                  Theme.of(context).splashColor,
                                  FontWeight.w400,
                                  'FontRegular'),
                            ),
                            SizedBox(height: 10.0,),

                            Text(
                              "(1) Users with less than 10,000 MX Tokens will receive 10% of the trading fees generated by their referees as commission. ",
                              style: CustomWidget(context: context)
                                  .CustomSizedTextStyle(
                                  10.0,
                                  Theme.of(context).splashColor,
                                  FontWeight.w400,
                                  'FontRegular'),
                            ),

                            Text(
                              "(2) Users with between 10,000 to 100,000 MX Tokens will receive 20% of the trading fees generated by their referees as commission. ",
                              style: CustomWidget(context: context)
                                  .CustomSizedTextStyle(
                                  10.0,
                                  Theme.of(context).splashColor,
                                  FontWeight.w400,
                                  'FontRegular'),
                            ),

                            Text(
                              "(3) Users with more than 100,000 MX Tokens will receive 30% of the trading fees generated by their referees as commission. ",
                              style: CustomWidget(context: context)
                                  .CustomSizedTextStyle(
                                  10.0,
                                  Theme.of(context).splashColor,
                                  FontWeight.w400,
                                  'FontRegular'),
                            ),

                            Text(
                              "(4)H2Crypto Community Node Partners can contact official platform staff directly to learn more about the increased rewards they are entitled to. ",
                              style: CustomWidget(context: context)
                                  .CustomSizedTextStyle(
                                  10.0,
                                  Theme.of(context).splashColor,
                                  FontWeight.w400,
                                  'FontRegular'),
                            ),
                            SizedBox(height: 10.0,),

                          ],
                        ),
                        const SizedBox(height: 15.0,),
                      ],
                    ),
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
