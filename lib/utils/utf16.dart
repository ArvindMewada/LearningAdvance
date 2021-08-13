import 'utf8_to_utf16.dart';

class UTF16 {
  /// The text that is your input value
  String text;

  /// The space that add a space between all bytes
  bool space;

  /// Creates a new UTF16 with the provided arguments
  UTF16(
    this.text,
    this.space,
  );

  /// Get the value from UTF8
  String get value => UTF8ToUTF16(text, space).value;
}
