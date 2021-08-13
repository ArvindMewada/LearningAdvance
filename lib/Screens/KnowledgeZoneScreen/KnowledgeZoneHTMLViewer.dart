import 'dart:convert';

import 'package:elearning/MyStore.dart';
import 'package:elearning/dbModel.dart';
import 'package:elearning/objectbox.g.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:html/parser.dart' as htmlparser;
import 'package:share/share.dart';
import 'package:http/http.dart' as http;
import 'package:velocity_x/velocity_x.dart';

import '../../constants.dart';
// ignore_for_file: non_constant_identifier_names

class KnowledgeZoneHTMLTextViewer extends StatefulWidget {
  final String data_hash;
  final String title;
  final String subtitle;
  const KnowledgeZoneHTMLTextViewer(
      {Key? key,
      required this.data_hash,
      required this.subtitle,
      required this.title})
      : super(key: key);

  @override
  _KnowledgeZoneHTMLTextViewerState createState() =>
      _KnowledgeZoneHTMLTextViewerState();
}

class _KnowledgeZoneHTMLTextViewerState
    extends State<KnowledgeZoneHTMLTextViewer> {
  late String content;
  late bool isDone;
  MyStore store = VxState.store;

  IconButton getIconButton() {
    Query<BookmarkElement> data = store.dataStore
        .box<BookmarkElement>()
        .query(BookmarkElement_.content
            .equals(content)
            .and(BookmarkElement_.title.equals(widget.title))
            .and(BookmarkElement_.subtitle
                .equals(widget.subtitle.substring(0, 10))))
        .build();
    BookmarkElement? bookmarkElement = data.findFirst();
    data.close();
    print(bookmarkElement);
    if (bookmarkElement == null)
      return IconButton(
          onPressed: () {
            BookmarkElement data = BookmarkElement(
                subtitle: widget.subtitle.substring(0, 10),
                title: widget.title,
                content: content);
            showCustomSnackBar(context, 'Item Bookmarked');

            setState(() {
              store.dataStore.box<BookmarkElement>().put(data);
            });
          },
          icon: const Icon(Icons.bookmark_add_outlined));
    else
      return IconButton(
        onPressed: () {
          showCustomSnackBar(context, 'Item removed from bookmark');
          setState(() {
            store.dataStore.box<BookmarkElement>().remove(bookmarkElement.id!);
          });
        },
        icon: const Icon(Icons.bookmark_remove_outlined),
      );
  }

  getDatabyHash() async {
    MyStore store = VxState.store;
    await http.post(Uri.parse(getDataByHash_URL), body: {
      'user_id': store.studentID,
      'user_hash': store.studentHash,
      'data_hash': widget.data_hash,
    }).then((value) async {
      dynamic data = await compute(jsonDecode, value.body);

      content = data['content'];
    });
    setState(() {
      isDone = true;
    });
  }

  @override
  void initState() {
    isDone = false;
    content = '';
    getDatabyHash();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: ListTile(
          contentPadding: const EdgeInsets.all(0),
          title: Text(
            widget.title,
            softWrap: false,
            overflow: TextOverflow.fade,
            style: const TextStyle(fontSize: 20),
          ),
          subtitle: Text(
            widget.subtitle.substring(0, 10),
            softWrap: false,
            overflow: TextOverflow.fade,
            style: const TextStyle(fontSize: 15),
          ),
        ),
        actions: [
          isDone
              ? getIconButton()
              : const IconButton(
                  onPressed: null, icon: Icon(Icons.bookmark_outline)),
          IconButton(
              onPressed: isDone
                  ? () {
                      Share.share(
                          htmlparser
                              .parse(
                                content,
                              )
                              .body!
                              .text,
                          subject: widget.title);
                    }
                  : null,
              icon: const Icon(Icons.share))
        ],
      ),
      body: isDone
          ? InteractiveViewer(
              minScale: 1,
              child: ListView(padding: const EdgeInsets.all(10), children: [
                Html.fromDom(
                  document: htmlparser.parse(
                    content,
                  ),
                )
              ]),
            )
          : Center(child: CircularProgressIndicator()),
    );
  }
}
