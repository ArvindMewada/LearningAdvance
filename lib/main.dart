import 'dart:io';

import 'package:elearning/MyStore.dart';
import 'package:elearning/Screens/SplashScreen/SplashScreen.dart';
import 'package:elearning/constants.dart';
import 'package:elearning/objectbox.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

import 'dbModel.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  if (Platform.isAndroid) {
    await AndroidInAppWebViewController.setWebContentsDebuggingEnabled(true);

    var swAvailable = await AndroidWebViewFeature.isFeatureSupported(
        AndroidWebViewFeature.SERVICE_WORKER_BASIC_USAGE);
    var swInterceptAvailable = await AndroidWebViewFeature.isFeatureSupported(
        AndroidWebViewFeature.SERVICE_WORKER_SHOULD_INTERCEPT_REQUEST);

    if (swAvailable && swInterceptAvailable) {
      AndroidServiceWorkerController serviceWorkerController =
      AndroidServiceWorkerController.instance();

      serviceWorkerController.serviceWorkerClient = AndroidServiceWorkerClient(
        shouldInterceptRequest: (request) async {
          print(request);
          return null;
        },
      );
    }
  }

  runApp(VxState(store: MyStore(), child: MyApp()));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  MyStore store = VxState.store;

  @override
  void initState() {
    getApplicationDocumentsDirectory().then((dir) {
      store.dataStore =
          Store(getObjectBoxModel(), directory: join(dir.path, 'objectbox'));
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveSizer(builder: (context, orientation, screenType) {
      return MaterialApp(
        title: 'SpeEdLabs',
        theme: ThemeData.from(
          colorScheme: const ColorScheme.light(primary: Color(0xFF0d47a1)),
        ).copyWith(
          dividerColor: Colors.transparent,
          highlightColor: Colors.transparent,
          splashColor: Colors.transparent,
          primaryTextTheme: GoogleFonts.latoTextTheme(),
          accentTextTheme: GoogleFonts.latoTextTheme(),
          textTheme: GoogleFonts.latoTextTheme(),
          buttonColor: kPrimaryColor,
          appBarTheme: AppBarTheme(
              centerTitle: true,
              textTheme: GoogleFonts.latoTextTheme().copyWith(
                  headline6: GoogleFonts.latoTextTheme()
                      .headline6!
                      .copyWith(fontSize: 20)),
              backgroundColor: Colors.white,
              elevation: 0,
              actionsIconTheme: IconThemeData(color: Colors.black),
              iconTheme: IconThemeData(color: Colors.black)),
          tabBarTheme: TabBarTheme(
              indicatorSize: TabBarIndicatorSize.tab, labelColor: Colors.black),
          floatingActionButtonTheme: FloatingActionButtonThemeData(
              foregroundColor: Colors.white, backgroundColor: kPrimaryColor),
          pageTransitionsTheme: const PageTransitionsTheme(
            builders: <TargetPlatform, PageTransitionsBuilder>{
              TargetPlatform.android: ZoomPageTransitionsBuilder(),
            },
          ),
        ),
        home: SplashScreen(),
      );
    });
  }
}
