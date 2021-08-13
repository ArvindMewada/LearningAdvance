import 'package:elearning/Screens/MainLayout/FooterElement.dart';
import 'package:flutter/material.dart';

class Footer extends StatelessWidget {
  const Footer({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        FooterElement(
          footerText: 'Terms of Service',
          onPress: () {},
        ),
        VerticalDivider(
          color: Colors.white54,
          endIndent: 0,
          indent: 0,
          width: 1,
        ),
        FooterElement(
          footerText: 'Privacy Policy',
          onPress: () {},
        )
      ],
    );
  }
}
