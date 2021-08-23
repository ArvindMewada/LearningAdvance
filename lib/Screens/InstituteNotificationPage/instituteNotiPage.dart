import 'dart:convert';

import 'package:elearning/MyStore.dart';
import 'package:elearning/constants.dart';
import 'package:elearning/schemas/instituteNotiSchema.dart';
import 'package:elearning/utils/ConvertStringtoUnicode.dart';
import 'package:elearning/utils/LoadHTMLData.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:share/share.dart';
import 'package:velocity_x/velocity_x.dart';

class InstituteNotiPage extends StatefulWidget {
  const InstituteNotiPage({Key? key}) : super(key: key);

  @override
  _InstituteNotiPageState createState() => _InstituteNotiPageState();
}

class _InstituteNotiPageState extends State<InstituteNotiPage> {
  MyStore store = VxState.store;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Institute Notification'),
      ),
      body: FutureBuilder(
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
                                    child: (snapshot.data![index].userImage ==
                                                null ||
                                            snapshot.data![index].userImage ==
                                                '')
                                        ? Icon(Icons.person)
                                        : null,
                                    backgroundImage: (snapshot
                                                    .data![index].userImage ==
                                                null ||
                                            snapshot.data![index].userImage ==
                                                '')
                                        ? null
                                        : NetworkImage(
                                            snapshot.data![index].userImage!)),
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Center(
                                      child: loadData(
                                          snapshot.data![index].postTitle!, 25),
                                    ),
                                    loadData(
                                        snapshot.data![index].postDescription!,
                                        20),
                                    SizedBox(height: 10),
                                    snapshot.data![index].postImage == ''
                                        ? Container()
                                        : Image.network(
                                            'https://careerliftprod.s3.amazonaws.com/mcldiscussionpost/' +
                                                snapshot
                                                    .data![index].postImage!),
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
                                                        color: Colors.black),
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
                                                        color: Colors.black),
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
          }),
    );
  }
}
