import 'dart:convert';

import 'package:elearning/MyStore.dart';
import 'package:elearning/Screens/MainLayout/MainLayout.dart';
import 'package:elearning/Screens/SignupScreen/components/or_divider.dart';
import 'package:elearning/components/email_input_field.dart';
import 'package:elearning/components/rounded_button.dart';
import 'package:elearning/components/rounded_password_field.dart';
import 'package:elearning/constants.dart';
import 'package:elearning/functions/googleSignInApi.dart';
import 'package:elearning/schemas/studentDataSchema.dart';
import 'package:elearning/schemas/studentPermissionSchema.dart';
import 'package:elearning/utils/LoadAndDownload.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:flutter_svprogresshud/flutter_svprogresshud.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:velocity_x/velocity_x.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late TextEditingController emailController;
  late TextEditingController passwordController;
  MyStore store = VxState.store;

  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    emailController = TextEditingController();
    passwordController = TextEditingController();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Login',
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(40),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Text(
                    "SpeEdLabs",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 30.sp,
                    ),
                  ),
                ),
                EmailRoundedInputField(
                  hintText: "Your Email",
                  keyboardType: TextInputType.emailAddress,
                  controller: emailController,
                  color: Colors.grey[200],
                ),
                RoundedPasswordField(
                  color: Colors.grey[200],
                  controller: passwordController,
                ),
                RoundedButton(
                  color: kPrimaryColor,
                  text: "LOGIN",
                  press: () async {
                    if (emailController.text.isEmptyOrNull) {
                      showCustomSnackBar(
                          context, 'Please enter your e-mail address');
                    } else if (passwordController.text.isEmptyOrNull)
                      showCustomSnackBar(context, 'Please enter your password');
                    else {
                      loadingDialogOpen();
                      //Checks the user id and password from the server
                      await http.post(Uri.parse(studentDetailsAPI_URL), body: {
                        'app_id': appID,
                        'hash': app_hash,
                        'email': emailController.text,
                        'pwd': passwordController.text,
                      }).then((userData) async {
                        //Network Error
                        if (userData.statusCode != 200) {
                          SVProgressHUD.dismiss();
                          showCustomSnackBar(
                              context, 'Error connecting to server');
                        } else {
                          dynamic data =
                              await compute(jsonDecode, userData.body);
                          if (data['flag'] != 1 ||
                              data.toString().contains(
                                  '{message: No data exist for given user') ||
                              data.toString().contains(
                                  '{message: Institute id did not matched with given app id,')) {
                            SVProgressHUD.dismiss();
                            showCustomSnackBar(context,
                                'No user found with these credentials, please check your email address and password');
                          } else {
                            //User Exists
                            store.studentData = StudentData.fromJson(data);
                            print(store.studentData);
                            store.studentHash = store.studentData.userHash!;
                            store.studentID = store.studentData.userId!;

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
                                  print(store.studentPermission);
                                  SharedPreferences prefs =
                                      await SharedPreferences.getInstance();
                                  prefs.setBool('isAuth', true);
                                  prefs.setString(
                                      'email', emailController.text);
                                  prefs.setString(
                                      'password', passwordController.text);
                                  SVProgressHUD.dismiss();
                                  Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => MainLayout()),
                                      (route) => false);
                                }
                              }
                            });
                          }
                        }
                      });
                    }
                  },
                ),
                OrDivider(),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SignInButton(
                    Buttons.Google,
                    onPressed: () async {
                      GoogleSignInAccount? user = await GoogleSignInApi.login();
                      SVProgressHUD.setRingThickness(5);
                      SVProgressHUD.setRingRadius(5);
                      SVProgressHUD.setDefaultMaskType(
                          SVProgressHUDMaskType.black);
                      SVProgressHUD.show();
                      if (user == null) {
                        SVProgressHUD.dismiss();
                        showCustomSnackBar(context, 'No User Found!');
                      } else {
                        store.emailID = user.email;
                        print(user);
                        await http.post(Uri.parse(appCheckEmail_URL), body: {
                          'hash': app_hash,
                          'email': store.emailID,
                          'app_id': appID
                        }).then((studentData) async {
                          print(studentData.body);
                          if (studentData.statusCode != 200) {
                            SVProgressHUD.dismiss();
                            showCustomSnackBar(
                                context, 'Error connecting to server');
                            await GoogleSignInApi.logout();
                          } else {
                            dynamic data =
                                await compute(jsonDecode, studentData.body);
                            if (data['message'] ==
                                'No data exist for given email id') {
                              SVProgressHUD.dismiss();
                              showCustomSnackBar(
                                  context, 'No data exist for given email id');
                              await GoogleSignInApi.logout();
                            } else {
                              //User Exists
                              store.studentData = StudentData.fromJson(data);
                              store.studentHash = store.studentData.userHash!;
                              store.studentID = store.studentData.userId!;
                              //Getting user permission from the admin
                              await http.post(
                                  Uri.parse(studentPermissionAPI_URL),
                                  body: {
                                    'app_hash': app_hash,
                                    'user_hash': store.studentData.userHash,
                                    'user_id': store.studentData.userId
                                  }).then((userPermission) async {
                                if (userPermission.statusCode != 200) {
                                  SVProgressHUD.dismiss();
                                  showCustomSnackBar(
                                      context, 'Error connecting to server');
                                  await GoogleSignInApi.logout();
                                } else {
                                  dynamic data = await compute(
                                      jsonDecode, userPermission.body);
                                  if (data['flag'] != 1) {
                                    SVProgressHUD.dismiss();
                                    showCustomSnackBar(context,
                                        'User not granted permission to use this application');
                                    await GoogleSignInApi.logout();
                                  } else {
                                    store.studentPermission =
                                        StudentPermission.fromJson(data);
                                    print(store.studentPermission);
                                    SharedPreferences prefs =
                                        await SharedPreferences.getInstance();
                                    prefs.setBool('isAuth', true);
                                    prefs.setString('loginType', 'google');
                                    print(user.email);
                                    prefs.setString('email', user.email);
                                    SVProgressHUD.dismiss();
                                    Navigator.pushAndRemoveUntil(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => MainLayout()),
                                        (route) => false);
                                  }
                                }
                              });
                            }
                          }
                        });
                      }
                    },
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(29)),
                    padding: EdgeInsets.all(10),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SignInButton(
                    Buttons.FacebookNew,
                    onPressed: () {
                      FacebookAuth.instance.login(permissions: [
                        "email",
                        "public_profile",
                      ]).then((value) {
                        if (value.accessToken == null) {
                          SVProgressHUD.dismiss();
                          showCustomSnackBar(context, 'No User Found!');
                        } else {
                          FacebookAuth.instance
                              .getUserData()
                              .then((userData) async {
                            SVProgressHUD.setRingThickness(5);
                            SVProgressHUD.setRingRadius(5);
                            SVProgressHUD.setDefaultMaskType(
                                SVProgressHUDMaskType.black);
                            SVProgressHUD.show();
                            store.emailID = userData["email"];
                            print(userData);

                            await http.post(Uri.parse(appCheckEmail_URL),
                                body: {
                                  'hash': app_hash,
                                  'email': store.emailID,
                                  'app_id': appID
                                }).then((studentData) async {
                              print(studentData.body);
                              if (studentData.statusCode != 200) {
                                SVProgressHUD.dismiss();
                                showCustomSnackBar(
                                    context, 'Error connecting to server');
                                await FacebookAuth.instance.logOut();
                              } else {
                                //No netwrk issue
                                dynamic data =
                                    await compute(jsonDecode, studentData.body);
                                store.studentData = StudentData.fromJson(data);
                                store.studentHash = store.studentData.userHash!;
                                store.studentID = store.studentData.userId!;

                                //Getting user permission from the server
                                await http.post(
                                    Uri.parse(studentPermissionAPI_URL),
                                    body: {
                                      'app_hash': app_hash,
                                      'user_hash': store.studentData.userHash,
                                      'user_id': store.studentData.userId
                                    }).then((userPermission) async {
                                  print(userPermission);
                                  if (userPermission.statusCode != 200) {
                                    SVProgressHUD.dismiss();
                                    showCustomSnackBar(
                                        context, 'Error connecting to server');
                                    await FacebookAuth.instance.logOut();
                                  } else {
                                    dynamic data = await compute(
                                        jsonDecode, userPermission.body);
                                    if (data['flag'] != 1) {
                                      SVProgressHUD.dismiss();
                                      showCustomSnackBar(context,
                                          'User not granted permission to use this application');
                                      await FacebookAuth.instance.logOut();
                                    } else {
                                      store.studentPermission =
                                          StudentPermission.fromJson(data);
                                      print(store.studentPermission);
                                      SharedPreferences prefs =
                                          await SharedPreferences.getInstance();
                                      prefs.setBool('isAuth', true);
                                      prefs.setString('loginType', 'fb');
                                      prefs.setString('email', store.emailID);
                                      SVProgressHUD.dismiss();
                                      await FacebookAuth.instance.logOut();
                                      Navigator.pushAndRemoveUntil(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => MainLayout()),
                                        (route) => false,
                                      );
                                    }
                                  }
                                });
                              }
                            });
                          });
                        }
                      });
                    },
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(29)),
                    padding: EdgeInsets.all(15),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
