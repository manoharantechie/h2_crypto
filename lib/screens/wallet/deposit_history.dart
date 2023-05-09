import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../common/custom_widget.dart';
import '../../common/localization/localizations.dart';
import '../../common/theme/custom_theme.dart';
import 'package:h2_crypto/data/api_utils.dart';


class DepositHistoryScreen extends StatefulWidget {
  const DepositHistoryScreen({Key? key}) : super(key: key);

  @override
  State<DepositHistoryScreen> createState() => _DepositHistoryScreenState();
}

class _DepositHistoryScreenState extends State<DepositHistoryScreen> {
  APIUtils apiUtils = APIUtils();
  bool loading = false;

  ScrollController controller = ScrollController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();


  }

  Widget build(BuildContext context) {
    return Scaffold(
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
              CustomTheme.of(context).accentColor,
            ])),
        child: SingleChildScrollView(
          child: SafeArea(
            child: Padding(
              padding: EdgeInsets.all(0.0),
              child: loading
                  ? CustomWidget(context: context).loadingIndicator(
                      CustomTheme.of(context).splashColor,
                    )
                  : Container()

             // depositListWidgets(),
            ),
          ),
        ),
      ),
    );
  }

  // Widget depositListWidgets() {
  //   return Column(
  //     children: [
  //       depositHistory.length > 0
  //           ? Container(
  //               height: MediaQuery.of(context).size.height,
  //               child: ListView.builder(
  //                   itemCount: depositHistory.length,
  //                   shrinkWrap: true,
  //                   itemBuilder: (BuildContext context, int index) {
  //                     String dates= DateTime.fromMillisecondsSinceEpoch(int.parse( depositHistory[index]
  //                         .createdTime.toString()) ).toString();
  //                     return SizedBox(
  //                         width: MediaQuery.of(context).size.width,
  //                         child: Column(
  //                           crossAxisAlignment: CrossAxisAlignment.start,
  //                           mainAxisAlignment: MainAxisAlignment.start,
  //                           children: [
  //                             Theme(
  //                               data: Theme.of(context)
  //                                   .copyWith(dividerColor: Colors.transparent),
  //                               child: ExpansionTile(
  //                                 key: PageStorageKey(index.toString()),
  //                                 title: Row(
  //                                   mainAxisAlignment:
  //                                       MainAxisAlignment.spaceBetween,
  //                                   children: [
  //                                     Row(
  //                                       mainAxisAlignment:
  //                                           MainAxisAlignment.start,
  //                                       crossAxisAlignment:
  //                                           CrossAxisAlignment.start,
  //                                       children: [
  //                                         Container(
  //                                           height: 25.0,
  //                                           width: 25.0,
  //                                           child: SvgPicture.network(
  //
  //                                             "https://beta-front.cifdaq.com/api/color/" +
  //                                                 depositHistory[index]
  //                                                     .asset!
  //                                                     .toString()
  //                                                     .toLowerCase() +
  //                                                 ".svg",
  //                                             fit: BoxFit.cover,
  //                                           ),
  //                                         ),
  //                                         const SizedBox(
  //                                           width: 15.0,
  //                                         ),
  //                                         Text(
  //                                           depositHistory[index]
  //                                               .asset
  //                                               .toString(),
  //                                           style: CustomWidget(context: context)
  //                                               .CustomTextStyle(
  //                                               Theme.of(context)
  //                                                   .splashColor,
  //                                               FontWeight.w400,
  //                                               'FontRegular'),
  //                                         ),
  //
  //                                       ],
  //                                     ),
  //                                     Column(
  //
  //                                       children: [
  //                                         Text(
  //                                           AppLocalizations.instance
  //                                               .text("loc_amount"),
  //                                           style: CustomWidget(context: context)
  //                                               .CustomTextStyle(
  //                                               Theme.of(context)
  //                                                   .splashColor.withOpacity(0.5),
  //                                               FontWeight.w400,
  //                                               'FontRegular'),
  //                                         ),
  //                                         Text(
  //                                           double.parse(depositHistory[index]
  //                                                   .amount
  //                                                   .toString()
  //                                                   .replaceAll(",", ""))
  //                                               .toStringAsFixed(2),
  //                                           style: CustomWidget(context: context)
  //                                               .CustomTextStyle(
  //                                               Theme.of(context)
  //                                                   .splashColor,
  //                                               FontWeight.w400,
  //                                               'FontRegular'),
  //                                         ),
  //                                       ],
  //                                       crossAxisAlignment:
  //                                           CrossAxisAlignment.end,
  //                                     )
  //                                   ],
  //                                 ),
  //                                 children: [
  //                                 Container(
  //                                   width: MediaQuery.of(context).size.width,
  //                                   child:   Padding(
  //                                     padding: const EdgeInsets.only(
  //                                         left: 10.0, right: 10.0),
  //                                     child: Column(
  //                                       crossAxisAlignment:
  //                                       CrossAxisAlignment.start,
  //                                       mainAxisAlignment: MainAxisAlignment.start,
  //                                       children: [
  //                                         Padding(
  //                                           padding: EdgeInsets.only(
  //                                               left: 10.0, right: 15.0),
  //                                           child: Column(
  //                                             crossAxisAlignment:
  //                                             CrossAxisAlignment.start,
  //                                             children: [
  //                                               Text(
  //                                                 "Date",
  //                                                 style: CustomWidget(context: context)
  //                                                     .CustomTextStyle(
  //                                                     Theme.of(context)
  //                                                         .splashColor.withOpacity(0.5),
  //                                                     FontWeight.w400,
  //                                                     'FontRegular'),
  //                                               ),
  //                                               const SizedBox(
  //                                                 width: 30.0,
  //                                               ),
  //                                               Text(
  //                                                 dates.toString().substring(0,19),
  //                                                 style: CustomWidget(context: context)
  //                                                     .CustomTextStyle(
  //                                                     Theme.of(context)
  //                                                         .splashColor,
  //                                                     FontWeight.w400,
  //                                                     'FontRegular'),
  //                                               ),
  //                                             ],
  //                                           ),
  //                                         ),
  //                                         const SizedBox(
  //                                           height: 10.0,
  //                                         ),
  //                                         Padding(
  //                                           padding: EdgeInsets.only(
  //                                               left: 10.0, right: 15.0),
  //                                           child: Column(
  //                                             crossAxisAlignment:
  //                                             CrossAxisAlignment.start,
  //                                             children: [
  //                                               Text(
  //                                                 "Sender's Address",
  //                                                 style: CustomWidget(context: context)
  //                                                     .CustomTextStyle(
  //                                                     Theme.of(context)
  //                                                         .splashColor.withOpacity(0.5),
  //                                                     FontWeight.w400,
  //                                                     'FontRegular'),
  //                                               ),
  //                                               const SizedBox(
  //                                                 width: 30.0,
  //                                               ),
  //                                               Text(
  //                                                 depositHistory[index]
  //                                                     .toAddress
  //                                                     .toString(),
  //                                                 style: CustomWidget(context: context)
  //                                                     .CustomTextStyle(
  //                                                     Theme.of(context)
  //                                                         .splashColor,
  //                                                     FontWeight.w400,
  //                                                     'FontRegular'),
  //                                               ),
  //                                             ],
  //                                           ),
  //                                         ),
  //                                         const SizedBox(
  //                                           height: 10.0,
  //                                         ),
  //                                         Padding(
  //                                           padding: EdgeInsets.only(
  //                                               left: 10.0, right: 15.0),
  //                                           child: Column(
  //                                             crossAxisAlignment:
  //                                             CrossAxisAlignment.start,
  //                                             children: [
  //                                               Text(
  //                                                 "Transaction ID",
  //                                                 style:CustomWidget(context: context)
  //                                                     .CustomTextStyle(
  //                                                     Theme.of(context)
  //                                                         .splashColor.withOpacity(0.5),
  //                                                     FontWeight.w400,
  //                                                     'FontRegular'),
  //                                               ),
  //                                               const SizedBox(
  //                                                 width: 30.0,
  //                                               ),
  //                                               Text(
  //                                                 depositHistory[index]
  //                                                     .id
  //                                                     .toString(),
  //                                                 style:CustomWidget(context: context)
  //                                                     .CustomTextStyle(
  //                                                     Theme.of(context)
  //                                                         .splashColor,
  //                                                     FontWeight.w400,
  //                                                     'FontRegular'),
  //                                               ),
  //                                             ],
  //                                           ),
  //                                         ),
  //                                         const SizedBox(
  //                                           height: 10.0,
  //                                         ),
  //                                         Padding(
  //                                           padding: EdgeInsets.only(
  //                                               left: 10.0, right: 15.0),
  //                                           child: Column(
  //                                             children: [
  //                                               Text(
  //                                                 "Status",
  //                                                 style: CustomWidget(context: context)
  //                                                     .CustomTextStyle(
  //                                                     Theme.of(context)
  //                                                         .splashColor.withOpacity(0.5),
  //                                                     FontWeight.w400,
  //                                                     'FontRegular'),
  //                                               ),
  //                                               const SizedBox(
  //                                                 width: 30.0,
  //                                               ),
  //                                               Text(
  //                                                 depositHistory[index]
  //                                                     .transactionType
  //                                                     .toString(),
  //                                                 style: CustomWidget(context: context)
  //                                                     .CustomTextStyle(
  //                                                     Theme.of(context)
  //                                                         .splashColor,
  //                                                     FontWeight.w400,
  //                                                     'FontRegular'),
  //                                               ),
  //                                             ],
  //                                             crossAxisAlignment:
  //                                             CrossAxisAlignment.start,
  //                                           ),
  //                                         ),
  //                                         const SizedBox(
  //                                           height: 10.0,
  //                                         ),
  //                                       ],
  //                                     ),
  //                                   ),
  //                                 )
  //                                 ],
  //                                 trailing: Container(
  //                                   width: 1.0,
  //                                   height: 10.0,
  //                                 ),
  //                               ),
  //                             ),
  //                             const SizedBox(
  //                               height: 5.0,
  //                             ),
  //                             Container(
  //                               height: 1.0,
  //                               width: MediaQuery.of(context).size.width,
  //                               color: CustomTheme.of(context).splashColor.withOpacity(0.5),
  //                             )
  //                           ],
  //                         ));
  //                   }),
  //             )
  //           : Container(
  //         height: MediaQuery.of(context).size.height,
  //               decoration: BoxDecoration(
  //                   gradient: LinearGradient(
  //                       begin: Alignment.topCenter,
  //                       end: Alignment.bottomCenter,
  //                       // Add one stop for each color
  //                       // Values should increase from 0.0 to 1.0
  //                       stops: [
  //                     0.1,
  //                     0.5,
  //                     0.9,
  //                   ],
  //                       colors: [
  //                     CustomTheme.of(context).primaryColor,
  //                     CustomTheme.of(context).backgroundColor,
  //                     CustomTheme.of(context).accentColor,
  //                   ])),
  //               child: Center(
  //                 child: Text(
  //                   " No records Found..!",
  //                   style: TextStyle(
  //                     fontFamily: "FontRegular",
  //                     color: CustomTheme.of(context).splashColor,
  //                   ),
  //                 ),
  //               ),
  //             )
  //     ],
  //   );
  // }


}
