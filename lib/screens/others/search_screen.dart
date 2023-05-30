import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:h2_crypto/common/custom_widget.dart';
import 'package:h2_crypto/common/theme/custom_theme.dart';
import 'package:h2_crypto/data/api_utils.dart';
import 'package:h2_crypto/data/crypt_model/trade_pair_list_model.dart';



class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController searchController = TextEditingController();
  FocusNode searchFocus = FocusNode();
  APIUtils apiUtils = APIUtils();

  bool loading = false;
  ScrollController controller = ScrollController();
  List<TradePairList> tradePair = [];
  List<TradePairList> searchPair = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loading = true;

    getCoinList();
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
        data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
        child: Scaffold(
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
             "Search",
              style: TextStyle(
                fontFamily: 'FontSpecial',
                color: CustomTheme.of(context).splashColor,
                fontWeight: FontWeight.w500,
                fontSize: 14.0,
              ),
            ),
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
              child: loading
                  ? CustomWidget(context: context).loadingIndicator(
                      CustomTheme.of(context).splashColor,
                    )
                  : Padding(
                padding: EdgeInsets.only(
                    top: 5.0, bottom: 10.0, right: 15.0, left: 15.0),
                child: Column(
                  children: <Widget>[
                    Container(
                      height: 45.0,
                      padding: EdgeInsets.only(left: 20.0),
                      width:
                      MediaQuery.of(context).size.width,
                      child: TextField(
                        controller: searchController,
                        focusNode: searchFocus,
                        enabled: true,
                        onEditingComplete: () {
                          setState(() {
                            searchFocus.unfocus();
                          });
                        },
                        onChanged: (value) {
                          setState(() {
                            setState(() {
                              searchPair = [];
                              for (int m = 0;
                              m < tradePair.length;
                              m++) {
                                if (tradePair[m]
                                    .baseAsset!
                                    .symbol
                                    .toString()
                                    .toLowerCase()
                                    .contains(value
                                    .toString()
                                    .toLowerCase()) ||
                                    tradePair[m]
                                        .marketAsset!
                                        .symbol
                                        .toString()
                                        .toLowerCase()
                                        .contains(value
                                        .toString()
                                        .toLowerCase()) ||
                                    tradePair[m]
                                        .displayName
                                        .toString()
                                        .toLowerCase()
                                        .contains(value
                                        .toString()
                                        .toLowerCase())) {
                                  searchPair.add(tradePair[m]);
                                }
                              }
                            });
                          });
                        },
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.only(
                              left: 12,
                              right: 0,
                              top: 8,
                              bottom: 8),
                          hintText: "Search",
                          hintStyle: TextStyle(
                              fontFamily: "FontRegular",
                              color: Theme.of(context).hintColor,
                              fontSize: 14.0,
                              fontWeight: FontWeight.w400),
                          filled: true,
                          fillColor: CustomTheme.of(context)
                              .backgroundColor
                              .withOpacity(0.5),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                                Radius.circular(5.0)),
                            borderSide: BorderSide(
                                color: CustomTheme.of(context)
                                    .splashColor
                                    .withOpacity(0.5),
                                width: 1.0),
                          ),
                          disabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                                Radius.circular(5.0)),
                            borderSide: BorderSide(
                                color: CustomTheme.of(context)
                                    .splashColor
                                    .withOpacity(0.5),
                                width: 1.0),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                                Radius.circular(5.0)),
                            borderSide: BorderSide(
                                color: CustomTheme.of(context)
                                    .splashColor
                                    .withOpacity(0.5),
                                width: 1.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                                Radius.circular(5.0)),
                            borderSide: BorderSide(
                                color: CustomTheme.of(context)
                                    .splashColor
                                    .withOpacity(0.5),
                                width: 1.0),
                          ),
                          errorBorder: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                                Radius.circular(5)),
                            borderSide: BorderSide(
                                color: Colors.red, width: 0.0),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                   Expanded(child:  ListView.builder(
                       controller: controller,
                       itemCount: searchPair.length,
                       itemBuilder:
                       ((BuildContext context, int index) {
                         return Column(
                           children: [
                             InkWell(
                               onTap: () {
                                 setState(() {});
                               },
                               child: Row(
                                 children: [
                                   const SizedBox(
                                     width: 20.0,
                                   ),
                                   Container(
                                     height: 25.0,
                                     width: 25.0,
                                     child: SvgPicture.network(
                                       "https://cifdaq.in/api/color/" +
                                           searchPair[index]
                                               .baseAsset!
                                               .assetname
                                               .toString()
                                               .toLowerCase() +
                                           ".svg",
                                       fit: BoxFit.cover,
                                     ),
                                   ),
                                   const SizedBox(
                                     width: 10.0,
                                   ),
                                   Text(
                                     searchPair[index]
                                         .displayName
                                         .toString(),
                                     style: CustomWidget(
                                         context: context)
                                         .CustomSizedTextStyle(
                                         16.0,
                                         Theme.of(context)
                                             .splashColor,
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
                               height: 1.0,
                               width: MediaQuery.of(context)
                                   .size
                                   .width,
                               color: CustomTheme.of(context)
                                   .backgroundColor,
                             ),
                             const SizedBox(
                               height: 5.0,
                             ),
                           ],
                         );
                       })),)
                  ],
                ),
              ),),
        ));
  }

  getCoinList() {
    apiUtils.getTradePair().then((TradePairListModel loginData) {
      if (loginData.statusCode == 200) {
        setState(() {
          tradePair = loginData.data!;
          tradePair = tradePair.reversed.toList();
          searchPair = tradePair.reversed.toList();
            loading = false;
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
