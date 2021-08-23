import 'package:flutter/material.dart';
import 'package:elearning/components/text_field_container.dart';
import 'package:elearning/constants.dart';

class PhoneRoundedInputField extends StatefulWidget {
  final String hintText;
  final IconData? icon;
  final bool hasIcon;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final Color? color;
  const PhoneRoundedInputField({
    Key? key,
    this.hasIcon = true,
    required this.hintText,
    this.color = kPrimaryLightColor,
    this.icon = Icons.person,
    required this.keyboardType,
    required this.controller,
  }) : super(key: key);

  @override
  _PhoneRoundedInputFieldState createState() => _PhoneRoundedInputFieldState();
}

class _PhoneRoundedInputFieldState extends State<PhoneRoundedInputField> {
  bool validPhoneNo = true;
  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
      color: widget.color,
      border: validPhoneNo ? null : Border.all(color: Colors.red),
      child: TextField(
        onTap: () {
          if (widget.controller.text.length == 10) {
            if (mounted)
              setState(() {
                validPhoneNo = true;
              });
          } else {
            if (mounted)
              setState(() {
                validPhoneNo = false;
              });
          }
        },
        onChanged: (e) {
          if (widget.controller.text.length == 10) {
            if (mounted)
              setState(() {
                validPhoneNo = true;
              });
          } else {
            if (mounted)
              setState(() {
                validPhoneNo = false;
              });
          }
        },
        controller: widget.controller,
        keyboardType: widget.keyboardType,
        cursorColor: kPrimaryColor,
        decoration: InputDecoration(
          icon: widget.hasIcon
              ? Icon(
                  widget.icon,
                  color: kPrimaryColor,
                )
              : null,
          hintText: widget.hintText,
          border: InputBorder.none,
        ),
      ),
    );
  }
}
