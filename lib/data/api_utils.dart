import 'dart:convert';
import 'package:h2_crypto/data/crypt_model/coin_list.dart';
import 'package:h2_crypto/data/crypt_model/asset_details_model.dart';
import 'package:h2_crypto/data/crypt_model/assets_list_model.dart';
import 'package:h2_crypto/data/crypt_model/check_quote_model.dart';
import 'package:h2_crypto/data/crypt_model/country_code.dart';
import 'package:h2_crypto/data/crypt_model/history_model.dart';
import 'package:h2_crypto/data/crypt_model/individual_user_details.dart';
import 'package:h2_crypto/data/crypt_model/login_model.dart';
import 'package:h2_crypto/data/crypt_model/quote_details_model.dart';
import 'package:h2_crypto/data/crypt_model/user_details_model.dart';
import 'package:h2_crypto/data/crypt_model/user_wallet_balance_model.dart';
import 'package:http/http.dart' as http;

import 'package:h2_crypto/data/crypt_model/common_model.dart';
import 'package:h2_crypto/data/crypt_model/trade_pair_list_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart';

class APIUtils {
  /*static const baseURL = 'http://43.205.10.212';*/
  /* static const baseURL = 'http://43.205.149.22';*/

  static const crypto_baseURL = 'http://h2crypto.exchange/';
  static const crypto_baseURL_Sfox = 'https://api.sfox.com/';

  Socket? socketChat;
  static const String regURL = 'api/register';

  static const String loginURL = 'api/login';

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
  static const String stopLimitUrl = 'api/post-trade';
  static const String userInfoUrl = 'api/userdetails';
  static const String depositInfoUrl = 'v1/user/deposit/address/';
  static const String getQuoteInfoUrl = 'api/check-quote';
  static const String cancelTradeUrl = 'api/cancel-trade';
  static const String tranHisUrl = 'api/transaction-histroy';
  static const String fiatDepUrl = 'v1/user/wire-instructions';

  Future<CommonModel> doVerifyRegister(
      String first_name,
      String last_name,
      String email,
      String device,
      String location,
      String password,
      String con_password) async {
    var emailbodyData = {
      'first_name': first_name,
      'last_name': last_name,
      'email': email,
      'device': device,
      'location': "location",
      'password': password,
      'passwordconfirmation': con_password,
    };

    final response = await http.post(Uri.parse(crypto_baseURL + regURL),
        body: emailbodyData);

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
    final response = await http.post(Uri.parse(crypto_baseURL + loginURL),
        body: emailbodyData);

    return LoginDetailsModel.fromJson(json.decode(response.body));
  }

  Future<CommonModel> forgotPassword(String email) async {
    var emailbodyData = {
      'email': email,
    };

    final response = await http.post(
        Uri.parse(crypto_baseURL + forgotPasswordURL),
        body: emailbodyData);

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

    final response = await http.post(
        Uri.parse(crypto_baseURL + forgotPasswordVerifyURL),
        body: emailbodyData);

    return CommonModel.fromJson(json.decode(response.body));
  }

  Future<CommonModel> postTrade(String pair, String side, String password,
      String type, String quantity, String price, String quote_id) async {
    var emailbodyData = {
      'pair': pair,
      "side": side,
      "type": type,
      "quantity": quantity,
      "price": price,
      "quote_id": quote_id
    };

    final response = await http.post(Uri.parse(crypto_baseURL + postTradeURL),
        body: emailbodyData);

    return CommonModel.fromJson(json.decode(response.body));
  }

  Future<IndividualUserDetailsModel> userDetailsInfo() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final response = await http.post(Uri.parse(crypto_baseURL + userDetailsURL),
        headers: {
          "authorization": "Bearer " + preferences.getString("token").toString()
        });

    return IndividualUserDetailsModel.fromJson(json.decode(response.body));
  }

  Future<AssetsListModel> assetsListInfo() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final response = await http.post(Uri.parse(crypto_baseURL + assetsListURL),
        headers: {
          "authorization": "Bearer " + preferences.getString("token").toString()
        });

    return AssetsListModel.fromJson(json.decode(response.body));
  }

  Future<UserWalletBalanceModel> walletBalanceInfo() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final response = await http
        .post(Uri.parse(crypto_baseURL + userWalletBalanceURL), headers: {
      "authorization": "Bearer " + preferences.getString("token").toString()
    });

    return UserWalletBalanceModel.fromJson(json.decode(response.body));
  }

  Future<AssetDetailsModel> assetDetails(String assetname) async {
    var bodyData = {'asset': assetname};

    final response = await http
        .post(Uri.parse(crypto_baseURL + assetDetailsURL), body: bodyData);

    return AssetDetailsModel.fromJson(json.decode(response.body));
  }

  Future<CommonModel> withdrawAssetDetails(
      String assetname, String address, String amount) async {
    var bodyData = {'asset': assetname, 'address': address, 'amount': amount};

    final response = await http
        .post(Uri.parse(crypto_baseURL + withdrawAssetURL), body: bodyData);

    return CommonModel.fromJson(json.decode(response.body));
  }

  Future<CheckQuoteModel> checkQuotesDetails(
      String pair, String side, String quantity) async {
    var bodyData = {'pair': pair, 'side': side, 'quantity': quantity};

    final response = await http.post(Uri.parse(crypto_baseURL + checkQuotesURL),
        body: bodyData);

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
    final response = await http.get(
      Uri.parse(crypto_baseURL_Sfox + doneOrdersURL),
      headers: {
        "authorization": "Bearer " + preferences.getString("sfox").toString()
      },
    );

    return json.decode(response.body);
  }

  Future<CommonModel> cancelOrdersDetails() async {
    final response = await http.delete(
      Uri.parse(crypto_baseURL_Sfox + cancelOrdersURL),
    );

    return CommonModel.fromJson(json.decode(response.body));
  }

  Future<CommonModel> getOpenOrdersDetails() async {
    final response = await http.get(
      Uri.parse(crypto_baseURL_Sfox + getOpenOrdersURL),
    );

    return CommonModel.fromJson(json.decode(response.body));
  }

  Future<CountryCodeModelDetails> countryCodeDetils() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final response = await http.get(
      Uri.parse(
        crypto_baseURL + countryCodesUrl,
      ),
    );

    return CountryCodeModelDetails.fromJson(json.decode(response.body));
  }

  Future<TradePairListModel> getTradePair() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final response = await http.get(Uri.parse(crypto_baseURL + tradePairURL),
        headers: {
          "authorization": "Bearer " + preferences.getString("token").toString()
        });

    return TradePairListModel.fromJson(json.decode(response.body));
  }

  Future<CoinListModel> getCoinList() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final response = await http.post(Uri.parse(crypto_baseURL + tradePairURL),
        headers: {
          "authorization": "Bearer " + preferences.getString("token").toString()
        });

    return CoinListModel.fromJson(json.decode(response.body));
  }

  Future<CommonModel> updateKycDetails(
      String fname,
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
    request.headers['authorization'] =
        "Bearer " + preferences.getString("token").toString();
    request.headers['Accept'] = 'application/json';

    var pic = await http.MultipartFile.fromPath("front_upload_id", aadharImg);
    var pic1 = await http.MultipartFile.fromPath("back_upload_id", panImg);
    request.files.add(pic);
    request.files.add(pic1);

    request.fields['first_name'] = fname;
    request.fields['last_name'] = lastname;

    request.fields['phone_code'] = counrtycode;
    request.fields['phone_no'] = mobile;
    request.fields['dob'] = dob;
    request.fields['gender_type'] = gender;
    request.fields['country'] = country;
    request.fields['city'] = city;
    request.fields['state'] = states;
    request.fields['zip_code'] = zip;
    request.fields['address'] = address;
    request.fields['addressline'] = addressline;
    request.fields['id_type'] = idproof;
    request.fields['id_number'] = idnumber;
    request.fields['address_line1'] = address;
    request.fields['address_line2'] = addressline;
    request.fields['id_exp'] = expdate;

    http.Response response =
        await http.Response.fromStream(await request.send());

    return CommonModel.fromJson(json.decode(response.body.toString()));
  }

  Future<CommonModel> emailSendOTP(String email) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var tradeBody = {
      'type': email,
    };

    final response = await http.post(
        Uri.parse(crypto_baseURL + emailSendOTPUrl),
        body: tradeBody,
        headers: {
          "authorization": "Bearer " + preferences.getString("token").toString()
        });

    return CommonModel.fromJson(json.decode(response.body));
  }

  Future<CommonModel> updateEmailDetails(String email, String code) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    var emailData = {
      'type': email,
      "OTP": code,
    };

    final response = await http.post(Uri.parse(crypto_baseURL + verifyOTPUrl),
        body: emailData,
        headers: {
          "authorization": "Bearer " + preferences.getString("token").toString()
        });

    return CommonModel.fromJson(json.decode(response.body));
  }

  Future<CommonModel> doLimitOrder(String pair, String side, String type,
      String quantity, String price, String quote_id, bool spotStop) async {
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
      "quote_id": quote_id,
    };

    final response = await http.post(
        Uri.parse(
          crypto_baseURL + stopLimitUrl,
        ),
        body: spotStop ? spotStopData : tradeData,
        headers: {
          "authorization": "Bearer " + preferences.getString("token").toString()
        });
    return CommonModel.fromJson(json.decode(response.body));
  }

  Future<UserDetailsModel> getUserDetails() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    final response = await http.post(Uri.parse(crypto_baseURL + userInfoUrl),
        headers: {
          "authorization": "Bearer " + preferences.getString("token").toString()
        });

    return UserDetailsModel.fromJson(json.decode(response.body));
  }

  Future<dynamic> getDepositDetails(String coin) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    final response = await http
        .get(Uri.parse(crypto_baseURL_Sfox + depositInfoUrl + coin), headers: {
      "authorization": "Bearer " + preferences.getString("sfox").toString()
    });

    print(response.body);
    return json.decode(response.body);
  }

  Future<QuoteDetailsModel> getQuoteDetails(
    String pair,
    String side,
    String quantity,
  ) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var spotStopData = {
      "pair": pair,
      "side": side,
      "quantity": quantity,
    };

    final response = await http.post(
        Uri.parse(
          crypto_baseURL + getQuoteInfoUrl,
        ),
        body: spotStopData,
        headers: {
          "authorization": "Bearer " + preferences.getString("token").toString()
        });
    return QuoteDetailsModel.fromJson(json.decode(response.body));
  }

  Future<CommonModel> cancelTradeOption(
    String order_id,
  ) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var spotStopData = {
      "order_id": order_id,
    };

    final response = await http.post(
        Uri.parse(
          crypto_baseURL + cancelTradeUrl,
        ),
        body: spotStopData,
        headers: {
          "authorization": "Bearer " + preferences.getString("token").toString()
        });
    return CommonModel.fromJson(json.decode(response.body));
  }

  Future<TransHistoryListModel> getTransHistory() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    final response = await http.post(
        Uri.parse(
          crypto_baseURL + tranHisUrl,
        ),
        headers: {
          "authorization": "Bearer " + preferences.getString("token").toString()
        });
    return TransHistoryListModel.fromJson(json.decode(response.body));
  }

  Future<dynamic> getFiatDepositDetails() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    final response = await http
        .get(Uri.parse(crypto_baseURL_Sfox + fiatDepUrl), headers: {
      "authorization": "Bearer " + preferences.getString("sfox").toString()
    });

    return json.decode(response.body);
  }
}
