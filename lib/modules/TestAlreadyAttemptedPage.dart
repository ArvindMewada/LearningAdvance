import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:elearning/MyStore.dart';
import 'package:elearning/constants.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:velocity_x/velocity_x.dart';
import 'dart:core';

// ignore_for_file: non_constant_identifier_names
class TestAlreadyAttemptedPage extends StatefulWidget {
  final String totalQues;
  final bool isQuiz;
  final String test_hash;
  final String totalMark;
  final int id;
  final String incorrectMarks;
  final String correctMarks;
  final String totalTime;
  final String heading;
  final String title;

  const TestAlreadyAttemptedPage({
    Key? key,
    required this.isQuiz,
    required this.totalTime,
    required this.id,
    required this.incorrectMarks,
    required this.correctMarks,
    required this.heading,
    required this.title,
    required this.totalQues,
    required this.test_hash,
    required this.totalMark,
  }) : super(key: key);

  @override
  _TestAlreadyAttemptedPageState createState() =>
      _TestAlreadyAttemptedPageState();
}

class _TestAlreadyAttemptedPageState extends State<TestAlreadyAttemptedPage> {
  late bool isDone;
  late List data;
  late Map<String, dynamic> overallReport;

  fetchTestResult() async {
    overallReport = {};
    MyStore store = VxState.store;
    await http.post(Uri.parse(fetchResult_URL), body: {
      'user_id': store.studentID,
      'user_hash': store.studentHash,
      'test_hash': widget.test_hash,
      'tot_ques': widget.totalQues,
      'rgcmid': '',
    }).then((value) async {
      dynamic recievedData = await compute(jsonDecode, value.body);
      overallReport.addAll({
        "percentage": double.parse(recievedData['percentage']),
        "totCorrect": recievedData['totCorrect'],
        "totIncorrect": recievedData['totIncorrect'],
        "notAttempt": recievedData['notAttempt'],
        "mark_obtain": recievedData['mark_obtain'].toDouble()
      });
      if (mounted) {
        setState(() {
          isDone = true;
        });
      }
    });
  }

  @override
  void initState() {
    isDone = false;
    fetchTestResult();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return Scaffold(
      appBar: AppBar(
        title: Text('Test Results'),
      ),
      body: isDone
          ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                CircularPercentIndicator(
                    lineWidth: 10,
                    animation: true,
                    animationDuration: 1500,
                    progressColor: kPrimaryColor,
                    center: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '${overallReport['percentage']!}%',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        Text('Total Marks:',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 15)),
                        Text(
                            '${overallReport['mark_obtain']!}/${widget.totalMark}',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 15))
                      ],
                    ),
                    percent: (overallReport['percentage']!) / 100,
                    radius: 150),
                SizedBox(height: 15),
                Text(
                  'Overall Report',
                  style: TextStyle(fontSize: 40),
                ),
                SizedBox(height: 15),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Material(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    child: Padding(
                      padding: const EdgeInsets.all(15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Text(
                                    'Total Correct',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    '${overallReport['totCorrect']}',
                                    style: TextStyle(fontSize: 30),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Text(
                                    'Total Incorrect',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    '${overallReport['totIncorrect']}',
                                    style: TextStyle(fontSize: 30),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Text(
                                    'Not Attempted',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    '${overallReport['notAttempt']}',
                                    style: TextStyle(fontSize: 30),
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            )
          : Center(child: CircularProgressIndicator()),
    );
  }
}
