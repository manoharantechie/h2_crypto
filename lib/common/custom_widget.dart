import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import 'package:h2_crypto/common/colors.dart';
import 'package:h2_crypto/common/ring.dart';

class CustomWidget {
  final BuildContext context;

  CustomWidget({required this.context});

  //TODO Alert dialog
  showSuccessAlertDialog(
    String title,
    String message,
  ) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0)), //this right here
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: [AppColors.appColor, AppColors.appColor],
                    begin: Alignment.topRight,
                    //const FractionalOffset(0.0, 0.5),
                    end: Alignment.bottomLeft,
                    //const FractionalOffset(1.0, 0.6),
                    stops: [0.0, 1.0],
                    tileMode: TileMode.clamp),
              ),
              height: MediaQuery.of(context).size.height * 0.30,
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
                      margin: EdgeInsets.only(top: 7.0, bottom: 10.0),
                      height: 2.0,
                      color: AppColors.whiteColor,
                    ),
                    Text(
                      message,
                      style: TextStyle(
                        fontSize: 13.0,
                        color: Colors.white,
                        fontFamily: 'OpenSans',
                      ),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    SizedBox(
                      child: GestureDetector(
                        child: Container(
                          width: 100,
                          height: 40,
                          margin: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0.0),
                          decoration: BoxDecoration(
                            gradient: new LinearGradient(
                                colors: [
                                  AppColors.appColor,
                                  AppColors.appColor
                                ],
                                begin: Alignment.topRight,
                                //const FractionalOffset(0.0, 0.5),
                                end: Alignment.bottomLeft,
                                //const FractionalOffset(1.0, 0.6),
                                stops: [0.0, 1.0],
                                tileMode: TileMode.clamp),
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: Align(
                            alignment: Alignment.center,
                            child: Text(
                              "ok".toUpperCase(),
                              style: TextStyle(
                                  fontSize: 16,
                                  fontFamily: "OpenSansBold",
                                  color: AppColors.whiteColor),
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
                ),
              ),
            ),
          );
        });
    // show the dialog
  }

  Widget loadingIndicator(Color color) {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      // color:  Color(0xFF1d0068),
      child:  Center(
        child: Container(
          child: Center(
            child: SpinKitDualRing(
              color: color,
            ),
          ),
        ),
      ),
    );
  }

  CustomTextStyle(Color color, FontWeight weight, String family) {
    return TextStyle(
      fontFamily: family,
      color: color,
      fontWeight: weight,
    );
  }

  custombar(String title, String message, bool status) {

   var snackBar = SnackBar(
      elevation: 0,
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      content: AwesomeSnackbarContent(
        title: title,
        message: message,
        color: status?Colors.green:Colors.red,
        contentType: status ? ContentType.success : ContentType.failure,
      ),
    );
    return ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  CustomSizedTextStyle(
      double size, Color color, FontWeight weight, String family) {
    return TextStyle(
      fontSize: size,
      fontFamily: family,
      color: color,
      fontWeight: weight,
    );
  }

  Widget noInternet() {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      // color:  Color(0xFF1d0068),
      child: Center(
        child: Container(
          child: Center(child: Image.asset('assets/image/internet.png')),
        ),
      ),
    );
  }

  Widget noRecordsFound(String data, Color color) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Center(
        child: Text(data,
            style: TextStyle(
              fontFamily: "FontRegular",
              color: color,
            )),
      ),
    );
  }
}
