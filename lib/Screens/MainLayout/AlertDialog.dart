import 'package:elearning/constants.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class AlertBox extends StatefulWidget {
  final String text, secondText, title, content;
  final Function() press, secondPress;
  AlertBox({
    required this.text,
    required this.title,
    required this.content,
    required this.secondText,
    required this.press,
    required this.secondPress,
  });
  @override
  _AlertBoxState createState() => _AlertBoxState();
}

class _AlertBoxState extends State<AlertBox> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(ExploreConstants.padding),
      ),
      child: Padding(
        padding: const EdgeInsets.only(top: 16, left: 10, right: 10, bottom: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              widget.title,
              style: TextStyle(fontSize: 20.sp),
            ),
            SizedBox(
              height: 2.h,
            ),
            Text(
              widget.content,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14.sp),
            ),
            SizedBox(
              height: 3.h,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                    style: TextButton.styleFrom(
                        backgroundColor: kPrimaryColor.withOpacity(0.5),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10))),
                    onPressed: widget.secondPress,
                    child: Text(
                      widget.secondText,
                      style: TextStyle(fontSize: 15.sp, color: Colors.white),
                    )),
                TextButton(
                    style: TextButton.styleFrom(
                        backgroundColor: kPrimaryColor,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10))),
                    onPressed: widget.press,
                    child: Text(
                      widget.text,
                      style: TextStyle(fontSize: 15.sp, color: Colors.white),
                    ))
              ],
            )
          ],
        ),
      ),
    );
  }
}
