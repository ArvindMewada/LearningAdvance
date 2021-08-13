import 'package:elearning/MyStore.dart';
import 'package:elearning/Screens/SplashScreen/SplashScreen.dart';
import 'package:elearning/constants.dart';
import 'package:elearning/objectbox.g.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(VxState(store: MyStore(), child: MyApp()));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    final MyStore store = VxState.store;
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
