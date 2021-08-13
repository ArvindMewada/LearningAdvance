import 'dart:convert';

import 'package:elearning/MyStore.dart';
import 'package:elearning/Screens/MainLayout/MainLayout.dart';
import 'package:elearning/Screens/SignupScreen/RegisterScreen.dart';
import 'package:elearning/Screens/SignupScreen/components/or_divider.dart';
import 'package:elearning/components/email_input_field.dart';
import 'package:elearning/components/rounded_button.dart';
import 'package:elearning/constants.dart';
import 'package:elearning/functions/googleSignInApi.dart';
import 'package:elearning/schemas/otpSchema.dart';
import 'package:elearning/schemas/studentDataSchema.dart';
import 'package:elearning/schemas/studentPermissionSchema.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:flutter_svprogresshud/flutter_svprogresshud.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:velocity_x/velocity_x.dart';

class SignUpScreenParent extends StatefulWidget {
  @override
  _SignUpScreenParentState createState() => _SignUpScreenParentState();
}

class _SignUpScreenParentState extends State<SignUpScreenParent> {
  GlobalKey<FormState> _homeKey =
      GlobalKey<FormState>(debugLabel: '_homeScreenkey');
  late bool _showSecond;
  late ScrollController _controller;
  final MyStore store = VxState.store;
  late bool completed;
  late TextEditingController emailController;
  late TextEditingController otpController;

  @override
  void initState() {
    _showSecond = false;
    completed = false;
    _controller = ScrollController();
    emailController = TextEditingController();
    otpController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _homeKey,
      appBar: AppBar(
        title: Text(
          'Sign Up',
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          controller: _controller,
          child: AnimatedContainer(
            child: AnimatedCrossFade(
                firstChild: Padding(
                  padding: const EdgeInsets.all(40),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20.0),
                        child: Text(
                          "SpeEdLabs",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 30),
                        ),
                      ),
                      EmailRoundedInputField(
                        keyboardType: TextInputType.emailAddress,
                        hintText: "Your Email",
                        icon: Icons.email,
                        controller: emailController,
                        color: Colors.grey[200],
                      ),
                      RoundedButton(
                        text: "Get OTP",
                        color: kPrimaryColor,
                        press: () async {
                          if (emailController.text.isEmpty)
                            showCustomSnackBar(
                                context, 'Please enter your e-mail address');
                          else {
                            SVProgressHUD.setRingThickness(5);
                            SVProgressHUD.setRingRadius(5);
                            SVProgressHUD.setDefaultMaskType(
                                SVProgressHUDMaskType.black);
                            SVProgressHUD.show();
                            await http.post(Uri.parse(userRegPIN_URL), body: {
                              'user_email': emailController.text,
                              'app_id': appID,
                              'hash': app_hash,
                              'is_secure': is_secure
                            }).then((value) async {
                              if (value.statusCode != 200) {
                                SVProgressHUD.dismiss();
                                showCustomSnackBar(
                                    context, 'Error connecting to server');
                              } else {
                                dynamic data =
                                    await compute(jsonDecode, value.body);
                                if (data['flag'] != 2) {
                                  SVProgressHUD.dismiss();
                                  showCustomSnackBar(
                                      context, 'Error connecting to server');
                                } else {
                                  OTP otp = OTP.fromJson(data);
                                  MyStore store = VxState.store;
                                  store.emailID = emailController.text;
                                  store.recievedOTP = otp.pin!;
                                  print(store.recievedOTP);
                                  if (mounted)
                                    setState(() {
                                      _showSecond = true;
                                    });
                                  SVProgressHUD.dismiss();
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
                          text: 'Sign Up with Google',
                          onPressed: () async {
                            //Opens google sign in dialog box
                            GoogleSignInAccount? user =
                                await GoogleSignInApi.login();
                            SVProgressHUD.setRingThickness(5);
                            SVProgressHUD.setRingRadius(5);
                            SVProgressHUD.setDefaultMaskType(
                                SVProgressHUDMaskType.black);
                            SVProgressHUD.show();

                            if (user == null) {
                              SVProgressHUD.dismiss();
                              showCustomSnackBar(context, 'No User Found!');
                              await GoogleSignInApi.logout();
                            } else {
                              store.emailID = user.email;
                              print(user);
                              await http
                                  .post(Uri.parse(userRegister_URL), body: {
                                'uFname': user.displayName!.split(' ').first,
                                'uLname': user.displayName!.split(' ').last,
                                'app_id': appID,
                                'mobNo': '',
                                'uEmail': store.emailID,
                                'source': 'mob',
                                'version_code': version_code,
                                'uEduQual': '',
                                'uCity': '',
                                'uState': '',
                                'uCountry': '',
                                'gcm_id': '',
                                'uImage': (user.photoUrl == null)
                                    ? ''
                                    : user.photoUrl,
                                'uType': '',
                                'stream': '',
                              }).then((studentData) async {
                                //Gets the data from Gmail account
                                print(studentData.body);
                                if (studentData.statusCode != 200) {
                                  //Network Error
                                  SVProgressHUD.dismiss();
                                  showCustomSnackBar(
                                      context, 'Error connecting to server');
                                  await GoogleSignInApi.logout();
                                } else {
                                  dynamic data = await compute(
                                      jsonDecode, studentData.body);
                                  store.studentData =
                                      StudentData.fromJson(data);
                                  store.studentHash =
                                      store.studentData.userHash!;
                                  store.studentID = store.studentData.userId!;
                                  await http.post(
                                      Uri.parse(studentPermissionAPI_URL),
                                      body: {
                                        'app_hash': app_hash,
                                        'user_hash': store.studentData.userHash,
                                        'user_id': store.studentData.userId
                                      }).then((userPermission) async {
                                    if (userPermission.statusCode != 200) {
                                      SVProgressHUD.dismiss();
                                      showCustomSnackBar(context,
                                          'Error connecting to server');
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
                                            await SharedPreferences
                                                .getInstance();
                                        prefs.setBool('isAuth', true);
                                        prefs.setString('loginType', 'google');
                                        print(user.email);
                                        prefs.setString('email', user.email);
                                        SVProgressHUD.dismiss();
                                        await GoogleSignInApi.logout();
                                        Navigator.pushAndRemoveUntil(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    MainLayout()),
                                            (route) => false);
                                      }
                                    }
                                  });
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
                          text: 'Sign Up with Facebook',
                          onPressed: () async {
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
                                  await http
                                      .post(Uri.parse(userRegister_URL), body: {
                                    'uFname': userData["name"].split(' ').first,
                                    'uLname': userData["name"].split(' ').last,
                                    'app_id': appID,
                                    'mobNo': '',
                                    'uEmail': store.emailID,
                                    'source': 'mob',
                                    'version_code': version_code,
                                    'uEduQual': '',
                                    'uCity': '',
                                    'uState': '',
                                    'uCountry': '',
                                    'gcm_id': '',
                                    'uImage': (userData["picture"]["data"]
                                                ["url"] ==
                                            null)
                                        ? ''
                                        : userData["picture"]["data"]["url"],
                                    'uType': '',
                                    'stream': '',
                                  }).then((studentData) async {
                                    print(studentData.body);
                                    if (studentData.statusCode != 200) {
                                      SVProgressHUD.dismiss();
                                      showCustomSnackBar(context,
                                          'Error connecting to server');
                                      await FacebookAuth.instance.logOut();
                                    } else {
                                      dynamic data = await compute(
                                          jsonDecode, studentData.body);
                                      store.studentData =
                                          StudentData.fromJson(data);
                                      store.studentHash =
                                          store.studentData.userHash!;
                                      store.studentID =
                                          store.studentData.userId!;

                                      await http.post(
                                          Uri.parse(studentPermissionAPI_URL),
                                          body: {
                                            'app_hash': app_hash,
                                            'user_hash':
                                                store.studentData.userHash,
                                            'user_id': store.studentData.userId
                                          }).then((userPermission) async {
                                        print(userPermission);
                                        if (userPermission.statusCode != 200) {
                                          SVProgressHUD.dismiss();
                                          showCustomSnackBar(context,
                                              'Error connecting to server');
                                          await FacebookAuth.instance.logOut();
                                        } else {
                                          dynamic data = await compute(
                                              jsonDecode, userPermission.body);
                                          if (data['flag'] != 1) {
                                            SVProgressHUD.dismiss();
                                            showCustomSnackBar(context,
                                                'User not granted permission to use this application');
                                            await FacebookAuth.instance
                                                .logOut();
                                          } else {
                                            store.studentPermission =
                                                StudentPermission.fromJson(
                                                    data);
                                            print(store.studentPermission);
                                            SharedPreferences prefs =
                                                await SharedPreferences
                                                    .getInstance();
                                            prefs.setBool('isAuth', true);
                                            prefs.setString('loginType', 'fb');
                                            prefs.setString(
                                                'email', store.emailID);
                                            SVProgressHUD.dismiss();
                                            await FacebookAuth.instance
                                                .logOut();
                                            Navigator.pushAndRemoveUntil(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        MainLayout()),
                                                (route) => false);
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
                secondChild: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20.0),
                        child: Text(
                          "SpeEdLabs",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 30),
                        ),
                      ),
                      SizedBox(
                        height: 5.h,
                      ),
                      Text(
                        "Enter the 6 digit OTP recieved on the email",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontWeight: FontWeight.normal, fontSize: 25.sp),
                      ),
                      Text(
                        "${store.emailID}",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.indigo[900]),
                      ),
                      SizedBox(
                        height: 5.h,
                      ),
                      PinCodeTextField(
                        onChanged: (e) {
                          if (e.length == 6) {
                            if (mounted)
                              setState(() {
                                completed = true;
                              });
                          } else {
                            if (mounted)
                              setState(() {
                                completed = false;
                              });
                          }
                        },
                        keyboardType: TextInputType.number,
                        mainAxisAlignment: MainAxisAlignment.center,
                        autoDisposeControllers: true,
                        appContext: context,
                        length: 6,
                        obscureText: false,
                        animationType: AnimationType.fade,
                        pinTheme: PinTheme(
                            fieldOuterPadding: EdgeInsets.all(5),
                            shape: PinCodeFieldShape.box,
                            borderRadius: BorderRadius.circular(20),
                            fieldHeight: 8.h,
                            fieldWidth: 12.w,
                            selectedFillColor: Colors.black,
                            activeColor: Colors.black,
                            inactiveColor: Colors.grey,
                            activeFillColor: Colors.black,
                            inactiveFillColor: Colors.black,
                            selectedColor: Colors.black),
                        animationDuration: Duration(milliseconds: 300),
                        enableActiveFill: false,
                        controller: otpController,
                        cursorColor: Colors.black,
                        onCompleted: (v) {
                          if (mounted)
                            setState(() {
                              completed = true;
                            });
                        },
                        beforeTextPaste: (text) {
                          print("Allowing to paste $text");
                          //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
                          //but you can show anything you want here, like your pop up saying wrong paste format or etc
                          return true;
                        },
                      ),
                      SizedBox(
                        height: 5.h,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: RoundedButton(
                          text: "Verify OTP",
                          color: completed
                              ? kPrimaryColor
                              : kPrimaryColor.withOpacity(0.5),
                          press: completed
                              ? () async {
                                  if (otpController.text != store.recievedOTP) {
                                    showCustomSnackBar(
                                        context, 'Incorrect OTP entered');
                                  } else {
                                    //Correct Otp
                                    SVProgressHUD.setRingThickness(5);
                                    SVProgressHUD.setRingRadius(5);
                                    SVProgressHUD.setDefaultMaskType(
                                        SVProgressHUDMaskType.black);
                                    SVProgressHUD.show();
                                    //Check User Exist
                                    await http.post(
                                        Uri.parse(appCheckEmail_URL),
                                        body: {
                                          'hash': app_hash,
                                          'email': store.emailID,
                                          'app_id': appID
                                        }).then((response) async {
                                      dynamic data = await compute(
                                          jsonDecode, response.body);
                                      print(data);

                                      //if user exist
                                      if (data['flag'] == 1) {
                                        store.studentData =
                                            StudentData.fromJson(data);
                                        store.studentHash =
                                            store.studentData.userHash!;
                                        store.studentID =
                                            store.studentData.userId!;
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
                                            SVProgressHUD.dismiss();
                                            showCustomSnackBar(context,
                                                'Error connecting to server');
                                          } else {
                                            dynamic data = await compute(
                                                jsonDecode,
                                                userPermission.body);
                                            if (data['flag'] != 1) {
                                              SVProgressHUD.dismiss();
                                              showCustomSnackBar(context,
                                                  'User not granted permission to use this application');
                                            } else {
                                              //Correct OTP
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
                                              prefs.setString(
                                                  'email', store.emailID);
                                              SVProgressHUD.dismiss();
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
                                      //user don't exist make new user by navigating to registerScreen()
                                      else {
                                        Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  RegisterScreen()),
                                        );
                                      }
                                    });
                                  }
                                }
                              : null,
                        ),
                      ),
                    ],
                  ),
                ),
                crossFadeState: _showSecond
                    ? CrossFadeState.showSecond
                    : CrossFadeState.showFirst,
                duration: Duration(milliseconds: 400)),
            duration: Duration(milliseconds: 400),
          ),
        ),
      ),
    );
  }
}
