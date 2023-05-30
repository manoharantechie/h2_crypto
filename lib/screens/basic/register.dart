import 'dart:io';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:country_calling_code_picker/functions.dart';
import 'package:country_calling_code_picker/picker.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
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
import 'package:h2_crypto/screens/others/terms_Screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool loading = false;
  bool _MobilepasswordVisible = false;
  bool _EmailpasswordVisible = false;
  bool _EmailConfpasswordVisible = false;
  Country? _selectedCountry;

  var deviceData;
  TextEditingController email = TextEditingController();
  TextEditingController firstname_email = TextEditingController();
  TextEditingController lastname_email = TextEditingController();
  TextEditingController email_password = TextEditingController();
  TextEditingController email_confi_password = TextEditingController();
  TextEditingController email_verify = TextEditingController();
  TextEditingController email_refer = TextEditingController();
  FocusNode emailFocus = FocusNode();
  FocusNode emailFirstFocus = FocusNode();
  FocusNode emailLastFocus = FocusNode();
  FocusNode emailPassFocus = FocusNode();
  FocusNode emailConfPassFocus = FocusNode();
  FocusNode emailVerifyFocus = FocusNode();

  ScrollController controller = ScrollController();
  bool countryB = false;
  bool isMobile = false;
  bool isEmail = true;
  bool emailVerify = true;
  bool emailCodeVerify = false;
  bool emailPassVerify = false;
  bool emailReferVerify = false;
  final emailformKey = GlobalKey<FormState>();
  final mobileformKey = GlobalKey<FormState>();
  bool check = false;

  var snackBar;

  bool mobileVerify = true;
  bool mobileCodeVerify = false;
  bool mobilePassVerify = true;

  bool mobileReferVerify = false;
  String token = "";
  APIUtils apiUtils = APIUtils();

  @override
  void initState() {
    initCountry();
    getDeviceInfo();
    super.initState();
  }

  void initCountry() async {
    final country = await getDefaultCountry(context);
    setState(() {
      _selectedCountry = country;
      countryB = true;
    });
  }
  getDeviceInfo() async {
    DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      deviceData = _readAndroidBuildData(await deviceInfoPlugin.androidInfo);


    } else if (Platform.isIOS) {
      deviceData = _readIosDeviceInfo(await deviceInfoPlugin.iosInfo);

    }
  }

  Map<String, dynamic> _readAndroidBuildData(AndroidDeviceInfo build) {
    return <String, dynamic>{
      'os_version': build.version.release,
      'device_model': build.model,
      'device_id': build.id,
      'deviceos_type': 'android',
    };
  }

  Map<String, dynamic> _readIosDeviceInfo(IosDeviceInfo data) {
    return <String, dynamic>{
      'os_version': data.systemName! + " " + data.systemVersion!,
      'device_model': data.name,
      'deviceos_type': data.systemName,
      'device_id': data.identifierForVendor
    };
  }

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
                        left: 20.0, right: 20.0, top: 40.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
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
                                  .CustomTextStyle(
                                      Theme.of(context).splashColor,
                                      FontWeight.w400,
                                      'FontRegular'),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 35.0,
                        ),
                        Text(
                          AppLocalizations.instance.text("loc_sign_up_text"),
                          style: CustomWidget(context: context)
                              .CustomSizedTextStyle(
                                  25.0,
                                  Theme.of(context).splashColor,
                                  FontWeight.w500,
                                  'FontRegular'),
                        ),
                        const SizedBox(
                          height: 10.0,
                        ),
                        Text(
                          AppLocalizations.instance.text("loc_sign_up_content"),
                          style: CustomWidget(context: context)
                              .CustomSizedTextStyle(
                                  16.0,
                                  Theme.of(context).splashColor,
                                  FontWeight.w500,
                                  'FontRegular'),
                        ),
                        const SizedBox(
                          height: 40.0,
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
                        //               mobile.clear();
                        //               mobile_password.clear();
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
                        //                       18.0,
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
                        //               email.clear();
                        //               email_password.clear();
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
                        //                       18.0,
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
                          height: 30.0,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                                margin:
                                    EdgeInsets.only(left: 00.0, bottom: 00.0),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: check
                                        ? Theme.of(context).splashColor
                                        : Theme.of(context).splashColor,
                                  ),
                                ),
                                child: Checkbox(
                                    activeColor: Theme.of(context).primaryColor,
                                    value: check,
                                    onChanged: (newValue) {
                                      setState(() {
                                        check = newValue!;
                                      });
                                    }),
                                width: 20,
                                height: 20),
                            Padding(
                              padding:
                                  EdgeInsets.only(left: 10.0, bottom: 10.0),
                              child: RichText(
                                text: TextSpan(
                                  text: 'Accept and Continue ',
                                  style: TextStyle(
                                    color: Theme.of(context).splashColor,
                                  ),
                                  children: <TextSpan>[
                                    TextSpan(
                                      text: AppLocalizations.instance
                                          .text("loc_policy"),
                                      recognizer: TapGestureRecognizer()..onTap = () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>  TermsCondition(
                                                title: false, content: false,
                                              ),
                                            ));
                                      },
                                      style: TextStyle(
                                          color: Theme.of(context).shadowColor,
                                          fontWeight: FontWeight.w400),
                                    ),
                                    TextSpan(
                                      text: "\n"+AppLocalizations.instance
                                          .text("loc_terms"),
                                      recognizer: TapGestureRecognizer()..onTap = () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>  TermsCondition(
                                                title: true, content: true,
                                              ),
                                            ));
                                      },
                                      style: TextStyle(
                                          color: Theme.of(context).shadowColor,
                                          fontWeight: FontWeight.w400),
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
                        ButtonCustom(
                            text: AppLocalizations.instance.text("loc_sign_up"),
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

                                  if (check) {
                                    loading = true;

                                    registerMail();}


                                  else {
                                    custombar("Register",
                                        "Accept Terms and Condition", false);
                                  }

                              });
                            },
                            paddng: 1.0),
                        const SizedBox(
                          height: 20.0,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            InkWell(
                              onTap: () {
                                setState(() {
                                  Navigator.of(context).pushReplacement(
                                      MaterialPageRoute(builder: (context) => LoginScreen()));
                                });
                              },
                              child: RichText(
                                text: TextSpan(
                                  text: AppLocalizations.instance
                                      .text("loc_all_account"),
                                  style: CustomWidget(context: context)
                                      .CustomSizedTextStyle(
                                          16.0,
                                          Theme.of(context).splashColor,
                                          FontWeight.w500,
                                          'FontRegular'),
                                  children: <TextSpan>[
                                    // TextSpan(
                                    //   text: "  ",
                                    //   style: CustomWidget(context: context)
                                    //       .CustomSizedTextStyle(
                                    //       16.0,
                                    //       Theme.of(context).splashColor.withOpacity(0.5),
                                    //       FontWeight.normal,
                                    //       'FontRegular'),
                                    // ),
                                    TextSpan(
                                      text: AppLocalizations.instance
                                          .text("loc_log_in"),
                                      style: CustomWidget(context: context)
                                          .CustomSizedTextStyle(
                                              16.0,
                                              Theme.of(context).shadowColor,
                                              FontWeight.w500,
                                              'FontRegular'),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 60.0,
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 30.0,
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
            obscureText: false,
            textInputAction: TextInputAction.next,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            hintStyle: CustomWidget(context: context)
                .CustomTextStyle(
                Theme.of(context).splashColor.withOpacity(0.5),
                FontWeight.w300,
                'FontRegular'),
            radius: 5.0,
            focusNode: emailFirstFocus,
            controller: firstname_email,
            // inputFormatters: [
            //   FilteringTextInputFormatter.allow(RegExp(r'[A-Za-z]')),
            // ],
            enabled: true,
            borderColor: CustomTheme.of(context).splashColor.withOpacity(0.5),
            fillColor: CustomTheme.of(context).backgroundColor.withOpacity(0.5),
            onChanged: () {},
            hintText: "Firstname",
            textChanged: (value) {},
            suffix: Container(width: 0.0,),
            validator: (value) {
              if (value!.isEmpty) {
                return "Please enter Firstname";
              }

              return null;
            },
            textStyle:CustomWidget(context: context)
                .CustomTextStyle(
                Theme.of(context).splashColor,
                FontWeight.w400,
                'FontRegular'),
            maxlines: 1,
            error: "Enter Valid Username",
            text: "",
            onEditComplete: () {
              emailFirstFocus.unfocus();
              FocusScope.of(context).requestFocus(emailLastFocus);
            },
            textColor: AppColors.blackColor,
            textInputType: TextInputType.visiblePassword,
          ),
          const SizedBox(
            height: 20.0,
          ),
          TextFormFieldCustom(
            obscureText: false,
            textInputAction: TextInputAction.next,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            hintStyle: CustomWidget(context: context)
                .CustomTextStyle(
                Theme.of(context).splashColor.withOpacity(0.5),
                FontWeight.w300,
                'FontRegular'),
            radius: 5.0,
            focusNode: emailLastFocus,
            controller: lastname_email,
            // inputFormatters: [
            //   FilteringTextInputFormatter.allow(RegExp(r'[A-Za-z]')),
            // ],
            enabled: true,
            borderColor: CustomTheme.of(context).splashColor.withOpacity(0.5),
            fillColor: CustomTheme.of(context).backgroundColor.withOpacity(0.5),
            onChanged: () {},
            hintText: "Lastname",
            textChanged: (value) {},
            suffix: Container(width: 0.0,),
            validator: (value) {
              if (value!.isEmpty) {
                return "Please enter Lastname";
              }

              return null;
            },
            textStyle:CustomWidget(context: context)
                .CustomTextStyle(
                Theme.of(context).splashColor,
                FontWeight.w400,
                'FontRegular'),
            maxlines: 1,
            error: "Enter Valid Username",
            text: "",
            onEditComplete: () {
              emailLastFocus.unfocus();
              FocusScope.of(context).requestFocus(emailFocus);
            },
            textColor: AppColors.blackColor,
            textInputType: TextInputType.visiblePassword,
          ),
          const SizedBox(
            height: 20.0,
          ),
          TextFormFieldCustom(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            onEditComplete: () {
              emailFocus.unfocus();
              FocusScope.of(context).requestFocus(emailPassFocus);
            },
            radius: 5.0,
            error: "Enter Valid Email",
            textColor: CustomTheme.of(context).splashColor,
            borderColor: CustomTheme.of(context).splashColor.withOpacity(0.5),
            fillColor: CustomTheme.of(context).backgroundColor.withOpacity(0.5),
            textInputAction: TextInputAction.next,
            focusNode: emailFocus,
            // inputFormatters: [
            //   FilteringTextInputFormatter.allow(RegExp(r'[A-Za-z@0-9_.]')),
            // ],
            maxlines: 1,
            text: '',
            hintText: "Please enter email",
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
            }
            ,
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
            obscureText: !_EmailpasswordVisible,
            textInputAction: TextInputAction.next,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            hintStyle: CustomWidget(context: context)
                .CustomTextStyle(
                Theme.of(context).splashColor.withOpacity(0.5),
                FontWeight.w300,
                'FontRegular'),
            textStyle:CustomWidget(context: context)
                .CustomTextStyle(
                Theme.of(context).splashColor,
                FontWeight.w400,
                'FontRegular'),
            // inputFormatters: [
            //   FilteringTextInputFormatter.allow(RegExp(r'[A-Za-z@#0-9!_]')),
            // ],
            radius: 5.0,
            focusNode: emailPassFocus,
            controller: email_password,
            enabled: true,
            textColor: CustomTheme.of(context).splashColor,
            borderColor: CustomTheme.of(context).splashColor.withOpacity(0.5),
            fillColor:  CustomTheme.of(context)
                .backgroundColor
                .withOpacity(0.5),
            onChanged: () {},
            hintText: AppLocalizations.instance.text("loc_password"),
            textChanged: (value) {},
            suffix: IconButton(
              icon: Icon(
                _EmailpasswordVisible ? Icons.visibility : Icons.visibility_off,
                color:  CustomTheme.of(context).splashColor.withOpacity(0.5),
              ),
              onPressed: () {
                setState(() {
                  _EmailpasswordVisible = !_EmailpasswordVisible;
                });
              },
            ),
            validator: (value) {
              if (value!.isEmpty) {
                return "Please enter Password";
              }
              else if (!RegExp(r"^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$")
                  .hasMatch(value)) {
                return "Please enter valid Password";
              }
              else if(value.length<8){
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
          TextFormFieldCustom(
            obscureText: !_EmailConfpasswordVisible,
            textInputAction: TextInputAction.next,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            hintStyle: CustomWidget(context: context)
                .CustomTextStyle(
                Theme.of(context).splashColor.withOpacity(0.5),
                FontWeight.w300,
                'FontRegular'),
            textStyle:CustomWidget(context: context)
                .CustomTextStyle(
                Theme.of(context).splashColor,
                FontWeight.w400,
                'FontRegular'),
            // inputFormatters: [
            //   FilteringTextInputFormatter.allow(RegExp(r'[A-Za-z@#0-9!_]')),
            // ],
            radius: 5.0,
            focusNode: emailConfPassFocus,
            controller: email_confi_password,
            enabled: true,
            textColor: CustomTheme.of(context).splashColor,
            borderColor: CustomTheme.of(context).splashColor.withOpacity(0.5),
            fillColor:  CustomTheme.of(context)
                .backgroundColor
                .withOpacity(0.5),
            onChanged: () {},
            hintText:"Confirm Password",
            textChanged: (value) {},
            suffix: IconButton(
              icon: Icon(
                _EmailConfpasswordVisible ? Icons.visibility : Icons.visibility_off,
                color:  CustomTheme.of(context).splashColor.withOpacity(0.5),
              ),
              onPressed: () {
                setState(() {
                  _EmailConfpasswordVisible = !_EmailConfpasswordVisible;
                });
              },
            ),
            validator: (value) {
              if (value!.isEmpty) {
                return "Please enter Confirm Password";
              }
              else if (!RegExp(r"^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$")
                  .hasMatch(value)) {
                return "Please enter valid Confirm Password";
              }
              else if(value.length<8){
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



          Container(
            padding: EdgeInsets.symmetric(horizontal: 10.0),
            width: MediaQuery.of(context).size.width,
            child:  Text(
              "Note:".toUpperCase(),
              textAlign: TextAlign.start,
              overflow: TextOverflow.visible,
              style: CustomWidget(context: context)
                  .CustomSizedTextStyle(
                  14.0,
                 Colors.red,
                  FontWeight.w500,
                  'FontRegular'),
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
              style: CustomWidget(context: context)
                  .CustomSizedTextStyle(
                  12.0,
                  Theme.of(context).splashColor.withOpacity(0.5),
                  FontWeight.w500,
                  'FontRegular'),
            ),
          ),
          const SizedBox(
            height: 10.0,
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


  registerMail() {
    apiUtils
        .doVerifyRegister(
      firstname_email.text.toString(),
            lastname_email.text.toString(),
            email.text.toString(),deviceData['device_id'].toString(),"", email_password.text.toString(),email_confi_password.text.toString())
        .then((CommonModel loginData) {
      if (loginData.status!) {
        setState(() {
          loading = false;
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) =>  LoginScreen()));
        });
        custombar("Register", loginData.message.toString(), true);

        // storeData(loginData.userId.toString(),loginData.username.toString());
        // Navigator.of(context).pushReplacement(
        //     MaterialPageRoute(builder: (context) =>  HomeScreen(login: true,index: 0,)));
      } else {
        setState(() {
          loading = false;
          custombar("Register", loginData.message.toString(), false);
        });
      }
    }).catchError((Object error) {
      print(error);
      setState(() {
        loading = false;
      });
    });
  }



  storeData(String userid, String email) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString("user_id", userid);
    preferences.setString("uemail", email);
  }
}
