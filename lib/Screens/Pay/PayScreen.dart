import 'dart:convert';

import 'package:elearning/MyStore.dart';
import 'package:elearning/components/rounded_input_field.dart';
import 'package:elearning/constants.dart';
import 'package:elearning/modules/PaymentGateway.dart';
import 'package:elearning/schemas/paymentHistorySchema.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:velocity_x/velocity_x.dart';

class PayScreen extends StatefulWidget {
  const PayScreen({Key? key}) : super(key: key);

  @override
  _PayScreenState createState() => _PayScreenState();
}

class _PayScreenState extends State<PayScreen> {
  late TextEditingController _controller;
  MyStore store = VxState.store;

  Future<PaymentHistory> getPaymentHistory() async {
    late PaymentHistory data;
    await http.post(Uri.parse(getPaymentHistory_URL), body: {
      'user_id': store.studentID,
      'user_hash': store.studentHash,
      'app_id': appID,
      'app_hash': app_hash,
    }).then((value) async {
      dynamic recievedData = await compute(jsonDecode, value.body);
      if (recievedData['flag'] != 1)
        data = PaymentHistory(flag: 0, status: '', response: [], msg: '');
      else
        data = PaymentHistory.fromJson(recievedData);
    });
    return data;
  }

  @override
  void initState() {
    _controller = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
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
                    } else {
                      double amount = double.parse(_controller.text);
                      if (amount <= 0) {
                        print('Enter amount greater than 0.');
                      }else {
                        PaymentGateway().openCheckout(amount);
                        getPaymentHistory().then((value) => setState(() {}));
                      }
                    }
                  },
                  child: Text('Pay'),
                )
              ],
            ),
          ),
          Expanded(
            child: FutureBuilder(
                future: getPaymentHistory(),
                builder: (context, AsyncSnapshot<PaymentHistory> snapshot) {
                  if (snapshot.hasData) if (snapshot.data!.response!.isEmpty)
                    return Center(child: Text('No Payment History'));
                  else
                    return ListView.builder(
                        itemCount: snapshot.data!.response!.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: Text(
                                '₹ ' + snapshot.data!.response![index].amount!),
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
