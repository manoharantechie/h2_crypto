import 'package:flutter/material.dart';
import 'package:h2_crypto/data/api_utils.dart';
import 'package:h2_crypto/data/crypt_model/common_model.dart';

import '../../common/colors.dart';
import '../../common/custom_widget.dart';
import '../../common/localization/localizations.dart';
import '../../common/textformfield_custom.dart';
import '../../common/theme/custom_theme.dart';

class AddBankScreen extends StatefulWidget {
  const AddBankScreen({Key? key}) : super(key: key);

  @override
  State<AddBankScreen> createState() => _AddBankScreenState();
}

class _AddBankScreenState extends State<AddBankScreen> {
  final List<String> trasnType = [
    "Individual",
    "Corporate",
  ];
  final List<String> accType = [
    "Checking",
    "Savings",
  ];
  final List<String> nationalType = [
    "False",
    "True",
  ];
  bool loading = false;
  String selectedtrasnType = "";
  String selectedaccType = "";
  String selectednationalType = "";


  TextEditingController fnameContoller = TextEditingController();
  TextEditingController lnameContoller = TextEditingController();
  TextEditingController accnumContoller = TextEditingController();
  TextEditingController routnumContoller = TextEditingController();
  TextEditingController wireroutnumContoller = TextEditingController();
  TextEditingController bankNameContoller = TextEditingController();
  TextEditingController swiftnumContoller = TextEditingController();
  TextEditingController wireInsContoller = TextEditingController();

  FocusNode fnameFocus = FocusNode();
  FocusNode lnameFocus = FocusNode();
  FocusNode accnumFocus = FocusNode();
  FocusNode routnumFocus = FocusNode();
  FocusNode wireroutnumFocus = FocusNode();
  FocusNode bankNameFocus = FocusNode();
  FocusNode swiftnumFocus = FocusNode();
  FocusNode wireInsFocus = FocusNode();
  APIUtils apiUtils = APIUtils();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    selectedtrasnType = trasnType.first;
    selectedaccType = accType.first;
    selectednationalType = nationalType.first;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        centerTitle: true,
        elevation: 0.0,
        backgroundColor: Theme.of(context).backgroundColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context, true),
        ),
        title: Text(
          "Link A Bank Account",
          style: CustomWidget(context: context).CustomSizedTextStyle(16.0,
              Theme.of(context).splashColor, FontWeight.w500, 'FontRegular'),
        ),
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
                CustomTheme.of(context).accentColor,
              ])),
          child: Stack(
            children: [
              SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(20.0, 5.0, 20.0, 5.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Form(
                          child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            "Type :",
                            style: CustomWidget(context: context)
                                .CustomTextStyle(
                                    Theme.of(context)
                                        .splashColor
                                        .withOpacity(0.6),
                                    FontWeight.w500,
                                    'FontRegular'),
                          ),
                          const SizedBox(
                            height: 10.0,
                          ),
                          Container(
                            height: 40.0,
                            padding: const EdgeInsets.only(
                                left: 10.0, right: 10.0, top: 0.0, bottom: 0.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5.0),
                              color: CustomTheme.of(context).cardColor,
                            ),
                            child: Center(
                              child: Theme(
                                data: Theme.of(context).copyWith(
                                  canvasColor:
                                      CustomTheme.of(context).cardColor,
                                ),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton(
                                    items: trasnType
                                        .map((value) => DropdownMenuItem(
                                              child: Text(
                                                value,
                                                style: CustomWidget(
                                                        context: context)
                                                    .CustomSizedTextStyle(
                                                        12.0,
                                                        Theme.of(context)
                                                            .splashColor,
                                                        FontWeight.w500,
                                                        'FontRegular'),
                                              ),
                                              value: value,
                                            ))
                                        .toList(),
                                    onChanged: (value) {
                                      setState(() {
                                        selectedtrasnType = value.toString();
                                      });
                                    },
                                    isExpanded: true,
                                    value: selectedtrasnType,
                                    icon: Icon(
                                      Icons.keyboard_arrow_down,
                                      color:
                                          CustomTheme.of(context).splashColor,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 10.0,
                          ),
                          Text(
                            "Bank Account Type :",
                            style: CustomWidget(context: context)
                                .CustomTextStyle(
                                    Theme.of(context)
                                        .splashColor
                                        .withOpacity(0.6),
                                    FontWeight.w500,
                                    'FontRegular'),
                          ),
                          const SizedBox(
                            height: 10.0,
                          ),
                          Container(
                            height: 40.0,
                            padding: const EdgeInsets.only(
                                left: 10.0, right: 10.0, top: 0.0, bottom: 0.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5.0),
                              color: CustomTheme.of(context).cardColor,
                            ),
                            child: Center(
                              child: Theme(
                                data: Theme.of(context).copyWith(
                                  canvasColor:
                                      CustomTheme.of(context).cardColor,
                                ),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton(
                                    items: accType
                                        .map((value) => DropdownMenuItem(
                                              child: Text(
                                                value,
                                                style: CustomWidget(
                                                        context: context)
                                                    .CustomSizedTextStyle(
                                                        12.0,
                                                        Theme.of(context)
                                                            .splashColor,
                                                        FontWeight.w500,
                                                        'FontRegular'),
                                              ),
                                              value: value,
                                            ))
                                        .toList(),
                                    onChanged: (value) {
                                      setState(() {
                                        selectedaccType = value.toString();
                                      });
                                    },
                                    isExpanded: true,
                                    value: selectedaccType,
                                    icon: Icon(
                                      Icons.keyboard_arrow_down,
                                      color:
                                          CustomTheme.of(context).splashColor,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 10.0,
                          ),
                          Text(
                            "is International? :",
                            style: CustomWidget(context: context)
                                .CustomTextStyle(
                                    Theme.of(context)
                                        .splashColor
                                        .withOpacity(0.6),
                                    FontWeight.w500,
                                    'FontRegular'),
                          ),
                          const SizedBox(
                            height: 10.0,
                          ),
                          Container(
                            height: 40.0,
                            padding: const EdgeInsets.only(
                                left: 10.0, right: 10.0, top: 0.0, bottom: 0.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5.0),
                              color: CustomTheme.of(context).cardColor,
                            ),
                            child: Center(
                              child: Theme(
                                data: Theme.of(context).copyWith(
                                  canvasColor:
                                      CustomTheme.of(context).cardColor,
                                ),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton(
                                    items: nationalType
                                        .map((value) => DropdownMenuItem(
                                              child: Text(
                                                value,
                                                style: CustomWidget(
                                                        context: context)
                                                    .CustomSizedTextStyle(
                                                        12.0,
                                                        Theme.of(context)
                                                            .splashColor,
                                                        FontWeight.w500,
                                                        'FontRegular'),
                                              ),
                                              value: value,
                                            ))
                                        .toList(),
                                    onChanged: (value) {
                                      setState(() {
                                        selectednationalType = value.toString();
                                      });
                                    },
                                    isExpanded: true,
                                    value: selectednationalType,
                                    icon: Icon(
                                      Icons.keyboard_arrow_down,
                                      color:
                                          CustomTheme.of(context).splashColor,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 10.0,
                          ),
                          Text(
                            "First Name :",
                            style: CustomWidget(context: context)
                                .CustomTextStyle(
                                    Theme.of(context)
                                        .splashColor
                                        .withOpacity(0.6),
                                    FontWeight.w500,
                                    'FontRegular'),
                          ),
                          const SizedBox(
                            height: 10.0,
                          ),
                          TextFormFieldCustom(
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            onEditComplete: () {
                              fnameFocus.unfocus();
                              FocusScope.of(context).requestFocus(lnameFocus);
                            },
                            radius: 5.0,
                            // inputFormatters: [
                            //   FilteringTextInputFormatter.allow(RegExp(r'[A-Za-z@0-9!_.]')),
                            // ],
                            error: "Enter First Name",
                            textColor: CustomTheme.of(context).splashColor,
                            borderColor: CustomTheme.of(context)
                                .splashColor
                                .withOpacity(0.5),
                            fillColor: CustomTheme.of(context)
                                .backgroundColor
                                .withOpacity(0.5),
                            textInputAction: TextInputAction.next,
                            focusNode: fnameFocus,
                            maxlines: 1,
                            text: '',
                            hintText: "First Name",
                            obscureText: false,
                            suffix: Container(
                              width: 0.0,
                            ),
                            textChanged: (value) {},
                            onChanged: () {},
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Please enter First name";
                              }

                              return null;
                            },
                            enabled: true,
                            textInputType: TextInputType.name,
                            controller: fnameContoller,
                            hintStyle: CustomWidget(context: context)
                                .CustomTextStyle(
                                    Theme.of(context)
                                        .splashColor
                                        .withOpacity(0.5),
                                    FontWeight.w300,
                                    'FontRegular'),
                            textStyle: CustomWidget(context: context)
                                .CustomTextStyle(Theme.of(context).splashColor,
                                    FontWeight.w400, 'FontRegular'),
                          ),
                          const SizedBox(
                            height: 10.0,
                          ),
                          Text(
                            "Last Name :",
                            style: CustomWidget(context: context)
                                .CustomTextStyle(
                                    Theme.of(context)
                                        .splashColor
                                        .withOpacity(0.6),
                                    FontWeight.w500,
                                    'FontRegular'),
                          ),
                          const SizedBox(
                            height: 10.0,
                          ),
                          TextFormFieldCustom(
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            onEditComplete: () {
                              lnameFocus.unfocus();
                              FocusScope.of(context).requestFocus(accnumFocus);
                            },
                            radius: 5.0,
                            // inputFormatters: [
                            //   FilteringTextInputFormatter.allow(RegExp(r'[A-Za-z@0-9!_.]')),
                            // ],
                            error: "Enter Last name",
                            textColor: CustomTheme.of(context).splashColor,
                            borderColor: CustomTheme.of(context)
                                .splashColor
                                .withOpacity(0.5),
                            fillColor: CustomTheme.of(context)
                                .backgroundColor
                                .withOpacity(0.5),
                            textInputAction: TextInputAction.next,
                            focusNode: lnameFocus,
                            maxlines: 1,
                            text: '',
                            hintText: "Last Name",
                            obscureText: false,
                            suffix: Container(
                              width: 0.0,
                            ),
                            textChanged: (value) {},
                            onChanged: () {},
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Please enter Last name";
                              }

                              return null;
                            },
                            enabled: true,
                            textInputType: TextInputType.name,
                            controller: lnameContoller,
                            hintStyle: CustomWidget(context: context)
                                .CustomTextStyle(
                                    Theme.of(context)
                                        .splashColor
                                        .withOpacity(0.5),
                                    FontWeight.w300,
                                    'FontRegular'),
                            textStyle: CustomWidget(context: context)
                                .CustomTextStyle(Theme.of(context).splashColor,
                                    FontWeight.w400, 'FontRegular'),
                          ),
                          const SizedBox(
                            height: 10.0,
                          ),
                          Text(
                            "Account Number :",
                            style: CustomWidget(context: context)
                                .CustomTextStyle(
                                    Theme.of(context)
                                        .splashColor
                                        .withOpacity(0.6),
                                    FontWeight.w500,
                                    'FontRegular'),
                          ),
                          const SizedBox(
                            height: 10.0,
                          ),
                          TextFormFieldCustom(
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            onEditComplete: () {
                              accnumFocus.unfocus();
                              FocusScope.of(context).requestFocus(routnumFocus);
                            },
                            radius: 5.0,
                            // inputFormatters: [
                            //   FilteringTextInputFormatter.allow(RegExp(r'[A-Za-z@0-9!_.]')),
                            // ],
                            error: "Enter Account number",
                            textColor: CustomTheme.of(context).splashColor,
                            borderColor: CustomTheme.of(context)
                                .splashColor
                                .withOpacity(0.5),
                            fillColor: CustomTheme.of(context)
                                .backgroundColor
                                .withOpacity(0.5),
                            textInputAction: TextInputAction.next,
                            focusNode: accnumFocus,
                            maxlines: 1,
                            text: '',
                            hintText: "Account Number",
                            obscureText: false,
                            suffix: Container(
                              width: 0.0,
                            ),
                            textChanged: (value) {},
                            onChanged: () {},
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Please enter Account Number";
                              }

                              return null;
                            },
                            enabled: true,
                            textInputType: TextInputType.number,
                            controller: accnumContoller,
                            hintStyle: CustomWidget(context: context)
                                .CustomTextStyle(
                                    Theme.of(context)
                                        .splashColor
                                        .withOpacity(0.5),
                                    FontWeight.w300,
                                    'FontRegular'),
                            textStyle: CustomWidget(context: context)
                                .CustomTextStyle(Theme.of(context).splashColor,
                                    FontWeight.w400, 'FontRegular'),
                          ),
                          const SizedBox(
                            height: 10.0,
                          ),
                          Text(
                            "Routing Number :",
                            style: CustomWidget(context: context)
                                .CustomTextStyle(
                                    Theme.of(context)
                                        .splashColor
                                        .withOpacity(0.6),
                                    FontWeight.w500,
                                    'FontRegular'),
                          ),
                          const SizedBox(
                            height: 10.0,
                          ),
                          TextFormFieldCustom(
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            onEditComplete: () {
                              routnumFocus.unfocus();
                              FocusScope.of(context)
                                  .requestFocus(wireroutnumFocus);
                            },
                            radius: 5.0,
                            // inputFormatters: [
                            //   FilteringTextInputFormatter.allow(RegExp(r'[A-Za-z@0-9!_.]')),
                            // ],
                            error: "Enter Routing number",
                            textColor: CustomTheme.of(context).splashColor,
                            borderColor: CustomTheme.of(context)
                                .splashColor
                                .withOpacity(0.5),
                            fillColor: CustomTheme.of(context)
                                .backgroundColor
                                .withOpacity(0.5),
                            textInputAction: TextInputAction.next,
                            focusNode: routnumFocus,
                            maxlines: 1,
                            text: '',
                            hintText: "Routing Number",
                            obscureText: false,
                            suffix: Container(
                              width: 0.0,
                            ),
                            textChanged: (value) {},
                            onChanged: () {},
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Please enter Routing Number";
                              }

                              return null;
                            },
                            enabled: true,
                            textInputType: TextInputType.number,
                            controller: routnumContoller,
                            hintStyle: CustomWidget(context: context)
                                .CustomTextStyle(
                                    Theme.of(context)
                                        .splashColor
                                        .withOpacity(0.5),
                                    FontWeight.w300,
                                    'FontRegular'),
                            textStyle: CustomWidget(context: context)
                                .CustomTextStyle(Theme.of(context).splashColor,
                                    FontWeight.w400, 'FontRegular'),
                          ),
                          const SizedBox(
                            height: 10.0,
                          ),
                          Text(
                            "Wire Routing Number :",
                            style: CustomWidget(context: context)
                                .CustomTextStyle(
                                    Theme.of(context)
                                        .splashColor
                                        .withOpacity(0.6),
                                    FontWeight.w500,
                                    'FontRegular'),
                          ),
                          const SizedBox(
                            height: 10.0,
                          ),
                          TextFormFieldCustom(
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            onEditComplete: () {
                              wireroutnumFocus.unfocus();
                              FocusScope.of(context)
                                  .requestFocus(bankNameFocus);
                            },
                            radius: 5.0,
                            // inputFormatters: [
                            //   FilteringTextInputFormatter.allow(RegExp(r'[A-Za-z@0-9!_.]')),
                            // ],
                            error: "Enter Wire Routing number",
                            textColor: CustomTheme.of(context).splashColor,
                            borderColor: CustomTheme.of(context)
                                .splashColor
                                .withOpacity(0.5),
                            fillColor: CustomTheme.of(context)
                                .backgroundColor
                                .withOpacity(0.5),
                            textInputAction: TextInputAction.next,
                            focusNode: wireroutnumFocus,
                            maxlines: 1,
                            text: '',
                            hintText: "Wire Routing Number",
                            obscureText: false,
                            suffix: Container(
                              width: 0.0,
                            ),
                            textChanged: (value) {},
                            onChanged: () {},
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Please enter Account Number";
                              }

                              return null;
                            },
                            enabled: true,
                            textInputType: TextInputType.number,
                            controller: wireroutnumContoller,
                            hintStyle: CustomWidget(context: context)
                                .CustomTextStyle(
                                    Theme.of(context)
                                        .splashColor
                                        .withOpacity(0.5),
                                    FontWeight.w300,
                                    'FontRegular'),
                            textStyle: CustomWidget(context: context)
                                .CustomTextStyle(Theme.of(context).splashColor,
                                    FontWeight.w400, 'FontRegular'),
                          ),
                          const SizedBox(
                            height: 10.0,
                          ),
                          Text(
                            "Bank Name :",
                            style: CustomWidget(context: context)
                                .CustomTextStyle(
                                    Theme.of(context)
                                        .splashColor
                                        .withOpacity(0.6),
                                    FontWeight.w500,
                                    'FontRegular'),
                          ),
                          const SizedBox(
                            height: 10.0,
                          ),
                          TextFormFieldCustom(
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            onEditComplete: () {
                              bankNameFocus.unfocus();
                              FocusScope.of(context)
                                  .requestFocus(swiftnumFocus);
                            },
                            radius: 5.0,
                            // inputFormatters: [
                            //   FilteringTextInputFormatter.allow(RegExp(r'[A-Za-z@0-9!_.]')),
                            // ],
                            error: "Enter Bank Name",
                            textColor: CustomTheme.of(context).splashColor,
                            borderColor: CustomTheme.of(context)
                                .splashColor
                                .withOpacity(0.5),
                            fillColor: CustomTheme.of(context)
                                .backgroundColor
                                .withOpacity(0.5),
                            textInputAction: TextInputAction.next,
                            focusNode: bankNameFocus,
                            maxlines: 1,
                            text: '',
                            hintText: "Bank Name",
                            obscureText: false,
                            suffix: Container(
                              width: 0.0,
                            ),
                            textChanged: (value) {},
                            onChanged: () {},
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Please enter Bank Name";
                              }

                              return null;
                            },
                            enabled: true,
                            textInputType: TextInputType.text,
                            controller: bankNameContoller,
                            hintStyle: CustomWidget(context: context)
                                .CustomTextStyle(
                                    Theme.of(context)
                                        .splashColor
                                        .withOpacity(0.5),
                                    FontWeight.w300,
                                    'FontRegular'),
                            textStyle: CustomWidget(context: context)
                                .CustomTextStyle(Theme.of(context).splashColor,
                                    FontWeight.w400, 'FontRegular'),
                          ),
                          const SizedBox(
                            height: 10.0,
                          ),
                          Text(
                            "Swift Number :",
                            style: CustomWidget(context: context)
                                .CustomTextStyle(
                                    Theme.of(context)
                                        .splashColor
                                        .withOpacity(0.6),
                                    FontWeight.w500,
                                    'FontRegular'),
                          ),
                          const SizedBox(
                            height: 10.0,
                          ),
                          TextFormFieldCustom(
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            onEditComplete: () {
                              swiftnumFocus.unfocus();
                              // FocusScope.of(context).requestFocus(emailPassFocus);
                            },
                            radius: 5.0,
                            // inputFormatters: [
                            //   FilteringTextInputFormatter.allow(RegExp(r'[A-Za-z@0-9!_.]')),
                            // ],
                            error: "Enter Swift Number",
                            textColor: CustomTheme.of(context).splashColor,
                            borderColor: CustomTheme.of(context)
                                .splashColor
                                .withOpacity(0.5),
                            fillColor: CustomTheme.of(context)
                                .backgroundColor
                                .withOpacity(0.5),
                            textInputAction: TextInputAction.next,
                            focusNode: swiftnumFocus,
                            maxlines: 1,
                            text: '',
                            hintText: "Swift Number",
                            obscureText: false,
                            suffix: Container(
                              width: 0.0,
                            ),
                            textChanged: (value) {},
                            onChanged: () {},
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Please enter Swift Number";
                              }

                              return null;
                            },
                            enabled: true,
                            textInputType: TextInputType.text,
                            controller: swiftnumContoller,
                            hintStyle: CustomWidget(context: context)
                                .CustomTextStyle(
                                    Theme.of(context)
                                        .splashColor
                                        .withOpacity(0.5),
                                    FontWeight.w300,
                                    'FontRegular'),
                            textStyle: CustomWidget(context: context)
                                .CustomTextStyle(Theme.of(context).splashColor,
                                    FontWeight.w400, 'FontRegular'),
                          ),
                          const SizedBox(
                            height: 10.0,
                          ),
                          selectednationalType == "True"
                              ? Text(
                                  "Wire Instructions :",
                                  style: CustomWidget(context: context)
                                      .CustomTextStyle(
                                          Theme.of(context)
                                              .splashColor
                                              .withOpacity(0.6),
                                          FontWeight.w500,
                                          'FontRegular'),
                                )
                              : Container(),
                          const SizedBox(
                            height: 10.0,
                          ),
                          selectednationalType == "True"
                              ? TextFormFieldCustom(
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  onEditComplete: () {
                                    wireInsFocus.unfocus();
                                    // FocusScope.of(context).requestFocus(emailPassFocus);
                                  },
                                  radius: 5.0,
                                  // inputFormatters: [
                                  //   FilteringTextInputFormatter.allow(RegExp(r'[A-Za-z@0-9!_.]')),
                                  // ],
                                  error: "Enter Wire Instructions",
                                  textColor:
                                      CustomTheme.of(context).splashColor,
                                  borderColor: CustomTheme.of(context)
                                      .splashColor
                                      .withOpacity(0.5),
                                  fillColor: CustomTheme.of(context)
                                      .backgroundColor
                                      .withOpacity(0.5),
                                  textInputAction: TextInputAction.next,
                                  focusNode: wireInsFocus,
                                  maxlines: 1,
                                  text: '',
                                  hintText: "Wire Instructions",
                                  obscureText: false,
                                  suffix: Container(
                                    width: 0.0,
                                  ),
                                  textChanged: (value) {},
                                  onChanged: () {},
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return "Please enter Wire Instructions";
                                    }

                                    return null;
                                  },
                                  enabled: true,
                                  textInputType: TextInputType.text,
                                  controller: wireInsContoller,
                                  hintStyle: CustomWidget(context: context)
                                      .CustomTextStyle(
                                          Theme.of(context)
                                              .splashColor
                                              .withOpacity(0.5),
                                          FontWeight.w300,
                                          'FontRegular'),
                                  textStyle: CustomWidget(context: context)
                                      .CustomTextStyle(
                                          Theme.of(context).splashColor,
                                          FontWeight.w400,
                                          'FontRegular'),
                                )
                              : Container(),
                          const SizedBox(
                            height: 40.0,
                          ),
                          InkWell(
                            onTap: () {
                              setState(() {});
                            },
                            child: Container(
                                decoration: BoxDecoration(
                                  color: CustomTheme.of(context).buttonColor,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5.0)),
                                ),
                                padding: const EdgeInsets.only(
                                    top: 13.0, bottom: 13.0),
                                child: Center(
                                  child: Text(
                                    AppLocalizations.instance
                                        .text("loc_submit"),
                                    style: CustomWidget(context: context)
                                        .CustomTextStyle(
                                            CustomTheme.of(context).splashColor,
                                            FontWeight.w500,
                                            'FontRegular'),
                                  ),
                                )),
                          ),
                          const SizedBox(
                            height: 30.0,
                          ),
                        ],
                      ))
                    ],
                  ),
                ),
              ),
              loading
                  ? CustomWidget(context: context).loadingIndicator(
                      CustomTheme.of(context).splashColor,
                    )
                  : Container()
            ],
          )),
    );
  }

  addBank(String id) {
    apiUtils.addbankDetails(selectedaccType.toString(),selectedtrasnType.toString(),selectednationalType.toString(),fnameContoller.text.toString(),lnameContoller.text.toString(),
        accnumContoller.text.toString(),bankNameContoller.text.toString(),swiftnumContoller.text.toString(),wireInsContoller.text.toString(),wireroutnumContoller.text.toString(),routnumContoller.text.toString()).then((CommonModel loginData) {
      if (loginData.status!) {
        setState(() {
          CustomWidget(context: context)
              .custombar("H2Crypto", loginData.message.toString(), true);

          Navigator.pop(context);
        });
      } else {
        setState(() {
          loading = false;
          CustomWidget(context: context)
              .custombar("H2Crypto", loginData.message.toString(), false);
        });
      }
    }).catchError((Object error) {
      setState(() {
        loading = false;
      });
    });
  }
}
