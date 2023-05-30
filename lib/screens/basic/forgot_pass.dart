import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:country_calling_code_picker/picker.dart';
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
import 'package:h2_crypto/data/crypt_model/common_model.dart';

import 'package:h2_crypto/screens/basic/login.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({Key? key}) : super(key: key);

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  bool loading = false;
  bool _passwordVisible = false;
  bool _confirmpasswordVisible = false;
  Country? _selectedCountry;
  TextEditingController mobile = TextEditingController();

  TextEditingController mobile_verify = TextEditingController();
  TextEditingController mobile_refer = TextEditingController();
  FocusNode mobileFocus = FocusNode();
  FocusNode mobilePassFocus = FocusNode();
  FocusNode mobileVerifyFocus = FocusNode();
  FocusNode mobileReferFocus = FocusNode();
  TextEditingController email = TextEditingController();
  TextEditingController email_password = TextEditingController();
  TextEditingController email_confirm_password = TextEditingController();
  TextEditingController email_verify = TextEditingController();
  TextEditingController email_refer = TextEditingController();
  FocusNode emailFocus = FocusNode();
  FocusNode emailPassFocus = FocusNode();
  FocusNode confirmemailPassFocus = FocusNode();
  FocusNode emailVerifyFocus = FocusNode();
  FocusNode emailreferFocus = FocusNode();
  ScrollController controller = ScrollController();
  bool countryB = false;
  bool isMobile = false;
  bool isDisplay = true;
  bool isEmail = true;
  bool emailVerify = true;
  bool emailCodeVerify = false;
  bool emailPassVerify = false;
  bool emailReferVerify = false;
  final emailformKey = GlobalKey<FormState>();
  final mobileformKey = GlobalKey<FormState>();
  final verifyformKey = GlobalKey<FormState>();
  bool check = false;

  bool getCode = true;

  String token = "";
  var snackBar;

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

  custombar(String title, String message, bool status) {
    snackBar = SnackBar(
      width: MediaQuery.of(context).size.width,
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
                  Theme.of(context).dialogBackgroundColor,
                ])),
            child: SingleChildScrollView(
              controller: controller,
              child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 20.0, right: 20.0, top: 50.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            SvgPicture.asset(
                              'assets/icon/language.svg',
                              height: 20.0,
                              color: CustomTheme.of(context).splashColor,
                            ),
                            const SizedBox(
                              width: 10.0,
                            ),
                            Text(
                              "English",
                              style: CustomWidget(context: context)
                                  .CustomSizedTextStyle(
                                      16.0,
                                      Theme.of(context).splashColor,
                                      FontWeight.w400,
                                      'FontRegular'),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 50.0,
                        ),
                        Text(
                            AppLocalizations.instance
                                .text("loc_forgot_password"),
                            style: CustomWidget(context: context)
                                .CustomSizedTextStyle(
                                    20.0,
                                    Theme.of(context).splashColor,
                                    FontWeight.w500,
                                    'FontRegular')),
                        const SizedBox(
                          height: 30.0,
                        ),
                        Visibility(
                          visible: isDisplay,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              InkWell(
                                  onTap: () {
                                    FocusScope.of(context).unfocus();
                                    setState(() {
                                      if (isMobile) {
                                        isMobile = false;
                                        isEmail = true;
                                      }
                                    });
                                  },
                                  child: Column(
                                    children: [
                                      Text(
                                          AppLocalizations.instance
                                              .text("loc_email"),
                                          style: CustomWidget(context: context)
                                              .CustomSizedTextStyle(
                                                  16.0,
                                                  Theme.of(context).splashColor,
                                                  FontWeight.w500,
                                                  'FontRegular')),
                                      const SizedBox(
                                        height: 5.0,
                                      ),
                                      Container(
                                        width: MediaQuery.of(context).size.width *
                                            0.25,
                                        color: isEmail
                                            ? CustomTheme.of(context).shadowColor
                                            : CustomTheme.of(context)
                                                .primaryColor
                                                .withOpacity(0.1),
                                        height: 2.0,
                                      )
                                    ],
                                  )),
                              InkWell(
                                  onTap: () {
                                    FocusScope.of(context).unfocus();
                                    setState(() {
                                      if (!isMobile) {
                                        isMobile = true;
                                        isEmail = false;
                                      }
                                    });
                                  },
                                  child: Column(
                                    children: [
                                      Text(
                                          AppLocalizations.instance
                                              .text("loc_mobile"),
                                          style: CustomWidget(context: context)
                                              .CustomSizedTextStyle(
                                                  16.0,
                                                  Theme.of(context).splashColor,
                                                  FontWeight.w500,
                                                  'FontRegular')),
                                      const SizedBox(
                                        height: 5.0,
                                      ),
                                      Container(
                                        width: MediaQuery.of(context).size.width *
                                            0.25,
                                        color: isMobile
                                            ? CustomTheme.of(context).shadowColor
                                            : CustomTheme.of(context)
                                                .primaryColor
                                                .withOpacity(0.1),
                                        height: 2.0,
                                      )
                                    ],
                                  )),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 20.0,
                        ),
                        !getCode
                            ? Container()
                            : isMobile
                                ? mobileWidget()
                                : emailWidget(),
                        getCode
                            ? Container()
                            : Form(
                                key: verifyformKey,
                                child: Column(children: [
                                  TextFormFieldCustom(
                                    onEditComplete: () {
                                      mobileVerifyFocus.unfocus();
                                    },
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return "Please enter Code";
                                      }

                                      return null;
                                    },
                                    radius: 5.0,
                                    autovalidateMode: AutovalidateMode.onUserInteraction,
                                    // inputFormatters: [
                                    //   FilteringTextInputFormatter.allow(RegExp(r'[A-Za-z0-9@.]')),
                                    // ],
                                    error: "Enter Valid Email",
                                    textColor: AppColors.appColor,
                                    borderColor: CustomTheme.of(context)
                                        .splashColor
                                        .withOpacity(0.5),
                                    fillColor: CustomTheme.of(context)
                                        .backgroundColor
                                        .withOpacity(0.5),
                                    textInputAction: TextInputAction.next,
                                    focusNode: mobileVerifyFocus,
                                    maxlines: 1,
                                    text: '',
                                    hintText: "Enter Verification Code",
                                    obscureText: false,
                                    suffix: Container(
                                      width: 0.0,
                                    ),
                                    textChanged: (value) {},
                                    onChanged: () {},
                                    enabled: true,
                                    textInputType: TextInputType.number,
                                    controller: mobile_verify,
                                    hintStyle: CustomWidget(context: context)
                                        .CustomTextStyle(
                                            Theme.of(context)
                                                .splashColor
                                                .withOpacity(0.5),
                                            FontWeight.w300,
                                            'FontRegular'),
                                    textStyle: CustomWidget(context: context)
                                        .CustomTextStyle(
                                            Theme.of(context).splashColor,
                                            FontWeight.w400,
                                            'FontRegular'),
                                  ),
                                  const SizedBox(
                                    height: 20.0,
                                  ),
                                  TextFormFieldCustom(
                                    obscureText: !_passwordVisible,
                                    textInputAction: TextInputAction.done,
                                    autovalidateMode: AutovalidateMode.onUserInteraction,
                                    // inputFormatters: [
                                    //   FilteringTextInputFormatter.allow(RegExp(r'[A-Za-z@#0-9!_]')),
                                    // ],
                                    hintStyle: CustomWidget(context: context)
                                        .CustomTextStyle(
                                            Theme.of(context)
                                                .splashColor
                                                .withOpacity(0.5),
                                            FontWeight.w300,
                                            'FontRegular'),
                                    textStyle: CustomWidget(context: context)
                                        .CustomTextStyle(
                                            Theme.of(context).splashColor,
                                            FontWeight.w400,
                                            'FontRegular'),
                                    radius: 5.0,
                                    focusNode: emailPassFocus,
                                    controller: email_password,
                                    enabled: true,
                                    textColor:
                                        CustomTheme.of(context).splashColor,
                                    borderColor: CustomTheme.of(context)
                                        .splashColor
                                        .withOpacity(0.5),
                                    fillColor: CustomTheme.of(context)
                                        .backgroundColor
                                        .withOpacity(0.5),
                                    onChanged: () {},
                                    hintText: AppLocalizations.instance
                                        .text("loc_new_password"),
                                    textChanged: (value) {},
                                    suffix: IconButton(
                                      icon: Icon(
                                        _passwordVisible
                                            ? Icons.visibility
                                            : Icons.visibility_off,
                                        color: CustomTheme.of(context)
                                            .splashColor
                                            .withOpacity(0.5),
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
                                      else if(value.length<8){
                                        return "Please enter Valid  Password";
                                      }

                                      return null;
                                    },
                                    maxlines: 1,
                                    error: "Enter Valid Password",
                                    text: "",
                                    onEditComplete: () {
                                      emailPassFocus.unfocus();
                                    },
                                    textInputType:
                                        TextInputType.visiblePassword,
                                  ),
                                  const SizedBox(
                                    height: 20.0,
                                  ),
                                  TextFormFieldCustom(
                                    obscureText: !_confirmpasswordVisible,
                                    textInputAction: TextInputAction.done,
                                    // inputFormatters: [
                                    //   FilteringTextInputFormatter.allow(RegExp(r'[A-Za-z@#0-9!_]')),
                                    // ],
                                    autovalidateMode: AutovalidateMode.onUserInteraction,
                                    hintStyle: CustomWidget(context: context)
                                        .CustomTextStyle(
                                            Theme.of(context)
                                                .splashColor
                                                .withOpacity(0.5),
                                            FontWeight.w300,
                                            'FontRegular'),
                                    textStyle: CustomWidget(context: context)
                                        .CustomTextStyle(
                                            Theme.of(context).splashColor,
                                            FontWeight.w400,
                                            'FontRegular'),
                                    radius: 5.0,
                                    focusNode: confirmemailPassFocus,
                                    controller: email_confirm_password,
                                    enabled: true,
                                    textColor:
                                        CustomTheme.of(context).splashColor,
                                    borderColor: CustomTheme.of(context)
                                        .splashColor
                                        .withOpacity(0.5),
                                    fillColor: CustomTheme.of(context)
                                        .backgroundColor
                                        .withOpacity(0.5),
                                    onChanged: () {},
                                    hintText: AppLocalizations.instance
                                        .text("loc_confirm_password"),
                                    textChanged: (value) {},
                                    suffix: IconButton(
                                      icon: Icon(
                                        _confirmpasswordVisible
                                            ? Icons.visibility
                                            : Icons.visibility_off,
                                        color: CustomTheme.of(context)
                                            .splashColor
                                            .withOpacity(0.5),
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          _confirmpasswordVisible =
                                              !_confirmpasswordVisible;
                                        });
                                      },
                                    ),
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return "Please enter Confirm Password";
                                      }
                                      return null;
                                    },
                                    maxlines: 1,
                                    error: "Enter Valid Password",
                                    text: "",
                                    onEditComplete: () {
                                      confirmemailPassFocus.unfocus();
                                    },
                                    textInputType:
                                        TextInputType.visiblePassword,
                                  ),
                                  const SizedBox(
                                    height: 20.0,
                                  ),

                                  Container(
                                    padding: EdgeInsets.symmetric(horizontal: 10.0),
                                    width: MediaQuery.of(context).size.width,
                                    child:  Text(
                                      "Note:".toUpperCase(),
                                      textAlign: TextAlign.start,
                                      overflow: TextOverflow.visible,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.redAccent,
                                          fontFamily: 'BALLOBHAI-REGULAR',
                                          fontSize: 12.0),
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  Container(
                                    padding: EdgeInsets.symmetric(horizontal: 10.0),
                                    width: MediaQuery.of(context).size.width,
                                    child:  Text(
                                      "To make your password more secure: (Minimum 8 characters,Use numbers,Use uppercase,Use lowercase and Use special characters)",
                                      textAlign: TextAlign.start,
                                      overflow: TextOverflow.visible,
                                      style: TextStyle(
                                          fontWeight: FontWeight.normal,
                                          color: Colors.white,
                                          fontFamily: 'BALLOBHAI-REGULAR',
                                          fontSize: 11.0),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 20.0,
                                  ),
                                ]),
                              ),
                        const SizedBox(
                          height: 20.0,
                        ),

                        ButtonCustom(
                            text: getCode ? "Send Code" : "Verify Code",
                            iconEnable: false,
                            radius: 5.0,
                            icon: "",
                            textStyle: CustomWidget(context: context)
                                .CustomSizedTextStyle(
                                    18.0,
                                    Theme.of(context).splashColor,
                                    FontWeight.w500,
                                    'FontRegular'),
                            iconColor: CustomTheme.of(context).shadowColor,
                            buttonColor: CustomTheme.of(context).shadowColor,
                            splashColor: CustomTheme.of(context).shadowColor,
                            onPressed: () {
                              setState(() {
                                FocusScope.of(context).unfocus();
                                if (getCode) {
                                  if (isEmail) {
                                    if(email.text.isEmpty  || !RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                        .hasMatch(email.text))                         {
                                      custombar("Forgot", "Please Enter Email",
                                          false);
                                    }
                                    else{
                                        loading = true;
                                        sendCodeMail();
                                    }

                                  } else {
                                    if(mobile.text.isEmpty)
                                    {
                                      custombar("Forgot", "Please Enter Mobile Number",
                                          false);
                                    }
                                    else {
                                      setState(() {

                                      });
                                    }
                                  }
                                } else {
                                  if (verifyformKey.currentState!.validate()) {
                                    if (email_password.text.toString() ==
                                        email_confirm_password.text
                                            .toString()) {
                                      if (isEmail) {
                                        setState(() {

                                        });
                                      } else {
                                        setState(() {

                                        });
                                      }
                                    } else {
                                      custombar(
                                          "Forgot Password",
                                          "Password and confirm password do not match",
                                          false);
                                    }
                                  }
                                }
                              });
                            },
                            paddng: 1.0),
                        const SizedBox(
                          height: 20.0,
                        ),
                        InkWell(
                          onTap: () {
                            setState(() {
                              Navigator.pop(context);
                            });
                          },
                          child: Text(
                            "Cancel",
                            textAlign: TextAlign.center,
                            style: CustomWidget(context: context)
                                .CustomSizedTextStyle(
                                16.0,
                                Theme.of(context).splashColor,
                                FontWeight.normal,
                                'FontRegular'),

                          ),
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

  Widget mobileWidget() {
    return Form(
      child: Column(
        children: [
          Row(
            children: [
              Container(
                  padding: const EdgeInsets.only(
                      left: 10.0, right: 10.0, top: 14.0, bottom: 14.0),
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: CustomTheme.of(context)
                            .splashColor
                            .withOpacity(0.5),
                        width: 1.0),
                    color: CustomTheme.of(context)
                        .backgroundColor
                        .withOpacity(0.5),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(5.0),
                      bottomLeft: Radius.circular(5.0),
                    ),
                  ),
                  child: Row(
                    children: [
                      InkWell(
                        onTap: _onPressedShowBottomSheet,
                        child: Row(
                          children: [
                            Text(
                              countryB
                                  ? _selectedCountry!.callingCode.toString()
                                  : "+1",
                              style: CustomWidget(context: context)
                                  .CustomTextStyle(
                                      Theme.of(context).splashColor,
                                      FontWeight.normal,
                                      'FontRegular'),
                            ),
                            const SizedBox(
                              width: 3.0,
                            ),
                            const Icon(
                              Icons.keyboard_arrow_down_outlined,
                              size: 15.0,
                              color: AppColors.backgroundColor,
                            )
                          ],
                        ),
                      ),
                      const SizedBox(
                        width: 10.0,
                      ),
                    ],
                  )),
              Flexible(
                child: TextFormField(
                  controller: mobile,
                  focusNode: mobileFocus,
                  maxLines: 1,
                  enabled: mobileVerify,
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.number,
                  style: CustomWidget(context: context).CustomTextStyle(
                      Theme.of(context).splashColor,
                      FontWeight.w400,
                      'FontRegular'),
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.only(
                        left: 12, right: 0, top: 2, bottom: 2),
                    hintText: "Please enter Mobile",
                    hintStyle: CustomWidget(context: context).CustomTextStyle(
                        Theme.of(context).splashColor.withOpacity(0.5),
                        FontWeight.w300,
                        'FontRegular'),
                    filled: true,
                    fillColor: CustomTheme.of(context)
                        .backgroundColor
                        .withOpacity(0.5),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(5.0),
                        bottomRight: Radius.circular(5.0),
                      ),
                      borderSide: BorderSide(
                          color: CustomTheme.of(context)
                              .splashColor
                              .withOpacity(0.5),
                          width: 1.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(5.0),
                        bottomRight: Radius.circular(5.0),
                      ),
                      borderSide: BorderSide(
                          color: CustomTheme.of(context)
                              .splashColor
                              .withOpacity(0.5),
                          width: 1.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(5.0),
                        bottomRight: Radius.circular(5.0),
                      ),
                      borderSide: BorderSide(
                          color: CustomTheme.of(context)
                              .splashColor
                              .withOpacity(0.5),
                          width: 1.0),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(5.0),
                        bottomRight: Radius.circular(5.0),
                      ),
                      borderSide: BorderSide(
                          color: CustomTheme.of(context)
                              .splashColor
                              .withOpacity(0.5),
                          width: 1.0),
                    ),
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
      key: mobileformKey,
    );
  }

  Widget emailWidget() {
    return Form(
      child: Column(
        children: [
          TextFormFieldCustom(
            onEditComplete: () {
              emailFocus.unfocus();
              FocusScope.of(context).requestFocus(emailPassFocus);
            },
            autovalidateMode: AutovalidateMode.onUserInteraction,
            radius: 5.0,
            error: "Enter Valid Email",
            textColor: CustomTheme.of(context).splashColor,
            borderColor: CustomTheme.of(context).splashColor.withOpacity(0.5),
            fillColor: CustomTheme.of(context).backgroundColor.withOpacity(0.5),
            textInputAction: TextInputAction.next,
            focusNode: emailFocus,
            maxlines: 1,
            text: '',
            hintText: AppLocalizations.instance.text("loc_email"),
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

  sendCodeMail() {
    apiUtils
        .forgotPassword(email.text.toString())
        .then((CommonModel loginData) {
      if (loginData.status!) {
        setState(() {
          loading = false;
          getCode = false;
          isDisplay=false;
        });
        custombar("Forgot Password", loginData.message.toString(), true);
      } else {
        setState(() {
          print("jeeva");
          loading = false;
          custombar("Forgot Password", loginData.message.toString(), false);
        });
      }
    }).catchError((Object error) {
      print(error);
      setState(() {
        loading = false;
      });
    });
  }



  verifyMail() {
    apiUtils
        .doVerifyOTP(email.text.toString(),mobile_verify.text.toString(),email_password.text.toString(),email_confirm_password.text.toString())
        .then((CommonModel loginData) {
      if (loginData.status!) {
        setState(() {
          loading = false;
          emailVerify = true;

          email.clear();
          mobile_verify.clear();
          email_verify.clear();
          email_confirm_password.clear();

          mobileCodeVerify = true;
        });
        custombar("Register", loginData.message.toString(), true);

      } else {
        setState(() {
          loading = false;
          custombar("Register", loginData.message.toString(), false);
        });
      }
    }).catchError((Object error) {
      setState(() {
        loading = false;
      });
    });
  }

// verifyMobile() {
//   print(mobile_verify.text);
//   apiUtils
//       .doVerifyOTP(APIUtils.verifyMobileOtpURL,_selectedCountry!.callingCode.toString()+ mobile.text.toString(),
//       mobile_verify.text.toString(), false)
//       .then((SentOtpModel loginData) {
//     if (loginData.status.toString() == "Success") {
//       setState(() {
//         loading = false;
//         emailVerify = true;
//         emailCodeVerify = false;
//         emailPassVerify = false;
//         emailReferVerify = false;
//         email.clear();
//         email_password.clear();
//         email_verify.clear();
//         email_refer.clear();
//
//         mobileCodeVerify = true;
//       });
//       custombar("Register", loginData.message.toString(), true);
//     } else {
//       setState(() {
//         loading = false;
//         custombar("Register", loginData.message.toString(), false);
//       });
//     }
//   }).catchError((Object error) {
//     setState(() {
//       loading = false;
//     });
//   });
// }

}
