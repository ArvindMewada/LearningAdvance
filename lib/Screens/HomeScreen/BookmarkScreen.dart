import 'package:elearning/MyStore.dart';
import 'package:elearning/dbModel.dart';
import 'package:elearning/modules/HTMLTextViewer.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:velocity_x/velocity_x.dart';

class BookmarkScreen extends StatefulWidget {
  const BookmarkScreen({Key? key}) : super(key: key);

  @override
  _BookmarkScreenState createState() => _BookmarkScreenState();
}

class _BookmarkScreenState extends State<BookmarkScreen> {
  late BehaviorSubject<List<BookmarkElement>> _stream;
  MyStore store = VxState.store;

  @override
  void initState() {
    _stream = BehaviorSubject();
    _stream.addStream(store.dataStore
        .box<BookmarkElement>()
        .query()
        .watch(triggerImmediately: true)
        .map((query) => query.find()));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Bookmarks',
        ),
      ),
      body: StreamBuilder(
          stream: _stream,
          builder: (context, AsyncSnapshot<List<BookmarkElement>> snapshot) {
            if (snapshot.hasData &&
                !store.dataStore.box<BookmarkElement>().isEmpty())
              return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(snapshot.data![index].title),
                      subtitle: Text(snapshot.data![index].subtitle),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => HTMLTextViewer(
                                      content: snapshot.data![index].content,
                                      title: snapshot.data![index].title,
                                      subtitle: snapshot.data![index].subtitle,
                                    )));
                      },
                      trailing: IconButton(
                          onPressed: () {
                            store.dataStore
                                .box<BookmarkElement>()
                                .remove(snapshot.data![index].id!);
                          },
                          icon: Icon(Icons.bookmark_remove_outlined)),
                    );
                  });
            return Center(child: Text("You have not bookmarked any items"));
          }),
    );
  }
}
