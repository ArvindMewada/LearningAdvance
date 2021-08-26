import 'package:flutter/material.dart';
import 'package:elearning/components/text_field_container.dart';
import 'package:elearning/constants.dart';
import 'package:email_validator/email_validator.dart';

class EmailRoundedInputField extends StatefulWidget {
  final String hintText;
  final IconData? icon;
  final Color? color;
  final TextEditingController controller;
  final TextInputType keyboardType;
  const EmailRoundedInputField({
    Key? key,
    required this.hintText,
    this.color = kPrimaryLightColor,
    this.icon = Icons.person,
    required this.keyboardType,
    required this.controller,
  }) : super(key: key);

  @override
  _EmailRoundedInputFieldState createState() => _EmailRoundedInputFieldState();
}

class _EmailRoundedInputFieldState extends State<EmailRoundedInputField> {
  bool validEmail = true;
  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
      color: widget.color,
      border: validEmail ? null : Border.all(color: Colors.red),
      child: TextField(
        onTap: () {
          if (EmailValidator.validate(widget.controller.text)) {
            if (mounted)
              setState(() {
                validEmail = true;
              });
          } else {
            if (mounted)
              setState(() {
                validEmail = false;
              });
          }
        },
        onChanged: (e) {
          if (EmailValidator.validate(widget.controller.text)) {
            if (mounted)
              setState(() {
                validEmail = true;
              });
          } else {
            if (mounted)
              setState(() {
                validEmail = false;
              });
          }
        },
        controller: widget.controller,
        keyboardType: widget.keyboardType,
        cursorColor: kPrimaryColor,
        decoration: InputDecoration(
          icon: Icon(
            widget.icon,
            color: kPrimaryColor,
          ),
          hintText: widget.hintText,
          border: InputBorder.none,
        ),
      ),
    );
  }
}
