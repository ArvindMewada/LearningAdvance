import 'dart:convert';

import 'package:elearning/MyStore.dart';
import 'package:elearning/Screens/FullLengthTestScreen/FLTTestQuizPage.dart';
import 'package:elearning/Screens/MainLayout/AlertDialog.dart';
import 'package:elearning/schemas/fltSectionDataSchema.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:elearning/constants.dart';
import 'package:velocity_x/velocity_x.dart';

// ignore_for_file: non_constant_identifier_names
class FLTTestInstructionPage extends StatefulWidget {
  final bool isHindi;
  final String totalTime;
  final String heading;
  final String reqPercentage;
  final String title;
  final String totalQues;
  final String test_id;
  final String correctMarks;
  final String incorrectMarks;
  const FLTTestInstructionPage(
      {Key? key,
      required this.isHindi,
      required this.reqPercentage,
      required this.correctMarks,
      required this.totalQues,
      required this.heading,
      required this.incorrectMarks,
      required this.test_id,
      required this.title,
      required this.totalTime})
      : super(key: key);

  @override
  _FLTTestInstructionPageState createState() => _FLTTestInstructionPageState();
}

class _FLTTestInstructionPageState extends State<FLTTestInstructionPage> {
  late List<SectionData> buttonData = [];
  Future<FLTSectionData> getFLTSectionList() async {
    late FLTSectionData data;
    MyStore store = VxState.store;
    await http.post(Uri.parse(getFLTSectionList_URL), body: {
      'user_id': store.studentID,
      'user_hash': store.studentHash,
      'test_id': widget.test_id,
    }).then((value) async {
      dynamic recievedData = await compute(jsonDecode, value.body);
      data = FLTSectionData.fromJson(recievedData);
    });
    return data;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
          child: SingleChildScrollView(
        padding: const EdgeInsets.all(8.0),
        child: Card(
          elevation: 10,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: !widget.isHindi
                ? [
                    Padding(
                      padding:
                          const EdgeInsets.only(top: 8.0, left: 8, right: 8),
                      child: ListTile(
                          title: Text(
                        widget.heading,
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 25),
                      )),
                    ),
                    ListTile(
                        title: Text(
                      'Test Instructions',
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    )),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        'General Instructions',
                        style: TextStyle(
                            fontSize: 18, color: Colors.orange.shade900),
                      ),
                    ),
                    SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Row(children: [
                        Icon(CupertinoIcons.largecircle_fill_circle),
                        Expanded(
                            child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                              'The test will have the following structure:'),
                        ))
                      ]),
                    ),
                    Center(
                      child: FittedBox(
                        child: FutureBuilder(
                            future: getFLTSectionList(),
                            builder: (context,
                                AsyncSnapshot<FLTSectionData> snapshot) {
                              if (snapshot.hasData) {
                                buttonData = snapshot.data!.sectionData!;
                                return Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 5),
                                  child: Material(
                                    elevation: 2,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5)),
                                    child: DataTable(
                                        headingRowColor:
                                            MaterialStateColor.resolveWith(
                                                (states) =>
                                                    Colors.grey.shade200),
                                        dividerThickness: 1,
                                        headingTextStyle: TextStyle(
                                            fontSize: 25, color: Colors.black),
                                        dataTextStyle: TextStyle(
                                            fontSize: 25, color: Colors.black),
                                        showBottomBorder: true,
                                        columns: [
                                          DataColumn(
                                              label: Center(
                                                  child: Text(
                                            'Name',
                                            textAlign: TextAlign.center,
                                          ))),
                                          DataColumn(
                                              label: Center(
                                                  child: Text(
                                            'Time',
                                            textAlign: TextAlign.center,
                                          ))),
                                          DataColumn(
                                              label: Center(
                                                  child: Text(
                                            'Total\nQuestions',
                                            textAlign: TextAlign.center,
                                          ))),
                                          DataColumn(
                                              label: Center(
                                                  child: Text(
                                            'Total\nMarks',
                                            textAlign: TextAlign.center,
                                          ))),
                                        ],
                                        rows: snapshot.data!.sectionData!
                                            .map((element) => DataRow(cells: [
                                                  DataCell(Text(
                                                    '${element.sectionName}'
                                                        .split('_')
                                                        .sublist(1)
                                                        .join(),
                                                  )),
                                                  DataCell(Center(
                                                      child: Text(
                                                    element.sectionTime != '0'
                                                        ? element.sectionTime!
                                                        : '-',
                                                    textAlign: TextAlign.center,
                                                  ))),
                                                  DataCell(Center(
                                                    child: Text(
                                                      element.secTotalQuestion!,
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                  )),
                                                  DataCell(Center(
                                                      child: Text(
                                                    element.secTotalMark!,
                                                    textAlign: TextAlign.center,
                                                  ))),
                                                ]))
                                            .toList()),
                                  ),
                                );
                              }
                              return CircularProgressIndicator();
                            }),
                      ),
                    ),
                    SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Row(children: [
                        Icon(CupertinoIcons.largecircle_fill_circle),
                        Expanded(
                            child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                              'The question number at the top of the screen shows one of the following status for each of the questions numbered :'),
                        ))
                      ]),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 5),
                      child: Row(children: [
                        Material(
                          elevation: 5,
                          color: Colors.greenAccent,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          child: CircleAvatar(
                            radius: 15,
                            backgroundColor: Colors.greenAccent,
                          ),
                        ),
                        Expanded(
                            child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('Attempted'),
                        ))
                      ]),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 5),
                      child: Row(children: [
                        Material(
                          elevation: 5,
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          child: CircleAvatar(
                            radius: 15,
                            backgroundColor: Colors.white,
                          ),
                        ),
                        Expanded(
                            child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('Not Attempted'),
                        ))
                      ]),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 5),
                      child: Row(children: [
                        Material(
                          elevation: 5,
                          color: Colors.purpleAccent,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          child: CircleAvatar(
                            radius: 15,
                            backgroundColor: Colors.purpleAccent,
                          ),
                        ),
                        Expanded(
                            child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('Marked for Review'),
                        ))
                      ]),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Row(children: [
                        Icon(CupertinoIcons.largecircle_fill_circle),
                        Expanded(
                            child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                              'The ${widget.totalTime} Minutes duration will be given to attempt all the questions across all the sections.'),
                        ))
                      ]),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Row(children: [
                        Icon(CupertinoIcons.largecircle_fill_circle),
                        Expanded(
                            child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                              'The clock has been set at the server and the countdown timer at the top right corner of your screen will display the time remaining for you to complete the exam. When the clock runs out the exam ends by default-you are not required to end or submit you exam.'),
                        ))
                      ]),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Row(children: [
                        Icon(CupertinoIcons.largecircle_fill_circle),
                        Expanded(
                            child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                              'The question number at the top of the screen will help you to navigate through the questions.'),
                        ))
                      ]),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Row(children: [
                        Icon(CupertinoIcons.largecircle_fill_circle),
                        Expanded(
                            child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: RichText(
                              text: TextSpan(
                                  style: TextStyle(color: Colors.black),
                                  children: [
                                TextSpan(
                                    text:
                                        'There will be penalty for wrong answers marked in the Objective Test. For each question for which a wrong answer has been given,'),
                                TextSpan(
                                    text: ' ${widget.incorrectMarks} mark(s) ',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    )),
                                TextSpan(
                                    text:
                                        'assigned to that question will be deducted as penalty to arrive at corrected score.')
                              ])),
                        ))
                      ]),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Row(children: [
                        Icon(CupertinoIcons.largecircle_fill_circle),
                        Expanded(
                            child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                              'No marks will be awarded/deducted if the question is not attempted.'),
                        ))
                      ]),
                    ),
                    SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        'Navigation Instructions',
                        style: TextStyle(
                            fontSize: 18, color: Colors.orange.shade900),
                      ),
                    ),
                    SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Row(children: [
                        Icon(CupertinoIcons.largecircle_fill_circle),
                        Expanded(
                            child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                              'To select a question to answer, you can do one of the following:'),
                        ))
                      ]),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Row(children: [
                        Text('A.'),
                        Expanded(
                            child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                              'Click on the question number on the top of your screen to go to that numbered question directly. Note that using this option does NOT save your answer to the current question.'),
                        ))
                      ]),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Row(children: [
                        Text('B.'),
                        Expanded(
                            child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                              'Click on NEXT to the current question and go to the next question in the sequence.'),
                        ))
                      ]),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Row(children: [
                        Text('C.'),
                        Expanded(
                            child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                              'Click on PREVIOUS to the current question and go to the previous question in the sequence.'),
                        ))
                      ]),
                    ),
                    SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        'Answering a Question',
                        style: TextStyle(
                            fontSize: 18, color: Colors.orange.shade900),
                      ),
                    ),
                    SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Row(children: [
                        Icon(CupertinoIcons.largecircle_fill_circle),
                        Expanded(
                            child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('For Multiple Choice type question:'),
                        ))
                      ]),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Row(children: [
                        Text('A.'),
                        Expanded(
                            child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                              'To select answer, Click on one of the options buttons. '),
                        ))
                      ]),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Row(children: [
                        Text('B.'),
                        Expanded(
                            child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                              'To change the answer, Click another desired options button.'),
                        ))
                      ]),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Row(children: [
                        Text('C.'),
                        Expanded(
                            child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                              'To deselect a chosen answer, Click on the Clear Selection Button.'),
                        ))
                      ]),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Row(children: [
                        Text('D.'),
                        Expanded(
                            child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                              'To mark the question for review, click on the Mark For Review button. If an answer is selected for a question that is Marked For Review, that answer will be considered in evaluation.'),
                        ))
                      ]),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Row(children: [
                        Text('E.'),
                        Expanded(
                            child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                              'To change the answer to a question, first select the question and then click on a new answer followed by click on the NEXT button.'),
                        ))
                      ]),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Row(children: [
                        Icon(CupertinoIcons.largecircle_fill_circle),
                        Expanded(
                            child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                              'You need to complete the particular section (within the section time) or directly move to the last question of that section from the question palette and click Next, before moving to the next section. You can not revisit the section once it has been completed.'),
                        ))
                      ]),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Row(children: [
                        Icon(CupertinoIcons.largecircle_fill_circle),
                        Expanded(
                            child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                              'If the time allotted to the particular section finishes, then automatically the next section starts with its allotted time.'),
                        ))
                      ]),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      child: FutureBuilder(
                        future: getFLTSectionList(),
                        builder:
                            (context, AsyncSnapshot<FLTSectionData> snapshot) {
                          if (snapshot.hasData)
                            return TextButton(
                              onPressed: () {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertBox(
                                        text: 'Yes, I agree',
                                        secondText: 'No, go back',
                                        title: 'Start Test',
                                        content:
                                            'I have read and understood the instructions. All Computer Hardwares allotted to me are in proper working condition. I agree that in case of not adhering to the instructions, I will be disqualified from giving the exam.',
                                        press: () async {
                                          Navigator.pop(context);
                                          Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                  builder:
                                                      (context) => FLTTestQuizPage(
                                                          hasSection: snapshot
                                                                  .data!
                                                                  .sectionData!
                                                                  .first
                                                                  .sectionTime !=
                                                              '0',
                                                          totalTime:
                                                              widget.totalTime,
                                                          correctMarks: widget
                                                              .correctMarks,
                                                          incorrectMarks: widget
                                                              .incorrectMarks,
                                                          reqPercentage: widget
                                                              .reqPercentage,
                                                          title: widget.heading,
                                                          section_data:
                                                              buttonData,
                                                          totalQues:
                                                              widget.totalQues,
                                                          test_id:
                                                              widget.test_id)));
                                        },
                                        secondPress: () {
                                          Navigator.pop(context);
                                        },
                                      );
                                    });
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text('Start Test',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 20)),
                              ),
                              style: TextButton.styleFrom(
                                  backgroundColor: kPrimaryColor,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(29))),
                            );
                          return TextButton(
                            onPressed: null,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: CircularProgressIndicator(
                                color: Colors.white,
                              ),
                            ),
                            style: TextButton.styleFrom(
                                backgroundColor: kPrimaryColor,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(29))),
                          );
                        },
                      ),
                    )
                  ]
                : [
                    Padding(
                      padding:
                          const EdgeInsets.only(top: 8.0, left: 8, right: 8),
                      child: ListTile(
                          title: Text(
                        widget.heading,
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 25),
                      )),
                    ),
                    ListTile(
                        title: Text(
                      'परीक्षा निर्देश',
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    )),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        'सामान्य निर्देश :',
                        style: TextStyle(
                            fontSize: 18, color: Colors.orange.shade900),
                      ),
                    ),
                    SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Row(children: [
                        Icon(CupertinoIcons.largecircle_fill_circle),
                        Expanded(
                            child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('परीक्षा में निम्नलिखित अनुदेश होंगे:'),
                        ))
                      ]),
                    ),
                    Center(
                      child: FittedBox(
                        child: FutureBuilder(
                            future: getFLTSectionList(),
                            builder: (context,
                                AsyncSnapshot<FLTSectionData> snapshot) {
                              if (snapshot.hasData) {
                                buttonData = snapshot.data!.sectionData!;
                                return Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 5),
                                  child: Material(
                                    elevation: 2,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5)),
                                    child: DataTable(
                                        headingRowColor:
                                            MaterialStateColor.resolveWith(
                                                (states) =>
                                                    Colors.grey.shade200),
                                        dividerThickness: 1,
                                        headingTextStyle: TextStyle(
                                            fontSize: 25, color: Colors.black),
                                        dataTextStyle: TextStyle(
                                            fontSize: 25, color: Colors.black),
                                        showBottomBorder: true,
                                        columns: [
                                          DataColumn(
                                              label: Center(
                                                  child: Text(
                                            'Name',
                                            textAlign: TextAlign.center,
                                          ))),
                                          DataColumn(
                                              label: Center(
                                                  child: Text(
                                            'Time',
                                            textAlign: TextAlign.center,
                                          ))),
                                          DataColumn(
                                              label: Center(
                                                  child: Text(
                                            'Total\nQuestions',
                                            textAlign: TextAlign.center,
                                          ))),
                                          DataColumn(
                                              label: Center(
                                                  child: Text(
                                            'Total\nMarks',
                                            textAlign: TextAlign.center,
                                          ))),
                                        ],
                                        rows: snapshot.data!.sectionData!
                                            .map((element) => DataRow(cells: [
                                                  DataCell(Text(
                                                    '${element.sectionName}'
                                                        .split('_')
                                                        .sublist(1)
                                                        .join(),
                                                  )),
                                                  DataCell(Center(
                                                      child: Text(
                                                    element.sectionTime != '0'
                                                        ? element.sectionTime!
                                                        : '-',
                                                    textAlign: TextAlign.center,
                                                  ))),
                                                  DataCell(Center(
                                                    child: Text(
                                                      element.secTotalQuestion!,
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                  )),
                                                  DataCell(Center(
                                                      child: Text(
                                                    element.secTotalMark!,
                                                    textAlign: TextAlign.center,
                                                  ))),
                                                ]))
                                            .toList()),
                                  ),
                                );
                              }
                              return CircularProgressIndicator();
                            }),
                      ),
                    ),
                    SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Row(children: [
                        Icon(CupertinoIcons.largecircle_fill_circle),
                        Expanded(
                            child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                              'स्क्रीन के ऊपर दी गयी प्रश्न संख्या, प्रत्येक प्रश्न के लिए निम्न में से कोई एक स्थिति प्रकट करता है:'),
                        ))
                      ]),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 5),
                      child: Row(children: [
                        Material(
                          elevation: 5,
                          color: Colors.greenAccent,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          child: CircleAvatar(
                            radius: 15,
                            backgroundColor: Colors.greenAccent,
                          ),
                        ),
                        Expanded(
                            child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('आपने प्रश्न का उत्तर दे दिया है।'),
                        ))
                      ]),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 5),
                      child: Row(children: [
                        Material(
                          elevation: 5,
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          child: CircleAvatar(
                            radius: 15,
                            backgroundColor: Colors.white,
                          ),
                        ),
                        Expanded(
                            child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('आपने प्रश्न का उत्तर नहीं दिया है। '),
                        ))
                      ]),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 5),
                      child: Row(children: [
                        Material(
                          elevation: 5,
                          color: Colors.purpleAccent,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          child: CircleAvatar(
                            radius: 15,
                            backgroundColor: Colors.purpleAccent,
                          ),
                        ),
                        Expanded(
                            child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                              'आपने प्रश्न को पुनः विचार के लिए चिह्नित किया है।'),
                        ))
                      ]),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Row(children: [
                        Icon(CupertinoIcons.largecircle_fill_circle),
                        Expanded(
                            child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                              'सभी प्रश्नों को हल करने के लिए ${widget.totalTime} मिनिट का समय दिया जायेगा'),
                        ))
                      ]),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Row(children: [
                        Icon(CupertinoIcons.largecircle_fill_circle),
                        Expanded(
                            child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                              'सर्वर पर घड़ी सेट की गयी है, तथा आपकी स्क्रीन के दाहिने कोने में शीर्ष पर काउंटडाउन टाइमर है जो आपके लिए परीक्षा समाप्त होने की शेष अवधि को प्रदर्शित करेगा। परीक्षा समय समाप्त होने पर, आपको अपनी परीक्षा बंद या समाप्त करने की जरूरत नहीं है। यह स्वतः बंद या जमा हो जायेगी।'),
                        ))
                      ]),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Row(children: [
                        Icon(CupertinoIcons.largecircle_fill_circle),
                        Expanded(
                            child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                              'स्क्रीन के ऊपर दी गयी प्रश्न संख्या, आपको प्रश्नों पर जाने के लिए मदद करेगा।'),
                        ))
                      ]),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Row(children: [
                        Icon(CupertinoIcons.largecircle_fill_circle),
                        Expanded(
                            child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: RichText(
                              text: TextSpan(
                                  style: TextStyle(color: Colors.black),
                                  children: [
                                TextSpan(
                                    text:
                                        'वस्तुनिष्ठ परीक्षा में अंकित किए गए गलत उत्तरों के लिए दंड होगा। सही स्कोर को प्राप्त करने हेतु उम्मीदवार द्वारा दिए गए प्रत्येक गलत उत्तर के लिए, उस प्रश्न के लिए निर्दिष्ट अंकों से'),
                                TextSpan(
                                    text: ' ${widget.incorrectMarks} अंक ',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    )),
                                TextSpan(text: 'दंड के तौर पर काटे जाऐंगे।')
                              ])),
                        ))
                      ]),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Row(children: [
                        Icon(CupertinoIcons.largecircle_fill_circle),
                        Expanded(
                            child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                              'यदि प्रश्न नहीं किया है तो ना ही अंक प्राप्त होगा और न ही अंक की कटौती होगी।'),
                        ))
                      ]),
                    ),
                    SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        'किसी प्रश्न पर जाने हेतु -',
                        style: TextStyle(
                            fontSize: 18, color: Colors.orange.shade900),
                      ),
                    ),
                    SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Row(children: [
                        Icon(CupertinoIcons.largecircle_fill_circle),
                        Expanded(
                            child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                              'उत्तर देने हेतु कोई प्रश्न चुनने के लिए, आप निम्न में से कोई एक कार्य कर सकते हैं : '),
                        ))
                      ]),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Row(children: [
                        Text('A.'),
                        Expanded(
                            child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                              'प्रश्न पर सीधे जाने के लिए स्क्रीन के ऊपर दी गयी प्रश्न संख्या पर क्लिक करें। ध्यान दें कि इस विकल्प का उपयोग करने से वर्तमान प्रश्न का उत्तर सुरक्षित नहीं होता है।'),
                        ))
                      ]),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Row(children: [
                        Text('B.'),
                        Expanded(
                            child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                              'क्रम में अगले प्रश्न पर जाने के लिए वर्तमान प्रश्न में Next पर क्लिक करें।'),
                        ))
                      ]),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Row(children: [
                        Text('C.'),
                        Expanded(
                            child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                              'क्रम में पिछले प्रश्न पर जाने के लिए, वर्तमान प्रश्न में Previous पर क्लिक करें।'),
                        ))
                      ]),
                    ),
                    SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        'प्रश्न का उत्तर देने हेतु - ',
                        style: TextStyle(
                            fontSize: 18, color: Colors.orange.shade900),
                      ),
                    ),
                    SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Row(children: [
                        Icon(CupertinoIcons.largecircle_fill_circle),
                        Expanded(
                            child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('एकाधिक विकल्प प्रकार प्रश्न के लिए : '),
                        ))
                      ]),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Row(children: [
                        Text('A.'),
                        Expanded(
                            child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                              'उत्तर चुनने के लिए, किसी एक विकल्प (बटन) पर क्लिक करें। '),
                        ))
                      ]),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Row(children: [
                        Text('B.'),
                        Expanded(
                            child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                              'उत्तर बदलने के लिए, किसी अन्य ऐच्छिक विकल्प (बटन) पर क्लिक करें।'),
                        ))
                      ]),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Row(children: [
                        Text('C.'),
                        Expanded(
                            child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                              'किसी चुने हुए उत्तर को अचयनित करने के लिए Clear Selection विकल्प (बटन) पर क्लिक करें।'),
                        ))
                      ]),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Row(children: [
                        Text('D.'),
                        Expanded(
                            child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                              'पुनर्विचार हेतु प्रश्न को चिह्नित करने के लिए, Mark for Review बटन पर क्लिक करें। यदि प्रश्न के लिए उत्तर चुना हो जो कि पुनर्विचार के लिए चिह्नित किया गया है, तब अंतिम मूल्यांकन में उस उत्तर पर ध्यान दिया जाएगा।'),
                        ))
                      ]),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Row(children: [
                        Text('E.'),
                        Expanded(
                            child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                              'किसी प्रश्न का उत्तर बदलने के लिए सबसे पहले प्रश्न का चयन करें और फिर नए उत्तर विकल्प पर क्लिक करें।'),
                        ))
                      ]),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Row(children: [
                        Icon(CupertinoIcons.largecircle_fill_circle),
                        Expanded(
                            child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                              'अगले भाग में जाने के पहले, आपको प्रत्येक भाग को उसके दिए गए समय में पूरा करना है, या उस भाग के अंतिम प्रश्न पर सीधे चले जाना है और Next बटन क्लिक करना है। आप उस भाग को पूरा करने पर या उससे निकलने पर दोबारा उसमें नहीं जा सकेंगे।'),
                        ))
                      ]),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Row(children: [
                        Icon(CupertinoIcons.largecircle_fill_circle),
                        Expanded(
                            child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                              'यदि किसी भाग का आवंटित समय समाप्त हो जाता है, उसके बाद अगला भाग स्वतः ही प्रारम्भ हो जाएगा, जिसका आवंटित समय दिया गया होगा।'),
                        ))
                      ]),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      child: FutureBuilder(
                        future: getFLTSectionList(),
                        builder:
                            (context, AsyncSnapshot<FLTSectionData> snapshot) {
                          if (snapshot.hasData)
                            return TextButton(
                              onPressed: () {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertBox(
                                        text: 'Yes, I agree',
                                        secondText: 'No, go back',
                                        title: 'परीक्षा शुरू करें',
                                        content:
                                            'मैंने निर्देश पढ़ तथा समझ लिए हैं सभी कंप्यूटर हार्डवेयर उचित क्षमता में मेरे लिए आवंटित किये गए है में सहमत हूँ की यदि में निर्देशों का पालन नहीं कर पाया तो में परीक्षा देने से अयोग्य घोषित कर दिया जाऊंगा/जाऊंगी।',
                                        press: () async {
                                          Navigator.pop(context);
                                          Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                  builder:
                                                      (context) => FLTTestQuizPage(
                                                          hasSection: snapshot
                                                                  .data!
                                                                  .sectionData!
                                                                  .first
                                                                  .sectionTime !=
                                                              '0',
                                                          totalTime:
                                                              widget.totalTime,
                                                          correctMarks: widget
                                                              .correctMarks,
                                                          incorrectMarks: widget
                                                              .incorrectMarks,
                                                          reqPercentage: widget
                                                              .reqPercentage,
                                                          title: widget.heading,
                                                          section_data:
                                                              buttonData,
                                                          totalQues:
                                                              widget.totalQues,
                                                          test_id:
                                                              widget.test_id)));
                                        },
                                        secondPress: () {
                                          Navigator.pop(context);
                                        },
                                      );
                                    });
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text('परीक्षा शुरू करें',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 20)),
                              ),
                              style: TextButton.styleFrom(
                                  backgroundColor: kPrimaryColor,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(29))),
                            );
                          return TextButton(
                            onPressed: null,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: CircularProgressIndicator(
                                color: Colors.white,
                              ),
                            ),
                            style: TextButton.styleFrom(
                                backgroundColor: kPrimaryColor,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(29))),
                          );
                        },
                      ),
                    )
                  ],
          ),
        ),
      )),
    );
  }
}
