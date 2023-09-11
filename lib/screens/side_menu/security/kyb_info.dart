import 'dart:convert';

import 'package:country_calling_code_picker/picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';

import 'package:h2_crypto/common/colors.dart';
import 'package:h2_crypto/common/country.dart';
import 'package:h2_crypto/data/api_utils.dart';
import 'package:h2_crypto/data/crypt_model/common_model.dart';
import 'package:h2_crypto/data/crypt_model/country_code.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io' as Io;
import 'dart:convert';

import '../../../common/custom_button.dart';
import '../../../common/custom_widget.dart';
import '../../../common/localization/localizations.dart';
import '../../../common/theme/custom_theme.dart';

import 'link_email_address.dart';

class KYBPage extends StatefulWidget {
  const KYBPage({Key? key}) : super(key: key);

  @override
  State<KYBPage> createState() => _KYCPageState();
}

class _KYCPageState extends State<KYBPage> {
  Country? _selectedCountry;
  Country? _selectedPrincipalCountry;
  DateTime? selectedDateOfBirth;
  DateTime? selectedExpiryDate;
  DateTime? selectedExDate;
  DateTime? companyExDate;
  bool verify = false;
  String selectedTime = "";

  List<String> acc_purpose = [
    "Treasury Management",
    "Operating",
    "Liquidating Crypto Assets",
    "Investment Fund",
    "Cross Border Payments",
    "Arbitrage Trading",
    "Other"
  ];
  String select_purpose = "";

  List<String> business_type = [
    "Hedge Fund",
    "Private Equity Fund",
    "Mutual Fund",
    "Proprietary Trading Firm",
    "Personal Investment Company",
    "Individual Retirement Account Holding Company",
    "Money Service Business (MSB) (E.g Exchange, payments, platform exchange)",
    "Financial Institution Brokerage",
    "Agency OTC Brokerage",
    "Principle OTC Brokerage",
    "Retail Brokerage, Robo-Advisor, or FX/CFD Provider",
    "Fund of Funds",
    "Pension Fund",
    "Endowment",
    "Exchange Traded Fund",
    "Fund Administrator",
    "Professional Service Provider (Accounting or Law Firm)",
    "Software Vendor, Platform Provider, Data Aggregator",
    "Charity Organization or Non-profit",
    "Crypto Exchange",
    "Digital Currency Mining Firm",
    "ICO Sponsor or ICO Platform",
    "Merchant",
    "N/A"
  ];
  String select_business = "";


  List<String> org_type = [
    "Trust",
    "Sole Proprietor",
    "LLC",
    "Partnership",
    "Corporation",
    "Other"
  ];
  String select_org = "";

  var documentUri = "";
  final _formKey = GlobalKey<FormState>();
  String imagePath = "assets/others/banner.png";
  var faceUri = "";
  ImagePicker picker = ImagePicker();

  APIUtils apiUtils = APIUtils();
  bool loading = false;
  bool imageCapture = true;

  // bool _autoValidate = true;
  bool mobileVerify = true;

  FocusNode mobileFocus = FocusNode();
  TextEditingController mobile = TextEditingController();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController idController = TextEditingController();
  TextEditingController dobController = TextEditingController();
  TextEditingController aadharController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController statesController = TextEditingController();
  TextEditingController zipController = TextEditingController();

  TextEditingController addressController = TextEditingController();
  TextEditingController addressLineController = TextEditingController();
  TextEditingController expController = TextEditingController();

  List<String> genderType = [
    "Male",
    "Female",
  ];
  List<CountryCodeResult> countryList = [];
  List<String> idProofType = [
    "Passport",
    "SSN",
  ];
  String selectedGender = "";
  String selectedIdProof = "";
  CountryCodeResult? selectedCountryType;

  List<CountryCodeResult> countryPrincList = [];
  CountryCodeResult? selectedPrinCountryType;
  List<CountryCodeResult> countryIssueList = [];
  CountryCodeResult? selectedIssueCountryType;

  String panUrl = "";
  String aadharUrl = "";
  String faceUrl = "";
  bool countryB = false;
  bool countryA = false;

  String AadharImg = "img64";

  String PanImg = "img65";


  FocusNode entityFocus = FocusNode();
  TextEditingController entityController = TextEditingController();
  FocusNode bis_stateFocus = FocusNode();
  TextEditingController bis_stateController = TextEditingController();
  FocusNode regNumFocus = FocusNode();
  TextEditingController reg_numController = TextEditingController();
  FocusNode descripFocus = FocusNode();
  TextEditingController descripController = TextEditingController();
  FocusNode principal_stateFocus = FocusNode();
  TextEditingController principal_stateController = TextEditingController();
  FocusNode principal_cityFocus = FocusNode();
  TextEditingController principal_cityController = TextEditingController();

  FocusNode principal_addressFocus = FocusNode();
  TextEditingController principal_addressController = TextEditingController();
  FocusNode principal_codeFocus = FocusNode();
  TextEditingController principal_codeController = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    selectedDateOfBirth = DateTime((DateTime.now()).year - 18,
        (DateTime.now()).month, (DateTime.now()).day); //DateTime.now();
    selectedExDate = DateTime.now();
    initCountry();
    selectedExpiryDate = DateTime(
        (DateTime.now()).year, (DateTime.now()).month, (DateTime.now()).day);
    companyExDate = DateTime(
        (DateTime.now()).year, (DateTime.now()).month, (DateTime.now()).day);

    selectedGender = genderType.first;
    selectedIdProof = idProofType.first;
    select_purpose = acc_purpose.first;
    select_org = org_type.first;
    select_business = business_type.first;
    getCountryCodeDetils();
  }

  /// Opens QR scanner screen

  void initCountry() async {
    final country = await getDefaultCountry(context);
    setState(() {
      _selectedCountry = country;
      _selectedPrincipalCountry = country;
      countryB = true;
      countryA = true;
    });
  }

  Future<Null> _selectDate(BuildContext context, bool isDob,
      DateTime initialDate, DateTime firstDate, DateTime lastDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: CustomTheme.of(context).primaryColor,
            dialogBackgroundColor: CustomTheme.of(context).splashColor,
            backgroundColor: CustomTheme.of(context).primaryColor,
            colorScheme: ColorScheme.light(
              primary: CustomTheme.of(context).primaryColor,
            ),
            buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary),
          ),
          child: child!,
        );
      },
    );
    if (picked != null)
      setState(() {
        if (isDob) {
          selectedDateOfBirth = picked;
          dobController =
              TextEditingController(text: picked.toString().split(' ')[0]);
        } else {
          selectedExDate = picked;
        }
      });
  }

  Future<Null> _selectExpiryDate(BuildContext context, bool isExpDate,
      DateTime initialDate, DateTime firstDate, DateTime lastDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: CustomTheme.of(context).primaryColor,
            dialogBackgroundColor: CustomTheme.of(context).splashColor,
            backgroundColor: CustomTheme.of(context).primaryColor,
            colorScheme: ColorScheme.light(
              primary: CustomTheme.of(context).primaryColor,
            ),
            buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary),
          ),
          child: child!,
        );
      },
    );
    if (picked != null)
      setState(() {
        if (isExpDate) {
          selectedExpiryDate = picked;
          expController =
              TextEditingController(text: picked.toString().split(' ')[0]);
        } else {
          selectedExDate = picked;
        }
      });
  }

  Widget build(BuildContext context) {
    return MediaQuery(
        data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: CustomTheme.of(context).primaryColor,
            elevation: 0.0,
            leading: Container(
              padding: const EdgeInsets.all(18.0),
              // child: InkWell(
              //   onTap: () {
              //     Navigator.pop(context);
              //   },
              //   child: SvgPicture.asset(
              //     'assets/others/arrow_left.svg',
              //     height: 8.0,
              //     width: 8.0,
              //     color: CustomTheme.of(context).splashColor,
              //     allowDrawingOutsideViewBox: true,
              //   ),
              // )
            ),
            centerTitle: true,
            title: Text(
              "KYB",
              style: CustomWidget(context: context).CustomSizedTextStyle(
                  16.0,
                  Theme.of(context).splashColor,
                  FontWeight.w500,
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
                      // Add one stop for each color
                      // Values should increase from 0.0 to 1.0
                      stops: [
                    0.1,
                    1,
                    0.9,
                  ],
                      colors: [
                    CustomTheme.of(context).primaryColor,
                    CustomTheme.of(context).backgroundColor,
                    CustomTheme.of(context).dialogBackgroundColor,
                  ])),
              child: Stack(
                children: [
                  SingleChildScrollView(
                    child: SafeArea(
                      child: Container(
                        padding: EdgeInsets.only(
                            top: 5.0, bottom: 10.0, right: 15.0, left: 15.0),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextFormField(
                                controller: firstNameController,
                                // focusNode: emailFocus,
                                maxLines: 1,
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                // autocorrect: _autoValidate,
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
                                  hintText: "First Name",
                                  hintStyle: CustomWidget(context: context)
                                      .CustomSizedTextStyle(
                                          14.0,
                                          Theme.of(context)
                                              .splashColor
                                              .withOpacity(0.5),
                                          FontWeight.w300,
                                          'FontRegular'),
                                  filled: true,
                                  fillColor:
                                      CustomTheme.of(context).backgroundColor,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5),
                                    borderSide: BorderSide(
                                        color: CustomTheme.of(context)
                                            .splashColor
                                            .withOpacity(0.5),
                                        width: 1.0),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5),
                                    borderSide: BorderSide(
                                        color: CustomTheme.of(context)
                                            .splashColor
                                            .withOpacity(0.5),
                                        width: 1),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5),
                                    borderSide: BorderSide(
                                        color:
                                            CustomTheme.of(context).splashColor,
                                        width: 1.0),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5),
                                    borderSide: BorderSide(
                                        color: Colors.red, width: 1.0),
                                  ),
                                ),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return "Please enter FirstName";
                                  } else {
                                    return value.length < 4
                                        ? 'Minimum character length is 4'
                                        : null;
                                  }
                                },
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              TextFormField(
                                controller: lastNameController,
                                // focusNode: emailFocus,
                                maxLines: 1,
                                // autocorrect: _autoValidate,
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
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
                                  hintText: "Last Name",
                                  hintStyle: CustomWidget(context: context)
                                      .CustomSizedTextStyle(
                                          14.0,
                                          Theme.of(context)
                                              .splashColor
                                              .withOpacity(0.5),
                                          FontWeight.w300,
                                          'FontRegular'),
                                  filled: true,
                                  fillColor:
                                      CustomTheme.of(context).backgroundColor,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5),
                                    borderSide: BorderSide(
                                        color: CustomTheme.of(context)
                                            .splashColor
                                            .withOpacity(0.5),
                                        width: 1.0),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5),
                                    borderSide: BorderSide(
                                        color: CustomTheme.of(context)
                                            .splashColor
                                            .withOpacity(0.5),
                                        width: 1),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5),
                                    borderSide: BorderSide(
                                        color:
                                            CustomTheme.of(context).splashColor,
                                        width: 1.0),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5),
                                    borderSide: BorderSide(
                                        color: Colors.red, width: 1.0),
                                  ),
                                ),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return "Please enter LastName";
                                  }

                                  return null;
                                },
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              Row(
                                children: [
                                  Container(
                                      padding: const EdgeInsets.only(
                                          left: 10.0,
                                          right: 10.0,
                                          top: 14.7,
                                          bottom: 14.7),
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                            color: CustomTheme.of(context)
                                                .splashColor
                                                .withOpacity(0.5),
                                            width: 1.0),
                                        color: CustomTheme.of(context)
                                            .backgroundColor
                                            .withOpacity(0.5),
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(5.0),
                                          bottomLeft: Radius.circular(5.0),
                                        ),
                                      ),
                                      child: Row(
                                        children: [
                                          InkWell(
                                            onTap: _onPressedShowBottomSheet,
                                            child: Row(
                                              children: [
                                                Text(
                                                  countryB
                                                      ? _selectedCountry!
                                                          .callingCode
                                                          .toString()
                                                      : "+1",
                                                  style: CustomWidget(
                                                          context: context)
                                                      .CustomTextStyle(
                                                          Theme.of(context)
                                                              .splashColor,
                                                          FontWeight.normal,
                                                          'FontRegular'),
                                                ),
                                                const SizedBox(
                                                  width: 3.0,
                                                ),
                                                const Icon(
                                                  Icons
                                                      .keyboard_arrow_down_outlined,
                                                  size: 15.0,
                                                  color:
                                                      AppColors.backgroundColor,
                                                )
                                              ],
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 10.0,
                                          ),
                                        ],
                                      )),
                                  Flexible(
                                    child: TextFormField(
                                      controller: mobile,
                                      focusNode: mobileFocus,
                                      maxLines: 1,
                                      enabled: mobileVerify,
                                      textInputAction: TextInputAction.next,
                                      inputFormatters: [
                                        FilteringTextInputFormatter.allow(
                                            RegExp(r'[0-9]')),
                                      ],
                                      keyboardType: TextInputType.number,
                                      style: CustomWidget(context: context)
                                          .CustomTextStyle(
                                              Theme.of(context).splashColor,
                                              FontWeight.w400,
                                              'FontRegular'),
                                      decoration: InputDecoration(
                                        contentPadding: const EdgeInsets.only(
                                            left: 12,
                                            right: 0,
                                            top: 2,
                                            bottom: 2),
                                        hintText: "Please enter Mobile",
                                        suffixIcon: Container(
                                          // padding: const EdgeInsets.all(15.0),
                                          // child: SvgPicture.asset(
                                          //   'assets/icon/mobile.svg',
                                          //   height: 15.0,
                                          //   width: 15.0,
                                          //   allowDrawingOutsideViewBox: true,
                                          //   color: CustomTheme.of(context)
                                          //       .splashColor
                                          //       .withOpacity(0.5),
                                          // ),
                                          width: 0.0,
                                        ),
                                        hintStyle:
                                            CustomWidget(context: context)
                                                .CustomTextStyle(
                                                    Theme.of(context)
                                                        .splashColor
                                                        .withOpacity(0.5),
                                                    FontWeight.w300,
                                                    'FontRegular'),
                                        filled: true,
                                        fillColor: CustomTheme.of(context)
                                            .backgroundColor
                                            .withOpacity(0.5),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.only(
                                            topRight: Radius.circular(5.0),
                                            bottomRight: Radius.circular(5.0),
                                          ),
                                          borderSide: BorderSide(
                                              color: CustomTheme.of(context)
                                                  .splashColor
                                                  .withOpacity(0.5),
                                              width: 1.0),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.only(
                                            topRight: Radius.circular(5.0),
                                            bottomRight: Radius.circular(5.0),
                                          ),
                                          borderSide: BorderSide(
                                              color: CustomTheme.of(context)
                                                  .splashColor
                                                  .withOpacity(0.5),
                                              width: 1.0),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.only(
                                            topRight: Radius.circular(5.0),
                                            bottomRight: Radius.circular(5.0),
                                          ),
                                          borderSide: BorderSide(
                                              color: CustomTheme.of(context)
                                                  .splashColor,
                                              width: 1.0),
                                        ),
                                        errorBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.only(
                                            topRight: Radius.circular(5.0),
                                            bottomRight: Radius.circular(5.0),
                                          ),
                                          borderSide: BorderSide(
                                              color: CustomTheme.of(context)
                                                  .splashColor,
                                              width: 1.0),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width,
                                padding:
                                    EdgeInsets.fromLTRB(12.0, 0.0, 12, 0.0),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      color: CustomTheme.of(context)
                                          .splashColor
                                          .withOpacity(0.5),
                                      width: 1.0),
                                  borderRadius: BorderRadius.circular(5.0),
                                  color:
                                      CustomTheme.of(context).backgroundColor,
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
                                              0.7,
                                      items: genderType
                                          .map((value) => DropdownMenuItem(
                                                child: Text(
                                                  value.toString(),
                                                  style: CustomWidget(
                                                          context: context)
                                                      .CustomSizedTextStyle(
                                                          14.0,
                                                          Theme.of(context)
                                                              .hintColor,
                                                          FontWeight.w400,
                                                          'FontRegular'),
                                                ),
                                                value: value,
                                              ))
                                          .toList(),
                                      onChanged: (value) async {
                                        setState(() {
                                          selectedGender = value.toString();
                                        });
                                      },
                                      hint: Text(
                                        "Select Category",
                                        style: CustomWidget(context: context)
                                            .CustomSizedTextStyle(
                                                14.0,
                                                Theme.of(context).hintColor,
                                                FontWeight.w400,
                                                'FontRegular'),
                                      ),
                                      isExpanded: true,
                                      value: selectedGender,
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
                              InkWell(
                                onTap: () {
                                  selectedDateOfBirth = DateTime(
                                      (DateTime.now()).year - 18,
                                      (DateTime.now()).month,
                                      (DateTime.now()).day);
                                  _selectDate(
                                      context,
                                      true,
                                      DateTime(
                                          selectedDateOfBirth!.year,
                                          selectedDateOfBirth!.month,
                                          selectedDateOfBirth!.day),
                                      DateTime(
                                          selectedDateOfBirth!.year - 100,
                                          selectedDateOfBirth!.month,
                                          selectedDateOfBirth!.day),
                                      DateTime(
                                          selectedDateOfBirth!.year,
                                          selectedDateOfBirth!.month,
                                          selectedDateOfBirth!.day));
                                },
                                child: TextFormField(
                                  controller: dobController,
                                  // focusNode: emailFocus,
                                  maxLines: 1,
                                  enabled: false,
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
                                    hintText: "DOB",
                                    hintStyle: CustomWidget(context: context)
                                        .CustomSizedTextStyle(
                                            14.0,
                                            Theme.of(context)
                                                .splashColor
                                                .withOpacity(0.5),
                                            FontWeight.w300,
                                            'FontRegular'),
                                    filled: true,
                                    fillColor:
                                        CustomTheme.of(context).backgroundColor,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(5),
                                      borderSide: BorderSide(
                                          color: CustomTheme.of(context)
                                              .splashColor
                                              .withOpacity(0.5),
                                          width: 1.0),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(5),
                                      borderSide: BorderSide(
                                          color: CustomTheme.of(context)
                                              .splashColor
                                              .withOpacity(0.5),
                                          width: 1),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(5),
                                      borderSide: BorderSide(
                                          color: CustomTheme.of(context)
                                              .splashColor
                                              .withOpacity(0.5),
                                          width: 1.0),
                                    ),
                                    disabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(5),
                                      borderSide: BorderSide(
                                          color: CustomTheme.of(context)
                                              .splashColor
                                              .withOpacity(0.5),
                                          width: 1),
                                    ),
                                    errorBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(5),
                                      borderSide: BorderSide(
                                          color: Colors.red, width: 1.0),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width,
                                padding:
                                    EdgeInsets.fromLTRB(12.0, 0.0, 12, 0.0),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      color: CustomTheme.of(context)
                                          .splashColor
                                          .withOpacity(0.5),
                                      width: 1.0),
                                  borderRadius: BorderRadius.circular(5.0),
                                  color:
                                      CustomTheme.of(context).backgroundColor,
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
                                              0.7,
                                      items: countryList
                                          .map((value) => DropdownMenuItem(
                                                child: Text(
                                                  value.name!.toString(),
                                                  style: CustomWidget(
                                                          context: context)
                                                      .CustomSizedTextStyle(
                                                          14.0,
                                                          Theme.of(context)
                                                              .hintColor,
                                                          FontWeight.w400,
                                                          'FontRegular'),
                                                ),
                                                value: value,
                                              ))
                                          .toList(),
                                      onChanged: (value) async {
                                        setState(() {
                                          selectedCountryType = value;
                                          print(
                                            "hai" +
                                                selectedCountryType!.code
                                                    .toString(),
                                          );
                                        });
                                      },
                                      hint: Text(
                                        "Select Country",
                                        style: CustomWidget(context: context)
                                            .CustomSizedTextStyle(
                                                14.0,
                                                Theme.of(context).hintColor,
                                                FontWeight.w400,
                                                'FontRegular'),
                                      ),
                                      isExpanded: true,
                                      value: selectedCountryType,
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
                              TextFormField(
                                controller: cityController,
                                // autocorrect: _autoValidate,
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
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
                                  hintText: "City",
                                  hintStyle: CustomWidget(context: context)
                                      .CustomSizedTextStyle(
                                          14.0,
                                          Theme.of(context)
                                              .splashColor
                                              .withOpacity(0.5),
                                          FontWeight.w300,
                                          'FontRegular'),
                                  filled: true,
                                  fillColor:
                                      CustomTheme.of(context).backgroundColor,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5),
                                    borderSide: BorderSide(
                                        color: CustomTheme.of(context)
                                            .splashColor
                                            .withOpacity(0.5),
                                        width: 1.0),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5),
                                    borderSide: BorderSide(
                                        color: CustomTheme.of(context)
                                            .splashColor
                                            .withOpacity(0.5),
                                        width: 1),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5),
                                    borderSide: BorderSide(
                                        color:
                                            CustomTheme.of(context).splashColor,
                                        width: 1.0),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5),
                                    borderSide: BorderSide(
                                        color: Colors.red, width: 1.0),
                                  ),
                                ),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return "Please enter City";
                                  }
                                  return null;
                                },
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              TextFormField(
                                controller: statesController,
                                // autocorrect: _autoValidate,
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                // focusNode: emailFocus,
                                maxLines: 1,
                                // enabled: emailVerify,
                                textInputAction: TextInputAction.next,
                                keyboardType: TextInputType.text,
                                style: CustomWidget(context: context)
                                    .CustomTextStyle(
                                        Theme.of(context).splashColor,
                                        FontWeight.w400,
                                        'FontRegular'),
                                decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.only(
                                      left: 12, right: 0, top: 2, bottom: 2),
                                  hintText: "State",
                                  hintStyle: CustomWidget(context: context)
                                      .CustomSizedTextStyle(
                                          14.0,
                                          Theme.of(context)
                                              .splashColor
                                              .withOpacity(0.5),
                                          FontWeight.w300,
                                          'FontRegular'),
                                  filled: true,
                                  fillColor:
                                      CustomTheme.of(context).backgroundColor,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5),
                                    borderSide: BorderSide(
                                        color: CustomTheme.of(context)
                                            .splashColor
                                            .withOpacity(0.5),
                                        width: 1.0),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5),
                                    borderSide: BorderSide(
                                        color: CustomTheme.of(context)
                                            .splashColor
                                            .withOpacity(0.5),
                                        width: 1),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5),
                                    borderSide: BorderSide(
                                        color:
                                            CustomTheme.of(context).splashColor,
                                        width: 1.0),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5),
                                    borderSide: BorderSide(
                                        color: Colors.red, width: 1.0),
                                  ),
                                ),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return "Please enter State";
                                  }
                                  return null;
                                },
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              Text(
                                "Organization Type",
                                style: CustomWidget(context: context)
                                    .CustomSizedTextStyle(
                                    12.0,
                                    Theme.of(context)
                                        .splashColor,
                                    FontWeight.w500,
                                    'FontRegular'),
                                softWrap: true,
                              ),
                              SizedBox(
                                height: 3.0,
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width,
                                padding:
                                EdgeInsets.fromLTRB(12.0, 0.0, 12, 0.0),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      color: CustomTheme.of(context)
                                          .splashColor
                                          .withOpacity(0.5),
                                      width: 1.0),
                                  borderRadius: BorderRadius.circular(5.0),
                                  color:
                                  CustomTheme.of(context).backgroundColor,
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
                                          0.7,
                                      items: org_type
                                          .map((value) => DropdownMenuItem(
                                        child: Text(
                                          value.toString(),
                                          style: CustomWidget(
                                              context: context)
                                              .CustomSizedTextStyle(
                                              14.0,
                                              Theme.of(context)
                                                  .hintColor,
                                              FontWeight.w400,
                                              'FontRegular'),
                                        ),
                                        value: value,
                                      ))
                                          .toList(),
                                      onChanged: (value) async {
                                        setState(() {
                                          select_org = value.toString();
                                        });
                                      },
                                      hint: Text(
                                        "Select Category",
                                        style: CustomWidget(context: context)
                                            .CustomSizedTextStyle(
                                            14.0,
                                            Theme.of(context).hintColor,
                                            FontWeight.w400,
                                            'FontRegular'),
                                      ),
                                      isExpanded: true,
                                      value: select_org,
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
                              Text(
                                "Account Purpose",
                                style: CustomWidget(context: context)
                                    .CustomSizedTextStyle(
                                    12.0,
                                    Theme.of(context)
                                        .splashColor,
                                    FontWeight.w500,
                                    'FontRegular'),
                                softWrap: true,
                              ),
                              SizedBox(
                                height: 3.0,
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width,
                                padding:
                                EdgeInsets.fromLTRB(12.0, 0.0, 12, 0.0),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      color: CustomTheme.of(context)
                                          .splashColor
                                          .withOpacity(0.5),
                                      width: 1.0),
                                  borderRadius: BorderRadius.circular(5.0),
                                  color:
                                  CustomTheme.of(context).backgroundColor,
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
                                          0.7,
                                      items: acc_purpose
                                          .map((value) => DropdownMenuItem(
                                        child: Text(
                                          value.toString(),
                                          style: CustomWidget(
                                              context: context)
                                              .CustomSizedTextStyle(
                                              14.0,
                                              Theme.of(context)
                                                  .hintColor,
                                              FontWeight.w400,
                                              'FontRegular'),
                                        ),
                                        value: value,
                                      ))
                                          .toList(),
                                      onChanged: (value) async {
                                        setState(() {
                                          select_purpose = value.toString();
                                        });
                                      },
                                      hint: Text(
                                        "Select Category",
                                        style: CustomWidget(context: context)
                                            .CustomSizedTextStyle(
                                            14.0,
                                            Theme.of(context).hintColor,
                                            FontWeight.w400,
                                            'FontRegular'),
                                      ),
                                      isExpanded: true,
                                      value: select_purpose,
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
                              Text(
                                "Business Type",
                                style: CustomWidget(context: context)
                                    .CustomSizedTextStyle(
                                    12.0,
                                    Theme.of(context)
                                        .splashColor,
                                    FontWeight.w500,
                                    'FontRegular'),
                                softWrap: true,
                              ),
                              SizedBox(
                                height: 3.0,
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width,
                                padding:
                                EdgeInsets.fromLTRB(12.0, 0.0, 12, 0.0),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      color: CustomTheme.of(context)
                                          .splashColor
                                          .withOpacity(0.5),
                                      width: 1.0),
                                  borderRadius: BorderRadius.circular(5.0),
                                  color:
                                  CustomTheme.of(context).backgroundColor,
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
                                          0.7,
                                      items: business_type
                                          .map((value) => DropdownMenuItem(
                                        child: Text(
                                          value.toString(),
                                          style: CustomWidget(
                                              context: context)
                                              .CustomSizedTextStyle(
                                              14.0,
                                              Theme.of(context)
                                                  .hintColor,
                                              FontWeight.w400,
                                              'FontRegular'),
                                        ),
                                        value: value,
                                      ))
                                          .toList(),
                                      onChanged: (value) async {
                                        setState(() {
                                          select_business = value.toString();
                                        });
                                      },
                                      hint: Text(
                                        "Select Category",
                                        style: CustomWidget(context: context)
                                            .CustomSizedTextStyle(
                                            14.0,
                                            Theme.of(context).hintColor,
                                            FontWeight.w400,
                                            'FontRegular'),
                                      ),
                                      isExpanded: true,
                                      value: select_business,
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



                              TextFormField(
                                controller: reg_numController,
                                // autocorrect: _autoValidate,
                                autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                                // focusNode: emailFocus,
                                maxLines: 1,
                                // enabled: emailVerify,
                                textInputAction: TextInputAction.next,
                                keyboardType: TextInputType.number,
                                style: CustomWidget(context: context)
                                    .CustomTextStyle(
                                    Theme.of(context).splashColor,
                                    FontWeight.w400,
                                    'FontRegular'),
                                decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.only(
                                      left: 12, right: 0, top: 2, bottom: 2),
                                  hintText: "Registration Number",
                                  hintStyle: CustomWidget(context: context)
                                      .CustomSizedTextStyle(
                                      14.0,
                                      Theme.of(context)
                                          .splashColor
                                          .withOpacity(0.5),
                                      FontWeight.w300,
                                      'FontRegular'),
                                  filled: true,
                                  fillColor:
                                  CustomTheme.of(context).backgroundColor,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5),
                                    borderSide: BorderSide(
                                        color: CustomTheme.of(context)
                                            .splashColor
                                            .withOpacity(0.5),
                                        width: 1.0),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5),
                                    borderSide: BorderSide(
                                        color: CustomTheme.of(context)
                                            .splashColor
                                            .withOpacity(0.5),
                                        width: 1),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5),
                                    borderSide: BorderSide(
                                        color: CustomTheme.of(context)
                                            .splashColor
                                            .withOpacity(0.5),
                                        width: 1.0),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5),
                                    borderSide: BorderSide(
                                        color: Colors.red, width: 1.0),
                                  ),
                                ),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return "Please enter Registration Number";
                                  }
                                  return null;
                                },
                              ),
                              SizedBox(
                                height: 2.0,
                              ),
                              Text(
                                "Note: The business’s TIN (tax identification number) for US businesses or registration number",
                                style: CustomWidget(context: context)
                                    .CustomSizedTextStyle(
                                    10.0,
                                    Colors.red,
                                    FontWeight.w500,
                                    'FontRegular'),
                                softWrap: true,
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              TextFormField(
                                controller: descripController,
                                // autocorrect: _autoValidate,
                                autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                                // focusNode: emailFocus,
                                maxLines: 1,
                                // enabled: emailVerify,
                                textInputAction: TextInputAction.next,
                                keyboardType: TextInputType.number,
                                style: CustomWidget(context: context)
                                    .CustomTextStyle(
                                    Theme.of(context).splashColor,
                                    FontWeight.w400,
                                    'FontRegular'),
                                decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.only(
                                      left: 12, right: 0, top: 2, bottom: 2),
                                  hintText: "Description",
                                  hintStyle: CustomWidget(context: context)
                                      .CustomSizedTextStyle(
                                      14.0,
                                      Theme.of(context)
                                          .splashColor
                                          .withOpacity(0.5),
                                      FontWeight.w300,
                                      'FontRegular'),
                                  filled: true,
                                  fillColor:
                                  CustomTheme.of(context).backgroundColor,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5),
                                    borderSide: BorderSide(
                                        color: CustomTheme.of(context)
                                            .splashColor
                                            .withOpacity(0.5),
                                        width: 1.0),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5),
                                    borderSide: BorderSide(
                                        color: CustomTheme.of(context)
                                            .splashColor
                                            .withOpacity(0.5),
                                        width: 1),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5),
                                    borderSide: BorderSide(
                                        color: CustomTheme.of(context)
                                            .splashColor
                                            .withOpacity(0.5),
                                        width: 1.0),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5),
                                    borderSide: BorderSide(
                                        color: Colors.red, width: 1.0),
                                  ),
                                ),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return "Please enter Description";
                                  }
                                  return null;
                                },
                              ),
                              SizedBox(
                                height: 2.0,
                              ),
                              Text(
                                "Note: A description of the business",
                                style: CustomWidget(context: context)
                                    .CustomSizedTextStyle(
                                    10.0,
                                    Colors.red,
                                    FontWeight.w500,
                                    'FontRegular'),
                                softWrap: true,
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width,
                                padding:
                                EdgeInsets.fromLTRB(12.0, 0.0, 12, 0.0),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      color: CustomTheme.of(context)
                                          .splashColor
                                          .withOpacity(0.5),
                                      width: 1.0),
                                  borderRadius: BorderRadius.circular(5.0),
                                  color:
                                  CustomTheme.of(context).backgroundColor,
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
                                          0.7,
                                      items: countryPrincList
                                          .map((value) => DropdownMenuItem(
                                        child: Text(
                                          value.code!.toString(),
                                          style: CustomWidget(
                                              context: context)
                                              .CustomSizedTextStyle(
                                              14.0,
                                              Theme.of(context)
                                                  .hintColor,
                                              FontWeight.w400,
                                              'FontRegular'),
                                        ),
                                        value: value,
                                      ))
                                          .toList(),
                                      onChanged: (value) async {
                                        setState(() {
                                          selectedPrinCountryType = value;

                                        });
                                      },
                                      hint: Text(
                                        "Select Country",
                                        style: CustomWidget(context: context)
                                            .CustomSizedTextStyle(
                                            14.0,
                                            Theme.of(context).hintColor,
                                            FontWeight.w400,
                                            'FontRegular'),
                                      ),
                                      isExpanded: true,
                                      value: selectedPrinCountryType,
                                      icon: const Icon(
                                        Icons.arrow_drop_down,
                                        // color: AppColors.otherTextColor,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 2.0,
                              ),
                              Text(
                                "Note: Country code of the business’ principal place of business operations",
                                style: CustomWidget(context: context)
                                    .CustomSizedTextStyle(
                                    10.0,
                                    Colors.red,
                                    FontWeight.w500,
                                    'FontRegular'),
                                softWrap: true,
                              ),
                              SizedBox(
                                height: 10.0,
                              ),

                              TextFormField(
                                controller: principal_stateController,
                                // autocorrect: _autoValidate,
                                autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                                // focusNode: emailFocus,
                                maxLines: 1,
                                // enabled: emailVerify,
                                textInputAction: TextInputAction.next,
                                keyboardType: TextInputType.text,
                                style: CustomWidget(context: context)
                                    .CustomTextStyle(
                                    Theme.of(context).splashColor,
                                    FontWeight.w400,
                                    'FontRegular'),
                                decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.only(
                                      left: 12, right: 0, top: 2, bottom: 2),
                                  hintText: "Principal place state",
                                  hintStyle: CustomWidget(context: context)
                                      .CustomSizedTextStyle(
                                      14.0,
                                      Theme.of(context)
                                          .splashColor
                                          .withOpacity(0.5),
                                      FontWeight.w300,
                                      'FontRegular'),
                                  filled: true,
                                  fillColor:
                                  CustomTheme.of(context).backgroundColor,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5),
                                    borderSide: BorderSide(
                                        color: CustomTheme.of(context)
                                            .splashColor
                                            .withOpacity(0.5),
                                        width: 1.0),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5),
                                    borderSide: BorderSide(
                                        color: CustomTheme.of(context)
                                            .splashColor
                                            .withOpacity(0.5),
                                        width: 1),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5),
                                    borderSide: BorderSide(
                                        color: CustomTheme.of(context)
                                            .splashColor
                                            .withOpacity(0.5),
                                        width: 1.0),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5),
                                    borderSide: BorderSide(
                                        color: Colors.red, width: 1.0),
                                  ),
                                ),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return "Please enter Principal place state";
                                  }
                                  return null;
                                },
                              ),
                              SizedBox(
                                height: 2.0,
                              ),
                              Text(
                                "Note: State/province of the business’ principal place of business operations",
                                style: CustomWidget(context: context)
                                    .CustomSizedTextStyle(
                                    10.0,
                                    Colors.red,
                                    FontWeight.w500,
                                    'FontRegular'),
                                softWrap: true,
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              TextFormField(
                                controller: principal_addressController,
                                // autocorrect: _autoValidate,
                                autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                                // focusNode: emailFocus,
                                maxLines: 1,
                                // enabled: emailVerify,
                                textInputAction: TextInputAction.next,
                                keyboardType: TextInputType.text,
                                style: CustomWidget(context: context)
                                    .CustomTextStyle(
                                    Theme.of(context).splashColor,
                                    FontWeight.w400,
                                    'FontRegular'),
                                decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.only(
                                      left: 12, right: 0, top: 2, bottom: 2),
                                  hintText: "Principal place address",
                                  hintStyle: CustomWidget(context: context)
                                      .CustomSizedTextStyle(
                                      14.0,
                                      Theme.of(context)
                                          .splashColor
                                          .withOpacity(0.5),
                                      FontWeight.w300,
                                      'FontRegular'),
                                  filled: true,
                                  fillColor:
                                  CustomTheme.of(context).backgroundColor,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5),
                                    borderSide: BorderSide(
                                        color: CustomTheme.of(context)
                                            .splashColor
                                            .withOpacity(0.5),
                                        width: 1.0),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5),
                                    borderSide: BorderSide(
                                        color: CustomTheme.of(context)
                                            .splashColor
                                            .withOpacity(0.5),
                                        width: 1),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5),
                                    borderSide: BorderSide(
                                        color: CustomTheme.of(context)
                                            .splashColor
                                            .withOpacity(0.5),
                                        width: 1.0),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5),
                                    borderSide: BorderSide(
                                        color: Colors.red, width: 1.0),
                                  ),
                                ),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return "Please enter Principal place address";
                                  }
                                  return null;
                                },
                              ),
                              SizedBox(
                                height: 2.0,
                              ),
                              Text(
                                "Note: Street address of the business’ principal place of business operations",
                                style: CustomWidget(context: context)
                                    .CustomSizedTextStyle(
                                    10.0,
                                    Colors.red,
                                    FontWeight.w500,
                                    'FontRegular'),
                                softWrap: true,
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              TextFormField(
                                controller: principal_cityController,
                                // autocorrect: _autoValidate,
                                autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                                // focusNode: emailFocus,
                                maxLines: 1,
                                // enabled: emailVerify,
                                textInputAction: TextInputAction.next,
                                keyboardType: TextInputType.text,
                                style: CustomWidget(context: context)
                                    .CustomTextStyle(
                                    Theme.of(context).splashColor,
                                    FontWeight.w400,
                                    'FontRegular'),
                                decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.only(
                                      left: 12, right: 0, top: 2, bottom: 2),
                                  hintText: "Principal place city",
                                  hintStyle: CustomWidget(context: context)
                                      .CustomSizedTextStyle(
                                      14.0,
                                      Theme.of(context)
                                          .splashColor
                                          .withOpacity(0.5),
                                      FontWeight.w300,
                                      'FontRegular'),
                                  filled: true,
                                  fillColor:
                                  CustomTheme.of(context).backgroundColor,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5),
                                    borderSide: BorderSide(
                                        color: CustomTheme.of(context)
                                            .splashColor
                                            .withOpacity(0.5),
                                        width: 1.0),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5),
                                    borderSide: BorderSide(
                                        color: CustomTheme.of(context)
                                            .splashColor
                                            .withOpacity(0.5),
                                        width: 1),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5),
                                    borderSide: BorderSide(
                                        color: CustomTheme.of(context)
                                            .splashColor
                                            .withOpacity(0.5),
                                        width: 1.0),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5),
                                    borderSide: BorderSide(
                                        color: Colors.red, width: 1.0),
                                  ),
                                ),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return "Please enter Principal place city";
                                  }
                                  return null;
                                },
                              ),
                              SizedBox(
                                height: 2.0,
                              ),
                              Text(
                                "Note: City of the business’ principal place of business operations",
                                style: CustomWidget(context: context)
                                    .CustomSizedTextStyle(
                                    10.0,
                                    Colors.red,
                                    FontWeight.w500,
                                    'FontRegular'),
                                softWrap: true,
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              TextFormField(
                                controller: principal_codeController,
                                // autocorrect: _autoValidate,
                                autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                                // focusNode: emailFocus,
                                maxLines: 1,
                                // enabled: emailVerify,
                                textInputAction: TextInputAction.next,
                                keyboardType: TextInputType.text,
                                style: CustomWidget(context: context)
                                    .CustomTextStyle(
                                    Theme.of(context).splashColor,
                                    FontWeight.w400,
                                    'FontRegular'),
                                decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.only(
                                      left: 12, right: 0, top: 2, bottom: 2),
                                  hintText: "Principal place postal code",
                                  hintStyle: CustomWidget(context: context)
                                      .CustomSizedTextStyle(
                                      14.0,
                                      Theme.of(context)
                                          .splashColor
                                          .withOpacity(0.5),
                                      FontWeight.w300,
                                      'FontRegular'),
                                  filled: true,
                                  fillColor:
                                  CustomTheme.of(context).backgroundColor,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5),
                                    borderSide: BorderSide(
                                        color: CustomTheme.of(context)
                                            .splashColor
                                            .withOpacity(0.5),
                                        width: 1.0),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5),
                                    borderSide: BorderSide(
                                        color: CustomTheme.of(context)
                                            .splashColor
                                            .withOpacity(0.5),
                                        width: 1),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5),
                                    borderSide: BorderSide(
                                        color: CustomTheme.of(context)
                                            .splashColor
                                            .withOpacity(0.5),
                                        width: 1.0),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5),
                                    borderSide: BorderSide(
                                        color: Colors.red, width: 1.0),
                                  ),
                                ),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return "Please enter Principal place postal code";
                                  }
                                  return null;
                                },
                              ),
                              SizedBox(
                                height: 2.0,
                              ),
                              Text(
                                "Note: Postal code of the business’ principal place of business operationss",
                                style: CustomWidget(context: context)
                                    .CustomSizedTextStyle(
                                    10.0,
                                    Colors.red,
                                    FontWeight.w500,
                                    'FontRegular'),
                                softWrap: true,
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              TextFormField(
                                controller: zipController,
                                // autocorrect: _autoValidate,
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                // focusNode: emailFocus,
                                maxLines: 1,
                                // enabled: emailVerify,
                                textInputAction: TextInputAction.next,
                                keyboardType: TextInputType.number,
                                style: CustomWidget(context: context)
                                    .CustomTextStyle(
                                        Theme.of(context).splashColor,
                                        FontWeight.w400,
                                        'FontRegular'),
                                decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.only(
                                      left: 12, right: 0, top: 2, bottom: 2),
                                  hintText: "Zip / Postal Code",
                                  hintStyle: CustomWidget(context: context)
                                      .CustomSizedTextStyle(
                                          14.0,
                                          Theme.of(context)
                                              .splashColor
                                              .withOpacity(0.5),
                                          FontWeight.w300,
                                          'FontRegular'),
                                  filled: true,
                                  fillColor:
                                      CustomTheme.of(context).backgroundColor,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5),
                                    borderSide: BorderSide(
                                        color: CustomTheme.of(context)
                                            .splashColor
                                            .withOpacity(0.5),
                                        width: 1.0),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5),
                                    borderSide: BorderSide(
                                        color: CustomTheme.of(context)
                                            .splashColor
                                            .withOpacity(0.5),
                                        width: 1),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5),
                                    borderSide: BorderSide(
                                        color: CustomTheme.of(context)
                                            .splashColor
                                            .withOpacity(0.5),
                                        width: 1.0),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5),
                                    borderSide: BorderSide(
                                        color: Colors.red, width: 1.0),
                                  ),
                                ),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return "Please enter Zip code";
                                  }
                                  return null;
                                },
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              TextFormField(
                                controller: addressController,
                                // autocorrect: _autoValidate,
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                // focusNode: emailFocus,
                                maxLines: 5,
                                // enabled: emailVerify,
                                textInputAction: TextInputAction.next,
                                keyboardType: TextInputType.streetAddress,
                                style: CustomWidget(context: context)
                                    .CustomTextStyle(
                                        Theme.of(context).splashColor,
                                        FontWeight.w400,
                                        'FontRegular'),
                                decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.only(
                                      left: 12, right: 0, top: 2, bottom: 2),
                                  hintText: "Address Line 1",
                                  hintStyle: CustomWidget(context: context)
                                      .CustomSizedTextStyle(
                                          14.0,
                                          Theme.of(context)
                                              .splashColor
                                              .withOpacity(0.5),
                                          FontWeight.w300,
                                          'FontRegular'),
                                  filled: true,
                                  fillColor:
                                      CustomTheme.of(context).backgroundColor,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5),
                                    borderSide: BorderSide(
                                        color: CustomTheme.of(context)
                                            .splashColor
                                            .withOpacity(0.5),
                                        width: 1.0),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5),
                                    borderSide: BorderSide(
                                        color: CustomTheme.of(context)
                                            .splashColor
                                            .withOpacity(0.5),
                                        width: 1),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5),
                                    borderSide: BorderSide(
                                        color:
                                            CustomTheme.of(context).splashColor,
                                        width: 1.0),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5),
                                    borderSide: BorderSide(
                                        color: Colors.red, width: 1.0),
                                  ),
                                ),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return "Please enter Address Line1 ";
                                  }
                                  return null;
                                },
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              TextFormField(
                                controller: addressLineController,
                                // autocorrect: _autoValidate,
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                // focusNode: emailFocus,
                                maxLines: 5,
                                // enabled: emailVerify,
                                textInputAction: TextInputAction.next,
                                keyboardType: TextInputType.streetAddress,
                                style: CustomWidget(context: context)
                                    .CustomTextStyle(
                                        Theme.of(context).splashColor,
                                        FontWeight.w400,
                                        'FontRegular'),
                                decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.only(
                                      left: 12, right: 0, top: 2, bottom: 2),
                                  hintText: "Address Line 2",
                                  hintStyle: CustomWidget(context: context)
                                      .CustomSizedTextStyle(
                                          14.0,
                                          Theme.of(context)
                                              .splashColor
                                              .withOpacity(0.5),
                                          FontWeight.w300,
                                          'FontRegular'),
                                  filled: true,
                                  fillColor:
                                      CustomTheme.of(context).backgroundColor,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5),
                                    borderSide: BorderSide(
                                        color: CustomTheme.of(context)
                                            .splashColor
                                            .withOpacity(0.5),
                                        width: 1.0),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5),
                                    borderSide: BorderSide(
                                        color: CustomTheme.of(context)
                                            .splashColor
                                            .withOpacity(0.5),
                                        width: 1),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5),
                                    borderSide: BorderSide(
                                        color:
                                            CustomTheme.of(context).splashColor,
                                        width: 1.0),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5),
                                    borderSide: BorderSide(
                                        color: Colors.red, width: 1.0),
                                  ),
                                ),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return "Please enter Address Line 2 ";
                                  }
                                  return null;
                                },
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width,
                                padding:
                                    EdgeInsets.fromLTRB(12.0, 0.0, 12, 0.0),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      color: CustomTheme.of(context)
                                          .splashColor
                                          .withOpacity(0.5),
                                      width: 1.0),
                                  borderRadius: BorderRadius.circular(5.0),
                                  color:
                                      CustomTheme.of(context).backgroundColor,
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
                                              0.7,
                                      items: idProofType
                                          .map((value) => DropdownMenuItem(
                                                child: Text(
                                                  value.toString(),
                                                  style: CustomWidget(
                                                          context: context)
                                                      .CustomSizedTextStyle(
                                                          14.0,
                                                          Theme.of(context)
                                                              .hintColor,
                                                          FontWeight.w400,
                                                          'FontRegular'),
                                                ),
                                                value: value,
                                              ))
                                          .toList(),
                                      onChanged: (value) async {
                                        setState(() {
                                          selectedIdProof = value.toString();
                                        });
                                      },
                                      hint: Text(
                                        "Select Category",
                                        style: CustomWidget(context: context)
                                            .CustomSizedTextStyle(
                                                14.0,
                                                Theme.of(context).hintColor,
                                                FontWeight.w400,
                                                'FontRegular'),
                                      ),
                                      isExpanded: true,
                                      value: selectedIdProof,
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
                              TextFormField(
                                controller: idController,
                                // focusNode: emailFocus,
                                maxLines: 1,
                                // autocorrect: _autoValidate,
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                // enabled: emailVerify,
                                textInputAction: TextInputAction.next,
                                keyboardType: TextInputType.text,
                                style: CustomWidget(context: context)
                                    .CustomTextStyle(
                                        Theme.of(context).splashColor,
                                        FontWeight.w400,
                                        'FontRegular'),
                                decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.only(
                                      left: 12, right: 0, top: 2, bottom: 2),
                                  hintText: "Id Number",
                                  hintStyle: CustomWidget(context: context)
                                      .CustomSizedTextStyle(
                                          14.0,
                                          Theme.of(context)
                                              .splashColor
                                              .withOpacity(0.5),
                                          FontWeight.w300,
                                          'FontRegular'),
                                  filled: true,
                                  fillColor:
                                      CustomTheme.of(context).backgroundColor,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5),
                                    borderSide: BorderSide(
                                        color: CustomTheme.of(context)
                                            .splashColor
                                            .withOpacity(0.5),
                                        width: 1.0),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5),
                                    borderSide: BorderSide(
                                        color: CustomTheme.of(context)
                                            .splashColor
                                            .withOpacity(0.5),
                                        width: 1),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5),
                                    borderSide: BorderSide(
                                        color:
                                            CustomTheme.of(context).splashColor,
                                        width: 1.0),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5),
                                    borderSide: BorderSide(
                                        color: Colors.red, width: 1.0),
                                  ),
                                ),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return "Please enter Id Number";
                                  }

                                  return null;
                                },
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              InkWell(
                                onTap: () {
                                  selectedExpiryDate = DateTime(
                                      (DateTime.now()).year,
                                      (DateTime.now()).month,
                                      (DateTime.now()).day);
                                  _selectExpiryDate(
                                      context,
                                      true,
                                      DateTime(
                                          selectedExpiryDate!.year,
                                          selectedExpiryDate!.month,
                                          selectedExpiryDate!.day),
                                      DateTime(
                                          selectedExpiryDate!.year,
                                          selectedExpiryDate!.month,
                                          selectedExpiryDate!.day),
                                      DateTime(
                                          selectedExpiryDate!.year + 10,
                                          selectedExpiryDate!.month,
                                          selectedExpiryDate!.day));
                                },
                                child: TextFormField(
                                  controller: expController,
                                  // focusNode: emailFocus,
                                  maxLines: 1,
                                  enabled: false,
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
                                    hintText: "Expiry Date",
                                    hintStyle: CustomWidget(context: context)
                                        .CustomSizedTextStyle(
                                            14.0,
                                            Theme.of(context)
                                                .splashColor
                                                .withOpacity(0.5),
                                            FontWeight.w300,
                                            'FontRegular'),
                                    filled: true,
                                    fillColor:
                                        CustomTheme.of(context).backgroundColor,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(5),
                                      borderSide: BorderSide(
                                          color: CustomTheme.of(context)
                                              .splashColor
                                              .withOpacity(0.5),
                                          width: 1.0),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(5),
                                      borderSide: BorderSide(
                                          color: CustomTheme.of(context)
                                              .splashColor
                                              .withOpacity(0.5),
                                          width: 1),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(5),
                                      borderSide: BorderSide(
                                          color: CustomTheme.of(context)
                                              .splashColor,
                                          width: 1.0),
                                    ),
                                    disabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(5),
                                      borderSide: BorderSide(
                                          color: CustomTheme.of(context)
                                              .splashColor
                                              .withOpacity(0.5),
                                          width: 1),
                                    ),
                                    errorBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(5),
                                      borderSide: BorderSide(
                                          color: Colors.red, width: 1.0),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width,
                                padding:
                                EdgeInsets.fromLTRB(12.0, 0.0, 12, 0.0),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      color: CustomTheme.of(context)
                                          .splashColor
                                          .withOpacity(0.5),
                                      width: 1.0),
                                  borderRadius: BorderRadius.circular(5.0),
                                  color:
                                  CustomTheme.of(context).backgroundColor,
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
                                          0.7,
                                      items: countryIssueList
                                          .map((value) => DropdownMenuItem(
                                        child: Text(
                                          value.code!.toString(),
                                          style: CustomWidget(
                                              context: context)
                                              .CustomSizedTextStyle(
                                              14.0,
                                              Theme.of(context)
                                                  .hintColor,
                                              FontWeight.w400,
                                              'FontRegular'),
                                        ),
                                        value: value,
                                      ))
                                          .toList(),
                                      onChanged: (value) async {
                                        setState(() {
                                          selectedIssueCountryType = value;

                                        });
                                      },
                                      hint: Text(
                                        "Select Country",
                                        style: CustomWidget(context: context)
                                            .CustomSizedTextStyle(
                                            14.0,
                                            Theme.of(context).hintColor,
                                            FontWeight.w400,
                                            'FontRegular'),
                                      ),
                                      isExpanded: true,
                                      value: selectedIssueCountryType,
                                      icon: const Icon(
                                        Icons.arrow_drop_down,
                                        // color: AppColors.otherTextColor,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 2.0,
                              ),
                              Text(
                                "Note: Country code of the business’ principal place of business operations",
                                style: CustomWidget(context: context)
                                    .CustomSizedTextStyle(
                                    10.0,
                                    Colors.red,
                                    FontWeight.w500,
                                    'FontRegular'),
                                softWrap: true,
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              InkWell(
                                onTap: () async {
                                  onRequestPermission(true);
                                },
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  padding:
                                      EdgeInsets.fromLTRB(10, 50.0, 10, 40.0),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: CustomTheme.of(context)
                                            .splashColor
                                            .withOpacity(0.5),
                                        width: 1.0),
                                    borderRadius: BorderRadius.circular(5.0),
                                    color: Colors.transparent,
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.file_upload_outlined,
                                        size: 25.0,
                                        color:
                                            CustomTheme.of(context).splashColor,
                                      ),
                                      SizedBox(
                                        height: 10.0,
                                      ),
                                      Text(
                                        PanImg == "img65"
                                            ? "ID Document (if document type passport)*"
                                            : "ID Document Captured",
                                        textAlign: TextAlign.center,
                                        style: CustomWidget(context: context)
                                            .CustomSizedTextStyle(
                                                13.0,
                                                Theme.of(context).splashColor,
                                                FontWeight.w400,
                                                'FontRegular'),
                                      ),
                                      SizedBox(
                                        height: 10.0,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 10.0,
                              ),

                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    "Note :".toUpperCase(),
                                    style: CustomWidget(context: context)
                                        .CustomSizedTextStyle(
                                            13.0,
                                            Theme.of(context)
                                                .scaffoldBackgroundColor,
                                            FontWeight.w600,
                                            'FontRegular'),
                                  ),
                                  SizedBox(
                                    height: 5.0,
                                  ),
                                  Text(
                                    "To avoid delays with verification process, please double-check to ensure the above requirements are fully met. Chosen credential must not be expired.",
                                    style: CustomWidget(context: context)
                                        .CustomSizedTextStyle(
                                            13.0,
                                            Theme.of(context).splashColor,
                                            FontWeight.w400,
                                            'FontRegular'),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 20.0,
                              ),
                              ButtonCustom(
                                  text: verify
                                      ? AppLocalizations.instance
                                          .text("loc_submit")
                                      : "Verify Details",
                                  iconEnable: false,
                                  radius: 5.0,
                                  icon: "",
                                  textStyle: CustomWidget(context: context)
                                      .CustomSizedTextStyle(
                                          18.0,
                                          Theme.of(context).splashColor,
                                          FontWeight.w500,
                                          'FontRegular'),
                                  iconColor:
                                      CustomTheme.of(context).shadowColor,
                                  shadowColor:
                                      CustomTheme.of(context).shadowColor,
                                  splashColor:
                                      CustomTheme.of(context).shadowColor,
                                  onPressed: () {
                                    if (_formKey.currentState!.validate()) {
                                      if (AadharImg == "img64") {
                                        CustomWidget(context: context).custombar(
                                            "Verify KYC",
                                            "Please Choose the ID Front Document ",
                                            false);
                                      } else if (PanImg == "img65") {
                                        CustomWidget(context: context).custombar(
                                            "Verify KYC",
                                            "Please Choose the ID Back Document ",
                                            false);
                                      } else {
                                        setState(() {
                                          loading = true;
                                          updateKyc();
                                        });
                                      }
                                    }
                                  },
                                  paddng: 1.0),
                              SizedBox(
                                height: 10.0,
                              ),
                            ],
                          ),
                        ),
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
        ));
  }

  onRequestPermission(bool type) async {
    var status = await Permission.storage.status;
    if (status.isDenied) {
      // You can request multiple permissions at once.
      Map<Permission, PermissionStatus> statuses = await [
        Permission.storage,
        Permission.camera,
      ].request();
      _pickedImageDialog(type);
    } else {
      _pickedImageDialog(type);
    }
  }

  _pickedImageDialog(bool type) {
    showModalBottomSheet<void>(
      //background color for modal bottom screen
      backgroundColor: AppColors.backgroundColor,
      //elevates modal bottom screen
      elevation: 10,
      isScrollControlled: true,
      // gives rounded corner to modal bottom screen
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10.0),
          topRight: Radius.circular(10.0),
        ),
      ),
      // context and builder are
      // required properties in this widget
      context: context,
      builder: (BuildContext context) {
        // we set up a container inside which
        // we create center column and display text

        // Returning SizedBox instead of a Container
        return SingleChildScrollView(
            child: Container(
          padding: EdgeInsets.all(10.0),
          child: Column(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Choose image source",
                      style: CustomWidget(context: context)
                          .CustomSizedTextStyle(16.0, AppColors.blackColor,
                              FontWeight.w600, 'FontRegular'),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 30.0,
              ),
              Container(
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: ButtonCustom(
                              text: "Gallery",
                              iconEnable: false,
                              radius: 5.0,
                              icon: "",
                              textStyle: CustomWidget(context: context)
                                  .CustomSizedTextStyle(
                                      18.0,
                                      AppColors.whiteColor,
                                      FontWeight.w500,
                                      'FontRegular'),
                              iconColor: AppColors.appColor,
                              shadowColor: AppColors.appColor,
                              splashColor: AppColors.appColor,
                              onPressed: () {
                                setState(() {
                                  Navigator.pop(context);
                                  getImage(ImageSource.gallery, type);
                                });
                              },
                              paddng: 1.0),
                          flex: 4,
                        ),
                        SizedBox(
                          width: 10.0,
                        ),
                        Flexible(
                          child: ButtonCustom(
                              text: "Camera",
                              iconEnable: false,
                              radius: 5.0,
                              icon: "",
                              textStyle: CustomWidget(context: context)
                                  .CustomSizedTextStyle(
                                      18.0,
                                      AppColors.whiteColor,
                                      FontWeight.w500,
                                      'FontRegular'),
                              iconColor: AppColors.appColor,
                              shadowColor: AppColors.appColor,
                              splashColor: AppColors.appColor,
                              onPressed: () {
                                setState(() {
                                  Navigator.pop(context);
                                  getImage(ImageSource.camera, type);
                                });
                              },
                              paddng: 1.0),
                          flex: 4,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
      },
    );
  }

  /// Get from gallery
  getImage(ImageSource type, bool imageType) async {
    print(imageType);
    var pickedFile = await picker.pickImage(source: type);
    if (pickedFile != null) {
      if (imageType) {
        setState(() {
          PanImg = pickedFile.path;
        });
      } else {
        setState(() {
          AadharImg = pickedFile.path;
        });
      }
    }
  }

  updateKyc() {
    apiUtils
        .updateKycDetails(
            firstNameController.text.toString(),
            lastNameController.text.toString(),
            _selectedCountry!.callingCode.toString(),
            mobile.text.toString(),
            dobController.text.toString(),
            selectedGender.toString(),
            selectedCountryType!.code.toString(),
            cityController.text.toString(),
            statesController.text.toString(),
            zipController.text.toString(),
            addressController.text.toString(),
            addressLineController.text.toString(),
            selectedIdProof.toString().toLowerCase(),
            idController.text.toString(),
            expController.text.toString(),
            AadharImg,
            PanImg)
        .then((CommonModel loginData) {
      if (loginData.status!) {
        setState(() {
          loading = false;
        });
        CustomWidget(context: context)
            .custombar("Verify KYC", loginData.message.toString(), true);
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => LinkEmailAddress(),
          ),
        );
      } else {
        setState(() {
          loading = false;
          CustomWidget(context: context)
              .custombar("Verify KYC", loginData.message.toString(), false);
        });
      }
    }).catchError((Object error) {
      print(error);
      setState(() {
        loading = false;
      });
    });
  }

  void _onPressedShowBottomSheet() async {
    final country = await showCountryPickerSheets(
      context,
    );
    if (country != null) {
      setState(() {
        _selectedCountry = country;
      });
    }
  }

  getCountryCodeDetils() {
    apiUtils.countryCodeDetils().then((CountryCodeModelDetails loginData) {
      if (loginData.success!) {
        setState(() {
          loading = false;
          countryList = loginData.result!;
          countryPrincList = loginData.result!;
          countryIssueList = loginData.result!;
          selectedCountryType = countryList.first;
          selectedPrinCountryType = countryPrincList.first;
          selectedIssueCountryType = countryIssueList.first;
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
