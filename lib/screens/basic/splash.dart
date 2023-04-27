import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:h2_crypto/common/localization/localizations.dart';
import 'package:h2_crypto/common/theme/custom_theme.dart';
import 'package:h2_crypto/common/theme/themes.dart';
import 'package:h2_crypto/data/api_utils.dart';
import 'package:h2_crypto/data/model/refresh_token_model.dart';
import 'package:h2_crypto/screens/basic/google_login.dart';
import 'package:h2_crypto/screens/basic/home.dart';
import 'package:h2_crypto/screens/basic/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  String user = "";
  String themeType = "";
  int expTime = 0;
  String exp = "";
  bool loggedIn = false;
  bool gooleAuth = false;

  APIUtils apiUtils = APIUtils();

  @override
  void initState() {
    super.initState();
   getDetails();
    onLocaleChange();

    expTime = DateTime.now().millisecondsSinceEpoch;
  }

  getDetails() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    setState(() {
     preferences.clear();
      user = preferences.getString('token').toString();
      themeType = preferences.getString('theme').toString();
      exp = preferences.getString('exp').toString();
      gooleAuth = preferences.getBool('tfa').toString() == null ||
              preferences.getBool('tfa').toString() == "null"
          ? false
          : preferences.getBool('tfa')!;

      if (user == null || user == "null") {
        loggedIn = false;
      } else {
        loggedIn = true;
      }
      if (themeType == null || themeType == "null") {
        CustomTheme.instanceOf(context).changeTheme(MyThemeKeys.DARK);
      } else if (themeType == "dark") {
        CustomTheme.instanceOf(context).changeTheme(MyThemeKeys.DARK);
      } else {
        CustomTheme.instanceOf(context).changeTheme(MyThemeKeys.LIGHT);
      }

      onLoad();
      // if (exp == null || exp == "null") {
      //   onLoad();
      // } else {
      //   if (expTime != int.parse(exp)) {
      //     getRefresh();
      //   } else {
      //     onLoad();
      //   }
      // }
    });
  }

  onLoad() {
    if (loggedIn) {
      if (gooleAuth) {
        Future.delayed(const Duration(seconds: 5), () {
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => GoogleLogin()));
        });
      } else {
        Future.delayed(const Duration(seconds: 5), () {
          Navigator.of(context)
              .pushReplacement(MaterialPageRoute(builder: (context) => Home()));
        });
      }
    } else {
      Future.delayed(const Duration(seconds: 5), () {
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => LoginScreen()));
      });
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  void onLocaleChange() async {
    setState(() {
      const AppLocalizationsDelegate().load(const Locale('en'));
    });
  }

  // getRefresh() {
  //   apiUtils.getRefreshToken().then((RefreshTokenModel loginData) {
  //     if (loginData.statusCode.toString() == "200") {
  //       setState(() {
  //         storeData(loginData.data!.accessToken!.token.toString(),
  //             loginData.data!.accessToken!.exp.toString());
  //         onLoad();
  //       });
  //     } else {
  //       setState(() {});
  //     }
  //   }).catchError((Object error) {
  //     print("Mano");
  //     print(error);
  //     setState(() {});
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
        data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
        child: Scaffold(
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
            child: Center(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(
                  height: 10.0,
                ),
                Image.asset(
                  'assets/icon/logo.png',
                  height: MediaQuery.of(context).size.height * 0.15,
                  width: MediaQuery.of(context).size.width*0.7,
                ),
                const SizedBox(
                  height: 20.0,
                ),
              ],
            )),
          ),
        ));
  }

  storeData(String token, String userID) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString("token", token);
    preferences.setString("exp", userID);
  }
}
