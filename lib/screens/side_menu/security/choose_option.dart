import 'package:flutter/material.dart';
import 'package:h2_crypto/common/custom_widget.dart';
import 'package:h2_crypto/common/theme/custom_theme.dart';
import 'package:h2_crypto/screens/side_menu/security/kyb_info.dart';
import 'package:h2_crypto/screens/side_menu/security/kyc_info.dart';

class ChooseOption extends StatefulWidget {
  const ChooseOption({Key? key}) : super(key: key);

  @override
  State<ChooseOption> createState() => _ChooseOptionState();
}

class _ChooseOptionState extends State<ChooseOption> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomTheme.of(context).primaryColor,
      body: Container(
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
                  CustomTheme.of(context).dialogBackgroundColor,
                ])),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "SELECT ACCOUNT TYPE",
              style: CustomWidget(context: context).CustomSizedTextStyle(20.0,
                  Theme.of(context).splashColor, FontWeight.w500, 'FontRegular'),
            ),
           const SizedBox(height: 35.0,),

           InkWell(
             onTap: (){
               {
                 Navigator.of(context).pushReplacement(
                   MaterialPageRoute(
                     builder: (context) => KYCPage(),
                   ),
                 );
               }
             },
             child:  Container(
               width: MediaQuery.of(context).size.width,
               margin: EdgeInsets.only(left: 25.0,right: 25.0),
               padding: EdgeInsets.only(top: 45.0,bottom: 45.0),

               decoration: BoxDecoration(
                   color:     Color(0xFF0d6efd),
                   borderRadius: BorderRadius.circular(15.0)

               ),
               child: Column(
                 children: [
                   Image.asset('assets/images/personal-account.png',height: 70.0,),

                   const SizedBox(height: 10.0,),
                   Text(
                     "Personal Account",
                     style: CustomWidget(context: context).CustomSizedTextStyle(20.0,
                         Theme.of(context).splashColor, FontWeight.w500, 'FontRegular'),
                   ),

                 ],
               ),
             ),
           ),
            const SizedBox(height: 25.0,),
            InkWell(
              onTap: (){
                {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => KYBPage(),
                    ),
                  );
                }
              },
              child:  Container(
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.only(left: 25.0,right: 25.0),
                padding: EdgeInsets.only(top: 45.0,bottom: 45.0),

                decoration: BoxDecoration(
                    color:      CustomTheme.of(context).shadowColor,
                    borderRadius: BorderRadius.circular(15.0)

                ),
                child: Column(
                  children: [
                    Image.asset('assets/images/business-account.png',height: 70.0,),

                    const SizedBox(height: 10.0,),
                    Text(
                      "Business Account",
                      style: CustomWidget(context: context).CustomSizedTextStyle(20.0,
                          Theme.of(context).splashColor, FontWeight.w500, 'FontRegular'),
                    ),

                  ],
                ),
              ),
            )
          ],
        )
      ),
    );
  }
}
