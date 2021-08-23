import 'dart:convert';
import 'package:elearning/Screens/ExamScreen/ExamCompleted.dart';
import 'package:elearning/Screens/MainLayout/AlertDialog.dart';
import 'package:elearning/dbModel.dart';
import 'package:elearning/modules/TestResultScreen.dart';
import 'package:elearning/schemas/examResultSchema.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svprogresshud/flutter_svprogresshud.dart';
import 'package:html/parser.dart' as htmlparser;
import 'package:elearning/MyStore.dart';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:elearning/constants.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:http/http.dart' as http;
import 'package:velocity_x/velocity_x.dart';

// ignore_for_file: non_constant_identifier_names
class ExamTestScreen extends StatefulWidget {
  final int id;
  final String positive_marks;
  final double totalMarks;
  final String negative_marks;
  final String title;
  final String test_hash;
  final String totalTime;

  const ExamTestScreen(
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
  _ExamTestScreenState createState() => _ExamTestScreenState();
}

class _ExamTestScreenState extends State<ExamTestScreen>
    with TickerProviderStateMixin, KeepAliveParentDataMixin {
  late List data;
  MyStore store = VxState.store;
  late TabController _tabController;
  late CountDownController countDownController;
  late List<List<Color>> result;
  late List<String> responses;
  late bool isDone;
  late int initPos;
  double initScale = 1;
  TransformationController _transformationController =
      TransformationController();

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
      responses = List.filled(data.length, '');
    });
    _tabController = TabController(length: data.length, vsync: this);
    if (mounted)
      setState(() {
        countDownController = CountDownController();
        isDone = true;
      });
  }

  @override
  void initState() {
    getDataByTestHash();
    super.initState();
    initPos = 1;
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<RadioListTile> getOptions(element, TabController _controller,
      List<Color> result, List<String> responses, int index) {
    List<RadioListTile> reslist = [];
    element.forEach((key, value) {
      if (key.contains('opt') && key != 'correct_opt' && value != '') {
        reslist.add(RadioListTile(
          groupValue: responses[index],
          value: key[key.length - 1],
          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 0),
          onChanged: (e) {
            setState(() {
              responses[index] = e;
            });
            print(responses);
          },
          title: value.toString().contains('<img')
              ? Html.fromDom(
                  style: {'p': Style(fontSize: FontSize.larger)},
                  document: htmlparser.parse(
                    '<p>' + value + '</p>',
                  ),
                )
              : Text(
                  htmlparser.parse('<p>' + value + '</p>').body!.text,
                ),
        ));
      }
    });
    return reslist;
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
                          _tabController.animateTo(_tabController.index - 1);
                          if (mounted)
                            setState(() {
                              initPos--;
                            });
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
                        onPressed: () async {
                          countDownController.pause();
                          SVProgressHUD.setRingThickness(5);
                          SVProgressHUD.setRingRadius(5);
                          SVProgressHUD.setDefaultMaskType(
                              SVProgressHUDMaskType.black);
                          SVProgressHUD.show();
                          List responsesNew = [];
                          responses.forEach((element) {
                            if ((element) == '')
                              responsesNew.add(0);
                            else
                              responsesNew.add(element);
                          });
                          List ques_stringList = [];
                          for (int i = 0; i < responsesNew.length; i++) {
                            ques_stringList.add(
                                '${data[i]['ques_id']}#${responsesNew[i]}');
                          }
                          await http.post(Uri.parse(postTestResultDetails_URL),
                              body: {
                                'user_id': store.studentID,
                                'user_hash': store.studentHash,
                                'test_hash': widget.test_hash,
                                'positive_mark': widget.positive_marks,
                                'negative_mark': widget.negative_marks,
                                'ques_string': ques_stringList.join('|'),
                                'rgcmid': '',
                              }).then((value) async {
                            dynamic recievedData =
                                await compute(jsonDecode, value.body);
                            if (recievedData['flag'] != 1) {
                              SVProgressHUD.dismiss();
                              showCustomSnackBar(context,
                                  'Error Submitting Result. Please try again.');
                              countDownController.resume();
                            } else {
                              ExamResult examResult =
                                  ExamResult.fromJson(recievedData);
                              final box =
                                  store.dataStore.box<TestDataElement>();
                              TestDataElement _testDataElement =
                                  box.get(widget.id)!;
                              _testDataElement.is_attempted = 1;
                              box.putAsync(_testDataElement);
                              SVProgressHUD.dismiss();
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ExamCompleted(
                                          examResult: examResult,
                                          test_hash: widget.test_hash)));
                            }
                          });
                        },
                        child: Icon(Icons.check))
                    : FloatingActionButton(
                        mini: true,
                        heroTag: null,
                        onPressed: () {
                          _tabController.animateTo(_tabController.index + 1);
                          if (mounted)
                            setState(() {
                              initPos++;
                            });
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
                  Row(
                    children: [
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 8.0, horizontal: 0),
                            child: MaterialButton(
                                materialTapTargetSize:
                                    MaterialTapTargetSize.shrinkWrap,
                                padding: EdgeInsets.all(0),
                                minWidth: 0,
                                onPressed: () {
                                  if (initScale < 4) {
                                    ++initScale;
                                    _transformationController.value =
                                        Matrix4.diagonal3Values(
                                            initScale, initScale, 1);
                                  }
                                },
                                child: Image.asset(
                                    'assets/icons8-increase-font-24.png')),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: MaterialButton(
                                materialTapTargetSize:
                                    MaterialTapTargetSize.shrinkWrap,
                                padding: EdgeInsets.all(0),
                                minWidth: 0,
                                onPressed: () {
                                  if (initScale > 1) {
                                    --initScale;
                                    _transformationController.value =
                                        Matrix4.diagonal3Values(
                                            initScale, initScale, 1);
                                  }
                                },
                                child: Image.asset(
                                  'assets/icons8-decrease-font-24.png',
                                  scale: 1.2,
                                )),
                          ),
                        ],
                      ),
                      isDone
                          ? CircularCountDownTimer(
                              duration: int.parse(widget.totalTime) * 60,
                              initialDuration: 0,
                              controller: countDownController,
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
                                final box =
                                    store.dataStore.box<TestDataElement>();
                                TestDataElement _testDataElement =
                                    box.get(widget.id)!;
                                _testDataElement.is_attempted = 1;
                                box.putAsync(_testDataElement);
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => TestResultScreen(
                                            isQuiz: false,
                                            totalMarks: widget.totalMarks,
                                            quesIDList: data,
                                            positive_marks:
                                                widget.positive_marks,
                                            negative_marks:
                                                widget.negative_marks,
                                            data: responses,
                                            test_hash: widget.test_hash)));
                              },
                            )
                          : Text('Initializing Timer'),
                    ],
                  )
                ]),
          ),
          SizedBox(height: 10),
          Expanded(
            child: isDone
                ? Column(children: [
                    TabBar(
                      onTap: (index) {
                        if (mounted)
                          setState(() {
                            initPos = index + 1;
                          });
                      },
                      isScrollable: true,
                      controller: _tabController,
                      tabs: data
                          .mapIndexed((currentValue, index) => Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: FloatingActionButton(
                                  heroTag: null,
                                  onPressed: null,
                                  backgroundColor: initPos - 1 == index
                                      ? kPrimaryColor
                                      : (responses[index] != '')
                                          ? Colors.greenAccent
                                          : Colors.white,
                                  foregroundColor: initPos - 1 == index
                                      ? Colors.white
                                      : Colors.black,
                                  child: Text(
                                    '${index + 1}',
                                    style: TextStyle(fontSize: 20),
                                  ),
                                ),
                              ))
                          .toList(),
                    ),
                    Expanded(
                      child: TabBarView(
                          physics: NeverScrollableScrollPhysics(),
                          controller: _tabController,
                          children: data
                              .mapIndexed((currentValue, index) =>
                                  InteractiveViewer(
                                    transformationController:
                                        _transformationController,
                                    minScale: 1,
                                    child: ListView(
                                        children: [
                                              data[index]['ques_desc']
                                                      .toString()
                                                      .contains('<img')
                                                  ? Html.fromDom(
                                                      style: {
                                                        'body': Style(
                                                            fontSize: FontSize
                                                                .larger),
                                                      },
                                                      document:
                                                          htmlparser.parse(
                                                        '<body>' +
                                                            data[index]
                                                                ['ques_desc'] +
                                                            '</body>',
                                                      ),
                                                    )
                                                  : Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Text(
                                                        htmlparser
                                                            .parse(data[index]
                                                                ['ques_desc'])
                                                            .body!
                                                            .text,
                                                        style: TextStyle(
                                                            fontSize: 15),
                                                      ),
                                                    ),
                                            ] +
                                            getOptions(
                                                data[index],
                                                _tabController,
                                                result[index],
                                                responses,
                                                index) +
                                            [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 50,
                                                        vertical: 8),
                                                child: TextButton(
                                                    style: TextButton.styleFrom(
                                                        elevation: 2,
                                                        backgroundColor:
                                                            kPrimaryColor,
                                                        shape: RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        20))),
                                                    onPressed: () {
                                                      setState(() {
                                                        responses[index] = '';
                                                      });
                                                    },
                                                    child: Text(
                                                      'Clear Selection',
                                                      style: TextStyle(
                                                          color: Colors.white),
                                                    )),
                                              )
                                            ]),
                                  ))
                              .toList()),
                    )
                  ])
                : Center(child: CircularProgressIndicator()),
          ),
        ],
      ),
    );
  }

  @override
  void detach() {}

  @override
  bool get keptAlive => true;
}
