///
/// The translation language class, which contains the information of the translation languages.
///
///
///
class ChatTranslateLanguage {
  ///
  /// The code of a target language. For example, the code for simplified Chinese is "zh-Hans".
  ///
  ///
  ///
  final String languageCode;

  ///
  /// The language name. For example, the code for simplified Chinese is "Chinese Simplified".
  ///
  ///
  ///
  final String languageName;

  ///
  /// The native name of the language. For example, the native name of simplified Chinese is "Chinese (Simplified)".
  ///
  ///
  ///
  final String languageNativeName;

  ChatTranslateLanguage._private({
    required this.languageCode,
    required this.languageName,
    required this.languageNativeName,
  });

  factory ChatTranslateLanguage.fromJson(Map map) {
    String code = map["code"];
    String name = map["name"];
    String nativeName = map["nativeName"];
    return ChatTranslateLanguage._private(
      languageCode: code,
      languageName: name,
      languageNativeName: nativeName,
    );
  }
}
