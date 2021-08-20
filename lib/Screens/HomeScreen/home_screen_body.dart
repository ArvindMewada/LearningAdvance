import 'dart:convert';

import 'package:elearning/MyStore.dart';
import 'package:elearning/Screens/AboutUsPage/aboutUsPage.dart';
import 'package:elearning/Screens/DiscussScreen/CommunityPage.dart';
import 'package:elearning/Screens/ExamScreen/ExamScreen.dart';
import 'package:elearning/Screens/FullLengthTestScreen/FullLengthTestScreen.dart';
import 'package:elearning/Screens/HomeScreen/BookmarkScreen.dart';
import 'package:elearning/Screens/InstituteBatchManagementScreen/InstituteBatchManagement.dart';
import 'package:elearning/Screens/InstituteNotificationPage/instituteNotiPage.dart';
import 'package:elearning/Screens/KnowledgeZoneScreen/KnowledgeZoneScreen.dart';
import 'package:elearning/Screens/LiveClassesScreen/LiveClassesScreen.dart';
import 'package:elearning/Screens/MainLayout/Footer.dart';
import 'package:elearning/Screens/MainLayout/MainLayoutConstants.dart';
import 'package:elearning/Screens/Pay/PayScreen.dart';
import 'package:elearning/Screens/ProfileScreen/ProfileScreen.dart';
import 'package:elearning/Screens/QuizScreen/QuizScreen.dart';
import 'package:elearning/Screens/Setting/Setting.dart';
import 'package:elearning/Screens/StudyZoneScreen/StudyZoneScreen.dart';
import 'package:elearning/components/nothingToShow.dart';
import 'package:elearning/constants.dart';
import 'package:elearning/modules/CurrentAffairsPage.dart';
import 'package:elearning/schemas/clientDataSchema.dart';
import 'package:elearning/utils/const.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:reorderables/reorderables.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:store_redirect/store_redirect.dart';
import 'package:velocity_x/velocity_x.dart';

class HomeScreenBody extends StatefulWidget {
  @override
  _HomeScreenBodyState createState() => _HomeScreenBodyState();
}

class _HomeScreenBodyState extends State<HomeScreenBody> {
  late List<IconData> _tiles;
  MyStore store = VxState.store;
  late SharedPreferences prefs;
  late bool isDone;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  initialise() async {
    prefs = await SharedPreferences.getInstance();
    List<String> permissions = store.studentPermission.studentPermissions!;
    if (prefs.containsKey('homelist')) {
      List data =
          prefs.getStringList('homelist')!.map((e) => jsonDecode(e)).toList();
      List<HomeElements> tempData =
          data.map((e) => HomeElements.fromJson(e)).toList();

      List<HomeElements> tempDataNew = store.clientData.homeElements!;
      List tempDataCheck = tempDataNew.map((e) => jsonEncode(e)).toList();
      tempData.forEach((element) {
        String elementOld = jsonEncode(element);
        if (tempDataCheck.contains(elementOld)) {
          print(elementOld);

          tempDataCheck.removeWhere((elementNew) => elementNew == elementOld);
        }
      });
      if (tempDataCheck.length != 0) {
        tempData += tempDataCheck
            .map((e) => HomeElements.fromJson(jsonDecode(e)))
            .toList();
        prefs.setStringList(
            'homelist', tempData.map((e) => jsonEncode(e)).toList());
      }
      getCards(tempData, permissions);
    } else {
      print('else');
      List<HomeElements> tempData = store.clientData.homeElements!;
      print(tempData);
      getCards(tempData, permissions);
      prefs.setStringList(
          'homelist', tempData.map((e) => jsonEncode(e)).toList());
    }
    setState(() {
      isDone = true;
    });
  }

  getFunction(String element) {
    return Navigator.push(context, MaterialPageRoute(builder: (context) {
      switch (element) {
        case '230':
          return CommunityPage();
        case '373':
          return StudyZoneScreen();
        case '456':
          return CurrentAffairsPage();
        case '229':
          return KnowledgeZoneScreen();
        case '225':
          return ExamScreen();
        case '226':
          return QuizScreen();
        case '331':
          return FullLengthTestScreen();
        case '467':
          return LiveClassesScreen();
        case '237':
          return AboutUsPage();
        case '370':
          return InstituteNotiPage();
        case '234':
          return PayScreen();
        case '357':
          return InstituteBatchManagement();
        default:
          return NothingToShow();
      }
    }));
  }

  getCards(List<HomeElements> tempData, List<String> permissions) {
    tempData.forEach((element) {
      _tiles.add(IconData(
          color: (permissions.contains(element.homeElementId))
              ? Colors.yellow.shade100
              : Constants.lightBackground,
          function: () {
            (permissions.contains(element.homeElementId))
                ? getFunction(element.homeElementId!)
                : showCustomSnackBar(context,
                    'This feature is disabled, please contact your Institute administrator');
          },
          img: "assets/homeScreen/${element.homeElementId}.png",
          title: "${element.title1}"));
    });
  }

  CircleAvatar getProfileIcon() {
    try {
      return CircleAvatar(
          radius: 100,
          onBackgroundImageError: (e, s) {
            print('hello');
            setState(() {
              store.studentData.userImagePath = '';
              print(store.studentData.userImagePath);
            });
          },
          child: store.studentData.userImagePath == ''
              ? Icon(
                  Icons.person,
                  size: 80,
                )
              : null,
          backgroundImage: store.studentData.userImagePath == ''
              ? null
              : NetworkImage(store.studentData.userImagePath!));
    } catch (e) {
      return CircleAvatar(
          radius: 100,
          child: Icon(
            Icons.person,
            size: 80,
          ));
    }
  }

  @override
  void initState() {
    super.initState();
    isDone = false;
    _tiles = [];
    initialise();
  }

  @override
  void dispose() {
    super.dispose();
    prefs.clear();
  }

  @override
  Widget build(BuildContext context) {
    void _onReorder(int oldIndex, int newIndex) {
      setState(() {
        IconData row = _tiles.removeAt(oldIndex);
        List<String> tempPref = prefs.getStringList('homelist')!;
        dynamic temp = tempPref.removeAt(oldIndex);
        tempPref.insert(newIndex, temp);
        prefs.setStringList('homelist', tempPref);
        _tiles.insert(newIndex, row);
      });
    }

    getColor(int index) {
      switch (index) {
        case 0:
          return Colors.cyan.shade100;
        case 1:
          return Colors.pink.shade100;
        case 2:
          return Colors.lightGreenAccent.shade100;
        case 3:
          return Colors.tealAccent;
        default:
      }
    }

    var wrap = ReorderableWrap(
      alignment: WrapAlignment.center,
      spacing: 10,
      runSpacing: 10,
      buildDraggableFeedback: (context, constraints, widget) {
        return widget;
      },
      crossAxisAlignment: WrapCrossAlignment.start,
      children: <Widget>[] +
          _tiles
              .take(isDone ? 4 : 0)
              .mapIndexed((currentValue, index) => Container(
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(20)),
                    width: MediaQuery.of(context).orientation ==
                            Orientation.landscape
                        ? MediaQuery.of(context).size.width / 4.4
                        : MediaQuery.of(context).size.width / 2.2,
                    height: MediaQuery.of(context).orientation ==
                            Orientation.landscape
                        ? MediaQuery.of(context).size.width / 4.4
                        : MediaQuery.of(context).size.width / 2.2,
                    child: Card(
                      elevation: 10,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      color: getColor(index),
                      child: MaterialButton(
                        onPressed: currentValue.function,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: GridTile(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: Center(
                                    child: Image.asset(
                                      currentValue.img,
                                      height: 20.h,
                                      width: 20.w,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Center(
                                    child: Text(
                                      currentValue.title,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 12.sp,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ))
              .toList() +
          _tiles
              .sublist(isDone ? 4 : 0)
              .mapIndexed((currentValue, index) => Container(
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(29)),
                    width: MediaQuery.of(context).orientation ==
                            Orientation.landscape
                        ? MediaQuery.of(context).size.width / 6.6
                        : MediaQuery.of(context).size.width / 3.3,
                    height: MediaQuery.of(context).orientation ==
                            Orientation.landscape
                        ? MediaQuery.of(context).size.width / 6.6
                        : MediaQuery.of(context).size.width / 3.3,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: MaterialButton(
                        padding: EdgeInsets.all(0),
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        onPressed: currentValue.function,
                        child: Column(
                          children: [
                            Expanded(
                              flex: 2,
                              child: Center(
                                child: Card(
                                    elevation: 5,
                                    color: currentValue.color,
                                    child: Padding(
                                      padding: const EdgeInsets.all(15),
                                      child: Image.asset(
                                        currentValue.img,
                                        fit: BoxFit.contain,
                                        height: 10.h,
                                        width: 10.w,
                                      ),
                                    )),
                              ),
                            ),
                            Expanded(
                              child: Center(
                                child: Text(
                                  currentValue.title,
                                  maxLines: 3,
                                  style: TextStyle(fontSize: 10.sp),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ))
              .toList(),
      onReorder: _onReorder,
    );

    var column = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        wrap,
      ],
    );

    return Scaffold(
      key: _scaffoldKey,
      drawer: Drawer(
        child: Scaffold(
          backgroundColor: Colors.blueGrey,
          body: SafeArea(
            child: ListTileTheme(
              textColor: Colors.white,
              iconColor: Colors.white,
              child: ListView(
                padding: EdgeInsets.all(20),
                children: [
                  MaterialButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ProfileScreen()));
                    },
                    child: Material(
                      elevation: 10,
                      shape: CircleBorder(),
                      child: CircleAvatar(
                          backgroundColor: Colors.blueGrey.shade300,
                          foregroundColor: Colors.white,
                          child: store.studentData.userImagePath == ''
                              ? Icon(
                                  Icons.person,
                                  size: 50,
                                )
                              : null,
                          radius: 60,
                          backgroundImage: store.studentData.userImagePath == ''
                              ? null
                              : NetworkImage(store.studentData.userImagePath!)),
                    ),
                  ),
                  SizedBox(height: 30),
                  ListTile(
                    shape: listTileShape,
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AboutUsPage()));
                    },
                    leading: Icon(Icons.info),
                    title: Text('About Us'),
                  ),
                  Divider(
                    color: Colors.white54,
                  ),
                  ListTile(
                    shape: listTileShape,
                    onTap: () {
                      StoreRedirect.redirect(
                          androidAppId:
                              "com.example.elearning",
                          iOSAppId: "284882215");
                    },
                    leading: Icon(Icons.rate_review),
                    title: Text('Rate the App'),
                  ),
                  Divider(
                    color: Colors.white54,
                  ),
                  ListTile(
                    shape: listTileShape,
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SettingScreen()));
                    },
                    leading: Icon(Icons.settings),
                    title: Text('Settings (Clear Cache)'),
                  ),
                  ListTile(
                    title: DefaultTextStyle(
                      style: TextStyle(
                        fontSize: 12,
                      ),
                      child: Container(
                        margin: const EdgeInsets.symmetric(
                          vertical: 16.0,
                        ),
                        child: IntrinsicHeight(
                          child: Footer(),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.menu),
          onPressed: () => _scaffoldKey.currentState!.openDrawer(),
        ),
        centerTitle: false,
        title: ListTile(
            contentPadding: EdgeInsets.all(0),
            leading: FittedBox(
              fit: BoxFit.contain,
              child: CircleAvatar(
                backgroundColor: Colors.white,
                child: Image.asset(
                  'assets/logo.png',
                  fit: BoxFit.contain,
                ),
              ),
            ),
            title: Text('SpeEdLabs')),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ProfileScreen()));
              },
              icon: FittedBox(
                fit: BoxFit.contain,
                child: Container(
                  decoration: BoxDecoration(
                      shape: BoxShape.circle, color: kPrimaryColor),
                  height: 150,
                  width: 150,
                  child: Stack(children: [
                    FittedBox(
                      fit: BoxFit.contain,
                      child: CircularPercentIndicator(
                        radius: 150,
                        lineWidth: 10,
                        animation: true,
                        animationDuration: 1500,
                        percent: (double.parse(
                                store.studentData.percentage.toString())) /
                            100,
                        circularStrokeCap: CircularStrokeCap.round,
                        progressColor: Colors.deepPurple[900],
                        backgroundColor: kPrimaryColor,
                        center: getProfileIcon(),
                      ),
                    ),
                  ]),
                ),
              )),
          IconButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => BookmarkScreen()));
              },
              icon: Icon(Icons.bookmark))
        ],
      ),
      body: isDone
          ? SingleChildScrollView(
              child: column,
            )
          : Center(child: CircularProgressIndicator()),
    );
  }
}

class IconData {
  String img;
  String title;
  Function()? function;
  Color? color;

  IconData(
      {required this.function,
      required this.img,
      required this.title,
      this.color = const Color(0xfffff9c4)});
}
