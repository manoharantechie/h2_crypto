import 'dart:convert';

import 'package:country_calling_code_picker/picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:h2_crypto/common/colors.dart';
import 'package:h2_crypto/common/country.dart';
import 'package:h2_crypto/data/api_utils.dart';
import 'package:h2_crypto/data/model/common_model.dart';
import 'dart:io' as Io;
import 'dart:convert';

import '../../../common/custom_button.dart';
import '../../../common/custom_widget.dart';
import '../../../common/localization/localizations.dart';
import '../../../common/theme/custom_theme.dart';

class KYCPage extends StatefulWidget {
  const KYCPage({Key? key}) : super(key: key);

  @override
  State<KYCPage> createState() => _KYCPageState();
}

class _KYCPageState extends State<KYCPage> {
  Country? _selectedCountry;

  DateTime? selectedDateOfBirth;
  DateTime? selectedExDate;
  bool verify = false;
  String selectedTime = "";

  var documentUri = "";
  final _formKey = GlobalKey<FormState>();
  String imagePath = "assets/others/banner.png";
  var faceUri = "";

  APIUtils apiUtils=APIUtils();
  bool aadharVerifyStatus = false;
  bool panVerifyStatus = false;
  bool loading = false;
  bool  imageCapture = true;
  // bool _autoValidate = true;

  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController idController = TextEditingController();
  TextEditingController dobController = TextEditingController();
  TextEditingController aadharController = TextEditingController();
  TextEditingController panController = TextEditingController();

  List<String> genderType = [
    "Male",
    "Female",
  ];
  String selectedGender = "";
  String panUrl = "";
  String aadharUrl = "";
  String faceUrl = "";
  bool countryB = false;

  String AadharImg = "img64";

  String PanImg = "img65";
  String selfieImage = "img66";

  String aadharScore = "0";
  String panScore = "0";

  var appID = "f7b6fd";
  var appKey = "add7cfab0546db139b47";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    selectedDateOfBirth = DateTime((DateTime.now()).year - 18,
        (DateTime.now()).month, (DateTime.now()).day); //DateTime.now();
    selectedExDate = DateTime.now();
    initCountry();

    selectedGender = genderType.first;
  }


  /// Opens QR scanner screen

  void initCountry() async {
    final country = await getDefaultCountry(context);
    setState(() {
      _selectedCountry = country;
      countryB = true;
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
            accentColor: CustomTheme.of(context).primaryColor,
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

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: CustomTheme.of(context).primaryColor,
        elevation: 0.0,
        leading: Container(
            padding: const EdgeInsets.all(18.0),
            child: InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: SvgPicture.asset(
                'assets/others/arrow_left.svg',
                height: 8.0,
                width: 8.0,
                color: CustomTheme.of(context).splashColor,
                allowDrawingOutsideViewBox: true,
              ),
            )),
        centerTitle: true,
        title: Text(
          AppLocalizations.instance.text("loc_kyc_head"),
          style: CustomWidget(context: context).CustomSizedTextStyle(16.0,
              Theme.of(context).splashColor, FontWeight.w500, 'FontRegular'),
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
              CustomTheme.of(context).accentColor,
            ])),
        child: SingleChildScrollView(
          child: SafeArea(
            child: Container(
              padding: EdgeInsets.only(
                  top: 5.0, bottom: 10.0, right: 15.0, left: 15.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Container(
                    //   width: MediaQuery.of(context).size.width,
                    //   padding: EdgeInsets.fromLTRB(12, 15.0, 12, 15.0),
                    //   decoration: BoxDecoration(
                    //     border: Border.all(color: CustomTheme.of(context).hintColor, width: 1.0),
                    //     borderRadius: BorderRadius.circular(5.0),
                    //     color: CustomTheme.of(context).backgroundColor,
                    //   ),
                    //   child:    InkWell(
                    //     onTap: _onPressedShowBottomSheet,
                    //     child: Row(
                    //        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //       children: [
                    //         Text(
                    //           countryB
                    //               ? _selectedCountry!.name.toString()
                    //               : "India",
                    //           style: CustomWidget(context: context)
                    //               .CustomTextStyle(
                    //               Theme.of(context).splashColor,
                    //               FontWeight.normal,
                    //               'FontRegular'),
                    //         ),
                    //         const SizedBox(
                    //           width: 3.0,
                    //         ),
                    //         const Icon(
                    //           Icons.keyboard_arrow_down_outlined,
                    //           size: 15.0,
                    //           color: AppColors.backgroundColor,
                    //         )
                    //       ],
                    //     ),
                    //   ),
                    // ),
                    // SizedBox(height: 10.0,),

                    TextFormField(
                      controller: firstNameController,
                      // focusNode: emailFocus,
                      maxLines: 1,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      // autocorrect: _autoValidate,
                      // enabled: emailVerify,
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.emailAddress,
                      style: CustomWidget(context: context).CustomTextStyle(
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
                                Theme.of(context).splashColor,
                                FontWeight.w300,
                                'FontRegular'),
                        filled: true,
                        fillColor: CustomTheme.of(context)
                            .backgroundColor
                            ,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide: BorderSide(
                              color: CustomTheme.of(context)
                                  .splashColor
                                  ,
                              width: 1.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide: BorderSide(
                              color: CustomTheme.of(context)
                                  .splashColor
                                  ,
                              width: 1),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide: BorderSide(
                              color: CustomTheme.of(context)
                                  .splashColor
                                  ,
                              width: 1.0),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide: BorderSide(color: Colors.red, width: 1.0),
                        ),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Please enter FirstName";
                        }
                        else {
                          return value.length < 4 ? 'Minimum character length is 4' : null;
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
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      // enabled: emailVerify,
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.emailAddress,
                      style: CustomWidget(context: context).CustomTextStyle(
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
                                Theme.of(context).splashColor,
                                FontWeight.w300,
                                'FontRegular'),
                        filled: true,
                        fillColor: CustomTheme.of(context)
                            .backgroundColor
                            ,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide: BorderSide(
                              color: CustomTheme.of(context)
                                  .splashColor
                                  ,
                              width: 1.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide: BorderSide(
                              color: CustomTheme.of(context)
                                  .splashColor
                                  ,
                              width: 1),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide: BorderSide(
                              color: CustomTheme.of(context)
                                  .splashColor
                                  ,
                              width: 1.0),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide: BorderSide(color: Colors.red, width: 1.0),
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
                    Container(
                      width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.fromLTRB(12.0, 0.0, 12, 0.0),
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: CustomTheme.of(context)
                                .hintColor
                                ,
                            width: 1.0),
                        borderRadius: BorderRadius.circular(5.0),
                        color: CustomTheme.of(context)
                            .backgroundColor
                            ,
                      ),
                      child: Theme(
                        data: Theme.of(context).copyWith(
                          canvasColor: CustomTheme.of(context).cardColor,
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton(
                            menuMaxHeight:
                                MediaQuery.of(context).size.height * 0.7,
                            items: genderType
                                .map((value) => DropdownMenuItem(
                                      child: Text(
                                        value.toString(),
                                        style: CustomWidget(context: context)
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
                                      Theme.of(context)
                                          .hintColor
                                          ,
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
                    //
                    // TextFormField(
                    //    controller: idController,
                    //   // focusNode: emailFocus,
                    //   maxLines: 1,
                    //   // enabled: emailVerify,
                    //   textInputAction: TextInputAction.next,
                    //   keyboardType: TextInputType.emailAddress,
                    //   style: CustomWidget(context: context)
                    //       .CustomTextStyle(
                    //       Theme.of(context).splashColor,
                    //       FontWeight.w400,
                    //       'FontRegular'),
                    //   decoration: InputDecoration(
                    //     contentPadding: const EdgeInsets.only(
                    //         left: 12, right: 0, top: 2, bottom: 2),
                    //     hintText: "ID Number",
                    //     hintStyle: CustomWidget(context: context)
                    //         .CustomSizedTextStyle(
                    //         14.0,
                    //         Theme.of(context).splashColor,
                    //         FontWeight.w300,
                    //         'FontRegular'),
                    //     filled: true,
                    //     fillColor: CustomTheme.of(context)
                    //         .backgroundColor
                    //         ,
                    //     border: OutlineInputBorder(
                    //       borderRadius: BorderRadius.circular(5),
                    //       borderSide: BorderSide(
                    //           color: CustomTheme.of(context)
                    //               .splashColor
                    //               ,
                    //           width: 1.0),
                    //     ),
                    //     enabledBorder: OutlineInputBorder(
                    //       borderRadius: BorderRadius.circular(5),
                    //       borderSide: BorderSide(
                    //           color: CustomTheme.of(context)
                    //               .splashColor
                    //               ,
                    //           width:1),
                    //     ),
                    //     focusedBorder: OutlineInputBorder(
                    //       borderRadius: BorderRadius.circular(5),
                    //       borderSide: BorderSide(
                    //           color: CustomTheme.of(context)
                    //               .splashColor
                    //               ,
                    //           width: 1.0),
                    //     ),
                    //     errorBorder: OutlineInputBorder(
                    //       borderRadius: BorderRadius.circular(5),
                    //       borderSide: BorderSide(
                    //           color: CustomTheme.of(context)
                    //               .splashColor
                    //               ,
                    //           width: 1.0),
                    //     ),
                    //   ),
                    // ),
                    // SizedBox(height: 10.0,),
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
                        style: CustomWidget(context: context).CustomTextStyle(
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
                                      ,
                                  FontWeight.w300,
                                  'FontRegular'),
                          filled: true,
                          fillColor: CustomTheme.of(context)
                              .backgroundColor
                              ,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide: BorderSide(
                                color: CustomTheme.of(context)
                                    .splashColor
                                    ,
                                width: 1.0),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide: BorderSide(
                                color: CustomTheme.of(context)
                                    .splashColor
                                    ,
                                width: 1),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide: BorderSide(
                                color: CustomTheme.of(context)
                                    .splashColor
                                    ,
                                width: 1.0),
                          ),
                          disabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide: BorderSide(
                                color: CustomTheme.of(context)
                                    .splashColor
                                    ,
                                width: 1),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide:
                                BorderSide(color: Colors.red, width: 1.0),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),

                    TextFormField(
                      controller: panController,
                      // autocorrect: _autoValidate,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      // focusNode: emailFocus,
                      maxLines: 1,
                      // enabled: emailVerify,
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.emailAddress,
                      style: CustomWidget(context: context).CustomTextStyle(
                          Theme.of(context).splashColor,
                          FontWeight.w400,
                          'FontRegular'),
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.only(
                            left: 12, right: 0, top: 2, bottom: 2),
                        hintText: "PAN number",
                        hintStyle: CustomWidget(context: context)
                            .CustomSizedTextStyle(
                            14.0,
                            Theme.of(context).splashColor,
                            FontWeight.w300,
                            'FontRegular'),
                        filled: true,
                        fillColor: CustomTheme.of(context)
                            .backgroundColor
                            ,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide: BorderSide(
                              color: CustomTheme.of(context)
                                  .splashColor
                                  ,
                              width: 1.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide: BorderSide(
                              color: CustomTheme.of(context)
                                  .splashColor
                                  ,
                              width: 1),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide: BorderSide(
                              color: CustomTheme.of(context)
                                  .splashColor
                                  ,
                              width: 1.0),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide: BorderSide(color: Colors.red, width: 1.0),
                        ),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Please enter PAN Number";
                        } else if (!RegExp(r"^[A-Z]{5}[0-9]{4}[A-Z]{1}$")
                            .hasMatch(value)) {
                          return "Please enter valid PAN Number";
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    InkWell(
                      onTap: () async {

                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        padding: EdgeInsets.fromLTRB(10, 50.0, 10, 40.0),
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: CustomTheme.of(context)
                                  .hintColor
                                  ,
                              width: 1.0),
                          borderRadius: BorderRadius.circular(5.0),
                          color: Colors.transparent,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              'assets/images/add.svg',
                              height: 20.0,
                              width: 20.0,
                              allowDrawingOutsideViewBox: true,
                              color: CustomTheme.of(context).splashColor,
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            Text(
                              PanImg=="img65"
                                  ? "Please Capture a photo of your PAN’s information page"
                                  : "PAN's Captured",
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
                    TextFormField(
                      controller: aadharController,
                      // focusNode: emailFocus,
                      maxLines: 1,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      // autocorrect: _autoValidate,
                      // enabled: emailVerify,
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.number,
                      style: CustomWidget(context: context).CustomTextStyle(
                          Theme.of(context).splashColor,
                          FontWeight.w400,
                          'FontRegular'),
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.only(
                            left: 12, right: 0, top: 2, bottom: 2),
                        hintText: "Aadhar number",
                        hintStyle: CustomWidget(context: context)
                            .CustomSizedTextStyle(
                            14.0,
                            Theme.of(context).splashColor,
                            FontWeight.w300,
                            'FontRegular'),
                        filled: true,
                        fillColor: CustomTheme.of(context)
                            .backgroundColor
                            ,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide: BorderSide(
                              color: CustomTheme.of(context)
                                  .splashColor
                                  ,
                              width: 1.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide: BorderSide(
                              color: CustomTheme.of(context)
                                  .splashColor
                                  ,
                              width: 1),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide: BorderSide(
                              color: CustomTheme.of(context)
                                  .splashColor
                                  ,
                              width: 1.0),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide: BorderSide(color: Colors.red, width: 1.0),
                        ),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Please enter Aadhar Number";
                        }
                        else if(value.length!=12){
                          return "Please enter valid Aadhar Number(1234 1234 1234)";
                        }
                        // else if (!RegExp(r"/(^[0-9]{4}[0-9]{4}[0-9]{4}$)|(^[0-9]{4}\s[0-9]{4}\s[0-9]{4}$)|(^[0-9]{4}-[0-9]{4}-[0-9]{4}$)/")
                        //     .hasMatch(value)) {
                        //   return "Please enter valid Aadhar Number(1234 1234 1234)";
                        //}
                        return null;
                      },
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    InkWell(
                      onTap: () async {

                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        padding: EdgeInsets.fromLTRB(10, 50.0, 10, 40.0),
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: CustomTheme.of(context)
                                  .hintColor
                                  ,
                              width: 1.0),
                          borderRadius: BorderRadius.circular(5.0),
                          color: Colors.transparent,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              'assets/images/add.svg',
                              height: 20.0,
                              width: 20.0,
                              allowDrawingOutsideViewBox: true,
                              color: CustomTheme.of(context).splashColor,
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            Text(
                              AadharImg =="img64" ? "Please Capture a photo of your Aadhar’s information page": "Aadhar's Captured",
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
                    InkWell(
                      onTap: () async {

                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        padding: EdgeInsets.fromLTRB(10, 50.0, 10, 40.0),
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: CustomTheme.of(context)
                                  .hintColor
                                  ,
                              width: 1.0),
                          borderRadius: BorderRadius.circular(5.0),
                          color: Colors.transparent,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              'assets/images/add.svg',
                              height: 20.0,
                              width: 20.0,
                              allowDrawingOutsideViewBox: true,
                              color: CustomTheme.of(context).splashColor,
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            Text(

                              selfieImage == "img66" ? "Please Capture a photo of your Selfie": "Selfie Captured",
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
                          "The information on the certification must be visible and clear.no modification or obscuring is allowed. the number and name on the cerification must be visible.",
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
                            ? AppLocalizations.instance.text("loc_submit")
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
                        iconColor: CustomTheme.of(context).buttonColor,
                        buttonColor: CustomTheme.of(context).buttonColor,
                        splashColor: CustomTheme.of(context).buttonColor,
                        onPressed: () {

                          setState(() {
                            print(_formKey.currentState!.validate());
                            if (_formKey.currentState!.validate()) {

                              if (!verify) {

                                loading=true;

                              } else {

                                int pScore=int.parse(panScore);
                                int aScore=int.parse(aadharScore);
                                int score=((pScore+aScore)/2).toInt();
                                if(panVerifyStatus&& aadharVerifyStatus&& score>=50)
                                {
                                  loading=true;
                                  updateKyc();
                                }
                                else
                                  {
                                    CustomWidget(context: context).  custombar("Verify KYC", "Upload Your ID Details again..! " ,false);
                                  }
                              }
                            }
                            else{

                            }
                          });

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
      ),
    );
  }


  updateKyc() {
    apiUtils
        .updateKycDetails(firstNameController.text.toString(),lastNameController.text.toString(),dobController.text.toString(),selectedGender.toString(),panController.text.toString(),aadharController.text.toString(),AadharImg,PanImg,selfieImage)
        .then((CommonModel loginData) {
      if (loginData.status.toString() == "200") {
        setState(() {
          loading=false;
        });
        CustomWidget(context: context).  custombar("Verify KYC", loginData.message.toString(), true);
        Navigator.pop(context,true);
      }

      else {
        setState(() {
          loading = false;
          CustomWidget(context: context).  custombar("Verify KYC", loginData.message.toString(), false);
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
}

