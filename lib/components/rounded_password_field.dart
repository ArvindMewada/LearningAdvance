import 'package:flutter/material.dart';
import 'package:elearning/components/text_field_container.dart';
import 'package:elearning/constants.dart';

class RoundedPasswordField extends StatefulWidget {
  final TextEditingController controller;
  final Color? color;
  const RoundedPasswordField({Key? key, required this.controller, this.color})
      : super(key: key);

  @override
  _RoundedPasswordFieldState createState() => _RoundedPasswordFieldState();
}

class _RoundedPasswordFieldState extends State<RoundedPasswordField> {
  bool _obscureText = true;
  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
      color: widget.color,
      child: TextField(
        controller: widget.controller,
        keyboardType: TextInputType.visiblePassword,
        obscureText: _obscureText,
        cursorColor: kPrimaryColor,
        decoration: InputDecoration(
          hintText: "Password",
          icon: Icon(
            Icons.lock,
            color: kPrimaryColor,
          ),
          suffixIcon: IconButton(
            hoverColor: Colors.transparent,
            splashColor: Colors.transparent,
            splashRadius: 0.01,
            onPressed: () {
              if (mounted)
                setState(() {
                  _obscureText = !_obscureText;
                });
            },
            icon: Icon(_obscureText ? Icons.visibility : Icons.visibility_off),
            color:
                _obscureText ? kPrimaryColor.withOpacity(0.5) : kPrimaryColor,
          ),
          border: InputBorder.none,
        ),
      ),
    );
  }
}
