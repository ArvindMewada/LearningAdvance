import 'package:elearning/MyStore.dart';
import 'package:elearning/constants.dart';
import 'package:elearning/schemas/examResultSchema.dart';
import 'package:flutter/material.dart';
import 'package:html/parser.dart' as htmlparser;
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:velocity_x/velocity_x.dart';

class ExamResultAnalysis extends StatefulWidget {
  final ExamResult examResult;
  const ExamResultAnalysis({Key? key, required this.examResult})
      : super(key: key);

  @override
  _ExamResultAnalysisState createState() => _ExamResultAnalysisState();
}

class _ExamResultAnalysisState extends State<ExamResultAnalysis>
    with TickerProviderStateMixin {
  late List data;
  MyStore store = VxState.store;
  late TabController _tabController;
  late int initPos;
  double initScale = 1;
  TransformationController _transformationController =
      TransformationController();

  List<RadioListTile> getOptions(
      Ques element, TabController _controller, int index) {
    List<RadioListTile> reslist = [];
    element.toJson().forEach((key, value) {
      if (key.contains('opt') &&
          key != 'correct_opt' &&
          value != '' &&
          value != null) {
        reslist.add(RadioListTile(
          secondary: key[key.length - 1] == element.correctOpt
              ? TextButton.icon(
                  onPressed: () {
                    showModalBottomSheet(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20),
                                topRight: Radius.circular(20))),
                        context: context,
                        builder: (context) => element.quesExpl!.contains('<img')
                            ? Padding(
                                padding: const EdgeInsets.all(20),
                                child: SingleChildScrollView(
                                  child: Column(
                                    children: [
                                      Text('Answer Explanation',
                                          style: TextStyle(
                                              fontSize: 25,
                                              fontWeight: FontWeight.bold)),
                                      SizedBox(height: 10),
                                      Html.fromDom(
                                          document: htmlparser
                                              .parse(element.quesExpl)),
                                    ],
                                  ),
                                ),
                              )
                            : Padding(
                                padding: const EdgeInsets.all(20),
                                child: SingleChildScrollView(
                                  child: Column(
                                    children: [
                                      Text(
                                        'Answer Explanation',
                                        style: TextStyle(
                                            fontSize: 25,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(height: 10),
                                      Text(htmlparser
                                          .parse(element.quesExpl)
                                          .body!
                                          .text),
                                    ],
                                  ),
                                ),
                              ));
                  },
                  icon: Icon(Icons.check, color: Colors.green),
                  label: Text('See How?'))
              : (key[key.length - 1] == element.userResponse &&
                      element.userResponse != element.correctOpt)
                  ? Icon(Icons.close, color: Colors.red)
                  : null,
          groupValue: element.userResponse,
          value: key[key.length - 1],
          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 0),
          onChanged: null,
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
  void initState() {
    _tabController =
        TabController(length: widget.examResult.ques!.length, vsync: this);
    initPos = 1;
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return Scaffold(
      appBar: AppBar(
        title: Text('Test Analysis'),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            (initPos != 1)
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
                : Text(''),
            (((initPos + 1) > (widget.examResult.ques!.length)))
                ? FloatingActionButton(
                    heroTag: null,
                    mini: true,
                    onPressed: () {
                      Navigator.pop(context);
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
                  Text('Total Questions: ' +
                      '${widget.examResult.ques!.length}'),
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
                  )
                ]),
          ),
          SizedBox(height: 10),
          Expanded(
            child: Column(children: [
              TabBar(
                onTap: (index) {
                  if (mounted)
                    setState(() {
                      initPos = index + 1;
                    });
                },
                isScrollable: true,
                controller: _tabController,
                tabs: widget.examResult.ques!
                    .mapIndexed((currentValue, index) => Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: FloatingActionButton(
                            heroTag: null,
                            onPressed: null,
                            backgroundColor: initPos - 1 == index
                                ? kPrimaryColor
                                : (currentValue.quesStatus!.toLowerCase() ==
                                        'incorrect')
                                    ? Colors.redAccent
                                    : (currentValue.quesStatus!.toLowerCase() ==
                                            'correct')
                                        ? Colors.greenAccent
                                        : Colors.white,
                            foregroundColor: initPos - 1 == index
                                ? Colors.white
                                : (currentValue.quesStatus!.toLowerCase() ==
                                        'incorrect')
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
                    children: widget.examResult.ques!
                        .mapIndexed((currentValue, index) => InteractiveViewer(
                              transformationController:
                                  _transformationController,
                              minScale: 1,
                              child: ListView(
                                  children: [
                                        currentValue.quesStatus!
                                                    .toLowerCase() ==
                                                'incorrect'
                                            ? Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Text(
                                                  'Incorrect Answer',
                                                  style: TextStyle(
                                                      color: Colors.red,
                                                      fontSize: 30),
                                                ),
                                              )
                                            : currentValue.quesStatus ==
                                                    'correct'
                                                ? Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Text(
                                                      'Correct Answer',
                                                      style: TextStyle(
                                                          color: Colors.green,
                                                          fontSize: 30),
                                                    ),
                                                  )
                                                : Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Text(
                                                      'Not Answered',
                                                      style: TextStyle(
                                                          fontSize: 30),
                                                    ),
                                                  ),
                                        currentValue.quesDesc!.contains('<img')
                                            ? Html.fromDom(
                                                style: {
                                                  'body': Style(
                                                      fontSize:
                                                          FontSize.larger),
                                                },
                                                document: htmlparser.parse(
                                                  '<body>' +
                                                      currentValue.quesDesc! +
                                                      '</body>',
                                                ),
                                              )
                                            : Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Text(
                                                  htmlparser
                                                      .parse(
                                                          currentValue.quesDesc)
                                                      .body!
                                                      .text,
                                                  style:
                                                      TextStyle(fontSize: 15),
                                                ),
                                              ),
                                      ] +
                                      getOptions(
                                          currentValue, _tabController, index)),
                            ))
                        .toList()),
              )
            ]),
          ),
        ],
      ),
    );
  }
}
