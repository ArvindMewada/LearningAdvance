import 'dart:async';

import 'package:elearning/MyStore.dart';
import 'package:elearning/Screens/MainLayout/AlertDialog.dart';
import 'package:elearning/Screens/ProfileScreen/StudentDashboard.dart';
import 'package:elearning/Screens/Welcome/welcome_screen.dart';
import 'package:elearning/constants.dart';
import 'package:elearning/dbModel.dart';
import 'package:elearning/functions/googleSignInApi.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_svprogresshud/flutter_svprogresshud.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:percent_indicator/percent_indicator.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool collapsed = false;
  MyStore store = VxState.store;
  Icon errorIcon = Icon(
    Icons.error,
    color: Colors.red,
  );

  @override
  Widget build(BuildContext context) {
    bool isQualFilled = (store.studentData.userQual == '') ||
        (store.studentData.userQual == null);
    bool isStreamFilled =
        (store.studentData.stream == '') || (store.studentData.stream == null);
    return Scaffold(
        appBar: AppBar(
          title: Text('Profile'),
        ),
        body: SingleChildScrollView(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                elevation: 10,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                child: Center(
                    child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 30, horizontal: 10),
                  child: Column(children: [
                    CircularPercentIndicator(
                      radius: 100,
                      lineWidth: 10,
                      animation: true,
                      animationDuration: 1500,
                      percent: (double.parse(
                              store.studentData.percentage.toString())) /
                          100,
                      circularStrokeCap: CircularStrokeCap.round,
                      progressColor: Colors.deepPurple[900],
                      backgroundColor: Colors.white,
                      center: CircleAvatar(
                          child: store.studentData.userImagePath == ''
                              ? Icon(
                                  Icons.person,
                                  size: 50,
                                )
                              : null,
                          radius: 42,
                          backgroundImage: store.studentData.userImagePath == ''
                              ? null
                              : NetworkImage(store.studentData.userImagePath!)),
                    ),
                    SizedBox(height: 10),
                    Text(
                      '${store.studentData.userFirstName.toString().firstLetterUpperCase()} ${store.studentData.userLastName.toString().firstLetterUpperCase()}',
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 5),
                    Text(
                      '${store.studentData.userEmail}',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 18),
                    ),
                    SizedBox(height: 20),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Text(
                              '${isQualFilled ? '-' : store.studentData.userQual}',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
                          Expanded(
                            child: Text(
                                '${isStreamFilled ? '-' : store.studentData.stream}',
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 18)),
                          ),
                          Expanded(
                            child: Text('${store.studentData.userContactNo}',
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 18)),
                          )
                        ])
                  ]),
                )),
              ),
            ),
            // Padding(
            //   padding: const EdgeInsets.all(8.0),
            //   child: Material(
            //     elevation: 10,
            //     shape: RoundedRectangleBorder(
            //         borderRadius: BorderRadius.circular(10)),
            //     child: ListTile(
            //         onTap: () {
            //           Navigator.push(
            //               context,
            //               MaterialPageRoute(
            //                   builder: (context) => StudentDashboard()));
            //         },
            //         title: Text('Student Dashboard',
            //             style: TextStyle(fontSize: 20)),
            //         trailing: Icon(
            //           Icons.keyboard_arrow_right,
            //           color: kPrimaryColor,
            //           size: 30,
            //         )),
            //   ),
            // ),
            // Padding(
            //   padding: const EdgeInsets.all(8.0),
            //   child: Material(
            //     elevation: 10,
            //     shape: RoundedRectangleBorder(
            //         borderRadius: BorderRadius.circular(10)),
            //     child: ListTile(
            //         title: Text('Frequently Asked Questions',
            //             style: TextStyle(fontSize: 20)),
            //         trailing: Icon(
            //           Icons.keyboard_arrow_right,
            //           color: kPrimaryColor,
            //           size: 30,
            //         )),
            //   ),
            // ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Material(
                elevation: 10,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                child: ListTile(
                    onTap: () async {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertBox(
                              text: 'Yes',
                              secondText: 'No',
                              title: 'Logout',
                              content: 'Do you want to Logout?',
                              press: () async {
                                SVProgressHUD.setRingThickness(5);
                                SVProgressHUD.setRingRadius(5);
                                SVProgressHUD.setDefaultMaskType(
                                    SVProgressHUDMaskType.black);
                                SVProgressHUD.show();
                                Timer(Duration(seconds: 2), () async {
                                  SharedPreferences prefs =
                                      await SharedPreferences.getInstance();
                                  if (prefs.getString('loginType') == 'google')
                                    await GoogleSignInApi.logout();
                                  else if (prefs.getString('loginType') == 'fb')
                                    await FacebookAuth.instance.logOut();
                                  else
                                    prefs.clear();
                                  prefs.setBool('hasSeenCards', true);
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
                                  SVProgressHUD.dismiss();
                                  Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              WelcomeScreen()),
                                      (route) => false);
                                });
                              },
                              secondPress: () {
                                Navigator.pop(context);
                              },
                            );
                          });
                    },
                    title: Text('Log Out', style: TextStyle(fontSize: 20)),
                    trailing: Icon(
                      Icons.keyboard_arrow_right,
                      color: kPrimaryColor,
                      size: 30,
                    )),
              ),
            )
          ],
        )));
  }
}
