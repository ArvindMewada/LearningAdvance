import 'package:flutter/material.dart';
import 'package:elearning/components/text_field_container.dart';
import 'package:elearning/constants.dart';

class RoundedInputField extends StatefulWidget {
  final String hintText;
  final IconData? icon;
  final bool? hasPressFunc;
  final Function()? onPress;
  final bool enabled;
  final bool hasIcon;
  final IconData? trailingIcon;
  final Color? color;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final List<BoxShadow>? boxShadow;
  RoundedInputField({
    Key? key,
    this.boxShadow,
    this.trailingIcon,
    this.onPress,
    this.hasPressFunc = false,
    this.hasIcon = true,
    this.color = kPrimaryLightColor,
    required this.hintText,
    this.icon = Icons.person,
    required this.keyboardType,
    required this.controller,
    this.enabled = true,
  }) : super(key: key);

  @override
  _RoundedInputFieldState createState() => _RoundedInputFieldState();
}

class _RoundedInputFieldState extends State<RoundedInputField> {
  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
      boxShadow: widget.boxShadow,
      color: widget.color,
      child: TextField(
        enabled: widget.enabled,
        controller: widget.controller,
        keyboardType: widget.keyboardType,
        cursorColor: kPrimaryColor,
        decoration: InputDecoration(
          suffixIcon: widget.hasPressFunc!
              ? IconButton(
                  onPressed: widget.onPress, icon: Icon(widget.trailingIcon))
              : null,
          icon: widget.hasIcon
              ? Icon(
                  widget.icon,
                  color: widget.enabled
                      ? kPrimaryColor
                      : kPrimaryColor.withOpacity(0.5),
                )
              : null,
          hintText: widget.hintText,
          border: InputBorder.none,
        ),
      ),
    );
  }
}
