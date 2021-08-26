import 'dart:ui';
import 'package:elearning/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class DialogBox extends StatefulWidget {
  final String title, text;
  final Image? img;
  final List<Widget> children;
  final Widget topIcon;

  const DialogBox(
      {Key? key,
      required this.topIcon,
      required this.title,
      required this.text,
      required this.children,
      this.img})
      : super(key: key);

  @override
  _DialogBoxState createState() => _DialogBoxState();
}

class _DialogBoxState extends State<DialogBox> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(ExploreConstants.padding),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: contentBox(context),
    );
  }

  contentBox(context) {
    return Stack(
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(
              left: ExploreConstants.padding,
              top: ExploreConstants.avatarRadius + ExploreConstants.padding,
              right: ExploreConstants.padding,
              bottom: ExploreConstants.padding - 10),
          margin: EdgeInsets.only(top: ExploreConstants.avatarRadius),
          decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              color: Colors.white,
              borderRadius: BorderRadius.circular(ExploreConstants.padding),
              boxShadow: [
                BoxShadow(color: Colors.black, blurRadius: 10),
              ]),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: Text(
                  widget.title,
                  style:
                      TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w600),
                ),
              ),
              SizedBox(
                height: 2.h,
              ),
              Expanded(
                child: Center(
                  child: ListView(
                    children: widget.children,
                  ),
                ),
              ),
              SizedBox(
                height: 2.h,
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: TextButton(
                    style: TextButton.styleFrom(
                        backgroundColor: Colors.blue[400],
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10))),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      widget.text,
                      style: TextStyle(fontSize: 18.sp, color: Colors.white),
                    )),
              ),
            ],
          ),
        ),
        Positioned(
          left: ExploreConstants.padding,
          right: ExploreConstants.padding,
          child: CircleAvatar(
            backgroundColor: Colors.transparent,
            radius: ExploreConstants.avatarRadius,
            child: ClipRRect(
                borderRadius: BorderRadius.all(
                    Radius.circular(ExploreConstants.avatarRadius)),
                child: widget.topIcon),
          ),
        ),
      ],
    );
  }
}
