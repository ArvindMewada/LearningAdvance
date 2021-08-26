import 'package:elearning/constants.dart';
import 'package:flutter/material.dart';

class LessonCompleted extends StatefulWidget {
  const LessonCompleted({Key? key}) : super(key: key);

  @override
  _LessonCompletedState createState() => _LessonCompletedState();
}

class _LessonCompletedState extends State<LessonCompleted> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: SafeArea(
      child: OrientationBuilder(
        builder: (context, orientation) {
          return (orientation == Orientation.portrait)
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                      Expanded(
                          flex: 2, child: Image.asset('assets/completed.png')),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'Congratulations!',
                                style: TextStyle(fontSize: 30),
                              ),
                            ),
                            Text(
                              'Material Completed',
                              style: TextStyle(fontSize: 20),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(20),
                              child: TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 60.0, vertical: 5),
                                    child: Text(
                                      'Continue',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 20),
                                    ),
                                  ),
                                  style: TextButton.styleFrom(
                                      elevation: 10,
                                      backgroundColor: kPrimaryColor,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20)))),
                            )
                          ],
                        ),
                      )
                    ])
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                      Expanded(child: Image.asset('assets/completed.png')),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'Congratulations!',
                                style: TextStyle(fontSize: 30),
                              ),
                            ),
                            Text(
                              'Lesson Completed',
                              style: TextStyle(fontSize: 20),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(20),
                              child: TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 60.0, vertical: 5),
                                    child: Text(
                                      'Continue',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 20),
                                    ),
                                  ),
                                  style: TextButton.styleFrom(
                                      elevation: 10,
                                      backgroundColor: kPrimaryColor,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20)))),
                            )
                          ],
                        ),
                      )
                    ]);
        },
      ),
    ));
  }
}
