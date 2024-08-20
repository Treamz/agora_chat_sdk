///
/// The error class defined by the SDK.
///
///
///
class ChatError {
  ChatError._private(this.code, this.description);

  ///
  /// The error code.
  ///
  ///
  ///
  final int code;

  ///
  /// The error description.
  ///
  ///
  ///
  final String description;

  /// @nodoc
  factory ChatError.fromJson(Map map) {
    return ChatError._private(map['code'], map['description']);
  }

  /// @nodoc
  static hasErrorFromResult(Map map) {
    if (map['error'] == null) {
      return;
    } else {
      try {
        throw (ChatError.fromJson(map['error']));
      } on Exception {}
    }
  }

  @override
  String toString() {
    return "code: " + code.toString() + " desc: " + description;
  }
}
