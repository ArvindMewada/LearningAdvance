import 'dart:convert';

import 'package:elearning/MyStore.dart';
import 'package:elearning/Screens/FullLengthTestScreen/FLTTestDataPage.dart';
import 'package:elearning/constants.dart';
import 'package:elearning/dbModel.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:velocity_x/velocity_x.dart';

class FullLengthTestScreen extends StatefulWidget {
  const FullLengthTestScreen({Key? key}) : super(key: key);

  @override
  _FullLengthTestScreenState createState() => _FullLengthTestScreenState();
}

class _FullLengthTestScreenState extends State<FullLengthTestScreen> {
  late BehaviorSubject<List<FLTExamElement>> _stream;
  MyStore store = VxState.store;
  late SharedPreferences _sharedPreferences;
  late bool isHindi = false;
  @override
  void initState() async {
    if (mounted)
      setState(() {
        _stream = BehaviorSubject();
        _stream.addStream(store.dataStore
            .box<FLTExamElement>()
            .query()
            .watch(triggerImmediately: true)
            .map((query) => query.find()));
      });
    _sharedPreferences = await SharedPreferences.getInstance();
    super.initState();
  }

  void isAccessAllow () async {
    final isPermission = _sharedPreferences.getString("access_allow");
    if(isPermission != null && isPermission == "Yes") {
      print("hey cong");
    }
  }
  @override
  Widget build(BuildContext context) {
    isAccessAllow();
    return Scaffold(
      appBar: AppBar(
        title: Text('Full Length Test'),
      ),
      body: StreamBuilder(
        stream: _stream,
        builder: (context, AsyncSnapshot<List<FLTExamElement>> snapshot) {
          if (snapshot.hasData &&
              !store.dataStore.box<FLTExamElement>().isEmpty()) {
            List data = List.from(snapshot.data!)
                .map((element) => jsonDecode(element.sub_menu1!))
                .toList();
            return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Material(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      elevation: 5,
                      child: ExpansionTile(
                        collapsedIconColor: kPrimaryColor,
                        iconColor: kPrimaryColor,
                        textColor: Colors.black,
                        title: Text(
                          snapshot.data![index].title!,
                        ),
                        subtitle: Text(snapshot.data![index].subtitle!),
                        children: List.from(data[index])
                            .map((element) => ListTile(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => FLTTestDataPage(
                                              isHindi: snapshot
                                                      .data![index].subtitle!
                                                      .contains('Hindi')
                                                  ? true
                                                  : false,
                                              title: element['name'],
                                              exam_id: element['exam_id'],
                                              exam_id_2:
                                                  element['exam_id_2'])));
                                },
                                trailing: Icon(
                                  Icons.keyboard_arrow_right,
                                  color: kPrimaryColor,
                                  size: 30,
                                ),
                                title: Text(element['name'])))
                            .toList(),
                      ),
                    ),
                  );
                });
          }

          return (Center(child: CircularProgressIndicator()));
        },
      ),
    );
  }
}
