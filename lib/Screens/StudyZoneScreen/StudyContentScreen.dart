import 'package:elearning/Screens/StudyZoneScreen/PDFViewerPage.dart';
import 'package:elearning/Screens/StudyZoneScreen/VideoPlayerPage.dart';
import 'package:elearning/constants.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class StudyContentScreen extends StatefulWidget {
  final String name;
  final List content;
  final bool isVideoSection;
  StudyContentScreen({
    required this.name,
    required this.content,
    this.isVideoSection = false,
  });
  @override
  _StudyContentScreenState createState() => _StudyContentScreenState();
}

class _StudyContentScreenState extends State<StudyContentScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            widget.name,
          ),
        ),
        body: GlowingOverscrollIndicator(
          axisDirection: AxisDirection.down,
          color: Vx.pink700,
          child: widget.isVideoSection
              ? ListView.builder(
                  //For Video Section
                  padding: EdgeInsets.all(10),
                  itemCount: widget.content.length,
                  itemBuilder: (BuildContext context, int index) {
                    String? urlID = YoutubePlayer.convertUrlToId(
                        widget.content[index]['url']);
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Material(
                        elevation: 10,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ListTile(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
                            leading: (urlID == null)
                                ? CircleAvatar(
                                    child: Icon(Icons.image),
                                  )
                                : ((urlID.contains('mZJgxlLbJzI') == true) ||
                                        (urlID.contains('jhl129k7XBE') == true))
                                    ? CircleAvatar(
                                        child: Icon(Icons.image),
                                      )
                                    : Image.network(YoutubePlayer.getThumbnail(
                                        videoId: urlID)),
                            title: Text(widget.content[index]['title']),
                            trailing: IconButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => VideoPlayerPage(
                                                url: widget.content[index]
                                                    ['url'],
                                                desc: widget.content[index]
                                                    ['desc'],
                                                title: widget.content[index]
                                                    ['title'],
                                              )));
                                },
                                icon: CircleAvatar(
                                    backgroundColor: kPrimaryColor,
                                    foregroundColor: Colors.white,
                                    child: Icon(Icons.play_arrow))),
                            subtitle: Text(
                              widget.content[index]['desc'],
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      ),
                    );
                  })
              : ListView.builder(
                  //For Magazine
                  padding: EdgeInsets.all(10),
                  itemCount: widget.content.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Material(
                        elevation: 10,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ListTile(
                            trailing: TextButton(
                                style: TextButton.styleFrom(
                                    backgroundColor: kPrimaryColor,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(20))),
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => PDFViewerPage(
                                                url: widget.content[index]
                                                    ['url'],
                                                desc: widget.content[index]
                                                    ['desc'],
                                                title: widget.content[index]
                                                    ['title'],
                                              )));
                                },
                                child: Text(
                                  'Start',
                                  style: TextStyle(color: Colors.white),
                                )),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
                            title: Text(widget.content[index]['title']),
                            subtitle: Text(
                              widget.content[index]['desc'],
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
        ));
  }
}
