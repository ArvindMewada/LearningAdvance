import 'dart:async';

import 'package:flutter/material.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({
    Key? key,
  }) : super(key: key);

  @override
  _SettingScreenState createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  int _state = 0;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            appBar: AppBar(
              title: Text("Setting"),
            ),
            body: ListView(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text("Loading Preference"),
                    Container(
                      width: 80,
                      height: 35,
                      child: MaterialButton(
                        child: setUpButtonChild(),
                        onPressed: () {
                          setState(() {
                            if (_state == 0) {
                              animateButton();
                            }
                          });
                        },
                        elevation: 4.0,
                        minWidth: double.infinity,
                        height: 48.0,
                        color: Colors.blueAccent,
                      ),
                    ),
                  ],
                )
              ],
            )));
  }

  Widget setUpButtonChild() {
    if (_state == 0) {
      return Icon(Icons.check, color: Colors.white);
    } else {
      return CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
      );
    }
  }

  void animateButton() {
    Timer(Duration(milliseconds: 3300), () {
      setState(() {
        _state = 0;
      });
    });
  }
}
