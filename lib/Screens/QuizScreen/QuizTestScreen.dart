import 'dart:async';
import 'dart:convert';
import 'package:elearning/Screens/MainLayout/AlertDialog.dart';
import 'package:elearning/dbModel.dart';
import 'package:elearning/modules/TestResultScreen.dart';
import 'package:flutter/services.dart';
import 'package:flutter_card_swipper/flutter_card_swiper.dart';
import 'package:html/parser.dart' as htmlparser;
import 'package:elearning/MyStore.dart';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:elearning/constants.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:http/http.dart' as http;
import 'package:step_progress_indicator/step_progress_indicator.dart';
import 'package:velocity_x/velocity_x.dart';

// ignore_for_file: non_constant_identifier_names
class QuiztestScreen extends StatefulWidget {
  final int id;
  final String positive_marks;
  final double totalMarks;
  final String negative_marks;
  final String title;
  final String test_hash;
  final String totalTime;

  const QuiztestScreen(
      {Key? key,
      required this.id,
      required this.totalMarks,
      required this.title,
      required this.negative_marks,
      required this.positive_marks,
      required this.test_hash,
      required this.totalTime})
      : super(key: key);

  @override
  _QuiztestScreenState createState() => _QuiztestScreenState();
}

class _QuiztestScreenState extends State<QuiztestScreen> {
  late List data;
  MyStore store = VxState.store;

  late List<List<Color>> result;
  late bool isDone;
  late SwiperController _controller;
  late int initPos;

  getDataByTestHash() async {
    isDone = false;
    MyStore store = VxState.store;
    data = [];

    await http.post(Uri.parse(getTestQuestions_URL), body: {
      'user_id': store.studentID,
      'user_hash': store.studentHash,
      'test_hash': widget.test_hash,
      'rgcmid': '',
    }).then((value) async {
      dynamic fetchedData = jsonDecode(value.body);
      data = fetchedData['questions'];
      result = List.generate(data.length, (index) {
        List<Color> temp = [];
        data[index].forEach((key, value) {
          if (key.contains('opt') && key != 'correct_opt' && value != '')
            temp.add(Colors.white);
        });
        return temp;
      });
    });
    if (mounted)
      setState(() {
        isDone = true;
      });
  }

  @override
  void initState() {
    _controller = SwiperController();
    getDataByTestHash();
    super.initState();
    initPos = 1;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  List<Container> getOptions(
      element, SwiperController _controller, List<Color> result) {
    List<Container> reslist = [];
    int count = 0;
    element.forEach((key, value) {
      if (key.contains('opt') && key != 'correct_opt' && value != '') {
        reslist.add(Container(
          height: 50,
          width: MediaQuery.of(context).size.width / 6,
          child: MaterialButton(
            padding: EdgeInsets.symmetric(horizontal: 5),
            onPressed: result.count((n) => n == Colors.green) == 1
                ? null
                : () {
                    if (key[key.length - 1] == element['correct_opt']) {
                      print('If');
                      if (mounted)
                        setState(() {
                          result[int.parse(key[key.length - 1]) - 1] =
                              Colors.green;
                        });
                    } else {
                      print('Else');
                      if (mounted)
                        setState(() {
                          result[int.parse(element['correct_opt']) - 1] =
                              Colors.green;
                          result[int.parse(key[key.length - 1]) - 1] =
                              Colors.red;
                        });
                    }
                    Timer(Duration(seconds: 1), () {
                      _controller.next(animation: true);
                    });
                  },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Container(
                  margin: EdgeInsets.symmetric(vertical: 2, horizontal: 5),
                  width: MediaQuery.of(context).size.width / 6,
                  height: 50,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: result[int.parse(key[key.length - 1]) - 1]),
                  child: Center(
                    child: Text(
                      String.fromCharCode(65 + count),
                      style: TextStyle(fontSize: 25),
                    ),
                  )),
            ),
          ),
        ));
        count++;
      }
    });
    return reslist;
  }

  List<Widget> getOptionsText(dynamic data) {
    List<Widget> options = [];
    int countNew = 0;
    data.forEach((key, value) {
      if (key.contains('opt') && key != 'correct_opt' && value != '') {
        options.add(value.toString().contains('<img')
            ? Padding(
                padding: const EdgeInsets.only(left: 16),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Row(
                    children: [
                      Text(String.fromCharCode(65 + countNew) + '. '),
                      Html.fromDom(
                        style: {
                          'p': Style(
                              color: Colors.white,
                              textAlign: TextAlign.start,
                              fontSize: FontSize.xLarge)
                        },
                        document: htmlparser.parse(
                          '<p>' + value + '</p>',
                        ),
                      ),
                    ],
                  ),
                ),
              )
            : Padding(
                padding: const EdgeInsets.only(left: 16),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: AutoSizeText(
                    String.fromCharCode(65 + countNew) +
                        '. ' +
                        htmlparser.parse('<p>' + value + '</p>').body!.text,
                    minFontSize: 18,
                    maxFontSize: 20,
                    style: TextStyle(color: Colors.white),
                    textAlign: TextAlign.start,
                    maxLines: 3,
                  ),
                ),
              ));
        countNew++;
      }
    });
    return options;
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          onPressed: () {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertBox(
                    text: 'Yes',
                    secondText: 'No',
                    title: 'Exit Test',
                    content: 'Are you sure you want to exit the test?',
                    press: () async {
                      Navigator.pop(context);
                      Navigator.pop(context);
                    },
                    secondPress: () {
                      Navigator.pop(context);
                    },
                  );
                });
          },
        ),
        title: Text(widget.title),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            isDone
                ? (initPos != 1)
                    ? FloatingActionButton(
                        mini: true,
                        heroTag: null,
                        onPressed: () {
                          _controller.previous();
                        },
                        child: Icon(Icons.arrow_back),
                      )
                    : Text('')
                : Text(''),
            (isDone)
                ? (((initPos + 1) > (data.length)))
                    ? FloatingActionButton(
                        heroTag: null,
                        mini: true,
                        onPressed: () {
                          final box = store.dataStore.box<TestDataElement>();
                          TestDataElement _testDataElement =
                              box.get(widget.id)!;
                          print(widget.id);
                          _testDataElement.is_attempted = 1;
                          box.putAsync(_testDataElement);
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => TestResultScreen(
                                      isQuiz: true,
                                      totalMarks: widget.totalMarks,
                                      quesIDList: data,
                                      positive_marks: widget.positive_marks,
                                      negative_marks: widget.negative_marks,
                                      colorData: result,
                                      test_hash: widget.test_hash)));
                        },
                        child: Icon(Icons.check))
                    : FloatingActionButton(
                        mini: true,
                        heroTag: null,
                        onPressed: () {
                          _controller.next();
                        },
                        child: Icon(Icons.arrow_forward),
                      )
                : Text('')
          ],
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 8.0, left: 8, right: 8),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Total Questions: ' + '${data.length}'),
                  isDone
                      ? CircularCountDownTimer(
                          duration: int.parse(widget.totalTime) * 60,
                          initialDuration: 0,
                          controller: CountDownController(),
                          width: 50,
                          height: 50,
                          ringColor: Colors.grey[300]!,
                          ringGradient: null,
                          fillColor: kPrimaryColor,
                          fillGradient: null,
                          backgroundGradient: null,
                          strokeWidth: 5,
                          strokeCap: StrokeCap.round,
                          textStyle: TextStyle(
                              fontSize: 10,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                          textFormat: CountdownTextFormat.MM_SS,
                          isReverse: true,
                          isReverseAnimation: true,
                          isTimerTextShown: true,
                          autoStart: true,
                          onComplete: () {
                            print('Countdown Ended');
                            final box = store.dataStore.box<TestDataElement>();
                            TestDataElement _testDataElement =
                                box.get(widget.id)!;
                            print(widget.id);
                            _testDataElement.is_attempted = 1;
                            box.putAsync(_testDataElement);
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => TestResultScreen(
                                        isQuiz: true,
                                        totalMarks: widget.totalMarks,
                                        quesIDList: data,
                                        positive_marks: widget.positive_marks,
                                        negative_marks: widget.negative_marks,
                                        colorData: result,
                                        test_hash: widget.test_hash)));
                          },
                        )
                      : Text('Initializing Timer')
                ]),
          ),
          Expanded(
            child: isDone
                ? Swiper(
                    onIndexChanged: (e) {
                      initPos = e;
                      if (mounted)
                        setState(() {
                          if (initPos <= data.length) initPos++;
                        });
                    },
                    physics: NeverScrollableScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    loop: false,
                    itemBuilder: (BuildContext context, int index) {
                      return Card(
                          color: kPrimaryColor,
                          margin:
                              EdgeInsets.symmetric(vertical: 25, horizontal: 8),
                          elevation: 10,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 20, horizontal: 5),
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[] +
                                    [
                                      Expanded(
                                        flex: 2,
                                        child: data[index]['ques_desc']
                                                .toString()
                                                .contains('<img')
                                            ? Html.fromDom(
                                                style: {
                                                  'body': Style(
                                                      color: Colors.white,
                                                      fontSize: FontSize.xLarge)
                                                },
                                                document: htmlparser.parse(
                                                  '<body>' +
                                                      data[index]['ques_desc'] +
                                                      '</body>',
                                                ),
                                              )
                                            : Center(
                                                child: AutoSizeText(
                                                  htmlparser
                                                      .parse(data[index]
                                                          ['ques_desc'])
                                                      .body!
                                                      .text,
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                  minFontSize: 18,
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                      ),
                                    ] +
                                    getOptionsText(data[index]) +
                                    [
                                      Wrap(
                                          children: getOptions(data[index],
                                              _controller, result[index])),
                                    ],
                              ),
                            ),
                          ));
                    },
                    itemCount: data.length,
                    itemWidth: MediaQuery.of(context).size.width,
                    itemHeight: MediaQuery.of(context).size.height / 1.4,
                    controller: _controller,
                    layout: SwiperLayout.STACK,
                  )
                : Center(child: CircularProgressIndicator()),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: StepProgressIndicator(
              selectedSize: 10,
              unselectedSize: 5,
              totalSteps: isDone ? data.length : 1,
              currentStep: isDone ? initPos : 1,
            ),
          ),
        ],
      ),
    );
  }
}
