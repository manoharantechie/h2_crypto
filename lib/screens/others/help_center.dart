import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:h2_crypto/common/custom_widget.dart';
import 'package:h2_crypto/common/localization/localizations.dart';
import 'package:h2_crypto/common/theme/custom_theme.dart';
import 'package:h2_crypto/screens/others/terms_Screen.dart';

class HelpCenter extends StatefulWidget {
  const HelpCenter({Key? key}) : super(key: key);

  @override
  State<HelpCenter> createState() => _HelpCenterState();
}

class _HelpCenterState extends State<HelpCenter> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: CustomTheme.of(context).primaryColor,
          elevation: 0.0,
          centerTitle: true,
          title: Text(
            AppLocalizations.instance.text("loc_help"),
            style: CustomWidget(context: context)
                .CustomSizedTextStyle(
                17.0,
                Theme.of(context).splashColor,
                FontWeight.w500,
                'FontRegular'),
          ),
          leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(
              padding: EdgeInsets.only(left: 16.0, right: 16.0),
              child: SvgPicture.asset(
                'assets/others/arrow_left.svg',
                color: CustomTheme.of(context).splashColor,

              ),
            ),
          )),
      body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          padding: const EdgeInsets.only(top: 20.0, left: 15.0, right: 15.0),
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
                    CustomTheme.of(context).dialogBackgroundColor,
                  ])),
          child:Stack(
            children: [
              Column(
                children: [

                  Container(
                    height: MediaQuery.of(context).size.height * 0.64,
                    margin: EdgeInsets.only(top: 0.0),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [


                          const SizedBox(
                            height: 20.0,
                          ),


                          InkWell(
                            onTap: (){
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const TermsCondition(title: "loc_terms", content: 'https://h2crypto.exchange/page/privacypolicy'),
                                  ));
                            },
                            child:  Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [


                                    Text(
                                      AppLocalizations.instance.text("loc_terms"),
                                      style: CustomWidget(context: context)
                                          .CustomSizedTextStyle(
                                          16.0,
                                          Theme.of(context).splashColor,
                                          FontWeight.normal,
                                          'FontRegular'),
                                    ),
                                  ],
                                ),
                                SvgPicture.asset(
                                  'assets/sidemenu/arrow.svg',
                                  color: CustomTheme.of(context).splashColor,
                                  height: 20.0,
                                ),
                              ],
                            ),
                          ),
                          // const SizedBox(
                          //   height: 20.0,
                          // ),
                          // Container(
                          //   height: 0.7,
                          //   width: MediaQuery.of(context).size.width,
                          //   color: CustomTheme.of(context).shadowColor,
                          // ),

                          const SizedBox(
                            height: 30.0,
                          ),
                          InkWell(
                            onTap: (){
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const TermsCondition(title: "loc_policy", content: 'https://h2crypto.exchange/page/termsofservice'),
                                  ));

                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [

                                    Text(
                                      AppLocalizations.instance.text("loc_policy"),
                                      style: CustomWidget(context: context)
                                          .CustomSizedTextStyle(
                                          16.0,
                                          Theme.of(context).splashColor,
                                          FontWeight.normal,
                                          'FontRegular'),
                                    ),
                                  ],
                                ),
                                SvgPicture.asset(
                                  'assets/sidemenu/arrow.svg',
                                  color: CustomTheme.of(context).splashColor,
                                  height: 20.0,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 20.0,
                          ),


                          const SizedBox(
                            height: 20.0,
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),

            ],
          )
      ),
    );
  }
}
