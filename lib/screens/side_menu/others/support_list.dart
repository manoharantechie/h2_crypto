import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:h2_crypto/common/colors.dart';
import 'package:h2_crypto/common/custom_button.dart';
import 'package:h2_crypto/common/custom_widget.dart';
import 'package:h2_crypto/common/localization/localizations.dart';
import 'package:h2_crypto/common/textformfield_custom.dart';
import 'package:h2_crypto/common/theme/custom_theme.dart';
import 'package:h2_crypto/data/api_utils.dart';
import 'package:h2_crypto/data/crypt_model/common_model.dart';
import 'package:h2_crypto/data/crypt_model/support_ticket_model.dart';
import 'package:h2_crypto/screens/side_menu/others/chat_screen.dart';
import 'package:intl/intl.dart';
import 'package:moment_dart/moment_dart.dart';

class SupportTicketList extends StatefulWidget {
  const SupportTicketList({Key? key}) : super(key: key);

  @override
  State<SupportTicketList> createState() => _SupportTicketListState();
}

class _SupportTicketListState extends State<SupportTicketList> {
  APIUtils apiUtils = APIUtils();
  ScrollController controller = ScrollController();
  bool loading = false;
  List<SupportTicketListResult> ticketList = [];
  final _formKey = GlobalKey<FormState>();
  FocusNode subjectFocus = FocusNode();
  FocusNode messageFocus = FocusNode();
  TextEditingController subjectController = TextEditingController();
  TextEditingController messageController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loading = true;
    getTicketList();
  }

  @override
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
                height: 10.0,
                width: 10.0,
                color: CustomTheme.of(context).splashColor,
                allowDrawingOutsideViewBox: true,
              ),
            )),
        centerTitle: true,
        title: Text(
          "Support",
          style: TextStyle(
            fontFamily: 'FontSpecial',
            color: CustomTheme.of(context).splashColor,
            fontWeight: FontWeight.w700,
            fontSize: 18.0,
          ),
        ),
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
              Theme.of(context).dialogBackgroundColor,
            ])),
        child: Stack(
          children: [
            supportListUI(),
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

  Widget supportListUI() {
    return Container(
      child: Stack(
        children: [
          Container(
            margin: EdgeInsets.only(left: 10.0, right: 10.0),
            height: 35.0,
            padding: const EdgeInsets.only(
                left: 10.0, right: 10.0, top: 0.0, bottom: 0.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5.0),
              color: Colors.transparent,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "TicketList".toUpperCase(),
                  style: CustomWidget(context: context).CustomSizedTextStyle(
                      14.0,
                      Theme.of(context).splashColor,
                      FontWeight.w500,
                      'FontRegular'),
                ),
                InkWell(
                  onTap: () {
                    createTicket();
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        color: CustomTheme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(5.0)),
                    padding: EdgeInsets.all(5.0),
                    child: Icon(
                      Icons.add,
                      size: 20.0,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height,
            margin: EdgeInsets.only(top: 50.0),
            child: ticketList.length > 0
                ? Container(
                    height: MediaQuery.of(context).size.height,
                    padding: EdgeInsets.only(bottom: 10.0),
                    child: ListView.builder(
                        itemCount: ticketList.length,
                        shrinkWrap: true,
                        controller: controller,
                        itemBuilder: (BuildContext context, int index) {
                          return Column(
                            children: [
                              InkWell(
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => ChatScreen(
                                            ticket_id: ticketList[index]
                                                .ticketId
                                                .toString(),
                                          )));
                                },
                                child: Container(
                                  margin: EdgeInsets.only(
                                      left: 10.0, right: 10.0, top: 5.0),
                                  width: MediaQuery.of(context).size.width,
                                  decoration: BoxDecoration(
                                      color: CustomTheme.of(context).cardColor,
                                      borderRadius: BorderRadius.circular(5.0)),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(
                                        height: 10.0,
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(
                                            left: 10.0, right: 10.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "Ticket Id",
                                                  style: CustomWidget(
                                                          context: context)
                                                      .CustomTextStyle(
                                                          Theme.of(context)
                                                              .splashColor
                                                              .withOpacity(0.6),
                                                          FontWeight.w500,
                                                          'FontRegular'),
                                                ),
                                                SizedBox(
                                                  height: 5.0,
                                                ),
                                                Text(
                                                  ticketList[index]
                                                      .ticketId
                                                      .toString(),
                                                  style: CustomWidget(
                                                          context: context)
                                                      .CustomTextStyle(
                                                          Theme.of(context)
                                                              .splashColor,
                                                          FontWeight.w500,
                                                          'FontRegular'),
                                                ),
                                                SizedBox(
                                                  height: 5.0,
                                                ),
                                                Text(
                                                  "Title",
                                                  style: CustomWidget(
                                                          context: context)
                                                      .CustomTextStyle(
                                                          Theme.of(context)
                                                              .splashColor
                                                              .withOpacity(0.6),
                                                          FontWeight.w500,
                                                          'FontRegular'),
                                                ),
                                                SizedBox(
                                                  height: 5.0,
                                                ),
                                                Text(
                                                  ticketList[index]
                                                      .subject
                                                      .toString(),
                                                  style: CustomWidget(
                                                          context: context)
                                                      .CustomTextStyle(
                                                          Theme.of(context)
                                                              .splashColor,
                                                          FontWeight.w500,
                                                          'FontRegular'),
                                                ),
                                              ],
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                            ),
                                            Column(
                                              children: [
                                                Text(
                                                  DateFormat("MMM d,yyyy")
                                                      .format(ticketList[index]
                                                          .createdAt!)
                                                      .toString(),
                                                  style: CustomWidget(
                                                          context: context)
                                                      .CustomTextStyle(
                                                          Theme.of(context)
                                                              .splashColor,
                                                          FontWeight.w500,
                                                          'FontRegular'),
                                                ),
                                              ],
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 5.0,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          );
                        }),
                  )
                : Container(
                    height: MediaQuery.of(context).size.height * 0.3,
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
          )
        ],
      ),
    );
  }

  createTicket() {
    showModalBottomSheet(
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        isDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter ssetState) {
            return Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30.0),
                      topRight: Radius.circular(30.0)),
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
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 15.0,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(),
                            Text(
                              "Create Ticket",
                              style: TextStyle(
                                  fontSize: 18.0,
                                  color: Theme.of(context)
                                      .splashColor
                                      .withOpacity(0.6),
                                  fontWeight: FontWeight.w700,
                                  fontFamily: 'FontRegular'),
                              textAlign: TextAlign.center,
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.pop(context);
                                subjectController.clear();
                                messageController.clear();
                              },
                              child: Container(
                                margin: EdgeInsets.only(right: 15.0),
                                decoration: BoxDecoration(
                                  color: CustomTheme.of(context).shadowColor,
                                  shape: BoxShape.circle,
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Icon(Icons.close,
                                      color:
                                          CustomTheme.of(context).splashColor,
                                      size: 15.0),
                                ),
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 15.0,
                        ),
                        Text(
                          "Title",
                          style: CustomWidget(context: context).CustomTextStyle(
                              Theme.of(context).splashColor.withOpacity(0.6),
                              FontWeight.w500,
                              'FontRegular'),
                        ),
                        SizedBox(
                          height: 5.0,
                        ),
                        TextFormFieldCustom(
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          obscureText: false,
                          textInputAction: TextInputAction.next,
                          hintStyle: CustomWidget(context: context)
                              .CustomTextStyle(
                                  Theme.of(context)
                                      .splashColor
                                      .withOpacity(0.5),
                                  FontWeight.w300,
                                  'FontRegular'),
                          // inputFormatters: [
                          //   FilteringTextInputFormatter.allow(RegExp(r'[A-Za-z@#0-9!_.$]')),
                          // ],
                          textStyle: CustomWidget(context: context)
                              .CustomTextStyle(
                                  CustomTheme.of(context).splashColor,
                                  FontWeight.w400,
                                  'FontRegular'),
                          radius: 5.0,
                          focusNode: subjectFocus,
                          controller: subjectController,
                          enabled: true,
                          textColor: CustomTheme.of(context).splashColor,
                          borderColor: CustomTheme.of(context)
                              .splashColor
                              .withOpacity(0.5),
                          fillColor: CustomTheme.of(context)
                              .backgroundColor
                              .withOpacity(0.5),
                          onChanged: () {},
                          hintText:
                              AppLocalizations.instance.text("loc_subject"),
                          textChanged: (value) {},
                          suffix: Container(width: 0.0),
                          validator: (value) {
                            if (value!.trim().isEmpty) {
                              return "Please enter the subject";
                            }
                            return null;
                          },
                          maxlines: 1,
                          error: "Enter the Subject",
                          text: "",
                          onEditComplete: () {
                            subjectFocus.unfocus();
                            FocusScope.of(context).requestFocus(messageFocus);
                          },
                          textInputType: TextInputType.text,
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Text(
                          "Message",
                          style: CustomWidget(context: context).CustomTextStyle(
                              Theme.of(context).splashColor.withOpacity(0.6),
                              FontWeight.w500,
                              'FontRegular'),
                        ),
                        SizedBox(
                          height: 5.0,
                        ),
                        TextFormField(
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          textInputAction: TextInputAction.done,
                          decoration: InputDecoration(
                            hintStyle: CustomWidget(context: context)
                                .CustomTextStyle(
                                    Theme.of(context)
                                        .splashColor
                                        .withOpacity(0.5),
                                    FontWeight.w300,
                                    'FontRegular'),
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5.0)),
                              borderSide: BorderSide(
                                  color: CustomTheme.of(context)
                                      .splashColor
                                      .withOpacity(0.5),
                                  width: 1.0),
                            ),
                            disabledBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5.0)),
                              borderSide: BorderSide(
                                  color: CustomTheme.of(context)
                                      .splashColor
                                      .withOpacity(0.5),
                                  width: 1.0),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5.0)),
                              borderSide: BorderSide(
                                  color: CustomTheme.of(context)
                                      .splashColor
                                      .withOpacity(0.5),
                                  width: 1.0),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5.0)),
                              borderSide: BorderSide(
                                  color: CustomTheme.of(context)
                                      .splashColor
                                      .withOpacity(0.5),
                                  width: 1.0),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5.0)),
                              borderSide:
                                  BorderSide(color: Colors.red, width: 1.0),
                            ),
                            fillColor: CustomTheme.of(context)
                                .backgroundColor
                                .withOpacity(0.5),
                            hintText:
                                AppLocalizations.instance.text("loc_message"),
                            counterText: "",
                          ),
                          style: CustomWidget(context: context).CustomTextStyle(
                              Theme.of(context).splashColor,
                              FontWeight.w400,
                              'FontRegular'),
                          focusNode: messageFocus,
                          controller: messageController,
                          enabled: true,
                          validator: (value) {
                            if (value!.trim().isEmpty) {
                              return "Please enter the message";
                            }
                            return null;
                          },
                          maxLength: 350,
                          maxLines: 4,
                          onEditingComplete: () {
                            messageFocus.unfocus();
                          },
                          keyboardType: TextInputType.text,
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        ButtonCustom(
                            text: AppLocalizations.instance.text("loc_submit"),
                            iconEnable: false,
                            radius: 5.0,
                            icon: "",
                            textStyle: CustomWidget(context: context)
                                .CustomSizedTextStyle(
                                    18.0,
                                    Theme.of(context).splashColor,
                                    FontWeight.w500,
                                    'FontRegular'),
                            iconColor: AppColors.borderColor,
                            shadowColor: CustomTheme.of(context).shadowColor,
                            splashColor: CustomTheme.of(context).shadowColor,
                            onPressed: () {
                              setState(() {
                                FocusScope.of(context).unfocus();
                                if (_formKey.currentState!.validate()) {
                                  Navigator.pop(context);
                                  createNewTicket(
                                      subjectController.text.toString(),
                                      messageController.text.toString());
                                }
                              });
                            },
                            paddng: 1.0),
                        const SizedBox(
                          height: 20.0,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          });
        });
  }

  getTicketList() {
    apiUtils.fetchSupportTicketList().then((SupportTicketListData loginData) {
      if (loginData.sucess!) {
        setState(() {
          loading = false;
          ticketList = loginData.result!;
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

  createNewTicket(
    String subject,
    String message,
  ) {
    apiUtils.doCreateTicket(subject, message).then((CommonModel loginData) {
      if (loginData.status!) {
        setState(() {
          subjectController.clear();
          messageController.clear();
          ticketList == [];
          loading = true;
          getTicketList();
          CustomWidget(context: context)
              .custombar("H2Crypto", loginData.message.toString(), true);
        });
      } else {
        setState(() {
          loading = false;
          CustomWidget(context: context)
              .custombar("H2Crypto", loginData.message.toString(), false);
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
