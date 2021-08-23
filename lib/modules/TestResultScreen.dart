import 'dart:convert';

import 'package:elearning/MyStore.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:elearning/constants.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:html/parser.dart' as htmlparser;
import 'package:http/http.dart' as http;
import 'dart:core';

import 'package:velocity_x/velocity_x.dart';

// ignore_for_file: non_constant_identifier_names
class TestResultScreen extends StatefulWidget {
  final List<String>? data;
  final List quesIDList;
  final double totalMarks;
  final bool isQuiz;
  final List<List<Color>>? colorData;

  final String positive_marks;
  final String negative_marks;
  final String test_hash;
  const TestResultScreen(
      {Key? key,
      required this.isQuiz,
      required this.totalMarks,
      required this.quesIDList,
      this.data,
      this.colorData,
      required this.test_hash,
      required this.negative_marks,
      required this.positive_marks})
      : super(key: key);

  @override
  _TestResultScreenState createState() => _TestResultScreenState();
}

class _TestResultScreenState extends State<TestResultScreen> {
  late bool isDone;
  late bool isAttempted;
  late List ques;
  late Map<String, dynamic> overallReport;
  uploadTestResult() async {
    overallReport = {};
    List responses = [];
    if (widget.isQuiz) {
      widget.colorData!.forEach((element) {
        if (element.contains(Colors.red))
          responses.add(element.indexOf(Colors.red) + 1);
        else if (element.contains(Colors.green))
          responses.add(element.indexOf(Colors.green) + 1);
        else
          responses.add(0);
      });
    } else
      widget.data!.forEach((element) {
        if ((element) == '')
          responses.add(0);
        else
          responses.add(element);
      });
    print(responses);

    List ques_stringList = [];
    for (int i = 0; i < responses.length; i++) {
      ques_stringList.add('${widget.quesIDList[i]['ques_id']}#${responses[i]}');
    }
    print(widget.test_hash);
    print(widget.positive_marks);
    print(widget.negative_marks);
    print(ques_stringList.join('|'));

    MyStore store = VxState.store;
    await http.post(Uri.parse(postTestResultDetails_URL), body: {
      'user_id': store.studentID,
      'user_hash': store.studentHash,
      'test_hash': widget.test_hash,
      'positive_mark': widget.positive_marks,
      'negative_mark': widget.negative_marks,
      'ques_string': ques_stringList.join('|'),
      'rgcmid': '',
    }).then((value) async {
      dynamic recievedData = await compute(jsonDecode, value.body);
      if (recievedData['flag'] == 1) {
        isAttempted = false;
        ques = recievedData['ques'];
        overallReport.addAll({
          "percentage": recievedData['percentage'].toDouble(),
          "totCorrect": recievedData['totCorrect'],
          "totIncorrect": recievedData['totIncorrect'],
          "notAttempt": recievedData['notAttempt'],
          "mark_obtain": recievedData['mark_obtain'].toDouble()
        });
      } else
        isAttempted = true;
      if (mounted) {
        setState(() {
          isDone = true;
        });
      }
    });
  }

  List<Padding> buildList(List ques) {
    List<Padding> data = [];
    int count = 1;
    ques.forEach((element) {
      data.add(Padding(
        padding: const EdgeInsets.all(8.0),
        child: Material(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          elevation: 5,
          child: ExpansionTile(
            iconColor: Colors.black,
            leading: Text(
              '$count.',
              style: TextStyle(fontSize: 20),
            ),
            expandedAlignment: Alignment.center,
            expandedCrossAxisAlignment: CrossAxisAlignment.center,
            textColor: Colors.black,
            childrenPadding: EdgeInsets.symmetric(horizontal: 50, vertical: 10),
            children: [
              Text(
                'Question Explaination:',
                style: TextStyle(color: Colors.black),
              ),
              element['ques_expl'].contains('<img')
                  ? Html.fromDom(
                      document: htmlparser.parse(
                        element['ques_expl'],
                      ),
                    )
                  : Text(
                      htmlparser.parse(element['ques_expl']).body!.text,
                      style: TextStyle(color: Colors.black),
                    ),
            ],
            title: element['ques_desc'].contains('<img')
                ? Html.fromDom(
                    document: htmlparser.parse(
                      element['ques_desc'],
                    ),
                  )
                : Text(htmlparser.parse(element['ques_desc']).body!.text),
            subtitle: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      ('${element['user_response']}' == '0')
                          ? Text('Your Answer: N/A')
                          : Text(
                              'Your Answer: ' + '${element['user_response']}'),
                      SizedBox(height: 5),
                      Text('Correct Answer: ' + element['correct_opt']),
                      SizedBox(height: 5)
                    ],
                  ),
                ]),
            trailing: ('${element['user_response']}' == '0')
                ? Text('N/A')
                : Icon(
                    element['ques_status'] == 'correct'
                        ? Icons.check
                        : Icons.close,
                    color: element['ques_status'] == 'correct'
                        ? Colors.green
                        : Colors.red,
                  ),
          ),
        ),
      ));
      count++;
    });
    return data;
  }

  @override
  void initState() {
    isDone = false;
    uploadTestResult();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Test Results'),
      ),
      body: isDone
          ? (isAttempted
              ? Center(child: Text('You already attempted the test'))
              : SingleChildScrollView(
                  child: Column(
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
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text('Total Marks:',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(fontSize: 15)),
                                  Text(
                                      '${overallReport['mark_obtain']!}/${widget.totalMarks}',
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
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Material(
                              elevation: 5,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)),
                              child: Padding(
                                padding: const EdgeInsets.all(15),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
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
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
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
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
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
                          SizedBox(height: 20)
                        ] +
                        buildList(ques),
                  ),
                ))
          : Center(child: CircularProgressIndicator()),
    );
  }
}
