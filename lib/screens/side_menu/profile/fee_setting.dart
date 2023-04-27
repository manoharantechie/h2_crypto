import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';


import '../../../common/colors.dart';
import '../../../common/custom_button.dart';
import '../../../common/custom_widget.dart';
import '../../../common/localization/localizations.dart';
import '../../../common/theme/custom_theme.dart';


class FeesSetting extends StatefulWidget {
  const FeesSetting({Key? key}) : super(key: key);

  @override
  State<FeesSetting> createState() => _FeesSettingState();
}

class _FeesSettingState extends State<FeesSetting> {
  bool isSwitched = false;

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
                height: 10.0,
                width: 10.0,
                allowDrawingOutsideViewBox: true,
              ),
            )
        ),

        centerTitle: true,
        title: Text(
          AppLocalizations.instance
              .text("loc_fee_head"),
          style: CustomWidget(context: context)
              .CustomSizedTextStyle(
              16.0,
              Theme.of(context).splashColor,
              FontWeight.w500,
              'FontRegular'),
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
                stops: [0.1, 0.5, 0.9,],
                colors: [CustomTheme.of(context).primaryColor,CustomTheme.of(context).backgroundColor, CustomTheme.of(context).accentColor,])),
        child: SingleChildScrollView(
          child: SafeArea(
            child: Padding(
              padding: EdgeInsets.only(top: 5.0,bottom: 10.0,right: 15.0, left: 15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        AppLocalizations.instance
                            .text("loc_fee_content"),
                        style: CustomWidget(context: context)
                            .CustomSizedTextStyle(
                            10.0,
                            Theme.of(context).splashColor,
                            FontWeight.w400,
                            'FontRegular'),
                      ),

                      Switch(
                        value: isSwitched,
                        onChanged: (value) {
                          setState(() {
                            isSwitched = value;
                            print(isSwitched);
                          });
                        },
                        activeTrackColor: CustomTheme.of(context).buttonColor,
                        activeColor: CustomTheme.of(context).splashColor,
                      ),
                    ],
                  ),
                  const SizedBox(height: 10.0,),

                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SvgPicture.asset(
                        'assets/images/discount.svg',
                        height: 25.0,
                        width: 25.0,
                        allowDrawingOutsideViewBox: true,
                      ),
                      SizedBox(width: 5.0,),

                      Container(
                        width: MediaQuery.of(context).size.width*0.35,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              AppLocalizations.instance
                                  .text("loc_fee_content2"),
                              style: CustomWidget(context: context)
                                  .CustomSizedTextStyle(
                                  12.0,
                                  Theme.of(context).splashColor,
                                  FontWeight.w400,
                                  'FontRegular'),
                            ),

                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "0.2%",
                                      style: CustomWidget(context: context)
                                          .CustomSizedTextStyle(
                                          12.0,
                                          Theme.of(context).splashColor,
                                          FontWeight.w400,
                                          'FontRegular'),
                                    ),

                                    Text(
                                      "Maker",
                                      style: CustomWidget(context: context)
                                          .CustomSizedTextStyle(
                                          10.0,
                                          Theme.of(context).buttonColor,
                                          FontWeight.w400,
                                          'FontRegular'),
                                    ),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "0.2%",
                                      style: CustomWidget(context: context)
                                          .CustomSizedTextStyle(
                                          12.0,
                                          Theme.of(context).splashColor,
                                          FontWeight.w400,
                                          'FontRegular'),
                                    ),

                                    Text(
                                      "Taker",
                                      style: CustomWidget(context: context)
                                          .CustomSizedTextStyle(
                                          10.0,
                                          Theme.of(context).buttonColor,
                                          FontWeight.w400,
                                          'FontRegular'),
                                    ),
                                  ],
                                ),
                              ],
                            ),


                          ],
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 10.0,),

                  Row(
                    children: [
                      SvgPicture.asset(
                        'assets/images/steps.svg',
                        height: 25.0,
                        width: 25.0,
                        allowDrawingOutsideViewBox: true,
                      ),
                      SizedBox(width: 5.0,),

                      Text(
                        AppLocalizations.instance
                            .text("loc_fee_content3"),
                        style: CustomWidget(context: context)
                            .CustomSizedTextStyle(
                            12.0,
                            Theme.of(context).splashColor,
                            FontWeight.w400,
                            'FontRegular'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10.0,),

                  Row(
                    children: [
                      Text(
                        "Coming soon.......",
                        style: CustomWidget(context: context)
                            .CustomSizedTextStyle(
                            10.0,
                            Theme.of(context).splashColor,
                            FontWeight.w400,
                            'FontRegular'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15.0,),

                  Row(
                    children: [
                      SvgPicture.asset(
                        'assets/images/info.svg',
                        height: 22.0,
                        width: 22.0,
                        allowDrawingOutsideViewBox: true,
                      ),
                      SizedBox(width: 5.0,),

                      Text(
                        AppLocalizations.instance
                            .text("loc_fee_content4"),
                        style: CustomWidget(context: context)
                            .CustomSizedTextStyle(
                            12.0,
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
          ),
        ),
      ),
    );
  }
}
