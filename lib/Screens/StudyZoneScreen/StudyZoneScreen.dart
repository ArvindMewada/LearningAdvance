import 'dart:convert';
import 'package:elearning/MyStore.dart';
import 'package:elearning/Screens/StudyZoneScreen/StudyContentScreen.dart';
import 'package:elearning/constants.dart';
import 'package:elearning/modules/HTMLTextViewer.dart';
import 'package:elearning/schemas/currentAffairsSchema.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:http/http.dart' as http;
import 'package:random_color/random_color.dart';
import 'package:intl/intl.dart';
import 'package:elearning/modules/CurrentAffairsPage.dart';

class StudyZoneScreen extends StatefulWidget {
  @override
  _StudyZoneScreenState createState() => _StudyZoneScreenState();
}

class _StudyZoneScreenState extends State<StudyZoneScreen> {
  late final ScrollController studyZoneController;
  MyStore store = VxState.store;
  RandomColor _randomColor = RandomColor();

  Future<Widget> getList() async {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd kk:mm:ss').format(now);
    List<Widget> currentAffairsListEng = [];
    print(formattedDate);
    await http.post(Uri.parse(currentAffairsContent_URL), body: {
      'user_id': store.studentID,
      'user_hash': store.studentHash,
      'category': 'CA_ENG',
      'add_date': formattedDate,
      'country': '-',
      'app_hash': app_hash,
    }).then((value) async {
      dynamic data = await compute(jsonDecode, value.body);
      print(data);
      CurrentAffair dataNew = CurrentAffair.fromJson(data);
      List<CurrentAffairs> entries = dataNew.currentAffairs!;
      List<CurrentAffairs>.from(entries.reversed).take(5).forEach((element) {
        currentAffairsListEng.add(Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListTile(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => HTMLTextViewer(
                          content: element.content!,
                          title: element.title!,
                          subtitle: element.addDate)));
            },
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            title: Text('${element.title}'),
            subtitle: Text(
                '${element.addDate.toString().substring(8, 10) + element.addDate.toString().substring(4, 7) + '-' + element.addDate.toString().substring(0, 4)}'),
          ),
        ));
      });
    });
    return Stack(
      alignment: AlignmentDirectional.bottomCenter,
      children: [
        ShaderMask(
            shaderCallback: (Rect rect) {
              return LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.purple,
                  Colors.transparent,
                  Colors.transparent,
                  Colors.purple
                ],
                stops: [
                  0.0,
                  0.0,
                  0.2,
                  1.0
                ], // 10% purple, 80% transparent, 10% purple
              ).createShader(rect);
            },
            blendMode: BlendMode.dstOut,
            child: Column(
              children: currentAffairsListEng,
            )),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => CurrentAffairsPage()));
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 100, vertical: 5),
              child: Text(
                'View All',
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
            style: TextButton.styleFrom(
                elevation: 10,
                backgroundColor: kPrimaryColor,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20))),
          ),
        )
      ],
    );
  }

  Future<Widget> getStudyZoneContent({bool isMagazine = true}) async {
    List<Widget> magazineList = [];
    await http.post(Uri.parse(studyZoneContent_URL), body: {
      'user_id': store.studentID,
      'user_hash': store.studentHash,
      'app_hash': app_hash,
    }).then((value) async {
      dynamic studyZoneContent = await compute(jsonDecode, value.body);
      store.studyZoneContent = studyZoneContent;
      List magazinelistNew = isMagazine
          ? store.studyZoneContent['pdf']
          : store.studyZoneContent['video'];
      magazinelistNew.forEach((element) {
        Color _color = _randomColor.randomColor(
            colorHue: ColorHue.multiple(colorHues: [ColorHue.blue]),
            colorSaturation: ColorSaturation.mediumSaturation,
            colorBrightness: ColorBrightness.veryLight);
        magazineList.add(Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 2),
          child: MaterialButton(
            padding: EdgeInsets.all(0),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => StudyContentScreen(
                          isVideoSection: !isMagazine,
                          name: '${element['name']}',
                          content: element['content'])));
            },
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                color: _color,
                child: Container(
                  height: isMagazine ? 150 : 100,
                  width: isMagazine ? 150 : 150,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                        child: Text(
                      '${element['name']}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 20),
                    )),
                  ),
                )),
          ),
        ));
      });
    });
    return NotificationListener<OverscrollIndicatorNotification>(
      onNotification: (overscroll) {
        overscroll.disallowGlow();
        return true;
      },
      child: SingleChildScrollView(
          scrollDirection: Axis.horizontal, child: Row(children: magazineList)),
    );
  }

  List getStudyZoneContentCached({bool isMagazine = true}) {
    List magazinelistNew = isMagazine
        ? store.studyZoneContent['pdf']
        : store.studyZoneContent['video'];
    return magazinelistNew;
  }

  @override
  void initState() {
    studyZoneController = ScrollController();

    super.initState();
  }

  @override
  void dispose() {
    studyZoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: Key('StudyScreen'),
        appBar: AppBar(
          title: Text(
            'Study Zone',
          ),
        ),
        body: NotificationListener<OverscrollIndicatorNotification>(
          onNotification: (overscroll) {
            overscroll.disallowGlow();
            return true;
          },
          child: SingleChildScrollView(
            controller: studyZoneController,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    top: 20,
                    left: 20,
                  ),
                  child: Text('Magazines',
                      style:
                          TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
                ),
                (store.studyZoneContent == null)
                    ? FutureBuilder(
                        future: getStudyZoneContent(),
                        builder: (BuildContext context,
                            AsyncSnapshot<Widget> snapshot) {
                          if (snapshot.hasData) return snapshot.data!;
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  height: 150,
                                  width: 150,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Center(
                                        child: CircularProgressIndicator(
                                      color: kPrimaryColor,
                                    )),
                                  ),
                                ),
                              ],
                            ),
                          );
                        })
                    : NotificationListener<OverscrollIndicatorNotification>(
                        onNotification: (overscroll) {
                          overscroll.disallowGlow();
                          return true;
                        },
                        child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                                children:
                                    getStudyZoneContentCached().map((element) {
                              Color _color = _randomColor.randomColor(
                                  colorHue: ColorHue.multiple(
                                      colorHues: [ColorHue.blue]),
                                  colorSaturation:
                                      ColorSaturation.mediumSaturation,
                                  colorBrightness: ColorBrightness.veryLight);
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 8.0, horizontal: 2),
                                child: MaterialButton(
                                  padding: EdgeInsets.all(0),
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                StudyContentScreen(
                                                    isVideoSection: false,
                                                    name: '${element['name']}',
                                                    content:
                                                        element['content'])));
                                  },
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20)),
                                  child: Card(
                                      elevation: 5,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20)),
                                      color: _color,
                                      child: Container(
                                        height: 150,
                                        width: 150,
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Center(
                                              child: Text(
                                            '${element['name']}',
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(
                                              fontSize: 20,
                                              color: Colors.black,
                                            ),
                                          )),
                                        ),
                                      )),
                                ),
                              );
                            }).toList())),
                      ),
                Padding(
                  padding: const EdgeInsets.only(left: 20, top: 20),
                  child: Text('Videos',
                      style:
                          TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
                ),
                (store.studyZoneContent == null)
                    ? FutureBuilder(
                        future: getStudyZoneContent(isMagazine: false),
                        builder: (BuildContext context,
                            AsyncSnapshot<Widget> snapshot) {
                          if (snapshot.hasData) return snapshot.data!;
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  height: 150,
                                  width: 150,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Center(
                                        child: CircularProgressIndicator(
                                      color: kPrimaryColor,
                                    )),
                                  ),
                                ),
                              ],
                            ),
                          );
                        })
                    : NotificationListener<OverscrollIndicatorNotification>(
                        onNotification: (overscroll) {
                          overscroll.disallowGlow();
                          return true;
                        },
                        child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                                children:
                                    getStudyZoneContentCached(isMagazine: false)
                                        .map((element) {
                              Color _color = _randomColor.randomColor(
                                  colorHue: ColorHue.multiple(
                                      colorHues: [ColorHue.blue]),
                                  colorSaturation:
                                      ColorSaturation.mediumSaturation,
                                  colorBrightness: ColorBrightness.veryLight);
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 8.0, horizontal: 2),
                                child: MaterialButton(
                                  padding: EdgeInsets.all(0),
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                StudyContentScreen(
                                                    isVideoSection: true,
                                                    name: '${element['name']}',
                                                    content:
                                                        element['content'])));
                                  },
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20)),
                                  child: Card(
                                      elevation: 5,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20)),
                                      color: _color,
                                      child: Container(
                                        height: 100,
                                        width: 150,
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Center(
                                              child: Text(
                                            '${element['name']}',
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(
                                              fontSize: 20,
                                              color: Colors.black,
                                            ),
                                          )),
                                        ),
                                      )),
                                ),
                              );
                            }).toList())),
                      ),
                Padding(
                  padding: const EdgeInsets.only(top: 20, left: 20),
                  child: Text('Current Affairs',
                      style:
                          TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
                ),
                FutureBuilder(
                    future: getList(),
                    builder:
                        (BuildContext context, AsyncSnapshot<Widget> snapshot) {
                      if (snapshot.hasData) return snapshot.data!;
                      return Column(
                        children: [
                          ListTile(
                            title: Text(''),
                            subtitle: Text(''),
                          ),
                          ListTile(
                            title: Text(''),
                            subtitle: Text(''),
                          ),
                          Center(
                              child: CircularProgressIndicator(
                            color: kPrimaryColor,
                          )),
                        ],
                      );
                    })
              ],
            ),
          ),
        ));
  }
}
