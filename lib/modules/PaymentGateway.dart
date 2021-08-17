//This file is for payment gateways. Payment gateway through razor pay is implemented.

import 'dart:convert';
import 'dart:isolate';

import 'package:elearning/MyStore.dart';
import 'package:elearning/constants.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:velocity_x/velocity_x.dart';

class PaymentGateway {
  Razorpay _razorPay = Razorpay();
  MyStore store = VxState.store;
  late String finalAmount;

  PaymentGateway() {
    //Event listeners for razor pay.
    _razorPay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _onPaymentSuccess);
    _razorPay.on(Razorpay.EVENT_PAYMENT_ERROR, _onPaymentError);
    _razorPay.on(Razorpay.EVENT_EXTERNAL_WALLET, _onExternalWallet);
  }

  Future<void> getRazorPayAPIKeys() async {
    await http.post(Uri.parse(getPaymentDetail_URL), body: {
      'user_id': store.studentID,
      'user_hash': store.studentHash,
      'app_id': appID,
      'app_hash': app_hash,
    }).then((value) async {
      print('Printing API Keys:');
      print('${value.body}');
      dynamic recievedData = await compute(jsonDecode, value.body);
      print('Printing API Keys:');
      if (recievedData['flag'] != 1)
        print(recievedData);
      else
        print(recievedData);
    });
  }

  Future<void> openCheckout(double amount) async {
    getRazorPayAPIKeys();
    // this.finalAmount = amount.toString();
    // int finalAmount = (amount * 100).toInt();
    //
    // var options = {
    //   'key': "razorPay_testKey",
    //   'amount': finalAmount,
    //   'name': 'ELearning',
    //   'description': '',
    //   'prefill': {
    //     'contact': '${store.studentData.userContactNo}',
    //     'email': '${store.studentData.userEmail}'
    //   },
    //   'external': {
    //     'wallets': ['paytm']
    //   }
    // };
    //
    // try {
    //   _razorPay.open(options);
    // } catch (e) {
    //   print('Error: $e');
    // }
  }

  Future<void> submitPaymentResponse(String paymentId) async {
    await http.post(Uri.parse(submitPayment_URL), body: {
      'user_id': store.studentID,
      'user_hash': store.studentHash,
      'app_id': appID,
      'app_hash': app_hash,
      'payment_id': paymentId,
      'amount': this.finalAmount,
    }).then((value) {
      print('Response after submitting payment: $value');
    });
  }

  Future<void> _onPaymentSuccess(PaymentSuccessResponse response) async {
    print('Payment Success');

    if (response.paymentId != null) {
      // print('Order Id: ' + response.orderId);
      // print('Payment Id: ' + response.paymentId);
      // print('Signature Id: ' + response.signature);
      submitPaymentResponse(response.paymentId!);
    } else {
      submitPaymentResponse('Test Payment');
    }
  }

  void _onPaymentError(PaymentFailureResponse response) {
    print('Payment Failed');
    print('Error Code Id: ' + response.code!.toString());
    print('Error Message Id: ' + response.message!.toString());
  }

  void _onExternalWallet(ExternalWalletResponse response) {
    print('Payment External Wallet');
    print('Error Code Id: ' + response.walletName!);
  }
}
