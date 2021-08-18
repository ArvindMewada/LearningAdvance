import 'dart:convert';
import 'package:elearning/MyStore.dart';
import 'package:elearning/schemas/liveClassSchema.dart';
import 'package:elearning/constants.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:elearning/utils/webview.dart';


class LiveClassesScreen extends StatefulWidget {
  const LiveClassesScreen({Key? key}) : super(key: key);

  @override
  _LiveClassesScreenState createState() => _LiveClassesScreenState();
}

class _LiveClassesScreenState extends State<LiveClassesScreen>
    with KeepAliveParentDataMixin {
  MyStore store = VxState.store;


  //Api call for getting data of past classes
  Future<LiveClassScheme> fetchUpcomingClasses() async {
    try {
      final response =
          await http.post(Uri.parse(fetchUpcomingLiveClasses_URL), body: {
        'app_id': appID,
        'app_hash': app_hash,
        'user_id': store.studentID,
        'user_hash': store.studentHash
      });
      dynamic jsonData = await compute(jsonDecode, response.body);
      print('Json Data Upcoming Class');
      print(jsonData);
      print('Json Data Upcoming Class');
      return LiveClassScheme.fromJson(jsonData);
    } catch (err) {
      print('Error in Upcoming Class');
      print(err);
      return LiveClassScheme(flag: 1, liveClass: []);
    }
  }

  //Api call to fetch the ongoing live class data
  Future<LiveClassScheme> fetchPastClasses() async {
    try {
      final response =
          await http.post(Uri.parse(fetchPastLiveClasses_URL), body: {
        'app_id': appID,
        'app_hash': app_hash,
        'user_id': store.studentID,
        'user_hash': store.studentHash
      });
      dynamic jsonData = jsonDecode(response.body) as Map;
      print('JSON DATA Past');
      print(jsonData);
      print('JSON DATA Past End');
      return LiveClassScheme.fromJson(jsonData);
    } catch (err) {
      print('Error in Past Class');
      print(err);
      return LiveClassScheme(flag: 1, liveClass: []);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
            appBar: AppBar(
              title: Text('Live Classes'),
            ),
            bottomNavigationBar: Container(
              color: kPrimaryColor,
              child: TabBar(
                labelColor: Colors.white,
                unselectedLabelColor: Colors.white70,
                indicatorPadding: EdgeInsets.all(5.0),
                indicatorColor: Colors.white54,
                tabs: [
                  Tab(child: Text('Upcoming Classes')),
                  Tab(child: Text('Past Classes')),
                ],
              ),
            ),
            body: TabBarView(children: [
              FutureBuilder(
                //Upcoming Classes Builder
                future: fetchUpcomingClasses(),
                builder: (context, AsyncSnapshot<LiveClassScheme> snapshot) {
                  print('Building Upcoming Live Classes');
                  if (snapshot.hasData) if (snapshot.data!.liveClass!.length !=
                      0)
                    return ListView.builder(
                        itemCount: snapshot.data!.liveClass!.length,
                        itemBuilder: (context, index) {
                          return LiveClassCard(
                            data: snapshot.data!.liveClass![index],
                            tabNumber: 0,
                          );
                        });
                  else
                    return Center(child: Text('No Upcoming Classes!!'));
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                },
              ),
              FutureBuilder(
                //Past Classes Builder
                future: fetchPastClasses(),
                builder: (context, AsyncSnapshot<LiveClassScheme> snapshot) {
                  if (snapshot.hasData) if (snapshot.data!.liveClass!.length !=
                      0)
                    return ListView.builder(
                        itemCount: snapshot.data!.liveClass!.length,
                        itemBuilder: (context, index) {
                          return LiveClassCard(
                              data: snapshot.data!.liveClass![index],
                              tabNumber: 1);
                        });
                  else
                    return Center(child: Text('No Past Classes!!'));

                  return Center(child: CircularProgressIndicator());
                },
              ),
            ])),
      ),
    );
  }

  @override
  void detach() {}

  @override
  bool get keptAlive => true;
}

//to display different cards
class LiveClassCard extends StatefulWidget {
  final LiveClass data;
  final int tabNumber;
  const LiveClassCard({required this.data, Key? key, required this.tabNumber})
      : super(key: key);

  @override
  _LiveClassCardState createState() => _LiveClassCardState();
}

class _LiveClassCardState extends State<LiveClassCard> {
  bool isMicPermission = false;

  void permissionCheck() async {
    Fluttertoast.showToast(msg: "request");
   await [
      Permission.microphone,
      Permission.camera,
    ].request();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ListTile(
            title: Text(
              widget.data.title!,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Color(0xFF3F5AA6),
              ),
            ),
            subtitle: Text(widget.data.comment!),
          ),
          // date of the test
          Row(
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(left: 15),
                child: Icon(
                  Icons.date_range_outlined,
                  size: 20,
                ),
              ),
              Container(
                padding: EdgeInsets.only(left: 5),
                child: Text(
                  widget.data.classDate!,
                  style: TextStyle(
                    color: Colors.green,
                  ),
                ),
              ),
            ],
          ),

          // time of the test
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.only(left: 15),
                    child: Icon(
                      Icons.access_time,
                      size: 20,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 5),
                    child: Text(
                      widget.data.startTime! + ' - ' + widget.data.endTime!,
                      style: TextStyle(
                        color: Colors.green,
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                padding: EdgeInsets.only(right: 15),
                child: Text(
                  widget.data.duration!,
                  style: TextStyle(
                    color: Colors.green,
                  ),
                ),
              ),
            ],
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              TextButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all((widget.tabNumber == 0)
                        ? (isClassStarted(widget.data.startTime!)
                            ? Colors.blue[900]
                            : Colors.grey[500])
                        : widget.data.recordedLink.isEmptyOrNull
                            ? Colors.grey[500]
                            : Colors.blue[900]),
                  ),

                  // tabNumber 0:LiveClass Tab, 1:Past Class Tab
                  child: Text(
                    (widget.tabNumber == 0)
                        ? isClassStarted(widget.data.startTime!)
                            ? 'Join'
                            : 'Scheduled'
                        : widget.data.recordedLink.isEmptyOrNull
                            ? 'N/A'
                            : 'Play',
                    style: TextStyle(
                      color: Colors.white,
                      // fontStyle: FontStyle.italic,
                    ),
                  ),
                  onPressed: () {
                    if ((widget.tabNumber == 1 && !widget.data.recordedLink.isEmptyOrNull) ||
                        (widget.tabNumber == 0 && isClassStarted(widget.data.startTime!))) {
                      //to disable click when recording is not available
                      permissionCheck();
                      permissionGranted();
                    }
                  }),
              const SizedBox(width: 8),
            ],
          ),
        ],
      ),
    );
  }

  void permissionGranted() async {
    if(await Permission.microphone.isGranted){
      Navigator.of(context).push(MaterialPageRoute(
          builder: (BuildContext context) => MyWebView(
            selectedUrl: (widget.tabNumber == 0)
                ? widget.data.url
                : widget.data.recordedLink,
            tabNo: widget.tabNumber,
          )));
    }
  }
  bool isClassStarted(String classStartTime) {
    int a = int.parse(classStartTime.substring(0, 2));
    int b = classStartTime.substring(6) == 'pm' ? 12 : 0;
    int c = int.parse(classStartTime.substring(3, 5));
    int timeOfClass = (a + b) * 60 + c;
    int currentTime = DateTime.now().hour * 60 + DateTime.now().minute;
    return currentTime > timeOfClass-15;
    //class starts 15 min early
  }
}
