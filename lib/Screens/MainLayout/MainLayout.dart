import 'dart:convert';
import 'package:elearning/MyStore.dart';
import 'package:elearning/Screens/HomeScreen/home_screen_body.dart';
import 'package:elearning/constants.dart';
import 'package:elearning/dbModel.dart';
import 'package:elearning/objectbox.g.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:http/http.dart' as http;

class MainLayout extends StatefulWidget {
  @override
  _MainLayoutState createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  final MyStore store = VxState.store;
  late SharedPreferences prefs;
  getFLTExamList(Store store1) async {
    final box = store1.box<FLTExamElement>();
    MyStore store = VxState.store;
    await http.post(Uri.parse(getFLTExamList_URL), body: {
      'user_id': store.studentID,
      'user_hash': store.studentHash,
      'app_id': appID,
    }).then((value) async {
      dynamic data = await compute(jsonDecode, value.body);
      store.dataStore.runInTransaction(TxMode.write, () {
        List<FLTExamElement> storedData = List.from(data)
            .map((element) => FLTExamElement(
                sub_menu1: jsonEncode(element['sub_menu1']),
                title: element['title'],
                subtitle: element['subtitle']))
            .toList();
        box.removeAll();
        box.putMany(storedData);
      });
    });
  }

  initialisePrefs() async {
    prefs = await SharedPreferences.getInstance();
  }

  getGroupList(Store store1) async {
    final box = store1.box<GroupElement>();
    MyStore store = VxState.store;
    await http.post(Uri.parse(discussGroupsList_URL), body: {
      'user_id': store.studentID,
      'user_hash': store.studentHash,
      'app_hash': app_hash,
      'pref_community_ids': '',
      'app_id': appID,
    }).then((value) async {
      print(value.body);
      dynamic dynamicData = await compute(jsonDecode, value.body);
      List data = dynamicData;
      store1.runInTransaction(TxMode.write, () {
        List<GroupElement> groupData = data
            .map((element) => GroupElement(
                tag: element['tag'],
                groupHashTag: element['group_hash_tag'],
                countPost: element['count_post'],
                about: element['about'],
                checkedStatus: element['checked_status'],
                communityId: element['community_id'],
                countFollower: element['count_follower']))
            .toList();
        box.removeAll();
        box.putMany(groupData);
      });
    });
  }

  getTestListContent(Store store1) async {
    final box = store1.box<TestDataElement>();
    MyStore store = VxState.store;
    http.post(Uri.parse(testList_URL), body: {
      'user_id': store.studentID,
      'user_hash': store.studentHash,
      'max_test_sync_id': '',
      'app_hash': app_hash,
      'test_count': '',
      'country': 'India',
    }).then((value) async {
      dynamic data = await compute(jsonDecode, value.body);
      print('**************');
      print(data);

      store.dataStore.runInTransaction(TxMode.write, () {
        List<TestDataElement> dataNew = List.from(data['test_data'])
            .map((element) => TestDataElement(
                test_hash: element['test_hash'],
                add_date: element['add_date'],
                exam_id: element['exam_id'],
                is_attempted: element['is_attempted'],
                is_notify: element['is_notify'],
                mark_obtain: double.parse(element['mark_obtain'].toString()),
                negative_mark: element['negative_mark'],
                percentage: element['percentage'],
                positive_mark: element['positive_mark'],
                test_desc: element['test_desc'],
                test_name: element['test_name'],
                test_sequence_no: element['test_sequence_no'],
                test_status: element['test_status'],
                test_tag: element['test_tag'],
                total_mark: element['total_mark'],
                total_ques: element['total_ques'],
                total_time: element['total_time']))
            .toList();
        box.removeAll();
        box.putMany(dataNew);
      });
    });
  }

  getAppConfig(Store store1) async {
    final box = store1.box<ExamElement>();
    MyStore store = VxState.store;
    await http.post(Uri.parse(appCheckVersion_URL), body: {
      'user_id': store.studentID,
      'user_hash': store.studentHash,
      'gcm_id': '',
      'version_code': '85',
      'app_hash': app_hash,
      'country': 'India',
    }).then((value) async {
      dynamic data = await compute(jsonDecode, value.body);
      print('------------------------------');
      print(data);
      store.dataStore.runInTransaction(TxMode.write, () {
        List<ExamElement> dataNew = List.from(data['exams'])
            .map((element) => ExamElement(
                exam_id: element['exam_id'],
                exam_title_1: element['exam_title_1'],
                exam_name: element['exam_name'],
                exam_title_2: element['exam_title_2'],
                sequence_no: element['sequence_no'],
                status: element['status'],
                tag: element['tag']))
            .toList();
        box.removeAll();
        box.putMany(dataNew);
      });
    });
  }

  getTestReadingElementList(Store store1) async {
    final box = store1.box<TestReadingElement>();
    MyStore store = VxState.store;

    await http.post(Uri.parse(appFetchReading_URL), body: {
      'user_id': store.studentID,
      'user_hash': store.studentHash,
      'app_hash': app_hash,
      'row_count': '',
      'max_reading_sync_id': '',
      'country': 'India',
      'language': 'English',
    }).then((value) async {
      dynamic data = await compute(jsonDecode, value.body);
      print('!!!!!!!!!!!!!!!!!!!!!!!!');
      print(data);

      store.dataStore.runInTransaction(TxMode.write, () {
        List<TestReadingElement> dataNew = List.from(data['reading_arr'])
            .map((element) => TestReadingElement(
                add_date: element['add_date'],
                category: element['category'],
                content: element['content'],
                is_notify: element['is_notify'],
                mob_post_hash: element['mob_post_hash'],
                seq_no: element['seq_no'],
                status: element['status'],
                subcategory: element['subcategory'],
                title: element['title'],
                type: element['type'],
                url: element['url']))
            .toList();
        box.removeAll();
        box.putMany(dataNew);
      });
    });
  }

  @override
  void dispose() async {
    // TODO: implement dispose
    super.dispose();
    removeAllChachec();
  }

  @override
  void deactivate() {
    // TODO: implement deactivate
    super.deactivate();
    removeAllChachec();
  }

  void removeAllChachec() async {
    final MyStore store = VxState.store;
    SharedPreferences prefs =
    await SharedPreferences.getInstance();
    prefs.clear();
    store.dataStore.box<Post>().removeAll();
    store.dataStore
        .box<TestDataElement>()
        .removeAll();
    store.dataStore
        .box<ExamElement>()
        .removeAll();
    store.dataStore
        .box<TestReadingElement>()
        .removeAll();
    store.dataStore
        .box<FLTExamElement>()
        .removeAll();
    store.dataStore
        .box<GroupElement>()
        .removeAll();
    store.dataStore
        .box<BookmarkElement>()
        .removeAll();
  }

  @override
  void initState() {
    initialisePrefs();
    store.studentPermission.studentPermissions!.forEach((element) {
      switch (element) {
        case '230':
          getGroupList(store.dataStore);
          break;
        case '229':
          break;
        case '331':
          getFLTExamList(store.dataStore);
          break;
        default:
          break;
      }
    });
    print(store.studentID);
    print(store.studentHash);
    print(store.studentData);
    print(store.studentPermission);
    print(store.emailID);

    getTestListContent(store.dataStore);

    getAppConfig(store.dataStore);

    getTestReadingElementList(store.dataStore);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: HomeScreenBody(),
    );
  }
}
