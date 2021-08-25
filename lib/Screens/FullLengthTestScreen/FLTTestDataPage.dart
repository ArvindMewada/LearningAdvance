import 'dart:convert';

import 'package:elearning/MyStore.dart';
import 'package:elearning/Screens/FullLengthTestScreen/FLTTestInstructionPage.dart';
import 'package:elearning/constants.dart';
import 'package:elearning/schemas/fltTestDataSchema.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:velocity_x/velocity_x.dart';

// ignore_for_file: non_constant_identifier_names
class FLTTestDataPage extends StatefulWidget {
  final String title;
  final bool isHindi;
  final int exam_id;
  final int exam_id_2;

  const FLTTestDataPage(
      {Key? key,
      required this.isHindi,
      required this.title,
      required this.exam_id,
      required this.exam_id_2})
      : super(key: key);

  @override
  _FLTTestDataPageState createState() => _FLTTestDataPageState();
}

class _FLTTestDataPageState extends State<FLTTestDataPage> {
  Future<FLTTestData> getTestData() async {
    late FLTTestData data;
    MyStore store = VxState.store;
    await http.post(Uri.parse(getFLTTestData_URL), body: {
      'user_id': store.studentID,
      'user_hash': store.studentHash,
      'sub_category': '',
      'exam_id': '${widget.exam_id}',
      'exam_id_2': '${widget.exam_id_2}',
      'app_id': appID,
    }).then((value) async {
      dynamic recievedData = await compute(jsonDecode, value.body);
      print(recievedData);
      data = FLTTestData.fromJson(recievedData);
    });
    return data;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: FutureBuilder(
        future: getTestData(),
        builder: (context, AsyncSnapshot<FLTTestData> snapshot) {
          if (snapshot.hasData) if (snapshot.data!.testData!.length != 0)
            return ListView.builder(
                itemCount: snapshot.data!.testData!.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Material(
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: GestureDetector(
                          onTap: () {
                            snapshot.data!.testData![index].testStatus == 3
                                ? Fluttertoast.showToast(
                                    msg:
                                        "This test is not activated. Please contact "
                                        "your institute administrator to activate this test ")
                                : null;
                          },
                          child: ListTile(
                              trailing: TextButton(
                                  style: TextButton.styleFrom(
                                      backgroundColor: snapshot
                                                  .data!
                                                  .testData![index]
                                                  .testStatus ==
                                              1
                                          ? kPrimaryColor
                                          : Colors.white,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20))),
                                  onPressed: () async {
                                    snapshot.data!.testData![index]
                                                .testStatus ==
                                            1
                                        ? await Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    FLTTestInstructionPage(
                                                        isHindi: widget.isHindi,
                                                        correctMarks: snapshot
                                                            .data!
                                                            .testData![index]
                                                            .positiveMark!,
                                                        totalQues: snapshot
                                                            .data!
                                                            .testData![index]
                                                            .totalQues!,
                                                        heading: snapshot
                                                            .data!
                                                            .testData![index]
                                                            .testName!,
                                                        reqPercentage: snapshot
                                                            .data!
                                                            .testData![index]
                                                            .testReqPer!,
                                                        incorrectMarks: snapshot
                                                            .data!
                                                            .testData![index]
                                                            .negativeMark!,
                                                        test_id: snapshot
                                                            .data!
                                                            .testData![index]
                                                            .testId!,
                                                        title: widget.title,
                                                        totalTime: snapshot
                                                            .data!
                                                            .testData![index]
                                                            .totalTime!)))
                                        : (){};
                                    if (mounted) setState(() {});
                                  },
                                  child: snapshot.data!.testData![index]
                                              .testStatus ==
                                          1
                                      ? Text(
                                          'Start',
                                          style: TextStyle(color: Colors.white),
                                        )
                                      : Text(
                                          '',
                                          style: TextStyle(color: Colors.white),
                                        )),
                              subtitle: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  snapshot.data!.testData![index].testStatus !=
                                          2
                                      ? Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            snapshot.data!.testData![index]
                                                .testDesc!,
                                          ),
                                        )
                                      : Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            "Coming soon",
                                          ),
                                        ),
                                  Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          child: Text(snapshot.data!
                                                  .testData![index].totalQues! +
                                              ' Questions'),
                                        ),
                                        SizedBox(width: 20),
                                        Expanded(
                                          child: Text(snapshot.data!
                                                  .testData![index].totalTime! +
                                              ' Minutes'),
                                        ),
                                      ])
                                ],
                              ),
                              title: Text(
                                snapshot.data!.testData![index].testName!,
                                style: TextStyle(
                                  color: getColorCode(snapshot
                                      .data!.testData![index].testStatus),
                                ),
                              )),
                        ),
                      ),
                    ),
                  );
                });
          else
            return Center(child: Text('Nothing to show here.'));
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  getColorCode(dynamic index) {
    switch (index) {
      case 1:
        return Colors.blue;
      case 2:
        return Colors.blueGrey;
      case 3:
        return Colors.grey;
      default:
    }
  }
}
