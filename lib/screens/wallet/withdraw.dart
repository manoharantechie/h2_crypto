import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';


import '../../../common/colors.dart';
import '../../../common/custom_button.dart';
import '../../../common/custom_widget.dart';
import '../../../common/localization/localizations.dart';
import '../../../common/theme/custom_theme.dart';

class WithDraw extends StatefulWidget {
  const WithDraw({Key? key}) : super(key: key);

  @override
  State<WithDraw> createState() => _WithDrawState();
}

class _WithDrawState extends State<WithDraw> {
  List<String> idType = [
    "ERC 20",
    "ERC 22",
    "h2_crypto",
  ];
  String selectedId = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    selectedId = idType.first;
  }

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
                height: 22.0,
                width: 22.0,
                allowDrawingOutsideViewBox: true,
                color: CustomTheme.of(context).splashColor,
              ),
            )),
        centerTitle: true,
        title: Text(
          AppLocalizations.instance.text("loc_withdraw"),
          style: CustomWidget(context: context)
              .CustomSizedTextStyle(
              16.0,
              Theme.of(context).splashColor,
              FontWeight.w400,
              'FontRegular'),
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
        child: Padding(
          padding: EdgeInsets.fromLTRB(15.0, 0.0, 15.0, 0.0),
          child: Stack(
            children: [
              Container(
                padding: EdgeInsets.only(top: 15.0,bottom: 15.0),
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.18,
                decoration: BoxDecoration(
                  color:
                  CustomTheme.of(context).buttonColor.withOpacity(0.2),
                  borderRadius: BorderRadius.all(
                    Radius.circular(5.0),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                 Container(

                   child:    Row(
                     crossAxisAlignment: CrossAxisAlignment.center,
                     mainAxisAlignment: MainAxisAlignment.center,
                     children: [
                       SvgPicture.asset(
                         'assets/images/horse_icon.svg',
                         height: 40.0,
                         width: 40.0,
                       ),
                       SizedBox(
                         width: 10.0,
                       ),
                       Text(
                         "1INCH",
                         style: CustomWidget(context: context)
                             .CustomSizedTextStyle(
                             14.0,
                             Theme.of(context).splashColor,
                             FontWeight.w400,
                             'FontRegular'),
                       ),
                       Text(
                         "-1INCH",
                         style: CustomWidget(context: context)
                             .CustomSizedTextStyle(
                             12.0,
                             Theme.of(context).splashColor.withOpacity(0.5),
                             FontWeight.w400,
                             'FontRegular'),
                       ),
                     ],
                   ),
                   width: MediaQuery.of(context).size.width,
                 ),
                    SizedBox(
                      height: 15.0,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        const SizedBox(width: 15.0,),
                        Column(
                          children: [
                            Text(
                              "Available",
                              style: CustomWidget(context: context)
                                  .CustomSizedTextStyle(
                                  12.0,
                                  Theme.of(context).splashColor.withOpacity(0.5),
                                  FontWeight.w400,
                                  'FontRegular'),
                            ),
                            Text(
                              "0",
                              style: CustomWidget(context: context)
                                  .CustomSizedTextStyle(
                                  14.0,
                                  Theme.of(context).splashColor,
                                  FontWeight.w400,
                                  'FontRegular'),
                            ),
                          ],
                        ),

                        Container(
                          width: 1.0,
                          height: 40.0,
                          decoration: BoxDecoration(
                              color: CustomTheme.of(context)
                                  .splashColor
                                  .withOpacity(0.5),
                              borderRadius: BorderRadius.circular(5.0)),
                        ),

                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "Valuation(USD)",
                              style: CustomWidget(context: context)
                                  .CustomSizedTextStyle(
                                  12.0,
                                  Theme.of(context).splashColor.withOpacity(0.5),
                                  FontWeight.w400,
                                  'FontRegular'),
                            ),
                            Text(
                              "~0.00",
                              style: CustomWidget(context: context)
                                  .CustomSizedTextStyle(
                                  14.0,
                                  Theme.of(context).splashColor,
                                  FontWeight.w400,
                                  'FontRegular'),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                      ],
                    ),

                  ],
                ),
              ),

              Container(
                  margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.2,),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Container(
                          padding: EdgeInsets.fromLTRB(10.0, 5, 10.0, 0),

                          decoration: BoxDecoration(
                            color: CustomTheme.of(context)
                                .buttonColor
                                .withOpacity(0.2),
                            borderRadius: BorderRadius.all(
                              Radius.circular(5.0),
                            ),
                          ),
                          child: Row(
                            children: [
                              Flexible(
                                child: TextField(
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: 'Input or paste your address',
                                    hintStyle: TextStyle(
                                      fontSize: 12.0,
                                      color: CustomTheme.of(context)
                                          .splashColor
                                          .withOpacity(0.5),
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              Row(
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Padding(
                                    padding:
                                    EdgeInsets.fromLTRB(0, 0, 8, 0),
                                    child: SvgPicture.asset(
                                      'assets/images/Retina_scan.svg',
                                      height: 10.0,
                                      width: 10.0,
                                      allowDrawingOutsideViewBox: true,
                                      color:
                                      CustomTheme.of(context).hintColor,
                                    ),
                                  ),
                                  SvgPicture.asset(
                                    'assets/images/location.svg',
                                    height: 10.0,
                                    width: 10.0,
                                    allowDrawingOutsideViewBox: true,
                                    color:
                                    CustomTheme.of(context).hintColor,
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.fromLTRB(12.0, 0.0, 12, 0.0),
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: CustomTheme.of(context).cardColor,
                                width: 1.0),
                            borderRadius: BorderRadius.circular(5.0),
                            color: CustomTheme.of(context)
                                .backgroundColor
                                .withOpacity(0.5),
                          ),
                          child: Theme(
                            data: Theme.of(context).copyWith(
                              canvasColor: CustomTheme.of(context).cardColor,
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton(
                                menuMaxHeight:
                                MediaQuery.of(context).size.height * 0.7,
                                items: idType
                                    .map((value) => DropdownMenuItem(
                                  child: Text(
                                    value.toString(),
                                    style: CustomWidget(context: context)
                                        .CustomSizedTextStyle(
                                        14.0,
                                        Theme.of(context).hintColor,
                                        FontWeight.w400,
                                        'FontRegular'),
                                  ),
                                  value: value,
                                ))
                                    .toList(),
                                onChanged: (value) async {
                                  setState(() {
                                    selectedId = value.toString();
                                  });
                                },
                                hint: Text(
                                  "Select Category",
                                  style: CustomWidget(context: context)
                                      .CustomSizedTextStyle(
                                      14.0,
                                      Theme.of(context).hintColor.withOpacity(0.5),
                                      FontWeight.w400,
                                      'FontRegular'),
                                ),
                                isExpanded: true,
                                value: selectedId,
                                icon: const Icon(
                                  Icons.arrow_drop_down,
                                  // color: AppColors.otherTextColor,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Container(
                          padding: EdgeInsets.fromLTRB(10.0, 5, 10.0, 5),
                          decoration: BoxDecoration(
                            color: CustomTheme.of(context)
                                .buttonColor
                                .withOpacity(0.2),
                            borderRadius: BorderRadius.all(
                              Radius.circular(5.0),
                            ),
                          ),
                          child: Row(
                            children: [
                              Flexible(
                                child: TextField(
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: 'Withdrawal volume',
                                    hintStyle: TextStyle(
                                      fontSize: 12.0,
                                      color: CustomTheme.of(context)
                                          .splashColor
                                          .withOpacity(0.5),
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 10.0,
                              ),
                              Row(
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Padding(
                                    padding:
                                    EdgeInsets.fromLTRB(0, 0, 8, 0),
                                    child: Text(
                                      "1INCH",
                                      textAlign: TextAlign.center,
                                      style: CustomWidget(context: context)
                                          .CustomSizedTextStyle(
                                          10.0,
                                          Theme.of(context).hintColor.withOpacity(0.5),
                                          FontWeight.w400,
                                          'FontRegular'),
                                    ),
                                  ),
                                  Text(
                                    "All",
                                    textAlign: TextAlign.center,
                                    style: CustomWidget(context: context)
                                        .CustomSizedTextStyle(
                                        10.0,
                                        Theme.of(context).splashColor,
                                        FontWeight.w400,
                                        'FontRegular'),
                                  ),
                                ],
                              ),

                            ],
                          ),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Received 0",
                              textAlign: TextAlign.center,
                              style: CustomWidget(context: context)
                                  .CustomSizedTextStyle(
                                  10.0,
                                  Theme.of(context).hintColor.withOpacity(0.5),
                                  FontWeight.w400,
                                  'FontRegular'),
                            ),
                            Text(
                              "Feel 15.52",
                              textAlign: TextAlign.center,
                              style: CustomWidget(context: context)
                                  .CustomSizedTextStyle(
                                  10.0,
                                  Theme.of(context).hintColor.withOpacity(0.5),
                                  FontWeight.w400,
                                  'FontRegular'),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        TextFormField(
                          // controller: email,
                          // focusNode: emailFocus,
                          maxLines: 1,
                          // enabled: emailVerify,
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.emailAddress,
                          style: CustomWidget(context: context)
                              .CustomTextStyle(
                              Theme.of(context).splashColor,
                              FontWeight.w400,
                              'FontRegular'),
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.only(
                                left: 12, right: 0, top: 2, bottom: 2),
                            hintText: "Cash withdrawal notes (optional)",
                            hintStyle: CustomWidget(context: context)
                                .CustomSizedTextStyle(
                                12.0,
                                Theme.of(context).splashColor.withOpacity(0.5),
                                FontWeight.w300,
                                'FontRegular'),
                            filled: true,
                            fillColor: CustomTheme.of(context)
                                .backgroundColor
                                .withOpacity(0.5),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                              borderSide: BorderSide(
                                  color: CustomTheme.of(context).cardColor,
                                  width: 1.0),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                              borderSide: BorderSide(
                                  color: CustomTheme.of(context).cardColor,
                                  width: 0.5),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                              borderSide: BorderSide(
                                  color: CustomTheme.of(context).cardColor,
                                  width: 1.0),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                              borderSide: BorderSide(
                                  color: CustomTheme.of(context).cardColor,
                                  width: 1.0),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Text(
                          "H2Crypto’s API allows users to make market inquiries, trade automatically and perform various other tasks. You may find out more here",
                          style: CustomWidget(context: context)
                              .CustomSizedTextStyle(
                              12.0,
                              Theme.of(context).splashColor.withOpacity(0.5),
                              FontWeight.w400,
                              'FontRegular'),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Text(
                          "Each user may create up to 5 groups of API keys. The platform currently supports most mainstream currencies. For a full list of supported currencies, click here.",
                          style: CustomWidget(context: context)
                              .CustomSizedTextStyle(
                              12.0,
                              Theme.of(context).splashColor.withOpacity(0.5),
                              FontWeight.w400,
                              'FontRegular'),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Text(
                          "Please keep your API key confidential to protect your account. For security reasons, we recommend you link your IP address with your API key. To link your API Key with multiple addresses, you may separate each of them with a comma such as 192.168.1.1, 192.168.1.2, 192.168.1.3. Each API key can be linked with up to 4 IP addresses.",
                          style: CustomWidget(context: context)
                              .CustomSizedTextStyle(
                              12.0,
                              Theme.of(context).splashColor.withOpacity(0.5),
                              FontWeight.w400,
                              'FontRegular'),
                        ),
                        SizedBox(
                          height: 35.0,
                        ),
                        ButtonCustom(
                            text:
                            AppLocalizations.instance.text("loc_confirm"),
                            iconEnable: false,
                            radius: 5.0,
                            icon: "",
                            textStyle: CustomWidget(context: context)
                                .CustomSizedTextStyle(
                                13.0,
                                Theme.of(context).splashColor,
                                FontWeight.w500,
                                'FontRegular'),
                            iconColor: CustomTheme.of(context).buttonColor,
                            buttonColor: CustomTheme.of(context).buttonColor,
                            splashColor: CustomTheme.of(context).buttonColor,
                            onPressed: () {
                              // Navigator.push(
                              //     context,
                              //     MaterialPageRoute(
                              //       builder: (context) => const SetNameScreen3(),
                              //     ));
                            },
                            paddng: 1.0),
                        SizedBox(
                          height: 20.0,
                        ),
                      ],
                    ),
                  )
              ),
            ],
          )
        ),
      ),
    );
  }
}
