import 'dart:convert';
import 'package:elearning/MyStore.dart';
import 'package:elearning/Screens/DiscussScreen/CommunityPostView.dart';
import 'package:elearning/constants.dart';
import 'package:elearning/dbModel.dart';
import 'package:elearning/utils/ConvertStringtoUnicode.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:flutter_svprogresshud/flutter_svprogresshud.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:http/http.dart' as http;
import 'package:share/share.dart';

class DiscussScreen extends StatefulWidget {
  final AdvancedDrawerController? controller;
  DiscussScreen({required this.controller});
  @override
  _DiscussScreenState createState() => _DiscussScreenState();
}

class _DiscussScreenState extends State<DiscussScreen> {
  bool collapsed = false;
  late bool isDone;
  late List<Post> discussPostList;
  late SharedPreferences prefs;
  MyStore store = VxState.store;
  late ScrollController _controller;

  getDiscussList() async {
    MyStore store = VxState.store;
    final box = store.dataStore.box<Post>();
    prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('pref_community_ids_old')) {
      await prefs.setStringList('pref_community_ids_old', []);
    }
    if (!prefs.containsKey('pref_community_ids')) {
      await prefs.setStringList('pref_community_ids', []);
    }
    if (prefs.getStringList('pref_community_ids_old')!.toString() !=
        prefs.getStringList('pref_community_ids')!.toString()) {
      List<String> updated = prefs.getStringList('pref_community_ids')!;
      await prefs.setStringList('pref_community_ids_old', updated);
      await http.post(Uri.parse(discussPostList_URL), body: {
        'user_id': store.studentID,
        'user_hash': store.studentHash,
        'app_id': appID,
        'pref_community_ids': (prefs.containsKey('pref_community_ids'))
            ? (prefs.getStringList('pref_community_ids')!.isNotEmpty)
                ? prefs
                    .getStringList('pref_community_ids')
                    .toString()
                    .eliminateFirst
                    .eliminateLast
                : ''
            : '',
        'post_count': '',
        'max_user_post_sync_id': '',
        'limit': '',
      }).then((value) async {
        dynamic data = await compute(jsonDecode, value.body);
        print(data);
        List postList =
            (data.toString().contains('posts')) ? data['posts'] : [];
        box.removeAll();
        postList.forEach((element) async {
          Post post = Post(
              post_id: element['post_id'],
              community_id: element['community_id'],
              app_id: element['app_id'],
              user_id: element['user_id'],
              fname: element['fname'],
              lname: element['lname'],
              post_type: element['post_type'],
              post_title: element['post_title'],
              post_description: element['post_description'],
              video_url: element['video_url'],
              user_org_name: element['user_org_name'],
              comment_count: element['comment_count'],
              upvote_count: element['upvote_count'],
              view_count: element['view_count'],
              city_name: element['city_name'],
              spam_count: element['spam_count'],
              post_date: element['post_date'],
              is_notify: element['is_notify'],
              tag: element['tag'],
              question_reward: element['question_reward'],
              correct_response: element['correct_response'],
              status: element['status'],
              is_user_post: element['is_user_post'],
              display_type: element['display_type'],
              reserve_1: element['reserve_1'],
              group_hash_tag: element['group_hash_tag'],
              ques_attempt_flag: element['ques_attempt_flag'],
              is_ques_correct: element['is_ques_correct'],
              attemptmsg: element['attemptmsg'],
              post_image: element['post_image'],
              upvoteFlag: element['upvoteFlag'],
              job_title: element['job_title'],
              user_image: element['user_image']);
          await box.putAsync(post);
        });
        discussPostList = box.query().build().find();
        if (mounted) {
          setState(() {
            isDone = true;
          });
        }
      });
    } else {
      discussPostList = box.query().build().find();
      if (mounted) {
        setState(() {
          isDone = true;
        });
      }
      prefs = await SharedPreferences.getInstance();
      MyStore store = VxState.store;
      await http.post(Uri.parse(discussPostList_URL), body: {
        'user_id': store.studentID,
        'user_hash': store.studentHash,
        'app_id': appID,
        'pref_community_ids': (prefs.containsKey('pref_community_ids'))
            ? (prefs.getStringList('pref_community_ids')!.isNotEmpty)
                ? prefs
                    .getStringList('pref_community_ids')
                    .toString()
                    .eliminateFirst
                    .eliminateLast
                : ''
            : '',
        'post_count': '',
        'max_user_post_sync_id': '',
        'limit': '',
      }).then((value) async {
        dynamic data = await compute(jsonDecode, value.body);
        print(data);
        List postList =
            (data.toString().contains('posts')) ? data['posts'] : [];
        box.removeAll();
        postList.forEach((element) async {
          Post post = Post(
              post_id: element['post_id'],
              community_id: element['community_id'],
              app_id: element['app_id'],
              user_id: element['user_id'],
              fname: element['fname'],
              lname: element['lname'],
              post_type: element['post_type'],
              post_title: element['post_title'],
              post_description: element['post_description'],
              video_url: element['video_url'],
              user_org_name: element['user_org_name'],
              comment_count: element['comment_count'],
              upvote_count: element['upvote_count'],
              view_count: element['view_count'],
              city_name: element['city_name'],
              spam_count: element['spam_count'],
              post_date: element['post_date'],
              is_notify: element['is_notify'],
              tag: element['tag'],
              question_reward: element['question_reward'],
              correct_response: element['correct_response'],
              status: element['status'],
              is_user_post: element['is_user_post'],
              display_type: element['display_type'],
              reserve_1: element['reserve_1'],
              group_hash_tag: element['group_hash_tag'],
              ques_attempt_flag: element['ques_attempt_flag'],
              is_ques_correct: element['is_ques_correct'],
              attemptmsg: element['attemptmsg'],
              post_image: element['post_image'],
              upvoteFlag: element['upvoteFlag'],
              job_title: element['job_title'],
              user_image: element['user_image']);
          await box.putAsync(post);
        });
        discussPostList = box.query().build().find();
        if (mounted) {
          setState(() {
            isDone = true;
          });
        }
      });
    }
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

  @override
  void initState() {
    isDone = false;
    discussPostList = [];

    _controller = ScrollController();
    getDiscussList();

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: Key('DiscussScreen'),
        floatingActionButton: FloatingActionButton.extended(
          tooltip: 'New Post',
          onPressed: () {},
          label: Text('New Post'),
          isExtended: true,
          icon: Icon(Icons.add),
        ),
        body: NestedScrollView(
            controller: _controller,
            headerSliverBuilder: (context, isInnerScrolled) {
              return [
                SliverAppBar(
                    stretch: true,
                    backgroundColor: Vx.teal500,
                    elevation: 20,
                    forceElevated: true,
                    actions: [
                      IconButton(
                          onPressed: () async {
                            if (mounted) {
                              setState(() {
                                isDone = false;
                              });
                            }
                            await getDiscussList();
                          },
                          icon: Icon(Icons.sort))
                    ],
                    shape: sliverAppBarShape,
                    leading: IconButton(
                        onPressed: () {
                          widget.controller!.toggleDrawer();
                        },
                        icon: Icon(Icons.menu)),
                    expandedHeight: 200.0,
                    floating: false,
                    pinned: true,
                    flexibleSpace: LayoutBuilder(
                      builder:
                          (BuildContext context, BoxConstraints constraints) {
                        return FlexibleSpaceBar(
                          centerTitle: true,
                          titlePadding: const EdgeInsets.symmetric(
                              horizontal: 60, vertical: 5),
                          title: (constraints.biggest.height ==
                                  MediaQuery.of(context).padding.top +
                                      kToolbarHeight)
                              ? Padding(
                                  padding: EdgeInsets.only(
                                      top: (kToolbarHeight -
                                              MediaQuery.of(context)
                                                  .padding
                                                  .top) /
                                          2),
                                  child: ListTile(
                                    dense: true,
                                    contentPadding: EdgeInsets.zero,
                                    minLeadingWidth: 0,
                                    minVerticalPadding: 0,
                                    leading: Icon(
                                      Icons.chat,
                                      color: Colors.white,
                                    ),
                                    title: Text(
                                      'Discuss',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 20),
                                    ),
                                  ),
                                )
                              : FittedBox(
                                  child: Text(
                                    'Discuss',
                                    style: TextStyle(
                                        fontSize: 25,
                                        fontWeight: FontWeight.w900,
                                        fontFamily:
                                            GoogleFonts.lato().fontFamily),
                                  ),
                                ),
                          background: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Image.asset(
                              'assets/DiscussHeader.png',
                              fit: BoxFit.contain,
                            ),
                          ),
                        );
                      },
                    ))
              ];
            },
            physics: BouncingScrollPhysics(),
            body: isDone
                ? (discussPostList.isEmpty)
                    ? Center(
                        child:
                            Text('Choose Groups by clicking on Filter Button'),
                      )
                    : CustomScrollView(
                        slivers: [
                          SliverList(
                              delegate: SliverChildBuilderDelegate(
                            (BuildContext context, int index) {
                              int counter = discussPostList[index].upvote_count;
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 11, horizontal: 8),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: ExpansionTile(
                                    collapsedBackgroundColor:
                                        Colors.blueGrey[100],
                                    backgroundColor: Colors.blueGrey,
                                    tilePadding: EdgeInsets.all(10),
                                    textColor: Colors.white,
                                    leading: (discussPostList[index]
                                                    .user_image ==
                                                '' ||
                                            discussPostList[index].user_image ==
                                                null)
                                        ? CircleAvatar(
                                            child: Icon(Icons.person),
                                            backgroundColor: Colors.black,
                                          )
                                        : CircleAvatar(
                                            backgroundImage: NetworkImage(
                                                discussPostList[index]
                                                    .user_image!),
                                            backgroundColor: Colors.black,
                                          ),
                                    subtitle: Text('By ' +
                                        discussPostList[index].fname! +
                                        ' ' +
                                        discussPostList[index].lname!),
                                    title: Text(convertStringToUnicode(
                                        discussPostList[index].post_title!)),
                                    collapsedIconColor: Colors.black,
                                    iconColor: Colors.white,
                                    childrenPadding: EdgeInsets.all(11),
                                    children: [
                                      Text(
                                        convertStringToUnicode(
                                            discussPostList[index]
                                                .post_description!),
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 18),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              TextButton.icon(
                                                  onPressed: () {
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                CommunityPostView(
                                                                    details:
                                                                        discussPostList[
                                                                            index])));
                                                  },
                                                  icon: Icon(
                                                    Icons.question_answer,
                                                    color: Colors.white,
                                                  ),
                                                  label: Text(
                                                    '${discussPostList[index].comment_count}',
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  )),
                                              TextButton.icon(
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
                                                        discussPostList[index]
                                                            .post_id);
                                                    if (mounted) {
                                                      setState(() {
                                                        discussPostList[index]
                                                                .upvote_count =
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
                                                    Icons.thumb_up,
                                                    color: Colors.white,
                                                  ),
                                                  label: Text(
                                                    '$counter',
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  )),
                                              TextButton.icon(
                                                  onPressed: () {},
                                                  icon: Icon(
                                                    Icons.remove_red_eye,
                                                    color: Colors.white,
                                                  ),
                                                  label: Text(
                                                    '${discussPostList[index].view_count}',
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  )),
                                            ],
                                          ),
                                          discussPostList[index]
                                                  .post_title
                                                  .isEmptyOrNull
                                              ? Text('')
                                              : IconButton(
                                                  icon: Icon(
                                                    Icons.share,
                                                    color: Colors.white,
                                                  ),
                                                  onPressed: () {
                                                    Share.share(
                                                        discussPostList[index]
                                                                .post_title
                                                                .isEmptyOrNull
                                                            ? '${discussPostList[index].post_title}'
                                                            : ' Test',
                                                        subject: discussPostList[
                                                                    index]
                                                                .post_description
                                                                .isEmptyOrNull
                                                            ? '${discussPostList[index].post_description}'
                                                            : 'Test ');
                                                    // Share.share('', subject: '');
                                                  },
                                                )
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              );
                            },
                            childCount: discussPostList.length,
                          )),
                        ],
                      )
                : Center(
                    child: CircularProgressIndicator(),
                  )));
  }
}
