import 'package:elearning/Screens/ExamScreen/ExamTestScreen.dart';
import 'package:elearning/Screens/MainLayout/AlertDialog.dart';
import 'package:elearning/Screens/QuizScreen/QuizTestScreen.dart';
import 'package:elearning/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TestInstructionPage extends StatefulWidget {
  final int id;
  final bool isQuiz;
  final String totalTime;
  final String heading;
  final String title;
  final String totalQues;
  // ignore: non_constant_identifier_names
  final String test_hash;
  final String correctMarks;
  final String incorrectMarks;
  const TestInstructionPage(
      {Key? key,
      required this.isQuiz,
      required this.id,
      required this.correctMarks,
      required this.totalQues,
      required this.heading,
      required this.incorrectMarks,
      // ignore: non_constant_identifier_names
      required this.test_hash,
      required this.title,
      required this.totalTime})
      : super(key: key);

  @override
  _TestInstructionPageState createState() => _TestInstructionPageState();
}

class _TestInstructionPageState extends State<TestInstructionPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(8.0),
        child: Card(
          elevation: 10,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 8.0, left: 8, right: 8),
                  child: ListTile(
                      title: Text(
                    widget.heading,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 25),
                  )),
                ),
              ),
              Center(
                child: Padding(
                  padding:
                      const EdgeInsets.only(bottom: 8.0, left: 8, right: 8),
                  child: ListTile(
                    title: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.query_builder),
                          Text(
                            widget.totalTime + ' Minutes',
                            style: TextStyle(fontSize: 18),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(width: 30),
                          Icon(CupertinoIcons.question_circle),
                          Text(
                            widget.totalQues + ' Questions',
                            style: TextStyle(fontSize: 18),
                            textAlign: TextAlign.center,
                          )
                        ]),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 3),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(
                        Icons.keyboard_arrow_right,
                        color: kPrimaryColor,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        'The clock has been set at the server for the Test.',
                        style: TextStyle(fontSize: 15),
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 3),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(
                        Icons.keyboard_arrow_right,
                        color: kPrimaryColor,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        'The timer on the top right corner of the screen tells you the remaining time.',
                        style: TextStyle(fontSize: 15),
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 3),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(
                        Icons.keyboard_arrow_right,
                        color: kPrimaryColor,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        'Navigate through the questions using Next or Back buttons.',
                        style: TextStyle(fontSize: 15),
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 3),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(
                        Icons.keyboard_arrow_right,
                        color: kPrimaryColor,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        'Click on the option, to select as your choice.',
                        style: TextStyle(fontSize: 15),
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 3),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(
                        Icons.keyboard_arrow_right,
                        color: kPrimaryColor,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        'For each right answer ' +
                            '${widget.correctMarks}' +
                            ' marks will be provided.',
                        style: TextStyle(fontSize: 15),
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 3),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(
                        Icons.keyboard_arrow_right,
                        color: kPrimaryColor,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        'For each wrong answer ' +
                            '${widget.incorrectMarks}' +
                            ' marks will be deducted.',
                        style: TextStyle(fontSize: 15),
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 3),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(
                        Icons.keyboard_arrow_right,
                        color: kPrimaryColor,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        'Exams ends as the clock runs out.',
                        style: TextStyle(fontSize: 15),
                      ),
                    )
                  ],
                ),
              ),
              widget.isQuiz
                  ? ListTile(
                      leading: Material(
                        elevation: 5,
                        color: Colors.green,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        child: CircleAvatar(
                          backgroundColor: Colors.green,
                        ),
                      ),
                      title: Text('Correct Answer'),
                    )
                  : ListTile(
                      leading: Material(
                        elevation: 5,
                        color: Colors.greenAccent,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        child: CircleAvatar(
                          backgroundColor: Colors.greenAccent,
                        ),
                      ),
                      title: Text('Attempted'),
                    ),
              widget.isQuiz
                  ? ListTile(
                      leading: Material(
                        elevation: 5,
                        color: Colors.red,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        child: CircleAvatar(
                          backgroundColor: Colors.red,
                        ),
                      ),
                      title: Text('Incorrect Answer'),
                    )
                  : ListTile(
                      leading: Material(
                        elevation: 5,
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        child: CircleAvatar(
                          backgroundColor: Colors.white,
                        ),
                      ),
                      title: Text('Not Attempted'),
                    ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: TextButton(
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
                                      builder: (context) => widget.isQuiz
                                          ? QuiztestScreen(
                                              id: widget.id,
                                              positive_marks:
                                                  widget.correctMarks,
                                              negative_marks:
                                                  widget.incorrectMarks,
                                              totalMarks: double.parse(
                                                      widget.totalQues) *
                                                  double.parse(
                                                      widget.correctMarks),
                                              title: widget.heading,
                                              test_hash: widget.test_hash,
                                              totalTime: widget.totalTime)
                                          : ExamTestScreen(
                                              id: widget.id,
                                              positive_marks:
                                                  widget.correctMarks,
                                              negative_marks:
                                                  widget.incorrectMarks,
                                              totalMarks: double.parse(
                                                      widget.totalQues) *
                                                  double.parse(
                                                      widget.correctMarks),
                                              title: widget.heading,
                                              test_hash: widget.test_hash,
                                              totalTime: widget.totalTime)));
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
                        style: TextStyle(color: Colors.white, fontSize: 20)),
                  ),
                  style: TextButton.styleFrom(
                      backgroundColor: kPrimaryColor,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(29))),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
