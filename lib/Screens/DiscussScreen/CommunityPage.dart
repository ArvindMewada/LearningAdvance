import 'package:elearning/MyStore.dart';
import 'package:elearning/Screens/DiscussScreen/CommunityPostsPage.dart';
import 'package:elearning/constants.dart';
import 'package:elearning/dbModel.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:velocity_x/velocity_x.dart';

class CommunityPage extends StatefulWidget {
  const CommunityPage({Key? key}) : super(key: key);

  @override
  _CommunityPageState createState() => _CommunityPageState();
}

class _CommunityPageState extends State<CommunityPage> {
  late BehaviorSubject<List<GroupElement>> _stream;
  MyStore store = VxState.store;

  @override
  void initState() {
    _stream = BehaviorSubject();
    _stream.addStream(store.dataStore
        .box<GroupElement>()
        .query()
        .watch(triggerImmediately: true)
        .map((query) => query.find()));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Community'),
      ),
      body: StreamBuilder(
        stream: _stream,
        builder: (context, AsyncSnapshot<List<GroupElement>> snapshot) {
          if (snapshot.hasData &&
              !store.dataStore.box<GroupElement>().isEmpty())
            return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Material(
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      child: ListTile(
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => CommunityPostsPage(
                                        title: snapshot.data![index].tag,
                                        communityID: snapshot
                                            .data![index].communityId)));
                          },
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                          trailing: Icon(
                            Icons.keyboard_arrow_right,
                            color: kPrimaryColor,
                            size: 30,
                          ),
                          subtitle: Row(children: [
                            Text(snapshot.data![index].countPost.toString() +
                                ' Posts'),
                            SizedBox(width: 30),
                            Text(
                                snapshot.data![index].countFollower.toString() +
                                    ' Followers')
                          ]),
                          title: Text(snapshot.data![index].tag)),
                    ),
                  );
                });

          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
