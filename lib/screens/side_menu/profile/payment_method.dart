import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:h2_crypto/data/model/common_model.dart';
import 'package:h2_crypto/data/model/margin_loan_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../common/colors.dart';
import '../../../common/custom_widget.dart';
import '../../../common/textformfield_custom.dart';
import '../../../common/theme/custom_theme.dart';
import '../../../data/api_utils.dart';
import '../../../data/model/get_payment_details_model.dart';

class Payment_Method_Screen extends StatefulWidget {
  const Payment_Method_Screen({Key? key}) : super(key: key);

  @override
  State<Payment_Method_Screen> createState() => _Payment_Method_ScreenState();
}

class _Payment_Method_ScreenState extends State<Payment_Method_Screen> {
  bool loading = false;
  bool bank = false;
  bool upi = false;
  bool paytm = false;
  bool imps = false;
  String? pay_method;
  FocusNode nameFocus = FocusNode();
  FocusNode accTypeFocus = FocusNode();
  FocusNode branchTypeFocus = FocusNode();
  FocusNode bank_nameFocus = FocusNode();
  FocusNode ifscFocus = FocusNode();
  FocusNode accnumberFocus = FocusNode();
  FocusNode upiFocus = FocusNode();
  String userId = "";
  String upiId = "";
  String paymentName = "";

  // String bankType = "";
  APIUtils apiUtils = APIUtils();
  List<Payment> allPaymentDetails = [];
  final valformKey = GlobalKey<FormState>();
  final valformKeys = GlobalKey<FormState>();

  TextEditingController nameController = TextEditingController();
  TextEditingController upidetails = TextEditingController();
  TextEditingController accType = TextEditingController();
  TextEditingController branchType = TextEditingController();
  TextEditingController ifsc = TextEditingController();
  TextEditingController accnumber = TextEditingController();
  TextEditingController bank_name = TextEditingController();
  ScrollController controller = ScrollController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loading = true;
    getUserId();
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
        data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
        child: Scaffold(
          backgroundColor: AppColors.whiteColor,
          appBar: AppBar(
              backgroundColor: CustomTheme.of(context).primaryColor,
              elevation: 0.0,
              centerTitle: true,
              title: Text(
                "Payment Method",
                style: CustomWidget(context: context).CustomSizedTextStyle(
                    17.0,
                    Theme.of(context).splashColor,
                    FontWeight.w500,
                    'FontRegular'),
              ),
              leading: InkWell(
                onTap: () {
                  Navigator.pop(context, true);
                },
                child: Container(
                  padding: EdgeInsets.only(left: 16.0, right: 16.0),
                  child: SvgPicture.asset(
                    'assets/others/arrow_left.svg',
                    color: CustomTheme.of(context).splashColor,
                  ),
                ),
              )),
          body: SingleChildScrollView(
            controller: controller,
            child: Container(
              height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(
                color: CustomTheme.of(context).primaryColor,
              ),
              padding: EdgeInsets.only(left: 15.0, right: 15.0, top: 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  SizedBox(height: 10.0),
                  InkWell(
                    onTap: () {
                      setState(() {
                        showSuccessAlertDialog("Payment Method", "IMPS",
                            "Bank Transfer", "UPI", "PayTM");
                        pay_method = "";
                      });
                    },
                    child: Container(
                        width: MediaQuery.of(context).size.width * 0.3,
                        decoration: BoxDecoration(
                          color: CustomTheme.of(context).selectedRowColor,
                          borderRadius: BorderRadius.all(Radius.circular(5.0)),
                        ),
                        padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                        child: Center(
                          child: Text(
                            "Add Payment",
                            style: CustomWidget(context: context)
                                .CustomTextStyle(
                                    CustomTheme.of(context).splashColor,
                                    FontWeight.w500,
                                    'FontRegular'),
                          ),
                        )),
                  ),
                  SizedBox(height: 30.0),
                  allPaymentDetails.length > 0
                      ? Container(
                          height: MediaQuery.of(context).size.height * 0.72,
                          width: MediaQuery.of(context).size.width,
                          child: ListView.builder(
                              itemCount: allPaymentDetails.length,
                              shrinkWrap: true,
                              itemBuilder: (BuildContext context, int index) {
                                return allPaymentDetails[index]
                                                .Payment_name
                                                .toString() ==
                                            "bank" ||
                                        allPaymentDetails[index]
                                                .Payment_name
                                                .toString() ==
                                            "imps"
                                    ? Column(
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                              color: CustomTheme.of(context)
                                                  .backgroundColor,
                                            ),
                                            padding: EdgeInsets.only(
                                                left: 15.0,
                                                right: 15.0,
                                                top: 10.0,
                                                bottom: 10.0),
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            child: Column(
                                              children: [
                                                Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  children: [
                                                    InkWell(
                                                      onTap: () {
                                                        print("press" +
                                                            allPaymentDetails[
                                                                    index]
                                                                .Payment_name
                                                                .toString());
                                                        _showModal(true);
                                                        pay_method =
                                                            allPaymentDetails[
                                                                    index]
                                                                .Payment_name
                                                                .toString();
                                                        imps = true;
                                                        upi = false;
                                                        upiId =
                                                            allPaymentDetails[
                                                                    index]
                                                                .upiId
                                                                .toString();
                                                        paymentName =
                                                            allPaymentDetails[
                                                                    index]
                                                                .Payment_name
                                                                .toString();
                                                        nameController.text =
                                                            allPaymentDetails[
                                                                    index]
                                                                .name
                                                                .toString();
                                                        accType.text =
                                                            allPaymentDetails[
                                                                    index]
                                                                .accType
                                                                .toString();
                                                        branchType.text =
                                                            allPaymentDetails[
                                                                    index]
                                                                .branch
                                                                .toString();
                                                        ifsc.text =
                                                            allPaymentDetails[
                                                                    index]
                                                                .ifsc
                                                                .toString();
                                                        accnumber.text =
                                                            allPaymentDetails[
                                                                    index]
                                                                .accNum
                                                                .toString();
                                                        bank_name.text =
                                                            allPaymentDetails[
                                                                    index]
                                                                .bankName
                                                                .toString();
                                                      },
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                left: 5.0,
                                                                right: 5.0),
                                                        child: Icon(
                                                          Icons.edit_outlined,
                                                          color: CustomTheme.of(
                                                                  context)
                                                              .buttonColor,
                                                          size: 20.0,
                                                        ),
                                                      ),
                                                    ),
                                                    InkWell(
                                                      onTap: () {
                                                        showSuccesssAlertDialog(
                                                            "Delete",
                                                            "Are you sure want to Delete ?",
                                                            allPaymentDetails[
                                                                    index]
                                                                .Payment_name
                                                                .toString());
                                                      },
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                left: 5.0,
                                                                right: 0.0),
                                                        child: Icon(
                                                          Icons.delete_outlined,
                                                          color: CustomTheme.of(
                                                                  context)
                                                              .buttonColor,
                                                          size: 20.0,
                                                        ),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: 15.0,
                                                ),
                                                Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      "Payment Type",
                                                      style: CustomWidget(
                                                              context: context)
                                                          .CustomTextStyle(
                                                              CustomTheme.of(
                                                                      context)
                                                                  .splashColor,
                                                              FontWeight.w500,
                                                              'FontRegular'),
                                                    ),
                                                    Text(
                                                      allPaymentDetails[index]
                                                                  .Payment_name
                                                                  .toString()
                                                                  .toUpperCase() ==
                                                              "null"
                                                          ? "-"
                                                          : allPaymentDetails[
                                                                  index]
                                                              .Payment_name
                                                              .toString()
                                                              .toUpperCase(),
                                                      style: CustomWidget(
                                                              context: context)
                                                          .CustomTextStyle(
                                                              CustomTheme.of(
                                                                      context)
                                                                  .splashColor,
                                                              FontWeight.w500,
                                                              'FontRegular'),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: 15.0,
                                                ),
                                                Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      "Name",
                                                      style: CustomWidget(
                                                              context: context)
                                                          .CustomTextStyle(
                                                              CustomTheme.of(
                                                                      context)
                                                                  .splashColor,
                                                              FontWeight.w500,
                                                              'FontRegular'),
                                                    ),
                                                    Text(
                                                      allPaymentDetails[index]
                                                                  .name
                                                                  .toString()
                                                                  .toUpperCase() ==
                                                              "null"
                                                          ? "-"
                                                          : allPaymentDetails[
                                                                  index]
                                                              .name
                                                              .toString()
                                                              .toUpperCase(),
                                                      style: CustomWidget(
                                                              context: context)
                                                          .CustomTextStyle(
                                                              CustomTheme.of(
                                                                      context)
                                                                  .splashColor,
                                                              FontWeight.w500,
                                                              'FontRegular'),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: 15.0,
                                                ),
                                                Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      "Account Number",
                                                      style: CustomWidget(
                                                              context: context)
                                                          .CustomTextStyle(
                                                              CustomTheme.of(
                                                                      context)
                                                                  .splashColor,
                                                              FontWeight.w500,
                                                              'FontRegular'),
                                                    ),
                                                    Text(
                                                      allPaymentDetails[index]
                                                                  .accNum
                                                                  .toString() ==
                                                              "null"
                                                          ? "-"
                                                          : allPaymentDetails[
                                                                  index]
                                                              .accNum
                                                              .toString(),
                                                      style: CustomWidget(
                                                              context: context)
                                                          .CustomTextStyle(
                                                              CustomTheme.of(
                                                                      context)
                                                                  .splashColor,
                                                              FontWeight.w500,
                                                              'FontRegular'),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: 15.0,
                                                ),
                                                Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      "Bank Name",
                                                      style: CustomWidget(
                                                              context: context)
                                                          .CustomTextStyle(
                                                              CustomTheme.of(
                                                                      context)
                                                                  .splashColor,
                                                              FontWeight.w500,
                                                              'FontRegular'),
                                                    ),
                                                    Text(
                                                      allPaymentDetails[index]
                                                                  .bankName
                                                                  .toString()
                                                                  .toUpperCase() ==
                                                              "null"
                                                          ? "-"
                                                          : allPaymentDetails[
                                                                  index]
                                                              .bankName
                                                              .toString()
                                                              .toUpperCase(),
                                                      style: CustomWidget(
                                                              context: context)
                                                          .CustomTextStyle(
                                                              CustomTheme.of(
                                                                      context)
                                                                  .splashColor,
                                                              FontWeight.w500,
                                                              'FontRegular'),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: 15.0,
                                                ),
                                                Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      "Branch ",
                                                      style: CustomWidget(
                                                              context: context)
                                                          .CustomTextStyle(
                                                              CustomTheme.of(
                                                                      context)
                                                                  .splashColor,
                                                              FontWeight.w500,
                                                              'FontRegular'),
                                                    ),
                                                    Text(
                                                      allPaymentDetails[index]
                                                                  .branch
                                                                  .toString()
                                                                  .toUpperCase() ==
                                                              "null"
                                                          ? "-"
                                                          : allPaymentDetails[
                                                                  index]
                                                              .branch
                                                              .toString()
                                                              .toUpperCase(),
                                                      style: CustomWidget(
                                                              context: context)
                                                          .CustomTextStyle(
                                                              CustomTheme.of(
                                                                      context)
                                                                  .splashColor,
                                                              FontWeight.w500,
                                                              'FontRegular'),
                                                    ),
                                                  ],
                                                )
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                            height: 10.0,
                                          )
                                        ],
                                      )
                                    : Column(
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                              color: CustomTheme.of(context)
                                                  .backgroundColor,
                                            ),
                                            padding: EdgeInsets.only(
                                                left: 15.0,
                                                right: 15.0,
                                                top: 10.0,
                                                bottom: 10.0),
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            child: Column(
                                              children: [
                                                Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  children: [
                                                    InkWell(
                                                      onTap: () {
                                                        print("press" +
                                                            allPaymentDetails[
                                                                    index]
                                                                .Payment_name
                                                                .toString());
                                                        _showModal(true);
                                                        pay_method =
                                                            allPaymentDetails[
                                                                    index]
                                                                .Payment_name
                                                                .toString();
                                                        upi = true;
                                                        imps = false;
                                                        upidetails.text =
                                                            allPaymentDetails[
                                                                    index]
                                                                .upiId
                                                                .toString();
                                                        paymentName =
                                                            allPaymentDetails[
                                                                    index]
                                                                .Payment_name
                                                                .toString();
                                                      },
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                left: 5.0,
                                                                right: 5.0),
                                                        child: Icon(
                                                          Icons.edit_outlined,
                                                          color: CustomTheme.of(
                                                                  context)
                                                              .buttonColor,
                                                          size: 20.0,
                                                        ),
                                                      ),
                                                    ),
                                                    InkWell(
                                                      onTap: () {
                                                        showSuccesssAlertDialog(
                                                            "Delete",
                                                            "Are you sure want to Delete ?",
                                                            allPaymentDetails[
                                                                    index]
                                                                .Payment_name
                                                                .toString());
                                                      },
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                left: 5.0,
                                                                right: 0.0),
                                                        child: Icon(
                                                          Icons.delete_outlined,
                                                          color: CustomTheme.of(
                                                                  context)
                                                              .buttonColor,
                                                          size: 20.0,
                                                        ),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: 15.0,
                                                ),
                                                Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      "Payment Type",
                                                      style: CustomWidget(
                                                              context: context)
                                                          .CustomTextStyle(
                                                              CustomTheme.of(
                                                                      context)
                                                                  .splashColor,
                                                              FontWeight.w500,
                                                              'FontRegular'),
                                                    ),
                                                    Text(
                                                      allPaymentDetails[index]
                                                                  .Payment_name
                                                                  .toString()
                                                                  .toUpperCase() ==
                                                              "null"
                                                          ? "-"
                                                          : allPaymentDetails[
                                                                  index]
                                                              .Payment_name
                                                              .toString()
                                                              .toUpperCase(),
                                                      style: CustomWidget(
                                                              context: context)
                                                          .CustomTextStyle(
                                                              CustomTheme.of(
                                                                      context)
                                                                  .splashColor,
                                                              FontWeight.w500,
                                                              'FontRegular'),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: 15.0,
                                                ),
                                                Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      "UPI Id",
                                                      style: CustomWidget(
                                                              context: context)
                                                          .CustomTextStyle(
                                                              CustomTheme.of(
                                                                      context)
                                                                  .splashColor,
                                                              FontWeight.w500,
                                                              'FontRegular'),
                                                    ),
                                                    Text(
                                                      allPaymentDetails[index]
                                                                  .upiId
                                                                  .toString() ==
                                                              "null"
                                                          ? "-"
                                                          : allPaymentDetails[
                                                                  index]
                                                              .upiId
                                                              .toString(),
                                                      style: CustomWidget(
                                                              context: context)
                                                          .CustomTextStyle(
                                                              CustomTheme.of(
                                                                      context)
                                                                  .splashColor,
                                                              FontWeight.w500,
                                                              'FontRegular'),
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
                                          )
                                        ],
                                      );
                              }),
                        )
                      : Container(
                          height: MediaQuery.of(context).size.height * 0.5,
                          // color: Theme.of(context).primaryColor.withOpacity(0.5),
                          child: Center(
                            child: Text(
                              "No Records Found..!",
                              style: CustomWidget(context: context)
                                  .CustomSizedTextStyle(
                                      12.0,
                                      Theme.of(context).splashColor,
                                      FontWeight.w400,
                                      'FontRegular'),
                            ),
                          ),
                        ),
                  SizedBox(height: 20.0),
                ],
              ),
            ),
          ),
        ));
  }

  showSuccessAlertDialog(
    String title,
    String message1,
    String message2,
    String message3,
    String message4,
  ) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (context, setState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)), //this right here
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
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
                height: MediaQuery.of(context).size.height * 0.5,
                width: MediaQuery.of(context).size.width,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        title.toUpperCase(),
                        style: TextStyle(
                          fontSize: 16.0,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'OpenSansBold',
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 5.0, bottom: 10.0),
                        height: 2.0,
                        color: AppColors.whiteColor,
                      ),
                      RadioListTile(
                        title: Text(
                          message1,
                          style: TextStyle(
                            fontSize: 12.0,
                            color: Colors.white,
                            fontFamily: 'OpenSans',
                          ),
                        ),
                        value: "imps",
                        groupValue: pay_method,
                        onChanged: (value) {
                          setState(() {
                            imps = true;
                            bank = false;
                            upi = false;
                            paytm = false;
                            pay_method = value.toString();
                          });
                        },
                      ),
                      RadioListTile(
                        title: Text(
                          message2,
                          style: TextStyle(
                            fontSize: 12.0,
                            color: Colors.white,
                            fontFamily: 'OpenSans',
                          ),
                        ),
                        value: "bank",
                        groupValue: pay_method,
                        onChanged: (value) {
                          setState(() {
                            imps = false;
                            bank = true;
                            upi = false;
                            paytm = false;
                            pay_method = value.toString();
                          });
                        },
                      ),
                      RadioListTile(
                        title: Text(
                          message3,
                          style: TextStyle(
                            fontSize: 12.0,
                            color: Colors.white,
                            fontFamily: 'OpenSans',
                          ),
                        ),
                        value: "upi",
                        groupValue: pay_method,
                        onChanged: (value) {
                          setState(() {
                            imps = false;
                            bank = false;
                            upi = true;
                            paytm = false;
                            pay_method = value.toString();
                          });
                        },
                      ),
                      RadioListTile(
                        title: Text(
                          message4,
                          style: TextStyle(
                            fontSize: 12.0,
                            color: Colors.white,
                            fontFamily: 'OpenSans',
                          ),
                        ),
                        value: "paytm",
                        groupValue: pay_method,
                        onChanged: (value) {
                          setState(() {
                            imps = false;
                            bank = false;
                            upi = false;
                            paytm = true;
                            pay_method = value.toString();
                          });
                        },
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.of(context).pop(true);
                            },
                            child: Container(
                                padding: const EdgeInsets.only(
                                    left: 15.0,
                                    right: 15.0,
                                    top: 10.0,
                                    bottom: 10.0),
                                decoration: BoxDecoration(
                                    color: CustomTheme.of(context)
                                        .highlightColor
                                        .withOpacity(0.5),
                                    borderRadius: BorderRadius.circular(5.0)),
                                child: Center(
                                  child: Text(
                                    "cancel",
                                    style: CustomWidget(context: context)
                                        .CustomTextStyle(
                                            Theme.of(context).splashColor,
                                            FontWeight.w500,
                                            'FontRegular'),
                                  ),
                                )),
                          ),
                          InkWell(
                            onTap: () {
                              setState(() {
                                nameController.clear();
                                accnumber.clear();
                                accType.clear();
                                branchType.clear();
                                ifsc.clear();
                                upidetails.clear();
                                bank_name.clear();
                                if (pay_method == false) {
                                  Navigator.of(context).pop(true);
                                  CustomWidget(context: context).custombar(
                                      "Payment Method",
                                      "Please Select Payment Method",
                                      false);
                                } else if (pay_method == "") {
                                  Navigator.of(context).pop(true);
                                  CustomWidget(context: context).custombar(
                                      "Payment Method",
                                      "Please Select Payment Method",
                                      false);
                                } else {
                                  Navigator.of(context).pop(true);
                                  _showModal(false);
                                }
                              });
                            },
                            child: Container(
                                padding: const EdgeInsets.only(
                                    left: 15.0,
                                    right: 15.0,
                                    top: 10.0,
                                    bottom: 10.0),
                                decoration: BoxDecoration(
                                    color: CustomTheme.of(context)
                                        .selectedRowColor,
                                    borderRadius: BorderRadius.circular(5.0)),
                                child: Center(
                                  child: Text(
                                    "Add Payment",
                                    style: CustomWidget(context: context)
                                        .CustomTextStyle(
                                            Theme.of(context).splashColor,
                                            FontWeight.w500,
                                            'FontRegular'),
                                  ),
                                )),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            );
          });
        });
    // show the dialog
  }

  void _showModal(bool update) {
    showModalBottomSheet(
        isScrollControlled: true,
        isDismissible: false,
        enableDrag: false,
        backgroundColor: Colors.transparent,
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            return Container(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              width: MediaQuery.of(context).size.width,

              // You can wrap this Column with Padding of 8.0 for better design
              child: bank || imps
                  ? SingleChildScrollView(
                      child: Container(
                          height: MediaQuery.of(context).size.height * 0.75,
                          width: MediaQuery.of(context).size.width,
                          color: Theme.of(context).primaryColor,
                          child: SingleChildScrollView(
                            controller: controller,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                SizedBox(
                                  height: 20.0,
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                      left: 15.0, right: 15.0, top: 10.0),
                                  child: Form(
                                      key: valformKey,
                                      child: Column(
                                        children: [
                                          TextFormFieldCustom(
                                            autovalidateMode: AutovalidateMode
                                                .onUserInteraction,
                                            onEditComplete: () {
                                              nameFocus.unfocus();
                                              FocusScope.of(context)
                                                  .requestFocus(accTypeFocus);
                                            },
                                            inputFormatters: [
                                              FilteringTextInputFormatter.allow(RegExp(r'[A-Za-z]')),
                                            ],
                                            radius: 5.0,
                                            error: "Enter Valid Name",
                                            textColor: CustomTheme.of(context)
                                                .splashColor,
                                            borderColor: CustomTheme.of(context)
                                                .splashColor
                                                .withOpacity(0.5),
                                            fillColor: CustomTheme.of(context)
                                                .backgroundColor
                                                .withOpacity(0.5),
                                            textInputAction:
                                                TextInputAction.next,
                                            focusNode: nameFocus,
                                            maxlines: 1,
                                            text: '',
                                            obscureText: false,
                                            suffix: Container(
                                              width: 0.0,
                                            ),
                                            textChanged: (value) {},
                                            onChanged: () {},
                                            validator: (value) {
                                              if (nameController.text ==
                                                      "null" ||
                                                  nameController.text.isEmpty ||
                                                  nameController.text == null ||
                                                  value!.isEmpty) {
                                                return "Please Enter Name Details";
                                              }
                                              return null;
                                            },
                                            enabled: true,
                                            textInputType: TextInputType.name,
                                            controller: nameController,
                                            hintText: "Name",
                                            hintStyle:
                                                CustomWidget(context: context)
                                                    .CustomSizedTextStyle(
                                                        12.0,
                                                        Theme.of(context)
                                                            .splashColor
                                                            .withOpacity(0.5),
                                                        FontWeight.w500,
                                                        'FontRegular'),
                                            textStyle:
                                                CustomWidget(context: context)
                                                    .CustomSizedTextStyle(
                                                        12.0,
                                                        Theme.of(context)
                                                            .splashColor,
                                                        FontWeight.w400,
                                                        'FontRegular'),
                                          ),
                                          const SizedBox(
                                            height: 20.0,
                                          ),
                                          TextFormFieldCustom(
                                            autovalidateMode: AutovalidateMode
                                                .onUserInteraction,
                                            onEditComplete: () {
                                              accTypeFocus.unfocus();
                                              FocusScope.of(context)
                                                  .requestFocus(
                                                      branchTypeFocus);
                                            },
                                            inputFormatters: [
                                              FilteringTextInputFormatter.allow(RegExp(r'[A-Za-z]')),
                                            ],
                                            radius: 5.0,
                                            error: "Enter Valid Account Number",
                                            textColor: CustomTheme.of(context)
                                                .splashColor,
                                            borderColor: CustomTheme.of(context)
                                                .splashColor
                                                .withOpacity(0.5),
                                            fillColor: CustomTheme.of(context)
                                                .backgroundColor
                                                .withOpacity(0.5),
                                            textInputAction:
                                                TextInputAction.next,
                                            focusNode: accTypeFocus,
                                            maxlines: 1,
                                            text: '',
                                            hintText: "Account Type",
                                            obscureText: false,
                                            suffix: Container(
                                              width: 0.0,
                                            ),
                                            textChanged: (value) {},
                                            onChanged: () {},
                                            validator: (value) {
                                              if (accType.text.isEmpty ||
                                                  accType.text == null ||
                                                  accType == "null" ||
                                                  value!.isEmpty) {
                                                return "Please enter Account Type";
                                              }
                                              return null;
                                            },
                                            enabled: true,
                                            textInputType: TextInputType.name,
                                            controller: accType,
                                            hintStyle:
                                                CustomWidget(context: context)
                                                    .CustomSizedTextStyle(
                                                        12.0,
                                                        Theme.of(context)
                                                            .splashColor
                                                            .withOpacity(0.5),
                                                        FontWeight.w500,
                                                        'FontRegular'),
                                            textStyle:
                                                CustomWidget(context: context)
                                                    .CustomSizedTextStyle(
                                                        12.0,
                                                        Theme.of(context)
                                                            .splashColor,
                                                        FontWeight.w400,
                                                        'FontRegular'),
                                          ),
                                          const SizedBox(
                                            height: 20.0,
                                          ),
                                          TextFormFieldCustom(
                                            autovalidateMode: AutovalidateMode
                                                .onUserInteraction,
                                            onEditComplete: () {
                                              branchTypeFocus.unfocus();
                                              FocusScope.of(context)
                                                  .requestFocus(accnumberFocus);
                                            },
                                            radius: 5.0,
                                            inputFormatters: [
                                              FilteringTextInputFormatter.allow(RegExp(r'[A-Za-z]')),
                                            ],
                                            error: "Enter Valid Branch Type",
                                            textColor: CustomTheme.of(context)
                                                .splashColor,
                                            borderColor: CustomTheme.of(context)
                                                .splashColor
                                                .withOpacity(0.5),
                                            fillColor: CustomTheme.of(context)
                                                .backgroundColor
                                                .withOpacity(0.5),
                                            textInputAction:
                                                TextInputAction.next,
                                            focusNode: branchTypeFocus,
                                            maxlines: 1,
                                            text: '',
                                            hintText: "Branch",
                                            obscureText: false,
                                            suffix: Container(
                                              width: 0.0,
                                            ),
                                            textChanged: (value) {},
                                            onChanged: () {},
                                            validator: (value) {
                                              if (branchType.text.isEmpty ||
                                                  branchType.text == null ||
                                                  branchType == "null" ||
                                                  value!.isEmpty) {
                                                return "Please enter Branch Type";
                                              }
                                              return null;
                                            },
                                            enabled: true,
                                            textInputType: TextInputType.name,
                                            controller: branchType,
                                            hintStyle:
                                                CustomWidget(context: context)
                                                    .CustomSizedTextStyle(
                                                        12.0,
                                                        Theme.of(context)
                                                            .splashColor
                                                            .withOpacity(0.5),
                                                        FontWeight.w500,
                                                        'FontRegular'),
                                            textStyle:
                                                CustomWidget(context: context)
                                                    .CustomSizedTextStyle(
                                                        12.0,
                                                        Theme.of(context)
                                                            .splashColor,
                                                        FontWeight.w400,
                                                        'FontRegular'),
                                          ),
                                          const SizedBox(
                                            height: 20.0,
                                          ),
                                          TextFormFieldCustom(
                                            autovalidateMode: AutovalidateMode
                                                .onUserInteraction,
                                            inputFormatters: [
                                              FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                                            ],
                                            onEditComplete: () {
                                              accnumberFocus.unfocus();
                                              FocusScope.of(context)
                                                  .requestFocus(ifscFocus);
                                            },
                                            radius: 5.0,
                                            error: "Enter Valid Account Number",
                                            textColor: CustomTheme.of(context)
                                                .splashColor,
                                            borderColor: CustomTheme.of(context)
                                                .splashColor
                                                .withOpacity(0.5),
                                            fillColor: CustomTheme.of(context)
                                                .backgroundColor
                                                .withOpacity(0.5),
                                            textInputAction:
                                                TextInputAction.next,
                                            focusNode: accnumberFocus,
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
                                              if (accnumber.text.isEmpty ||
                                                  accnumber.text == null ||
                                                  accnumber == "null" ||
                                                  value!.isEmpty) {
                                                return "Please enter Account Number";
                                              }
                                              return null;
                                            },
                                            enabled: true,
                                            textInputType: TextInputType.number,
                                            controller: accnumber,
                                            hintStyle:
                                                CustomWidget(context: context)
                                                    .CustomSizedTextStyle(
                                                        12.0,
                                                        Theme.of(context)
                                                            .splashColor
                                                            .withOpacity(0.5),
                                                        FontWeight.w500,
                                                        'FontRegular'),
                                            textStyle:
                                                CustomWidget(context: context)
                                                    .CustomSizedTextStyle(
                                                        12.0,
                                                        Theme.of(context)
                                                            .splashColor,
                                                        FontWeight.w400,
                                                        'FontRegular'),
                                          ),
                                          const SizedBox(
                                            height: 20.0,
                                          ),
                                          TextFormFieldCustom(
                                            autovalidateMode: AutovalidateMode
                                                .onUserInteraction,
                                            onEditComplete: () {
                                              ifscFocus.unfocus();
                                              FocusScope.of(context)
                                                  .requestFocus(bank_nameFocus);
                                            },
                                            inputFormatters: [
                                              FilteringTextInputFormatter.allow(RegExp(r'[A-Za-z0-9]')),
                                            ],
                                            radius: 5.0,
                                            error: "Enter Valid IFSC",
                                            textColor: CustomTheme.of(context)
                                                .splashColor,
                                            borderColor: CustomTheme.of(context)
                                                .splashColor
                                                .withOpacity(0.5),
                                            fillColor: CustomTheme.of(context)
                                                .backgroundColor
                                                .withOpacity(0.5),
                                            textInputAction:
                                                TextInputAction.next,
                                            focusNode: ifscFocus,
                                            maxlines: 1,
                                            text: '',
                                            hintText: "IFSC",
                                            obscureText: false,
                                            suffix: Container(
                                              width: 0.0,
                                            ),
                                            textChanged: (value) {},
                                            onChanged: () {},
                                            validator: (value) {
                                              if (ifsc.text.isEmpty ||
                                                  ifsc.text == null ||
                                                  ifsc == "null" ||
                                                  value!.isEmpty) {
                                                return "Please enter Ifsc Code";
                                              }
                                              return null;
                                            },
                                            enabled: true,
                                            textInputType: TextInputType.name,
                                            controller: ifsc,
                                            hintStyle:
                                                CustomWidget(context: context)
                                                    .CustomSizedTextStyle(
                                                        12.0,
                                                        Theme.of(context)
                                                            .splashColor
                                                            .withOpacity(0.5),
                                                        FontWeight.w500,
                                                        'FontRegular'),
                                            textStyle:
                                                CustomWidget(context: context)
                                                    .CustomSizedTextStyle(
                                                        12.0,
                                                        Theme.of(context)
                                                            .splashColor,
                                                        FontWeight.w400,
                                                        'FontRegular'),
                                          ),
                                          const SizedBox(
                                            height: 20.0,
                                          ),
                                          TextFormFieldCustom(
                                            autovalidateMode: AutovalidateMode
                                                .onUserInteraction,
                                            onEditComplete: () {
                                              bank_nameFocus.unfocus();
                                            },
                                            inputFormatters: [
                                              FilteringTextInputFormatter.allow(RegExp(r'[A-Za-z]')),
                                            ],
                                            radius: 5.0,
                                            error: "Enter Valid Bank Name",
                                            textColor: CustomTheme.of(context)
                                                .splashColor,
                                            borderColor: CustomTheme.of(context)
                                                .splashColor
                                                .withOpacity(0.5),
                                            fillColor: CustomTheme.of(context)
                                                .backgroundColor
                                                .withOpacity(0.5),
                                            textInputAction:
                                                TextInputAction.next,
                                            focusNode: bank_nameFocus,
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
                                              if (bank_name.text.isEmpty ||
                                                  bank_name.text == null ||
                                                  bank_name == "null" ||
                                                  value!.isEmpty) {
                                                return "Please enter Bank Name";
                                              }
                                              return null;
                                            },
                                            enabled: true,
                                            textInputType: TextInputType.name,
                                            controller: bank_name,
                                            hintStyle:
                                                CustomWidget(context: context)
                                                    .CustomSizedTextStyle(
                                                        12.0,
                                                        Theme.of(context)
                                                            .splashColor
                                                            .withOpacity(0.5),
                                                        FontWeight.w500,
                                                        'FontRegular'),
                                            textStyle:
                                                CustomWidget(context: context)
                                                    .CustomSizedTextStyle(
                                                        12.0,
                                                        Theme.of(context)
                                                            .splashColor,
                                                        FontWeight.w400,
                                                        'FontRegular'),
                                          ),
                                          const SizedBox(
                                            height: 20.0,
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "Tips:".toUpperCase(),
                                                style: CustomWidget(
                                                        context: context)
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
                                                "The added payment method will be shown to the buyer during the transaction to accept fiat transfers. Please ensure that the information is correct, real, and matches your KYC information on H2Crypto.",
                                                style: CustomWidget(
                                                        context: context)
                                                    .CustomSizedTextStyle(
                                                        12.0,
                                                        Theme.of(context)
                                                            .splashColor,
                                                        FontWeight.w500,
                                                        'FontRegular'),
                                                textAlign: TextAlign.start,
                                              ),
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 20.0,
                                          ),
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              InkWell(
                                                onTap: () {
                                                  Navigator.of(context)
                                                      .pop(true);
                                                  nameController.clear();
                                                  accnumber.clear();
                                                  accType.clear();
                                                  branchType.clear();
                                                  ifsc.clear();
                                                  bank_name.clear();
                                                },
                                                child: Container(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.4,
                                                    decoration: BoxDecoration(
                                                      color: CustomTheme.of(
                                                              context)
                                                          .highlightColor
                                                          .withOpacity(0.5),
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  5.0)),
                                                    ),
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 10.0,
                                                            bottom: 10.0),
                                                    child: Center(
                                                      child: Text(
                                                        "Cancel",
                                                        style: CustomWidget(
                                                                context:
                                                                    context)
                                                            .CustomTextStyle(
                                                                CustomTheme.of(
                                                                        context)
                                                                    .splashColor,
                                                                FontWeight.w500,
                                                                'FontRegular'),
                                                      ),
                                                    )),
                                              ),
                                              InkWell(
                                                onTap: () {
                                                  setState(() {
                                                    print("Test1" +
                                                        pay_method.toString());
                                                    if (pay_method == "bank" ||
                                                        pay_method == "imps") {
                                                      if (valformKey
                                                              .currentState!
                                                              .validate() ||
                                                          nameController.text.isNotEmpty &&
                                                              accnumber.text
                                                                  .isNotEmpty &&
                                                              accType.text
                                                                  .isNotEmpty &&
                                                              branchType.text
                                                                  .isNotEmpty &&
                                                              ifsc.text
                                                                  .isNotEmpty &&
                                                              bank_name.text
                                                                  .isNotEmpty) {
                                                        if (update) {
                                                          doUpdateDetails(upiId,
                                                              paymentName);
                                                        } else {
                                                          addPaymentDetails();
                                                        }
                                                        Navigator.of(context)
                                                            .pop(true);
                                                      } else {}
                                                    } else if (valformKey
                                                            .currentState ==
                                                        " ") {
                                                      CustomWidget(
                                                              context: context)
                                                          .custombar(
                                                              "Payment Method",
                                                              "Bank Details",
                                                              false);
                                                      Navigator.of(context)
                                                          .pop(true);
                                                    } else if (nameController
                                                                .text.length ==
                                                            "" ||
                                                        accnumber.text.length ==
                                                            "" ||
                                                        accType.text.length ==
                                                            "" ||
                                                        branchType.text.length ==
                                                            "" ||
                                                        ifsc.text.length ==
                                                            "" ||
                                                        bank_name.text.length ==
                                                            "") {
                                                      CustomWidget(
                                                              context: context)
                                                          .custombar(
                                                              "Payment Method",
                                                              "Bank Details",
                                                              false);
                                                    } else {
                                                      Navigator.of(context)
                                                          .pop(true);
                                                      CustomWidget(
                                                              context: context)
                                                          .custombar(
                                                              "Payment Method",
                                                              "Bank Details",
                                                              false);
                                                    }

                                                    // if(bankType== "bank"){
                                                    //  ;
                                                    // }else{
                                                    //   Navigator.of(context).pop(true);
                                                    // }
                                                  });
                                                },
                                                child: Container(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.4,
                                                    decoration: BoxDecoration(
                                                      color: CustomTheme.of(
                                                              context)
                                                          .selectedRowColor,
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  5.0)),
                                                    ),
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 10.0,
                                                            bottom: 10.0),
                                                    child: Center(
                                                      child: Text(
                                                        "Submit",
                                                        style: CustomWidget(
                                                                context:
                                                                    context)
                                                            .CustomTextStyle(
                                                                CustomTheme.of(
                                                                        context)
                                                                    .splashColor,
                                                                FontWeight.w500,
                                                                'FontRegular'),
                                                      ),
                                                    )),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 15.0,
                                          ),
                                        ],
                                      )),
                                ),
                              ],
                            ),
                          )),
                    )
                  : SingleChildScrollView(
                      child: Container(
                        height: MediaQuery.of(context).size.height * 0.4,
                        width: MediaQuery.of(context).size.width,
                        color: Theme.of(context).primaryColor,
                        child: loading
                            ? CustomWidget(context: context).loadingIndicator(
                                CustomTheme.of(context).splashColor,
                              )
                            : Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  SizedBox(
                                    height: 20.0,
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                        left: 15.0, right: 15.0, top: 10.0),
                                    child: Form(
                                      key: valformKeys,
                                      child: Column(
                                        children: [
                                          TextFormFieldCustom(
                                            autovalidateMode: AutovalidateMode
                                                .onUserInteraction,
                                            onEditComplete: () {
                                              upiFocus.unfocus();
                                            },
                                            radius: 5.0,
                                            error: "Enter Valid UPI Id",
                                            inputFormatters: [
                                              FilteringTextInputFormatter.allow(RegExp(r'[A-Za-z0-9@]')),
                                            ],
                                            textColor: CustomTheme.of(context)
                                                .splashColor,
                                            borderColor: CustomTheme.of(context)
                                                .splashColor
                                                .withOpacity(0.5),
                                            fillColor: CustomTheme.of(context)
                                                .backgroundColor
                                                .withOpacity(0.5),
                                            textInputAction:
                                                TextInputAction.next,
                                            focusNode: upiFocus,
                                            maxlines: 1,
                                            text: '',
                                            hintText: "UPI ID",
                                            obscureText: false,
                                            suffix: Container(
                                              width: 0.0,
                                            ),
                                            textChanged: (value) {},
                                            onChanged: () {},
                                            validator: (value) {
                                              if (value!.isEmpty) {
                                                return "Please enter UPI Number";
                                              }
                                              return null;
                                            },
                                            enabled: true,
                                            textInputType: TextInputType.name,
                                            controller: upidetails,
                                            hintStyle:
                                                CustomWidget(context: context)
                                                    .CustomSizedTextStyle(
                                                        12.0,
                                                        Theme.of(context)
                                                            .splashColor
                                                            .withOpacity(0.5),
                                                        FontWeight.w500,
                                                        'FontRegular'),
                                            textStyle:
                                                CustomWidget(context: context)
                                                    .CustomSizedTextStyle(
                                                        12.0,
                                                        Theme.of(context)
                                                            .splashColor,
                                                        FontWeight.w400,
                                                        'FontRegular'),
                                          ),
                                          const SizedBox(
                                            height: 20.0,
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "Tips:".toUpperCase(),
                                                style: CustomWidget(
                                                        context: context)
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
                                                "The added payment method will be shown to the buyer during the transaction to accept fiat transfers. Please ensure that the information is correct, real, and matches your KYC information on H2Crypto.",
                                                style: CustomWidget(
                                                        context: context)
                                                    .CustomSizedTextStyle(
                                                        12.0,
                                                        Theme.of(context)
                                                            .splashColor,
                                                        FontWeight.w500,
                                                        'FontRegular'),
                                                textAlign: TextAlign.start,
                                              ),
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 50.0,
                                          ),
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: [
                                              InkWell(
                                                onTap: () {
                                                  Navigator.of(context)
                                                      .pop(true);
                                                  upidetails.clear();
                                                },
                                                child: Container(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.4,
                                                    decoration: BoxDecoration(
                                                      color: CustomTheme.of(
                                                              context)
                                                          .highlightColor
                                                          .withOpacity(0.5),
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  5.0)),
                                                    ),
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 10.0,
                                                            bottom: 10.0),
                                                    child: Center(
                                                      child: Text(
                                                        "Cancel",
                                                        style: CustomWidget(
                                                                context:
                                                                    context)
                                                            .CustomTextStyle(
                                                                CustomTheme.of(
                                                                        context)
                                                                    .splashColor,
                                                                FontWeight.w500,
                                                                'FontRegular'),
                                                      ),
                                                    )),
                                              ),
                                              InkWell(
                                                onTap: () {
                                                  setState(() {
                                                    if (pay_method == "upi" ||
                                                        pay_method == "paytm") {
                                                      if (valformKeys
                                                              .currentState!
                                                              .validate() ||
                                                          upidetails.text
                                                                  .isNotEmpty &&
                                                              upidetails.text
                                                                      .length >
                                                                  4) {
                                                        if (update) {
                                                          doUpdateDetails(
                                                              upidetails.text,
                                                              paymentName);
                                                        } else {
                                                          addPaymentDetails();
                                                        }
                                                        Navigator.of(context)
                                                            .pop(true);
                                                      } else if (valformKeys
                                                              .currentState ==
                                                          " ") {
                                                        CustomWidget(
                                                                context:
                                                                    context)
                                                            .custombar(
                                                                "Payment Method",
                                                                "UPI Details",
                                                                false);
                                                        // Navigator.of(context)
                                                        //     .pop(true);
                                                      }
                                                    } else {
                                                      // Navigator.of(context)
                                                      //     .pop(true);
                                                      CustomWidget(
                                                              context: context)
                                                          .custombar(
                                                              "Payment Method",
                                                              "Enter UPI Details",
                                                              false);
                                                    }

                                                    // if(upidetails.text.isEmpty || upidetails == "null" || upidetails == null){
                                                    //   CustomWidget(context: context)
                                                    //       .custombar("Payment Method", "Please Enter UPI Details", false);
                                                    // }
                                                    // else if(upidetails.text.isEmpty == "" || upidetails.text.length == "" || upidetails.text.length == "null" || upidetails.text.length == null){
                                                    // Navigator.of(context)
                                                    //     .pop(true);
                                                    // CustomWidget(context: context)
                                                    //     .custombar("Payment Method", "Enter UPI Details", false);
                                                    // }
                                                    // else {
                                                    //   addPaymentDetails();
                                                    // }
                                                  });
                                                },
                                                child: Container(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.4,
                                                    decoration: BoxDecoration(
                                                      color: CustomTheme.of(
                                                              context)
                                                          .selectedRowColor,
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  5.0)),
                                                    ),
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 10.0,
                                                            bottom: 10.0),
                                                    child: Center(
                                                      child: Text(
                                                        "Submit",
                                                        style: CustomWidget(
                                                                context:
                                                                    context)
                                                            .CustomTextStyle(
                                                                CustomTheme.of(
                                                                        context)
                                                                    .splashColor,
                                                                FontWeight.w500,
                                                                'FontRegular'),
                                                      ),
                                                    )),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                      ),
                    ),
            );
          });
        });
  }

  showSuccesssAlertDialog(String title, String message, String paymentType) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0)), //this right here
            child: Container(
              decoration: new BoxDecoration(
                  color: CustomTheme.of(context).splashColor,
                  borderRadius: BorderRadius.circular(5.0)),
              height: MediaQuery.of(context).size.height * 0.24,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      title.toUpperCase(),
                      style: CustomWidget(context: context)
                          .CustomSizedTextStyle(
                              16.0,
                              Theme.of(context).buttonColor,
                              FontWeight.bold,
                              'FontRegular'),
                    ),
                    Container(
                        margin: EdgeInsets.only(top: 7.0, bottom: 10.0),
                        height: 2.0,
                        color: CustomTheme.of(context).buttonColor),
                    Text(
                      message,
                      style: CustomWidget(context: context)
                          .CustomSizedTextStyle(
                              16.0,
                              Theme.of(context).buttonColor,
                              FontWeight.w500,
                              'FontRegular'),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Row(
                      children: [
                        SizedBox(
                          child: InkWell(
                            child: Container(
                              width: 100,
                              height: 40,
                              margin: const EdgeInsets.fromLTRB(
                                  10.0, 10.0, 10.0, 0.0),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                    colors: [
                                      CustomTheme.of(context).buttonColor,
                                      CustomTheme.of(context).buttonColor
                                    ],
                                    begin: Alignment.topRight,
                                    end: Alignment.bottomLeft,
                                    stops: [0.0, 1.0],
                                    tileMode: TileMode.clamp),
                                borderRadius: BorderRadius.circular(25),
                              ),
                              child: Align(
                                alignment: Alignment.center,
                                child: Text(
                                  "ok".toUpperCase(),
                                  style: CustomWidget(context: context)
                                      .CustomSizedTextStyle(
                                          15.0,
                                          Theme.of(context).splashColor,
                                          FontWeight.w500,
                                          'FontRegular'),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                            onTap: () {
                              setState(() {
                                doDeleteDetails(paymentType);
                              });
                              Navigator.of(context).pop(true);
                            },
                          ),
                        ),
                        SizedBox(
                          child: InkWell(
                            child: Container(
                              width: 100,
                              height: 40,
                              margin: const EdgeInsets.fromLTRB(
                                  10.0, 10.0, 10.0, 0.0),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                    colors: [
                                      CustomTheme.of(context).buttonColor,
                                      CustomTheme.of(context).buttonColor,
                                    ],
                                    begin: Alignment.topRight,
                                    end: Alignment.bottomLeft,
                                    stops: [0.0, 1.0],
                                    tileMode: TileMode.clamp),
                                borderRadius: BorderRadius.circular(25),
                              ),
                              child: Align(
                                alignment: Alignment.center,
                                child: Text(
                                  "Cancel".toUpperCase(),
                                  style: CustomWidget(context: context)
                                      .CustomSizedTextStyle(
                                          15.0,
                                          Theme.of(context).splashColor,
                                          FontWeight.w500,
                                          'FontRegular'),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                            onTap: () {
                              Navigator.of(context).pop(true);
                            },
                          ),
                        )
                      ],
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                    )
                  ],
                ),
              ),
            ),
          );
        });
    // show the dialog
  }

  getUserId() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    userId = preferences.getString("exp").toString();
    setState(() {
      loading = true;
    });
    getPaymentDetails();
  }

  getPaymentDetails() {
    print("Mano");
    apiUtils
        .getpay_details(userId, "true")
        .then((GetPaymentDetailsModel loginData) {
      print(loginData.statusCode.toString());
      if (loginData.statusCode.toString() == "200") {
        setState(() {
          loading = false;

          allPaymentDetails = [];
          allPaymentDetails.clear();
          allPaymentDetails = loginData.data!.pay!;
        });
      } else {
        setState(() {
          allPaymentDetails = [];
          allPaymentDetails.clear();
          loading = false;
          // CustomWidget(context: context)
          //     .custombar("Payment Method", loginData.message.toString(), false);
        });
      }
    }).catchError((Object error) {
      print(error.toString());
      setState(() {
        loading = false;
      });
    });
  }

  doUpdateDetails(String upi_id, String paymentName) {
    apiUtils
        .editPaymentDetails(
            nameController.text.toString(),
            accType.text.toString(),
            accnumber.text.toString(),
            ifsc.text.toString(),
            bank_name.text.toString(),
            branchType.text.toString(),
            upi_id,
            paymentName)
        .then((LoanModel loginData) {
      if (loginData.statusCode.toString() == "200") {
        setState(() {
          loading = false;
          CustomWidget(context: context)
              .custombar("Payment Method", loginData.message.toString(), true);
          getPaymentDetails();
        });
      } else {
        setState(() {
          loading = false;
          // CustomWidget(context: context)
          //     .custombar("Payment Method", loginData.message.toString(), false);
        });
      }
    }).catchError((Object error) {
      print(error.toString());
      setState(() {
        loading = false;
      });
    });
  }

  doDeleteDetails(String paymentName) {
    apiUtils.deletePaymentDetails(paymentName).then((LoanModel loginData) {
      if (loginData.statusCode.toString() == "200") {
        setState(() {
          loading = false;
          CustomWidget(context: context)
              .custombar("Payment Method", loginData.message.toString(), true);
          loading = true;
          getPaymentDetails();
        });
      } else {
        setState(() {
          loading = false;
          // CustomWidget(context: context)
          //     .custombar("Payment Method", loginData.message.toString(), false);
        });
      }
    }).catchError((Object error) {
      print(error.toString());
      setState(() {
        loading = false;
      });
    });
  }

  addPaymentDetails() {
    apiUtils
        .addpay_details(
            nameController.text.toString(),
            upidetails.text.toString(),
            accType.text.toString(),
            accnumber.text.toString(),
            ifsc.text.toString(),
            bank_name.text.toString(),
            branchType.text.toString(),
            pay_method.toString(),
            userId)
        .then((CommonModel loginData) {
      if (loginData.status.toString() == "200") {
        setState(() {
          // selectPaymentDetails = loginData.data!.pay!;
        });
        loading = false;
        CustomWidget(context: context)
            .custombar("Payment Method", loginData.message.toString(), true);
        getPaymentDetails();
      } else {
        setState(() {
          loading = false;
          CustomWidget(context: context)
              .custombar("Payment Method", loginData.message.toString(), false);
        });
      }
    }).catchError((Object error) {
      print("text");
      print(error.toString());
      setState(() {
        loading = false;
      });
    });
  }
}
