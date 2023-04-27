import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:h2_crypto/common/custom_widget.dart';

import 'package:h2_crypto/common/localization/localizations.dart';
import 'package:h2_crypto/common/theme/custom_theme.dart';
import 'package:h2_crypto/data/api_utils.dart';
import 'package:h2_crypto/data/model/user_details_model.dart';
import 'package:h2_crypto/screens/side_menu/security/change_password.dart';
import 'package:h2_crypto/screens/side_menu/security/google_tfa_screen.dart';
import 'package:h2_crypto/screens/side_menu/security/kyc_info.dart';
import 'package:h2_crypto/screens/side_menu/security/link_email_address.dart';
import 'package:h2_crypto/screens/side_menu/security/link_mobile.dart';

class SecurityScreen extends StatefulWidget {
  const SecurityScreen({Key? key}) : super(key: key);

  @override
  State<SecurityScreen> createState() => _SecurityScreenState();
}

class _SecurityScreenState extends State<SecurityScreen> {
  bool touch = false;
  bool gestPass = false;
  bool loading = false;
  APIUtils apiUtils = APIUtils();
  UserDetails? userDetails;
  bool emailUpdate=false;
  bool mobileUpdate=false;
  bool googleUpdate=false;
  bool kycUpdate=false;


  @override
  void initState() {
    super.initState();
    loading = true;
    getDetails();
  }

  _getRequests() async {
    setState(() {
      loading = true;
     getDetails();
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: CustomTheme.of(context).primaryColor,
          elevation: 0.0,
          centerTitle: true,
          title: Text(
            AppLocalizations.instance.text("loc_security"),
            style: CustomWidget(context: context).CustomSizedTextStyle(17.0,
                Theme.of(context).splashColor, FontWeight.w500, 'FontRegular'),
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
          padding: const EdgeInsets.only(top: 10.0),
          decoration: BoxDecoration(
              gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              CustomTheme.of(context).primaryColor,
              CustomTheme.of(context).backgroundColor,
            ],
          )),
          child: SingleChildScrollView(
            child: Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 15.0, right: 15.0),
                      child: Text(
                        AppLocalizations.instance.text("loc_kyc"),
                        style: CustomWidget(context: context)
                            .CustomSizedTextStyle(
                                18.0,
                                Theme.of(context).splashColor.withOpacity(0.5),
                                FontWeight.w500,
                                'FontRegular'),
                      ),
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    InkWell(
                      onTap: () {
                        if(kycUpdate)
                          {
                            CustomWidget(context: context).  custombar("Security","KYC Already Linked", true);


                          }
                        else
                          {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const KYCPage(),
                                ));
                          }

                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        color: CustomTheme.of(context)
                            .buttonColor
                            .withOpacity(0.5),
                        padding: EdgeInsets.only(
                            left: 15.0, right: 15.0, top: 8.0, bottom: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              AppLocalizations.instance.text("loc_kyc"),
                              style: CustomWidget(context: context)
                                  .CustomTextStyle(
                                      Theme.of(context).splashColor,
                                      FontWeight.w500,
                                      'FontRegular'),
                            ),
                            Row(
                              children: [
                                Text(
                                 kycUpdate?"Certified" :"Uncertified",
                                  style: CustomWidget(context: context)
                                      .CustomSizedTextStyle(
                                          12.0,
                                          Theme.of(context)
                                              .splashColor
                                              .withOpacity(0.5),
                                          FontWeight.w500,
                                          'FontRegular'),
                                ),
                                Icon(
                                  Icons.arrow_forward_ios_rounded,
                                  color: CustomTheme.of(context)
                                      .splashColor
                                      .withOpacity(0.5),
                                  size: 16.0,
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 15.0, right: 15.0),
                      child: Text(
                        AppLocalizations.instance.text("loc_security_set"),
                        style: CustomWidget(context: context).CustomTextStyle(
                            Theme.of(context).splashColor.withOpacity(0.5),
                            FontWeight.w500,
                            'FontRegular'),
                      ),
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    Container(
                        width: MediaQuery.of(context).size.width,
                        color: CustomTheme.of(context)
                            .buttonColor
                            .withOpacity(0.5),
                        padding: EdgeInsets.only(
                            left: 15.0, right: 15.0, top: 10.0, bottom: 10.0),
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 15.0,
                            ),
                            InkWell(
                              onTap: () {

                                Navigator.of(context)
                                    .push(
                                  MaterialPageRoute(
                                      builder: (_) => GoogleTFAScreen(username: userDetails!.name.toString())),
                                )
                                    .then((val) {
                                  (val == true || val == null) ? _getRequests() : null;
                                });

                              },
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    AppLocalizations.instance
                                        .text("loc_google_auth"),
                                    style: CustomWidget(context: context)
                                        .CustomTextStyle(
                                            Theme.of(context).splashColor,
                                            FontWeight.normal,
                                            'FontRegular'),
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        googleUpdate?  "Disable":"Enable",
                                        style: CustomWidget(context: context)
                                            .CustomSizedTextStyle(
                                                12.0,
                                                Theme.of(context)
                                                    .splashColor
                                                    .withOpacity(0.5),
                                                FontWeight.w500,
                                                'FontRegular'),
                                      ),
                                      Icon(
                                        Icons.arrow_forward_ios_rounded,
                                        color: CustomTheme.of(context)
                                            .splashColor
                                            .withOpacity(0.5),
                                        size: 16.0,
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 25.0,
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const ChangePassword(),
                                    ));
                              },
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    AppLocalizations.instance
                                        .text("loc_change_password"),
                                    style: CustomWidget(context: context)
                                        .CustomTextStyle(
                                            Theme.of(context).splashColor,
                                            FontWeight.normal,
                                            'FontRegular'),
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        "Modify",
                                        style: CustomWidget(context: context)
                                            .CustomSizedTextStyle(
                                                12.0,
                                                Theme.of(context)
                                                    .splashColor
                                                    .withOpacity(0.5),
                                                FontWeight.normal,
                                                'FontRegular'),
                                      ),
                                      Icon(
                                        Icons.arrow_forward_ios_rounded,
                                        color: CustomTheme.of(context)
                                            .splashColor
                                            .withOpacity(0.5),
                                        size: 16.0,
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 25.0,
                            ),
                         InkWell(
                           onTap: (){

                             if(emailUpdate)
                             {
                               CustomWidget(context: context).  custombar("Security","Email ID Already Linked", true);


                             }
                             else
                             {
                               Navigator.of(context)
                                   .push(
                                 MaterialPageRoute(
                                     builder: (_) => LinkEmailAddress()),
                               )
                                   .then((val) {
                                 (val == true || val == null) ? _getRequests() : null;
                               });
                             }

                           },
                           child:    Row(
                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
                             children: [
                               Text(
                                 AppLocalizations.instance
                                     .text("loc_link_mail"),
                                 style: CustomWidget(context: context)
                                     .CustomTextStyle(
                                     Theme.of(context).splashColor,
                                     FontWeight.normal,
                                     'FontRegular'),
                               ),
                               Row(
                                 children: [
                                   Text(
                                     emailUpdate?"Linked": "Not Linked",
                                     style: CustomWidget(context: context)
                                         .CustomSizedTextStyle(
                                         12.0,
                                         Theme.of(context)
                                             .splashColor
                                             .withOpacity(0.5),
                                         FontWeight.normal,
                                         'FontRegular'),
                                   ),
                                   Icon(
                                     Icons.arrow_forward_ios_rounded,
                                     color: CustomTheme.of(context)
                                         .splashColor
                                         .withOpacity(0.5),
                                     size: 16.0,
                                   )
                                 ],
                               )
                             ],
                           ),
                         ),
                            const SizedBox(
                              height: 25.0,
                            ),
                           InkWell(
                             onTap: (){
                               if(mobileUpdate)
                                 {
                                   CustomWidget(context: context).  custombar("Security","Mobile Number Already Linked", true);


                                 }
                               else
                                 {

                                   Navigator.of(context)
                                       .push(
                                     MaterialPageRoute(
                                         builder: (_) => LinkMobileNo()),
                                   )
                                       .then((val) {
                                     (val == true || val == null) ? _getRequests() : null;
                                   });
                                 }

                             },
                             child:  Row(
                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
                               children: [
                                 Text(
                                   AppLocalizations.instance
                                       .text("loc_link_mobile"),
                                   style: CustomWidget(context: context)
                                       .CustomTextStyle(
                                       Theme.of(context).splashColor,
                                       FontWeight.w500,
                                       'FontRegular'),
                                 ),
                                 Row(
                                   children: [
                                     Text(
                                       mobileUpdate?"Linked": "Not Linked",
                                       style: CustomWidget(context: context)
                                           .CustomSizedTextStyle(
                                           12.0,
                                           Theme.of(context)
                                               .splashColor
                                               .withOpacity(0.5),
                                           FontWeight.normal,
                                           'FontRegular'),
                                     ),
                                     Icon(
                                       Icons.arrow_forward_ios_rounded,
                                       color: CustomTheme.of(context)
                                           .splashColor
                                           .withOpacity(0.5),
                                       size: 16.0,
                                     )
                                   ],
                                 )
                               ],
                             ),
                           ),
                            const SizedBox(
                              height: 25.0,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  AppLocalizations.instance
                                      .text("loc_touch_id"),
                                  style: CustomWidget(context: context)
                                      .CustomTextStyle(
                                          Theme.of(context).splashColor,
                                          FontWeight.normal,
                                          'FontRegular'),
                                ),
                                Switch(
                                    value: touch,
                                    activeColor:
                                        CustomTheme.of(context).splashColor,
                                    inactiveTrackColor: CustomTheme.of(context)
                                        .buttonColor
                                        .withOpacity(0.5),
                                    onChanged: (val) {
                                      setState(() {
                                        touch = val;
                                        print(val);
                                      });
                                    }),
                              ],
                            ),
                            const SizedBox(
                              height: 5.0,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  AppLocalizations.instance.text("loc_ge_pass"),
                                  style: CustomWidget(context: context)
                                      .CustomTextStyle(
                                          Theme.of(context).splashColor,
                                          FontWeight.normal,
                                          'FontRegular'),
                                ),
                                Switch(
                                    value: gestPass,
                                    activeColor:
                                        CustomTheme.of(context).splashColor,
                                    inactiveTrackColor: CustomTheme.of(context)
                                        .buttonColor
                                        .withOpacity(0.5),
                                    onChanged: (val) {
                                      setState(() {
                                        gestPass = val;
                                      });
                                    }),
                              ],
                            ),
                            const SizedBox(
                              height: 15.0,
                            )
                          ],
                        )),
                    const SizedBox(
                      height: 20.0,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 15.0, right: 15.0),
                      child: Text(
                        AppLocalizations.instance.text("loc_fiat_setting"),
                        style: CustomWidget(context: context).CustomTextStyle(
                            Theme.of(context).splashColor,
                            FontWeight.w500,
                            'FontRegular'),
                      ),
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    InkWell(
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        color: CustomTheme.of(context)
                            .buttonColor
                            .withOpacity(0.5),
                        padding: EdgeInsets.only(
                            left: 15.0, right: 15.0, top: 8.0, bottom: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              AppLocalizations.instance.text("loc_pay_collet"),
                              style: CustomWidget(context: context)
                                  .CustomTextStyle(
                                      Theme.of(context).splashColor,
                                      FontWeight.w500,
                                      'FontRegular'),
                            ),
                            Icon(
                              Icons.arrow_forward_ios_rounded,
                              color: CustomTheme.of(context)
                                  .splashColor
                                  .withOpacity(0.5),
                              size: 16.0,
                            )
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    // Padding(
                    //   padding: EdgeInsets.only(left: 15.0, right: 15.0),
                    //   child: Text(
                    //     AppLocalizations.instance.text("loc_fiat_setting"),
                    //     style: GoogleFonts.habibi(
                    //         fontWeight: FontWeight.w500,
                    //         color:
                    //         CustomTheme.of(context).splashColor.withOpacity(0.5)),
                    //   ),
                    // ),
                    // const SizedBox(
                    //   height: 10.0,
                    // ),
                    // InkWell(
                    //   child: Container(
                    //     width: MediaQuery.of(context).size.width,
                    //     color: CustomTheme.of(context).buttonColor.withOpacity(0.5),
                    //     padding: EdgeInsets.only(
                    //         left: 15.0, right: 15.0, top: 8.0, bottom: 8.0),
                    //     child: Row(
                    //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //       children: [
                    //         Text(
                    //           AppLocalizations.instance.text("loc_with_address"),
                    //           style: GoogleFonts.habibi(
                    //               fontWeight: FontWeight.w500,
                    //               color: CustomTheme.of(context).splashColor),
                    //         ),
                    //         Icon(
                    //           Icons.arrow_forward_ios_rounded,
                    //           color: CustomTheme.of(context)
                    //               .splashColor
                    //               .withOpacity(0.5),
                    //           size: 16.0,
                    //         )
                    //       ],
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
                loading
                    ? CustomWidget(context: context).loadingIndicator(
                        CustomTheme.of(context).splashColor,
                      )
                    : Container()
              ],
            ),
          )),
    );
  }

  getDetails() {
    apiUtils.getUserDetails().then((UserDetailsModel loginData) {
      if (loginData.statusCode.toString() == "200") {
        setState(() {
          loading = false;
          userDetails = loginData.data;
          emailUpdate=loginData.data!.emailVerify!;
          print(loginData.data!.mobileVerify!);
          mobileUpdate=loginData.data!.mobileVerify!;
          googleUpdate=loginData.data!.f2AEnable!;
          if(loginData.data!.kycStatus.toString()=='3')
            {
              kycUpdate=true;
            }
          else
            {
              kycUpdate=false;
            }

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
