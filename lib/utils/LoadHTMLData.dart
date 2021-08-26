import 'package:elearning/utils/ConvertStringtoUnicode.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter/material.dart';
import 'package:html/parser.dart' as htmlparser;
import 'package:intl/intl.dart';

parseData(String text) {
  try {
    return htmlparser.parse(text);
  } catch (e) {
    return htmlparser.parse(Bidi.stripHtmlIfNeeded(text));
  }
}

Widget loadData(String text, double fontSize) {
  try {
    return (text.contains('<img') || text.contains('<p'))
        ? Html.fromDom(document: parseData(text))
        : Text(convertStringToUnicode(htmlparser.parse(text).body!.text),
            style: TextStyle(fontSize: fontSize));
  } catch (e) {
    return Text(
      Bidi.stripHtmlIfNeeded(text),
      style: TextStyle(fontSize: fontSize),
    );
  }
}
