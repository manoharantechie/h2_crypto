import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:h2_crypto/common/colors.dart';
import 'package:h2_crypto/common/custom_button.dart';
import 'package:h2_crypto/common/custom_widget.dart';
import 'package:h2_crypto/common/localization/localizations.dart';
import 'package:h2_crypto/common/theme/custom_theme.dart';
import 'package:h2_crypto/data/api_utils.dart';
import 'package:h2_crypto/data/model/common_model.dart';
import 'package:h2_crypto/screens/basic/home.dart';


class GoogleLogin extends StatefulWidget {
  const GoogleLogin({Key? key}) : super(key: key);

  @override
  State<GoogleLogin> createState() => _GoogleLoginState();
}

class _GoogleLoginState extends State<GoogleLogin> {
  APIUtils apiUtils=APIUtils();

  bool loading=false;
  final mobileformKey = GlobalKey<FormState>();
  TextEditingController code = TextEditingController();
  GlobalKey globalKeyauth = GlobalKey(debugLabel: 'auth');
  FocusNode codeFocus = FocusNode();

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      child: WillPopScope(
        child: Scaffold(
          appBar: AppBar(
              backgroundColor: CustomTheme.of(context).primaryColor,
              elevation: 0.0,
              centerTitle: true,
              title: Text(
                AppLocalizations.instance.text("loc_google_auth"),
                style: CustomWidget(context: context).CustomSizedTextStyle(17.0,
                    Theme.of(context).splashColor, FontWeight.w500, 'FontRegular'),
              ),
              // leading: InkWell(
              //   onTap: () {
              //     Navigator.pop(context);
              //   },
              //   child: Container(
              //     padding: EdgeInsets.only(left: 16.0, right: 16.0),
              //     child: SvgPicture.asset(
              //       'assets/others/arrow_left.svg',
              //     ),
              //   ),
              // )
          ),

          body: Container(
              height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      // Add one stop for each color
                      // Values should increase from 0.0 to 1.0
                      stops: [0.1, 0.5, 0.9,],
                      colors: [CustomTheme.of(context).primaryColor,CustomTheme.of(context).backgroundColor, CustomTheme.of(context).accentColor,])),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                  child:  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(
                        height: 10.0,
                      ),
                      const SizedBox(
                        height: 40.0,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextFormField(
                              textAlign: TextAlign.center,
                              keyboardType: TextInputType.number,
                              controller: code,
                              textInputAction: TextInputAction.done,
                              focusNode: codeFocus,
                              style:

                              CustomWidget(context: context)
                                  .CustomTextStyle(
                                  Theme.of(context).splashColor,
                                  FontWeight.w500,
                                  'FontRegular'),

                              decoration: InputDecoration(
                                labelText: "Google Code",
                                errorStyle: TextStyle(color: Colors.redAccent),
                                labelStyle: TextStyle(fontSize: 14, color: Color(0xFF999999)),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(5.0)
                                  ),
                                  borderSide: BorderSide(
                                      color: CustomTheme.of(context)
                                          .splashColor
                                          .withOpacity(0.5),
                                      width: 1.0),
                                ),
                                disabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(5.0)
                                  ),
                                  borderSide: BorderSide(
                                      color: CustomTheme.of(context)
                                          .splashColor
                                          .withOpacity(0.5),
                                      width: 1.0),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(5.0)
                                  ),
                                  borderSide: BorderSide(
                                      color: CustomTheme.of(context)
                                          .splashColor
                                          .withOpacity(0.5),
                                      width: 1.0),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(5.0)
                                  ),
                                  borderSide: BorderSide(
                                      color: CustomTheme.of(context)
                                          .splashColor
                                          .withOpacity(0.5),
                                      width: 1.0),
                                ),
                                filled: true,
                                fillColor: CustomTheme.of(context)
                                    .backgroundColor
                                    .withOpacity(0.5),
                                isDense: true,
                                contentPadding: new EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                              ),
                              onFieldSubmitted: (term) {
                                codeFocus.unfocus();
                              },
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "Please enter google code";
                                }
                                return null;
                              }),
                          const SizedBox(
                            height: 30,
                          ),
                        ],
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

                            if (code.text.isNotEmpty) {
                              setState(() {
                                loading = true;
                                verifyCode();
                              });

                            }
                            else{
                              CustomWidget(context: context).  custombar("Google Authenticator", "Enter  Verification Code", false);

                            }
                          },
                          paddng: 0.0),
                      const SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                ),
              )),
        ),
        onWillPop: () async {
          setState(() {});
          return false;
        },
      ),
    );
  }

  verifyCode() {
    apiUtils.verifyGoogleTFA(code.text.toString()).then((CommonModel loginData) {
      setState(() {
        code.clear();

        if (loginData.status==200) {
          CustomWidget(context: context).  custombar("Login", loginData.message.toString(), true);


          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => Home(

              ),
            ),
          );
        }
        else {

            loading = false;
            CustomWidget(context: context).  custombar("Login", loginData.message.toString(), false);

        }
      });
    }).catchError((Object error) {});
  }
}
