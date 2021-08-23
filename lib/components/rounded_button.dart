import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {
  final String text;
  final Function()? press;
  final double fontSize;
  final Color color, textColor;
  const RoundedButton({
    Key? key,
    required this.text,
    this.press,
    required this.color,
    this.textColor = Colors.white,
    this.fontSize = 15,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      width: size.width * 0.8,
      child: MaterialButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(29)),
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 40),
        color: color,
        disabledColor: color,
        onPressed: press,
        child: Text(
          text,
          style: TextStyle(color: textColor, fontSize: fontSize),
        ),
      ),
    );
  }
}
