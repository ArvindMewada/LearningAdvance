library sk_onboarding_screen;

import 'package:elearning/Screens/ExploreScreen/Dialog.dart';
import 'package:elearning/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import 'onboarding_model.dart';

class OnboardingScreen extends StatefulWidget {
  final List<OnboardingModel> pages;
  final Color bgColor;
  final Color themeColor;
  final ValueChanged<String> skipClicked;
  final Function() getStartedClicked;

  OnboardingScreen({
    required Key key,
    required this.pages,
    required this.bgColor,
    required this.themeColor,
    required this.skipClicked,
    required this.getStartedClicked,
  }) : super(key: key);

  @override
  OnboardingScreenState createState() => OnboardingScreenState();
}

class OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController(initialPage: 0);
  int _currentPage = 0;

  List<Widget> _buildPageIndicator() {
    List<Widget> list = [];
    for (int i = 0; i < widget.pages.length; i++) {
      list.add(i == _currentPage ? _indicator(true) : _indicator(false));
    }
    return list;
  }

  List<Widget> buildOnboardingPages() {
    final children = <Widget>[];

    for (int i = 0; i < widget.pages.length; i++) {
      if (i == widget.pages.length - 1)
        children.add(_showPageData(widget.pages[i], true));
      else
        children.add(_showPageData(widget.pages[i], false));
    }
    return children;
  }

  @override
  void initState() {
    super.initState();
  }

  Widget _indicator(bool isActive) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 150),
      margin: EdgeInsets.symmetric(horizontal: 8.0),
      height: 8,
      width: isActive ? 24 : 16,
      decoration: BoxDecoration(
        color: isActive ? kPrimaryColor : Color(0xFF929794),
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.bgColor,
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: SafeArea(
          child: Padding(
              padding: EdgeInsets.symmetric(vertical: 5.0),
              child: OrientationBuilder(builder: (context, orientation) {
                return orientation == Orientation.portrait
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          _currentPage == widget.pages.length - 1
                              ? MaterialButton(
                                  onPressed: null,
                                  child: Text(
                                    '',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black,
                                      fontSize: 20,
                                    ),
                                  ),
                                )
                              : Align(
                                  alignment: Alignment.centerRight,
                                  child: TextButton(
                                    onPressed: () {
                                      _pageController
                                          .jumpToPage(widget.pages.length - 1);
                                    },
                                    child: Text(
                                      'Skip',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black,
                                        fontSize: 20,
                                      ),
                                    ),
                                  ),
                                ),
                          Container(
                            height: 65.h,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: NotificationListener<
                                      OverscrollIndicatorNotification>(
                                    onNotification: (overscroll) {
                                      overscroll.disallowGlow();
                                      return true;
                                    },
                                    child: PageView(
                                        physics: ClampingScrollPhysics(),
                                        controller: _pageController,
                                        onPageChanged: (int page) {
                                          if (mounted)
                                            setState(() {
                                              _currentPage = page;
                                            });
                                        },
                                        children: buildOnboardingPages()),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: _buildPageIndicator(),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          _currentPage != widget.pages.length - 1
                              ? Align(
                                  alignment: FractionalOffset.bottomRight,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10.0, horizontal: 8),
                                    child: TextButton(
                                        onPressed: () {
                                          _pageController.nextPage(
                                              duration:
                                                  Duration(milliseconds: 500),
                                              curve: Curves.ease);
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Container(
                                            child: Icon(
                                              Icons.arrow_forward,
                                              color: kPrimaryColor,
                                            ),
                                          ),
                                        ),
                                        style: TextButton.styleFrom(
                                            elevation: 10,
                                            backgroundColor: Colors.white,
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        100)))),
                                  ),
                                )
                              : Align(
                                  alignment: FractionalOffset.center,
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 10),
                                    child: _showGetStartedButton(),
                                  ),
                                ),
                        ],
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          _currentPage == widget.pages.length - 1
                              ? MaterialButton(
                                  onPressed: null,
                                  child: Text(
                                    '',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black,
                                      fontSize: 20,
                                    ),
                                  ),
                                )
                              : Align(
                                  alignment: Alignment.centerRight,
                                  child: TextButton(
                                    onPressed: () {
                                      _pageController
                                          .jumpToPage(widget.pages.length - 1);
                                      widget.skipClicked("Skip Tapped");
                                    },
                                    child: Text(
                                      'Skip',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black,
                                        fontSize: 20,
                                      ),
                                    ),
                                  ),
                                ),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: PageView(
                                      physics: ClampingScrollPhysics(),
                                      controller: _pageController,
                                      onPageChanged: (int page) {
                                        if (mounted)
                                          setState(() {
                                            _currentPage = page;
                                          });
                                      },
                                      children: buildOnboardingPages()),
                                ),
                                SizedBox(
                                  height: 2.h,
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: _buildPageIndicator(),
                            ),
                          ),
                          _currentPage != widget.pages.length - 1
                              ? Align(
                                  alignment: FractionalOffset.bottomRight,
                                  child: Padding(
                                    padding: const EdgeInsets.only(right: 8.0),
                                    child: TextButton(
                                        onPressed: () {
                                          _pageController.nextPage(
                                              duration:
                                                  Duration(milliseconds: 500),
                                              curve: Curves.ease);
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Container(
                                            child: Icon(
                                              Icons.arrow_forward,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                        style: TextButton.styleFrom(
                                            elevation: 10,
                                            backgroundColor: Colors.white,
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        100)))),
                                  ),
                                )
                              : Align(
                                  alignment: FractionalOffset.bottomCenter,
                                  child: Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 20),
                                    child: _showGetStartedButton(),
                                  ),
                                ),
                        ],
                      );
              })),
        ),
      ),
    );
  }

  Widget _showPageData(OnboardingModel page, bool isTnC) {
    return OrientationBuilder(builder: (context, orientation) {
      return orientation == Orientation.portrait
          ? ListView(
              children: [
                Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 50.0),
                      child: Center(
                        child: Image(
                          image: AssetImage(page.imagePath),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Text(
                              page.title,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                color: page.titleColor,
                                fontSize: 20.sp,
                              ),
                            ),
                            SizedBox(height: 15.0),
                            Text(
                              page.description,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                color: page.descripColor,
                                fontSize: 15.sp,
                              ),
                            ),
                            SizedBox(
                              height: 2.h,
                            ),
                            isTnC
                                ? Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 30),
                                    child: TextButton(
                                        onPressed: () {
                                          showDialog(
                                              context: context,
                                              builder: (BuildContext context) =>
                                                  DialogBox(
                                                    topIcon: Image.asset(
                                                        "assets/5.png"),
                                                    title: 'Terms & Conditions',
                                                    text: 'Close',
                                                    children: [
                                                      Text(
                                                        tncContent,
                                                        style: TextStyle(
                                                            fontSize: 12.sp),
                                                        textAlign:
                                                            TextAlign.center,
                                                      ),
                                                      SizedBox(
                                                        height: 1.h,
                                                      )
                                                    ],
                                                  ));
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            'Terms & Conditions',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 15),
                                          ),
                                        ),
                                        style: TextButton.styleFrom(
                                            elevation: 10,
                                            backgroundColor: Colors.blue[400],
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        20)))))
                                : Text('')
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            )
          : Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: Center(
                    child: Image(
                      image: AssetImage(page.imagePath),
                    ),
                  ),
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        page.title,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: page.titleColor,
                          fontSize: 20,
                        ),
                      ),
                      SizedBox(height: 5.0),
                      Text(
                        page.description,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          color: page.descripColor,
                          fontSize: 15.sp,
                        ),
                      ),
                      SizedBox(height: 5.0),
                      isTnC
                          ? Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 50),
                              child: TextButton(
                                  onPressed: () {
                                    showDialog(
                                        context: context,
                                        builder: (BuildContext context) =>
                                            DialogBox(
                                              topIcon:
                                                  Image.asset("assets/5.png"),
                                              title: 'Terms & Conditions',
                                              text: 'Close',
                                              children: [
                                                Text(
                                                  tncContent,
                                                  style: TextStyle(
                                                      fontSize: 12.sp),
                                                  textAlign: TextAlign.center,
                                                ),
                                                SizedBox(
                                                  height: 1.h,
                                                )
                                              ],
                                            ));
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      'Terms & Conditions',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 15),
                                    ),
                                  ),
                                  style: TextButton.styleFrom(
                                      elevation: 10,
                                      backgroundColor: Colors.blue[400],
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20)))),
                            )
                          : Text('')
                    ],
                  ),
                )
              ],
            );
    });
  }

  Widget _showGetStartedButton() {
    TextButton loginButtonWithGesture = TextButton(
        onPressed: widget.getStartedClicked,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            'Get Started',
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
        ),
        style: TextButton.styleFrom(
            elevation: 10,
            backgroundColor: kPrimaryColor,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20))));

    return Container(width: 300, child: loginButtonWithGesture);
  }
}
