import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:h2_crypto/common/theme/custom_theme.dart';
import 'package:h2_crypto/data/api_utils.dart';
import 'package:h2_crypto/screens/wallet/deposit_history.dart';

class TransactionHistory extends StatefulWidget {
  const TransactionHistory({Key? key}) : super(key: key);

  @override
  State<TransactionHistory> createState() => _TransactionHistoryState();
}

class _TransactionHistoryState extends State<TransactionHistory> with SingleTickerProviderStateMixin{
  APIUtils apiUtils = APIUtils();
  ScrollController controller = ScrollController();
  late TabController _tabController;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tabController = TabController(vsync: this, length: 2);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  CustomTheme.of(context).accentColor,
                ])),
        child: Column(
          children: [
            Stack(
              children: [
                TabBar(
                  controller: _tabController,
                  labelColor: CustomTheme.of(context).buttonColor,
                  //<-- selected text color
                  unselectedLabelColor: CustomTheme.of(context).splashColor.withOpacity(0.5),
                  // isScrollable: true,
                  indicatorPadding:
                  EdgeInsets.only(left: 10.0, right: 10.0),
                  indicatorColor: CustomTheme.of(context).buttonColor,
                  tabs: <Widget>[
                    Tab(
                      text: "Deposit History",
                    ),
                    Tab(
                      text:  "Withdraw History",
                    ),

                  ],
                ),
              ],
            ),
            Expanded(
              child: Container(
                color: CustomTheme.of(context).backgroundColor,
                child: TabBarView(
                  controller: _tabController,
                  children: <Widget>[
                    DepositHistoryScreen(),
                    Container(
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
                        child: Text(
                          " No records Found..!",
                          style: TextStyle(
                            fontFamily: "FontRegular",
                            color: CustomTheme.of(context).splashColor,
                          ),
                        ),
                      ),
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


}
