import 'package:elearning/MyStore.dart';
import 'package:elearning/constants.dart';
import 'package:elearning/dbModel.dart';
import 'package:elearning/objectbox.g.dart';
import 'package:flutter/material.dart';
import 'package:elearning/modules/TestPreReadingPage.dart';
import 'package:rxdart/subjects.dart';
import 'package:velocity_x/velocity_x.dart';

class ExamScreen extends StatefulWidget {
  const ExamScreen({Key? key}) : super(key: key);

  @override
  _ExamScreenState createState() => _ExamScreenState();
}

class _ExamScreenState extends State<ExamScreen> {
  MyStore store = VxState.store;
  late BehaviorSubject<List<ExamElement>> _stream;

  @override
  void initState() {
    if (mounted)
      setState(() {
        _stream = BehaviorSubject();
        _stream.addStream(store.dataStore
            .box<ExamElement>()
            .query((ExamElement_.tag).equals('exam'))
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
        title: Text('Exams'),
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
                            trailing: Icon(
                              Icons.keyboard_arrow_right,
                              color: kPrimaryColor,
                              size: 30,
                            ),
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 10, horizontal: 20),
                            onTap: () {
                              final query = store.dataStore
                                  .box<TestReadingElement>()
                                  .query(TestReadingElement_.subcategory
                                      .equals(snapshot.data![index].exam_id!
                                          .toString())
                                      .and(TestReadingElement_.status
                                          .equals('active')))
                                  .build();
                              PropertyQuery<String> pq =
                                  query.property(TestReadingElement_.type);
                              pq.distinct = true;
                              List<String> tabs = pq.find();

                              pq.close();
                              query.close();
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => TestPreReadingPage(
                                          isQuiz: false,
                                          tabs: ['Mock Tests'] + tabs,
                                          exam_id:
                                              snapshot.data![index].exam_id!,
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
          }),
    );
  }
}
