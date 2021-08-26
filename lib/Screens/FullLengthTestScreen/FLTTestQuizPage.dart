import 'dart:async';
import 'dart:convert';
import 'package:elearning/Screens/FullLengthTestScreen/FLTTestCompleted.dart';
import 'package:elearning/Screens/MainLayout/AlertDialog.dart';
import 'package:elearning/schemas/fltSectionDataSchema.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_svprogresshud/flutter_svprogresshud.dart';
import 'package:html/parser.dart' as htmlparser;
import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:elearning/MyStore.dart';
import 'package:elearning/schemas/sectionQuizSchema.dart';
import 'package:elearning/constants.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:http/http.dart' as http;

// ignore_for_file: non_constant_identifier_names
class FLTTestQuizPage extends StatefulWidget {
  final String title;
  final bool hasSection;
  final String totalTime;
  final String reqPercentage;
  final String correctMarks;
  final String incorrectMarks;
  final List<SectionData> section_data;
  final String totalQues;
  final String test_id;
  const FLTTestQuizPage(
      {Key? key,
      required this.totalTime,
      required this.hasSection,
      required this.reqPercentage,
      required this.totalQues,
      required this.correctMarks,
      required this.incorrectMarks,
      required this.section_data,
      required this.test_id,
      required this.title})
      : super(key: key);

  @override
  _FLTTestQuizPageState createState() => _FLTTestQuizPageState();
}

class _FLTTestQuizPageState extends State<FLTTestQuizPage>
    with TickerProviderStateMixin {
  late List<List<String>> results;
  GlobalKey _key = GlobalKey();
  late List<CountDownController> controllerList = [];
  MyStore store = VxState.store;
  late bool isDone;
  int currentIndex = 0;
  int initIndex = 0;
  List<int> prevIndex = [];
  int currIndex = 0;
  List<int> selColors = [];
  List<SectionQuiz> sectionQuiz = [];
  List<PageController> pageContList = [];
  List<List<String>> responses = [];
  List<List<String>> correctRes = [];
  List<List<CountDownController>> getInitQuesTime = [];
  List<List<int>> getInitQuesTimeInt = [];
  List<bool> enabledSection = [];
  List<List<bool>> reviewResponses = [];
  List<CountDownController> noSectionTime = [];
  List<int> noSectionTimeInt = [];
  CountDownController noSectionController = CountDownController();
  ScrollController tabController = ScrollController();
  double initOffset = 0;
  TransformationController _transformationController =
      TransformationController();
  double initScale = 1;

  fetchSectionQues() async {
    await Future.forEach(widget.section_data, (SectionData element) async {
      await http.post(Uri.parse(getSectionQuesList_URL), body: {
        'user_id': store.studentID,
        'user_hash': store.studentHash,
        'test_id': widget.test_id,
        'section_id': element.sectionId,
      }).then((value) async {
        print(element.sectionId!);
        print(value.body);
        dynamic data = await compute(jsonDecode, value.body);
        SectionQuiz dataQues = SectionQuiz.fromJson(data);
        sectionQuiz.add(dataQues);
        pageContList.add(PageController());
        List<String> resData = List.filled(dataQues.questionData!.length, '');
        List<bool> reviewResData =
            List.filled(dataQues.questionData!.length, false);
        responses.add(resData);
        reviewResponses.add(reviewResData);
        List<String> correctOpt = List.generate(
            dataQues.questionData!.length,
            (index) => dataQues.questionData![index].options!
                .firstWhere((element) => element.isCorrect == '1')
                .ansKey!);
        List<CountDownController> time =
            List.filled(dataQues.questionData!.length, CountDownController());
        correctRes.add(correctOpt);
        getInitQuesTime.add(time);
        getInitQuesTimeInt.add(List.filled(dataQues.questionData!.length, 0));
      });
      controllerList.add(CountDownController());
      selColors.add(0);
      prevIndex.add(0);
      enabledSection.add(true);
      noSectionTime.add(CountDownController());
      noSectionTimeInt.add(0);
    });
    if (mounted)
      setState(() {
        isDone = true;
      });
    print(correctRes);
    print(selColors);
  }

  @override
  void initState() {
    isDone = false;
    fetchSectionQues();
    super.initState();
  }

  int getTime(CountDownController controller) {
    try {
      return int.parse(controller.getTime().split(':').first) * 60 +
          int.parse(controller.getTime().split(':').last);
    } catch (e) {
      return 0;
    }
  }

  format(Duration d) => d.toString().split('.').first.padLeft(8, "0");

  @override
  Widget build(BuildContext context) {
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
        actions: [
          isDone
              ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextButton(
                    style: TextButton.styleFrom(
                        elevation: 10,
                        primary: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(100)),
                        backgroundColor: kPrimaryColor),
                    onPressed: () async {
                      if (!widget.hasSection) {
                        noSectionController.pause();
                        List<String> storage =
                            noSectionTime[initIndex].getTime().split(':');
                        int sectionDataNew = int.parse(storage.first) * 60 +
                            int.parse(storage.last);
                        noSectionTimeInt[initIndex] = sectionDataNew;
                      } else
                        controllerList[initIndex].pause();
                      List<String> storageData = getInitQuesTime[initIndex]
                              [currentIndex]
                          .getTime()
                          .split(':');
                      int dataNew = int.parse(storageData.first) * 60 +
                          int.parse(storageData.last);
                      getInitQuesTimeInt[initIndex][currentIndex] = dataNew;
                      print('Start of Submit******************************');
                      print(responses);
                      print(correctRes);
                      print(getInitQuesTimeInt);
                      print(noSectionTimeInt);
                      print('End of Submit******************************');
                      List<String> section_string = [];
                      double mark_obtain = 0;
                      int total_correct = 0;
                      int total_incorrect = 0;
                      int total_unattempted = 0;
                      widget.section_data.forEachIndexed((index, element) {
                        List<String> dataText = [];
                        dataText.add(element.sectionId!);
                        dataText.add(element.sectionName!);
                        dataText.add(element.secTotalQuestion!);
                        int countCorrect = 0;
                        int countIncorrect = 0;
                        int countUnAttempted = 0;
                        double totalMarks = 0;
                        double fullMarks = 0;
                        for (int i = 0; i < responses[index].length; i++) {
                          if (responses[index][i] == '')
                            countUnAttempted++;
                          else if (responses[index][i] != '' &&
                              responses[index][i] == correctRes[index][i]) {
                            totalMarks += double.parse(sectionQuiz[index]
                                .questionData![i]
                                .positiveMark!);

                            countCorrect++;
                          } else if (responses[index][i] != '' &&
                              responses[index][i] != correctRes[index][i]) {
                            totalMarks -= double.parse(sectionQuiz[index]
                                .questionData![i]
                                .negativeMark!);
                            countIncorrect++;
                          }
                          fullMarks += double.parse(sectionQuiz[index]
                              .questionData![i]
                              .positiveMark!);
                        }
                        dataText.add(countCorrect.toString());
                        total_correct += countCorrect;
                        dataText.add(countIncorrect.toString());
                        total_incorrect += countIncorrect;
                        dataText.add(countUnAttempted.toString());
                        total_unattempted += countUnAttempted;
                        dataText.add(format(Duration(
                            seconds: widget.hasSection
                                ? getTime(controllerList[index])
                                : noSectionTimeInt[index])));
                        dataText.add(totalMarks.toString());
                        mark_obtain += totalMarks;
                        dataText.add(((totalMarks / fullMarks) * 100)
                            .toDoubleStringAsPrecised(length: 2));
                        section_string.add(dataText.join('#'));
                      });
                      List<String> ques_string = [];

                      responses.forEachIndexed((index, element) {
                        for (int i = 0; i < element.length; i++) {
                          List<String> dataText = [];
                          dataText
                              .add(sectionQuiz[index].questionData![i].quesId!);
                          dataText.add(format(
                              Duration(seconds: getInitQuesTimeInt[index][i])));
                          dataText.add(responses[index][i]);
                          dataText.add(correctRes[index][i]);
                          if (responses[index][i] == '')
                            dataText.add('0');
                          else if (responses[index][i] != '' &&
                              responses[index][i] == correctRes[index][i])
                            dataText.add(sectionQuiz[index]
                                .questionData![i]
                                .positiveMark!);
                          else if (responses[index][i] != '' &&
                              responses[index][i] != correctRes[index][i])
                            dataText.add(sectionQuiz[index]
                                .questionData![i]
                                .negativeMark!);
                          ques_string.add(dataText.join('#'));
                        }
                      });
                      int total_time = 0;
                      controllerList.forEach((element) {
                        total_time += getTime(element);
                      });

                      debugPrint(section_string.toString(), wrapWidth: 1024);
                      debugPrint(ques_string.toString(), wrapWidth: 1024);
                      SVProgressHUD.setRingThickness(5);
                      SVProgressHUD.setRingRadius(5);
                      SVProgressHUD.setDefaultMaskType(
                          SVProgressHUDMaskType.black);
                      SVProgressHUD.show();
                      await http.post(Uri.parse(submitFLTTest_URL), body: {
                        'user_id': store.studentID,
                        'user_hash': store.studentHash,
                        'test_id': widget.test_id,
                        'test_name': widget.title,
                        'ques_string': ques_string.join('|'),
                        'section_string': section_string.join('|'),
                        'positive_mark': widget.correctMarks,
                        'negative_mark': widget.incorrectMarks,
                        'total_ques': widget.totalQues,
                        'res_mark_obtain': mark_obtain.toString(),
                        'res_required_percentage': widget.reqPercentage,
                        'res_time_taken': format(Duration(seconds: total_time)),
                        'total_correct': total_correct.toString(),
                        'total_incorrect': total_incorrect.toString(),
                        'total_unattempted': total_unattempted.toString(),
                        'per_obtain': '',
                      }).then((value) {
                        if (value.body.contains('"flag":1')) {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => FLTTestCompleted(
                                      test_id: widget.test_id)));
                          SVProgressHUD.dismiss();
                        } else {
                          SVProgressHUD.dismiss();
                          showCustomSnackBar(
                              context, 'Unable to submit the test');
                        }
                      });
                    },
                    child: Text(
                      'Submit',
                    ),
                  ),
                )
              : Container()
        ],
      ),
      bottomNavigationBar: isDone
          ? BottomNavigationBar(
              selectedItemColor: kPrimaryColor,
              unselectedItemColor: kPrimaryColor,
              onTap: (value) {
                List<String> storageData = getInitQuesTime[initIndex]
                        [prevIndex[initIndex]]
                    .getTime()
                    .split(':');
                int dataNew = int.parse(storageData.first) * 60 +
                    int.parse(storageData.last);
                if (mounted)
                  setState(() {
                    getInitQuesTimeInt[initIndex][prevIndex[initIndex]] =
                        dataNew;
                    if (value == 0 &&
                        prevIndex[initIndex] - 1 >= 0 &&
                        prevIndex[initIndex] != 0) {
                      prevIndex[initIndex] = --prevIndex[initIndex];
                      selColors[initIndex] = --selColors[initIndex];
                      currentIndex = prevIndex[initIndex];
                    } else if (value == 1 &&
                        prevIndex[initIndex] + 1 <=
                            sectionQuiz[initIndex].questionData!.length - 1 &&
                        prevIndex[initIndex] !=
                            sectionQuiz[initIndex].questionData!.length - 1) {
                      prevIndex[initIndex] = ++prevIndex[initIndex];
                      selColors[initIndex] = ++selColors[initIndex];
                      currentIndex = prevIndex[initIndex];
                    }
                  });
                print('Question Time Int all sections');
                print(getInitQuesTimeInt);
                if (value == 0)
                  pageContList[initIndex].previousPage(
                      duration: Duration(microseconds: 1),
                      curve: Curves.linear);
                else
                  pageContList[initIndex].nextPage(
                      duration: Duration(microseconds: 1),
                      curve: Curves.linear);
                initOffset = -(MediaQuery.of(context).size.width / 2) +
                    _key.currentContext!.size!.width * selColors[initIndex];
                print(currentIndex);
                print(tabController.offset);
                tabController.animateTo(initOffset,
                    duration: Duration(milliseconds: 500),
                    curve: Curves.linear);
              },
              items: [
                  BottomNavigationBarItem(
                      backgroundColor: kPrimaryColor,
                      icon: Icon(Icons.navigate_before),
                      label: 'Previous Question'),
                  BottomNavigationBarItem(
                      backgroundColor: kPrimaryColor,
                      icon: Icon(
                        Icons.navigate_next,
                      ),
                      label: 'Next Question'),
                ])
          : null,
      body: isDone
          ? Column(children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Section Questions: ' +
                        '${sectionQuiz[initIndex].questionData!.length}'),
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
                        CircularCountDownTimer(
                          key: Key(initIndex.toString()),
                          duration: widget.hasSection
                              ? int.parse(widget
                                      .section_data[initIndex].sectionTime!) *
                                  60
                              : int.parse(widget.totalTime) * 60,
                          initialDuration: widget.hasSection
                              ? getTime(controllerList[initIndex])
                              : getTime(noSectionController),
                          width: 50,
                          height: 50,
                          controller: widget.hasSection
                              ? controllerList[initIndex]
                              : noSectionController,
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
                          isReverse: false,
                          isReverseAnimation: false,
                          isTimerTextShown: true,
                          autoStart: true,
                          onComplete: () {
                            if (mounted)
                              setState(() {
                                if (widget.hasSection)
                                  enabledSection[initIndex] = false;
                                else {
                                  enabledSection
                                      .forEachIndexed((index, element) {
                                    enabledSection[index] = false;
                                  });
                                }
                              });
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                child: Material(
                  elevation: 10,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      isExpanded: true,
                      onChanged: (value) {
                        pageContList[initIndex].jumpToTop();
                        selColors[initIndex] = 0;
                        currentIndex = 0;
                        tabController.animToTop();
                        initOffset = -(MediaQuery.of(context).size.width / 2);
                        if (!widget.hasSection) {
                          List<String> storage =
                              noSectionTime[initIndex].getTime().split(':');
                          int sectionDataNew = int.parse(storage.first) * 60 +
                              int.parse(storage.last);
                          noSectionTimeInt[initIndex] = sectionDataNew;
                        }

                        List<String> storageData = getInitQuesTime[initIndex]
                                [currentIndex]
                            .getTime()
                            .split(':');
                        int dataNew = int.parse(storageData.first) * 60 +
                            int.parse(storageData.last);
                        getInitQuesTimeInt[initIndex][currentIndex] = dataNew;
                        pageContList[initIndex].jumpToTop();
                        selColors[initIndex] = 0;

                        if (mounted)
                          setState(() {
                            initOffset =
                                -(MediaQuery.of(context).size.width / 2);
                            if (enabledSection[int.parse(value!)] == true)
                              initIndex = int.parse(value);
                          });
                      },
                      value: initIndex.toString(),
                      items: widget.section_data
                          .mapIndexed((element, index) => DropdownMenuItem(
                                child: Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Text('${element.sectionName}'
                                      .split('_')
                                      .sublist(1)
                                      .join()),
                                ),
                                value: index.toString(),
                              ))
                          .toList(),
                    ),
                  ),
                ),
              ),
              !widget.hasSection
                  ? CircularCountDownTimer(
                      key: Key(initIndex.toString() + 'sectionTime'),
                      duration: int.parse(widget.totalTime) * 60,
                      initialDuration: noSectionTimeInt[initIndex],
                      width: 0,
                      height: 0,
                      controller: noSectionTime[initIndex],
                      ringColor: Colors.transparent,
                      ringGradient: null,
                      fillColor: Colors.transparent,
                      fillGradient: null,
                      backgroundGradient: null,
                      strokeWidth: 0,
                      strokeCap: StrokeCap.round,
                      textStyle: TextStyle(
                          fontSize: 0,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                      textFormat: CountdownTextFormat.MM_SS,
                      isReverse: false,
                      isReverseAnimation: false,
                      isTimerTextShown: false,
                      autoStart: true,
                      onComplete: () {},
                    )
                  : Container(width: 0, height: 0),
              Container(
                height: 65,
                child: ListView.builder(
                    controller: tabController,
                    padding: EdgeInsets.symmetric(vertical: 8),
                    itemExtent: 75,
                    scrollDirection: Axis.horizontal,
                    itemCount: sectionQuiz[initIndex].questionData!.length,
                    itemBuilder: (context, index) {
                      _key = GlobalKey();
                      return FloatingActionButton(
                          key: _key,
                          foregroundColor: selColors[initIndex] == index
                              ? Colors.white
                              : Colors.black,
                          backgroundColor: selColors[initIndex] == index
                              ? kPrimaryColor
                              : (reviewResponses[initIndex][index] == true)
                                  ? Colors.purpleAccent
                                  : (responses[initIndex][index] != '')
                                      ? Colors.greenAccent
                                      : Colors.white,
                          heroTag: null,
                          child: Text(
                            '${index + 1}',
                            style: TextStyle(
                              fontSize: 18,
                            ),
                          ),
                          onPressed: () {
                            List<String> storageData =
                                getInitQuesTime[initIndex][prevIndex[initIndex]]
                                    .getTime()
                                    .split(':');
                            int dataNew = int.parse(storageData.first) * 60 +
                                int.parse(storageData.last);
                            if (mounted)
                              setState(() {
                                getInitQuesTimeInt[initIndex]
                                    [prevIndex[initIndex]] = dataNew;
                                prevIndex[initIndex] = index;
                                selColors[initIndex] = index;
                                currentIndex = prevIndex[initIndex];
                              });
                            print('Question Time Int all sections');
                            print(getInitQuesTimeInt);

                            pageContList[initIndex].jumpToPage(index);
                          });
                    }),
              ),
              Expanded(
                child: PageView(
                    controller: pageContList[initIndex],
                    physics: NeverScrollableScrollPhysics(),
                    children: sectionQuiz[initIndex]
                        .questionData!
                        .mapIndexed((element, index) {
                      return Column(
                        key: PageStorageKey(
                            initIndex.toString() + index.toString()),
                        children: [
                          CircularCountDownTimer(
                            key: Key(initIndex.toString() + index.toString()),
                            duration: widget.hasSection
                                ? int.parse(widget
                                        .section_data[initIndex].sectionTime!) *
                                    60
                                : int.parse(widget.totalTime) * 60,
                            initialDuration: getInitQuesTimeInt[initIndex]
                                [index],
                            width: 0,
                            height: 0,
                            controller: getInitQuesTime[initIndex][index],
                            ringColor: Colors.transparent,
                            ringGradient: null,
                            fillColor: Colors.transparent,
                            fillGradient: null,
                            backgroundGradient: null,
                            strokeWidth: 0,
                            strokeCap: StrokeCap.round,
                            textStyle: TextStyle(
                                fontSize: 0,
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                            textFormat: CountdownTextFormat.MM_SS,
                            isReverse: false,
                            isReverseAnimation: false,
                            isTimerTextShown: false,
                            autoStart: true,
                            onComplete: () {},
                          ),
                          Expanded(
                            child: InteractiveViewer(
                              transformationController:
                                  _transformationController,
                              minScale: 1,
                              child: ListView(
                                children: <Widget>[
                                      '${element.quesDesc}'.contains('<img')
                                          ? Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Html.fromDom(
                                                  document: htmlparser
                                                      .parse(element.quesDesc)),
                                            )
                                          : Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(htmlparser
                                                  .parse(element.quesDesc)
                                                  .body!
                                                  .text),
                                            )
                                    ] +
                                    List.from(element.options!).map((option) {
                                      return RadioListTile<String>(
                                        activeColor: kPrimaryColor,
                                        toggleable: false,
                                        value: option.ansKey,
                                        groupValue: responses[initIndex][index],
                                        onChanged: enabledSection[initIndex]
                                            ? (String? option) {
                                                if (mounted)
                                                  setState(() {
                                                    responses[initIndex]
                                                        [index] = option!;
                                                    print(
                                                        'Responses all sections');
                                                    print(responses);
                                                  });
                                              }
                                            : null,
                                        title: '${option.optionDesc}'
                                                .contains('<img')
                                            ? Html.fromDom(
                                                document: htmlparser
                                                    .parse(option.optionDesc))
                                            : Text(htmlparser
                                                .parse(option.optionDesc!)
                                                .body!
                                                .text),
                                      );
                                    }).toList() +
                                    [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          TextButton(
                                              style: TextButton.styleFrom(
                                                  elevation: 2,
                                                  backgroundColor:
                                                      enabledSection[initIndex]
                                                          ? kPrimaryColor
                                                          : kPrimaryColor
                                                              .withOpacity(0.5),
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20))),
                                              onPressed:
                                                  enabledSection[initIndex]
                                                      ? () {
                                                          if (mounted)
                                                            setState(() {
                                                              reviewResponses[
                                                                          initIndex]
                                                                      [index] =
                                                                  !reviewResponses[
                                                                          initIndex]
                                                                      [index];
                                                            });
                                                        }
                                                      : null,
                                              child: reviewResponses[initIndex]
                                                          [index] ==
                                                      true
                                                  ? Text('Unmark for Review',
                                                      style: TextStyle(
                                                          color:
                                                              enabledSection[initIndex]
                                                                  ? Colors.white
                                                                  : Colors
                                                                      .grey[400]))
                                                  : Text(
                                                      'Mark for Review',
                                                      style: TextStyle(
                                                          color: enabledSection[
                                                                  initIndex]
                                                              ? Colors.white
                                                              : Colors
                                                                  .grey[400]),
                                                    )),
                                          TextButton(
                                              style: TextButton.styleFrom(
                                                  elevation: 2,
                                                  backgroundColor:
                                                      enabledSection[initIndex]
                                                          ? kPrimaryColor
                                                          : kPrimaryColor
                                                              .withOpacity(0.5),
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20))),
                                              onPressed: enabledSection[
                                                      initIndex]
                                                  ? () {
                                                      if (mounted)
                                                        setState(() {
                                                          responses[initIndex]
                                                              [index] = '';
                                                          print(responses);
                                                        });
                                                    }
                                                  : null,
                                              child: Text(
                                                'Clear Selection',
                                                style: TextStyle(
                                                    color: enabledSection[
                                                            initIndex]
                                                        ? Colors.white
                                                        : Colors.grey[400]),
                                              )),
                                        ],
                                      )
                                    ],
                              ),
                            ),
                          ),
                        ],
                      );
                    }).toList()),
              )
            ])
          : Center(child: CircularProgressIndicator()),
    );
  }
}
