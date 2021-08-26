import 'package:elearning/Screens/ExamScreen/ExamResultAnalysis.dart';
import 'package:elearning/constants.dart';
import 'package:elearning/schemas/examResultSchema.dart';
import 'package:flutter/material.dart';

//ignore_for_file: non_constant_identifier_names
class ExamCompleted extends StatefulWidget {
  final ExamResult examResult;
  final String test_hash;
  const ExamCompleted({
    Key? key,
    required this.test_hash,
    required this.examResult,
  }) : super(key: key);

  @override
  _ExamCompletedState createState() => _ExamCompletedState();
}

class _ExamCompletedState extends State<ExamCompleted> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: SingleChildScrollView(
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
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text('Correct Answers'),
                                    Text('${widget.examResult.totCorrect}',
                                        style: TextStyle(
                                            fontSize: 30,
                                            fontWeight: FontWeight.bold))
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text('Inorrect Answers'),
                                    Text(
                                      '${widget.examResult.totIncorrect}',
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
                                builder: (context) => ExamResultAnalysis(
                                      examResult: widget.examResult,
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
                              borderRadius: BorderRadius.circular(20)))),
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
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                      ),
                      style: TextButton.styleFrom(
                          elevation: 10,
                          backgroundColor: kPrimaryColor,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)))),
                )
              ],
            )
          ]),
    )));
  }
}

// overallReport.addAll({
//                                 "percentage":
//                                     recievedData['percentage'].toDouble(),
//                                 "totCorrect": recievedData['totCorrect'],
//                                 "totIncorrect": recievedData['totIncorrect'],
//                                 "notAttempt": recievedData['notAttempt'],
//                                 "mark_obtain":
//                                     recievedData['mark_obtain'].toDouble()
//                               });
