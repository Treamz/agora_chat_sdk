import 'package:agora_chat_sdk/src/internal/inner_headers.dart';

///
/// The parameter configuration class for pulling historical messages from the server.
///
///
///
class FetchMessageOptions {
  ///
  /// The parameter configuration class for pulling historical messages from the server.
  ///
  /// Param [direction] The message search direction, Default is [ChatSearchDirection.Up]. See [ChatSearchDirection].
  ///
  /// Param [from] The user ID of the message sender in the group conversation.
  ///
  /// Param [msgTypes] The array of message types for query. The default value is `null`, indicating that all types of messages are retrieved.
  ///
  /// Param [startTs] The start time for message query. The time is a UNIX time stamp in milliseconds.
  /// The default value is `-1`, indicating that this parameter is ignored during message query.
  /// If the [startTs] is set to a specific time spot and the [endTs] uses the default value `-1`,
  /// the SDK returns messages that are sent and received in the period that is from the start time to the current time.
  /// If the [startTs] uses the default value `-1` and the [endTs] is set to a specific time spot,
  /// the SDK returns messages that are sent and received in the period that is from the timestamp of the first message to the current time.
  ///
  /// Param [endTs] The end time for message query. The time is a UNIX time stamp in milliseconds.
  /// The default value is -1, indicating that this parameter is ignored during message query.
  /// If the [startTs] is set to a specific time spot and the [endTs] uses the default value -1,
  /// the SDK returns messages that are sent and received in the period that is from the start time to the current time.
  /// If the [startTs] uses the default value -1 and the [endTs] is set to a specific time spot,
  /// the SDK returns messages that are sent and received in the period that is from the timestamp of the first message to the current time.
  ///
  /// Param [needSave] Whether to save the retrieved messages to the database:
  /// - `true`: save to database;
  /// - `false`(Default)：no save to database.
  ///
  ///
  ///
  const FetchMessageOptions({
    this.from,
    this.msgTypes,
    this.startTs = -1,
    this.endTs = -1,
    this.needSave = false,
    this.direction = ChatSearchDirection.Up,
  });

  ///
  /// The user ID of the message sender in the group conversation.
  ///
  ///
  ///
  final String? from;

  ///
  /// The array of message types for query. The default value is `null`, indicating that all types of messages are retrieved.
  ///
  ///
  ///
  final List<MessageType>? msgTypes;

  ///
  /// The start time for message query. The time is a UNIX time stamp in milliseconds. The default value is -1,
  /// indicating that this parameter is ignored during message query.
  /// If the [startTs] is set to a specific time spot and the [endTs] uses the default value -1,
  /// the SDK returns messages that are sent and received in the period that is from the start time to the current time.
  /// If the [startTs] uses the default value -1 and the [endTs] is set to a specific time spot,
  /// the SDK returns messages that are sent and received in the period that is from the timestamp of the first message to the current time.
  ///
  ///
  ///
  final int startTs;

  ///
  /// The end time for message query. The time is a UNIX time stamp in milliseconds.
  /// The default value is `-1`, indicating that this parameter is ignored during message query.
  /// If the [startTs] is set to a specific time spot and the [endTs] uses the default value `-1`,
  /// the SDK returns messages that are sent and received in the period that is from the start time to the current time.
  /// If the [startTs] uses the default value `-1` and the [endTs] is set to a specific time spot,
  /// the SDK returns messages that are sent and received in the period that is from the timestamp of the first message to the current time.
  ///
  ///
  ///
  final int endTs;

  ///
  /// The message search direction, Default is [ChatSearchDirection.Up]. See [ChatSearchDirection].
  ///
  ///
  ///
  final ChatSearchDirection direction;

  ///
  /// Whether to save the retrieved messages to the database:
  /// - `true`: save to database;
  /// - (Default) `false`：Do not save to database.
  ///
  ///
  ///
  final bool needSave;

  Map toJson() {
    Map data = {};
    data.putIfNotNull(
        'direction', direction == ChatSearchDirection.Up ? "up" : "down");
    data.putIfNotNull('startTs', startTs);
    data.putIfNotNull('endTs', endTs);
    data.putIfNotNull('from', from);
    data.putIfNotNull('needSave', needSave);
    data.putIfNotNull('msgTypes',
        msgTypes?.toSet().map<String>((e) => messageTypeToTypeStr(e)).toList());

    return data;
  }
}
