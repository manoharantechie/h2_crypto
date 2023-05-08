import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:h2_crypto/common/localization/localizations.dart';
import 'package:h2_crypto/common/theme/custom_theme.dart';
import 'package:h2_crypto/common/theme/themes.dart';
import 'package:h2_crypto/data/api_utils.dart';
import 'package:h2_crypto/screens/basic/login.dart';

import 'package:shared_preferences/shared_preferences.dart';

import '../../common/custom_widget.dart';
import '../side_menu/security/change_password.dart';
import '../side_menu/security/kyc_info.dart';

class SideMenu extends StatefulWidget {
  const SideMenu({Key? key}) : super(key: key);

  @override
  State<SideMenu> createState() => _SideMenuState();
}

class _SideMenuState extends State<SideMenu> {
  bool theme = false;
  bool kycUpdate=false;
  APIUtils apiUtils = APIUtils();
  String name = "";
  String uid = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getDetails();
  }

  void _changeTheme(BuildContext buildContext, MyThemeKeys key) {
    CustomTheme.instanceOf(buildContext).changeTheme(key);
  }

  getDetails() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    setState(() {
      String themeType = preferences.getString('theme').toString();
      name = preferences.getString("name").toString() == "null" ||
              preferences.getString("name").toString() == null
          ? "Set Name"
          : preferences.getString("name").toString();
      uid = preferences.getString("uid").toString();

      if (themeType == null || themeType == "null") {
        CustomTheme.instanceOf(context).changeTheme(MyThemeKeys.DARK);
        theme = true;
      } else if (themeType == "light") {
        CustomTheme.instanceOf(context).changeTheme(MyThemeKeys.LIGHT);
        theme = false;
      } else {
        CustomTheme.instanceOf(context).changeTheme(MyThemeKeys.DARK);
        theme = true;
      }
    });
  }

  _getRequests() async {
    setState(() {
      getDetails();
    });
  }

  StoreData(String themeData) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString("theme", themeData);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              CustomTheme.of(context).accentColor,
            ])),
        child: Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.25,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        child: SvgPicture.asset(
                          'assets/others/close.svg',
                          color: CustomTheme.of(context).splashColor,
                          height: 20.0,
                        ),
                        onTap: () {
                          Navigator.pop(context);
                        },
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            if (theme) {
                              _changeTheme(context, MyThemeKeys.LIGHT);
                              StoreData("light");
                              theme = false;
                            } else {
                              _changeTheme(context, MyThemeKeys.DARK);
                              StoreData("dark");
                              theme = true;
                            }
                          });
                        },
                        child: SvgPicture.asset(
                          'assets/others/sun.svg',
                          color: CustomTheme.of(context).splashColor,
                          height: 20.0,
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 15.0,
                  ),
                  Container(
                    padding: const EdgeInsets.only(
                        left: 10.0, right: 10.0, top: 20.0, bottom: 20.0),
                    decoration: BoxDecoration(
                        color: CustomTheme.of(context)
                            .buttonColor
                            .withOpacity(0.3),
                        borderRadius: BorderRadius.circular(10.0)),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              name,
                              style: CustomWidget(context: context)
                                  .CustomSizedTextStyle(
                                      16.0,
                                      Theme.of(context).splashColor,
                                      FontWeight.w500,
                                      'FontRegular'),
                            ),

                          ],
                        ),
                        const SizedBox(
                          height: 10.0,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "UID: " + uid,
                              style: CustomWidget(context: context)
                                  .CustomSizedTextStyle(
                                      12.0,
                                      Theme.of(context)
                                          .splashColor
                                          .withOpacity(0.5),
                                      FontWeight.w400,
                                      'FontRegular'),
                            ),
                            const SizedBox(
                              width: 10.0,
                            ),
                            InkWell(
                              onTap: (){
                                Clipboard.setData(ClipboardData(text: uid));
                                CustomWidget(context: context).custombar(
                                    "H2Crypto", "UID was Copied", true);
                              },
                              child: SvgPicture.asset(
                                'assets/others/copy.svg',
                                height: 15.0,
                              ),
                            ),

                          ],
                        ),
                        const SizedBox(
                          height: 20.0,
                        ),
                        // Container(
                        //   padding: const EdgeInsets.only(left: 15.0,right: 15.0,top: 12.0,bottom: 12.0),
                        //
                        //   decoration: BoxDecoration(
                        //       color: CustomTheme.of(context).buttonColor.withOpacity(0.5),
                        //       borderRadius: BorderRadius.circular(30.0)
                        //
                        //   ),
                        //   child: Row(
                        //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //     children: [
                        //       Row(
                        //         children: [   SvgPicture.asset('assets/others/vip.svg'),
                        //           const SizedBox(width: 10.0,),
                        //           Text(
                        //             AppLocalizations.instance.text('loc_apply_vip'),
                        //             style: GoogleFonts.habibi(
                        //                 fontSize: 13.0,
                        //                 fontWeight: FontWeight.w500,
                        //                 color: CustomTheme.of(context).splashColor),
                        //           ),],
                        //       ),
                        //       Text(
                        //         AppLocalizations.instance.text('loc_enjoy_more'),
                        //         style: GoogleFonts.habibi(
                        //             fontSize: 11.0,
                        //             fontWeight: FontWeight.w500,
                        //             color: CustomTheme.of(context).splashColor),
                        //       )
                        //
                        //     ],
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                  //  const SizedBox(height: 20.0,),
                ],
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height * 0.64,
              margin: EdgeInsets.only(top: 20.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
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
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              SvgPicture.asset(
                                'assets/sidemenu/security.svg',
                                height: 20.0,
                              ),
                              const SizedBox(
                                width: 10.0,
                              ),
                              Text(
                                AppLocalizations.instance.text("loc_kyc"),
                                style: CustomWidget(context: context)
                                    .CustomSizedTextStyle(
                                    16.0,
                                    Theme.of(context).splashColor,
                                    FontWeight.normal,
                                    'FontRegular'),
                              ),
                            ],
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
                      )
                    ),
                    const SizedBox(
                      height: 20.0,
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
                          Row(
                            children: [
                              SvgPicture.asset(
                                'assets/sidemenu/settings.svg',
                                height: 20.0,
                              ),
                              const SizedBox(
                                width: 10.0,
                              ),
                              Text(
                                AppLocalizations.instance.text("loc_change_password"),
                                style: CustomWidget(context: context)
                                    .CustomSizedTextStyle(
                                    16.0,
                                    Theme.of(context).splashColor,
                                    FontWeight.normal,
                                    'FontRegular'),
                              ),
                            ],
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
                      height: 20.0,
                    ),

                    Container(
                      height: 0.7,
                      width: MediaQuery.of(context).size.width,
                      color: CustomTheme.of(context).buttonColor,
                    ),

                    const SizedBox(
                      height: 20.0,
                    ),


                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            SvgPicture.asset(
                              'assets/sidemenu/help.svg',
                              height: 20.0,
                            ),
                            const SizedBox(
                              width: 10.0,
                            ),
                            Text(
                              AppLocalizations.instance.text("loc_help"),
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
                    const SizedBox(
                      height: 20.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            SvgPicture.asset(
                              'assets/sidemenu/support.svg',
                              height: 20.0,
                            ),
                            const SizedBox(
                              width: 10.0,
                            ),
                            Text(
                              AppLocalizations.instance.text("loc_cu_support"),
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
                    const SizedBox(
                      height: 20.0,
                    ),
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //   children: [
                    //     Row(
                    //       children: [
                    //
                    //         SvgPicture.asset('assets/sidemenu/product.svg',height: 20.0,),
                    //         const SizedBox(width: 10.0,),
                    //         Text(
                    //           AppLocalizations.instance.text("loc_pro_sug"),
                    //           style: GoogleFonts.habibi(
                    //               fontSize: 16.0,
                    //               color: CustomTheme.of(context).splashColor),
                    //         ),
                    //       ],
                    //     ),
                    //     SvgPicture.asset('assets/sidemenu/arrow.svg',color: CustomTheme.of(context).splashColor,height: 20.0,),
                    //   ],
                    // ),
                    // const SizedBox(height: 20.0,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            SvgPicture.asset(
                              'assets/sidemenu/about.svg',
                              height: 20.0,
                            ),
                            const SizedBox(
                              width: 10.0,
                            ),
                            Text(
                              AppLocalizations.instance.text("loc_about"),
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
                    const SizedBox(
                      height: 20.0,
                    ),
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //   children: [
                    //     Row(
                    //       children: [
                    //
                    //         SvgPicture.asset('assets/sidemenu/chain.svg',height: 20.0,),
                    //         const SizedBox(width: 10.0,),
                    //         Text(
                    //           AppLocalizations.instance.text("loc_chain"),
                    //           style: GoogleFonts.habibi(
                    //               fontSize: 16.0,
                    //               color: CustomTheme.of(context).splashColor),
                    //         ),
                    //       ],
                    //     ),
                    //     SvgPicture.asset('assets/sidemenu/arrow.svg',color: CustomTheme.of(context).splashColor,height: 20.0,),
                    //   ],
                    // ),
                    //
                    // const SizedBox(height: 20.0,),
                    InkWell(
                      onTap: () {
                        showSuccessAlertDialog(
                            "Logout", "Are you sure want to Logout ?");
                      },
                      child: Container(
                          padding: const EdgeInsets.only(
                              left: 15.0, right: 15.0, top: 10.0, bottom: 10.0),
                          decoration: BoxDecoration(
                              color: CustomTheme.of(context)
                                  .buttonColor
                                  .withOpacity(0.5),
                              borderRadius: BorderRadius.circular(10.0)),
                          child: Center(
                            child: Text(
                              AppLocalizations.instance.text('loc_logout'),
                              style: CustomWidget(context: context)
                                  .CustomTextStyle(
                                      Theme.of(context).splashColor,
                                      FontWeight.w500,
                                      'FontRegular'),
                            ),
                          )),
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
      ),
    );
  }

  showSuccessAlertDialog(String title, String message) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0)), //this right here
            child: Container(
              decoration: new BoxDecoration(
                  color: CustomTheme.of(context).splashColor,
                  borderRadius: BorderRadius.circular(5.0)),
              height: MediaQuery.of(context).size.height * 0.30,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      title.toUpperCase(),
                      style: CustomWidget(context: context)
                          .CustomSizedTextStyle(
                              16.0,
                              Theme.of(context).buttonColor,
                              FontWeight.bold,
                              'FontRegular'),
                    ),
                    Container(
                        margin: EdgeInsets.only(top: 7.0, bottom: 10.0),
                        height: 2.0,
                        color: CustomTheme.of(context).buttonColor),
                    Text(
                      message,
                      style: CustomWidget(context: context)
                          .CustomSizedTextStyle(
                              16.0,
                              Theme.of(context).buttonColor,
                              FontWeight.w500,
                              'FontRegular'),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Row(
                      children: [
                        SizedBox(
                          child: InkWell(
                            child: Container(
                              width: 100,
                              height: 40,
                              margin: const EdgeInsets.fromLTRB(
                                  10.0, 10.0, 10.0, 0.0),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                    colors: [
                                      CustomTheme.of(context).buttonColor,
                                      CustomTheme.of(context).buttonColor
                                    ],
                                    begin: Alignment.topRight,
                                    end: Alignment.bottomLeft,
                                    stops: [0.0, 1.0],
                                    tileMode: TileMode.clamp),
                                borderRadius: BorderRadius.circular(25),
                              ),
                              child: Align(
                                alignment: Alignment.center,
                                child: Text(
                                  "ok".toUpperCase(),
                                  style: CustomWidget(context: context)
                                      .CustomSizedTextStyle(
                                          16.0,
                                          Theme.of(context).splashColor,
                                          FontWeight.w500,
                                          'FontRegular'),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                            onTap: () {
                              callLogout();
                              Navigator.of(context).pop(true);
                            },
                          ),
                        ),
                        SizedBox(
                          child: InkWell(
                            child: Container(
                              width: 100,
                              height: 40,
                              margin: const EdgeInsets.fromLTRB(
                                  10.0, 10.0, 10.0, 0.0),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                    colors: [
                                      CustomTheme.of(context).buttonColor,
                                      CustomTheme.of(context).buttonColor,
                                    ],
                                    begin: Alignment.topRight,
                                    end: Alignment.bottomLeft,
                                    stops: [0.0, 1.0],
                                    tileMode: TileMode.clamp),
                                borderRadius: BorderRadius.circular(25),
                              ),
                              child: Align(
                                alignment: Alignment.center,
                                child: Text(
                                  "Cancel".toUpperCase(),
                                  style: CustomWidget(context: context)
                                      .CustomSizedTextStyle(
                                          16.0,
                                          Theme.of(context).splashColor,
                                          FontWeight.w500,
                                          'FontRegular'),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                            onTap: () {
                              Navigator.of(context).pop(true);
                            },
                          ),
                        )
                      ],
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                    )
                  ],
                ),
              ),
            ),
          );
        });
    // show the dialog
  }

  Future callLogout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        // TODO:SET MYMAP
        builder: (BuildContext context) => LoginScreen(),
      ),
      (Route route) => false,
    );
  }
}
