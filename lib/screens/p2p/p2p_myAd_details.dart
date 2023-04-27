import 'package:flutter/material.dart';
import 'package:h2_crypto/common/colors.dart';
import 'package:h2_crypto/common/custom_widget.dart';
import 'package:h2_crypto/common/theme/custom_theme.dart';
import 'package:h2_crypto/data/api_utils.dart';
import 'package:h2_crypto/data/model/my_ad_details_model.dart';
import 'package:h2_crypto/screens/p2p/p2p_payment_details.dart';

class MyAdDetailsPage extends StatefulWidget {
  final String tradeId;
  const MyAdDetailsPage({Key? key,
  required this.tradeId
  }) : super(key: key);

  @override
  State<MyAdDetailsPage> createState() => _MyAdDetailsPageState();
}

class _MyAdDetailsPageState extends State<MyAdDetailsPage> {
  bool loading = false;
  APIUtils apiUtils = APIUtils();
  ScrollController controller = ScrollController();
  List<MyAdDetailsData> myAdsDataDetailList = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loading=true;
    getMypostAdDetails(widget.tradeId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            setState(() {
              Navigator.pop(context);
            });
          },
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Text(
          "P2P My Ad Details",
          style: CustomWidget(context: context).CustomSizedTextStyle(22.0,
              Theme.of(context).splashColor, FontWeight.w500, 'FontRegular'),
        ),
        centerTitle: true,
      ),
      backgroundColor: CustomTheme.of(context).primaryColor,
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        padding: EdgeInsets.all(10.0),
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
        child: Stack(
          children: [
            SingleChildScrollView(
              controller: controller,
              child: Column(
                children: [
                  myAdsDetailsUIS(),
                ],
              ),
            ),

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

  Widget myAdsDetailsUIS() {
    return Column(
      children: [
        myAdsDataDetailList.isNotEmpty
            ? Container(
          color: Theme.of(context).backgroundColor,
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: ListView.builder(
            itemCount: myAdsDataDetailList.length,
            shrinkWrap: true,
            controller: controller,
            itemBuilder: (BuildContext context, int index) {
              final input = myAdsDataDetailList[index].paymentType.toString();
              final removedBrackets =
              input.substring(1, input.length - 1);
              final parts = removedBrackets.split(', ');
              var joined = parts.map((part) => "$part").join(', ');
              return Column(
                children: [
                  Theme(
                    data: Theme.of(context)
                        .copyWith(dividerColor: Colors.transparent),
                    child: ExpansionTile(
                      key: PageStorageKey(index.toString()),
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Advertisers (Completion rate)",
                                style: CustomWidget(context: context)
                                    .CustomSizedTextStyle(
                                    12.0,
                                    Theme.of(context)
                                        .splashColor
                                        .withOpacity(0.5),
                                    FontWeight.w400,
                                    'FontRegular'),
                              ),
                              Text(
                                myAdsDataDetailList[index]
                                    .userId!
                                    .name
                                    .toString() +
                                    "(" +
                                    myAdsDataDetailList[index]
                                        .tradeId
                                        .toString()+
                                    ")",
                                style: CustomWidget(context: context)
                                    .CustomSizedTextStyle(
                                    13.0,
                                    Theme.of(context).splashColor,
                                    FontWeight.w400,
                                    'FontRegular'),
                              ),
                            ],
                          ),
                          const SizedBox(
                            width: 10.0,
                          ),
                          const Icon(
                            Icons.keyboard_arrow_down_outlined,
                            color: AppColors.whiteColor,
                            size: 18.0,
                          )
                        ],
                      ),
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 10.0, right: 10.0),
                          child: Column(
                            children: [
                              Padding(
                                padding: EdgeInsets.only(
                                    left: 5.0, right: 5.0),
                                child: Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment:
                                  CrossAxisAlignment.center,
                                  children: [
                                    Column(
                                      children: [
                                        Text(
                                          "AdType",
                                          style: CustomWidget(
                                              context: context)
                                              .CustomSizedTextStyle(
                                              12.0,
                                              Theme.of(context)
                                                  .splashColor
                                                  .withOpacity(0.5),
                                              FontWeight.w400,
                                              'FontRegular'),
                                        ),
                                        Text(
                                          myAdsDataDetailList[index]
                                              .adType
                                              .toString(),
                                          style: CustomWidget(
                                              context: context)
                                              .CustomSizedTextStyle(
                                              12.0,
                                              Theme.of(context)
                                                  .splashColor,
                                              FontWeight.w400,
                                              'FontRegular'),
                                        ),
                                      ],
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                    ),
                                    Column(
                                      children: [
                                        Text(
                                          "Status",
                                          style: CustomWidget(
                                              context: context)
                                              .CustomSizedTextStyle(
                                              12.0,
                                              Theme.of(context)
                                                  .splashColor
                                                  .withOpacity(0.5),
                                              FontWeight.w400,
                                              'FontRegular'),
                                        ),
                                        Text(
                                          myAdsDataDetailList[index]
                                              .statusText
                                              .toString(),
                                          style: CustomWidget(
                                              context: context)
                                              .CustomSizedTextStyle(
                                              12.0,
                                              Theme.of(context)
                                                  .splashColor,
                                              FontWeight.w500,
                                              'FontRegular'),
                                        ),
                                      ],
                                    ),
                                    Column(
                                      children: [
                                        Text(
                                          "Payment",
                                          style: CustomWidget(
                                              context: context)
                                              .CustomSizedTextStyle(
                                              12.0,
                                              Theme.of(context)
                                                  .splashColor
                                                  .withOpacity(0.5),
                                              FontWeight.w400,
                                              'FontRegular'),
                                        ),
                                        Text(
                                          joined.toString(),
                                          style: CustomWidget(
                                              context: context)
                                              .CustomSizedTextStyle(
                                              12.0,
                                              Theme.of(context)
                                                  .splashColor,
                                              FontWeight.w400,
                                              'FontRegular'),
                                        ),
                                      ],
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                height: 10.0,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 5.0,right: 5.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Column(
                                      children: [
                                        Text(
                                          "Limit",
                                          style: CustomWidget(
                                              context: context)
                                              .CustomSizedTextStyle(
                                              12.0,
                                              Theme.of(context)
                                                  .splashColor
                                                  .withOpacity(0.5),
                                              FontWeight.w400,
                                              'FontRegular'),
                                        ),
                                        Text(
                                          "Min: " +
                                              myAdsDataDetailList[index]
                                                  .minLimit
                                                  .toString() +
                                              " " +
                                              myAdsDataDetailList[index]
                                                  .asset
                                                  .toString() +
                                              " - " +
                                              "Max: " +
                                              myAdsDataDetailList[index]
                                                  .maxLimit
                                                  .toString() +
                                              " " +
                                              myAdsDataDetailList[index]
                                                  .asset
                                                  .toString(),
                                          style: CustomWidget(
                                              context: context)
                                              .CustomSizedTextStyle(
                                              12.0,
                                              Theme.of(context)
                                                  .splashColor,
                                              FontWeight.w400,
                                              'FontRegular'),
                                        ),
                                      ],
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                    ),
                                    myAdsDataDetailList[index].status==3||myAdsDataDetailList[index].status==4?SizedBox():InkWell(
                                      child: Container(
                                        width: 120.0,
                                        padding: const EdgeInsets.only(
                                            top: 10.0, bottom: 10.0),
                                        decoration: BoxDecoration(
                                          color: Theme.of(context).indicatorColor,
                                          borderRadius:
                                          BorderRadius.circular(5),
                                        ),
                                        child: Align(
                                          alignment: Alignment.center,
                                          child: Text(
                                            "View",
                                            style: CustomWidget(
                                                context: context)
                                                .CustomSizedTextStyle(
                                                12.0,
                                                Theme.of(context)
                                                    .splashColor,
                                                FontWeight.w400,
                                                'FontRegular'),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ),
                                      onTap: () {
                                        setState(() {
                                          Navigator.of(context).push(MaterialPageRoute(builder: (context)=>P2pPayment(postDetailsData: myAdsDataDetailList[index],
                                            quantity: myAdsDataDetailList[index].quantity.toString(),)));
                                        });
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                height: 10.0,
                              ),
                            ],
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                          ),
                        )
                      ],
                      trailing: Container(
                        width: 1.0,
                        height: 10.0,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 5.0,
                  ),
                  Container(
                    height: 1.0,
                    width: MediaQuery.of(context).size.width,
                    color: Theme.of(context).splashColor,
                  ),
                ],
              );
            },
          ),
        )
            : Container(
          height: MediaQuery.of(context).size.height * 0.3,
          color: Theme.of(context).primaryColor.withOpacity(0.5),
          child: Center(
            child: Text(
              "No Records Found..!",
              style: CustomWidget(context: context).CustomSizedTextStyle(
                  12.0,
                  Theme.of(context).splashColor,
                  FontWeight.w400,
                  'FontRegular'),
            ),
          ),
        ),
        const SizedBox(
          height: 30.0,
        )
      ],
    );
  }

  getMypostAdDetails(String tradeId) {
    apiUtils.getMyAdDetails(tradeId).then((MyAdDetailsModel loginData) {
      if (loginData.statusCode == 200) {
        setState(() {
          loading = false;
          myAdsDataDetailList = loginData.data!;
        });
      }
    }).catchError((Object error) {
      print("P2P" + error.toString());
      setState(() {
        loading = false;
      });
    });
  }

}
