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
  static const String stopLimitUrl = '/api/v1/trade/placeorderdetails';
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

    print(response.body);
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

    print(response.body);
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

  Future<CountryCodeModelDetails> countryCodeDetils() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final response = await http.get(
        Uri.parse(
          crypto_baseURL + countryCodesUrl,
        ),
        // headers: {"authorization": preferences.getString("token").toString()}
    );
    print(response.body);
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

    print(response.body);
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

  Future<CoinBalanceModel> getCoinBalance(String coinone) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var tradeBody = {
      'source': coinone,
    };

    final response = await http.post(Uri.parse(baseURL + getBalUrl),
        body: tradeBody,
        headers: {"authorization": preferences.getString("token").toString()});

    return CoinBalanceModel.fromJson(json.decode(response.body));
  }

  Future<RefreshTokenModel> getRefreshToken(dynamic function) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    var tradeBody = {
      'token': preferences.getString("refresh").toString(),
    };

    final response = await http.post(
      Uri.parse(baseURL + refreshTokenUrl),
      body: tradeBody,
    );
    if (response.statusCode == 200) {
      RefreshTokenModel loginData =
          RefreshTokenModel.fromJson(json.decode(response.body));
      storeData(loginData.data!.accessToken!.token.toString(),
          loginData.data!.accessToken!.exp.toString());

      function();
    }

    return RefreshTokenModel.fromJson(json.decode(response.body));
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

  Future<DepositDetailsModel> getDepositDetails(String idValue) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final response = await http.get(
        Uri.parse(baseURL + walletListURL + "?id=" + idValue),
        headers: {"authorization": preferences.getString("token").toString()});
    return DepositDetailsModel.fromJson(json.decode(response.body));
  }

  Future<BannerImageListModel> getBannerList() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    final response = await http.get(Uri.parse(baseURL + bannerListUrl),
        headers: {"authorization": preferences.getString("token").toString()});

    return BannerImageListModel.fromJson(json.decode(response.body));
  }

  Future<GoogletfaModel> getGoogleTFADetails() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    final response = await http.post(Uri.parse(baseURL + gtfaUrl),
        headers: {"authorization": preferences.getString("token").toString()});

    return GoogletfaModel.fromJson(json.decode(response.body));
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
    print("Upload"+response.body);
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

  Future<GoogleEnabletfaModel> enableGoogleTFA(
      String token, bool status) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var bodyData = {
      'f2a_type': "0",
      'token': token,
    };

    var bodyaEnableData = {
      'token': token,
      "revoke": "true",
      'f2a_type': "0",
    };

    final response = await http.post(Uri.parse(baseURL + tfaEnableUrl),
        body: status ? bodyaEnableData : bodyData,
        headers: {"authorization": preferences.getString("token").toString()});

    return GoogleEnabletfaModel.fromJson(json.decode(response.body));
  }

  Future<OpenOrderListModel> openOrderList(String id) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    final response = await http.post(
        Uri.parse(baseURL + openOrderUrl + "?id=$id"),
        headers: {"authorization": preferences.getString("token").toString()});
    return OpenOrderListModel.fromJson(json.decode(response.body));
  }

  Future<OpenOrderListModel> AllopenOrderList(bool open) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String url =
        open ? baseURL + openOrderUrl + "?all=true" : baseURL + openOrderUrl;
    final response = await http.post(Uri.parse(url),
        headers: {"authorization": preferences.getString("token").toString()});
    return OpenOrderListModel.fromJson(json.decode(response.body));
  }

  Future<AllOpenOrderModel> AllopenOrderHistory(String mode) async {
    var bodyData = {
      'mode': mode,
    };
    SharedPreferences preferences = await SharedPreferences.getInstance();

    String url = baseURL + openOrderUrl + "?all=true";
    final response = await http.post(Uri.parse(url),
        body: bodyData,
        headers: {"authorization": preferences.getString("token").toString()});
    print(response.body);
    return AllOpenOrderModel.fromJson(json.decode(response.body));
  }

  Future<PositionOrderModel> FuturePositionList() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    String url = baseURL + openOrderUrl + "?future=true";
    final response = await http.post(Uri.parse(url),
        headers: {"authorization": preferences.getString("token").toString()});
    return PositionOrderModel.fromJson(json.decode(response.body));
  }

  Future<FutureOpenOrderModel> FutureOpenOrderList() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    String url = baseURL + openOrderUrl + "?futureorder=true";
    final response = await http.post(Uri.parse(url),
        headers: {"authorization": preferences.getString("token").toString()});
    return FutureOpenOrderModel.fromJson(json.decode(response.body));
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

    print(response.body);
    return CommonModel.fromJson(json.decode(response.body));
  }

  Future<CommonModel> cancelTrade(String tradeID) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    var verifyData = {
      "tradeId": tradeID,
    };

    final response = await http.post(Uri.parse(baseURL + cancelTradeUrl),
        body: verifyData,
        headers: {"authorization": preferences.getString("token").toString()});
    print(response.body);
    return CommonModel.fromJson(json.decode(response.body));
  }

  Future<CommonModel> updateUserName(String name) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    var verifyData = {
      "name": name,
      "updatetype": "name",
    };

    final response = await http.post(Uri.parse(baseURL + updateNameUrl),
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

    print(response.body);
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

  Future<CommonModel> checkreferID(String id) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    var verifyData = {
      "referral_id": id,
    };
    final response = await http.post(
        Uri.parse(
          baseURL + checkreferUrl,
        ),
        body: verifyData,
        headers: {"authorization": preferences.getString("token").toString()});

    return CommonModel.fromJson(json.decode(response.body));
  }

  Future<MarginTradeModel> doMarginPostTrade(
    bool spotTrade,
    String trade_id,
    String quantity,
    String price,
    String type,
    bool check,
    String tradeMode,
    String leverage,
  ) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    var tradeData = {
      "trade_id": trade_id,
      "quantity": quantity,
      "price": price,
      "type": type,
      "trade_mode": tradeMode,
      "leverage": leverage
    };

    var spotTradeData = {
      "trade_id": trade_id,
      "quantity": quantity,
      "price": price,
      "type": type,
      "trade_mode": tradeMode,
    };

    var marketData = {
      'trade_id': trade_id,
      "quantity": quantity,
      'type': type,
      "trade_mode": tradeMode,
      "leverage": leverage,
    };

    var spotMarketData = {
      'trade_id': trade_id,
      "quantity": quantity,
      'type': type,
      "trade_mode": tradeMode,
    };
    print(check
        ? spotTrade
            ? spotTradeData
            : tradeData
        : spotTrade
            ? spotMarketData
            : marketData);
    final response = await http.post(
        Uri.parse(
          baseURL + marginTradeUrl,
        ),
        body: check
            ? spotTrade
                ? spotTradeData
                : tradeData
            : spotTrade
                ? spotMarketData
                : marketData,
        headers: {"authorization": preferences.getString("token").toString()});
    print("Margin" + response.body);
    return MarginTradeModel.fromJson(json.decode(response.body));
  }

  Future<LoanModel> doMarginLoan(
      String wallet_id, String leverage, String loan_mode) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    var loanData = {
      "wallet_id": wallet_id,
      "leverage": leverage,
      "loan_mode": loan_mode,
    };
    print(loanData);
    final response = await http.post(
        Uri.parse(
          baseURL + marginLoanUrl,
        ),
        body: loanData,
        headers: {"authorization": preferences.getString("token").toString()});
    print(response.body);
    return LoanModel.fromJson(json.decode(response.body));
  }

  Future<RepayLoanModel> doMarginRepayLoan(
    String wallet_id,
    String loan_history_id,
    String loan_mode,
  ) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    var loanData = {
      "wallet_id": wallet_id,
      "loan_history_id": loan_history_id,
      "loan_mode": loan_mode,
    };
    print(loanData);

    final response = await http.post(
        Uri.parse(
          baseURL + marginRepayLoanUrl,
        ),
        body: loanData,
        headers: {"authorization": preferences.getString("token").toString()});
    print(response.body);
    return RepayLoanModel.fromJson(json.decode(response.body));
  }

  Future<MarginTransferModel> doTransferMargin(
    String wallet_id,
    String margin_balance,
    String loan_mode,
  ) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    var loanData = {
      "wallet_id": wallet_id,
      "balance": margin_balance,
      "loan_mode": loan_mode,
    };
    print(loanData);
    final response = await http.post(
        Uri.parse(
          baseURL + marginToSpotTransferUrl,
        ),
        body: loanData,
        headers: {"authorization": preferences.getString("token").toString()});
    print(response.body);
    return MarginTransferModel.fromJson(json.decode(response.body));
  }

  Future<MarginTransferModel> doTransferSpot(
    String wallet_id,
    String balance,
    String loan_mode,
  ) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    var loanData = {
      "wallet_id": wallet_id,
      "balance": balance,
      "loan_mode": loan_mode,
    };

    final response = await http.post(
        Uri.parse(
          baseURL + spotToMarginTransferUrl,
        ),
        body: loanData,
        headers: {"authorization": preferences.getString("token").toString()});
    return MarginTransferModel.fromJson(json.decode(response.body));
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
    print(instantData);
    final response = await http.post(
        Uri.parse(
          baseURL + instantTrade,
        ),
        body: instantData,
        headers: {"authorization": preferences.getString("token").toString()});
    print("InstantCalc" + response.body);
    return InstantTradeModel.fromJson(json.decode(response.body));
  }

  Future<CommonModel> doStopLimit(
    bool spotStop,
    String trade_id,
    String price,
    String stop_price,
    String quantity,
    String type,
    String tradeMode,
    String leverage,
  ) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var spotStopData = {
      "trade_id": trade_id,
      "quantity": quantity,
      "price": price,
      "stop_price": stop_price,
      "type": type,
      "trade_mode": tradeMode,
    };
    var tradeData = {
      "trade_id": trade_id,
      "quantity": quantity,
      "price": price,
      "stop_price": stop_price,
      "type": type,
      "trade_mode": tradeMode,
      "leverage": leverage,
    };
    print(tradeData);
    final response = await http.post(
        Uri.parse(
          baseURL + stopLimitUrl,
        ),
        body: spotStop ? spotStopData : tradeData,
        headers: {"authorization": preferences.getString("token").toString()});
    print("StopLimit" + response.body);
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

  Future<LoanHistoryModel> getLoanHistory(
    String wallet_id,
    String loan_status,
    String loan_mode,
  ) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var loanData = {
      "wallet_id": wallet_id,
      "loan_status": loan_status,
      "loan_mode": loan_mode,
    };
    print(loanData);
    final response = await http.post(
        Uri.parse(
          baseURL + getloanHistoryUrl,
        ),
        body: loanData,
        headers: {"authorization": preferences.getString("token").toString()});
    print(response.body);
    return LoanHistoryModel.fromJson(json.decode(response.body));
  }

  Future<PostAddModel> Allpostadd(
      String userId,
      String type,
      String AssetCoin,
      String cash,
      String quantity,
      String min_limit,
      String max_limit,
      String payment_type,
      String live_price) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var loanData = {
      "userId": userId,
      "ad_type": type,
      "asset": AssetCoin,
      "cash": cash,
      "quantity": quantity,
      "min_limit": min_limit,
      "max_limit": max_limit,
      "payment_type": payment_type,
      "live_price": live_price
    };
    print(loanData);
    final response = await http.post(
        Uri.parse(
          baseURL + p2pAllPostAdd,
        ),
        body: loanData,
        headers: {"authorization": preferences.getString("token").toString()});
    print(response.body);
    return PostAddModel.fromJson(json.decode(response.body));
  }

  Future<P2PLivePriceModel> getLiveAssetValue(String AssetCoin) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var loanData = {
      "asset": AssetCoin,
    };
    final response = await http.get(
        Uri.parse(
          baseURL + p2pLiveAssetUrl + "?asset=" + AssetCoin,
        ),
        headers: {"authorization": preferences.getString("token").toString()});
    // print(response.body);
    return P2PLivePriceModel.fromJson(json.decode(response.body));
  }

  Future<CommonModel> addpay_details(
      String name,
      String upi_id,
      String acc_type,
      String acc_num,
      String ifsc,
      String bank_name,
      String branch,
      String type,
      String userId) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    var bank = {
      "userId": userId,
      "type": type,
      "Payment_name": type,
      "acc_num": acc_num,
      "name": name,
      "ifsc": ifsc,
      "bank_name": bank_name,
      "acc_type": acc_type,
      "branch": branch
    };

    var paytm = {
      "userId": userId,
      "type": type,
      "Payment_name": type,
      "upi_id": upi_id,
      "qr_code": "image"
    };

    final response = await http.post(
        Uri.parse(
          baseURL + paymentUrl,
        ),
        body: type == "bank" || type == "imps" ? bank : paytm,
        headers: {"authorization": preferences.getString("token").toString()});

    return CommonModel.fromJson(json.decode(response.body));
  }

  Future<GetPaymentDetailsModel> getpay_details(
      String userId, String payment) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    print(preferences.getString("token").toString());
    var loanData = {"userId": userId, "payment": payment};

    final response = await http.post(
        Uri.parse(
          baseURL + paymentUrl,
        ),
        body: loanData,
        headers: {"authorization": preferences.getString("token").toString()});
    /* print("Hello"+response.body);*/
    return GetPaymentDetailsModel.fromJson(json.decode(response.body));
  }

  Future<CommonModel> getdel_details(String dele, String userId) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    print(preferences.getString("token").toString());
    var loanData = {"delete": dele, "userId": userId};

    print("payment body" + loanData.toString());
    final response = await http.post(
        Uri.parse(
          baseURL + paymentUrl,
        ),
        body: loanData,
        headers: {"authorization": preferences.getString("token").toString()});
    /* print("Hello"+response.body);*/
    return CommonModel.fromJson(json.decode(response.body));
  }

  Future<GetPostAdData> getAd(String userId, String type) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var loanData = {
      "ad_type": type,
      "userId": userId,
    };
    print("Getpost" + loanData.toString());
    final response = await http.post(
        Uri.parse(
          baseURL + p2pGetAllPostAdd + "?ad_type=$type&userId=$userId",
        ),
        /*  body: loanData,*/
        headers: {"authorization": preferences.getString("token").toString()});
    /* print("Getpostdata :"+response.body);*/
    return GetPostAdData.fromJson(json.decode(response.body));
  }

  Future<MyAdsHistoryData> getMyAd(String userId) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final response = await http.get(
        Uri.parse(
          baseURL + p2pGetMyPostAdd + "?userId=$userId",
        ),
        headers: {"authorization": preferences.getString("token").toString()});
    /* print("GetMyadsData :"+response.body);*/
    return MyAdsHistoryData.fromJson(json.decode(response.body));
  }

  Future<PurchasedAdsHistoryData> getPurchaseAd(String userId) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final response = await http.get(
        Uri.parse(
          baseURL + p2pGetPurchaseAd + "?senderuserId=$userId",
        ),
        headers: {"authorization": preferences.getString("token").toString()});
    /* print("GetMyadsData :"+response.body);*/
    return PurchasedAdsHistoryData.fromJson(json.decode(response.body));
  }

  Future<UploadImageModel> uploadP2PImage2(
      String trade_id, String userId, String quantity) async {
    var loanData = {
      "trade_id": trade_id,
      "quantity": quantity,
      "userId": userId,
    };
    print("withOutImageData" + loanData.toString());
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final response = await http.post(
        Uri.parse(
          baseURL + p2pUploadImage,
        ),
        body: loanData,
        headers: {"authorization": preferences.getString("token").toString()});
    /*print("GetMyadsData :"+response.body);*/
    return UploadImageModel.fromJson(json.decode(response.body));
  }

  Future<UploadImageModel> uploadP2PImage(String trade_id, String post_id,
      String userId, String quantity, String upload_img) async {
    var loanData = {
      "trade_id": trade_id,
      "post_id": post_id,
      "quantity": quantity,
      "userId": userId,
      "upload_img": upload_img,
    };
    print(loanData);
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final response = await http.post(
        Uri.parse(
          baseURL + p2pUploadImage,
        ),
        body: loanData,
        headers: {"authorization": preferences.getString("token").toString()});
    /*print("GetMyadsData :"+response.body);*/
    return UploadImageModel.fromJson(json.decode(response.body));
  }

  Future<LoanModel> p2pNotification(String trade_id, String userId) async {
    var loanData = {
      "_id": userId,
      "trade_id": trade_id,
    };

    SharedPreferences preferences = await SharedPreferences.getInstance();
    final response = await http.post(
        Uri.parse(
          baseURL + p2pNotificationUrl,
        ),
        body: loanData,
        headers: {"authorization": preferences.getString("token").toString()});
    print("GetMyadsData :" + response.body);
    return LoanModel.fromJson(json.decode(response.body));
  }

  Future<LoanModel> p2pCancelTrade(
      String trade_id, String userId, String userId2) async {
    var loanData = {
      "_id": userId,
      "_id1": userId2,
      "trade_id": trade_id,
    };
    print(loanData);
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final response = await http.post(
        Uri.parse(
          baseURL + p2pCancelUrl,
        ),
        body: loanData,
        headers: {"authorization": preferences.getString("token").toString()});
    print("GetMyadsData :" + response.body);
    return LoanModel.fromJson(json.decode(response.body));
  }

  Future<MyAdDetailsModel> getMyAdDetails(String trade_id) async {
    var loanData = {
      "purchase_id": trade_id,
    };
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final response = await http.get(
        Uri.parse(
          baseURL + p2pGetMyPostAdDetails + "?purchase_id=" + trade_id,
        ),
        headers: {"authorization": preferences.getString("token").toString()});
    print("GetMyadsDetailsData :" + response.body);
    return MyAdDetailsModel.fromJson(json.decode(response.body));
  }

  Future<UploadImageModel> p2PRelease(String trade_id) async {
    var loanData = {
      "purchase_id": trade_id,
    };
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final response = await http.post(
        Uri.parse(
          baseURL + p2pReleaseFundUrl + "?trade_id=" + trade_id,
        ),
        headers: {"authorization": preferences.getString("token").toString()});
    print("Release Fund :" + response.body);
    return UploadImageModel.fromJson(json.decode(response.body));
  }

  Future<LoanModel> editPaymentDetails(
      String name,
      String acc_type,
      String acc_num,
      String ifsc,
      String bank_name,
      String branch,
      String upi_id,
      String Payment_name) async {
    var bank = {
      "edit": "true",
      "isstatus": "true",
      "acc_num": acc_num,
      "name": name,
      "ifsc": ifsc,
      "bank_name": bank_name,
      "acc_type": acc_type,
      "Payment_name": Payment_name,
      "branch": branch
    };

    var loanData = {
      "edit": "true",
      "isstatus": "true",
      "qr_code": "image",
      "upi_id": upi_id,
      "Payment_name": Payment_name,
    };
    print(loanData);
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final response = await http.post(
        Uri.parse(
          baseURL + paymentUrl,
        ),
        body:
            Payment_name == "bank" || Payment_name == "imps" ? bank : loanData,
        headers: {"authorization": preferences.getString("token").toString()});
    print("Edit payment :" + response.body);
    return LoanModel.fromJson(json.decode(response.body));
  }

  Future<LoanModel> deletePaymentDetails(String Payment_name) async {
    var loanData = {
      "delete": "true",
      "type": Payment_name,
    };
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final response = await http.post(
        Uri.parse(
          baseURL + paymentUrl,
        ),
        body: loanData,
        headers: {"authorization": preferences.getString("token").toString()});
    print("Release Fund :" + response.body);
    return LoanModel.fromJson(json.decode(response.body));
  }

  Future<dynamic> sendChatMessage(
      String chatid, String author, String message) async {
    var loanData = {
      "chatid": chatid,
      "author": author,
      "message": message,
    };
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final response = await http.post(
        Uri.parse(
          baseURL + sendNewMessageUrl,
        ),
        body: loanData,
        headers: {"authorization": preferences.getString("token").toString()});
    print("Release Fund :" + response.body);
    return response.body;
  }

  Future<ChatDataModel> getChatData(String chatId) async {
    var loanData = {
      "chatId": chatId,
    };
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final response = await http.post(
        Uri.parse(
          baseURL + chatHistoryUrl,
        ),
        body: loanData,
        headers: {"authorization": preferences.getString("token").toString()});
    print("Release Fund :" + response.body);
    return ChatDataModel.fromJson(json.decode(response.body));
  }

}
