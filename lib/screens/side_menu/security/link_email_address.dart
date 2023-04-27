import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:h2_crypto/data/api_utils.dart';
import 'package:h2_crypto/data/model/common_model.dart';

import '../../../common/colors.dart';
import '../../../common/custom_button.dart';
import '../../../common/custom_widget.dart';
import '../../../common/localization/localizations.dart';
import '../../../common/text_field_custom_prefix.dart';
import '../../../common/textformfield_custom.dart';
import '../../../common/theme/custom_theme.dart';

class LinkEmailAddress extends StatefulWidget {
  const LinkEmailAddress({Key? key}) : super(key: key);

  @override
  State<LinkEmailAddress> createState() => _ChangeEmailAddressState();
}

class _ChangeEmailAddressState extends State<LinkEmailAddress> {
  bool isEmail = true;
  bool mobileCodeVerify = false;
  bool loading = false;
  final emailformKey = GlobalKey<FormState>();

  FocusNode emailFocus = FocusNode();
  FocusNode emailPassFocus = FocusNode();
  FocusNode mobileVerifyFocus = FocusNode();
  TextEditingController email = TextEditingController();
  TextEditingController mobile_verify = TextEditingController();
  ScrollController controller = ScrollController();
  APIUtils apiUtils = APIUtils();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
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
              AppLocalizations.instance.text("loc_email_address"),
              style: CustomWidget(context: context).CustomSizedTextStyle(
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
              child: Stack(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
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
                      Form(
                        child: Container(
                          padding: EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
                          child: Column(
                            children: [
                              TextFormFieldCustom(
                                onEditComplete: () {
                                  emailFocus.unfocus();
                                  FocusScope.of(context)
                                      .requestFocus(emailPassFocus);
                                },
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(RegExp(r'[A-Za-z0-9@._]')),
                                ],
                                radius: 5.0,
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                error: "Enter Valid Email",
                                textColor: CustomTheme.of(context).splashColor,
                                borderColor: CustomTheme.of(context)
                                    .splashColor
                                    .withOpacity(0.5),
                                fillColor: CustomTheme.of(context)
                                    .backgroundColor
                                    .withOpacity(0.5),
                                textInputAction: TextInputAction.next,
                                focusNode: emailFocus,
                                maxlines: 1,
                                text: '',
                                hintText:
                                    AppLocalizations.instance.text("loc_email"),
                                obscureText: false,
                                suffix: Container(
                                  width: 0.0,
                                ),
                                textChanged: (value) {},
                                onChanged: () {},
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return "Please enter email";
                                  } else if (!RegExp(
                                          r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                      .hasMatch(value)) {
                                    return "Please enter valid email";
                                  }

                                  return null;
                                },
                                enabled: true,
                                textInputType: TextInputType.emailAddress,
                                controller: email,
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
                              Row(
                                children: [
                                  Flexible(
                                    child: TextFormCustom(
                                        onEditComplete: () {
                                          mobileVerifyFocus.unfocus();
                                        },
                                        autovalidateMode:
                                            AutovalidateMode.onUserInteraction,
                                        radius: 5.0,
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
                                        hintText: "New email Verification Code",
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
                                        hintStyle:
                                            CustomWidget(context: context)
                                                .CustomTextStyle(
                                                    Theme.of(context)
                                                        .splashColor
                                                        .withOpacity(0.5),
                                                    FontWeight.w300,
                                                    'FontRegular'),
                                        textStyle: CustomWidget(
                                                context: context)
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

                                        if (mobileCodeVerify) {
                                        } else {
                                          if (emailformKey.currentState!
                                              .validate()) {
                                            setState(() {
                                              loading = true;
                                              sentOtp(true);
                                            });
                                          }
                                        }
                                      });
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: CustomTheme.of(context)
                                              .buttonColor,
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

                                    if (emailformKey.currentState!.validate()) {
                                      if (mobile_verify.text.isNotEmpty) {
                                        setState(() {
                                          loading = true;
                                          verifyEmail();
                                        });
                                      } else {
                                        CustomWidget(context: context)
                                            .custombar(
                                                "verify Email",
                                                "Enter Email Verification Code",
                                                false);
                                      }
                                    }
                                  },
                                  paddng: 0.0),
                              const SizedBox(
                                height: 15.0,
                              ),
                            ],
                          ),
                        ),
                        key: emailformKey,
                      )
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

  sentOtp(bool emailMob) {
    apiUtils
        .updateEmailDetails(email.text.toString(), false, emailMob)
        .then((CommonModel loginData) {
      if (loginData.status.toString() == "200") {
        setState(() {
          loading = false;
          mobileCodeVerify = true;
          CustomWidget(context: context)
              .custombar("Security", loginData.message.toString(), true);
        });
      } else {
        setState(() {
          loading = false;
          CustomWidget(context: context)
              .custombar("Security", loginData.message.toString(), false);
        });
      }
    }).catchError((Object error) {
      setState(() {
        loading = false;
      });
    });
  }

  verifyEmail() {
    apiUtils
        .updateEmailDetails(mobile_verify.text.toString(), true, false)
        .then((CommonModel loginData) {
      if (loginData.status.toString() == "200") {
        setState(() {
          loading = false;
          CustomWidget(context: context)
              .custombar("Security", loginData.message.toString(), true);

          Navigator.pop(context, true);
        });
      } else {
        setState(() {
          loading = false;
          CustomWidget(context: context)
              .custombar("Security", loginData.message.toString(), false);
        });
      }
    }).catchError((Object error) {
      setState(() {
        loading = false;
      });
    });
  }
}
