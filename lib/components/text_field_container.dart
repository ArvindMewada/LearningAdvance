import 'package:flutter/material.dart';
import 'package:elearning/constants.dart';

class TextFieldContainer extends StatelessWidget {
  final Widget child;
  final Border? border;
  final Color? color;
  final List<BoxShadow>? boxShadow;
  const TextFieldContainer({
    this.border,
    this.boxShadow,
    this.color = kPrimaryLightColor,
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      width: size.width * 0.8,
      decoration: BoxDecoration(
        boxShadow: boxShadow,
        border: border,
        color: color,
        borderRadius: BorderRadius.circular(29),
      ),
      child: child,
    );
  }
}
