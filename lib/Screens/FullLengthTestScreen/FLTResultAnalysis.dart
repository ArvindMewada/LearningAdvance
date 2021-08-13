import 'package:elearning/constants.dart';
import 'package:html/parser.dart' as htmlparser;
import 'package:elearning/schemas/resultSchema.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:velocity_x/velocity_x.dart';

class FLTResultAnalysis extends StatefulWidget {
  final ResultSchema result;
  const FLTResultAnalysis({Key? key, required this.result}) : super(key: key);

  @override
  _FLTResultAnalysisState createState() => _FLTResultAnalysisState();
}

class _FLTResultAnalysisState extends State<FLTResultAnalysis> {
  List<int> prevIndex = [];
  int currentIndex = 0;
  TransformationController _transformationController =
      TransformationController();
  int initIndex = 0;
  List<int> selColors = [];
  GlobalKey _key = GlobalKey();
  ScrollController tabController = ScrollController();
  List<PageController> pageContList = [];
  List<List<QuestionData>> sectionQuiz = [];
  double initScale = 1;
  double initOffset = 0;

  @override
  void initState() {
    super.initState();

    widget.result.section!.forEach((element) {
      pageContList.add(PageController());
      List<QuestionData> data = widget.result.questionData!
          .where((elementQues) => elementQues.sectionId == element.sectionId)
          .toList();
      sectionQuiz.add(data);
      selColors.add(0);
      prevIndex.add(0);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Test Analysis'),
        ),
        bottomNavigationBar: BottomNavigationBar(
            selectedItemColor: kPrimaryColor,
            unselectedItemColor: kPrimaryColor,
            onTap: (value) {
              if (mounted)
                setState(() {
                  if (value == 0 &&
                      prevIndex[initIndex] - 1 >= 0 &&
                      prevIndex[initIndex] != 0) {
                    prevIndex[initIndex] = --prevIndex[initIndex];
                    selColors[initIndex] = --selColors[initIndex];
                    currentIndex = prevIndex[initIndex];
                  } else if (value == 1 &&
                      prevIndex[initIndex] + 1 <=
                          sectionQuiz[initIndex].length - 1 &&
                      prevIndex[initIndex] !=
                          sectionQuiz[initIndex].length - 1) {
                    prevIndex[initIndex] = ++prevIndex[initIndex];
                    selColors[initIndex] = ++selColors[initIndex];
                    currentIndex = prevIndex[initIndex];
                  }
                });
              if (value == 0)
                pageContList[initIndex].previousPage(
                    duration: Duration(microseconds: 1), curve: Curves.linear);
              else
                pageContList[initIndex].nextPage(
                    duration: Duration(microseconds: 1), curve: Curves.linear);
              initOffset = -(MediaQuery.of(context).size.width / 2) +
                  _key.currentContext!.size!.width * selColors[initIndex];
              tabController.animateTo(initOffset,
                  duration: Duration(milliseconds: 500), curve: Curves.linear);
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
            ]),
        body: Column(children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                    'Section Questions: ' + '${sectionQuiz[initIndex].length}'),
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
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
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

                    pageContList[initIndex].jumpToTop();
                    selColors[initIndex] = 0;

                    if (mounted)
                      setState(() {
                        initOffset = -(MediaQuery.of(context).size.width / 2);

                        initIndex = int.parse(value!);
                      });
                  },
                  value: initIndex.toString(),
                  items: widget.result.section!
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
          Container(
            height: 65,
            child: ListView.builder(
                controller: tabController,
                padding: EdgeInsets.symmetric(vertical: 8),
                itemExtent: 75,
                scrollDirection: Axis.horizontal,
                itemCount: sectionQuiz[initIndex].length,
                itemBuilder: (context, index) {
                  _key = GlobalKey();
                  return FloatingActionButton(
                      key: _key,
                      foregroundColor: selColors[initIndex] == index
                          ? Colors.white
                          : sectionQuiz[initIndex][index].options!.indexWhere(
                                      (element1) =>
                                          element1.isCorrect !=
                                              element1.userResponse
                                                  .toString() &&
                                          element1.userResponse == 1) !=
                                  -1
                              ? Colors.white
                              : Colors.black,
                      backgroundColor: selColors[initIndex] == index
                          ? kPrimaryColor
                          : sectionQuiz[initIndex][index].options!.indexWhere(
                                      (element1) =>
                                          element1.isCorrect !=
                                              element1.userResponse
                                                  .toString() &&
                                          element1.userResponse == 1) !=
                                  -1
                              ? Colors.redAccent
                              : sectionQuiz[initIndex][index]
                                          .options!
                                          .indexWhere((element1) =>
                                              element1.isCorrect ==
                                                  element1.userResponse
                                                      .toString() &&
                                              element1.userResponse == 1) !=
                                      -1
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
                        if (mounted)
                          setState(() {
                            prevIndex[initIndex] = index;
                            selColors[initIndex] = index;
                            currentIndex = prevIndex[initIndex];
                          });

                        pageContList[initIndex].jumpToPage(index);
                      });
                }),
          ),
          Expanded(
            child: PageView(
                controller: pageContList[initIndex],
                physics: NeverScrollableScrollPhysics(),
                children: sectionQuiz[initIndex].mapIndexed((element, index) {
                  return Column(
                    key:
                        PageStorageKey(initIndex.toString() + index.toString()),
                    children: [
                      Expanded(
                        child: InteractiveViewer(
                          transformationController: _transformationController,
                          minScale: 1,
                          child: ListView(
                              children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          element.options!.indexWhere((element1) =>
                                                      element1.isCorrect !=
                                                          element1.userResponse
                                                              .toString() &&
                                                      element1.userResponse ==
                                                          1) !=
                                                  -1
                                              ? Expanded(
                                                  child: Text(
                                                    'Incorrect Answer',
                                                    style: TextStyle(
                                                        fontSize: 20,
                                                        color: Colors.red),
                                                  ),
                                                )
                                              : element.options!.indexWhere((element1) =>
                                                          element1.isCorrect ==
                                                              element1
                                                                  .userResponse
                                                                  .toString() &&
                                                          element1.userResponse ==
                                                              1) !=
                                                      -1
                                                  ? Expanded(
                                                      child: Text(
                                                          'Correct Answer',
                                                          style: TextStyle(
                                                              fontSize: 20,
                                                              color: Colors
                                                                  .green)),
                                                    )
                                                  : Expanded(
                                                      child: Text(
                                                          'Not Attempted',
                                                          style: TextStyle(
                                                              fontSize: 20)),
                                                    ),
                                          element.quesTime![
                                                      element.quesTime!.length -
                                                          1] !=
                                                  '0'
                                              ? Expanded(
                                                  child: Text(
                                                      'Time Taken: ' +
                                                          element.quesTime!,
                                                      textAlign: TextAlign.end,
                                                      style: TextStyle(
                                                          fontSize: 20)),
                                                )
                                              : Expanded(
                                                  child: Text('Time Taken: N/A',
                                                      textAlign: TextAlign.end,
                                                      style: TextStyle(
                                                          fontSize: 20)),
                                                )
                                        ],
                                      ),
                                    ),
                                    '${element.quesDesc}'.contains('<img')
                                        ? Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Html.fromDom(
                                                document: htmlparser
                                                    .parse(element.quesDesc)),
                                          )
                                        : Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(htmlparser
                                                .parse(element.quesDesc)
                                                .body!
                                                .text),
                                          )
                                  ] +
                                  element.options!
                                      .mapIndexed((Options option, index) {
                                    return RadioListTile<String>(
                                      activeColor: kPrimaryColor,
                                      toggleable: false,
                                      secondary:
                                          (option.userResponse.toString() !=
                                                      option.isCorrect &&
                                                  option.userResponse == 1)
                                              ? Icon(
                                                  Icons.close,
                                                  color: Colors.red,
                                                )
                                              : (option.isCorrect == '1')
                                                  ? TextButton.icon(
                                                      onPressed: () {
                                                        showModalBottomSheet(
                                                            shape: RoundedRectangleBorder(
                                                                borderRadius: BorderRadius.only(
                                                                    topLeft: Radius
                                                                        .circular(
                                                                            20),
                                                                    topRight: Radius
                                                                        .circular(
                                                                            20))),
                                                            context: context,
                                                            builder: (context) =>
                                                                element.quesExpl!
                                                                        .contains(
                                                                            '<img')
                                                                    ? Padding(
                                                                        padding:
                                                                            const EdgeInsets.all(20),
                                                                        child:
                                                                            SingleChildScrollView(
                                                                          child:
                                                                              Column(
                                                                            children: [
                                                                              Text('Answer Explanation', style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
                                                                              SizedBox(height: 10),
                                                                              Html.fromDom(document: htmlparser.parse(element.quesExpl)),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      )
                                                                    : Padding(
                                                                        padding:
                                                                            const EdgeInsets.all(20),
                                                                        child:
                                                                            SingleChildScrollView(
                                                                          child:
                                                                              Column(
                                                                            children: [
                                                                              Text(
                                                                                'Answer Explanation',
                                                                                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                                                                              ),
                                                                              SizedBox(height: 10),
                                                                              Text(htmlparser.parse(element.quesExpl).body!.text),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ));
                                                      },
                                                      icon: Icon(
                                                        Icons.check,
                                                        color: Colors.green,
                                                      ),
                                                      label: Text('See How?'))
                                                  : null,
                                      value: (index + 1).toString(),
                                      groupValue: (element.options!.indexWhere(
                                                  (elementOption) =>
                                                      elementOption
                                                          .userResponse ==
                                                      1) +
                                              1)
                                          .toString(),
                                      onChanged: null,
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
                                  }).toList()),
                        ),
                      ),
                    ],
                  );
                }).toList()),
          )
        ]));
  }
}
