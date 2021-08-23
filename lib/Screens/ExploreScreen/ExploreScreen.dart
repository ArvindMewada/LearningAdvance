import 'package:elearning/Screens/ExploreScreen/flutter_onboarding.dart';
import 'package:elearning/Screens/ExploreScreen/onboarding_screen.dart';
import 'package:elearning/Screens/Welcome/welcome_screen.dart';
import 'package:elearning/constants.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ExploreScreen extends StatefulWidget {
  @override
  _ExploreScreenState createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen>
    with TickerProviderStateMixin {
  late final AnimationController controller;

  @override
  void initState() {
    controller = AnimationController(vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: OnboardingScreen(
            key: Key('Onboard'),
            pages: [
              OnboardingModel(
                  title: 'Online Tests',
                  description:
                      'Take a test to know your areas of strengths and weaknesses.',
                  titleColor: Colors.black,
                  descripColor: const Color(0xFF929794),
                  imagePath: 'assets/1.png'),
              OnboardingModel(
                  title: 'Knowledge Zone',
                  description:
                      'Explore to learn current affairs and tips and tricks to score well in your exams.',
                  titleColor: Colors.black,
                  descripColor: const Color(0xFF929794),
                  imagePath: 'assets/2.png'),
              OnboardingModel(
                  title: 'Quiz',
                  description:
                      'Rack your brain with our Quiz. Latest pattern and advanced difficulty level based questions.',
                  titleColor: Colors.black,
                  descripColor: const Color(0xFF929794),
                  imagePath: 'assets/3.png'),
              OnboardingModel(
                  title: 'Discuss',
                  description:
                      'Get connected with different users of the app, discuss your doubts & share your solutions.',
                  titleColor: Colors.black,
                  descripColor: const Color(0xFF929794),
                  imagePath: 'assets/4.png'),
              OnboardingModel(
                  title: 'Terms and Conditions',
                  description:
                      'Please click on the below button to see the Terms and Conditions of the company',
                  titleColor: Colors.black,
                  descripColor: const Color(0xFF929794),
                  imagePath: 'assets/5.png')
            ],
            bgColor: Colors.white,
            themeColor: kPrimaryColor,
            skipClicked: (e) {},
            getStartedClicked: () async {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              prefs.setBool('hasSeenCards', true);
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => WelcomeScreen()));
            }));
  }
}
