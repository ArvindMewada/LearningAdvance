import 'dart:async';

import 'package:elearning/utils/LoadAndDownloadNetworkCall.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:path_provider/path_provider.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../MyStore.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({
    Key? key,
  }) : super(key: key);

  @override
  _SettingScreenState createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  bool _isLoading = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    animateButton();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            appBar: AppBar(
              title: Text("Sync"),
              centerTitle: false,
            ),
            body: ListView(
              scrollDirection: Axis.vertical,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Text(
                        "Downloading App Data",
                        style: TextStyle(
                            color: Colors.grey[700],
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text("Loading Preference"),
                          Container(
                            width: 80,
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(50))),
                            height: 35.0,
                            child: MaterialButton(
                              child: setUpButtonChild(),
                              onPressed: () {
                                setState(() {
                                  if (!_isLoading) animateButton();
                                });
                              },
                              elevation: 4.0,
                              minWidth: double.infinity,
                              height: 35.0,
                              color: _isLoading
                                  ? Colors.grey[400]
                                  : Colors.blueAccent,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 100),
                  child: FlatButton(
                    onPressed: () => Navigator.pop(context),
                    child:
                        Text('Continue', style: TextStyle(color: Colors.blue)),
                    textColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        side: BorderSide(
                            color: Colors.blue,
                            width: 1,
                            style: BorderStyle.solid),
                        borderRadius: BorderRadius.circular(4)),
                  ),
                ),
                SizedBox(
                  height: 40,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(16))),
                    child: MaterialButton(
                      child: Text(
                        "CLEAR DATA & AGAIN",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      onPressed: () {
                        resetApiCall();
                      },
                      elevation: 4.0,
                      minWidth: double.minPositive,
                      height: 35,
                      color: Colors.blueAccent,
                    ),
                  ),
                )
              ],
            )));
  }



  Widget setUpButtonChild() {
    if (!_isLoading) {
      return Icon(Icons.check, color: Colors.white);
    } else {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: CircularProgressIndicator(
          color: Colors.white,
          strokeWidth: 2,
        ),
      );
    }
  }

  void animateButton() {
    final MyStore store = VxState.store;
    getTestListContent(store.dataStore);
    getAppConfigMain(store.dataStore, context);
    getTestReadingElementList(store.dataStore);
    setState(() {
      if (!_isLoading) {
        _isLoading = true;
      }
    });

    Timer(Duration(seconds: 5), () {
      setState(() {
        if (_isLoading) {
          _isLoading = false;
        }
      });
    });
  }
}
