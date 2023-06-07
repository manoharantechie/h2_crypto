
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:h2_crypto/common/theme/custom_theme.dart';
import 'package:h2_crypto/data/api_utils.dart';

class NotifyScreen extends StatefulWidget {
  const NotifyScreen({Key? key}) : super(key: key);

  @override
  State<NotifyScreen> createState() => _NotifyScreenState();
}

class _NotifyScreenState extends State<NotifyScreen> {
  APIUtils apiUtils = APIUtils();
  bool loading = false;
  ScrollController controller = ScrollController();

  String kycStatus = "";
  String TfaStatus = "";
  int start = 0;
  int limit = 15;

  bool nextSearch = true;



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //loading = true;
 //   getDetails();
  }
  @override
  Widget build(BuildContext context) {
    return MediaQuery(data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0), child: Scaffold(
      appBar: AppBar(
        backgroundColor: CustomTheme.of(context).primaryColor,
        elevation: 0.0,
        leading: Container(
            padding: const EdgeInsets.all(16.0),
            child: InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: SvgPicture.asset(
                'assets/others/arrow_left.svg',
                height: 10.0,
                width: 10.0,
                color: CustomTheme.of(context).splashColor,
                allowDrawingOutsideViewBox: true,
              ),
            )),
        centerTitle: true,
        title: Text(
          "Notification",
          style: TextStyle(
            fontFamily: 'FontSpecial',
            color: CustomTheme.of(context).splashColor,
            fontWeight: FontWeight.w500,
            fontSize: 14.0,
          ),
        ),
      ),
      body: Container(

          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
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
          child: Container(
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
            child: Center(
              child: Text(
                " No records Found..!",
                style: TextStyle(
                  fontFamily: "FontRegular",
                  color: CustomTheme.of(context).splashColor,
                ),
              ),
            ),
          )
      ),
    ));
  }

  // getDetails() {
  //   apiUtils
  //       .getNotifyList(
  //      )
  //       .then((List<NotifyListModel> loginData) {
  //     setState(() {
  //       loading = false;
  //
  //       notifyList = loginData;
  //     });
  //   }).catchError((Object error) {
  //     setState(() {
  //       loading = false;
  //     });
  //   });
  // }
}
