import 'dart:convert';
import 'package:h2_crypto/data/crypt_model/coin_list.dart';
import 'package:h2_crypto/data/model/login_model.dart';
import 'package:http/http.dart' as http;
import 'package:h2_crypto/data/model/allopenorderhistory_model.dart';
import 'package:h2_crypto/data/model/balance_list_model.dart';
import 'package:h2_crypto/data/model/banner_list_model.dart';
import 'package:h2_crypto/data/model/chat_data_model.dart';
import 'package:h2_crypto/data/model/coin_balance_model.dart';
import 'package:h2_crypto/data/model/common_model.dart';
import 'package:h2_crypto/data/model/deposit_details_model.dart';
import 'package:h2_crypto/data/model/deposit_history_model.dart';
import 'package:h2_crypto/data/model/future_open_order_model.dart';
import 'package:h2_crypto/data/model/get_post_ad_model.dart';
import 'package:h2_crypto/data/model/google_enable_tfa_model.dart';
import 'package:h2_crypto/data/model/google_tfa_model.dart';
import 'package:h2_crypto/data/model/instant_model.dart';
import 'package:h2_crypto/data/model/instant_value_model.dart';
import 'package:h2_crypto/data/model/loan_history_model.dart';

import 'package:h2_crypto/data/model/margin_loan_model.dart';
import 'package:h2_crypto/data/model/margin_repay_loan_model.dart';
import 'package:h2_crypto/data/model/margin_trade_model.dart';
import 'package:h2_crypto/data/model/margin_transfer_model.dart';
import 'package:h2_crypto/data/model/my_ad_details_model.dart';
import 'package:h2_crypto/data/model/my_ads_model.dart';
import 'package:h2_crypto/data/model/open_order_list_model.dart';
import 'package:h2_crypto/data/model/orderbook_model.dart';
import 'package:h2_crypto/data/model/p2p_live_price_model.dart';
import 'package:h2_crypto/data/model/position_model.dart';
import 'package:h2_crypto/data/model/post_add_model.dart';
import 'package:h2_crypto/data/model/purchased_ad_model.dart';
import 'package:h2_crypto/data/model/refresh_token_model.dart';
import 'package:h2_crypto/data/model/sent_otp_model.dart';
import 'package:h2_crypto/data/model/terms_policy_model.dart';
import 'package:h2_crypto/data/model/trade_pair_detail_data.dart';
import 'package:h2_crypto/data/model/trade_pair_list_model.dart';
import 'package:h2_crypto/data/model/upload_p2p_model.dart';
import 'package:h2_crypto/data/model/user_details_model.dart';
import 'package:h2_crypto/data/model/wallet_bal_model.dart';
import 'package:h2_crypto/data/model/wallet_list_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart';

import 'model/asset_details_model.dart';
import 'model/assets_list_model.dart';
import 'model/check_quote_model.dart';
import 'model/country_code.dart';
import 'model/get_done_order_model.dart';
import 'model/get_payment_details_model.dart';
import 'model/individual_user_details.dart';
import 'model/kyc_verify.dart';
import 'model/payment_model.dart';
import 'model/user_wallet_balance_model.dart';

class APIUtils {
  /*static const baseURL = 'http://43.205.10.212';*/
  /* static const baseURL = 'http://43.205.149.22';*/

  static const baseURL = 'https://cifdaq.in';
  static const crypto_baseURL = 'http://h2crypto.exchange/';
  static const crypto_baseURL_Sfox = 'https://api.sfox.com/';

  Socket? socketChat;
  static const String regURL = 'api/register';
  static const String verifyOtpURL = '/api/v1/users/userverify';
  static const String loginURL = 'api/login';
  static const String forgotMobURL = '/api/v1/users/forgot';
  static const String walletListURL = '/api/v1/wallet/get_wallet';

  static const String limitSellUrl = '/api/v1/trade/selllimit';
  static const String limitBuyUrl = '/api/v1/trade/buylimit';
  static const String getBalUrl = '/api/v1/asset/getCoin';
  static const String getDepositUrl = '/api/v1/asset/getAddress';
  static const String refreshTokenUrl = '/api/v1/users/token';
  static const String userDetailsUrl = '/api/v1/users/get';
  static const String bannerListUrl = '/api/v1/users/getbanner';
  static const String gtfaUrl = '/api/v1/users/2fa';
  static const String kycUrl = '/api/v1/users/initialKycVerify';
  static const String changePassUrl = '/api/v1/users/changepassword';
  static const String tfaEnableUrl = '/api/v1/users/2faverify';
  static const String openOrderUrl = '/api/v1/trade/myopenorder';
  static const String placeOrderUrl = '/api/v1/trade/placeorder';
  static const String updateEmailUrl = '/api/v1/users/verifyalternate';
  static const String verifyTFAUrl = '/api/v1/users/verifycode';
  static const String cancelTradeUrl = '/api/v1/trade/cancel';
  static const String updateNameUrl = '/api/v1/users/updateuser';
  static const String depositHistoryUrl = '/api/v1/crypto/get';
  static const String chartDataUrl = '/api/v1/trade/getklines';
  static const String addFavUrl = '/api/v1/tradepair/AddfavPair';
  static const String getOrderBookUrl = '/api/v1/tradepair/getowntradebook';
  static const String getloanHistoryUrl = '/api/v1/margin/loanhistory';
  static const String termsConditionUrl = '/api/v1/cms/getcms';
  static const String walletBalanceUrl =
      '/api/v1/wallet/getoverallbalance?type=coin';
  static const String checkreferUrl = '/api/v1/users/findrefer';
  static const String marginTradeUrl = '/api/v1/trade/placeorderdetails';
  static const String marginLoanUrl = '/api/v1/margin/loan';
  static const String marginRepayLoanUrl = '/api/v1/margin/repayloan';
  static const String marginToSpotTransferUrl = '/api/v1/margin/tranfermargin';
  static const String spotToMarginTransferUrl = '/api/v1/margin/tranferspot';

  static const String instantValueUrl = '/api/v1/trade/instantvalue';
  static const String instantTrade = '/api/v1/trade/instantbuysell';
  static const String p2pAllPostAdd = '/api/v1/p2pad/postad';
  static const String p2pGetAllPostAdd = '/api/v1/p2pad/postad';
  static const String p2pGetMyPostAdd = '/api/v1/p2pad/myads';
  static const String p2pGetMyPostAdDetails = '/api/v1/p2pad/purchasedad';
  static const String p2pGetPurchaseAd = '/api/v1/p2pad/purchasedad';
  static const String p2pUploadImage = '/api/v1/p2pad/imageupload';
  static const String p2pNotificationUrl = '/api/v1/p2pad/notification';
  static const String p2pCancelUrl = '/api/v1/p2pad/canceltradeemail';
  static const String p2pLiveAssetUrl = '/api/v1/p2pad/liveprice';
  static const String p2pReleaseFundUrl = '/api/v1/p2pad/buysellad';
  static const String paymentUrl = '/api/v1/userbank/paymentmethod';
  static const String sendNewMessageUrl = '/api/v1/chat/sendchat';
  static const String chatHistoryUrl = '/api/v1/chat/chatdata';


  static const String KycVerifyUrl = 'api/add-kyc';
  static const String emailSendOTPUrl = 'api/send-otp';
  static const String verifyOTPUrl = 'api/verify-otp';
  static const String logoutUrl = 'api/logout';
  static const String countryCodesUrl = 'api/country';
  static const String tradePairURL = 'api/trade-pairs';
  static const String forgotPasswordURL = 'api/resetpassword';
  static const String forgotPasswordVerifyURL = 'api/changeresetpassword';
  static const String userDetailsURL = 'api/userdetails';
  static const String assetsListURL = 'api/assets-list';
  static const String userWalletBalanceURL = 'api/user-balance';
  static const String assetDetailsURL = 'api/asset-details';
  static const String withdrawAssetURL = 'api/withdraw-asset';
  static const String checkQuotesURL = 'api/check-quote';
  static const String postTradeURL = 'api/post-trade';

  static const String doneOrdersURL = 'v1/orders/done';
  static const String cancelOrdersURL = 'v1/orders/:order_id';
  static const String getOpenOrdersURL = 'v1/orders';
  static const String stopLimitUrl = '/api/post-trade';





  Future<CommonModel> doVerifyRegister(
      String first_name, String last_name, String email, String device, String location, String password,  String con_password) async {
    var emailbodyData = {
      'first_name': first_name,
      'last_name': last_name,
      'email': email,
      'device': device,
      'location': "location",
      'password': password,
      'passwordconfirmation': con_password,

    };

    final response =
        await http.post(Uri.parse(crypto_baseURL + regURL), body: emailbodyData);

    return CommonModel.fromJson(json.decode(response.body));
  }


  Future<LoginDetailsModel> doLoginEmail(String email, String pass) async {
    var emailbodyData = {
      'email': email,
      'password': pass,
      'ipaddr': '100.00.22.223',
      'device': 'Android',
      'location': 'location',
    };
    final response =
        await http.post(Uri.parse(crypto_baseURL + loginURL), body: emailbodyData);


    return LoginDetailsModel.fromJson(json.decode(response.body));
  }

  Future<SentOtpModel> getforgotPassword(
      String url, String email, bool isMail) async {
    var emailbodyData = {
      'email': email,
      "type": "verify",
      'signup_type': '0',
    };
    var mobilebodyData = {
      'phoneNo': email,
      "type": "verify",
      'signup_type': '1',
    };

    final response = await http.post(Uri.parse(baseURL + url),
        body: isMail ? emailbodyData : mobilebodyData);

    return SentOtpModel.fromJson(json.decode(response.body));
  }

  Future<CommonModel> forgotPassword(
      String email) async {
    var emailbodyData = {
      'email': email,
    };

    final response = await http.post(Uri.parse(crypto_baseURL + forgotPasswordURL),
        body: emailbodyData );

    return CommonModel.fromJson(json.decode(response.body));
  }

  Future<CommonModel> doVerifyOTP(
      String email, String otp, String password, String confPass) async {
    var emailbodyData = {
      'email': email,
      "otp": otp,
      "password": password,
      "confirmpassword": confPass
    };

    final response = await http.post(Uri.parse(crypto_baseURL + forgotPasswordVerifyURL),
        body: emailbodyData );

    return CommonModel.fromJson(json.decode(response.body));
  }

  Future<CommonModel> postTrade(
      String pair, String side, String password, String type, String quantity, String price, String quote_id) async {
    var emailbodyData = {
      'pair': pair,
      "side": side,
      "type": type,
      "quantity": quantity,
      "price": price,
      "quote_id": quote_id
    };

    final response = await http.post(Uri.parse(crypto_baseURL + postTradeURL),
        body: emailbodyData );

    return CommonModel.fromJson(json.decode(response.body));
  }

  Future<IndividualUserDetailsModel> userDetailsInfo() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final response = await http.post(Uri.parse(crypto_baseURL + userDetailsURL),
        headers: {"authorization": "Bearer "+preferences.getString("token").toString()});

    return IndividualUserDetailsModel.fromJson(json.decode(response.body));
  }

  Future<AssetsListModel> assetsListInfo() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final response = await http.post(Uri.parse(crypto_baseURL + assetsListURL),
        headers: {"authorization": "Bearer "+preferences.getString("token").toString()});

    return AssetsListModel.fromJson(json.decode(response.body));
  }

  Future<UserWalletBalanceModel> walletBalanceInfo() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final response = await http.post(Uri.parse(crypto_baseURL + userWalletBalanceURL),
        headers: {"authorization": "Bearer "+preferences.getString("token").toString()});

    return UserWalletBalanceModel.fromJson(json.decode(response.body));
  }


  Future<AssetDetailsModel> assetDetails(String assetname) async {
    var bodyData = {
      'asset': assetname
    };

    final response = await http.post(Uri.parse(crypto_baseURL + assetDetailsURL),
        body: bodyData );

    return AssetDetailsModel.fromJson(json.decode(response.body));
  }

  Future<CommonModel> withdrawAssetDetails(String assetname, String address, String amount) async {
    var bodyData = {
      'asset': assetname,
      'address': address,
      'amount': amount
    };

    final response = await http.post(Uri.parse(crypto_baseURL + withdrawAssetURL),
        body: bodyData );

    return CommonModel.fromJson(json.decode(response.body));
  }

  Future<CheckQuoteModel> checkQuotesDetails(String pair, String side, String quantity) async {
    var bodyData = {
      'pair': pair,
      'side': side,
      'quantity': quantity
    };

    final response = await http.post(Uri.parse(crypto_baseURL + checkQuotesURL),
        body: bodyData );

    return CheckQuoteModel.fromJson(json.decode(response.body));
  }

  Future<CommonModel> logOut() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final response = await http.get(
        Uri.parse(
          crypto_baseURL + logoutUrl,
        ),
        headers: {"authorization": preferences.getString("token").toString()});
    return CommonModel.fromJson(json.decode(response.body));
  }

  Future<dynamic> getDoneOrdersDetails() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final response = await http.get(Uri.parse(crypto_baseURL_Sfox + doneOrdersURL),
      headers: {"authorization": "Bearer "+preferences.getString("sfox").toString()},
        );

    return json.decode(response.body);
  }

  Future<CommonModel> cancelOrdersDetails() async {
    final response = await http.delete(Uri.parse(crypto_baseURL_Sfox + cancelOrdersURL),
    );

    return CommonModel.fromJson(json.decode(response.body));
  }

  Future<CommonModel> getOpenOrdersDetails() async {
    final response = await http.get(Uri.parse(crypto_baseURL_Sfox + getOpenOrdersURL),
    );

    return CommonModel.fromJson(json.decode(response.body));
  }

  Future<CountryCodeModelDetails> countryCodeDetils() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final response = await http.get(
        Uri.parse(
          crypto_baseURL + countryCodesUrl,
        ),
        // headers: {"authorization": preferences.getString("token").toString()}
    );

    return CountryCodeModelDetails.fromJson(json.decode(response.body));
  }








  Future<WalletListModel> getWalletList() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final response = await http.get(
        Uri.parse(
          baseURL + walletListURL,
        ),
        headers: {"authorization": preferences.getString("token").toString()});
    return WalletListModel.fromJson(json.decode(response.body));
  }

  Future<WalletBalanceModel> getBalance(String id) async {
    print("ID" + id);
    SharedPreferences preferences = await SharedPreferences.getInstance();
    /* var balData = {
     'id': id,
   };*/
    // final uri = Uri.http("43.205.149.22",walletListURL, balData);
    // print("Uri"+uri.toString());
    final response = await http.get(
        Uri.parse(
          baseURL + walletListURL + "?id=" + id,
        ),
        headers: {"authorization": preferences.getString("token").toString()});
    return WalletBalanceModel.fromJson(json.decode(response.body));
  }

  Future<CommonModel> getUpdatePassword(
      String password, String otp, bool isMail, String token) async {
    var emailbodyData = {
      'password': password,
      'verificationCode': otp,
      "type": "validate",
    };
    var mobilebodyData = {
      'password': password,
      'verificationCode': otp,
      "type": "validate",
    };

    final response = await http.post(Uri.parse(baseURL + forgotMobURL),
        headers: {
          "authorization": token,
        },
        body: isMail ? emailbodyData : mobilebodyData);

    return CommonModel.fromJson(json.decode(response.body));
  }

  Future<TradePairListModel> getTradePair() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final response = await http.get(Uri.parse(crypto_baseURL + tradePairURL),
        headers: {"authorization": preferences.getString("token").toString()});

    return TradePairListModel.fromJson(json.decode(response.body));
  }
  Future<CoinListModel> getCoinList() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final response = await http.post(Uri.parse(crypto_baseURL + tradePairURL),
        headers: {"authorization": "Bearer "+preferences.getString("token").toString()});


    return CoinListModel.fromJson(json.decode(response.body));
  }


  Future<TradepairDetailsModel> getTradePairDetails(String id) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final response = await http.get(
        Uri.parse(baseURL + tradePairURL + "?trade_id=" + id),
        headers: {"authorization": preferences.getString("token").toString()});
    return TradepairDetailsModel.fromJson(json.decode(response.body));
  }

  Future<CommonModel> limitOrderExchange(String coinone, String cointwo,
      String price, String quantity, String type) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var tradeBody = {
      'coinone': coinone,
      'cointwo': cointwo,
      'price': price,
      'quantity': quantity,
      'type': type,
    };
    String url = type.toLowerCase() == "buy" ? limitBuyUrl : limitSellUrl;

    final response = await http.post(Uri.parse(baseURL + url),
        body: tradeBody,
        headers: {"authorization": preferences.getString("token").toString()});

    return CommonModel.fromJson(json.decode(response.body));
  }


  socketChatConnection(cb) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String auth = preferences.getString("token").toString();

    socketChat = io(
        baseURL,
        OptionBuilder()
            .setTransports(['websocket'])
            .disableForceNew() // for Flutter or Dart VM
            .setExtraHeaders({'authorization': auth}) // optional
            .build());

    socketChat!.onConnect((data) {
      cb();
      return;
    });
    socketChat!.onConnectError((data) => print(data));
    if (socketChat!.connected) {
      cb();
      return;
    }
  }

  Future<UserDetailsModel> getUserDetails() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    final response = await http.get(Uri.parse(baseURL + userDetailsUrl),
        headers: {"authorization": preferences.getString("token").toString()});

    return UserDetailsModel.fromJson(json.decode(response.body));
  }


  Future<BannerImageListModel> getBannerList() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    final response = await http.get(Uri.parse(baseURL + bannerListUrl),
        headers: {"authorization": preferences.getString("token").toString()});

    return BannerImageListModel.fromJson(json.decode(response.body));
  }




  Future<CommonModel> updateKycDetails( String fname,
      String lastname,
      String counrtycode,
      String mobile,
      String dob,
      String gender,
      String country,
      String city,
      String states,
      String zip,
      String address,
      String addressline,
      String idproof,
      String idnumber,
      String expdate,
      String aadharImg,
      String panImg) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    var request =
    http.MultipartRequest("POST", Uri.parse(crypto_baseURL + KycVerifyUrl));
    request.headers['authorization'] = "Bearer "+ preferences.getString("token").toString();
    request.headers['Accept'] = 'application/json';

    var pic = await http.MultipartFile.fromPath("front_upload_id", aadharImg);
    var pic1 = await http.MultipartFile.fromPath("back_upload_id", panImg);
    request.files.add(pic);
    request.files.add(pic1);

    request.fields['first_name'] =fname;
    request.fields['last_name'] =lastname;

    request.fields['phone_code'] =counrtycode;
    request.fields['phone_no'] =mobile;
    request.fields['dob'] =dob;
    request.fields['gender_type'] =gender;
    request.fields['country'] =country;
    request.fields['city'] =city;
    request.fields['state'] =states;
    request.fields['zip_code'] =zip;
    request.fields['address'] =address;
    request.fields['addressline'] =addressline;
    request.fields['id_type'] =idproof;
    request.fields['id_number'] =idnumber;
    request.fields['address_line1'] =address;
    request.fields['address_line2'] =addressline;
    request.fields['id_exp'] =expdate;

    http.Response response =
    await http.Response.fromStream(await request.send());

    return CommonModel.fromJson(json.decode(response.body.toString()));
  }

  Future<CommonModel> emailSendOTP(String email) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var tradeBody = {
      'type': email,
    };

    final response = await http.post(Uri.parse(crypto_baseURL + emailSendOTPUrl),
        body: tradeBody,
        headers: {"authorization": preferences.getString("token").toString()});

    return CommonModel.fromJson(json.decode(response.body));
  }


  Future<CommonModel> changePasswordRequest(
    String oldPass,
    String newPass,
  ) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    var bodyData = {
      'oldPassword': oldPass,
      'password': newPass,
    };
    final response = await http.post(Uri.parse(baseURL + changePassUrl),
        body: bodyData,
        headers: {"authorization": preferences.getString("token").toString()});

    return CommonModel.fromJson(json.decode(response.body));
  }



  Future<CommonModel> placeTradeOrder(
      String id, String price, String quantity, String type, bool check) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    var limitData = {
      'trade_id': id,
      "quantity": quantity,
      "price": price,
      'type': type,
    };

    var marketData = {
      'trade_id': id,
      "quantity": quantity,
      'type': type,
    };

    final response = await http.post(Uri.parse(baseURL + placeOrderUrl),
        body: check ? limitData : marketData,
        headers: {"authorization": preferences.getString("token").toString()});

    return CommonModel.fromJson(json.decode(response.body));
  }

  Future<CommonModel> updateEmailDetails(
      String email, String code) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    var emailData = {
      'type': email,
      "OTP": code,
    };

    final response = await http.post(Uri.parse(crypto_baseURL + verifyOTPUrl),
        body: emailData,
        headers: {"authorization": preferences.getString("token").toString()});

    return CommonModel.fromJson(json.decode(response.body));
  }

  Future<CommonModel> verifyGoogleTFA(String data) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    var verifyData = {
      "verify_code": data,
    };

    final response = await http.post(Uri.parse(baseURL + verifyTFAUrl),
        body: verifyData,
        headers: {"authorization": preferences.getString("token").toString()});


    return CommonModel.fromJson(json.decode(response.body));
  }


  Future<DepositHistoryModel> getDepositHistory() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final response = await http.get(
        Uri.parse(
          baseURL + depositHistoryUrl,
        ),
        headers: {"authorization": preferences.getString("token").toString()});

    return DepositHistoryModel.fromJson(json.decode(response.body));
  }

  Future<dynamic> getChartData(String id, String period) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var bodyData = {
      "symbol_id": id,
      "period": period,
    };
    final response = await http.post(
        Uri.parse(
          baseURL + chartDataUrl + "?mobile=true",
        ),
        body: bodyData,
        headers: {"authorization": preferences.getString("token").toString()});

    return response.body;
  }

  storeData(String token, String userID) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString("token", token);
    preferences.setString("exp", userID);
  }

  Future<CommonModel> addToFav(String trade_id, String type) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    var verifyData = {"pair_symbol": trade_id, "type": type};

    print(verifyData);
    final response = await http.post(Uri.parse(baseURL + addFavUrl),
        body: verifyData,
        headers: {"authorization": preferences.getString("token").toString()});


    return CommonModel.fromJson(json.decode(response.body));
  }

  Future<TermsConditionModel> getTerms() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final response = await http.get(
        Uri.parse(
          baseURL + termsConditionUrl,
        ),
        headers: {"authorization": preferences.getString("token").toString()});

    return TermsConditionModel.fromJson(json.decode(response.body));
  }

  Future<WalletBalModel> getWalletBalance() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final response = await http.get(
        Uri.parse(
          baseURL + walletBalanceUrl,
        ),
        headers: {"authorization": preferences.getString("token").toString()});

    return WalletBalModel.fromJson(json.decode(response.body));
  }



  Future<InstantValueModel> doInstantCalc(
    String trade_id,
    String quantity,
    String type,
  ) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    var instantData = {
      "trade_id": trade_id,
      "quantity": quantity,
      "type": type,
    };

    final response = await http.post(
        Uri.parse(
          baseURL + instantValueUrl,
        ),
        body: instantData,
        headers: {"authorization": preferences.getString("token").toString()});
    return InstantValueModel.fromJson(json.decode(response.body));
  }

  Future<InstantTradeModel> doInstantTrade(
    String trade_id,
    String quantity,
    String type,
  ) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    var instantData = {
      "trade_id": trade_id,
      "quantity": quantity,
      "type": type,
    };

    final response = await http.post(
        Uri.parse(
          baseURL + instantTrade,
        ),
        body: instantData,
        headers: {"authorization": preferences.getString("token").toString()});
    print("InstantCalc" + response.body);
    return InstantTradeModel.fromJson(json.decode(response.body));
  }

  Future<CommonModel> doLimitOrder(
      String pair,
    String side,
    String type,
    String quantity,

    String price,
      String quote_id,
      bool spotStop

  ) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var spotStopData = {
      "pair": pair,
      "side": side,
      "type": type,
      "quantity": quantity,
      "price": price,

    };
    var tradeData = {
      "pair": pair,
      "side": side,
      "type": type,
      "quantity": quantity,
      "price": price,
      "quote_id": quote_id,
    };

    final response = await http.post(
        Uri.parse(
          baseURL + stopLimitUrl,
        ),
        body: spotStop ? spotStopData : tradeData,
        headers: {"authorization": preferences.getString("token").toString()});
    return CommonModel.fromJson(json.decode(response.body));
  }

  Future<OrderBookModel> getOrderBook(String symbol) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    final response = await http.get(
        Uri.parse(
          baseURL + getOrderBookUrl + "?type=trade&symbol=" + symbol,
        ),
        headers: {"authorization": preferences.getString("token").toString()});
    return OrderBookModel.fromJson(json.decode(response.body));
  }







}
