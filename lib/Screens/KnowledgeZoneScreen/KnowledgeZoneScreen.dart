import 'package:elearning/MyStore.dart';
import 'package:elearning/Screens/KnowledgeZoneScreen/KnowledgeZonePreReadingPage.dart';
import 'package:elearning/Screens/KnowledgeZoneScreen/LearnEnglishPage.dart';
import 'package:elearning/Screens/KnowledgeZoneScreen/VocabularyPage.dart';
import 'package:elearning/constants.dart';
import 'package:elearning/dbModel.dart';
import 'package:elearning/objectbox.g.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:velocity_x/velocity_x.dart';

class KnowledgeZoneScreen extends StatefulWidget {
  const KnowledgeZoneScreen({Key? key}) : super(key: key);

  @override
  _KnowledgeZoneScreenState createState() => _KnowledgeZoneScreenState();
}

class _KnowledgeZoneScreenState extends State<KnowledgeZoneScreen> {
  MyStore store = VxState.store;
  late BehaviorSubject<List<ExamElement>> _stream;

  String getCategory(int param) {
    switch (param) {
      case 10005:
        return 'FINANCIAL_AFFAIRS';
      case 10006:
        return 'GD_PI';
      case 10007:
        return 'COMMERCE_TERMINOLOGY';
      case 10009:
        return 'SCIENCE_TERMINOLOGY';
      case 10010:
        return 'COMPUTER_TERMINOLOGY';
      case 10011:
        return 'BANKING_TERMINOLOGY';
      case 10013:
        return 'COMPANY_INFO';
      case 10014:
        return 'MATHS_TIPS&TRICKS';
      default:
        return '';
    }
  }

  @override
  void initState() {
    if (mounted)
      setState(() {
        _stream = BehaviorSubject();
        _stream.addStream(store.dataStore
            .box<ExamElement>()
            .query((ExamElement_.tag)
                .equals('kz')
                .and(ExamElement_.exam_id.notEquals(10008))
                .and(ExamElement_.exam_id.notEquals(10001)))
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
        title: Text('Knowledge Zone'),
      ),
      body: StreamBuilder(
        stream: _stream,
        builder: (context, AsyncSnapshot<List<ExamElement>> snapshot) {
          if (snapshot.hasData && !store.dataStore.box<ExamElement>().isEmpty())
            return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (BuildContext context, index) {
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
                          contentPadding: EdgeInsets.all(20),
                          leading: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.asset(
                                'assets/images/' +
                                    '${snapshot.data![index].exam_id}' +
                                    '.png',
                              )),
                          onTap: () {
                            switch (snapshot.data![index].exam_id) {
                              case 10003:
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => LearnEnglishPage(
                                              tab1: 'BASIC',
                                              tab2: 'INTERMEDIATE',
                                              tab3: 'ADVANCED',
                                              title: snapshot
                                                  .data![index].exam_name!,
                                            )));
                                break;
                              case 10004:
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => VocabularyPage(
                                              tab1: 'WORDS',
                                              tab2: 'STORIES',
                                              title: snapshot
                                                  .data![index].exam_name!,
                                            )));
                                break;
                              default:
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            KnowledgeZonePreReadingPage(
                                              title: snapshot
                                                  .data![index].exam_name!,
                                              category: getCategory(snapshot
                                                  .data![index].exam_id!),
                                            )));
                            }
                          },
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                          title: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(snapshot.data![index].exam_name!),
                          )),
                    ),
                  );
                });
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
