import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:elearning/schemas/gallerySchema.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:elearning/MyStore.dart';
import 'package:elearning/constants.dart';
import 'package:elearning/schemas/aboutUsContentSchema.dart';
import 'package:elearning/utils/LoadHTMLData.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'package:velocity_x/velocity_x.dart';

class AboutUsPage extends StatefulWidget {
  const AboutUsPage({Key? key}) : super(key: key);

  @override
  _AboutUsPageState createState() => _AboutUsPageState();
}

class _AboutUsPageState extends State<AboutUsPage>
    with SingleTickerProviderStateMixin {
  MyStore store = VxState.store;
  late TabController _tabController;
  late ScrollController _scrollController;

  Future<AboutUsContent> getAboutUsContent() async {
    late AboutUsContent data;
    await http.post(Uri.parse(fetchAboutUsContent_URL), body: {
      'user_id': store.studentID,
      'user_hash': store.studentHash,
      'app_hash': app_hash,
    }).then((value) async {
      dynamic recievedData = await compute(jsonDecode, value.body);
      if (recievedData['flag'] != 1)
        data = AboutUsContent(
            flag: 0,
            orgLogo: '',
            orgName: '',
            orgAddress: '',
            orgType: '',
            aboutUs: '',
            city: '',
            state: '',
            contactDetails: '',
            isAdmin: false,
            walletSupport: false);
      else
        data = AboutUsContent.fromJson(recievedData);
    });
    return data;
  }

  Future<List<Gallery>> getGalleryContent() async {
    late List<Gallery> data;
    await http.post(Uri.parse(fetchInstPostType_URL), body: {
      'app_id': appID,
      'user_id': store.studentID,
      'user_hash': store.studentHash,
      'post_type': 'gallery'
    }).then((value) async {
      List<dynamic> recievedData = jsonDecode(value.body);
      data = recievedData.map((e) => Gallery.fromJson(e)).toList();
    });
    return data.where((element) => element.postImage != '').toList();
  }

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    _scrollController = ScrollController();
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.dispose();
    super.dispose();
  }


  final Uri emailLaunchUri = Uri(
    scheme: 'mailto',
    path: 'smith@example.com',
  );


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('About Us'),
      ),
      body: FutureBuilder(
          future: getAboutUsContent(),
          builder: (context, AsyncSnapshot<AboutUsContent> snapshot) {
            if (snapshot.hasData) {
              print(snapshot.data);
              if (snapshot.data!.flag != 1)
                return Center(child: Text('Not Authorised.'));
              else
                return NestedScrollView(
                    controller: _scrollController,
                    headerSliverBuilder: (context, isInnerscrolled) {
                      return [
                        SliverAppBar(
                          leading: Container(),
                          snap: true,
                          floating: true,
                          expandedHeight: 300,
                          pinned: true,
                          flexibleSpace: FlexibleSpaceBar(
                            background: Column(
                              children: [
                                CircleAvatar(
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(100),
                                    child: Image.network(
                                      snapshot.data!.orgLogo!,
                                      height: 100,
                                      width: 100,
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                  radius: 80,
                                ),
                                SizedBox(height: 10),
                                Text(
                                  snapshot.data!.orgName!,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 30),
                                ),
                                Text(
                                  snapshot.data!.orgAddress!,
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                          bottom: TabBar(
                              labelColor: Colors.white,
                              unselectedLabelColor: Colors.black,
                              indicator: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(20),
                                      topRight: Radius.circular(20)),
                                  color: kPrimaryColor),
                              controller: _tabController,
                              tabs: [
                                Tab(
                                  text: 'About Us',
                                ),
                                Tab(
                                  text: 'Gallery',
                                )
                              ]),
                        )
                      ];
                    },
                    body: TabBarView(controller: _tabController, children: [
                      CustomScrollView(
                        slivers: [
                          SliverList(
                              delegate: SliverChildListDelegate.fixed([
                            loadData(snapshot.data!.aboutUs!, 12),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'Contact Details:',
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.bold),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  GestureDetector(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text("8818909210"),
                                    ),
                                    onTap: (){
                                      launch("tel:8818909210");
                                    },
                                  ),
                                  GestureDetector(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text("arvindmewada18@gmail.com"),
                                    ),
                                    onTap: (){
                                      launch("mailto:arvindmewada18@gmail.com");
                                    },
                                  ),
                                ],
                              ),
                            )
                          ]))
                        ],
                      ),
                      FutureBuilder(
                          future: getGalleryContent(),
                          builder:
                              (context, AsyncSnapshot<List<Gallery>> snapshot) {
                            if (snapshot.hasData)
                              return StaggeredGridView.countBuilder(
                                crossAxisCount: 4,
                                itemCount: snapshot.data!.length,
                                itemBuilder:
                                    (BuildContext context, int index) =>
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                                  decoration: BoxDecoration(

                                      borderRadius: BorderRadius.all(Radius.circular(20))
                                  ),
                                  child: CachedNetworkImage(
                                    imageUrl:  'https://careerliftprod.s3.amazonaws.com/mcldiscussionpost/' +
                                        snapshot.data![index].postImage!,
                                    fit: BoxFit.cover,
                                    fadeInCurve: Curves.fastOutSlowIn,
                                    placeholder: (context, url) => Padding(
                                      padding: const EdgeInsets.all(100.0),
                                      child: CircularProgressIndicator(),
                                    ),
                                    errorWidget: (context, url, error) => Icon(Icons.account_circle, color:Colors.grey,),
                                  ),
                                ),
                                staggeredTileBuilder: (int index) =>
                                    new StaggeredTile.count(2, 2),
                                mainAxisSpacing: 4.0,
                                crossAxisSpacing: 4.0,
                              );
                            return Center(child: CircularProgressIndicator());
                          }),
                    ]));
            }
            return Center(child: CircularProgressIndicator());
          }),
    );
  }
}
