import 'dart:async';
import 'dart:convert';
import 'package:elearning/MyStore.dart';
import 'package:elearning/Screens/MainLayout/MainLayout.dart';
import 'package:elearning/Screens/SplashScreen/SplashScreenConstants.dart';
import 'package:elearning/Screens/Welcome/welcome_screen.dart';
import 'package:elearning/constants.dart';
import 'package:elearning/schemas/clientDataSchema.dart';
import 'package:elearning/schemas/studentDataSchema.dart';
import 'package:elearning/schemas/studentPermissionSchema.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';
import '../ExploreScreen/ExploreScreen.dart';
import 'package:lottie/lottie.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late final AnimationController controller;
  MyStore store = VxState.store;

  getAppConfig() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Timer(Duration(seconds: 2), () async {
      await http.post(Uri.parse(clientAPI_URL), body: {
        'version_code': version_code,
        'app_hash': app_hash
      }).then((clientData) async {
        if (clientData.statusCode != 200)
          showCustomSnackBar(
              context, 'Error Connecting to Server. Please try again later.');
        else {
          dynamic data = await compute(jsonDecode, clientData.body);
          store.clientData = ClientData.fromJson(data);
          if (store.clientData.flag != 1)
            showCustomSnackBar(context, 'Invalid Application Package');
          else {
            store.clientData.homeElements!.forEach((element) {
              store.clientPermissionList.add(element.homeElementId);
            });
            print(store.clientPermissionList);
            debugPrint(store.clientData.homeElements.toString(),
                wrapWidth: 1024);
            await initLogin(prefs);
          }
        }
      });
    });
  }

  initLogin(SharedPreferences prefs) async {

    //Check weather the user is already logged in or is logging for the first time
    if (prefs.getBool('isAuth') == true  && prefs.getString('email')!=null) {
      // await http.post(Uri.parse(studentDetailsAPI_URL), body: {
      //   'app_id': appID,
      //   'hash': app_hash,
      //   'email': prefs.getString('email'),
      //   'pwd': prefs.getString('password'),
      // }).then((userData) async {
      //   if (userData.statusCode != 200) {
      //     showCustomSnackBar(context, 'Error connecting to server');
      //   } else if (userData.body
      //           .contains('{message: No data exist for given user') ||
      //       userData.body.contains(
      //           '{message: Institute id did not matched with given app id,')) {
      //     showCustomSnackBar(
      //         context, 'Session Expired. Please Signup or Login again.');
      //     prefs.setBool('isAuth', false);
      //     Navigator.pushReplacement(context,
      //         MaterialPageRoute(builder: (context) => WelcomeScreen()));
      //   } else {
      //     dynamic data = await compute(jsonDecode, userData.body);
      //     if (data['flag'] != 1) {
      //       showCustomSnackBar(
      //           context, 'Session Expired. Please Signup or Login again.');
      //       prefs.setBool('isAuth', false);
      //       Navigator.pushReplacement(context,
      //           MaterialPageRoute(builder: (context) => WelcomeScreen()));
      //     } else {
      //       store.studentData = StudentData.fromJson(data);
      //       print(store.studentData);
      //       store.studentID = store.studentData.userId!;
      //       store.studentHash = store.studentData.userHash!;
      //       await http.post(Uri.parse(studentPermissionAPI_URL), body: {
      //         'app_hash': app_hash,
      //         'user_hash': store.studentData.userHash,
      //         'user_id': store.studentData.userId
      //       }).then((userPermission) async {
      //         if (userPermission.statusCode != 200)
      //           showCustomSnackBar(context,
      //               'Error connecting to server. Please try again later');
      //         else {
      //           dynamic data = await compute(jsonDecode, userPermission.body);
      //           if (data['flag'] != 1) {
      //             showCustomSnackBar(context,
      //                 'User not granted permission to use this application');
      //             Navigator.pushReplacement(context,
      //                 MaterialPageRoute(builder: (context) => WelcomeScreen()));
      //           } else {
      //             store.studentPermission = StudentPermission.fromJson(data);
      //
      //             Navigator.pushReplacement(context,
      //                 MaterialPageRoute(builder: (context) => MainLayout()));
      //           }
      //         }
      //       });
      //     }
      //   }
      // });
      print(prefs.getString('email'));
      await http.post(
          Uri.parse(appCheckEmail_URL),
          body: {
            'hash': app_hash,
            'email': prefs.getString('email'),
            'app_id': appID
          }).then((response) async {
        dynamic data = await compute(
            jsonDecode, response.body);
        print(data);

        //if user exist
        if (data['flag'] == 1) {
          store.studentData = StudentData.fromJson(data);
          store.studentHash = store.studentData.userHash!;
          store.studentID = store.studentData.userId!;

          //Gets the permission of the user
          await http.post(
              Uri.parse(studentPermissionAPI_URL),
              body: {
                'app_hash': app_hash,
                'user_hash': store.studentHash,
                'user_id': store.studentID
              }).then((userPermission) async {
            print(userPermission);
            if (userPermission.statusCode !=
                200) {
              // SVProgressHUD.dismiss();
              showCustomSnackBar(context,
                  'Error connecting to server');
            } else {
              dynamic data = await compute(
                  jsonDecode,
                  userPermission.body);
              print(data);
              if (data['flag'] != 1) {
                // SVProgressHUD.dismiss();
                showCustomSnackBar(context,
                    'User not granted permission to use this application');
                Navigator.pushReplacement(
                    context, MaterialPageRoute(builder: (context) => WelcomeScreen()));
              } else {
                store.studentPermission =
                    StudentPermission.fromJson(
                        data);
                print(store.studentPermission);
                SharedPreferences prefs =
                await SharedPreferences
                    .getInstance();
                prefs.setBool('isAuth', true);
                prefs.setString(
                    'loginType', 'normal');
                // SVProgressHUD.dismiss();

                //user logged in to main page
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          MainLayout()),
                      (route) => false,
                );
              }
            }
          });
        }
      });
    } else if (prefs.containsKey('isAuth') == false &&
        prefs.containsKey('hasSeenCards') == true)
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => WelcomeScreen()));
    else
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => ExploreScreen()));
  }

  @override
  void initState() {
    super.initState();
    controller = AnimationController(vsync: this);
    getAppConfig();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(11),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Expanded(
                  child: Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: Image.asset(logo),
              )),
              Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 2,
                      child: Lottie.asset(animationAsset,
                          controller: controller, onLoaded: (composition) {
                        controller
                          ..duration = composition.duration
                          ..repeat();
                      }),
                    ),
                    CircularProgressIndicator(
                      color: kPrimaryColor,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
