import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:h2_crypto/common/custom_widget.dart';
import 'package:h2_crypto/common/theme/custom_theme.dart';
import 'package:h2_crypto/data/api_utils.dart';
import 'package:h2_crypto/data/crypt_model/support_ticket_model.dart';

class SupportTicketList extends StatefulWidget {
  const SupportTicketList({Key? key}) : super(key: key);

  @override
  State<SupportTicketList> createState() => _SupportTicketListState();
}

class _SupportTicketListState extends State<SupportTicketList> {

  APIUtils apiUtils = APIUtils();
  ScrollController controller = ScrollController();
  bool loading = false;
  List<SupportTicketListResult> ticketList = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loading=true;
    getTicketList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          "Support",
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
                  Theme.of(context).dialogBackgroundColor,
                ])),
        child: Stack(
          children: [

            loading
                ? CustomWidget(context: context).loadingIndicator(
              CustomTheme.of(context).splashColor,
            )
                : Container(),
          ],
        ),
      ),

    );
  }

 /* Widget supportListUI() {
    return  Container(
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.only(left: 10.0, right: 10.0),
            height: 35.0,
            padding: const EdgeInsets.only(
                left: 10.0, right: 10.0, top: 0.0, bottom: 0.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5.0),
              color: CustomTheme.of(context).cardColor,
            ),
            child: Row(
              children: [
                Text(
                  "TicketList".toUpperCase(),
                  style: CustomWidget(context: context)
                      .CustomSizedTextStyle(
                      12.0,
                      Theme.of(context).splashColor,
                      FontWeight.w500,
                      'FontRegular'),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 10.0,
          ),
          ticketList.length > 0
              ?     Container(
            height: MediaQuery.of(context).size.height * 0.74,
            child: ListView.builder(
                itemCount: ticketList.length,
                shrinkWrap: true,
                controller: controller,
                itemBuilder: (BuildContext context, int index) {
                  var date = DateTime.fromMicrosecondsSinceEpoch(
                      int.parse(
                          ticketList[index].createdAt.toString()) *
                          1000);
                  return Column(
                    children: [
                      Container(
                        margin: EdgeInsets.only(left: 10.0, right: 10.0),
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                            color: CustomTheme.of(context).cardColor,
                            borderRadius: BorderRadius.circular(5.0)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(
                              height: 10.0,
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                  left: 10.0, right: 10.0),
                              child:Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [

                                  Column(crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Date",
                                        style: CustomWidget(context: context)
                                            .CustomTextStyle(
                                            Theme.of(context)
                                                .splashColor
                                                .withOpacity(0.6),
                                            FontWeight.w500,
                                            'FontRegular'),
                                      ),
                                      Text(
                                        date.toString().substring(0, 19),
                                        style: CustomWidget(context: context)
                                            .CustomTextStyle(
                                            Theme.of(context).splashColor,
                                            FontWeight.w500,
                                            'FontRegular'),
                                      ),
                                    ],
                                  ),

                                  Column(
                                    mainAxisAlignment:
                                    MainAxisAlignment.end,

                                    children: [
                                      Text(
                                        "Type",
                                        style: CustomWidget(context: context)
                                            .CustomTextStyle(
                                            Theme.of(context)
                                                .splashColor
                                                .withOpacity(0.6),
                                            FontWeight.w500,
                                            'FontRegular'),
                                      ),
                                      Text(
                                        transHistory[index]
                                            .action
                                            .toString(),
                                        style: CustomWidget(context: context)
                                            .CustomTextStyle(
                                            Theme.of(context).shadowColor,
                                            FontWeight.w500,
                                            'FontRegular'),
                                      ),
                                    ],
                                    crossAxisAlignment:
                                    CrossAxisAlignment.end,
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(
                              height: 5.0,
                            ),
                            Container(
                              height: 0.5,
                              color: Theme.of(context)
                                  .shadowColor
                                  .withOpacity(0.5),
                            ),
                            const SizedBox(
                              height: 5.0,
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                  left: 10.0, right: 10.0),
                              child: Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    transHistory[index]
                                        .currency
                                        .toString()
                                        .toUpperCase(),
                                    style: CustomWidget(context: context)
                                        .CustomTextStyle(
                                        Theme.of(context).shadowColor,
                                        FontWeight.w500,
                                        'FontRegular'),
                                  ),
                                  Text(
                                    transHistory[index].amount.toString(),
                                    style: CustomWidget(context: context)
                                        .CustomTextStyle(
                                        Theme.of(context).shadowColor,
                                        FontWeight.w500,
                                        'FontRegular'),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 2.0,
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                  left: 10.0, right: 10.0),
                              child: Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Currency",
                                    style: CustomWidget(context: context)
                                        .CustomTextStyle(
                                        Theme.of(context)
                                            .splashColor
                                            .withOpacity(0.6),
                                        FontWeight.w500,
                                        'FontRegular'),
                                  ),
                                  Text(
                                    "Amount",
                                    style: CustomWidget(context: context)
                                        .CustomTextStyle(
                                        Theme.of(context)
                                            .splashColor
                                            .withOpacity(0.6),
                                        FontWeight.w500,
                                        'FontRegular'),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 5.0,
                            ),
                            Container(
                              height: 0.5,
                              color: Theme.of(context)
                                  .shadowColor
                                  .withOpacity(0.5),
                            ),
                            const SizedBox(
                              height: 5.0,
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                  left: 10.0, right: 10.0),
                              child: Column(
                                mainAxisAlignment:
                                MainAxisAlignment.start,
                                children: [
                                  Text(
                                    type.toLowerCase() == "buy" ||
                                        type.toLowerCase() == "sell"
                                        ? "Order ID"
                                        : "Transaction ID",
                                    style: CustomWidget(context: context)
                                        .CustomTextStyle(
                                        Theme.of(context)
                                            .splashColor
                                            .withOpacity(0.6),
                                        FontWeight.w500,
                                        'FontRegular'),
                                  ),
                                  Text(
                                    type.toLowerCase() == "buy" ||
                                        type.toLowerCase() == "sell"
                                        ? transHistory[index]
                                        .orderId
                                        .toString()
                                        : transHistory[index]
                                        .txHash
                                        .toString(),
                                    style: CustomWidget(context: context)
                                        .CustomTextStyle(
                                        Theme.of(context).shadowColor,
                                        FontWeight.w500,
                                        'FontRegular'),
                                  ),
                                ],
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                              ),
                            ),
                            const SizedBox(
                              height: 2.0,
                            ),
                            const SizedBox(
                              height: 5.0,
                            ),
                            Container(
                              height: 0.5,
                              color: Theme.of(context)
                                  .shadowColor
                                  .withOpacity(0.5),
                            ),
                            const SizedBox(
                              height: 5.0,
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                  left: 10.0, right: 10.0),
                              child: Column(
                                mainAxisAlignment:
                                MainAxisAlignment.start,
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Status",
                                    style: CustomWidget(context: context)
                                        .CustomTextStyle(
                                        Theme.of(context)
                                            .splashColor
                                            .withOpacity(0.6),
                                        FontWeight.w500,
                                        'FontRegular'),
                                  ),
                                  Text(
                                    transHistory[index]
                                        .status
                                        .toString()
                                        .toUpperCase(),
                                    style: CustomWidget(context: context)
                                        .CustomTextStyle(
                                        Theme.of(context).shadowColor,
                                        FontWeight.w500,
                                        'FontRegular'),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 10.0,
                            ),
                          ],
                        ),
                      ),
                      Container(
                        height: 5.0,
                        width: MediaQuery.of(context).size.width,
                      )
                    ],
                  );
                }),
          ): Container(
            height: MediaQuery.of(context).size.height * 0.3,
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
        ],
      ),
    )
    ;
  }*/

  getTicketList() {
    apiUtils.fetchSupportTicketList().then((SupportTicketListData loginData) {
      if (loginData.sucess!) {
        setState(() {
          loading = false;
          ticketList = loginData.result!;
        });
      } else {
        setState(() {
          loading = false;
        });
      }
    }).catchError((Object error) {
      print(error);
      setState(() {
        loading = false;
      });
    });
  }
}
