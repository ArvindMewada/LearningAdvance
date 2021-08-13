import 'package:flutter/material.dart';

class NothingToShow extends StatefulWidget {
  const NothingToShow({Key? key}) : super(key: key);

  @override
  _NothingToShowState createState() => _NothingToShowState();
}

class _NothingToShowState extends State<NothingToShow> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: Center(
          child: Text('Nothing to Show Here!'),
        ));
  }
}
