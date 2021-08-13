import 'dart:convert';
import 'package:elearning/MyStore.dart';
import 'package:elearning/components/rounded_input_field.dart';
import 'package:elearning/constants.dart';
import 'package:elearning/dbModel.dart';
import 'package:elearning/utils/LoadHTMLData.dart';
import 'package:elearning/utils/utf16.dart';
import 'package:html/parser.dart' as htmlparser;
import 'package:elearning/utils/ConvertStringtoUnicode.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_svprogresshud/flutter_svprogresshud.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:http/http.dart' as http;

class CommunityPostView extends StatefulWidget {
  final Post details;

  const CommunityPostView({
    Key? key,
    required this.details,
  }) : super(key: key);

  @override
  _CommunityPostViewState createState() => _CommunityPostViewState();
}

class _CommunityPostViewState extends State<CommunityPostView> {
  late TextEditingController _controller;
  late List commentsList;
  late SharedPreferences prefs;
  late ScrollController _scrollController;
  late bool isDone;

  fetchComments() async {
    prefs = await SharedPreferences.getInstance();
    MyStore store = VxState.store;
    await http.post(Uri.parse(discussPostCommentList_URL), body: {
      'user_id': store.studentID,
      'user_hash': store.studentHash,
      'app_id': appID,
      'post_id': widget.details.post_id,
      'comment_limit': '',
    }).then((value) async {
      dynamic data = await compute(jsonDecode, value.body);
      commentsList = data;
      if (mounted)
        setState(() {
          isDone = true;
        });
    });
  }

  addCommentToPost(String comment, String postId) async {
    SVProgressHUD.setRingThickness(5);
    SVProgressHUD.setRingRadius(5);
    SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.black);
    SVProgressHUD.show();
    MyStore store = VxState.store;
    print(comment);
    print(UTF16(comment, true).value.split(' '));
    List<String> data = UTF16(comment, true).value.split(' ');
    List<String> dataNew = [];
    data.forEach((element) {
      if (element.length == 4)
        dataNew.add(element);
      else {
        String one = element.substring(0, 4);
        String two = element.substring(4);
        dataNew.add(one);
        dataNew.add(two);
      }
    });
    print(dataNew.join('\\u'));
    await http.post(Uri.parse(discussPostAddComment_URL), body: {
      'user_id': store.studentID,
      'user_hash': store.studentHash,
      'app_id': appID,
      'user_first_name': store.studentData.userFirstName,
      'user_last_name': store.studentData.userLastName,
      'user_image_url': store.studentData.userImagePath,
      'user_type': store.studentData.role,
      'post_id': postId,
      'comment': '\\u' + dataNew.join('\\u'),
      'comment_image': '',
    }).then((value) {
      // Utf16Encoder encoder = utf16.encoder as Utf16Encoder;
      //print(String.fromCharCodes(comment.codeUnits));
      //print(Runes(comment));

      //print(comment.runes.toList().map((e) => e.toRadixString(16).codeUnits));
      //print(utf16.encode(comment).map((e) => e.toRadixString(8)));
      //print(encoder.encodeUtf16Be(comment, false));
      //hi print(utf8.encode(comment));
      SVProgressHUD.dismiss();
      if (mounted)
        setState(() {
          isDone = false;
          fetchComments();
        });
    });
  }

  @override
  void initState() {
    _controller = TextEditingController();
    _scrollController = ScrollController();
    isDone = false;
    commentsList = [];
    fetchComments();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                Share.share(widget.details.post_description!,
                    subject: widget.details.post_title!);
              },
              icon: Icon(Icons.share))
        ],
        title: loadData(widget.details.post_title!, 20),
      ),
      body: Stack(
        children: [
          ListView(
            controller: _scrollController,
            children: [
              ListTile(
                leading: CircleAvatar(
                    child: (widget.details.user_image == null ||
                            widget.details.user_image! == '')
                        ? Icon(Icons.person)
                        : null,
                    backgroundImage: (widget.details.user_image == null ||
                            widget.details.user_image! == '')
                        ? null
                        : NetworkImage(widget.details.user_image!)),
                title:
                    Text(widget.details.fname! + ' ' + widget.details.lname!),
                subtitle: Text(
                  widget.details.city_name! + ', ' + widget.details.post_date,
                  overflow: TextOverflow.ellipsis,
                ),
                trailing: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('#' + widget.details.group_hash_tag!),
                    IconButton(onPressed: () {}, icon: Icon(Icons.more_vert))
                  ],
                ),
              ),
              Padding(
                  padding: const EdgeInsets.all(20),
                  child: loadData(widget.details.post_description!, 25)),
              (widget.details.post_image == '' ||
                      widget.details.post_image == null)
                  ? Container()
                  : Image.network(
                      'https://careerliftprod.s3.amazonaws.com/mcldiscussionpost/' +
                          widget.details.post_image!),
              isDone
                  ? ListView.builder(
                      shrinkWrap: true,
                      controller: _scrollController,
                      itemBuilder: (BuildContext context, int index) {
                        return ListTile(
                            title: Text(commentsList[index]['fname'] +
                                ' ' +
                                commentsList[index]['lname']),
                            leading:
                                (commentsList[index]['user_image'] == null ||
                                        commentsList[index]['user_image'] == '')
                                    ? CircleAvatar(
                                        child: Icon(Icons.person),
                                      )
                                    : CircleAvatar(
                                        backgroundImage: NetworkImage(
                                            commentsList[index]['user_image']),
                                      ),
                            subtitle: (commentsList[index]['comment']
                                        .contains('<img') ||
                                    commentsList[index]['comment']
                                        .contains('<p'))
                                ? Html.fromDom(
                                    document: htmlparser
                                        .parse(commentsList[index]['comment']))
                                : Text(
                                    convertStringToUnicode(
                                        commentsList[index]['comment']),
                                    style: TextStyle(fontSize: 20)));
                      },
                      itemCount: commentsList.length,
                    )
                  : Center(
                      child: CircularProgressIndicator(),
                    ),
              SizedBox(
                height: kBottomNavigationBarHeight + 25,
              )
            ],
          ),
          Positioned(
            bottom: 0.0,
            left: 0.0,
            right: 0.0,
            child: Container(
              height: kBottomNavigationBarHeight + 20,
              margin: EdgeInsets.all(10),
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(29)),
              width: MediaQuery.of(context).size.width,
              child: Material(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(29)),
                elevation: 20,
                child: RoundedInputField(
                    icon: Icons.edit,
                    hintText: 'Type your comments here',
                    keyboardType: TextInputType.name,
                    color: Colors.white,
                    onPress: () {
                      addCommentToPost(
                          _controller.text, widget.details.post_id);
                      _controller.clear();
                    },
                    hasPressFunc: true,
                    trailingIcon: Icons.send,
                    controller: _controller),
              ),
            ),
          )
        ],
      ),
    );
  }
}
