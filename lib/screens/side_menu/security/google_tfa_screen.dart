import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:h2_crypto/common/custom_widget.dart';
import 'package:h2_crypto/common/localization/localizations.dart';
import 'package:h2_crypto/common/theme/custom_theme.dart';
import 'package:h2_crypto/data/api_utils.dart';
import 'package:h2_crypto/data/model/google_enable_tfa_model.dart';
import 'package:h2_crypto/data/model/google_tfa_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GoogleTFAScreen extends StatefulWidget {
  final String username;

  const GoogleTFAScreen({
    Key? key,
    required this.username,
  }) : super(key: key);

  @override
  State<GoogleTFAScreen> createState() => _GoogleTFAScreenState();
}

class _GoogleTFAScreenState extends State<GoogleTFAScreen> {
  APIUtils apiUtils = APIUtils();
  String appName = "Ciftag";
  Googletfa? details;
  String qrCode = "";
  String qrImage = "";
  bool status = false;
  TextEditingController code = TextEditingController();
  GlobalKey globalKeyauth = GlobalKey(debugLabel: 'auth');
  FocusNode codeFocus = FocusNode();
  bool loading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    loading = true;
    getUserDetails();
  }

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
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                CustomTheme.of(context).primaryColor,
                CustomTheme.of(context).backgroundColor,
              ],
            )),
            child: Stack(
              children: [
                loading
                    ? CustomWidget(context: context).loadingIndicator(
                        Theme.of(context).splashColor,
                      )
                    : SingleChildScrollView(
                        child: Padding(
                          padding:
                              const EdgeInsets.only(left: 15.0, right: 15.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(
                                height: 10.0,
                              ),
                              !status
                                  ? Column(
                                      children: [
                                        const SizedBox(
                                          height: 20.0,
                                        ),
                                        qrImage == ""
                                            ? Container()
                                            : Container(
                                                padding:
                                                    const EdgeInsets.all(5.0),
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.3,
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.15,
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                5.0)),
                                                    color: Theme.of(context).splashColor,
                                                    border: Border.all(
                                                        width: 0.2,
                                                        color: Colors.white)),
                                                child: Image.network(qrImage),
                                              ),
                                        const SizedBox(
                                          height: 10.0,
                                        ),
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Expanded(
                                              child: Text(
                                                qrCode,
                                                style: CustomWidget(
                                                        context: context)
                                                    .CustomTextStyle(
                                                        Theme.of(context)
                                                            .splashColor,
                                                        FontWeight.w500,
                                                        'FontRegular'),
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 5.0,
                                            ),
                                            IconButton(
                                              onPressed: () {
                                                Clipboard.setData(ClipboardData(
                                                    text: qrCode.toString()));
                                                CustomWidget(context: context)
                                                    .custombar(
                                                        "Google TFA",
                                                        "Secret Key Copied to Clipboard...!",
                                                        true);
                                              },
                                              icon: Icon(
                                                Icons.copy,
                                                color: Theme.of(context)
                                                    .buttonColor,
                                                size: 25.0,
                                              ),
                                            )
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 20.0,
                                        ),
                                        TextFormField(
                                            textAlign: TextAlign.start,
                                            keyboardType: TextInputType.number,
                                            controller: code,
                                            textInputAction:
                                                TextInputAction.done,
                                            focusNode: codeFocus,
                                            style:
                                                CustomWidget(context: context)
                                                    .CustomTextStyle(
                                                        Theme.of(context)
                                                            .splashColor,
                                                        FontWeight.w500,
                                                        'FontRegular'),
                                            decoration: InputDecoration(
                                              labelText: "Google Code",
                                              errorStyle: TextStyle(
                                                  color: Colors.redAccent),
                                              labelStyle: TextStyle(
                                                  fontSize: 14,
                                                  color: Color(0xFF999999)),
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                                borderSide: BorderSide(
                                                  width: 0,
                                                  color: Color(0xFF999999),
                                                ),
                                              ),
                                              disabledBorder:
                                                  OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                                borderSide: BorderSide(
                                                  width: 1.5,
                                                  color: Color(0xFF999999),
                                                ),
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                                borderSide: BorderSide(
                                                  width: 0,
                                                  color: Color(0xFF999999),
                                                ),
                                              ),
                                              errorBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                                borderSide: BorderSide(
                                                  width: 1,
                                                  color: Colors.red,
                                                ),
                                              ),
                                              filled: false,
                                              isDense: true,
                                              contentPadding:
                                                  new EdgeInsets.symmetric(
                                                      vertical: 10.0,
                                                      horizontal: 10.0),
                                              fillColor: Color(0xFFe6e6e6),
                                            ),
                                            onFieldSubmitted: (term) {
                                              codeFocus.unfocus();
                                            },
                                            validator: (value) {
                                              if (value!.isEmpty) {
                                                return "Please enter ifsc code";
                                              }
                                              return null;
                                            }),
                                        const SizedBox(
                                          height: 30,
                                        ),
                                      ],
                                    )
                                  : Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const SizedBox(
                                          height: 60.0,
                                        ),
                                        TextFormField(
                                            textAlign: TextAlign.start,
                                            keyboardType: TextInputType.number,
                                            controller: code,
                                            textInputAction:
                                                TextInputAction.done,
                                            focusNode: codeFocus,
                                            style:
                                                CustomWidget(context: context)
                                                    .CustomTextStyle(
                                                        Theme.of(context)
                                                            .splashColor,
                                                        FontWeight.w500,
                                                        'FontRegular'),
                                            decoration: InputDecoration(
                                              labelText: "Google Code",
                                              errorStyle: TextStyle(
                                                  color: Colors.redAccent),
                                              labelStyle: TextStyle(
                                                  fontSize: 14,
                                                  color: Color(0xFF999999)),
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                                borderSide: BorderSide(
                                                  width: 0,
                                                  color: Color(0xFF999999),
                                                ),
                                              ),
                                              disabledBorder:
                                                  OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                                borderSide: BorderSide(
                                                  width: 1.5,
                                                  color: Color(0xFF999999),
                                                ),
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                                borderSide: BorderSide(
                                                  width: 0,
                                                  color: Color(0xFF999999),
                                                ),
                                              ),
                                              errorBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                                borderSide: BorderSide(
                                                  width: 1,
                                                  color: Colors.red,
                                                ),
                                              ),
                                              filled: false,
                                              isDense: true,
                                              contentPadding:
                                                  new EdgeInsets.symmetric(
                                                      vertical: 10.0,
                                                      horizontal: 10.0),
                                              fillColor: Color(0xFFe6e6e6),
                                            ),
                                            onFieldSubmitted: (term) {
                                              codeFocus.unfocus();
                                            },
                                            validator: (value) {
                                              if (value!.isEmpty) {
                                                return "Please enter ifsc code";
                                              }
                                              return null;
                                            }),
                                        const SizedBox(
                                          height: 30,
                                        ),
                                      ],
                                    ),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    print("Hai");
                                    if (code.text.isEmpty) {
                                      CustomWidget(context: context).custombar(
                                          "Google Authenticator",
                                          "Enter Goolge Auth Code",
                                          false);
                                    } else {
                                      print(status);
                                      if (!status) {
                                        loading = true;
                                        enableGoogleauth(false);
                                      } else {
                                        loading = true;
                                        enableGoogleauth(true);
                                      }
                                    }
                                  });
                                },
                                child: Container(
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).buttonColor,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(5.0)),
                                    ),
                                    padding: const EdgeInsets.only(
                                        top: 13.0, bottom: 13.0),
                                    child: Center(
                                      child: Text(
                                        !status ? "Enable" : "Disable ",
                                        style: CustomWidget(context: context)
                                            .CustomTextStyle(
                                                Theme.of(context).splashColor,
                                                FontWeight.w500,
                                                'FontRegular'),
                                      ),
                                    )),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Note :".toUpperCase(),
                                      style: CustomWidget(context: context)
                                          .CustomSizedTextStyle(
                                          14.0,
                                          Theme.of(context)
                                              .scaffoldBackgroundColor,
                                          FontWeight.w600,
                                          'FontRegular'),
                                    ),
                                    SizedBox(height: 5.0,),
                                    Text(
                                      "Keep the secret key at safe place, it allows you to recover your 2FA code if it's lost",
                                      style: CustomWidget(context: context)
                                          .CustomSizedTextStyle(
                                          13.0,
                                          Theme.of(context)
                                              .splashColor,
                                          FontWeight.normal,
                                          'FontRegular'),
                                      textAlign: TextAlign.start,
                                    )
                                  ],
                                ),
                              ),
                              const SizedBox(
                                height: 5.0,
                              ),
                            ],
                          ),
                        ),
                      ),
              ],
            ),
          ),
        ),
        onWillPop: () async {
          print("Asdf");
          Navigator.of(context).pop(true);
          setState(() {
            loading = false;
          });
          return false;
        },
      ),
    );
  }

  getUserDetails() {
    apiUtils.getGoogleTFADetails().then((GoogletfaModel loginData) {
      if (loginData.statusCode.toString() == "200") {
        setState(() {
          loading = false;
          status = false;

          details = loginData.data;
          qrCode = details!.hash.toString();

          qrImage =
              "https://chart.googleapis.com/chart?chs=200x200&chld=M|0&cht=qr&chl=otpauth://totp/$appName-${widget.username}?secret=$qrCode&issuer=$appName";
        });
      } else if (loginData.statusCode == 1000) {
        setState(() {
          loading = false;
          status = true;
        });
      } else {
        setState(() {
          loading = false;
          //  status = false;
        });
      }
    }).catchError((Object error) {
      print(error);
      loading = false;
    });
  }

  enableGoogleauth(bool statusAuth) {
    apiUtils
        .enableGoogleTFA(code.text.toString(), statusAuth)
        .then((GoogleEnabletfaModel loginData) {
      setState(() {
        if (loginData.statusCode == 200) {
          code.clear();
          loading = false;
          status = loginData.data!.verified!;
          storeData(status);

          CustomWidget(context: context)
              .custombar("Google TFA", loginData.message.toString(), true);

          // loading = true;

          Navigator.pop(context, true);

          getUserDetails();
        } else {
          loading = false;
          CustomWidget(context: context)
              .custombar("Google TFA", loginData.message.toString(), false);
        }
      });
    }).catchError((Object error) {
      loading = false;
    });
  }

  storeData(bool google) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setBool("tfa", google);
  }
}
