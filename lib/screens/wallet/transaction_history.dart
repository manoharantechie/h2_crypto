import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:h2_crypto/common/custom_widget.dart';
import 'package:h2_crypto/common/theme/custom_theme.dart';
import 'package:h2_crypto/data/api_utils.dart';
import 'package:h2_crypto/data/crypt_model/history_model.dart';

class TransactionHistory extends StatefulWidget {
  const TransactionHistory({Key? key}) : super(key: key);

  @override
  State<TransactionHistory> createState() => _TransactionHistoryState();
}

class _TransactionHistoryState extends State<TransactionHistory>
    with SingleTickerProviderStateMixin {
  APIUtils apiUtils = APIUtils();
  ScrollController controller = ScrollController();
  bool loading = false;
  List<TransHistoryList> transHistory = [];
  List<TransHistoryList> AllHistory = [];
  final List<String> trasnType = [
    "All",
    "Buy",
    "Sell",
    "Deposit",
    "Withdraw",
  ];

  String selectedtrasnType = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loading = true;
    selectedtrasnType = trasnType.first;
    getHistory();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: CustomTheme.of(context).primaryColor,
        elevation: 0.0,
        leading: Container(
          width: 0.0,
        ),
        centerTitle: true,
        title: Text(
          "History Screen",
          style: CustomWidget(context: context).CustomSizedTextStyle(18.0,
              Theme.of(context).splashColor, FontWeight.w500, 'FontRegular'),
        ),
        actions: <Widget>[],
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
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
        child: Stack(
          children: [
            hisotryDetails(),
            loading
                ? CustomWidget(context: context).loadingIndicator(
                    CustomTheme.of(context).splashColor,
                  )
                : Container()
          ],
        ),
      ),
    );
  }

  Widget hisotryDetails() {
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
                  child: Center(
                    child: Theme(
                      data: Theme.of(context).copyWith(
                        canvasColor: CustomTheme.of(context).cardColor,
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton(
                          items: trasnType
                              .map((value) => DropdownMenuItem(
                                    child: Text(
                                      value,
                                      style: CustomWidget(context: context)
                                          .CustomSizedTextStyle(
                                              12.0,
                                              Theme.of(context).splashColor,
                                              FontWeight.w500,
                                              'FontRegular'),
                                    ),
                                    value: value,
                                  ))
                              .toList(),
                          onChanged: (value) {
                            setState(() {
                              transHistory=[];
                              selectedtrasnType = value.toString();
                              if(selectedtrasnType.toLowerCase()=="all")
                                {

                                  transHistory.addAll(AllHistory);
                                }
                              else{
                                for(int m=0;m<AllHistory.length;m++)
                                  {
                                    if(AllHistory[m].action.toString().toLowerCase()==selectedtrasnType.toLowerCase())
                                      {
                                        transHistory.add(AllHistory[m]);
                                      }
                                  }
                              }
                            });
                          },
                          isExpanded: true,
                          value: selectedtrasnType,
                          icon: Icon(
                            Icons.keyboard_arrow_down,
                            color: CustomTheme.of(context).splashColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10.0,
                ),
                transHistory.length > 0
                    ?     Container(
                  height: MediaQuery.of(context).size.height * 0.76,
                  child: ListView.builder(
                      itemCount: transHistory.length,
                      shrinkWrap: true,
                      controller: controller,
                      itemBuilder: (BuildContext context, int index) {
                        var date = DateTime.fromMicrosecondsSinceEpoch(
                            int.parse(
                                    transHistory[index].timestamp.toString()) *
                                1000);
                        String type = transHistory[index].action.toString();
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
              ],
            ),
          )
        ;
  }

  getHistory() {
    apiUtils.getTransHistory().then((TransHistoryListModel loginData) {
      if (loginData.success!) {
        setState(() {
          loading = false;
          AllHistory = loginData.result!;
          transHistory = loginData.result!;
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
