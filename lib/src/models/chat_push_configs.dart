import '../internal/inner_headers.dart';

///
/// The push configuration class.
///
///
///
class ChatPushConfigs {
  ChatPushConfigs._private({
    this.displayStyle = DisplayStyle.Simple,
    this.displayName,
  });

  ///
  /// The display type of push notifications.
  ///
  ///
  ///
  final DisplayStyle displayStyle;

  ///
  /// The user's nickname to be displayed in the notification.
  ///
  ///
  ///
  final String? displayName;

  /// @nodoc
  factory ChatPushConfigs.fromJson(Map map) {
    return ChatPushConfigs._private(
      displayStyle:
          map['pushStyle'] == 0 ? DisplayStyle.Simple : DisplayStyle.Summary,
      displayName: map["displayName"],
    );
  }
}
