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
import 'package:elearning/utils/LoadAndDownloadNetworkCall.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:velocity_x/velocity_x.dart';

import '../ExploreScreen/ExploreScreen.dart';

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
            await initLogin(prefs);
          }
        }
      });
    });
  }

  initLogin(SharedPreferences prefs) async {
    //Check weather the user is already logged in or is logging for the first time
    if (prefs.getBool('isAuth') == true && prefs.getString('email') != null) {
      print(prefs.getString('email'));
      await http.post(Uri.parse(appCheckEmail_URL), body: {
        'hash': app_hash,
        'email': prefs.getString('email'),
        'app_id': appID
      }).then((response) async {
        dynamic data = await compute(jsonDecode, response.body);
        print(data);

        //if user exist
        if (data['flag'] == 1) {
          store.studentData = StudentData.fromJson(data);
          store.studentHash = store.studentData.userHash!;
          store.studentID = store.studentData.userId!;

          //Gets the permission of the user
          await http.post(Uri.parse(studentPermissionAPI_URL), body: {
            'app_hash': app_hash,
            'user_hash': store.studentHash,
            'user_id': store.studentID
          }).then((userPermission) async {
            print(userPermission);
            if (userPermission.statusCode != 200) {
              print("Error connecting to server");
              showCustomSnackBar(context, 'Error connecting to server');
            } else {
              dynamic data = await compute(jsonDecode, userPermission.body);
              print(data);
              if (data['flag'] != 1) {
                showCustomSnackBar(context,
                    'User not granted permission to use this application');
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => WelcomeScreen()));
              } else {
                store.studentPermission = StudentPermission.fromJson(data);
                print(store.studentPermission);
                SharedPreferences prefs = await SharedPreferences.getInstance();
                prefs.setBool('isAuth', true);
                prefs.setString('loginType', 'normal');

                getAppConfigMain(store.dataStore, context);
                getTestListContent(store.dataStore);
                getTestReadingElementList(store.dataStore);

                //user logged in to main page
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => MainLayout()),
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

  getAppVersionCode() async {
    await http.post(Uri.parse(appFetchVersionCodeURL), body: {
      'app_id': appID,
      'app_hash': app_hash,
    }).then((value) async {
      dynamic data = await compute(jsonDecode, value.body);
      var appVersion = data['version_code'];
      int appVersionFetch = int.parse(appVersion);
      int appVersionLocal = int.parse(version_code);
      print("$appVersionFetch , $appVersionLocal");
      if(appVersionLocal > appVersionFetch){
        print("your application version is low please update your application");
      }
    });
  }

  @override
  void initState() {
    super.initState();
    controller = AnimationController(vsync: this);
    getAppConfig();
    getAppVersionCode();

  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    controller.dispose();
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
