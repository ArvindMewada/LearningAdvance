import 'package:elearning/MyStore.dart';
import 'package:elearning/dbModel.dart';
import 'package:elearning/objectbox.g.dart';
import 'package:flutter/material.dart';
import 'package:elearning/modules/TestPreReadingPage.dart';
import 'package:rxdart/rxdart.dart';
import 'package:velocity_x/velocity_x.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({Key? key}) : super(key: key);

  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  MyStore store = VxState.store;
  late BehaviorSubject<List<ExamElement>> _stream;

  @override
  void initState() {
    if (mounted)
      setState(() {
        _stream = BehaviorSubject();
        _stream.addStream(store.dataStore
            .box<ExamElement>()
            .query((ExamElement_.tag).equals('quiz'))
            .watch(triggerImmediately: true)
            .map((query) => query.find()));
      });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Quiz'),
        ),
        body: StreamBuilder(
            stream: _stream,
            builder: (context, AsyncSnapshot<List<ExamElement>> snapshot) {
              if (snapshot.hasData &&
                  !store.dataStore.box<ExamElement>().isEmpty())
                return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Material(
                            elevation: 5,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
                            child: ListTile(
                              leading: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.asset('assets/images/' +
                                    '${snapshot.data![index].exam_id}' +
                                    '.png'),
                              ),
                              contentPadding: EdgeInsets.all(20),
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            TestPreReadingPage(
                                                isQuiz: true,
                                                tabs: ['Mock Tests'],
                                                exam_id: snapshot
                                                    .data![index].exam_id!,
                                                title: snapshot
                                                    .data![index].exam_name!)));
                              },
                              title: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(snapshot.data![index].exam_name!),
                              ),
                              subtitle: (snapshot.data![index].exam_title_2 !=
                                      null)
                                  ? (snapshot.data![index].exam_title_2 != "")
                                      ? Padding(
                                          padding:
                                              const EdgeInsets.only(left: 8.0),
                                          child: Text(snapshot
                                              .data![index].exam_title_2!),
                                        )
                                      : null
                                  : null,
                            )),
                      );
                    });
              return Center(child: CircularProgressIndicator());
            }));
  }
}
