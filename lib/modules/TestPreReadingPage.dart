import 'package:elearning/MyStore.dart';
import 'package:elearning/Screens/KnowledgeZoneScreen/KnowledgeZoneHTMLViewer.dart';
import 'package:elearning/Screens/StudyZoneScreen/PDFViewerPage.dart';
import 'package:elearning/constants.dart';
import 'package:elearning/dbModel.dart';
import 'package:elearning/modules/TestAlreadyAttemptedPage.dart';
import 'package:elearning/modules/TestInstructionPage.dart';
import 'package:elearning/objectbox.g.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

import 'package:velocity_x/velocity_x.dart';
// ignore_for_file: non_constant_identifier_names

class TestPreReadingPage extends StatefulWidget {
  final bool isQuiz;
  final String title;
  final List<String> tabs;
  final int exam_id;
  const TestPreReadingPage(
      {Key? key,
      required this.isQuiz,
      required this.title,
      required this.tabs,
      required this.exam_id})
      : super(key: key);

  @override
  _TestPreReadingPageState createState() => _TestPreReadingPageState();
}

class _TestPreReadingPageState extends State<TestPreReadingPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late BehaviorSubject<List<TestDataElement>> _streamTestDataElement;
  late BehaviorSubject<List<TestReadingElement>> _streamTestReadingElement;
  MyStore store = VxState.store;

  BehaviorSubject<List<TestReadingElement>> getTestReadingStore(String param) {
    _streamTestReadingElement = BehaviorSubject();
    _streamTestReadingElement.addStream(store.dataStore
        .box<TestReadingElement>()
        .query(TestReadingElement_.subcategory
            .equals(widget.exam_id.toString())
            .and(TestReadingElement_.type
                .equals(param)
                .and(TestReadingElement_.status.equals('active'))))
        .watch(triggerImmediately: true)
        .map((query) => query.find()));

    return _streamTestReadingElement;
  }

  @override
  void initState() {
    if (mounted)
      setState(() {
        _streamTestDataElement = BehaviorSubject();
        _streamTestDataElement.addStream(store.dataStore
            .box<TestDataElement>()
            .query(TestDataElement_.exam_id
                .equals(widget.exam_id)
                .and(TestDataElement_.test_status.equals(1)))
            .watch(triggerImmediately: true)
            .map((query) => query.find()));
      });
    _tabController = TabController(length: widget.tabs.length, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        bottom: TabBar(
            isScrollable: true,
            labelColor: Colors.black,
            indicatorColor: kPrimaryColor,
            controller: _tabController,
            tabs: widget.tabs
                .map((e) => Tab(
                      text: e.toUpperCase().replaceAll('_', ' '),
                    ))
                .toList()),
        title: Text(widget.title),
      ),
      body: TabBarView(
          controller: _tabController,
          children: widget.tabs
              .map((e) => StreamBuilder(
                  stream: (e == 'Mock Tests')
                      ? _streamTestDataElement
                      : getTestReadingStore(e),
                  builder: (context, AsyncSnapshot<List> snapshot) {
                    if (snapshot.hasData &&
                        !store.dataStore.box<TestDataElement>().isEmpty() &&
                        !store.dataStore.box<TestReadingElement>().isEmpty())
                      return ListView.builder(
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Material(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20)),
                                elevation: 10,
                                child: ListTile(
                                  onTap: (e == 'Mock Tests')
                                      ? null
                                      : (e == 'model_test_paper')
                                          ? () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) => PDFViewerPage(
                                                          url: snapshot
                                                              .data![index].url
                                                              .toString()
                                                              .substring(
                                                                  'https://careerliftprod.s3.amazonaws.com/'
                                                                      .length,
                                                                  snapshot
                                                                      .data![
                                                                          index]
                                                                      .url
                                                                      .toString()
                                                                      .length),
                                                          desc: snapshot
                                                              .data![index]
                                                              .add_date!,
                                                          title: snapshot
                                                              .data![index]
                                                              .title!)));
                                            }
                                          : () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          KnowledgeZoneHTMLTextViewer(
                                                              data_hash: snapshot
                                                                  .data![index]
                                                                  .mob_post_hash!,
                                                              subtitle: snapshot
                                                                  .data![index]
                                                                  .add_date!,
                                                              title: snapshot
                                                                  .data![index]
                                                                  .title!)));
                                            },
                                  isThreeLine: true,
                                  trailing: e == 'Mock Tests'
                                      ? TextButton(
                                          style: TextButton.styleFrom(
                                              backgroundColor: snapshot
                                                          .data![index]
                                                          .is_attempted ==
                                                      1
                                                  ? Colors.green
                                                  : kPrimaryColor,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20))),
                                          onPressed: snapshot.data![index]
                                                      .is_attempted ==
                                                  1
                                              ? () {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              TestAlreadyAttemptedPage(
                                                                isQuiz: widget
                                                                    .isQuiz,
                                                                id: snapshot
                                                                    .data![
                                                                        index]
                                                                    .id,
                                                                incorrectMarks:
                                                                    snapshot
                                                                        .data![
                                                                            index]
                                                                        .negative_mark,
                                                                totalQues: snapshot
                                                                    .data![
                                                                        index]
                                                                    .total_ques,
                                                                correctMarks: snapshot
                                                                    .data![
                                                                        index]
                                                                    .positive_mark,
                                                                totalTime: snapshot
                                                                    .data![
                                                                        index]
                                                                    .total_time,
                                                                heading: snapshot
                                                                    .data![
                                                                        index]
                                                                    .test_name!,
                                                                title: widget
                                                                    .title,
                                                                test_hash: snapshot
                                                                    .data![
                                                                        index]
                                                                    .test_hash!,
                                                                totalMark: snapshot
                                                                    .data![
                                                                        index]
                                                                    .total_mark,
                                                              )));
                                                }
                                              : () {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) => TestInstructionPage(
                                                              isQuiz:
                                                                  widget.isQuiz,
                                                              id: snapshot
                                                                  .data![index]
                                                                  .id,
                                                              incorrectMarks:
                                                                  snapshot
                                                                      .data![
                                                                          index]
                                                                      .negative_mark,
                                                              totalQues: snapshot
                                                                  .data![index]
                                                                  .total_ques,
                                                              correctMarks: snapshot
                                                                  .data![index]
                                                                  .positive_mark,
                                                              totalTime: snapshot
                                                                  .data![index]
                                                                  .total_time,
                                                              heading: snapshot
                                                                  .data![index]
                                                                  .test_name!,
                                                              title:
                                                                  widget.title,
                                                              test_hash: snapshot
                                                                  .data![index]
                                                                  .test_hash!)));
                                                },
                                          child: snapshot.data![index]
                                                      .is_attempted ==
                                                  1
                                              ? Icon(
                                                  Icons.check,
                                                  color: Colors.white,
                                                )
                                              : Text(
                                                  'Start',
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ))
                                      : null,
                                  subtitle: e == 'Mock Tests'
                                      ? Padding(
                                          padding:
                                              const EdgeInsets.only(left: 8.0),
                                          child: Text('${snapshot.data![index].total_ques}' +
                                              ' Questions    ' +
                                              '${snapshot.data![index].total_time}' +
                                              ' Minutes\n' +
                                              '${snapshot.data![index].test_desc}'),
                                        )
                                      : Padding(
                                          padding:
                                              const EdgeInsets.only(left: 8.0),
                                          child: Text(
                                              '${snapshot.data![index].add_date!.substring(8, 10) + snapshot.data![index].add_date!.substring(4, 7) + '-' + snapshot.data![index].add_date!.substring(0, 4)}'),
                                        ),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20)),
                                  contentPadding: EdgeInsets.all(8),
                                  title: (e == 'Mock Tests')
                                      ? Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                              snapshot.data![index].test_name!),
                                        )
                                      : Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                              snapshot.data![index].title!),
                                        ),
                                ),
                              ),
                            );
                          });
                    return Center(child: CircularProgressIndicator());
                  }))
              .toList()),
    );
  }
}
