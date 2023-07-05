import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
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
import 'package:h2_crypto/common/textformfield_custom.dart';
import 'package:h2_crypto/common/theme/custom_theme.dart';
import 'package:h2_crypto/data/api_utils.dart';
import 'package:h2_crypto/data/crypt_model/login_model.dart';
import 'package:h2_crypto/screens/basic/forgot_pass.dart';
import 'package:h2_crypto/screens/basic/home.dart';
import 'package:h2_crypto/screens/basic/register.dart';

import 'package:h2_crypto/screens/side_menu/security/kyc_info.dart';
import 'package:h2_crypto/screens/side_menu/security/link_email_address.dart';
import 'package:h2_crypto/screens/side_menu/security/link_mobile.dart';
import 'package:shared_preferences/shared_preferences.dart';



class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
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

  TextEditingController email = TextEditingController();

  TextEditingController email_password = TextEditingController();
  TextEditingController email_verify = TextEditingController();
  TextEditingController email_refer = TextEditingController();
  FocusNode emailFocus = FocusNode();
  FocusNode emailAuthFocus = FocusNode();
  FocusNode emailPassFocus = FocusNode();
  FocusNode emailVerifyFocus = FocusNode();
  FocusNode emailreferFocus = FocusNode();
  bool countryB = false;
  bool isMobile = false;
  bool isEmail = true;
  var snackBar;
  ScrollController controller = ScrollController();
  bool emailVerify = true;
  bool emailCodeVerify = false;
  bool emailPassVerify = true;
  bool emailReferVerify = false;
  final emailformKey = GlobalKey<FormState>();
  final mobileformKey = GlobalKey<FormState>();

  bool mobileVerify = true;
  bool mobileCodeVerify = false;
  bool mobilePassVerify = true;
  bool mobileReferVerify = false;
  APIUtils apiUtils = APIUtils();

  custombar(String title, String message, bool status) {
    snackBar = SnackBar(
      elevation: 0,
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      content: AwesomeSnackbarContent(
        title: title,
        message: message,
        contentType: status ? ContentType.success : ContentType.failure,
      ),
    );
    return ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  void initState() {
    // email=TextEditingController(text: "vinoth.alpharive@gmail.com");
    // email_password=TextEditingController(text: "Vinoth@2020");
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



  verifyMail() {
    apiUtils
        .doLoginEmail(
      email.text.toString(),
      email_password.text.toString(),
    )
        .then((LoginDetailsModel loginData) {
      if (loginData.success!) {
        setState(() {
          loading = false;
          CustomWidget(context: context)
              .custombar("Login", loginData.message.toString(), true);
          storeData(loginData.result!.accessToken.toString(),loginData.result!.userDetails!.sfoxKey.toString());
        });

        if(loginData.result!.userDetails!.kycVerify!.toString()=="0")
          {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => KYCPage(),
              ),
            );
          }
        else if(loginData.result!.userDetails!.emailVerify!.toString()=="0")
          {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => LinkEmailAddress(

                ),
              ),
            );
          }
        else if(loginData.result!.userDetails!.smsVerify!.toString()=="0")
        {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => LinkMobileNo(

              ),
            ),
          );
        }
        else
          {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => Home(

                ),
              ),
            );

          }



        }
      else {
        setState(() {
          loading = false;
          CustomWidget(context: context)
              .custombar("Login", loginData.message.toString(), false);
        });
      }
    }).catchError((Object error) {
      print("Mano");
      print(error);
      setState(() {
        loading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      child: Scaffold(
        backgroundColor: AppColors.whiteColor,
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
                  CustomTheme.of(context).dialogBackgroundColor,
                ])),
            child: SingleChildScrollView(
              controller: controller,
              child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 20.0, right: 20.0, top: 50.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [

                        const SizedBox(
                          height: 50.0,
                        ),
                         Container(
                           width: MediaQuery.of(context).size.width,
                           child: Center(
                             child:  SvgPicture.asset(
                               'assets/icon/n_logo.svg',
                               height: MediaQuery.of(context).size.height * 0.2,
                               width: MediaQuery.of(context).size.width*0.7,
                             ),
                           ),
                         ),
                        const SizedBox(
                          height: 30.0,
                        ),
                        Text(
                          AppLocalizations.instance.text("loc_sign_in_text"),
                          style: CustomWidget(context: context)
                              .CustomSizedTextStyle(
                                  20.0,
                                  Theme.of(context).splashColor,
                                  FontWeight.w500,
                                  'FontRegular'),
                        ),
                        const SizedBox(
                          height: 30.0,
                        ),
                        // Row(
                        //   crossAxisAlignment: CrossAxisAlignment.center,
                        //   mainAxisAlignment: MainAxisAlignment.spaceAround,
                        //   children: [
                        //     InkWell(
                        //         onTap: () {
                        //           FocusScope.of(context).unfocus();
                        //           setState(() {
                        //             if (isMobile) {
                        //               isMobile = false;
                        //               isEmail = true;
                        //             }
                        //           });
                        //         },
                        //         child: Column(
                        //           children: [
                        //             Text(
                        //               AppLocalizations.instance
                        //                   .text("loc_email"),
                        //               style: CustomWidget(context: context)
                        //                   .CustomSizedTextStyle(
                        //                       16.0,
                        //                       Theme.of(context).splashColor,
                        //                       FontWeight.w500,
                        //                       'FontRegular'),
                        //             ),
                        //             const SizedBox(
                        //               height: 5.0,
                        //             ),
                        //             Container(
                        //               width: MediaQuery.of(context).size.width *
                        //                   0.25,
                        //               color: isEmail
                        //                   ? CustomTheme.of(context).shadowColor
                        //                   : CustomTheme.of(context)
                        //                       .primaryColor
                        //                       .withOpacity(0.1),
                        //               height: 2.0,
                        //             )
                        //           ],
                        //         )),
                        //     InkWell(
                        //         onTap: () {
                        //           FocusScope.of(context).unfocus();
                        //           setState(() {
                        //             if (!isMobile) {
                        //               isMobile = true;
                        //               isEmail = false;
                        //             }
                        //           });
                        //         },
                        //         child: Column(
                        //           children: [
                        //             Text(
                        //               AppLocalizations.instance
                        //                   .text("loc_mobile"),
                        //               style: CustomWidget(context: context)
                        //                   .CustomSizedTextStyle(
                        //                       16.0,
                        //                       Theme.of(context).splashColor,
                        //                       FontWeight.w500,
                        //                       'FontRegular'),
                        //             ),
                        //             const SizedBox(
                        //               height: 5.0,
                        //             ),
                        //             Container(
                        //               width: MediaQuery.of(context).size.width *
                        //                   0.25,
                        //               color: isMobile
                        //                   ? CustomTheme.of(context).shadowColor
                        //                   : CustomTheme.of(context)
                        //                       .primaryColor
                        //                       .withOpacity(0.1),
                        //               height: 2.0,
                        //             )
                        //           ],
                        //         )),
                        //   ],
                        // ),
                        // const SizedBox(
                        //   height: 20.0,
                        // ),
                        // isMobile ? mobileWidget() :
                        emailWidget(),
                        const SizedBox(
                          height: 5.0,
                        ),
                        ButtonCustom(
                            text: AppLocalizations.instance.text("loc_log_in"),
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
                            shadowColor: CustomTheme.of(context).shadowColor,
                            splashColor: CustomTheme.of(context).shadowColor,
                            onPressed: () {
                                setState(() {
                                  FocusScope.of(context).unfocus();
                                  if (email.text.isEmpty ||
                                      !RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                          .hasMatch(email.text)) {
                                    custombar(
                                        "Login", "Please Enter Email ", false);
                                  } else if (email_password.text.isEmpty) {
                                    custombar("Login", "Please Enter Password ",
                                        false);
                                  } else {
                                    loading = true;
                                    verifyMail();
                                  }
                                });

                            },
                            paddng: 1.0),
                        const SizedBox(
                          height: 20.0,
                        ),
                        InkWell(
                          onTap: () {

                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ForgotPassword(),
                                ));
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            child: Text(
                              AppLocalizations.instance
                                  .text("loc_forgot_password"),
                              style: CustomWidget(context: context)
                                  .CustomSizedTextStyle(
                                      16.0,
                                      Theme.of(context).shadowColor,
                                      FontWeight.normal,
                                      'FontRegular'),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20.0,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            InkWell(
                              onTap: () {
                                setState(() {});
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const RegisterScreen(),
                                    ));
                              },
                              child: RichText(
                                text: TextSpan(
                                  text: AppLocalizations.instance
                                      .text("loc_not_account"),
                                  style: CustomWidget(context: context)
                                      .CustomSizedTextStyle(
                                          16.0,
                                          Theme.of(context).splashColor,
                                          FontWeight.normal,
                                          'FontRegular'),
                                  children: <TextSpan>[
                                    TextSpan(
                                      text: "  ",
                                      style: CustomWidget(context: context)
                                          .CustomSizedTextStyle(
                                              16.0,
                                              Theme.of(context)
                                                  .splashColor
                                                  .withOpacity(0.5),
                                              FontWeight.normal,
                                              'FontRegular'),
                                    ),
                                    TextSpan(
                                      text: AppLocalizations.instance
                                          .text("loc_free_reg"),
                                      style: CustomWidget(context: context)
                                          .CustomSizedTextStyle(
                                              16.0,
                                              Theme.of(context).shadowColor,
                                              FontWeight.normal,
                                              'FontRegular'),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 20.0,
                        ),
                      ],
                    ),
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



  Widget emailWidget() {
    return Form(
      child: Column(
        children: [
          TextFormFieldCustom(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            onEditComplete: () {
              emailFocus.unfocus();
              FocusScope.of(context).requestFocus(emailPassFocus);
            },
            radius: 5.0,
            // inputFormatters: [
            //   FilteringTextInputFormatter.allow(RegExp(r'[A-Za-z@0-9!_.]')),
            // ],
            error: "Enter Valid Email",
            textColor: CustomTheme.of(context).splashColor,
            borderColor: CustomTheme.of(context).splashColor.withOpacity(0.5),
            fillColor: CustomTheme.of(context).backgroundColor.withOpacity(0.5),
            textInputAction: TextInputAction.next,
            focusNode: emailFocus,
            maxlines: 1,
            text: '',
            hintText: AppLocalizations.instance.text("loc_email"),
            obscureText: false,
            suffix: Container(
              padding: const EdgeInsets.all(15.0),
              child: SvgPicture.asset(
                'assets/icon/mail.svg',
                height: 15.0,
                width: 15.0,
                allowDrawingOutsideViewBox: true,
                color: CustomTheme.of(context).splashColor.withOpacity(0.5),
              ),
            ),
            textChanged: (value) {},
            onChanged: () {},
            validator: (value) {
              if (value!.isEmpty) {
                return "Please enter email";
              } else if (!RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                  .hasMatch(value)) {
                return "Please enter valid email";
              }

              return null;
            },
            enabled: true,
            textInputType: TextInputType.emailAddress,
            controller: email,
            hintStyle: CustomWidget(context: context).CustomTextStyle(
                Theme.of(context).splashColor.withOpacity(0.5),
                FontWeight.w300,
                'FontRegular'),
            textStyle: CustomWidget(context: context).CustomTextStyle(
                Theme.of(context).splashColor, FontWeight.w400, 'FontRegular'),
          ),
          const SizedBox(
            height: 20.0,
          ),
          TextFormFieldCustom(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            obscureText: !_passwordVisible,
            textInputAction: TextInputAction.done,
            hintStyle: CustomWidget(context: context).CustomTextStyle(
                Theme.of(context).splashColor.withOpacity(0.5),
                FontWeight.w300,
                'FontRegular'),
            // inputFormatters: [
            //   FilteringTextInputFormatter.allow(RegExp(r'[A-Za-z@#0-9!_.$]')),
            // ],
            textStyle: CustomWidget(context: context).CustomTextStyle(
                Theme.of(context).splashColor, FontWeight.w400, 'FontRegular'),
            radius: 5.0,
            focusNode: emailPassFocus,
            controller: email_password,
            enabled: true,
            textColor: CustomTheme.of(context).splashColor,
            borderColor: CustomTheme.of(context).splashColor.withOpacity(0.5),
            fillColor: CustomTheme.of(context).backgroundColor.withOpacity(0.5),
            onChanged: () {},
            hintText: AppLocalizations.instance.text("loc_password"),
            textChanged: (value) {},
            suffix: IconButton(
              icon: Icon(
                _passwordVisible ? Icons.visibility : Icons.visibility_off,
                color: CustomTheme.of(context).splashColor.withOpacity(0.5),
              ),
              onPressed: () {
                setState(() {
                  _passwordVisible = !_passwordVisible;
                });
              },
            ),
            validator: (value) {
              if (value!.isEmpty) {
                return "Please enter Password";
              }
             /* else if (!RegExp(
                      r"^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$")
                  .hasMatch(value)) {
                return "Please enter valid Password";
              } */
              else if (value.length < 8) {
                return "Please enter minimum 8 character Password";
              }
              return null;
            },
            maxlines: 1,
            error: "Enter Valid Password",
            text: "",
            onEditComplete: () {
              emailPassFocus.unfocus();
            },
            textInputType: TextInputType.visiblePassword,
          ),
          const SizedBox(
            height: 20.0,
          ),
          emailCodeVerify
              ? TextFormFieldCustom(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  onEditComplete: () {
                    emailVerifyFocus.unfocus();
                  },
                  radius: 5.0,
                  error: "Enter Valid Email",
                  textColor: AppColors.borderColor,
                  borderColor: AppColors.borderColor,
                  fillColor: AppColors.borderColor,
                  textInputAction: TextInputAction.next,
                  focusNode: emailVerifyFocus,
            // inputFormatters: [
            //   FilteringTextInputFormatter.allow(RegExp(r'[A-Za-z@0-9_.]')),
            // ],
                  maxlines: 1,
                  text: '',
                  hintText: AppLocalizations.instance.text("loc_email_code"),
                  obscureText: false,
                  suffix: Container(
                    width: 0.0,
                  ),
                  textChanged: (value) {},
                  onChanged: () {},
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Please enter Code";
                    }

                    return null;
                  },
                  enabled: emailCodeVerify,
                  textInputType: TextInputType.number,
                  controller: email_verify,
                  hintStyle: CustomWidget(context: context).CustomTextStyle(
                      Theme.of(context).splashColor.withOpacity(0.5),
                      FontWeight.w300,
                      'FontRegular'),
                  textStyle: CustomWidget(context: context).CustomTextStyle(
                      Theme.of(context).splashColor,
                      FontWeight.w400,
                      'FontRegular'),
                )
              : Container(),
          emailCodeVerify
              ? const SizedBox(
                  height: 30.0,
                )
              : Container(),
          emailAuth
              ? TextFormFieldCustom(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  onEditComplete: () {
                    emailAuthFocus.unfocus();
                  },
                  radius: 5.0,
                  // inputFormatters: [
                  //   FilteringTextInputFormatter.allow(RegExp(r'[A-Za-z@0-9_.]')),
                  // ],
                  error: "Enter Valid Email",
                  textColor: AppColors.borderColor,
                  borderColor: AppColors.borderColor,
                  fillColor: AppColors.borderColor,
                  textInputAction: TextInputAction.next,
                  focusNode: emailAuthFocus,
                  maxlines: 1,
                  text: '',
                  hintText: "Two Factor Code",
                  obscureText: false,
                  suffix: Container(
                    width: 0.0,
                  ),
                  textChanged: (value) {},
                  onChanged: () {},
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Please enter Code";
                    }

                    return null;
                  },
                  enabled: true,
                  textInputType: TextInputType.number,
                  controller: email_auth,
                  hintStyle: CustomWidget(context: context).CustomTextStyle(
                      Theme.of(context).splashColor.withOpacity(0.5),
                      FontWeight.w300,
                      'FontRegular'),
                  textStyle: CustomWidget(context: context).CustomTextStyle(
                      Theme.of(context).splashColor,
                      FontWeight.w400,
                      'FontRegular'),
                )
              : Container(),
          const SizedBox(
            height: 20.0,
          ),
        ],
      ),
      key: emailformKey,
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

  storeData(String token, String sfox) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString("token", token);
    preferences.setString("sfox", sfox);

  }
}
