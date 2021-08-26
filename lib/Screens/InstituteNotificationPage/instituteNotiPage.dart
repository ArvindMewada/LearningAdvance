import 'dart:convert';

import 'package:elearning/MyStore.dart';
import 'package:elearning/constants.dart';
import 'package:elearning/schemas/instituteNotiSchema.dart';
import 'package:elearning/utils/ConvertStringtoUnicode.dart';
import 'package:elearning/utils/LoadAndDownloadNetworkCall.dart';
import 'package:elearning/utils/LoadHTMLData.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:velocity_x/velocity_x.dart';

class InstituteNotiPage extends StatefulWidget {
  const InstituteNotiPage({Key? key}) : super(key: key);

  @override
  _InstituteNotiPageState createState() => _InstituteNotiPageState();
}

class _InstituteNotiPageState extends State<InstituteNotiPage> {
  MyStore store = VxState.store;
  bool isPermission = false;

  Future<List<InstituteNoti>> getInstNoti() async {
    late List<InstituteNoti> data;
    await http.post(Uri.parse(fetchInstPostType_URL), body: {
      'app_id': appID,
      'user_id': store.studentID,
      'user_hash': store.studentHash,
      'post_type': 'notification',
    }).then((value) {
      List<dynamic> recievedData = jsonDecode(value.body);
      data = recievedData.map((e) => InstituteNoti.fromJson(e)).toList();
    });
    data = data.where((element) => element.status == 'publish').toList();
    return data;
  }

  void isAccessAllow(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var permission = prefs.getString("access_allow");
    var flag = prefs.getInt("app_user_permission_access_v0_flag");
    if (permission == null || permission == "false") {
      getMessageFlag(flag);
    } else {
      setState(() {
        isPermission = true;
      });
    }
  }

  getMessageFlag(var flag) {
    String getText = "";
    switch (flag) {
      case 0:
        {
          getText = "Something went wrong, Please try again";
          break;
        }
      case 1:
        {
          getText = "Your request submitted to enable app access";
          break;
        }
      case 2:
        {
          getText = "You already requested to enable your access for this app";
          break;
        }
    }
    showPermissionDialog(context, getText);
  }

  void showPermissionDialog(BuildContext context, String msg) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return new AlertDialog(
            title:
                msg.length > 1 ? new Text("$msg") : new Text("Enable access"),
            content: new Text(
              "Please ask your Institute administrator to enable your access for this app",
              textAlign: TextAlign.center,
            ),
            actions: [
              RaisedButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                child: Text("Cancel"),
              ),
              RaisedButton(
                onPressed: () async {
                  if(msg.length < 1) await askFieldPermissionAccess(context, store);
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                color: Colors.blue,
                child:   Text(
                  msg.length > 1 ? "Ok" : "Enable access"  ,
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              )
            ],
            elevation: 8,
          );
        });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      isAccessAllow(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Institute Notification'),
      ),
      body: isPermission
          ? FutureBuilder(
              future: getInstNoti(),
              builder: (context, AsyncSnapshot<List<InstituteNoti>> snapshot) {
                if (snapshot.hasData)
                  return ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        String ampm = 'AM';
                        int timePrefix = int.parse(
                            snapshot.data![index].postDate!.substring(11, 13));
                        if (timePrefix >= 12) ampm = 'PM';
                        if (timePrefix > 12) timePrefix -= 12;
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Card(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15)),
                              elevation: 10,
                              child: Column(
                                children: [
                                  ListTile(
                                    leading: CircleAvatar(
                                        child:
                                            (snapshot.data![index].userImage ==
                                                        null ||
                                                    snapshot.data![index]
                                                            .userImage ==
                                                        '')
                                                ? Icon(Icons.person)
                                                : null,
                                        backgroundImage:
                                            (snapshot.data![index].userImage ==
                                                        null ||
                                                    snapshot.data![index]
                                                            .userImage ==
                                                        '')
                                                ? null
                                                : NetworkImage(snapshot
                                                    .data![index].userImage!)),
                                    trailing: IconButton(
                                        onPressed: () {},
                                        icon: Icon(Icons.more_vert)),
                                    subtitle: Text(
                                        '${snapshot.data![index].postDate!.substring(8, 10) + snapshot.data![index].postDate!.substring(4, 7) + '-' + snapshot.data![index].postDate!.substring(0, 4) + '        ' + timePrefix.toString() + ':' + snapshot.data![index].postDate!.substring(14, 16) + ' ' + ampm}'),
                                    title: Text(convertStringToUnicode(
                                        snapshot.data![index].fname! +
                                            ' ' +
                                            snapshot.data![index].lname!)),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Center(
                                          child: loadData(
                                              snapshot.data![index].postTitle!,
                                              25),
                                        ),
                                        loadData(
                                            snapshot
                                                .data![index].postDescription!,
                                            20),
                                        SizedBox(height: 10),
                                        snapshot.data![index].postImage == ''
                                            ? Container()
                                            : Image.network(
                                                'https://careerliftprod.s3.amazonaws.com/mcldiscussionpost/' +
                                                    snapshot.data![index]
                                                        .postImage!),
                                        Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                children: [
                                                  TextButton.icon(
                                                      label: Text(
                                                        '${snapshot.data![index].upvoteCount}',
                                                        style: TextStyle(
                                                            color:
                                                                Colors.black),
                                                      ),
                                                      onPressed: null,
                                                      icon: Icon(
                                                        Icons.favorite_border,
                                                        color: Colors.black,
                                                      )),
                                                  TextButton.icon(
                                                      label: Text(
                                                        '${snapshot.data![index].viewCount}',
                                                        style: TextStyle(
                                                            color:
                                                                Colors.black),
                                                      ),
                                                      onPressed: null,
                                                      icon: Icon(
                                                        Icons.remove_red_eye,
                                                        color: Colors.black,
                                                      )),
                                                ],
                                              ),
                                              IconButton(
                                                  onPressed: () {
                                                    Share.share(
                                                        snapshot
                                                                .data![index]
                                                                .postDescription!
                                                                .isEmptyOrNull
                                                            ? 'Test'
                                                            : convertStringToUnicode(
                                                                '${snapshot.data![index].postDescription}'),
                                                        subject: snapshot
                                                                .data![index]
                                                                .postTitle!
                                                                .isEmptyOrNull
                                                            ? 'Test '
                                                            : convertStringToUnicode(
                                                                '${snapshot.data![index].postTitle}'));
                                                  },
                                                  icon: Icon(Icons.share))
                                            ]),
                                      ],
                                    ),
                                  ),
                                ],
                              )),
                        );
                      });
                return Center(child: CircularProgressIndicator());
              })
          : Container(),
    );
  }
}
