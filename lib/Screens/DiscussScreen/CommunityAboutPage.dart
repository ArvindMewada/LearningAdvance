import 'dart:convert';

import 'package:elearning/MyStore.dart';
import 'package:elearning/constants.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:http/http.dart' as http;

class CommunityAboutPage extends StatefulWidget {
  final String communityID;
  final String title;
  const CommunityAboutPage(
      {Key? key, required this.communityID, required this.title})
      : super(key: key);

  @override
  _CommunityAboutPageState createState() => _CommunityAboutPageState();
}

class _CommunityAboutPageState extends State<CommunityAboutPage> {
  late ScrollController _controller;
  Future<dynamic> getGroupAbout() async {
    MyStore store = VxState.store;
    dynamic groupDetails;
    await http.post(Uri.parse(communityAboutPage_URL), body: {
      'user_id': store.studentID,
      'user_hash': store.studentHash,
      'app_id': appID,
      'community_id': widget.communityID,
    }).then((value) async {
      groupDetails = await compute(jsonDecode, value.body);
    });
    return groupDetails;
  }

  @override
  void initState() {
    _controller = ScrollController();
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
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: FutureBuilder(
            future: getGroupAbout(),
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              if (snapshot.hasData)
                return ListView(
                  padding: EdgeInsets.all(20),
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(15),
                      child: CircleAvatar(
                        radius: 70,
                      ),
                    ),
                    Material(
                      elevation: 20,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      child: Padding(
                        padding: const EdgeInsets.all(15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Text(
                                  'Followers',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  snapshot.data['count_follower'],
                                  style: TextStyle(fontSize: 30),
                                ),
                              ],
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Text(
                                  'Posts',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  snapshot.data['count_post'],
                                  style: TextStyle(fontSize: 30),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    Text(snapshot.data['about'])
                  ],
                );
              return Center(
                child: CircularProgressIndicator(),
              );
            }));
  }
}
