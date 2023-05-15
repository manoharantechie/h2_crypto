import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tarmex/common/colors.dart';
import 'package:tarmex/common/custom_button.dart';
import 'package:tarmex/common/custom_widget.dart';
import 'package:tarmex/common/localization/localizations.dart';
import 'package:tarmex/common/textformField_custom.dart';
import 'package:tarmex/rest_api/api_utils.dart';
import 'package:tarmex/rest_api/model/bank_detail_model.dart';
import 'package:tarmex/rest_api/model/common_response_model.dart';
import 'package:tarmex/rest_api/model/country_list_model.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class AddbankScreen extends StatefulWidget {
  const AddbankScreen({Key? key}) : super(key: key);

  @override
  _AddbankScreenState createState() => _AddbankScreenState();
}

class _AddbankScreenState extends State<AddbankScreen> {

  bool loading=false;
  final formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController banknameController = TextEditingController();
  TextEditingController accNoController = TextEditingController();

  TextEditingController ifscController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController stateController = TextEditingController();
  TextEditingController zipcodeController = TextEditingController();
  BankDetails? bankDetails;
  FocusNode usernameNode = FocusNode();
  FocusNode banknameNode = FocusNode();
  FocusNode accNode = FocusNode();

  bool profileImage=false;
  FocusNode ifscNode = FocusNode();
  FocusNode addressNode = FocusNode();
  FocusNode stateNode = FocusNode();
  FocusNode zipNode = FocusNode();
  String profilePicture="";
  XFile? profile_image;
  final ImagePicker _picker = ImagePicker();

  List<BankCurrency> currencies=[];
  BankCurrency? selectedCurrency;
  Country? selectedCountry;
  List<Country> countryListData = [];
  APIUtils apiUtils = APIUtils();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getBankDetails();
    loading=true;
  }
  getCountryList() {
    apiUtils.getCountryList().then((CountyListModel loginData) {
      setState(() {
        loading = false;
      });


    setState(() {
      if (loginData.status == "1") {
        countryListData = [];
        countryListData = loginData.countries!;
        if(bankDetails!.bankCountry!.isNotEmpty)
        {

          for(int m=0;m<countryListData.length;m++)
          {

            if(bankDetails!.bankCountry.toString().toLowerCase()==countryListData[m].code.toString().toLowerCase())
            {
              selectedCountry=countryListData[m];

            }
          }
        }
        else
        {
          selectedCountry=countryListData[0];
        }

      } else {}
    });
    }).catchError((Object error) {

      setState(() {
        loading = false;
      });
      // CustomWidget(context: context).showSuccessAlertDialog(
      //     'Alert', 'Server not responded!. Please try later');
    });
  }

  openCameraOrGallery() async {
    if (await Permission.camera.request().isGranted &&
        await Permission.storage.request().isGranted &&
        await Permission.photos.request().isGranted) {
      chooseFile();
    } else {
      Map<Permission, PermissionStatus> statuses = await [
        Permission.camera,
        Permission.storage,
        Permission.photos,
      ].request();
      if (statuses[Permission.camera] == PermissionStatus.granted &&
          (statuses[Permission.storage] == PermissionStatus.granted ||
              statuses[Permission.photos] == PermissionStatus.granted)) {
        chooseFile();
      }
    }
  }

  chooseFile() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0)), //this right here
            child: Container(
              color: AppColors.whiteColor,
              height: MediaQuery.of(context).size.height * 0.28,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Image Upload'.toUpperCase(),
                      style: const TextStyle(
                        fontSize: 14.0,
                        color: AppColors.appColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    Container(
                      height: 2.0,
                      color: AppColors.appColor,
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        SizedBox(
                          child: RaisedButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.0)),
                            onPressed: () {
                              captureImage(ImageSource.gallery);
                            },
                            child: const Text(
                              "Gallery",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12.0,
                              ),
                            ),
                            color: AppColors.appColor,
                          ),
                        ),
                        SizedBox(
                          child: RaisedButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.0)),
                            onPressed: () {
                              captureImage(ImageSource.camera,);
                            },
                            child:const Text(
                              "Camera",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12.0,
                              ),
                            ),
                            color: AppColors.appColor,
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }

  Future captureImage(ImageSource captureMode) async {
    Navigator.of(context, rootNavigator: true).pop('dialog');
    final image = await _picker.pickImage(source: captureMode);
    try {

      profile_image=  image!;

      setState(() {
        profilePicture=profile_image!.path;
        profileImage=false;
      });
    } catch (e) {}
  }
  @override
  Widget build(BuildContext context) {

    return WillPopScope(
        child:MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
          child: Scaffold(
            backgroundColor: AppColors.blackColor,
            appBar: PreferredSize(
              preferredSize: Size(MediaQuery.of(context).size.width, 120.0),
              child: Container(
                  height: 100.0,
                  width: MediaQuery.of(context).size.width * 0.8,
                  color: AppColors.backgroundColor,
                  padding: const EdgeInsets.only(top: 35.0),
                  child: Center(
                    child: Stack(
                      children: [
                        Row(
                          children: [
                            const SizedBox(
                              width: 10.0,
                            ),
                            IconButton(
                                onPressed: () => {Navigator.pop(context, true)},
                                icon: const Padding(
                                  padding: EdgeInsets.only(left: 5.0),
                                  child: Icon(
                                    Icons.arrow_back_ios,
                                    size: 20,
                                    color: AppColors.appColor,
                                  ),
                                )),
                            const SizedBox(
                              width: 10.0,
                            ),
                            Container(
                                width: MediaQuery.of(context).size.width * 0.7,
                                padding: const EdgeInsets.symmetric(vertical: 10),
                                child: Center(
                                  child: Text(
                                    AppLocalizations.instance.text("loc_add_bank"),
                                    style: GoogleFonts.poppins(
                                      fontSize: 20.0,
                                      color: AppColors.whiteColor,
                                    ),
                                    textAlign: TextAlign.start,
                                  ),
                                )),
                          ],
                        )
                      ],
                    ),
                  )),
            ),
            body: SizedBox(
              child: SingleChildScrollView(
                child: Stack(
                  children: [
                    Padding(padding: const EdgeInsets.only(left: 10.0,right: 10.0,top: 20.0),child:  Column(
                      children: [
                        Form(

                            key: formKey,
                            child: Column(
                              children: [
                                TextFormFieldCustom(
                                  onEditComplete: () {
                                    usernameNode.unfocus();
                                    FocusScope.of(context).requestFocus(banknameNode);

                                  },
                                  textChanged: (value){

                                  },
                                  error: "Enter Name",
                                  textColor: AppColors.appColor,
                                  borderColor: AppColors.borderColor,
                                  fillColor: AppColors.backgroundColor,
                                  textInputAction: TextInputAction.next,
                                  focusNode: usernameNode,
                                  maxlines: 1,
                                  text: '',
                                  hintText: AppLocalizations.instance
                                      .text("loc_account_name"),
                                  obscureText: false,
                                  suffix: Container(
                                    width: 0.0,
                                  ),
                                  onChanged: () {},
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return "Please enter  name";
                                    }

                                    return null;
                                  },
                                  enabled: false,
                                  textInputType: TextInputType.name,
                                  controller: nameController,
                                  hintStyle: GoogleFonts.poppins(
                                      color: AppColors.whiteColor,
                                      fontStyle: FontStyle.normal),
                                  textStyle: GoogleFonts.poppins(
                                    color: AppColors.appColor,
                                  ),
                                ),
                                const SizedBox(
                                  height: 20.0,
                                ),
                                TextFormFieldCustom(
                                  onEditComplete: () {
                                    banknameNode.unfocus();
                                    FocusScope.of(context).requestFocus(accNode);

                                  },
                                  textChanged: (value){

                                  },
                                  error: "Enter Name",
                                  textColor: AppColors.appColor,
                                  borderColor: AppColors.borderColor,
                                  fillColor: AppColors.backgroundColor,
                                  textInputAction: TextInputAction.next,
                                  focusNode: banknameNode,
                                  maxlines: 1,
                                  text: '',
                                  hintText: AppLocalizations.instance
                                      .text("loc_bank_name"),
                                  obscureText: false,
                                  suffix: Container(
                                    width: 0.0,
                                  ),
                                  onChanged: () {},
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return "Please enter bank name";
                                    }

                                    return null;
                                  },
                                  enabled: false,
                                  textInputType: TextInputType.name,
                                  controller: banknameController,
                                  hintStyle: GoogleFonts.poppins(
                                      color: AppColors.whiteColor,
                                      fontStyle: FontStyle.normal),
                                  textStyle: GoogleFonts.poppins(
                                    color: AppColors.appColor,
                                  ),
                                ),
                                const SizedBox(
                                  height: 20.0,
                                ),
                                TextFormFieldCustom(
                                  onEditComplete: () {


                                    accNode.unfocus();
                                    FocusScope.of(context).requestFocus(ifscNode);
                                  },
                                  textChanged: (value){

                                  },
                                  error: "Enter Valid Email",
                                  textColor: AppColors.appColor,
                                  borderColor: AppColors.borderColor,

                                  fillColor: AppColors.backgroundColor,
                                  textInputAction: TextInputAction.next,
                                  focusNode: accNode,
                                  maxlines: 1,
                                  text: '',
                                  hintText: AppLocalizations.instance.text("loc_bank_acc"),
                                  obscureText: false,
                                  suffix: Container(
                                    width: 0.0,
                                  ),
                                  onChanged: () {},
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return "Please enter Account Number";
                                    }

                                    return null;
                                  },
                                  enabled: false,
                                  textInputType: TextInputType.emailAddress,
                                  controller: accNoController,
                                  hintStyle: GoogleFonts.poppins(
                                      color: AppColors.whiteColor,
                                      fontStyle: FontStyle.normal),
                                  textStyle: GoogleFonts.poppins(
                                    color: AppColors.appColor,
                                  ),
                                ),
                                // const SizedBox(
                                //   height: 20.0,
                                // ),
                                // TextFormFieldCustom(
                                //   onEditComplete: () {
                                //
                                //
                                //     branchNode.unfocus();
                                //        FocusScope.of(context).requestFocus(ifscNode);
                                //
                                //   },
                                //   textChanged: (value){
                                //
                                //   },
                                //   error: "Enter Valid Email",
                                //   textColor: AppColors.appColor,
                                //   borderColor: AppColors.borderColor,
                                //   fillColor: AppColors.backgroundColor,
                                //   textInputAction: TextInputAction.next,
                                //   focusNode: branchNode,
                                //   maxlines: 1,
                                //   text: '',
                                //   hintText: AppLocalizations.instance.text("loc_bank_branch"),
                                //   obscureText: false,
                                //   suffix: Container(
                                //     width: 0.0,
                                //   ),
                                //   onChanged: () {},
                                //   validator: (value) {
                                //     if (value!.isEmpty) {
                                //       return "Please enter Bank Branch";
                                //     }
                                //
                                //     return null;
                                //   },
                                //   enabled: false,
                                //   textInputType: TextInputType.emailAddress,
                                //   controller: branchController,
                                //   hintStyle: GoogleFonts.poppins(
                                //       color: AppColors.whiteColor,
                                //       fontStyle: FontStyle.normal),
                                //   textStyle: GoogleFonts.poppins(
                                //     color: AppColors.appColor,
                                //   ),
                                // ),
                                const SizedBox(
                                  height: 20.0,
                                ),
                                TextFormFieldCustom(
                                  onEditComplete: () {


                                    ifscNode.unfocus();
                                    FocusScope.of(context).requestFocus(addressNode);

                                  },
                                  textChanged: (value){

                                  },
                                  error: "Enter Valid Email",
                                  textColor: AppColors.appColor,
                                  borderColor: AppColors.borderColor,
                                  fillColor: AppColors.backgroundColor,
                                  textInputAction: TextInputAction.done,
                                  focusNode: ifscNode,
                                  maxlines: 1,
                                  text: '',
                                  hintText: AppLocalizations.instance.text("loc_bank_IFSC"),
                                  obscureText: false,
                                  suffix: Container(
                                    width: 0.0,
                                  ),
                                  onChanged: () {},
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return "Please enter Bank IFSC Code";
                                    }

                                    return null;
                                  },
                                  enabled: false,
                                  textInputType: TextInputType.emailAddress,
                                  controller: ifscController,
                                  hintStyle: GoogleFonts.poppins(
                                      color: AppColors.whiteColor,
                                      fontStyle: FontStyle.normal),
                                  textStyle: GoogleFonts.poppins(
                                    color: AppColors.appColor,
                                  ),
                                ),
                                const SizedBox(
                                  height: 20.0,
                                ),
                                TextFormFieldCustom(
                                  onEditComplete: () {


                                    addressNode.unfocus();
                                    FocusScope.of(context).requestFocus(stateNode);

                                  },
                                  textChanged: (value){

                                  },
                                  error: "Enter Valid Email",
                                  textColor: AppColors.appColor,
                                  borderColor: AppColors.borderColor,
                                  fillColor: AppColors.backgroundColor,
                                  textInputAction: TextInputAction.done,
                                  focusNode: addressNode,
                                  maxlines: 1,
                                  text: '',
                                  hintText: AppLocalizations.instance.text("loc_bank_address"),
                                  obscureText: false,
                                  suffix: Container(
                                    width: 0.0,
                                  ),
                                  onChanged: () {},
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return "Please enter Bank Address";
                                    }

                                    return null;
                                  },
                                  enabled: false,
                                  textInputType: TextInputType.emailAddress,
                                  controller: addressController,
                                  hintStyle: GoogleFonts.poppins(
                                      color: AppColors.whiteColor,
                                      fontStyle: FontStyle.normal),
                                  textStyle: GoogleFonts.poppins(
                                    color: AppColors.appColor,
                                  ),
                                ),

                                const SizedBox(
                                  height: 20.0,
                                ),
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10.0, vertical: 1.0),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: AppColors.borderColor,
                                        width: 1.0),
                                    borderRadius: BorderRadius.circular(5.0),
                                    color: AppColors.backgroundColor,
                                  ),
                                  child: Theme(
                                    data: Theme.of(context).copyWith(
                                      canvasColor: AppColors.borderColor,
                                    ),
                                    child: DropdownButtonHideUnderline(
                                      child: DropdownButton<BankCurrency>(

                                        menuMaxHeight: MediaQuery.of(context).size.height*0.7,
                                        items: currencies
                                            .map((value) => DropdownMenuItem(
                                          child: Text(
                                            value.currencyName.toString(),
                                            style: GoogleFonts.poppins(
                                                color: AppColors
                                                    .whiteColor,
                                                fontStyle:
                                                FontStyle.normal),
                                          ),
                                          value: value,
                                        ))
                                            .toList(),
                                        onChanged: (value) async {
                                          setState(() {
                                            selectedCurrency=value!;

                                          });
                                        },
                                        hint: Text(
                                          "Currency",
                                          style: GoogleFonts.poppins(
                                              color: AppColors.whiteColor,
                                              fontStyle: FontStyle.normal),
                                        ),
                                        isExpanded: true,
                                        value: selectedCurrency,
                                        icon: const Icon(
                                          Icons.keyboard_arrow_down,
                                          color: AppColors.whiteColor,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 20.0,
                                ),
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10.0, vertical: 1.0),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: AppColors.borderColor,
                                        width: 1.0),
                                    borderRadius: BorderRadius.circular(5.0),
                                    color: AppColors.backgroundColor,
                                  ),
                                  child: Theme(
                                    data: Theme.of(context).copyWith(
                                      canvasColor: AppColors.borderColor,
                                    ),
                                    child: DropdownButtonHideUnderline(
                                      child: DropdownButton<Country>(

                                        menuMaxHeight: MediaQuery.of(context).size.height*0.7,
                                        items: countryListData
                                            .map((value) => DropdownMenuItem(
                                          child: Text(
                                            value.name.toString(),
                                            style: GoogleFonts.poppins(
                                                color: AppColors
                                                    .whiteColor,
                                                fontStyle:
                                                FontStyle.normal),
                                          ),
                                          value: value,
                                        ))
                                            .toList(),
                                        onChanged: (value) async {
                                          setState(() {
                                            selectedCountry=value!;

                                          });
                                        },
                                        hint: Text(
                                          "Country of Residence",
                                          style: GoogleFonts.poppins(
                                              color: AppColors.whiteColor,
                                              fontStyle: FontStyle.normal),
                                        ),
                                        isExpanded: true,
                                        value: selectedCountry,
                                        icon: const Icon(
                                          Icons.keyboard_arrow_down,
                                          color: AppColors.whiteColor,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 20.0,
                                ),
                                TextFormFieldCustom(
                                  onEditComplete: () {


                                    stateNode.unfocus();
                                    FocusScope.of(context).requestFocus(zipNode);

                                  },
                                  textChanged: (value){

                                  },
                                  error: "Enter Valid Email",
                                  textColor: AppColors.appColor,
                                  borderColor: AppColors.borderColor,
                                  fillColor: AppColors.backgroundColor,
                                  textInputAction: TextInputAction.done,
                                  focusNode: stateNode,
                                  maxlines: 1,
                                  text: '',
                                  hintText: AppLocalizations.instance.text("loc_state"),
                                  obscureText: false,
                                  suffix: Container(
                                    width: 0.0,
                                  ),
                                  onChanged: () {},
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return "Please enter State";
                                    }

                                    return null;
                                  },
                                  enabled: false,
                                  textInputType: TextInputType.emailAddress,
                                  controller: stateController,
                                  hintStyle: GoogleFonts.poppins(
                                      color: AppColors.whiteColor,
                                      fontStyle: FontStyle.normal),
                                  textStyle: GoogleFonts.poppins(
                                    color: AppColors.appColor,
                                  ),
                                ),
                                const SizedBox(
                                  height: 20.0,
                                ),
                                TextFormFieldCustom(
                                  onEditComplete: () {


                                    zipNode.unfocus();

                                  },
                                  textChanged: (value){

                                  },
                                  error: "Enter Valid Email",
                                  textColor: AppColors.appColor,
                                  borderColor: AppColors.borderColor,
                                  fillColor: AppColors.backgroundColor,
                                  textInputAction: TextInputAction.done,
                                  focusNode: zipNode,
                                  maxlines: 1,
                                  text: '',
                                  hintText: AppLocalizations.instance.text("loc_zip"),
                                  obscureText: false,
                                  suffix: Container(
                                    width: 0.0,
                                  ),
                                  onChanged: () {},
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return "Please enter ZipCode";
                                    }

                                    return null;
                                  },
                                  enabled: false,
                                  textInputType: TextInputType.emailAddress,
                                  controller: zipcodeController,
                                  hintStyle: GoogleFonts.poppins(
                                      color: AppColors.whiteColor,
                                      fontStyle: FontStyle.normal),
                                  textStyle: GoogleFonts.poppins(
                                    color: AppColors.appColor,
                                  ),
                                ),
                                const SizedBox(
                                  height: 20.0,
                                ),

                                InkWell(
                                  onTap: (){
                                    openCameraOrGallery();
                                  },
                                  child:  Row(
                                    children: [
                                      SvgPicture.asset('assets/icon/galley.svg',color: AppColors.appColor,height: 20.0,),
                                      const SizedBox(width: 10.0,),
                                      Expanded(child: Text(profilePicture.isNotEmpty?profilePicture:AppLocalizations.instance
                                          .text("loc_add_dco"),style:  GoogleFonts.poppins(
                                        color: AppColors.whiteColor,
                                      ),))
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  height: 20.0,
                                ),


                                ButtonCustom(
                                    text: AppLocalizations.instance
                                        .text("loc_submit")
                                        .toUpperCase(),
                                    iconEnable: false,
                                    radius: 5.0,
                                    icon: "",
                                    textStyle: GoogleFonts.poppins(
                                        color: AppColors.backgroundColor,
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.bold),
                                    iconColor: AppColors.appColor,
                                    buttonColor: AppColors.appColor,
                                    splashColor: AppColors.appColor,
                                    onPressed: () {
                                      if (formKey.currentState!.validate()) {
                                        if(profilePicture.isNotEmpty)
                                        {
                                          setState(() {

                                            updateBankDetails();
                                            loading=true;
                                          });
                                        }
                                        else
                                        {
                                          showTopSnackBar(
                                            context,
                                            const CustomSnackBar.error(message: "Select the bank Document"),
                                          );
                                        }

                                      }
                                    },
                                    paddng: 1.0),
                                const SizedBox(
                                  height:40.0,
                                ),

                              ],
                            ))

                      ],
                    ),),
                    loading
                        ? CustomWidget(context: context).loadingIndicator()
                        : Container()
                  ],
                ),
              ),
            ),
          ),
        ),
        onWillPop: () async => _backPressed());
  }
  Future<bool> _backPressed() async {
    Navigator.pop(context, true);
    return Future<bool>.value(true);
  }


  updateBankDetails() {
    apiUtils.addBankDetails(nameController.text,banknameController.text,accNoController.text,ifscController.text,addressController.text,selectedCountry!.code.toString(),stateController.text,zipcodeController.text,selectedCurrency!.id.toString()).then((CommonResponse loginData) {
      setState(() {

        if (loginData.status.toString() == "1") {

          if(!profileImage)
            {
              updatebankProof();
            }
        else
          {
           loading=false;
            showTopSnackBar(
              context,
              CustomSnackBar.success(message: loginData.message.toString()),
            );
          }

        } else {
          showTopSnackBar(
            context,
            CustomSnackBar.error(message: loginData.message.toString()),
          );
        }
      });
    }).catchError((Object error) {
      setState(() {
        loading = false;
      });
    });
  }

  updatebankProof() {
    apiUtils.updateBankproof(profile_image!).then((CommonResponse loginData) {
      setState(() {
        loading = false;
        if (loginData.status.toString() == "1") {

          showTopSnackBar(
            context,
            CustomSnackBar.success(message: loginData.message.toString()),
          );

        } else {
          showTopSnackBar(
            context,
            CustomSnackBar.error(message: loginData.message.toString()),
          );
        }
      });
    }).catchError((Object error) {

      setState(() {
        loading = false;
      });
    });
  }

  getBankDetails() {
    apiUtils.getBankDetails().then((BankDetailsResponse loginData) {
      setState(() {

        if (loginData.status.toString() == "1") {
          currencies=loginData.currencies!;
            bankDetails=loginData.bankDetails!;
            profilePicture=loginData.users!.photoId5.toString();
            nameController.text=bankDetails!.bankAccountName.toString();
            banknameController.text=bankDetails!.bankName.toString();
            accNoController.text=bankDetails!.bankAccountNumber.toString();
          profileImage=true;
            addressController.text=bankDetails!.bankAddress.toString();
            ifscController.text=bankDetails!.bankSwift.toString();
            stateController.text=bankDetails!.bankCity.toString();
            zipcodeController.text=bankDetails!.bankPostalcode.toString();
            if(bankDetails!.currency.toString().isNotEmpty) {
              for (int m = 0; m < currencies.length; m++) {
                if (bankDetails!.currency!.toString().toLowerCase() ==
                    currencies[m].id!.toLowerCase()) {
                  selectedCurrency = currencies[m];
                }
              }
            }
            else
              {
                selectedCurrency=currencies[0];
              }

          getCountryList();

        } else {

        }
      });
    }).catchError((Object error) {

      setState(() {
        loading = false;
      });
    });
  }
}
