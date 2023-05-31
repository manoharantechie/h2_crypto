import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:h2_crypto/common/custom_widget.dart';
import 'package:h2_crypto/common/theme/custom_theme.dart';
import 'package:h2_crypto/data/api_utils.dart';
import 'package:h2_crypto/data/crypt_model/common_model.dart';
import 'package:h2_crypto/data/crypt_model/message_data.dart';
import 'package:intl/intl.dart';
import 'package:moment_dart/moment_dart.dart';
import 'package:timeago/timeago.dart' as timeago;

class ChatScreen extends StatefulWidget {
  final String ticket_id;

  const ChatScreen({Key? key, required this.ticket_id}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  APIUtils apiUtils = APIUtils();
  ScrollController controller = ScrollController();
  bool loading = false;
  List<MessageResult> chatList = [];
  TextEditingController messageController = TextEditingController();
  String username = "";
  String userImage = "";
  String adminImage = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loading = true;
    getMessageList(widget.ticket_id.toString());
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
          "Chat",
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
            chatListUi(),
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

  String convertToAgo(DateTime input) {
    Duration diff = DateTime.now().difference(input);
    print("Diff" + diff.toString());
    if (diff.inMonths >= 1) {
      return '${diff.inMonths} months ago';
    } else if (diff.inWeeks >= 1) {
      return '${diff.inWeeks} weeks ago';
    } else if (diff.inDays >= 1) {
      return '${diff.inDays} days ago';
    } else if (diff.inHours >= 1) {
      return '${diff.inHours} hours ago';
    } else if (diff.inMinutes >= 1) {
      return '${diff.inMinutes} minutes ago';
    } else if (diff.inSeconds >= 1) {
      return '${diff.inSeconds} seconds ago';
    } else {
      return 'just now';
    }
  }

  Widget chatListUi() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      color: CustomTheme.of(context).primaryColor,
      child: Stack(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(bottom: 50.0),
            child: ListView.builder(
              reverse: false,
              shrinkWrap: true,
              itemCount: chatList.length,
              itemBuilder: (BuildContext context, int index) {
                String adminMessage = "";
                String userMessage = "";
                bool isUserMessage = false;
                bool isAdminMessage = false;
                adminMessage = "";
                String dates = "";
                String image = "";

                userMessage = "";

                if (chatList[index].reply.toString() != "null") {
                  adminMessage = chatList[index].reply.toString();
                  var ddd = chatList[index].createdAt!;

                  String time =
                  DateTime.parse(ddd).millisecondsSinceEpoch.toString();

                  var dt = DateTime.fromMillisecondsSinceEpoch(int.parse(time));

                  var dfinals = dt.toUtc().toString();
                  final DateTime timead = DateTime.parse(dfinals);

                  dates = timeago.format(timead);
                  isAdminMessage = true;
                } else {
                  userMessage = chatList[index].message.toString();
                  isUserMessage = true;

                  var ddd = chatList[index].createdAt!;

                  String time =
                      DateTime.parse(ddd).millisecondsSinceEpoch.toString();

                  var dt = DateTime.fromMillisecondsSinceEpoch(int.parse(time));

                  var dfinals = dt.toUtc().toString();
                  final DateTime timead = DateTime.parse(dfinals);
                  dates = timeago.format(timead);
                }

                return Padding(
                  padding:
                      const EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0),
                  child: SizedBox(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        isAdminMessage
                            ? Container(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        SvgPicture.asset(
                                          'assets/others/menu.svg',
                                          height: 22.0,
                                        )
                                      ],
                                    ),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            constraints: BoxConstraints(
                                                maxWidth: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    .6),
                                            decoration: BoxDecoration(
                                              color: CustomTheme.of(context)
                                                  .highlightColor,
                                              borderRadius:
                                                  BorderRadius.circular(25.0),
                                            ),
                                            margin: const EdgeInsets.only(
                                                left: 5.0),
                                            padding: const EdgeInsets.only(
                                                left: 10.0,
                                                top: 8.0,
                                                right: 10.0,
                                                bottom: 8.0),
                                            child: Text(
                                              adminMessage,
                                              style: CustomWidget(
                                                      context: context)
                                                  .CustomSizedTextStyle(
                                                      16.0,
                                                      CustomTheme.of(context)
                                                          .splashColor,
                                                      FontWeight.w400,
                                                      'FontRegular'),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 5.0,
                                          ),
                                          Text(
                                            dates,
                                            style:
                                                CustomWidget(context: context)
                                                    .CustomSizedTextStyle(
                                                        14.0,
                                                        CustomTheme.of(context)
                                                            .splashColor,
                                                        FontWeight.w400,
                                                        'FontRegular'),
                                            textAlign: TextAlign.start,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : isUserMessage
                                ? Container(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Expanded(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: [
                                              Container(
                                                constraints: BoxConstraints(
                                                    maxWidth:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            .6),
                                                decoration: BoxDecoration(
                                                    color:
                                                        CustomTheme.of(context)
                                                            .shadowColor,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            25.0)),
                                                margin: const EdgeInsets.only(
                                                    right: 5.0),
                                                padding: const EdgeInsets.only(
                                                    left: 10.0,
                                                    right: 10.0,
                                                    top: 8.0,
                                                    bottom: 8.0),
                                                child: Text(
                                                  userMessage,
                                                  style: CustomWidget(
                                                          context: context)
                                                      .CustomSizedTextStyle(
                                                          16.0,
                                                          CustomTheme.of(
                                                                  context)
                                                              .splashColor,
                                                          FontWeight.w400,
                                                          'FontRegular'),
                                                  textAlign: TextAlign.start,
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 5.0, right: 5.0),
                                                child: Text(
                                                  dates,
                                                  style: CustomWidget(
                                                          context: context)
                                                      .CustomSizedTextStyle(
                                                          12.0,
                                                          CustomTheme.of(
                                                                  context)
                                                              .splashColor
                                                              .withOpacity(0.5),
                                                          FontWeight.w400,
                                                          'FontRegular'),
                                                  textAlign: TextAlign.start,
                                                ),
                                              ),
                                              // image == ""
                                              //     ? Container()
                                              //     : Container(
                                              //         height: 100,
                                              //         width: 100,
                                              //         decoration: BoxDecoration(
                                              //             borderRadius:
                                              //                 BorderRadius
                                              //                     .circular(
                                              //                         5.0)),
                                              //         child: Image.network(
                                              //           image,
                                              //           fit: BoxFit.contain,
                                              //         ),
                                              //       )
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(top: 5.0),
                                          child: SvgPicture.asset(
                                            'assets/others/menu.svg',
                                            height: 22.0,
                                          ),
                                        )
                                      ],
                                    ),
                                  )
                                : const SizedBox(
                                    height: 30.0,
                                  ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 0.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[

                Container(
                  color: CustomTheme.of(context).primaryColor,
                  child: Container(
                    margin: const EdgeInsets.only(
                        left: 10.0, right: 10.0, bottom: 10.0, top: 10.0),
                    decoration: BoxDecoration(
                        border: Border.all(
                            color: CustomTheme.of(context)
                                .splashColor
                                .withOpacity(0.2)),
                        borderRadius: BorderRadius.circular(30.0)),
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                      children: <Widget>[
                        Flexible(
                            flex: 2,
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(right: 5.0, left: 10.0),
                              child: TextFormField(
                                textAlign: TextAlign.left,
                                controller: messageController,
                                style: CustomWidget(context: context)
                                    .CustomSizedTextStyle(
                                        16.0,
                                        CustomTheme.of(context).splashColor,
                                        FontWeight.w400,
                                        'FontRegular'),
                                decoration: InputDecoration(
                                  contentPadding:
                                      const EdgeInsets.symmetric(vertical: 0.0),
                                  border: InputBorder.none,
                                  hintText: 'Type a message here',
                                  hintStyle: CustomWidget(context: context)
                                      .CustomSizedTextStyle(
                                          14.0,
                                          Theme.of(context)
                                              .splashColor
                                              .withOpacity(0.5),
                                          FontWeight.w400,
                                          'FontRegular'),
                                ),
                              ),
                            )),
                        Padding(
                            padding:
                            const EdgeInsets.only(left: 10.0, bottom: 0.0),
                            child: InkWell(
                              onTap: () {
                                setState(() {
                                  if (messageController.text.isNotEmpty) {
                                    loading = true;
                                    sendNewMessage();
                                  }
                                });
                              },
                              child: Container(
                                margin: EdgeInsets.only(
                                  left: 15.0,
                                ),
                                width: 45.0,
                                height: 45.0,
                                decoration: BoxDecoration(
                                    color: CustomTheme.of(context).shadowColor,
                                    borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(30.0),
                                        bottomRight: Radius.circular(30.0))),
                                child: Center(
                                  child: Icon(
                                    Icons.send,
                                    color: CustomTheme.of(context).splashColor,
                                  ),
                                ),
                              ),
                            ))
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  getMessageList(String ticket_id) {
    apiUtils.fetchMessageList(ticket_id).then((GetMessageData loginData) {
      if (loginData.success!) {
        setState(() {
          loading = false;
          chatList = loginData.result!;
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

  sendNewMessage() {
    apiUtils
        .doSendMessage(
            widget.ticket_id.toString(), messageController.text.toString())
        .then((CommonModel loginData) {
      if (loginData.status!) {
        setState(() {
          messageController.clear();
          chatList == [];
          getMessageList(widget.ticket_id.toString());
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
