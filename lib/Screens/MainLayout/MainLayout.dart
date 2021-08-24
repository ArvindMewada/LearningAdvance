import 'dart:convert';

import 'package:elearning/MyStore.dart';
import 'package:elearning/Screens/HomeScreen/home_screen_body.dart';
import 'package:elearning/constants.dart';
import 'package:elearning/dbModel.dart';
import 'package:elearning/objectbox.g.dart';
import 'package:elearning/schemas/studentDataSchema.dart';
import 'package:elearning/schemas/studentPermissionSchema.dart';
import 'package:elearning/utils/LoadAndDownload.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svprogresshud/flutter_svprogresshud.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:velocity_x/velocity_x.dart';

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

  @override
  void dispose() {
    super.dispose();
    removeAllCache();
  }

  @override
  void deactivate() {
    super.deactivate();
    removeAllCache();
  }

void configurationAgain() async {
  //Gets the permission of the user in the app
  await http.post(Uri.parse(studentPermissionAPI_URL),
      body: {
        'app_hash': app_hash,
        'user_hash': store.studentData.userHash,
        'user_id': store.studentData.userId.toString()
      }).then((userPermission) async {
    if (userPermission.statusCode != 200) {
      SVProgressHUD.dismiss();
      showCustomSnackBar(
          context, 'Error connecting to server');
    } else {
      dynamic data = await compute(
          jsonDecode, userPermission.body);
      if (data['flag'] != 1) {
        SVProgressHUD.dismiss();
        showCustomSnackBar(context,
            'User not granted permission to use this application');
      } else {
        store.studentPermission =
            StudentPermission.fromJson(data);
        print("${store.studentPermission} student permission in main layout");
        SharedPreferences prefs =
        await SharedPreferences.getInstance();
        prefs.setBool('isAuth', true);
        SVProgressHUD.dismiss();
      }
    }
  });
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
    getAppConfigMain(store.dataStore, context);
    getTestListContent(store.dataStore);
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
