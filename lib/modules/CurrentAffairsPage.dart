import 'package:elearning/MyStore.dart';
import 'package:elearning/constants.dart';
import 'package:elearning/functions/currentAffairFunctions.dart';
import 'package:elearning/modules/HTMLTextViewer.dart';
import 'package:elearning/schemas/currentAffairsSchema.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:velocity_x/velocity_x.dart';

class CurrentAffairsPage extends StatefulWidget {
  const CurrentAffairsPage({Key? key}) : super(key: key);

  @override
  _CurrentAffairsPageState createState() => _CurrentAffairsPageState();
}

class _CurrentAffairsPageState extends State<CurrentAffairsPage>
    with SingleTickerProviderStateMixin, KeepAliveParentDataMixin {
  late TabController _tabController;
  late ScrollController nationalStudyZoneController;
  late ScrollController internationalStudyZoneController;
  late String _chosenVal;
  late String _chosenValINTL;
  MyStore store = VxState.store;

  @override
  void initState() {
    _chosenVal = 'English';
    _chosenValINTL = 'English';
    _tabController = TabController(length: 2, vsync: this);
    nationalStudyZoneController = ScrollController();
    internationalStudyZoneController = ScrollController();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
    nationalStudyZoneController.dispose();
    internationalStudyZoneController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Current Affairs',
          style: TextStyle(color: Colors.black),
        ),
        bottom: TabBar(
            controller: _tabController,
            labelColor: Colors.black,
            labelStyle: TextStyle(fontSize: 15),
            indicatorColor: kPrimaryColor,
            indicatorWeight: 2,
            physics: BouncingScrollPhysics(),
            indicatorSize: TabBarIndicatorSize.tab,
            tabs: [
              Tab(
                text: 'National',
              ),
              Tab(
                text: 'International',
              )
            ]),
      ),
      body: TabBarView(
          physics: BouncingScrollPhysics(),
          controller: _tabController,
          children: [
            SingleChildScrollView(
              controller: nationalStudyZoneController,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 10),
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.blueAccent)),
                        child: DropdownButtonHideUnderline(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12.0, vertical: 0),
                            child: DropdownButton<String>(
                              isExpanded: true,
                              value: _chosenVal,
                              items: [
                                DropdownMenuItem<String>(
                                    value: 'English', child: Text('English')),
                                DropdownMenuItem<String>(
                                  value: 'Hindi',
                                  child: Text('Hindi'),
                                )
                              ],
                              onChanged: (newVal) {
                                if (mounted)
                                  setState(() {
                                    _chosenVal = newVal!;
                                  });
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  FutureBuilder(
                      future: (_chosenVal == 'English')
                          ? getList('ENG')
                          : getList('HIN'),
                      builder: (BuildContext context,
                          AsyncSnapshot<List<CurrentAffairs>> snapshot) {
                        if (snapshot.hasData)
                          return Column(
                            children: snapshot.data!
                                .map((element) => Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: ListTile(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      HTMLTextViewer(
                                                          content:
                                                              element.content!,
                                                          title: element.title!,
                                                          subtitle: element
                                                              .addDate)));
                                        },
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20)),
                                        title: Text('${element.title}'),
                                        subtitle: Text(
                                            '${element.addDate.toString().substring(8, 10) + element.addDate.toString().substring(4, 7) + '-' + element.addDate.toString().substring(0, 4)}'),
                                      ),
                                    ))
                                .toList(),
                          );
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
            SingleChildScrollView(
              controller: internationalStudyZoneController,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.blueAccent)),
                        child: DropdownButtonHideUnderline(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12.0, vertical: 0),
                            child: DropdownButton<String>(
                              isExpanded: true,
                              value: _chosenValINTL,
                              items: [
                                DropdownMenuItem(
                                    value: 'English', child: Text('English')),
                                DropdownMenuItem<String>(
                                  value: 'Hindi',
                                  child: Text('Hindi'),
                                )
                              ],
                              onChanged: (newVal) {
                                if (mounted)
                                  setState(() {
                                    _chosenValINTL = newVal!;
                                  });
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  FutureBuilder(
                      future: (_chosenValINTL == 'English')
                          ? getListINTL('ENG')
                          : getListINTL('HIN'),
                      builder: (BuildContext context,
                          AsyncSnapshot<List<CurrentAffairs>> snapshot) {
                        if (snapshot.hasData)
                          return Column(
                              children: snapshot.data!
                                  .map((element) => Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: ListTile(
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        HTMLTextViewer(
                                                            content: element
                                                                .content!,
                                                            title:
                                                                element.title!,
                                                            subtitle: element
                                                                .addDate)));
                                          },
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20)),
                                          title: Text('${element.title}'),
                                          subtitle: Text(
                                              '${element.addDate.toString().substring(8, 10) + element.addDate.toString().substring(4, 7) + '-' + element.addDate.toString().substring(0, 4)}'),
                                        ),
                                      ))
                                  .toList());
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
          ]),
    );
  }

  @override
  void detach() {}

  @override
  bool get keptAlive => true;
}
