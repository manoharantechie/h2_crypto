import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_svg/svg.dart';
import '../../../common/custom_widget.dart';
import '../../../common/localization/localizations.dart';
import '../../../common/theme/custom_theme.dart';
import '../../../data/api_utils.dart';
import '../../../data/model/terms_policy_model.dart';


class TermsCondition extends StatefulWidget {
  final bool title;
  final bool content;
  const TermsCondition({Key? key, required this.title, required this.content}) : super(key: key);
  @override
  State<TermsCondition> createState() => _TermsConditionState();
}

class _TermsConditionState extends State<TermsCondition> {

  bool loading = false;

  String data="";
  APIUtils apiUtils = APIUtils();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loading=true;
    getTerms();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: CustomTheme.of(context).primaryColor,

        elevation: 0.0,
        title: Text(
           widget.title ? AppLocalizations.instance.text("loc_terms"): AppLocalizations.instance.text("loc_policy"),
          // textAlign: TextAlign.center,
          style: CustomWidget(context: context).CustomSizedTextStyle(
              17.0,
              Theme.of(context).splashColor, FontWeight.w500, 'FontRegular',
          ),
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
                  0.5,
                  0.9,
                ],
                colors: [
                  CustomTheme.of(context).primaryColor,
                  CustomTheme.of(context).backgroundColor,
                  CustomTheme.of(context).accentColor,
                ])),
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 10.0),
            child:loading?CustomWidget(context: context).loadingIndicator( CustomTheme.of(context).splashColor,): Html(
              data: data,
            ),
          ),
        ),
      ),
    );
  }

  getTerms() {
    apiUtils.getTerms().then((TermsConditionModel loginData) {
      if (loginData.statusCode == 200) {
        setState(() {

          if(widget.title)
            {
              data=loginData.data![1].cmsInfo.toString();
            }
          else{
            data=loginData.data![0].cmsInfo.toString();
          }


            loading = false;
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
