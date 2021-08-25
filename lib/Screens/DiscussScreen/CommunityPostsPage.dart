import 'dart:convert';
import 'dart:math';

import 'package:elearning/MyStore.dart';
import 'package:elearning/Screens/DiscussScreen/CommunityAboutPage.dart';
import 'package:elearning/Screens/DiscussScreen/CommunityPostView.dart';
import 'package:elearning/Screens/DiscussScreen/NewPostPage.dart';
import 'package:elearning/constants.dart';
import 'package:elearning/dbModel.dart';
import 'package:elearning/schemas/communityPostsSchema.dart';
import 'package:elearning/utils/ConvertStringtoUnicode.dart';
import 'package:elearning/utils/LoadHTMLData.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svprogresshud/flutter_svprogresshud.dart';
import 'package:http/http.dart' as http;
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'package:velocity_x/velocity_x.dart';

class CommunityPostsPage extends StatefulWidget {
  final String title;
  final String communityID;

  const CommunityPostsPage(
      {Key? key, required this.title, required this.communityID})
      : super(key: key);

  @override
  _CommunityPostsPageState createState() => _CommunityPostsPageState();
}

class _CommunityPostsPageState extends State<CommunityPostsPage> {
  MyStore store = VxState.store;
  String groupHashTag = '';
  String communityID = '';
  late SharedPreferences sharedPreferences;

  Future<CommunityPosts> getCommunityPosts() async {
    late CommunityPosts data;
    await http.post(Uri.parse(discussPostList_URL), body: {
      'user_id': store.studentID,
      'user_hash': store.studentHash,
      'app_id': appID,
      'pref_community_ids': widget.communityID,
      'post_count': '',
      'max_user_post_sync_id': '',
      'limit': '',
    }).then((value) async {
      dynamic recievedData = await compute(jsonDecode, value.body);
      data = CommunityPosts.fromJson(recievedData);
    });
    data.posts =
        data.posts!.where((element) => element.status == 'publish').toList();
    return data;
  }

  void viewComments(AsyncSnapshot<CommunityPosts> snapshot, int index) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => CommunityPostView(
                details: Post(
                    post_id: snapshot.data!.posts![index].postId!,
                    community_id: snapshot.data!.posts![index].communityId!,
                    app_id: snapshot.data!.posts![index].appId!,
                    user_id: snapshot.data!.posts![index].userId!,
                    fname: snapshot.data!.posts![index].fname!,
                    lname: snapshot.data!.posts![index].lname!,
                    post_type: snapshot.data!.posts![index].postType,
                    post_title: snapshot.data!.posts![index].postTitle!,
                    post_description:
                        snapshot.data!.posts![index].postDescription!,
                    video_url: snapshot.data!.posts![index].videoUrl!,
                    user_org_name: snapshot.data!.posts![index].userOrgName,
                    comment_count: snapshot.data!.posts![index].commentCount!,
                    upvote_count: snapshot.data!.posts![index].upvoteCount!,
                    view_count: snapshot.data!.posts![index].viewCount!,
                    city_name: snapshot.data!.posts![index].cityName!,
                    spam_count: snapshot.data!.posts![index].spamCount!,
                    post_date: snapshot.data!.posts![index].postDate!,
                    is_notify: snapshot.data!.posts![index].isNotify!,
                    tag: snapshot.data!.posts![index].tag,
                    question_reward:
                        snapshot.data!.posts![index].questionReward,
                    correct_response:
                        snapshot.data!.posts![index].correctResponse,
                    status: snapshot.data!.posts![index].status!,
                    is_user_post: snapshot.data!.posts![index].isUserPost!,
                    display_type: snapshot.data!.posts![index].displayType!,
                    reserve_1: snapshot.data!.posts![index].reserve1!,
                    group_hash_tag: snapshot.data!.posts![index].groupHashTag!,
                    ques_attempt_flag:
                        snapshot.data!.posts![index].quesAttemptFlag!,
                    is_ques_correct:
                        snapshot.data!.posts![index].isQuesCorrect!,
                    attemptmsg: snapshot.data!.posts![index].attemptmsg!,
                    post_image: snapshot.data!.posts![index].postImage!,
                    upvoteFlag: snapshot.data!.posts![index].upvoteFlag!,
                    job_title: snapshot.data!.posts![index].jobTitle!,
                    user_image: snapshot.data!.posts![index].userImage))));
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          MaterialButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => CommunityAboutPage(
                          communityID: widget.communityID,
                          title: widget.title)));
            },
            child: Icon(Icons.info_outlined),
          )
        ],
        title: Text(
          widget.title,
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        heroTag: null,
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => NewPostPage(
                      tag: widget.title,
                      groupHashTag: groupHashTag,
                      communityID: communityID)));
        },
        label: Text('New Post'),
        icon: Icon(Icons.add),
      ),
      body: FutureBuilder(
          future: getCommunityPosts(),
          builder: (context, AsyncSnapshot<CommunityPosts> snapshot) {
            if (snapshot.hasData) {
              groupHashTag = snapshot.data!.posts![0].groupHashTag!;
              communityID = snapshot.data!.posts![0].communityId!;
              return ListView.builder(
                  itemCount: snapshot.data!.posts!.length,
                  itemBuilder: (context, index) {
                    String ampm = 'AM';
                    int timePrefix = int.parse(snapshot
                        .data!.posts![index].postDate!
                        .substring(11, 13));
                    if (timePrefix >= 12) ampm = 'PM';
                    if (timePrefix > 12) timePrefix -= 12;
                    int counter = snapshot.data!.posts![0].upvoteCount!;

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
                                    child: (snapshot.data!.posts![index]
                                                    .userImage ==
                                                null ||
                                            snapshot.data!.posts![index]
                                                    .userImage ==
                                                '')
                                        ? Icon(Icons.person)
                                        : null,
                                    backgroundImage: (snapshot.data!
                                                    .posts![index].userImage ==
                                                null ||
                                            snapshot.data!.posts![index]
                                                    .userImage ==
                                                '')
                                        ? null
                                        : NetworkImage(snapshot
                                            .data!.posts![index].userImage!)),
                                trailing: IconButton(
                                    onPressed: () {},
                                    icon: Icon(Icons.more_vert)),
                                subtitle: Text(
                                    '${snapshot.data!.posts![index].postDate!.substring(8, 10) + snapshot.data!.posts![index].postDate!.substring(4, 7) + '-' + snapshot.data!.posts![index].postDate!.substring(0, 4) + '        ' + timePrefix.toString() + ':' + snapshot.data!.posts![index].postDate!.substring(14, 16) + ' ' + ampm}'),
                                title: Text(convertStringToUnicode(
                                    snapshot.data!.posts![index].fname! +
                                        ' ' +
                                        snapshot.data!.posts![index].lname!)),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Center(
                                      child: loadData(
                                          snapshot
                                              .data!.posts![index].postTitle!,
                                          21),
                                    ),
                                    loadData(
                                        snapshot.data!.posts![index]
                                            .postDescription!,
                                        20),
                                    SizedBox(height: 10),
                                    snapshot.data!.posts![index].postImage == ''
                                        ? Container()
                                        : Image.network(
                                            'https://careerliftprod.s3.amazonaws.com/mcldiscussionpost/' +
                                                snapshot.data!.posts![index]
                                                    .postImage!),
                                    Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              TextButton.icon(
                                                  label: Text(
                                                    '${snapshot.data!.posts![index].upvoteCount}',
                                                    style: TextStyle(
                                                        color: Colors.black),
                                                  ),
                                                  onPressed: () async {
                                                    SVProgressHUD
                                                        .setRingThickness(5);
                                                    SVProgressHUD.setRingRadius(
                                                        5);
                                                    SVProgressHUD
                                                        .setDefaultMaskType(
                                                            SVProgressHUDMaskType
                                                                .black);
                                                    SVProgressHUD.show();
                                                    await incrementUpvotePost(
                                                        snapshot
                                                            .data!
                                                            .posts![index]
                                                            .postId!);
                                                    if (mounted) {
                                                      setState(() {
                                                        snapshot
                                                                .data!
                                                                .posts![index]
                                                                .upvoteCount =
                                                            (counter + 1);
                                                        final box = store
                                                            .dataStore
                                                            .box<Post>();
                                                        List<Post> temp =
                                                            box.getAll();
                                                        temp[index]
                                                                .upvote_count =
                                                            counter + 1;
                                                        box.removeAll();
                                                        box.putMany(temp);
                                                      });
                                                    }

                                                    SVProgressHUD.dismiss();
                                                  },
                                                  icon: Icon(
                                                    Icons.favorite_border,
                                                    color: Colors.black,
                                                  )),
                                              IconButton(
                                                  onPressed: () {
                                                    viewComments(
                                                        snapshot, index);
                                                  },
                                                  icon: Icon(Icons
                                                      .mode_comment_outlined)),
                                              TextButton.icon(
                                                  label: Text(
                                                    '${snapshot.data!.posts![index].viewCount}',
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
                                                            .data!
                                                            .posts![index]
                                                            .postDescription!
                                                            .isEmptyOrNull
                                                        ? 'Test'
                                                        : convertStringToUnicode(
                                                            '${snapshot.data!.posts![index].postDescription}'),
                                                    subject: snapshot
                                                            .data!
                                                            .posts![index]
                                                            .postTitle!
                                                            .isEmptyOrNull
                                                        ? 'Test '
                                                        : convertStringToUnicode(
                                                            '${snapshot.data!.posts![index].postTitle}'));
                                              },
                                              icon: Icon(Icons.share))
                                        ]),
                                    snapshot.data!.posts![index].commentCount! >
                                            0
                                        ? TextButton(
                                            style: ButtonStyle(
                                              overlayColor: MaterialStateColor
                                                  .resolveWith((states) =>
                                                      Colors.transparent),
                                            ),
                                            onPressed: () {
                                              viewComments(snapshot, index);
                                            },
                                            child: Text(
                                              'View all ' +
                                                  '${snapshot.data!.posts![index].commentCount}' +
                                                  ' comment(s)',
                                              style:
                                                  TextStyle(color: Colors.grey),
                                            ))
                                        : Container()
                                  ],
                                ),
                              ),
                            ],
                          )),
                    );
                  });
            }
            return Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[400]!,
              child: ListView.builder(
                  itemExtent: 60,
                  itemCount: (MediaQuery.of(context).size.height) ~/ 60,
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        ListTile(
                          leading: CircleAvatar(),
                          title: Container(
                            color: Colors.white,
                            height: 10,
                            width: Random().nextDouble(),
                          ),
                        ),
                      ],
                    );
                  }),
            );
          }),
    );
  }

  incrementUpvotePost(String postId) async {
    MyStore store = VxState.store;
    await http.post(Uri.parse(discussionPostUpvote_URL), body: {
      'user_id': store.studentID,
      'user_hash': store.studentHash,
      'app_id': appID,
      'post_id': postId,
    });
  }
}
