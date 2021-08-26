import 'dart:convert';

import 'package:elearning/MyStore.dart';
import 'package:elearning/Screens/FullLengthTestScreen/FLTResultAnalysis.dart';
import 'package:elearning/constants.dart';
import 'package:elearning/schemas/resultSchema.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:http/http.dart' as http;

//ignore_for_file: non_constant_identifier_names

class FLTTestCompleted extends StatefulWidget {
  final String test_id;
  const FLTTestCompleted({Key? key, required this.test_id}) : super(key: key);

  @override
  _FLTTestCompletedState createState() => _FLTTestCompletedState();
}

class _FLTTestCompletedState extends State<FLTTestCompleted> {
  MyStore store = VxState.store;

  Future<ResultSchema> getResult() async {
    late ResultSchema data;
    await http.post(Uri.parse(fetchFLTResult_URL), body: {
      'user_id': store.studentID,
      'user_hash': store.studentHash,
      'test_id': widget.test_id,
    }).then((value) async {
      dynamic recievedData = await compute(jsonDecode, value.body);
      print(recievedData);
      data = ResultSchema.fromJson(recievedData);
    });
    return data;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: FutureBuilder(
        future: getResult(),
        builder: (context, AsyncSnapshot<ResultSchema> snapshot) {
          if (snapshot.hasData) {
            return SingleChildScrollView(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Image.asset('assets/completed.png'),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Congratulations!',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 30),
                          ),
                        ),
                        Text(
                          'Test Completed',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 20),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Card(
                              elevation: 10,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8.0, vertical: 20),
                                child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Expanded(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text('Correct Answers'),
                                            Text(
                                                snapshot.data!.result!
                                                    .resCorrectAns!,
                                                style: TextStyle(
                                                    fontSize: 30,
                                                    fontWeight:
                                                        FontWeight.bold))
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text('Inorrect Answers'),
                                            Text(
                                              snapshot
                                                  .data!.result!.resWrongAns!,
                                              style: TextStyle(
                                                  fontSize: 30,
                                                  fontWeight: FontWeight.bold),
                                            )
                                          ],
                                        ),
                                      )
                                    ]),
                              )),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(20),
                          child: TextButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => FLTResultAnalysis(
                                              result: snapshot.data!,
                                            )));
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 60.0, vertical: 5),
                                child: Text(
                                  'Check Analysis',
                                  style: TextStyle(fontSize: 20),
                                ),
                              ),
                              style: TextButton.styleFrom(
                                  elevation: 10,
                                  backgroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(20)))),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 60.0, vertical: 5),
                                child: Text(
                                  'Exit',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 20),
                                ),
                              ),
                              style: TextButton.styleFrom(
                                  elevation: 10,
                                  backgroundColor: kPrimaryColor,
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(20)))),
                        )
                      ],
                    )
                  ]),
            );
          }

          return Center(child: CircularProgressIndicator());
        },
      ),
    ));
  }
}
