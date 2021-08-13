import 'dart:convert';

import 'package:elearning/MyStore.dart';
import 'package:elearning/Screens/MainLayout/MainLayout.dart';
import 'package:elearning/components/phone_input_field.dart';
import 'package:elearning/components/rounded_button.dart';
import 'package:elearning/components/rounded_input_field.dart';
import 'package:elearning/constants.dart';
import 'package:elearning/schemas/studentDataSchema.dart';
import 'package:elearning/schemas/studentPermissionSchema.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svprogresshud/flutter_svprogresshud.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:http/http.dart' as http;
import 'package:responsive_sizer/responsive_sizer.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  late final TextEditingController firstNameController;
  late final TextEditingController lastNameController;
  late final TextEditingController mobNoController;
  MyStore store = VxState.store;
  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    mobNoController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    firstNameController = TextEditingController();
    lastNameController = TextEditingController();
    mobNoController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'User Details',
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text(
                "USER DETAILS",
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25.sp),
              ),
              SizedBox(height: size.height * 0.02),
              RoundedInputField(
                hintText: "First Name",
                color: Colors.grey[200],
                keyboardType: TextInputType.name,
                controller: firstNameController,
              ),
              SizedBox(height: size.height * 0.02),
              RoundedInputField(
                color: Colors.grey[200],
                hintText: "Last Name",
                keyboardType: TextInputType.name,
                controller: lastNameController,
              ),
              SizedBox(height: size.height * 0.02),
              PhoneRoundedInputField(
                  color: Colors.grey[200],
                  hintText: "Mobile Number",
                  icon: Icons.phone,
                  keyboardType: TextInputType.phone,
                  controller: mobNoController),
              SizedBox(height: size.height * 0.02),
              RoundedInputField(
                color: Colors.grey[200],
                hintText: "${store.emailID}",
                icon: Icons.email,
                keyboardType: TextInputType.emailAddress,
                controller: TextEditingController(),
                enabled: false,
              ),
              SizedBox(height: size.height * 0.05),
              RoundedButton(
                color: kPrimaryColor,
                text: 'Submit',
                press: () async {
                  if (firstNameController.text.isEmpty)
                    showCustomSnackBar(context, 'Please enter your First Name');
                  else if (lastNameController.text.isEmpty) {
                    showCustomSnackBar(context, 'Please enter your Last Name');
                  } else if (mobNoController.text.isEmpty) {
                    showCustomSnackBar(
                        context, 'Please enter your Mobile Number');
                  } else if (mobNoController.text.length != 10) {
                    showCustomSnackBar(
                        context, 'Please enter a valid Mobile Number');
                  } else {
                    SVProgressHUD.setRingThickness(5);
                    SVProgressHUD.setRingRadius(5);
                    SVProgressHUD.setDefaultMaskType(
                        SVProgressHUDMaskType.black);
                    SVProgressHUD.show();

                    await http.post(Uri.parse(userRegister_URL), body: {
                      'uFname': firstNameController.text,
                      'uLname': lastNameController.text,
                      'app_id': appID,
                      'mobNo': mobNoController.text,
                      'uEmail': store.emailID,
                      'source': 'mob',
                      'version_code': version_code,
                      'uEduQual': '',
                      'uCity': '',
                      'uState': '',
                      'uCountry': '',
                      'gcm_id': '',
                      'uImage': '',
                      'uType': '',
                      'stream': '',
                    }).then((studentData) async {
                      print(studentData.body);
                      if (studentData.statusCode != 200) {
                        SVProgressHUD.dismiss();
                        showCustomSnackBar(
                            context, 'Error connecting to server');
                      } else {
                        //////////////////////////////////////
                        dynamic data =
                            await compute(jsonDecode, studentData.body);
                        store.studentData = StudentData.fromJson(data);
                        store.studentHash = store.studentData.userHash!;
                        store.studentID = store.studentData.userId!;

                        await http.post(Uri.parse(studentPermissionAPI_URL),
                            body: {
                              'app_hash': app_hash,
                              'user_hash': store.studentHash,
                              'user_id': store.studentID
                            }).then((userPermission) async {
                          if (userPermission.statusCode != 200) {
                            SVProgressHUD.dismiss();
                            showCustomSnackBar(
                                context, 'Error connecting to server');
                          } else {
                            dynamic data =
                                await compute(jsonDecode, userPermission.body);
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
                              ////////////////////////
                              prefs.setBool('isAuth', true);
                              prefs.setString('loginType', 'normal');
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
                    });
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
