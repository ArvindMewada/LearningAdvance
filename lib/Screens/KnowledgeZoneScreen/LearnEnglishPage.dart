import 'dart:convert';

import 'package:elearning/MyStore.dart';
import 'package:elearning/Screens/KnowledgeZoneScreen/KnowledgeZoneHTMLViewer.dart';
import 'package:elearning/constants.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:velocity_x/velocity_x.dart';

class LearnEnglishPage extends StatefulWidget {
  final String tab1;
  final String tab2;
  final String tab3;
  final String title;
  const LearnEnglishPage(
      {Key? key,
      required this.tab1,
      required this.tab2,
      required this.tab3,
      required this.title})
      : super(key: key);

  @override
  _LearnEnglishPageState createState() => _LearnEnglishPageState();
}

class _LearnEnglishPageState extends State<LearnEnglishPage>
    with SingleTickerProviderStateMixin {
  late TabController _controller;

  Future<List> getLearnEnglishContentList(String param) async {
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
    _controller = TabController(length: 3, vsync: this);
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
              Tab(
                text: widget.tab3,
              )
            ]),
      ),
      body: TabBarView(controller: _controller, children: [
        FutureBuilder(
          future: getLearnEnglishContentList('BASIC_ENG'),
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
        FutureBuilder(
          future: getLearnEnglishContentList('INTERMEDIATE_ENG'),
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
        FutureBuilder(
          future: getLearnEnglishContentList('english_tips'),
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
        )
      ]),
    );
  }
}
