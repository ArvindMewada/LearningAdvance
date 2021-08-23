import 'dart:convert';

import 'package:elearning/MyStore.dart';
import 'package:elearning/Screens/KnowledgeZoneScreen/KnowledgeZoneHTMLViewer.dart';
import 'package:elearning/constants.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:velocity_x/velocity_x.dart';

class KnowledgeZonePreReadingPage extends StatefulWidget {
  final String title;
  final String category;
  const KnowledgeZonePreReadingPage(
      {Key? key, required this.title, required this.category})
      : super(key: key);

  @override
  _KnowledgeZonePreReadingPageState createState() =>
      _KnowledgeZonePreReadingPageState();
}

class _KnowledgeZonePreReadingPageState
    extends State<KnowledgeZonePreReadingPage> {
  Future<List> getPreReadingPageList() async {
    late List recievedData;
    MyStore store = VxState.store;
    await http.post(Uri.parse(knowledgeZonePreReading_URL), body: {
      'user_id': store.studentID,
      'user_hash': store.studentHash,
      'category': widget.category,
      'subcategory': '',
      'type': 'article',
    }).then((value) async {
      dynamic data = await compute(jsonDecode, value.body);
      recievedData = data["listpostData"];
    });
    return recievedData;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: FutureBuilder(
          future: getPreReadingPageList(),
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
                          title: Text(snapshot.data![index]["title"]),
                          subtitle: Text(snapshot.data![index]["add_date"]),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        KnowledgeZoneHTMLTextViewer(
                                          title: snapshot.data![index]["title"],
                                          subtitle: snapshot.data![index]
                                              ["add_date"],
                                          data_hash: snapshot.data![index]
                                              ['mob_post_hash'],
                                        )));
                          },
                        ),
                      ),
                    );
                  });
            return Center(child: CircularProgressIndicator());
          }),
    );
  }
}
