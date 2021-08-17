import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Footer extends StatelessWidget {
  const Footer({
    Key? key,
  }) : super(key: key);

  // url launch in browser for terms of service or privacy policy
  Future<void> _launchInBrowser(String url) async {
    if (await canLaunch(url)) {
      await launch(
        url,
        forceSafariVC: true,
        forceWebView: true,
        headers: <String, String>{'my_header_key': 'my_header_value'},
      );
    } else {
      throw 'Could not launch $url';
    }
  }


  @override
  Widget build(BuildContext context) {
    const String toLaunchTerm = 'http://speedlabspowai.in/termsandcondition';
    const String toLaunchPrivacy = 'http://speedlabspowai.in/privacy';
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: (){
            _launchInBrowser(toLaunchTerm);
          },
          child: Text("Terms of Service"),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: VerticalDivider(
            color: Colors.white54,
            endIndent: 0,
            indent: 0,
            width: 1,
          ),
        ),
        GestureDetector(
          onTap: (){
            _launchInBrowser(toLaunchPrivacy);
          },
          child: Text("Privacy Policy"),
        ),
      ],
    );
  }
}
