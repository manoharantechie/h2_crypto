import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:h2_crypto/data/crypt_model/coin_list.dart';
import '../../../common/custom_button.dart';
import '../../../common/custom_widget.dart';
import '../../../common/localization/localizations.dart';
import '../../../common/theme/custom_theme.dart';
import '../../../data/api_utils.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({Key? key}) : super(key: key);

  @override
  State<HistoryScreen> createState() => _FiatBuySellScreenState();
}

class _FiatBuySellScreenState extends State<HistoryScreen> {
  bool fiatBtn = true;

  List<String> selectedRupee = ["Indian Rupee(INR)", "American Doller(Doll)"];
  String selectedTime = "";

  APIUtils apiUtils=APIUtils();
  bool loading=false;
  List<CoinList> coinList=[];
  ScrollController controller=ScrollController();


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    selectedTime = selectedRupee.first;


  }


  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: CustomTheme.of(context).primaryColor,
        elevation: 0.0,
        leading: Container(
            padding: const EdgeInsets.all(16.0),
            child: InkWell(
              onTap: (){
                Navigator.pop(context);
              },
              child: SvgPicture.asset(
                'assets/others/arrow_left.svg',
                height: 22.0,
                width: 22.0,
                allowDrawingOutsideViewBox: true,
                color: CustomTheme.of(context).splashColor,
              ),
            )
        ),
        centerTitle: true,

        actions: <Widget>[
          Row(
            children: [
              Container(
                  padding: const EdgeInsets.fromLTRB(0.0, 0.0, 5.0, 0.0),
                  child: InkWell(
                    onTap: (){
                      Navigator.pop(context);
                    },
                    child: SvgPicture.asset(
                      'assets/images/clock.svg',
                      height: 22.0,
                      width: 22.0,
                      allowDrawingOutsideViewBox: true,
                      color: CustomTheme.of(context).splashColor,
                    ),
                  )
              ),

              Text(
                "Order",
                style: CustomWidget(context: context)
                    .CustomSizedTextStyle(
                    12.0,
                    Theme.of(context).hintColor,
                    FontWeight.w400,
                    'FontRegular'),
              ),

              Container(
                  padding: const EdgeInsets.fromLTRB(15.0,0.0, 15.0, 0.0),
                  child: InkWell(
                    onTap: (){
                      Navigator.pop(context);
                    },
                    child: SvgPicture.asset(
                      'assets/images/three_dot.svg',
                      height: 22.0,
                      width: 22.0,
                      allowDrawingOutsideViewBox: true,
                      color: CustomTheme.of(context).splashColor,
                    ),
                  )
              ),
            ],
          ),
        ],
      ),
      body: Container(
        margin: EdgeInsets.only(left: 0, right: 0, bottom: 0.0),

        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                // Add one stop for each color
                // Values should increase from 0.0 to 1.0
                stops: [0.1, 0.5, 0.9,],
                colors: [CustomTheme.of(context).primaryColor,CustomTheme.of(context).backgroundColor, CustomTheme.of(context).accentColor,])),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.fromLTRB(15.0,5.0,15.0,5.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                fiatBtn = true;
                              });
                            },
                            child: Text(
                              "Buy",
                              style: CustomWidget(context: context)
                                  .CustomSizedTextStyle(
                                  14.0,
                                  fiatBtn ? CustomTheme.of(context).hintColor: CustomTheme.of(context).hintColor.withOpacity(0.5),
                                  FontWeight.w400,
                                  'FontRegular'),
                            ),
                          ),
                          SizedBox(width: 15.0,),

                          GestureDetector(
                            onTap: () {
                              setState(() {
                                fiatBtn = false;
                              });
                            },
                            child: Text(
                              "Sell",
                              style: CustomWidget(context: context)
                                  .CustomSizedTextStyle(
                                  14.0,
                                  !fiatBtn ? CustomTheme.of(context).hintColor: CustomTheme.of(context).hintColor.withOpacity(0.5),
                                  FontWeight.w400,
                                  'FontRegular'),
                            ),
                          ),
                          SizedBox(width: 15.0,),
                        ],
                      ),

                      Container(
                        width: MediaQuery.of(context).size.width* 0.5,
                        height: 30.0,
                        padding: EdgeInsets.fromLTRB(10.0, 0.0, 5, 0.0),
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: CustomTheme.of(context)
                                  .cardColor,
                              width: 1.0),
                          borderRadius: BorderRadius.circular(20.0),
                          color: Colors.transparent,
                        ),
                        child: Theme(
                          data: Theme.of(context).copyWith(
                            canvasColor:
                            CustomTheme.of(context).cardColor,
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton(
                              menuMaxHeight:
                              MediaQuery.of(context).size.height *
                                  0.5,
                              items: selectedRupee
                                  .map((value) => DropdownMenuItem(
                                child: Text(
                                  value.toString(),
                                  style: CustomWidget(context: context)
                                      .CustomSizedTextStyle(
                                      12.0,
                                      Theme.of(context).hintColor,
                                      FontWeight.w400,
                                      'FontRegular'),
                                ),
                                value: value,
                              ))
                                  .toList(),
                              onChanged: (value) async {
                                setState(() {
                                  selectedTime = value.toString();
                                });
                              },
                              hint: Text(
                                "Select Category",
                                style: CustomWidget(context: context)
                                    .CustomSizedTextStyle(
                                    12.0,
                                    Theme.of(context).errorColor,
                                    FontWeight.w500,
                                    'FontRegular'),
                              ),
                              isExpanded: true,
                              value: selectedTime,
                              icon: const Icon(
                                Icons.arrow_drop_down,
                                // color: AppColors.otherTextColor,
                              ),
                            ),
                          ),
                        ),
                      ),

                    ],
                  ),
                  SizedBox(height: 10.0,),

                  Container(
                    height: 30.0,
                    child: ListView.builder(
                      itemCount: 10,
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      controller: controller,
                      itemBuilder: (BuildContext context, int index) {
                        return Column(
                          children: [
                            Text("Test $index")
                          ],
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 5.0,),

                  Container(
                    padding: EdgeInsets.all(15.0),
                    width: MediaQuery.of(context).size.width,

                    decoration: BoxDecoration(
                      color: CustomTheme.of(context).buttonColor.withOpacity(0.2),
                      borderRadius: BorderRadius.all(Radius.circular(5.0),),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(padding: EdgeInsets.fromLTRB(0.0,0.0,15.0, 0.0),
                              child: Text(
                                "Amount",
                                style: CustomWidget(context: context)
                                    .CustomSizedTextStyle(
                                    12.0,
                                    Theme.of(context).hintColor,
                                    FontWeight.w400,
                                    'FontRegular'),
                              ),
                            ),

                            Text(
                              "Quantity",
                              style: CustomWidget(context: context)
                                  .CustomSizedTextStyle(
                                  12.0,
                                  Theme.of(context).hintColor.withOpacity(0.5),
                                  FontWeight.w400,
                                  'FontRegular'),
                            ),

                          ],
                        ),
                        SizedBox(height: 10.0,),

                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(padding: EdgeInsets.fromLTRB(0.0,0.0,15.0, 0.0),
                              child: Text(
                                "Ref. price",
                                style: CustomWidget(context: context)
                                    .CustomSizedTextStyle(
                                    12.0,
                                    Theme.of(context).hintColor.withOpacity(0.5),
                                    FontWeight.w400,
                                    'FontRegular'),
                              ),
                            ),

                            Text(
                              "80.28 INR",
                              style: CustomWidget(context: context)
                                  .CustomSizedTextStyle(
                                  12.0,
                                  Theme.of(context).hintColor.withOpacity(0.5),
                                  FontWeight.w400,
                                  'FontRegular'),
                            ),

                          ],
                        ),
                        SizedBox(height: 10.0,),

                        Container(
                          padding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0 ,0.0),
                          decoration: BoxDecoration(
                            border: Border.all(width: 1.0, color: CustomTheme.of(context).buttonColor.withOpacity(0.5),),
                            color: Colors.transparent,
                            borderRadius: BorderRadius.all(Radius.circular(5.0),),
                          ),
                          child: Row(
                            children: [
                              Flexible(child:
                              TextField(
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'Input amount',
                                  hintStyle: TextStyle(
                                    fontSize: 13.0,
                                    color: CustomTheme.of(context).hintColor.withOpacity(0.5),
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                              ),

                             Flexible(
                                child:
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Container(
                                      margin: EdgeInsets.fromLTRB(0, 5, 0, 0),
                                      child: Text(
                                        "INR",
                                        style: CustomWidget(context: context)
                                            .CustomSizedTextStyle(
                                            12.0,
                                            Theme.of(context).hintColor.withOpacity(0.5),
                                            FontWeight.w400,
                                            'FontRegular'),
                                      ),
                                    ),

                                    fiatBtn?Container():    Container(
                                      margin: EdgeInsets.fromLTRB(10, 5, 10, 0),
                                      width: 1.0,
                                      height: 20.0,
                                      decoration: BoxDecoration(
                                          color: CustomTheme.of(context).hintColor.withOpacity(0.5),
                                          borderRadius: BorderRadius.circular(5.0)
                                      ),
                                    ),

                                    fiatBtn?Container():   Container(
                                      margin: EdgeInsets.fromLTRB(5, 5, 5, 0),
                                      child: Text(
                                        AppLocalizations.instance.text("loc_all"),
                                        style: CustomWidget(context: context)
                                            .CustomSizedTextStyle(
                                            12.0,
                                            Theme.of(context).scaffoldBackgroundColor,
                                            FontWeight.w400,
                                            'FontRegular'),
                                      ),
                                    ),
                                  ],
                                ),),

                              SizedBox(height: 10.0,),
                            ],
                          ),
                        ),
                        SizedBox(height: 10.0,),

                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(padding: EdgeInsets.fromLTRB(0.0,0.0,15.0, 0.0),
                              child: Text(
                                "Fiat account balance",
                                style: CustomWidget(context: context)
                                    .CustomSizedTextStyle(
                                    11.0,
                                    Theme.of(context).hintColor.withOpacity(0.5),
                                    FontWeight.w400,
                                    'FontRegular'),
                              ),
                            ),

                            Padding(padding: EdgeInsets.fromLTRB(0.0,0.0,15.0, 0.0),
                              child: Text(
                                "0.00 USDT",
                                style: CustomWidget(context: context)
                                    .CustomSizedTextStyle(
                                    12.0,
                                    Theme.of(context).hintColor.withOpacity(0.5),
                                    FontWeight.w400,
                                    'FontRegular'),
                              ),
                            ),



                            Text(
                              "Transfer",
                              style: CustomWidget(context: context)
                                  .CustomSizedTextStyle(
                                  11.0,
                                  Theme.of(context).buttonColor,
                                  FontWeight.w400,
                                  'FontRegular'),
                            ),

                          ],
                        ),
                        SizedBox(height: 10.0,),

                        Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5.0),
                                color: !fiatBtn ? CustomTheme.of(context).scaffoldBackgroundColor: CustomTheme.of(context).indicatorColor),
                            child: Center(
                                child: Padding(
                                  padding: EdgeInsets.only(
                                      top: 10.0, bottom: 10.0),
                                  child: Text(
                                    "QUICK TRADE",
                                    style: CustomWidget(context: context)
                                        .CustomSizedTextStyle(
                                        13.0,
                                        !fiatBtn ? CustomTheme.of(context).splashColor: CustomTheme.of(context).hintColor,
                                        FontWeight.w500,
                                        'FontRegular'),
                                  ),
                                ))),
                      ],
                    ),
                  ),
                  SizedBox(height: 10.0,),

                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        "Favourites merchant",
                        style: CustomWidget(context: context)
                            .CustomSizedTextStyle(
                            11.0,
                            Theme.of(context).hintColor.withOpacity(0.5),
                            FontWeight.w400,
                            'FontRegular'),
                      ),
                    ],
                  ),
                  SizedBox(height: 15.0,),

                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 1.0,
                    decoration: BoxDecoration(
                        color: CustomTheme.of(context).hintColor.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(5.0)
                    ),
                  ),
                  SizedBox(height: 10.0,),

                  Container(
                    child: Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Text(
                                  "Momento",
                                  style: CustomWidget(context: context)
                                      .CustomSizedTextStyle(
                                      18.0,
                                      Theme.of(context).splashColor,
                                      FontWeight.w500,
                                      'FontRegular'),
                                ),

                                Container(
                                    padding: EdgeInsets.fromLTRB(8.0,3.0,8.0,0.0),
                                    child: InkWell(
                                      onTap: (){
                                        Navigator.pop(context);
                                      },
                                      child: SvgPicture.asset(
                                        'assets/images/v_logo.svg',
                                        height: 15.0,
                                        width: 15.0,
                                        allowDrawingOutsideViewBox: true,
                                        // color: CustomTheme.of(context).splashColor,
                                      ),
                                    ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Text(
                                  "0",
                                  style: CustomWidget(context: context)
                                      .CustomSizedTextStyle(
                                      14.0,
                                      Theme.of(context).splashColor,
                                      FontWeight.w400,
                                      'FontRegular'),
                                ),
                                Container(
                                  margin: EdgeInsets.fromLTRB(5, 0, 5, 0),
                                  width: 1.0,
                                  height: 15.0,
                                  decoration: BoxDecoration(
                                      color: CustomTheme.of(context).hintColor.withOpacity(0.5),
                                      borderRadius: BorderRadius.circular(5.0)
                                  ),
                                ),

                                Text(
                                  "0%",
                                  style: CustomWidget(context: context)
                                      .CustomSizedTextStyle(
                                      14.0,
                                      Theme.of(context).splashColor,
                                      FontWeight.w400,
                                      'FontRegular'),
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: 10.0,),

                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Quantity 1000",
                              style: CustomWidget(context: context)
                                  .CustomSizedTextStyle(
                                  12.0,
                                  Theme.of(context).splashColor,
                                  FontWeight.w400,
                                  'FontRegular'),
                            ),
                            Text(
                              "Price[INR]",
                              style: CustomWidget(context: context)
                                  .CustomSizedTextStyle(
                                  12.0,
                                  Theme.of(context).splashColor,
                                  FontWeight.w400,
                                  'FontRegular'),
                            ),

                          ],
                        ),
                        SizedBox(height: 5.0,),

                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Limit ₹10000-₹70000",
                              style: CustomWidget(context: context)
                                  .CustomSizedTextStyle(
                                  12.0,
                                  Theme.of(context).splashColor,
                                  FontWeight.w400,
                                  'FontRegular'),
                            ),
                            Text(
                              "79.62",
                              style: CustomWidget(context: context)
                                  .CustomSizedTextStyle(
                                  12.0,
                                  Theme.of(context).splashColor,
                                  FontWeight.w400,
                                  'FontRegular'),
                            ),

                          ],
                        ),
                        SizedBox(height: 5.0,),

                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Container(
                                    padding: const EdgeInsets.all(5.0),
                                    child: InkWell(
                                      onTap: (){
                                        Navigator.pop(context);
                                      },
                                      child: SvgPicture.asset(
                                        'assets/images/atm_card.svg',
                                        height: 20.0,
                                        width: 20.0,
                                        allowDrawingOutsideViewBox: true,
                                        // color: CustomTheme.of(context).splashColor,
                                      ),
                                    )
                                ),
                                Container(
                                    padding: const EdgeInsets.all(2.0),
                                    child: InkWell(
                                      onTap: (){
                                        Navigator.pop(context);
                                      },
                                      child: SvgPicture.asset(
                                        'assets/images/google-pay.svg',
                                        height: 6.0,
                                        width: 22.0,
                                        allowDrawingOutsideViewBox: true,
                                        // color: CustomTheme.of(context).splashColor,
                                      ),
                                    )
                                ),
                                Container(
                                    padding: const EdgeInsets.all(2.0),
                                    child: InkWell(
                                      onTap: (){
                                        Navigator.pop(context);
                                      },
                                      child: SvgPicture.asset(
                                        'assets/images/Upi_logo.svg',
                                        height: 6.0,
                                        width: 22.0,
                                        // allowDrawingOutsideViewBox: true,
                                        // color: CustomTheme.of(context).splashColor,
                                      ),
                                    )
                                ),
                                Container(
                                    padding: const EdgeInsets.all(2.0),
                                    child: InkWell(
                                      onTap: (){
                                        Navigator.pop(context);
                                      },
                                      child: SvgPicture.asset(
                                        'assets/images/PhonePe.svg',
                                        height: 6.0,
                                        width: 22.0,
                                        allowDrawingOutsideViewBox: true,
                                        color: CustomTheme.of(context).splashColor,
                                      ),
                                    )
                                ),

                              ],
                            ),

                            Container(
                              padding: EdgeInsets.fromLTRB(10.0,0.0,10.0,0.0),
                              decoration: BoxDecoration(
                                  color: !fiatBtn ? CustomTheme.of(context).scaffoldBackgroundColor: CustomTheme.of(context).indicatorColor),
                              child: Text(
                                 !fiatBtn ? "Sell" : "Buy",
                                style: CustomWidget(context: context)
                                    .CustomSizedTextStyle(
                                    12.0,
                                    !fiatBtn ? CustomTheme.of(context).splashColor: CustomTheme.of(context).hintColor,
                                    FontWeight.w400,
                                    'FontRegular'),
                              ),
                            ),

                          ],
                        ),
                        SizedBox(height: 10.0,),
                      ],
                    ),
                  ),
                  SizedBox(height: 5.0,),

                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 1.0,
                    decoration: BoxDecoration(
                        color: CustomTheme.of(context).hintColor.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(5.0)
                    ),
                  ),
                  SizedBox(height: 5.0,),

                  Container(
                    child: Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Text(
                                  "Momento",
                                  style: CustomWidget(context: context)
                                      .CustomSizedTextStyle(
                                      18.0,
                                      Theme.of(context).splashColor,
                                      FontWeight.w500,
                                      'FontRegular'),
                                ),

                                Container(
                                  padding: EdgeInsets.fromLTRB(8.0,3.0,8.0,0.0),
                                  child: InkWell(
                                    onTap: (){
                                      Navigator.pop(context);
                                    },
                                    child: SvgPicture.asset(
                                      'assets/images/v_logo.svg',
                                      height: 15.0,
                                      width: 15.0,
                                      allowDrawingOutsideViewBox: true,
                                      // color: CustomTheme.of(context).splashColor,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Text(
                                  "0",
                                  style: CustomWidget(context: context)
                                      .CustomSizedTextStyle(
                                      14.0,
                                      Theme.of(context).splashColor,
                                      FontWeight.w400,
                                      'FontRegular'),
                                ),
                                Container(
                                  margin: EdgeInsets.fromLTRB(5, 0, 5, 0),
                                  width: 1.0,
                                  height: 15.0,
                                  decoration: BoxDecoration(
                                      color: CustomTheme.of(context).hintColor.withOpacity(0.5),
                                      borderRadius: BorderRadius.circular(5.0)
                                  ),
                                ),

                                Text(
                                  "0%",
                                  style: CustomWidget(context: context)
                                      .CustomSizedTextStyle(
                                      14.0,
                                      Theme.of(context).splashColor,
                                      FontWeight.w400,
                                      'FontRegular'),
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: 10.0,),

                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Quantity 1000",
                              style: CustomWidget(context: context)
                                  .CustomSizedTextStyle(
                                  12.0,
                                  Theme.of(context).splashColor,
                                  FontWeight.w400,
                                  'FontRegular'),
                            ),
                            Text(
                              "Price[INR]",
                              style: CustomWidget(context: context)
                                  .CustomSizedTextStyle(
                                  12.0,
                                  Theme.of(context).splashColor,
                                  FontWeight.w400,
                                  'FontRegular'),
                            ),

                          ],
                        ),
                        SizedBox(height: 5.0,),

                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Limit ₹10000-₹70000",
                              style: CustomWidget(context: context)
                                  .CustomSizedTextStyle(
                                  12.0,
                                  Theme.of(context).splashColor,
                                  FontWeight.w400,
                                  'FontRegular'),
                            ),
                            Text(
                              "79.62",
                              style: CustomWidget(context: context)
                                  .CustomSizedTextStyle(
                                  12.0,
                                  Theme.of(context).splashColor,
                                  FontWeight.w400,
                                  'FontRegular'),
                            ),

                          ],
                        ),
                        SizedBox(height: 5.0,),

                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Container(
                                    padding: const EdgeInsets.all(5.0),
                                    child: InkWell(
                                      onTap: (){
                                        Navigator.pop(context);
                                      },
                                      child: SvgPicture.asset(
                                        'assets/images/atm_card.svg',
                                        // color: CustomTheme.of(context).splashColor,
                                      ),
                                    )
                                ),
                                Container(
                                    padding: const EdgeInsets.all(2.0),
                                    child: InkWell(
                                      onTap: (){
                                        Navigator.pop(context);
                                      },
                                      child: SvgPicture.asset(
                                        'assets/images/google_pay.svg',

                                        // color: CustomTheme.of(context).splashColor,
                                      ),
                                    )
                                ),
                                Container(
                                    padding: const EdgeInsets.all(2.0),
                                    child: InkWell(
                                      onTap: (){
                                        Navigator.pop(context);
                                      },
                                      child: SvgPicture.asset(
                                        'assets/images/upi_logo.svg',

                                        // allowDrawingOutsideViewBox: true,
                                        // color: CustomTheme.of(context).splashColor,
                                      ),
                                    )
                                ),
                                Container(
                                    padding: const EdgeInsets.all(2.0),
                                    child: InkWell(
                                      onTap: (){
                                        Navigator.pop(context);
                                      },
                                      child: SvgPicture.asset(
                                        'assets/images/phone_pe.svg',


                                      ),
                                    )
                                ),

                              ],
                            ),

                            Container(
                              padding: EdgeInsets.fromLTRB(10.0,0.0,10.0,0.0),
                              decoration: BoxDecoration(
                                  color: !fiatBtn ? CustomTheme.of(context).scaffoldBackgroundColor: CustomTheme.of(context).indicatorColor),

                              child: Text(
                                !fiatBtn ? "Sell" : "Buy",
                                style: CustomWidget(context: context)
                                    .CustomSizedTextStyle(
                                    12.0,
                                    !fiatBtn ? CustomTheme.of(context).splashColor: CustomTheme.of(context).hintColor,
                                    FontWeight.w400,
                                    'FontRegular'),
                              ),
                            ),

                          ],
                        ),
                        SizedBox(height: 10.0,),
                      ],
                    ),
                  ),
                  SizedBox(height: 5.0,),

                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 1.0,
                    decoration: BoxDecoration(
                        color: CustomTheme.of(context).hintColor.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(5.0)
                    ),
                  ),
                  SizedBox(height: 5.0,),


                ],
              ),
            ),
          ),
        ),
      ),
    );
  }


}
