import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart';

class MyWebView extends StatefulWidget {
  final String? selectedUrl;
  final int tabNo;

  MyWebView({required this.selectedUrl, required this.tabNo});

  @override
  _MyWebViewState createState() => _MyWebViewState();
}

class _MyWebViewState extends State<MyWebView> {
  late final flutterWebViewPlugin;
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  late StreamSubscription<String> _onUrlChanged;
  late String currentUrl;
  String callbackUrl = "Live_logout";
  String adminLoginScreenUrl = 'https://adminpanel.learno.online/index.php';

  @override
  void initState() {
    super.initState();
    flutterWebViewPlugin = new FlutterWebviewPlugin();

    //Url Change Listener
    _onUrlChanged = flutterWebViewPlugin.onUrlChanged.listen((String url) {
      if (mounted) {
        //function is triggered when Url is changed
        print("Current url changed to : $url");
        currentUrl = url;

        //To automatically logout the user on logging out
        if (currentUrl == adminLoginScreenUrl) {
          Navigator.pop(context);
          showToast('You have been Successfully Logged Out');
        }
      }
    });
  }

  @override
  void dispose() {
    //stop the Url click listener and flutter web plugin
    _onUrlChanged.cancel();
    flutterWebViewPlugin.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return webViewPlugin();
  }

  //Display of Web View using flutter_webView plugin
  Widget webViewPlugin() {
    //WillScope enables the capture on back pressed by the user
    return WillPopScope(
      //onBackPressed
      onWillPop: () {
        print("Current url  variable $currentUrl");

        //if recorded lecture tab is opened
        if (widget.tabNo == 1) {
          showToast('Closed Recorded Lecture');
          return Future.value(true); //close activity
        }

        //when live tab is used
        if (currentUrl.isNotEmpty) {
          if (currentUrl.contains(callbackUrl)) {
            return Future.value(true);
          } else if (currentUrl.contains("joinIfRunning.php")) {
            return Future.value(true);
          } else if (!(currentUrl == widget.selectedUrl)) {
            showToast('Please logout first');
            return Future.value(false);
          } else {
            return Future.value(true);
          }
        } else {
          //when no url is fetched
          return Future.value(true);
        }
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: SafeArea(
          child: new Center(
            child: TextButton(
              onPressed: (){
                print("######${widget.selectedUrl}");
                String ur = "${widget.selectedUrl}";
                launchURL(ur);
              },
              child: Text("hello"),
              // child: WebviewScaffold(
              //   key: scaffoldKey,
              //   url: widget.selectedUrl!,
              //   appCacheEnabled: false,
              //   clearCookies: true,
              //   clearCache: true,
              //   debuggingEnabled: true,
              //   initialChild: Container(
              //     color: Colors.redAccent,
              //     child: const Center(
              //       child: Text('Waiting.....'),
              //     ),
              //   ),
              //   userAgent:
              //       'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/78.0.3904.97 Safari/537.36',
              // ),
            ),
          ),
        ),
      ),
    );
  }

  launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url,enableJavaScript: true, webOnlyWindowName: "https//google.in");
    } else {
      throw 'Could not launch $url';
    }
  }

  //Shows Toast Without Context
  void showToast(String s) {
    Fluttertoast.showToast(
        msg: s,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.grey,
        textColor: Colors.white,
        fontSize: 16.0);
  }
}
