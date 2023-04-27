import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:h2_crypto/common/custom_button.dart';
import 'package:h2_crypto/common/localization/localizations.dart';
import 'package:h2_crypto/common/theme/custom_theme.dart';

import '../../../common/custom_widget.dart';

class SetNameScreen3 extends StatefulWidget {
  const SetNameScreen3({Key? key}) : super(key: key);

  @override
  State<SetNameScreen3> createState() => _NickName3State();
}

class _NickName3State extends State<SetNameScreen3> {
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
                height: 10.0,
                width: 10.0,
                allowDrawingOutsideViewBox: true,
              ),
            )),
        centerTitle: true,
      ),
      body: Container(
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
        child: SingleChildScrollView(
          child: SafeArea(
            child: Padding(
              padding: EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        AppLocalizations.instance.text("loc_nick_nme2"),
                        style: CustomWidget(context: context)
                            .CustomSizedTextStyle(
                            24.0,
                            Theme.of(context).splashColor,
                            FontWeight.w500,
                            'FontRegular'),
                      ),
                      Container(
                        margin: const EdgeInsets.only(
                          left: 6.0,
                        ),
                        padding: const EdgeInsets.all(5.0),
                        child: SvgPicture.asset(
                          'assets/images/edit.svg',
                          height: 22.0,
                          width: 22.0,
                          allowDrawingOutsideViewBox: true,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 15.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Personal Verification",
                        style: CustomWidget(context: context)
                            .CustomSizedTextStyle(
                            13.0,
                            Theme.of(context).splashColor,
                            FontWeight.w400,
                            'FontRegular'),
                      ),
                      Row(
                        children: [
                          Container(
                            margin: const EdgeInsets.only(
                              left: 6.0,
                            ),
                            padding: const EdgeInsets.all(5.0),
                            child: SvgPicture.asset(
                              'assets/images/transfer.svg',
                              height: 20.0,
                              width: 20.0,
                              allowDrawingOutsideViewBox: true,
                            ),
                          ),
                          Text(
                            "Institutional Verification",
                            style: CustomWidget(context: context)
                                .CustomSizedTextStyle(
                                13.0,
                                Theme.of(context).buttonColor,
                                FontWeight.w400,
                                'FontRegular'),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 15.0,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: CustomTheme.of(context).buttonColor.withOpacity(0.2),
                      borderRadius: BorderRadius.all(
                        Radius.circular(8),
                      ),
                    ),
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Advanced KYC",
                          style: CustomWidget(context: context)
                              .CustomSizedTextStyle(
                              13.0,
                              Theme.of(context).splashColor,
                              FontWeight.w400,
                              'FontRegular'),
                        ),
                        const SizedBox(
                          height: 15.0,
                        ),
                        Text(
                          "* The daily withdrawal limit can be increased to 200 BTC.",
                          style: CustomWidget(context: context)
                              .CustomSizedTextStyle(
                              11.0,
                              Theme.of(context).splashColor.withOpacity(0.5),
                              FontWeight.w400,
                              'FontRegular'),
                        ),
                        const SizedBox(
                          height: 15.0,
                        ),
                        ButtonCustom(
                            text: AppLocalizations.instance
                                .text("loc_verify_btn"),
                            iconEnable: false,
                            radius: 5.0,
                            icon: "",
                            textStyle: CustomWidget(context: context)
                                .CustomSizedTextStyle(
                                18.0,
                                Theme.of(context).splashColor,
                                FontWeight.w500,
                                'FontRegular'),
                            iconColor: CustomTheme.of(context).buttonColor,
                            buttonColor: CustomTheme.of(context).buttonColor,
                            splashColor: CustomTheme.of(context).buttonColor,
                            onPressed: () {},
                            paddng: 1.0),
                        const SizedBox(
                          height: 15.0,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: CustomTheme.of(context).buttonColor.withOpacity(0.2),
                      borderRadius: BorderRadius.all(
                        Radius.circular(8),
                      ),
                    ),
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Primary KYC",
                              style: CustomWidget(context: context)
                                  .CustomSizedTextStyle(
                                  13.0,
                                  Theme.of(context).splashColor,
                                  FontWeight.w500,
                                  'FontRegular'),
                            ),
                            Container(
                              margin: const EdgeInsets.only(
                                left: 6.0,
                              ),
                              padding: const EdgeInsets.all(5.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    "verify",
                                    style: CustomWidget(context: context)
                                        .CustomSizedTextStyle(
                                        13.0,
                                        Theme.of(context).buttonColor,
                                        FontWeight.w500,
                                        'FontRegular'),
                                  ),
                                  SvgPicture.asset(
                                    'assets/images/arrow right_.svg',
                                    height: 13.0,
                                    width: 13.0,
                                    allowDrawingOutsideViewBox: true,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 15.0,
                        ),
                        Text(
                          "* The daily withdrawal limit can be increased to 40 BTC.",
                          style: CustomWidget(context: context)
                              .CustomSizedTextStyle(
                              11.0,
                              Theme.of(context).splashColor.withOpacity(0.5),
                              FontWeight.w400,
                              'FontRegular'),
                        ),
                        const SizedBox(
                          height: 15.0,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  // Container(
                  //   decoration: BoxDecoration(
                  //     color: CustomTheme.of(context).buttonColor.withOpacity(0.2),
                  //     borderRadius: BorderRadius.all(
                  //       Radius.circular(8),
                  //     ),
                  //   ),
                  //   padding: const EdgeInsets.all(10.0),
                  //   child: Column(
                  //     mainAxisAlignment: MainAxisAlignment.start,
                  //     crossAxisAlignment: CrossAxisAlignment.start,
                  //     children: [
                  //       Row(
                  //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //         crossAxisAlignment: CrossAxisAlignment.start,
                  //         children: [
                  //           Text(
                  //             "Trading fee",
                  //             style: GoogleFonts.habibi(
                  //               color: CustomTheme.of(context).splashColor,
                  //               fontWeight: FontWeight.w500,
                  //               fontSize: 14.0,
                  //             ),
                  //           ),
                  //           Container(
                  //             margin: const EdgeInsets.only(
                  //               left: 6.0,
                  //             ),
                  //             padding: const EdgeInsets.all(5.0),
                  //             child: SvgPicture.asset(
                  //               'assets/images/arrow right_.svg',
                  //               height: 15.0,
                  //               width: 15.0,
                  //               allowDrawingOutsideViewBox: true,
                  //             ),
                  //           ),
                  //         ],
                  //       ),
                  //       const SizedBox(
                  //         height: 15.0,
                  //       ),
                  //       Row(
                  //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //         crossAxisAlignment: CrossAxisAlignment.start,
                  //         children: [
                  //           Text(
                  //             "Spotmaker",
                  //             style: GoogleFonts.habibi(
                  //               color: CustomTheme.of(context).splashColor.withOpacity(0.5),
                  //               fontWeight: FontWeight.w400,
                  //               fontSize: 11.0,
                  //             ),
                  //           ),
                  //           Text(
                  //             "0.2%",
                  //             style: GoogleFonts.habibi(
                  //               color: CustomTheme.of(context).splashColor.withOpacity(0.5),
                  //               fontWeight: FontWeight.w400,
                  //               fontSize: 11.0,
                  //             ),
                  //           ),
                  //         ],
                  //       ),
                  //       const SizedBox(
                  //         height: 10.0,
                  //       ),
                  //       Row(
                  //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //         crossAxisAlignment: CrossAxisAlignment.start,
                  //         children: [
                  //           Text(
                  //             "Spottaker",
                  //             style: GoogleFonts.habibi(
                  //               color: CustomTheme.of(context).splashColor.withOpacity(0.5),
                  //               fontWeight: FontWeight.w400,
                  //               fontSize: 11.0,
                  //             ),
                  //           ),
                  //           Text(
                  //             "0.2%",
                  //             style: GoogleFonts.habibi(
                  //               color: CustomTheme.of(context).splashColor.withOpacity(0.5),
                  //               fontWeight: FontWeight.w400,
                  //               fontSize: 11.0,
                  //             ),
                  //           ),
                  //         ],
                  //       ),
                  //       const SizedBox(
                  //         height: 15.0,
                  //       ),
                  //       Text(
                  //         "Withdrawal limit",
                  //         style: GoogleFonts.habibi(
                  //           color: CustomTheme.of(context).splashColor,
                  //           fontWeight: FontWeight.w500,
                  //           fontSize: 14.0,
                  //         ),
                  //       ),
                  //       const SizedBox(
                  //         height: 15.0,
                  //       ),
                  //       Row(
                  //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //         crossAxisAlignment: CrossAxisAlignment.start,
                  //         children: [
                  //           Text(
                  //             "Daily withdrawal limit",
                  //             style: GoogleFonts.habibi(
                  //               color: CustomTheme.of(context).splashColor.withOpacity(0.5),
                  //               fontWeight: FontWeight.w400,
                  //               fontSize: 11.0,
                  //             ),
                  //           ),
                  //           Text(
                  //             "5BTC",
                  //             style: GoogleFonts.habibi(
                  //               color: CustomTheme.of(context).splashColor.withOpacity(0.5),
                  //               fontWeight: FontWeight.w400,
                  //               fontSize: 11.0,
                  //             ),
                  //           ),
                  //         ],
                  //       ),
                  //       const SizedBox(
                  //         height: 20.0,
                  //       ),
                  //       Container(
                  //         decoration: BoxDecoration(
                  //           color: CustomTheme.of(context).buttonColor.withOpacity(0.5),
                  //           borderRadius: BorderRadius.all(
                  //             Radius.circular(20),
                  //           ),
                  //         ),
                  //         padding: const EdgeInsets.only(left: 15.0,right: 10.0,top: 8.0,bottom: 8.0),
                  //         child: Row(
                  //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //           crossAxisAlignment: CrossAxisAlignment.center,
                  //           children: [
                  //             Row(
                  //               children: [
                  //                 SvgPicture.asset(
                  //                   'assets/images/vip 4.svg',
                  //                   height: 15.0,
                  //                   width: 15.0,
                  //                   allowDrawingOutsideViewBox: true,
                  //                 ),
                  //                 const SizedBox(width: 5.0,),
                  //                 Text(
                  //                   "Apply to be VIP",
                  //                   style: GoogleFonts.habibi(
                  //                     color:
                  //                         CustomTheme.of(context).splashColor,
                  //                     fontWeight: FontWeight.w400,
                  //                     fontSize: 12.0,
                  //                   ),
                  //                 ),
                  //               ],
                  //             ),
                  //             Text(
                  //               "Enjoy more privilleges",
                  //               style: GoogleFonts.habibi(
                  //                 color: CustomTheme.of(context).splashColor.withOpacity(0.5),
                  //                 fontWeight: FontWeight.w400,
                  //                 fontSize: 10.0,
                  //               ),
                  //             ),
                  //
                  //           ],
                  //         ),
                  //       ),
                  //       const SizedBox(
                  //         height: 10.0,
                  //       ),
                  //     ],
                  //   ),
                  // ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
