import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:h2_crypto/common/custom_widget.dart';
import 'package:h2_crypto/common/localization/localizations.dart';
import 'package:h2_crypto/common/text_field_custom_prefix.dart';
import 'package:h2_crypto/common/textformfield_custom.dart';
import 'package:h2_crypto/common/theme/custom_theme.dart';
import 'package:h2_crypto/data/api_utils.dart';
import 'package:h2_crypto/data/crypt_model/common_model.dart';


class ChangePassword extends StatefulWidget {
  const ChangePassword({Key? key}) : super(key: key);

  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  TextEditingController currentpasswordController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmpasswordController = TextEditingController();

  FocusNode currentpassWordNode = FocusNode();
  FocusNode passWordNode = FocusNode();
  FocusNode confirm_passWordNode = FocusNode();

  bool _currentpasswordVisible = false;


  bool _passwordVisible = false;
  bool _confirmpasswordVisible = false;
  String _confirmpassword = "";
  String _currentpassword = "";
  String _password = "";
  final formKey = GlobalKey<FormState>();
  APIUtils apiUtils = APIUtils();
  bool loading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: CustomTheme.of(context).primaryColor,
          elevation: 0.0,
          centerTitle: true,
          title: Text(
            AppLocalizations.instance.text("loc_change_password"),
            style: CustomWidget(context: context)
                .CustomSizedTextStyle(
                17.0,
                Theme.of(context).splashColor,
                FontWeight.w500,
                'FontRegular'),
          ),
          leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(
              padding: EdgeInsets.only(left: 16.0, right: 16.0),
              child: SvgPicture.asset(
                'assets/others/arrow_left.svg',
                color: CustomTheme.of(context).splashColor,

              ),
            ),
          )),
      body: Container(
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
                    CustomTheme.of(context).dialogBackgroundColor,
                  ])),
          child: Stack(
            children: [
             SingleChildScrollView(
               child:  Column(
                 children: [

                   Container(
                     width:MediaQuery.of(context).size.width,
                     padding: EdgeInsets.only(top: 15.0,bottom: 15.0),
                     color: Color(0xFFFBC02D).withOpacity(0.3),
                     child: Row(
                       children: [
                         const SizedBox(width: 20.0,),
                         SvgPicture.asset('assets/images/info.svg',height: 24.0,color: Color(0xFFFAAD34),),
                         const SizedBox(width: 10.0,),
                         Flexible(child:  Text(
                           AppLocalizations.instance.text("loc_changep_info"),

                           style: CustomWidget(context: context)
                               .CustomSizedTextStyle(
                               12.0,
                               Theme.of(context).splashColor.withOpacity(0.5),
                               FontWeight.w500,
                               'FontRegular'),
                           textAlign: TextAlign.start,
                           softWrap: true,
                         ),)
                       ],
                     ),
                   ),
                   Padding(
                       padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                       child:  Form(
                         key: formKey,
                         child:Column(
                           crossAxisAlignment: CrossAxisAlignment.start,
                           mainAxisAlignment: MainAxisAlignment.start,
                           children: [
                             const SizedBox(
                               height: 30,
                             ),
                             TextFormCustom(
                               autovalidateMode: AutovalidateMode.onUserInteraction,
                               obscureText: !_currentpasswordVisible,
                               textInputAction: TextInputAction.done,

                               hintStyle: CustomWidget(context: context)
                                   .CustomSizedTextStyle(
                                   14.0, CustomTheme.of(context).splashColor
                                   .withOpacity(0.5),
                                   FontWeight.normal,
                                   'FontRegular'),
                               radius: 5.0,
                               focusNode: currentpassWordNode,
                               controller: currentpasswordController,
                               enabled: true,
                               fillColor:   CustomTheme.of(context).primaryColor,
                               onChanged: () {},
                               hintText: AppLocalizations.instance.text("loc_old_pass"),
                               textChanged: (value) {},
                               prefix: Icon(Icons.lock, color: CustomTheme.of(context).splashColor.withOpacity(0.5),size: 20.0,),

                               suffix: IconButton(
                                 icon: Icon(
                                   _currentpasswordVisible
                                       ? Icons.visibility
                                       : Icons.visibility_off,
                                   color: CustomTheme.of(context).splashColor.withOpacity(0.5),
                                   size: 20.0,
                                 ),
                                 onPressed: () {
                                   setState(() {
                                     _currentpasswordVisible = !_currentpasswordVisible;
                                   });
                                 },
                               ),
                               validator: (value) {
                                 if (value!.isEmpty) {
                                   return "Please enter Old Password";
                                 }
                                 else if (!RegExp(r"^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~.]).{8,}$")
                                     .hasMatch(value)) {
                                   return "Please enter valid Password";
                                 }
                                 else if(value.toString().length<8){
                                   return "Please enter Valid Old Password";
                                 }

                                 return null;
                               },
                               textStyle:CustomWidget(context: context)
                                   .CustomTextStyle(
                                   CustomTheme.of(context).splashColor,
                                   FontWeight.normal,
                                   'FontRegular'),
                               borderColor:  CustomTheme.of(context).splashColor,
                               maxlines: 1,
                               error: "Enter Valid Password",
                               text: "",
                               onEditComplete: () {
                                 currentpassWordNode.unfocus();
                                 FocusScope.of(context).requestFocus(passWordNode);
                               },
                               textColor: CustomTheme.of(context).splashColor,
                               textInputType: TextInputType.visiblePassword,
                             ),

                             const SizedBox(
                               height: 15.0,
                             ),
                             TextFormCustom(
                               autovalidateMode: AutovalidateMode.onUserInteraction,
                               obscureText: !_passwordVisible,
                               textInputAction: TextInputAction.done,

                               hintStyle: CustomWidget(context: context)
                                   .CustomSizedTextStyle(
                                   14.0, CustomTheme.of(context).splashColor
                                   .withOpacity(0.5),
                                   FontWeight.normal,
                                   'FontRegular'),
                               radius: 5.0,
                               focusNode: passWordNode,
                               controller: passwordController,
                               enabled: true,
                               fillColor:   CustomTheme.of(context).primaryColor,
                               onChanged: () {},

                               hintText:
                               AppLocalizations.instance.text("loc_current_pass"),
                               textChanged: (value) {},
                               prefix: Icon(Icons.lock, color: CustomTheme.of(context).splashColor.withOpacity(0.5),size: 20.0,),
                               suffix: IconButton(
                                 icon: Icon(
                                   _passwordVisible
                                       ? Icons.visibility
                                       : Icons.visibility_off,
                                   color: CustomTheme.of(context).splashColor.withOpacity(0.5),
                                   size: 20.0,
                                 ),
                                 onPressed: () {
                                   setState(() {
                                     _passwordVisible = !_passwordVisible;
                                   });
                                 },
                               ),
                               validator: (value) {
                                 if (value!.isEmpty) {
                                   return "Please enter New Password";
                                 }
                                 else if (!RegExp(r"^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~.]).{8,}$")
                                     .hasMatch(value)) {
                                   return "Please enter valid New Password";
                                 }
                                 else if(value.length<8){
                                   return "Please enter minimum 8 character Password";
                                 }


                                 return null;
                               },
                               textStyle:CustomWidget(context: context)
                                   .CustomTextStyle(
                                   CustomTheme.of(context).splashColor,
                                   FontWeight.normal,
                                   'FontRegular'),
                               borderColor:  CustomTheme.of(context).splashColor,
                               maxlines: 1,
                               error: "Enter Valid Password",
                               text: "",
                               onEditComplete: () {
                                 passWordNode.unfocus();
                                 FocusScope.of(context)
                                     .requestFocus(confirm_passWordNode);
                               },
                               textColor: CustomTheme.of(context).splashColor,
                               textInputType: TextInputType.visiblePassword,
                             ),
                             const SizedBox(
                               height: 15.0,
                             ),
                             TextFormCustom(
                               autovalidateMode: AutovalidateMode.onUserInteraction,
                               obscureText: !_confirmpasswordVisible,
                               textInputAction: TextInputAction.done,
                               hintStyle: CustomWidget(context: context)
                                   .CustomSizedTextStyle(
                                   14.0, CustomTheme.of(context).splashColor
                                   .withOpacity(0.5),
                                   FontWeight.normal,
                                   'FontRegular'),
                               radius: 5.0,
                               focusNode: confirm_passWordNode,
                               controller: confirmpasswordController,
                               enabled: true,
                               fillColor:   CustomTheme.of(context).primaryColor,
                               onChanged: () {},
                               hintText: AppLocalizations.instance.text("loc_new_pass"),
                               textChanged: (value) {},
                               prefix: Icon(Icons.lock, color: CustomTheme.of(context).splashColor.withOpacity(0.5),size: 20.0,),
                               suffix: IconButton(
                                 icon: Icon(
                                   _confirmpasswordVisible
                                       ? Icons.visibility
                                       : Icons.visibility_off,
                                   color:   CustomTheme.of(context).splashColor.withOpacity(0.5),
                                   size: 20.0,
                                 ),
                                 onPressed: () {
                                   setState(() {
                                     _confirmpasswordVisible = !_confirmpasswordVisible;
                                   });
                                 },
                               ),
                               validator: (value) {
                                 if (value!.isEmpty) {
                                   return "Please enter Confirm Password";
                                 }
                                 else if (!RegExp(r"^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~.]).{8,}$")
                                     .hasMatch(value)) {
                                   return "Please enter valid Password";
                                 }
                                 else if(value.length<8){
                                   return "Please enter minimum 8 character Password";
                                 }
                                 return null;
                               },
                               textStyle:CustomWidget(context: context)
                                   .CustomTextStyle(
                                   CustomTheme.of(context).splashColor,
                                   FontWeight.normal,
                                   'FontRegular'),
                               borderColor:  CustomTheme.of(context).splashColor,
                               maxlines: 1,
                               error: "Enter Valid Password",
                               text: "",
                               onEditComplete: () {
                                 currentpassWordNode.unfocus();
                               },
                               textColor:  CustomTheme.of(context).splashColor,
                               textInputType: TextInputType.visiblePassword,
                             ),
                             const SizedBox(
                               height: 40.0,
                             ),
                             Container(
                               padding: EdgeInsets.symmetric(horizontal: 10.0),
                               width: MediaQuery.of(context).size.width,
                               child:  Text(
                                 "Note :".toUpperCase(),
                                 textAlign: TextAlign.start,
                                 style: CustomWidget(context: context)
                                     .CustomSizedTextStyle(
                                     14.0,
                                     Theme.of(context)
                                         .scaffoldBackgroundColor,
                                     FontWeight.w600,
                                     'FontRegular'),
                               ),
                             ),
                             SizedBox(height: 10),
                             Container(
                               padding: EdgeInsets.symmetric(horizontal: 10.0),
                               width: MediaQuery.of(context).size.width,
                               child:  Text(
                                 "To make your password more secure: (Minimum 8 characters,Use numbers,Use uppercase,Use lowercase and Use special characters)",
                                 textAlign: TextAlign.start,
                                 overflow: TextOverflow.visible,
                                 style: CustomWidget(context: context)
                                     .CustomSizedTextStyle(
                                     13.0,
                                     Theme.of(context)
                                         .splashColor,
                                     FontWeight.w500,
                                     'FontRegular'),
                               ),
                             ),
                             const SizedBox(
                               height: 20.0,
                             ),

                             InkWell(
                               onTap: () {
                                 setState(() {
                                   FocusScope.of(context).unfocus();
                                   if (formKey.currentState!.validate()) {
                                     setState(() {

                                       if(passwordController.text.toString()==confirmpasswordController.text.toString())
                                       {


                                       }
                                       else
                                       {
                                         CustomWidget(context: context).  custombar("Change Password", "New Password and Confirm Password Mismatched", false);


                                       }

                                     });
                                   }

                                 });
                               },
                               child: Container(
                                   decoration: BoxDecoration(
                                     color:  CustomTheme.of(context).shadowColor,
                                     borderRadius:
                                     BorderRadius.all(Radius.circular(5.0)),
                                   ),
                                   padding:
                                   const EdgeInsets.only(top: 13.0, bottom: 13.0),
                                   child: Center(
                                     child: Text(
                                       AppLocalizations.instance.text("loc_submit"),
                                       style:  CustomWidget(context: context)
                                           .CustomTextStyle(
                                           CustomTheme.of(context).splashColor,
                                           FontWeight.w500,
                                           'FontRegular'),
                                     ),
                                   )),
                             ),
                             const SizedBox(
                               height: 30,
                             ),
                           ],
                         ),
                       )
                   ),

                 ],
               ),
             ),

              loading
                  ? CustomWidget(context: context)
                      .loadingIndicator(CustomTheme.of(context).splashColor)
                  : Container()
            ],
          )),
    );
  }

}
