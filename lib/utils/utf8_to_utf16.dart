import 'dart:convert';

class UTF8ToUTF16 {
  /// The text that is your input value
  String text;

  /// The singleByte that is convert char code
  bool space;

  /// Creates a new UTF8ToUTF16 with the provided arguments
  UTF8ToUTF16(this.text, this.space);

  String get value => _value();

  String _value() {
    var bytes = utf8ToBytes(text);

    List codePoints = [];

    for (var i = 0; i < bytes.length;) {
      int byte = bytes[i];

      var codePoint;

      if ((byte & bin("11110000")) == bin("11110000")) {
        /// Four byte UTF8
        var byte4 = bytes[i];
        var byte3 = bytes[i + 1];
        var byte2 = bytes[i + 2];
        var byte1 = bytes[i + 3];

        codePoint = ((byte4 & bin("00000111")) << 18) |
            ((byte3 & bin("00111111")) << 12) |
            ((byte2 & bin("00111111")) << 6) |
            (byte1 & bin("00111111"));

        i += 4;
      } else if ((byte & bin("11100000")) == bin("11100000")) {
        /// Three byte UTF8
        var byte3 = bytes[i];
        var byte2 = bytes[i + 1];
        var byte1 = bytes[i + 2];

        codePoint = ((byte3 & bin("00001111")) << 12) |
            ((byte2 & bin("00111111")) << 6) |
            (byte1 & bin("00111111"));

        i += 3;
      } else if ((byte & bin("11000000")) == bin("11000000")) {
        /// Two byte UTF8
        var byte2 = bytes[i];
        var byte1 = bytes[i + 1];

        codePoint =
            ((byte2 & bin("00011111")) << 6) | (byte1 & bin("00111111"));

        i += 2;
      } else if ((byte & 0x80) == 0) {
        /// Single byte UTF8

        codePoint = byte;

        i += 1;
      }
      codePoints.add(codePoint);
    }

    List gucciUtf16 = [];

    for (int i = 0; i < codePoints.length; i++) {
      var codePoint = codePoints[i];
      var utf16 = codePointToUtf16(codePoint);
      gucciUtf16.add(utf16);
    }

    var ret = '';

    for (var i = 0; i < gucciUtf16.length; i++) {
      var utf16 = gucciUtf16[i];

      if (utf16.length == 1) {
        /// two bytes

        int val = utf16[0];

        var hexVal = val.toRadixString(16);
        while (hexVal.length < 4) {
          hexVal = "0" + hexVal;
        }

        ret += hexVal;
      } else {
        /// four bytes
        int val2 = utf16[0];
        int val1 = utf16[1];

        var hexVal2 = val2.toRadixString(16);
        while (hexVal2.length < 4) {
          hexVal2 = "0" + hexVal2;
        }
        ret += hexVal2;

        var hexVal1 = val1.toRadixString(16);
        while (hexVal1.length < 4) {
          hexVal1 = "0" + hexVal2;
        }
        ret += hexVal1;
      }

      if (space) {
        if (i != gucciUtf16.length - 1) {
          ret += " ";
        }
      }
    }
    return ret;
  }
}

List codePointToUtf16(codePoint) {
  var utf16;
  if (codePoint <= 0xffff) {
    utf16 = [codePoint];
  } else {
    var minus10000 = codePoint - 0x10000;
    var byte2 = (minus10000 >> 10) + 0xD800;
    var byte1 = (minus10000 & bin("1111111111")) + 0xDC00;
    utf16 = [byte2, byte1];
  }
  return utf16;
}

int bin(String s) {
  return int.parse(s, radix: 2);
}

List utf8ToBytes(String text) {
  List bytes = [];
  var encoded = utf8.encode(text);
  for (int i = 0; i < encoded.length; i++) {
    bytes.add(String.fromCharCode(encoded[i]).codeUnitAt(0));
  }
  return bytes;
}
