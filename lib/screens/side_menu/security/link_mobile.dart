
import 'package:country_calling_code_picker/functions.dart';
import 'package:country_calling_code_picker/picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:h2_crypto/common/colors.dart';
import 'package:h2_crypto/common/country.dart';
import 'package:h2_crypto/common/custom_button.dart';
import 'package:h2_crypto/common/custom_widget.dart';
import 'package:h2_crypto/common/localization/localizations.dart';
import 'package:h2_crypto/common/text_field_custom_prefix.dart';
import 'package:h2_crypto/common/textformfield_custom.dart';
import 'package:h2_crypto/common/theme/custom_theme.dart';
import 'package:h2_crypto/data/api_utils.dart';
import 'package:h2_crypto/data/model/common_model.dart';
import 'package:h2_crypto/screens/basic/home.dart';


import 'package:shared_preferences/shared_preferences.dart';

import '../../../data/model/sent_otp_model.dart';

class LinkMobileNo extends StatefulWidget {
  const LinkMobileNo({Key? key}) : super(key: key);

  @override
  _LinkMobileNoState createState() => _LinkMobileNoState();
}

class _LinkMobileNoState extends State<LinkMobileNo> {
  bool loading = false;
  bool _passwordVisible = false;
  Country? _selectedCountry;
  bool mobileAuth = false;
  bool emailAuth = false;

  TextEditingController mobile = TextEditingController();
  TextEditingController mobile_password = TextEditingController();
  TextEditingController mobile_verify = TextEditingController();
  TextEditingController mobile_refer = TextEditingController();
  TextEditingController mobile_auth = TextEditingController();
  TextEditingController email_auth = TextEditingController();
  String userId = "";
  FocusNode mobileFocus = FocusNode();
  FocusNode mobileAuthFocus = FocusNode();
  FocusNode mobilePassFocus = FocusNode();
  FocusNode mobileVerifyFocus = FocusNode();
  FocusNode mobileReferFocus = FocusNode();
  bool countryB = false;
  bool isMobile = false;
  bool isEmail = true;

  ScrollController controller = ScrollController();
  final mobileformKey = GlobalKey<FormState>();

  bool mobileVerify = true;
  bool mobileCodeVerify = false;
  bool mobilePassVerify = true;
  bool mobileReferVerify = false;
  APIUtils apiUtils = APIUtils();

  @override
  void initState() {
    initCountry();
    super.initState();
  }

  void initCountry() async {
    final country = await getDefaultCountry(context);
    setState(() {
      _selectedCountry = country;
      countryB = true;
    });
  }


  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      child: Scaffold(
        appBar: AppBar(
            backgroundColor: CustomTheme.of(context).primaryColor,
            elevation: 0.0,
            centerTitle: true,
            title: Text(
              AppLocalizations.instance.text("loc_phone_no"),
              style: CustomWidget(context: context).CustomSizedTextStyle(
                  17.0,
                  Theme.of(context).splashColor,
                  FontWeight.w500,
                  'FontRegular'),
            ),
            leading: Padding(
              padding: EdgeInsets.only(left: 0.0),
              // child: InkWell(
              //   onTap: () {
              //     Navigator.pop(context);
              //   },
              //   child: Container(
              //     padding: EdgeInsets.only(left: 16.0, right: 16.0),
              //     child: SvgPicture.asset(
              //       'assets/others/arrow_left.svg',
              //       color: CustomTheme.of(context).splashColor,
              //     ),
              //   ),
              // ),
            )),
        body: Container(
            height: MediaQuery.of(context).size.height,
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
              controller: controller,
              child: Stack(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width,
                        padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                        color: Color(0xFFFBC02D).withOpacity(0.3),
                        child: Row(
                          children: [
                            const SizedBox(
                              width: 20.0,
                            ),
                            SvgPicture.asset(
                              'assets/images/info.svg',
                              height: 20.0,
                              color: Color(0xFFFAAD34),
                            ),
                            const SizedBox(
                              width: 10.0,
                            ),
                            Flexible(
                              child: Text(
                                "No withdrawal and FiAT trading within 24 hours after changing the login password",
                                style: CustomWidget(context: context)
                                    .CustomSizedTextStyle(
                                        10.0,
                                        Theme.of(context)
                                            .splashColor
                                            .withOpacity(0.5),
                                        FontWeight.w500,
                                        'FontRegular'),
                                softWrap: true,
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      Container(
                        padding: EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
                        child: Column(
                          children: [
                            // Container(
                            //   decoration: BoxDecoration(
                            //     borderRadius: BorderRadius.circular(5.0),
                            //     border: Border.all(
                            //         color: CustomTheme.of(context)
                            //             .splashColor.withOpacity(0.5),
                            //         width: 1),
                            //     color: CustomTheme.of(context)
                            //         .backgroundColor
                            //         .withOpacity(0.5),
                            //   ),
                            //   child: Row(
                            //     children: [
                            //       Container(
                            //         padding: const EdgeInsets.only(
                            //             left: 10.0,
                            //             right: 10.0,
                            //             top: 14.0,
                            //             bottom: 14.0),
                            //         color: CustomTheme.of(context)
                            //             .backgroundColor
                            //             .withOpacity(0.5),
                            //         child: InkWell(
                            //           onTap: _onPressedShowBottomSheet,
                            //           child: Row(
                            //             children: [
                            //               Text(
                            //                 countryB
                            //                     ? _selectedCountry!.callingCode
                            //                         .toString()
                            //                     : "+1",
                            //                 style:
                            //                     CustomWidget(context: context)
                            //                         .CustomTextStyle(
                            //                             Theme.of(context)
                            //                                 .splashColor,
                            //                             FontWeight.normal,
                            //                             'FontRegular'),
                            //               ),
                            //               const SizedBox(
                            //                 width: 3.0,
                            //               ),
                            //               const Icon(
                            //                 Icons.arrow_forward_ios_rounded,
                            //                 size: 12.0,
                            //                 color: AppColors.backgroundColor,
                            //               )
                            //             ],
                            //           ),
                            //         ),
                            //       ),
                            //       Flexible(
                            //         child: TextFormField(
                            //           controller: mobile,
                            //           focusNode: mobileFocus,
                            //           maxLines: 1,
                            //           enabled: mobileVerify,
                            //           textInputAction: TextInputAction.next,
                            //           keyboardType: TextInputType.number,
                            //           style: CustomWidget(context: context)
                            //               .CustomTextStyle(
                            //                   Theme.of(context).splashColor,
                            //                   FontWeight.w400,
                            //                   'FontRegular'),
                            //           decoration: InputDecoration(
                            //             contentPadding: const EdgeInsets.only(
                            //                 left: 12,
                            //                 right: 0,
                            //                 top: 2,
                            //                 bottom: 2),
                            //             filled: true,
                            //             fillColor:   Theme.of(context)
                            //                 .backgroundColor
                            //                 .withOpacity(0.5),
                            //             hintText: "Please enter Mobile",
                            //             suffixIcon: Container(
                            //               width: 0.0,
                            //             ),
                            //             hintStyle:
                            //                 CustomWidget(context: context)
                            //                     .CustomTextStyle(
                            //                         Theme.of(context)
                            //                             .splashColor.withOpacity(0.5),
                            //                         FontWeight.w300,
                            //                         'FontRegular'),
                            //             border: OutlineInputBorder(
                            //               borderRadius: BorderRadius.zero,
                            //               borderSide: BorderSide(
                            //                 color: Theme.of(context)
                            //                     .splashColor,
                            //               ),
                            //             ),
                            //             enabledBorder: OutlineInputBorder(
                            //               borderRadius: BorderRadius.zero,
                            //               borderSide: BorderSide(
                            //                 color: Theme.of(context)
                            //                     .backgroundColor
                            //                     .withOpacity(0.5),
                            //               ),
                            //             ),
                            //             focusedBorder: OutlineInputBorder(
                            //               borderRadius: BorderRadius.zero,
                            //               borderSide: BorderSide(
                            //                 color: Theme.of(context)
                            //                     .backgroundColor
                            //                     .withOpacity(0.5),
                            //               ),
                            //             ),
                            //           ),
                            //         ),
                            //         flex: 1,
                            //       )
                            //     ],
                            //   ),
                            // ),
                            // const SizedBox(
                            //   height: 10.0,
                            // ),
                            //
                            // const SizedBox(
                            //   height: 15.0,
                            // ),

                            Row(
                              children: [
                                Flexible(
                                  child: TextFormCustom(
                                      autovalidateMode: AutovalidateMode.onUserInteraction,
                                      onEditComplete: () {
                                        mobileVerifyFocus.unfocus();
                                      },
                                      radius: 5.0,
                                      error: "Enter Valid Verification code",
                                      textColor: AppColors.appColor,
                                      borderColor: CustomTheme.of(context)
                                          .splashColor.withOpacity(0.5),
                                      fillColor: CustomTheme.of(context)
                                          .backgroundColor
                                          .withOpacity(0.5),
                                      textInputAction: TextInputAction.next,
                                      focusNode: mobileVerifyFocus,
                                      maxlines: 1,
                                      text: '',
                                      hintText: "Enter Verification code",
                                      obscureText: false,
                                      suffix: Container(
                                        width: 0.0,
                                      ),
                                      textChanged: (value) {},
                                      onChanged: () {},
                                      validator: (value) {
                                        return null;
                                      },
                                      enabled: mobileCodeVerify,
                                      textInputType: TextInputType.number,
                                      controller: mobile_verify,
                                      hintStyle: CustomWidget(context: context)
                                          .CustomTextStyle(
                                              Theme.of(context)
                                                  .splashColor.withOpacity(0.5),
                                              FontWeight.w300,
                                              'FontRegular'),
                                      textStyle: CustomWidget(context: context)
                                          .CustomTextStyle(
                                              Theme.of(context).splashColor,
                                              FontWeight.w400,
                                              'FontRegular'),
                                      prefix: Padding(
                                        padding: EdgeInsets.all(10.0),
                                        child: SvgPicture.asset(
                                          'assets/images/security.svg',
                                          color: Theme.of(context)
                                              .splashColor
                                              .withOpacity(0.5),
                                          height: 20.0,
                                        ),
                                      )),
                                  flex: 2,
                                ),
                                const SizedBox(
                                  width: 10.0,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      FocusScope.of(context).unfocus();
                                        loading = true;
                                        sentOtp();

                                    });
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color:
                                            CustomTheme.of(context).buttonColor,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(5.0))),
                                    padding: const EdgeInsets.only(
                                        left: 15.0,
                                        right: 15.0,
                                        top: 13.5,
                                        bottom: 13.5),
                                    child: Text(
                                      AppLocalizations.instance
                                          .text("loc_sent_code"),
                                      style: CustomWidget(context: context)
                                          .CustomTextStyle(
                                              Theme.of(context).splashColor,
                                              FontWeight.normal,
                                              'FontRegular'),
                                    ),
                                  ),
                                )
                              ],
                            ),
                            const SizedBox(
                              height: 15.0,
                            ),
                            //
                            // TextFormCustom(
                            //     obscureText: !_passwordVisible,
                            //     textInputAction: TextInputAction.done,
                            //     hintStyle: CustomWidget(context: context)
                            //         .CustomTextStyle(
                            //         Theme.of(context)
                            //             .splashColor
                            //             .withOpacity(0.5),
                            //         FontWeight.w300,
                            //         'FontRegular'),
                            //     radius: 5.0,
                            //     focusNode: mobilePassFocus,
                            //     controller: mobile_password,
                            //     enabled: mobilePassVerify,
                            //     borderColor: CustomTheme.of(context)
                            //         .splashColor
                            //         .withOpacity(0.5),
                            //     fillColor: CustomTheme.of(context)
                            //         .backgroundColor
                            //         .withOpacity(0.5),
                            //     onChanged: () {},
                            //     hintText: "Google Authantication Code",
                            //     textChanged: (value) {},
                            //     suffix: Text(
                            //       "Paste",
                            //       style: CustomWidget(context: context)
                            //           .CustomSizedTextStyle(
                            //           14.0,
                            //           Theme.of(context).buttonColor,
                            //           FontWeight.w500,
                            //           'FontRegular'),
                            //       textAlign: TextAlign.center,
                            //     ),
                            //     validator: (value) {
                            //       if (value!.isEmpty) {
                            //         return "Please enter Authentication code";
                            //       }
                            //
                            //       return null;
                            //     },
                            //     textStyle: CustomWidget(context: context)
                            //         .CustomTextStyle(
                            //         Theme.of(context).splashColor,
                            //         FontWeight.w400,
                            //         'FontRegular'),
                            //     maxlines: 1,
                            //     error: "Enter Valid Password",
                            //     text: "",
                            //     onEditComplete: () {
                            //       mobilePassFocus.unfocus();
                            //     },
                            //     textColor: AppColors.blackColor,
                            //     textInputType: TextInputType.visiblePassword,
                            //     prefix: Padding(
                            //       padding: EdgeInsets.all(10.0),
                            //       child: SvgPicture.asset('assets/images/security.svg',color:   Theme.of(context)
                            //           .splashColor
                            //           .withOpacity(0.5),height: 20.0,),
                            //     )
                            //
                            //
                            // ),
                            // Column(
                            //   children: [
                            //
                            //     SizedBox(
                            //       height: mobileAuth ? 20.0 : 0.0,
                            //     ),
                            //     mobileAuth
                            //         ? TextFormFieldCustom(
                            //             onEditComplete: () {
                            //               mobileAuthFocus.unfocus();
                            //             },
                            //             radius: 5.0,
                            //             error: "Enter Valid Email",
                            //             textColor: AppColors.borderColor,
                            //             borderColor: CustomTheme.of(context)
                            //                 .splashColor
                            //                 .withOpacity(0.5),
                            //             fillColor: CustomTheme.of(context)
                            //                 .backgroundColor
                            //                 .withOpacity(0.5),
                            //             textInputAction: TextInputAction.next,
                            //             focusNode: mobileAuthFocus,
                            //             maxlines: 1,
                            //             text: '',
                            //             hintText: "Two Factor Code",
                            //             obscureText: false,
                            //             suffix: Container(
                            //               width: 0.0,
                            //             ),
                            //             textChanged: (value) {},
                            //             onChanged: () {},
                            //             validator: (value) {
                            //               if (value!.isEmpty) {
                            //                 return "Please enter Code";
                            //               }
                            //
                            //               return null;
                            //             },
                            //             enabled: true,
                            //             textInputType: TextInputType.number,
                            //             controller: mobile_auth,
                            //             hintStyle:
                            //                 CustomWidget(context: context)
                            //                     .CustomTextStyle(
                            //                         Theme.of(context)
                            //                             .splashColor
                            //                             .withOpacity(0.5),
                            //                         FontWeight.w300,
                            //                         'FontRegular'),
                            //             textStyle: CustomWidget(
                            //                     context: context)
                            //                 .CustomTextStyle(
                            //                     Theme.of(context).splashColor,
                            //                     FontWeight.w400,
                            //                     'FontRegular'),
                            //           )
                            //         : Container(),
                            //     const SizedBox(
                            //       height: 20.0,
                            //     ),
                            //   ],
                            // ),
                            // const SizedBox(
                            //   height: 15.0,
                            // ),
                            ButtonCustom(
                                text: AppLocalizations.instance
                                    .text("loc_confirm"),
                                iconEnable: false,
                                radius: 5.0,
                                icon: "",
                                textStyle: CustomWidget(context: context)
                                    .CustomSizedTextStyle(
                                        18.0,
                                        Theme.of(context).splashColor,
                                        FontWeight.w500,
                                        'FontRegular'),
                                iconColor: AppColors.borderColor,
                                buttonColor:
                                    CustomTheme.of(context).buttonColor,
                                splashColor:
                                    CustomTheme.of(context).buttonColor,
                                onPressed: () {
                                  FocusScope.of(context).unfocus();

                                  if (mobile_verify.text.isNotEmpty) {
                                    setState(() {
                                      loading = true;
                                      verifyEmail();
                                    });

                                  }
                                  else{
                                    CustomWidget(context: context).  custombar("verify Mobile Number", "Enter Verification Code", false);

                                  }
                                },
                                paddng: 0.0),
                            const SizedBox(
                              height: 15.0,
                            ),
                          ],
                        ),
                      ),
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
      ),
    );
  }

  void _onPressedShowBottomSheet() async {
    final country = await showCountryPickerSheets(
      context,
    );
    if (country != null) {
      setState(() {
        _selectedCountry = country;
      });
    }
  }

  sentOtp() {
    apiUtils.emailSendOTP("sms").then((CommonModel loginData) {
      if (loginData.status!) {
        setState(() {
          loading = false;
          CustomWidget(context: context).  custombar("Link Mobile Number",loginData.message.toString(), true);
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => Home(

              ),
            ),
          );

        });
      } else {
        setState(() {
          loading = false;
          CustomWidget(context: context).  custombar("Link Mobile Number",loginData.message.toString(), false);
        });
      }
    }).catchError((Object error) {
      setState(() {
        loading = false;
      });
    });
  }

  verifyEmail() {
    apiUtils.updateEmailDetails("sms", mobile_verify.text.toString()).then((CommonModel loginData) {
      if (loginData.status!) {
        setState(() {
          loading = false;
          CustomWidget(context: context).  custombar("Link Mobile Number",loginData.message.toString(), true);
          Navigator.pop(context,true);

        });
      } else {
        setState(() {
          loading = false;
          CustomWidget(context: context).  custombar("Link Mobile Number",loginData.message.toString(), false);

        });
      }
    }).catchError((Object error) {
      setState(() {
        loading = false;
      });
    });
  }
}
