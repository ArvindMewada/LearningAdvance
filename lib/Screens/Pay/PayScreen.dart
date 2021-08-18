import 'dart:convert';

import 'package:elearning/MyStore.dart';
import 'package:elearning/components/rounded_input_field.dart';
import 'package:elearning/constants.dart';
import 'package:elearning/schemas/paymentHistorySchema.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:velocity_x/velocity_x.dart';

class PayScreen extends StatefulWidget {
  const PayScreen({Key? key}) : super(key: key);

  @override
  _PayScreenState createState() => _PayScreenState();
}

class _PayScreenState extends State<PayScreen> {
  late TextEditingController _controller;
  MyStore store = VxState.store;
  late String finalAmount;
  late Razorpay _razorPay;
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    _razorPay = Razorpay();
    _razorPay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _onPaymentSuccess);
    _razorPay.on(Razorpay.EVENT_PAYMENT_ERROR, _onPaymentError);
    _razorPay.on(Razorpay.EVENT_EXTERNAL_WALLET, _onExternalWallet);
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    _razorPay.clear();
    _controller.dispose();
  }

  Future<void> getRazorPayAPIKeys(double amount) async {
    await http.post(Uri.parse(getPaymentDetail_URL), body: {
      'user_id': store.studentID,
      'user_hash': store.studentHash,
      'app_id': appID,
      'app_hash': app_hash,
    }).then((value) async {
      // print('Printing API Keys:');
      print('${value.body}');
      dynamic recievedData = await compute(jsonDecode, value.body);
      print('Printing API Keys:');
      if (recievedData['status'] == "success") {
        String paymentGatewayAccessKey =
            recievedData["payment"]["payment_gateway_access_key"];
        checkOUtCheck(amount, paymentGatewayAccessKey);
      }
    });
  }

  void checkOUtCheck(double amount, String paymentGatewayAccessKey) {
    this.finalAmount = amount.toString();
    int finalAmount = (amount * 100).toInt();
    if (paymentGatewayAccessKey.isNotEmpty &&
        paymentGatewayAccessKey.length > 0) {
      setState(() {
        isLoading = true;
      });
      var options = {
        'key': paymentGatewayAccessKey,
        'amount': finalAmount,
        'name': 'ELearning',
        'description': '',
        'prefill': {
          'contact': '${store.studentData.userContactNo}',
          'email': '${store.studentData.userEmail}'
        },
        'external': {
          'wallets': ['paytm']
        }
      };
      try {
        _razorPay.open(options);
      } catch (e) {
        print('Error: $e');
      }
    } else {
      Fluttertoast.showToast(msg: "Try Again  Payment ID Black !");
    }
  }

  Future<void> openCheckout(double amount) async {
    getRazorPayAPIKeys(amount);
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
      // print('@@@@@@@Payment Id: ' + response.paymentId.toString());
      // print('Signature Id: ' + response.signature);
      submitPaymentResponse(response.paymentId!);
      setState(() {
        _controller.text = "";
        getPaymentHistory();
        setState(() {
          isLoading = false;
        });
      });
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

  Future<PaymentHistory> getPaymentHistory() async {
    late PaymentHistory data;
    await http.post(Uri.parse(getPaymentHistory_URL), body: {
      'user_id': store.studentID,
      'user_hash': store.studentHash,
      'app_id': appID,
      'app_hash': app_hash,
    }).then((value) async {
      dynamic recievedData = await compute(jsonDecode, value.body);
      if (recievedData['flag'] == 1) {
        data = PaymentHistory.fromJson(recievedData);
      }
    });
    return data;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pay'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: RoundedInputField(
                      icon: Icons.payment,
                      color: Colors.grey.shade200,
                      keyboardType: TextInputType.number,
                      hintText: 'Amount',
                      controller: _controller),
                ),
                SizedBox(
                  width: 10,
                ),
                TextButton(
                  style: TextButton.styleFrom(
                      padding: EdgeInsets.all(20),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      backgroundColor: kPrimaryColor,
                      primary: Colors.white),
                  onPressed: () {
                    if (_controller.text.length == 0) {
                      print('Enter amount greater than 0.');
                      Fluttertoast.showToast(msg: "Please enter amount");
                    } else {
                      double amount = double.parse(_controller.text);
                      if (amount <= 0) {
                        print('Enter amount greater than 0.');
                        Fluttertoast.showToast(msg: "Please enter amount");
                      } else {
                        openCheckout(amount);
                      }
                    }
                  },
                  child: Text('Pay'),
                )
              ],
            ),
          ),
          Expanded(
            child: isLoading ? Center(child: CircularProgressIndicator()) : FutureBuilder(
                future: getPaymentHistory(),
                builder: (context, AsyncSnapshot<PaymentHistory> snapshot) {
                  if (snapshot.hasData) if (snapshot
                      .data!.response!.isEmpty)
                    return Center(child: Text('No Payment History'));
                  else
                    return ListView.builder(
                        itemCount: snapshot.data!.response!.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: Text('₹ ' +
                                snapshot.data!.response![index].amount!),
                            subtitle: Text(snapshot
                                .data!.response![index].createdOn!
                                .substring(0, 16)),
                          );
                        });
                  return Center(child: CircularProgressIndicator());
                }),
          )
        ],
      ),
    );
  }
}
