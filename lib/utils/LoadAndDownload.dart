import 'dart:convert';

import 'package:elearning/Screens/UpdateAndExpiry/AppUpdateAndExpiryScreen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:velocity_x/velocity_x.dart';

import '../MyStore.dart';
import '../constants.dart';
import '../dbModel.dart';
import '../objectbox.g.dart';

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

getAppConfigMain(Store store1, BuildContext context) async {
  final box = store1.box<ExamElement>();
  SharedPreferences preferences = await SharedPreferences.getInstance();
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
    print(data);
    var forceUpdate = data['force_update'];
    var appUpdate = data['app_update'];
    var allowAccess = data['access_allow'];
    if (allowAccess == "No") {
      preferences.setString("access_allow", "false");
    }
    var expiryDate = data['date_app_expiry'];
    if (forceUpdate != null && forceUpdate == 0) {
      // response 1 -> disable update
      // response 0-> enable update
      print("$forceUpdate  Please update your Application");
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (context) => AppUpdateAndExpiryScreen(
                    isAppExpire: false,
                  )),
          (route) => false);
    }
    // else if(appUpdate != null &&  appUpdate){
    //   print("APP update true");
    //   AppUpdateAndExpiryScreen(isAppExpire: false,);
    // }
    else if (expiryDate != null) {
      DateTime tempDate = new DateFormat("yyyy-MM-dd").parse(expiryDate);
      if (tempDate.isBefore(DateTime.now())) {
        print("please update your app");
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (context) => AppUpdateAndExpiryScreen(
                      isAppExpire: true,
                    )),
            (route) => false);
      }
    }

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


 askFieldPermissionAccess(BuildContext context, MyStore store1) async {
  print("app_id': $appID,user_id': ${store1.studentID}, user_hash': $app_hash ");
  SharedPreferences preferences = await SharedPreferences.getInstance() ;
  await http.post(Uri.parse(appUserPermissionAccessURL), body: {
    'app_id': appID,
    'user_id': store1.studentID,
    'user_hash': store1.studentHash,
  }).then((value) async {
    dynamic data = await compute(jsonDecode, value.body);
    print(data);
    Map<dynamic, dynamic> mapTemp = Map();
    mapTemp.addAll(data);
    mapTemp.forEach((key, valueFlag){
      preferences.clear();
      preferences.setInt("app_user_permission_access_v0_flag", valueFlag);
    });
    // print(data);
  });
}

void removeAllCache() async {
  final MyStore store = VxState.store;
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.clear();
  prefs.setBool('hasSeenCards', true);
  store.dataStore.box<Post>().removeAll();
  store.dataStore.box<TestDataElement>().removeAll();
  store.dataStore.box<ExamElement>().removeAll();
  store.dataStore.box<TestReadingElement>().removeAll();
  store.dataStore.box<FLTExamElement>().removeAll();
  store.dataStore.box<GroupElement>().removeAll();
  store.dataStore.box<BookmarkElement>().removeAll();
  DefaultCacheManager().emptyCache();
}
