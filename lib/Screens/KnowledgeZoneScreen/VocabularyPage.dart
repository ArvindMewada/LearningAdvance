import 'dart:convert';
import 'package:elearning/MyStore.dart';
import 'package:elearning/Screens/KnowledgeZoneScreen/KnowledgeZoneHTMLViewer.dart';
import 'package:elearning/constants.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:velocity_x/velocity_x.dart';
import 'package:draggable_scrollbar/draggable_scrollbar.dart';

class VocabularyPage extends StatefulWidget {
  final String tab1;
  final String tab2;
  final String title;
  const VocabularyPage(
      {Key? key, required this.tab1, required this.tab2, required this.title})
      : super(key: key);

  @override
  _VocabularyPageState createState() => _VocabularyPageState();
}

class _VocabularyPageState extends State<VocabularyPage>
    with SingleTickerProviderStateMixin {
  late TabController _controller;
  late ScrollController _scrollController;

  Future<List> getVocabContentList(String param) async {
    late List recievedData;
    MyStore store = VxState.store;
    await http.post(Uri.parse(knowledgeZonePreReading_URL), body: {
      'user_id': store.studentID,
      'user_hash': store.studentHash,
      'category': param,
      'subcategory': '',
      'type': 'article',
    }).then((value) async {
      dynamic data = await compute(jsonDecode, value.body);
      recievedData = data["listpostData"];
    });
    return recievedData;
  }

  @override
  void initState() {
    _controller = TabController(length: 2, vsync: this);
    _scrollController = ScrollController();
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
        title: Text(widget.title),
        bottom: TabBar(
            indicatorColor: kPrimaryColor,
            labelColor: Colors.black,
            controller: _controller,
            tabs: [
              Tab(
                text: widget.tab1,
              ),
              Tab(
                text: widget.tab2,
              ),
            ]),
      ),
      body: TabBarView(controller: _controller, children: [
        FutureBuilder(
          future: getVocabContentList('VOCAB'),
          builder: (context, AsyncSnapshot<List> snapshot) {
            if (snapshot.hasData)
              return DraggableScrollbar.arrows(
                padding: EdgeInsets.all(8),
                controller: _scrollController,
                heightScrollThumb: 48,
                backgroundColor: kPrimaryColor,
                labelTextBuilder: (offset) {
                  final int currentItem =
                      offset ~/ (22344 / snapshot.data!.length);
                  var letter = currentItem <= snapshot.data!.length - 1
                      ? snapshot.data![currentItem]['title'].substring(0, 1)
                      : snapshot.data!.last['title'].substring(0, 1);
                  return Text(
                    "$letter",
                    style: TextStyle(color: Colors.white, fontSize: 25),
                  );
                },
                alwaysVisibleScrollThumb: true,
                labelConstraints:
                    BoxConstraints.tightFor(width: 60.0, height: 60.0),
                child: ListView.builder(
                  controller: _scrollController,
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                      title: Text(snapshot.data![index]['title']),
                      subtitle: Text(snapshot.data![index]['add_date']),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    KnowledgeZoneHTMLTextViewer(
                                        data_hash: snapshot.data![index]
                                            ['mob_post_hash'],
                                        subtitle: snapshot.data![index]
                                            ['add_date'],
                                        title: snapshot.data![index]
                                            ['title'])));
                      },
                    );
                  },
                  itemCount: snapshot.data!.length,
                ),
              );
            return Center(child: CircularProgressIndicator());
          },
        ),
        FutureBuilder(
          future: getVocabContentList('VOCAB_STORIES'),
          builder: (context, AsyncSnapshot<List> snapshot) {
            if (snapshot.hasData)
              return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Material(
                        elevation: 10,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        child: ListTile(
                          trailing: Icon(
                            Icons.keyboard_arrow_right,
                            color: kPrimaryColor,
                            size: 30,
                          ),
                          title: Text(snapshot.data![index]['title']),
                          subtitle: Text(snapshot.data![index]['add_date']),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        KnowledgeZoneHTMLTextViewer(
                                            data_hash: snapshot.data![index]
                                                ['mob_post_hash'],
                                            subtitle: snapshot.data![index]
                                                ['add_date'],
                                            title: snapshot.data![index]
                                                ['title'])));
                          },
                        ),
                      ),
                    );
                  });
            return Center(child: CircularProgressIndicator());
          },
        ),
      ]),
    );
  }
}
