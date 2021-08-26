String convertStringToUnicode(String content) {
  String regex = "\\u";
  int offset = content.indexOf(regex) + regex.length;
  while (offset > 1) {
    int limit = offset + 4;
    String str = content.substring(offset, limit);
    // ignore: unnecessary_null_comparison
    if (str != null && str.isNotEmpty) {
      String uni = String.fromCharCode(int.parse(str, radix: 16));

      content = content.replaceFirst(regex + str, uni);
    }
    offset = content.indexOf(regex) + regex.length;
  }
  return content.replaceAll('\\n', '\n').replaceAll('\\r', '\r');
}
