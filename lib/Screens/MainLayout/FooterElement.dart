import 'package:flutter/material.dart';

class FooterElement extends StatelessWidget {
  final String footerText;
  final Function onPress;
  FooterElement({
    required this.footerText,
    required this.onPress,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: TextButton(
          onPressed: onPress(),
          child: Text(
            footerText,
            style: TextStyle(color: Colors.white),
          )),
    );
  }
}
