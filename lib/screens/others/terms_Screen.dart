import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_svg/svg.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../../common/custom_widget.dart';
import '../../../common/localization/localizations.dart';
import '../../../common/theme/custom_theme.dart';
import '../../../data/api_utils.dart';


class TermsCondition extends StatefulWidget {
  final String title;
  final String content;
  const TermsCondition({Key? key, required this.title, required this.content}) : super(key: key);
  @override
  State<TermsCondition> createState() => _TermsConditionState();
}

class _TermsConditionState extends State<TermsCondition> {

  late final WebViewController webcontroller;
  bool loading=true;

  @override
  void initState() {

    super.initState();
    if (Platform.isAndroid) {
      webcontroller = WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..setBackgroundColor(const Color(0xFF242B48))
        ..setNavigationDelegate(
          NavigationDelegate(
            onProgress: (int progress) {
              // Update loading bar.
            },
            onPageStarted: (String url) {
              print("test1");

            },
            onPageFinished: (String url) {
              setState(() {
                loading=false;
              });
            },
            onWebResourceError: (WebResourceError error) {
              print("test");
              print(error);
            },

          ),
        )
        ..loadRequest(Uri.parse(widget.content));
    } else if (Platform.isIOS) {
      webcontroller = WebViewController()
        ..setBackgroundColor(const Color(0xFF242B48))
        ..setNavigationDelegate(
          NavigationDelegate(
            onProgress: (int progress) {
              // Update loading bar.
            },
            onPageStarted: (String url) {
              print("test1");

            },
            onPageFinished: (String url) {
              setState(() {
                loading=false;
              });
            },
            onWebResourceError: (WebResourceError error) {
              print("test");
              print(error);
            },

          ),
        )
        ..loadRequest(Uri.parse(widget.content));
    }




  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery(data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0), child: Scaffold(
      backgroundColor: CustomTheme.of(context).backgroundColor,
      appBar: AppBar(
        backgroundColor: CustomTheme.of(context).primaryColor,
        elevation: 0.0,
        title: Text(
          AppLocalizations.instance.text(widget.title),
          // textAlign: TextAlign.center,
          style: CustomWidget(context: context).CustomSizedTextStyle(
            17.0,
            Theme.of(context).splashColor, FontWeight.w500, 'FontRegular',
          ),
        ),
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
                allowDrawingOutsideViewBox: true,
              ),
            )),
        centerTitle: true,
      ),
      body:  Stack(
        children: [
          WebViewWidget(controller: webcontroller),
          loading
              ? CustomWidget(context: context).loadingIndicator(
            CustomTheme.of(context).splashColor,
          )
              : Container()
        ],
      ),));
  }

}
