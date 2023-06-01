

import 'package:flutter/material.dart';
import 'package:h2_crypto/common/colors.dart';
import 'package:h2_crypto/common/custom_widget.dart';


import 'package:webview_flutter/webview_flutter.dart';

class TradeChartScreen extends StatefulWidget {
  final String pair;
  const TradeChartScreen({Key? key, required this.pair}) : super(key: key);

  @override
  _TradeChartScreenState createState() => _TradeChartScreenState();
}

class _TradeChartScreenState extends State<TradeChartScreen> {
  bool loadingChart = false;

  late final WebViewController webcontroller;

  @override
  void initState() {
    super.initState();

    print('https://h2crypto.exchange/trading-chart/'+widget.pair);
    webcontroller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Update loading bar.
          },
          onPageStarted: (String url) {},
          onPageFinished: (String url) {},
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.startsWith('https://h2crypto.exchange/trading-chart/'+widget.pair,)) {
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse('https://h2crypto.exchange/trading-chart/'+widget.pair,));



  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: Theme.of(context).backgroundColor,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context, true),
          ),
          title: Text(
           "Trade Chart",
            style:CustomWidget(context: context)
                .CustomSizedTextStyle(
                 20.0,
                Theme.of(context).splashColor,
                FontWeight.w500,
                'FontRegular'),

          ),
        ),
        body:  WebViewWidget(controller: webcontroller),);
  }
}
