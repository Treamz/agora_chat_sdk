import '../internal/inner_headers.dart';

///
/// The class for group message read receipts.
///
/// To get the chat group message receipts, call [ChatManager.fetchGroupAcks].
///
/// ```dart
///   ChatCursorResult<ChatGroupMessageAck> result = await ChatClient.getInstance.chatManager.fetchGroupAcks("msgId");
/// ```
///
///
///
class ChatGroupMessageAck {
  ///
  /// Gets the group message ID.
  ///
  /// **Return** The group message ID.
  ///
  ///
  ///
  final String messageId;

  ///
  /// Gets the ID of the  group message read receipt.
  ///
  /// **Return** The read receipt ID.
  ///
  ///
  ///
  final String? ackId;

  ///
  /// Gets the username of the user who sends the read receipt.
  ///
  /// **Return** The username of the read receipt sender.
  ///
  ///
  ///
  final String from;

  ///
  /// Gets the read receipt extension.
  ///
  /// For how to set the extension, see [ChatManager.sendGroupMessageReadAck].
  ///
  /// **Return** The read receipt extension.
  ///
  ///
  ///
  final String? content;

  ///
  /// Gets the number read receipts of group messages.
  ///
  /// **Return** The count in which read receipts of group messages are sent.
  ///
  ///
  ///
  final int readCount;

  ///
  /// Gets the timestamp of sending read receipts of group messages.
  ///
  /// **Return** The timestamp of sending read receipts of group messages.
  ///
  ///
  ///
  final int timestamp;

  /// @nodoc
  factory ChatGroupMessageAck.fromJson(Map map) {
    ChatGroupMessageAck ack = ChatGroupMessageAck._private(
      ackId: map["ack_id"],
      messageId: map["msg_id"] as String,
      from: map["from"] as String,
      content: map["content"],
      readCount: map["count"] ?? 0,
      timestamp: map["timestamp"] ?? 0,
    );

    return ack;
  }

  ChatGroupMessageAck._private({
    this.ackId,
    required this.messageId,
    required this.from,
    required this.content,
    required this.readCount,
    required this.timestamp,
  });
}