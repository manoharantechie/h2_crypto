import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:h2_crypto/data/api_utils.dart';
import 'package:h2_crypto/data/model/common_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../common/colors.dart';
import '../../../common/custom_button.dart';
import '../../../common/custom_widget.dart';
import '../../../common/localization/localizations.dart';
import '../../../common/textformfield_custom.dart';
import '../../../common/theme/custom_theme.dart';

class SetNameScreen extends StatefulWidget {
  const SetNameScreen({Key? key}) : super(key: key);

  @override
  State<SetNameScreen> createState() => _SetNameScreen1State();
}

class _SetNameScreen1State extends State<SetNameScreen> {
  @override
  FocusNode textVerifyFocus = FocusNode();
  TextEditingController textValue = TextEditingController();

  bool loading=false;

  APIUtils apiUtils=APIUtils();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: CustomTheme.of(context).primaryColor,
        elevation: 0.0,
        title: Text(
          AppLocalizations.instance.text("loc_nick_setting"),
          style: CustomWidget(context: context).CustomSizedTextStyle(17.0,
              Theme.of(context).splashColor, FontWeight.w500, 'FontRegular'),
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
              padding: EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppLocalizations.instance.text("loc_nick_nme"),
                        style: CustomWidget(context: context)
                            .CustomSizedTextStyle(
                                14.0,
                                Theme.of(context).splashColor,
                                FontWeight.w500,
                                'FontRegular'),
                      ),
                      const SizedBox(
                        height: 15.0,
                      ),
                      TextFormFieldCustom(
                        onEditComplete: () {
                          textVerifyFocus.unfocus();
                        },
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp(r'[A-Za-z0-9@._]')),
                        ],
                        radius: 5.0,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        error: "Enter Valid Email",
                        textColor: Theme.of(context).splashColor,
                        borderColor:
                            Theme.of(context).splashColor.withOpacity(0.5),
                        fillColor: Theme.of(context).primaryColor,
                        textInputAction: TextInputAction.done,
                        focusNode: textVerifyFocus,
                        maxlines: 1,
                        text: '',
                        hintText: "Limited 10 Characters",
                        obscureText: false,
                        suffix: Container(
                          width: 0.0,
                        ),
                        textChanged: (value) {},
                        onChanged: () {},
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Please enter Code";
                          }

                          return null;
                        },
                        enabled: true,
                        textInputType: TextInputType.text,
                        controller: textValue,
                        hintStyle: CustomWidget(context: context)
                            .CustomSizedTextStyle(
                                12.0,
                                Theme.of(context).splashColor.withOpacity(0.5),
                                FontWeight.normal,
                                'FontRegular'),
                        textStyle: CustomWidget(context: context)
                            .CustomTextStyle(Theme.of(context).splashColor,
                                FontWeight.normal, 'FontRegular'),
                      ),
                      const SizedBox(
                        height: 15.0,
                      ),
                      ButtonCustom(
                          text: AppLocalizations.instance.text("loc_submit"),
                          iconEnable: false,
                          radius: 5.0,
                          icon: "",
                          textStyle: CustomWidget(context: context)
                              .CustomSizedTextStyle(
                                  14.0,
                                  Theme.of(context).splashColor,
                                  FontWeight.w500,
                                  'FontRegular'),
                          iconColor: CustomTheme.of(context).buttonColor,
                          buttonColor: CustomTheme.of(context).buttonColor,
                          splashColor: CustomTheme.of(context).buttonColor,
                          onPressed: () {
                            setState(() {
                              print(textValue.text.length);
                              if(textValue.text.isEmpty){
                                CustomWidget(context: context)
                                    .custombar("Nick name", "Enter the nick name", false);
                              }
                              else if(textValue.text.length < 10)
                                {
                                  CustomWidget(context: context)
                                      .custombar("Nick name", "Enter the nick name length above 10 characters", false);
                                }
                              else
                                {
                                  loading=true;
                                  changeName();
                                }
                            });
                          },
                          paddng: 1.0),
                      const SizedBox(
                        height: 15.0,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            "Notes :".toUpperCase(),
                            style: CustomWidget(context: context)
                                .CustomSizedTextStyle(
                                    13.0,
                                    Theme.of(context)
                                        .scaffoldBackgroundColor,
                                    FontWeight.w600,
                                    'FontRegular'),
                          ),
                          const SizedBox(
                            height: 10.0,
                          ),
                          Text(
                            "1. Your nickname can only be set and change three times. Please edit it carefully.",
                            style: CustomWidget(context: context)
                                .CustomSizedTextStyle(
                                    11.0,
                                    Theme.of(context)
                                        .splashColor,
                                    FontWeight.w400,
                                    'FontRegular'),
                            textAlign: TextAlign.justify,
                          ),
                          const SizedBox(
                            height: 5.0,
                          ),
                          Text(
                            "2. Your nickname will be reviewed. If any insulting, political sensitive words involved, your nickname will not pass the review. ",
                            style: CustomWidget(context: context)
                                .CustomSizedTextStyle(
                                    11.0,
                                    Theme.of(context)
                                        .splashColor,
                                    FontWeight.w400,
                                    'FontRegular'),
                            textAlign: TextAlign.justify,
                          ),
                          const SizedBox(
                            height: 5.0,
                          ),
                          Text(
                            "3. Your nickname will be reviewed occasionally. If any rule violations are found, your nickname will become invalid and you'll have to apply to another one.",
                            style: CustomWidget(context: context)
                                .CustomSizedTextStyle(
                                    11.0,
                                    Theme.of(context)
                                        .splashColor,
                                    FontWeight.w400,
                                    'FontRegular'),
                            textAlign: TextAlign.justify,
                          ),
                          const SizedBox(
                            height: 5.0,
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 15.0,
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 15.0,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  changeName() {
    apiUtils.updateUserName(textValue.text.toString()).then((CommonModel loginData) {
      if (loginData.status == 200) {
        setState(() {
          loading = false;
          setName(textValue.text.toString());
          Navigator.pop(context,true);
          CustomWidget(context: context).  custombar("Set Name", loginData.message.toString(), true);


        });
      } else {
        setState(() {
          loading=false;
          CustomWidget(context: context).  custombar("Set Name", loginData.message.toString(), false);

        });
      }
    }).catchError((Object error) {
      setState(() {
        loading = false;
      });
    });
  }

  setName(String name)async{
    SharedPreferences preferences=await SharedPreferences.getInstance();
    preferences.setString("name", name);
  }
}
