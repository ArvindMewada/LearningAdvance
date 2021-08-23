import 'package:elearning/MyStore.dart';
import 'package:elearning/constants.dart';
import 'package:elearning/dbModel.dart';
import 'package:elearning/objectbox.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:html/parser.dart' as htmlparser;
import 'package:share/share.dart';
import 'package:velocity_x/velocity_x.dart';

class HTMLTextViewer extends StatefulWidget {
  final String content;
  final String title;
  final String? subtitle;
  const HTMLTextViewer(
      {Key? key, required this.content, required this.title, this.subtitle})
      : super(key: key);

  @override
  _HTMLTextViewerState createState() => _HTMLTextViewerState();
}

class _HTMLTextViewerState extends State<HTMLTextViewer> {
  MyStore store = VxState.store;

  IconButton getIconButton() {
    Query<BookmarkElement> data = store.dataStore
        .box<BookmarkElement>()
        .query(BookmarkElement_.content
            .equals(widget.content)
            .and(BookmarkElement_.title.equals(widget.title))
            .and(BookmarkElement_.subtitle
                .equals(widget.subtitle!.substring(0, 10))))
        .build();
    BookmarkElement? bookmarkElement = data.findFirst();
    data.close();
    print(bookmarkElement);
    if (bookmarkElement == null)
      return IconButton(
          onPressed: () {
            BookmarkElement data = BookmarkElement(
                subtitle: widget.subtitle!.substring(0, 10),
                title: widget.title,
                content: widget.content);
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
            widget.subtitle!.substring(0, 10),
            softWrap: false,
            overflow: TextOverflow.fade,
            style: const TextStyle(fontSize: 15),
          ),
        ),
        actions: [
          getIconButton(),
          IconButton(
              onPressed: () {
                Share.share(
                    htmlparser
                        .parse(
                          widget.content,
                        )
                        .body!
                        .text,
                    subject: widget.title);
              },
              icon: const Icon(Icons.share))
        ],
      ),
      body: InteractiveViewer(
        minScale: 1,
        child: ListView(padding: const EdgeInsets.all(10), children: [
          Html.fromDom(
            document: htmlparser.parse(
              widget.content,
            ),
          )
        ]),
      ),
    );
  }
}
