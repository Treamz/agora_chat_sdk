// ignore_for_file: deprecated_member_use_from_same_package

import 'dart:math';

import 'package:flutter/services.dart';

import '../internal/inner_headers.dart';

///
/// The message class.
///
/// The sample code for constructing a text message to send is as follows.
///
/// ```dart
///   ChatMessage msg = ChatMessage.createTxtSendMessage(
///      username: "user1",
///      content: "hello",
///    );
/// ```
///
///
///
class ChatMessage {
  /// 消息 ID。
  String? _msgId;
  String _msgLocalId = DateTime.now().millisecondsSinceEpoch.toString() +
      Random().nextInt(99999).toString();

  ///
  /// Gets the message ID.
  ///
  /// **return** The message ID.
  ///
  ///
  ///
  String get msgId => _msgId ?? _msgLocalId;

  ///
  /// The conversation ID.
  ///
  ///
  ///
  String? conversationId;

  ///
  /// The ID of the message sender.
  /// - For a one-to-one chat, it is the username of the peer user.
  /// - For a group chat, it is the group ID.
  /// - For a chat room, it is the chat room ID.
  ///
  ///
  ///
  String? from = '';

  ///
  /// The ID of the message recipient.
  /// - For a one-to-one chat, it is the username of the peer user.
  /// - For a group chat, it is the group ID.
  /// - For a chat room, it is the chat room ID.
  ///
  ///
  ///
  String? to = '';

  ///
  /// The local timestamp when the message is created on the local device, in milliseconds.
  ///
  ///
  ///
  int localTime = DateTime.now().millisecondsSinceEpoch;

  ///
  /// The timestamp when the message is received by the server.
  ///
  ///
  ///
  int serverTime = DateTime.now().millisecondsSinceEpoch;

  ///
  /// The delivery receipt, which is to check whether the other party has received the message.
  ///
  ///  Whether the recipient has received the message.
  /// - `true`: Yes.
  /// - `false`: No.
  ///
  ///
  ///
  bool hasDeliverAck = false;

  ///
  /// Whether the recipient has read the message.
  /// - `true`: Yes.
  /// - `false`: No.
  ///
  ///
  ///
  bool hasReadAck = false;

  ///
  /// Whether read receipts are required for group messages.
  ///
  /// - `true`: Yes.
  /// - `false`: No.
  ///
  ///
  ///
  ///
  bool needGroupAck = false;

  ///
  /// Is it a message sent within a thread
  ///
  ///
  ///
  bool isChatThreadMessage = false;

  ///
  /// Whether the message is read.
  /// - `true`: Yes.
  /// - `false`: No.
  ///
  ///
  ///
  bool hasRead = false;

  ///
  /// The enumeration of the chat type.
  ///
  /// There are three chat types: one-to-one chat, group chat, and chat room.
  ///
  ///
  ///
  ChatType chatType = ChatType.Chat;

  ///
  /// The message direction. see [MessageDirection].
  ///
  ///
  ///
  MessageDirection direction = MessageDirection.SEND;

  ///
  /// Gets the message sending/reception status. see [MessageStatus].
  ///
  ///
  ///
  MessageStatus status = MessageStatus.CREATE;

  ///
  /// Message's extension attribute.
  ///
  ///
  ///
  Map? attributes;

  ///
  /// Whether the message is delivered only when the recipient(s) is/are online:
  ///
  /// - `true`：The message is delivered only when the recipient(s) is/are online. If the recipient is offline, the message is discarded.
  /// - `false` (Default) ：The message is delivered when the recipient(s) is/are online. If the recipient(s) is/are offline, the message will not be delivered to them until they get online.
  ///
  ///
  ///
  bool deliverOnlineOnly = false;

  ///
  /// The recipient list of a targeted message.
  ///
  /// This property is used only for messages in groups and chat rooms.
  ///
  ///
  ///
  List<String>? receiverList;

  ///
  /// Message body. We recommend you use [ChatMessageBody].
  ///
  ///
  ///
  late ChatMessageBody body;

  ///
  /// Message Online Status
  ///
  /// Local database does not store. The default value for reading or pulling roaming messages from the database is YES
  ///
  ///
  ///
  late final bool onlineState;

  ChatRoomMessagePriority? _priority;

  ///
  /// Sets the priority of chat room messages.
  /// param [priority] The priority of chat room messages. The default value is `Normal`, indicating the normal priority. For details, see[ChatRoomMessagePriority].
  ///
  ///
  ///
  set chatroomMessagePriority(ChatRoomMessagePriority priority) {
    _priority = priority;
  }

  ChatMessage._private();

  ///
  /// Creates a received message instance.
  ///
  /// Param [body] The message body.
  ///
  /// Param [chatType] The chat type, default is single chat, if it is group chat or chat room, see [ChatType].
  ///
  /// **Return** The message instance.
  ///
  ///
  ///
  ChatMessage.createReceiveMessage({
    required this.body,
    this.chatType = ChatType.Chat,
  }) {
    this.onlineState = true;
    this.direction = MessageDirection.RECEIVE;
  }

  ///
  /// Creates a message instance for sending.
  ///
  /// Param [body] The message body.
  ///
  /// Param [to] The ID of the message recipient.
  /// - For a one-to-one chat, it is the username of the peer user.
  /// - For a group chat, it is the group ID.
  /// - For a chat room, it is the chat room ID.
  ///
  /// Param [chatType] The chat type, default is single chat, if it is group chat or chat room, see [ChatType].
  ///
  /// **Return** The message instance.
  ///
  ///
  ///
  ChatMessage.createSendMessage({
    required this.body,
    this.to,
    this.chatType = ChatType.Chat,
  })  : this.from = ChatClient.getInstance.currentUserId,
        this.conversationId = to {
    this.hasRead = true;
    this.direction = MessageDirection.SEND;
    this.onlineState = true;
  }

  void dispose() {}

  ///
  /// Creates a text message for sending.
  ///
  /// Param [targetId] The ID of the message recipient.
  /// - For a one-to-one chat, it is the username of the peer user.
  /// - For a group chat, it is the group ID.
  /// - For a chat room, it is the chat room ID.
  ///
  /// Param [content] The text content.
  ///
  /// Param [targetLanguages] Target languages.
  ///
  /// Param [chatType] The chat type, default is single chat, if it is group chat or chat room, see [ChatType].
  ///
  /// **Return** The message instance.
  ///
  ///
  ///
  ChatMessage.createTxtSendMessage({
    required String targetId,
    required String content,
    List<String>? targetLanguages,
    ChatType chatType = ChatType.Chat,
  }) : this.createSendMessage(
          chatType: chatType,
          to: targetId,
          body: ChatTextMessageBody(
            content: content,
            targetLanguages: targetLanguages,
          ),
        );

  ///
  /// Creates a file message for sending.
  ///
  /// Param [targetId] The ID of the message recipient.
  /// - For a one-to-one chat, it is the username of the peer user.
  /// - For a group chat, it is the group ID.
  /// - For a chat room, it is the chat room ID.
  ///
  /// Param [filePath] The file path.
  ///
  /// Param [displayName] The file name.
  ///
  /// Param [fileSize] The file size in bytes.
  ///
  /// Param [chatType] The chat type, default is single chat, if it is group chat or chat room, see [ChatType].
  ///
  /// **Return** The message instance.
  ///
  ///
  ///
  ChatMessage.createFileSendMessage({
    required String targetId,
    required String filePath,
    String? displayName,
    int? fileSize,
    ChatType chatType = ChatType.Chat,
  }) : this.createSendMessage(
            chatType: chatType,
            to: targetId,
            body: ChatFileMessageBody(
              localPath: filePath,
              fileSize: fileSize,
              displayName: displayName,
            ));

  ///
  /// Creates an image message for sending.
  ///
  /// Param [targetId] The ID of the message recipient.
  /// - For a one-to-one chat, it is the username of the peer user.
  /// - For a group chat, it is the group ID.
  /// - For a chat room, it is the chat room ID.
  ///
  /// Param [filePath] The image path.
  ///
  /// Param [displayName] The image name.
  ///
  /// Param [thumbnailLocalPath] The local path of the image thumbnail.
  ///
  /// Param [sendOriginalImage] Whether to send the original image.
  /// - `true`: Yes.
  /// - `false`: (default) No. For an image greater than 100 KB, the SDK will compress it and send the thumbnail.
  ///
  /// Param [fileSize] The image file size in bytes.
  ///
  /// Param [width] The image width in pixels.
  ///
  /// Param [height] The image height in pixels.
  ///
  /// Param [chatType] The chat type, default is single chat, if it is group chat or chat room, see [ChatType].
  ///
  /// **Return** The message instance.
  ///
  ///
  ///
  ChatMessage.createImageSendMessage({
    required String targetId,
    required String filePath,
    String? displayName,
    String? thumbnailLocalPath,
    bool sendOriginalImage = false,
    int? fileSize,
    double? width,
    double? height,
    ChatType chatType = ChatType.Chat,
  }) : this.createSendMessage(
            chatType: chatType,
            to: targetId,
            body: ChatImageMessageBody(
              localPath: filePath,
              displayName: displayName,
              thumbnailLocalPath: thumbnailLocalPath,
              sendOriginalImage: sendOriginalImage,
              width: width,
              height: height,
            ));

  ///
  /// Creates a video message instance for sending.
  ///
  /// Param [targetId] The ID of the message recipient.
  /// - For a one-to-one chat, it is the username of the peer user.
  /// - For a group chat, it is the group ID.
  /// - For a chat room, it is the chat room ID.
  ///
  /// Param [filePath] The path of the video file.
  ///
  /// Param [displayName] The video name.
  ///
  /// Param [duration] The video duration in seconds.
  ///
  /// Param [fileSize] The video file size in bytes.
  ///
  /// Param [thumbnailLocalPath] The local path of the thumbnail, which is usually the first frame of video.
  ///
  /// Param [width] The width of the video thumbnail, in pixels.
  ///
  /// Param [height] The height of the video thumbnail, in pixels.
  ///
  /// Param [chatType] The chat type, default is single chat, if it is group chat or chat room, see [ChatType].
  ///
  /// **Return** The message instance.
  ///
  ///
  ///
  ChatMessage.createVideoSendMessage({
    required String targetId,
    required String filePath,
    String? displayName,
    int duration = 0,
    int? fileSize,
    String? thumbnailLocalPath,
    double? width,
    double? height,
    ChatType chatType = ChatType.Chat,
  }) : this.createSendMessage(
            chatType: chatType,
            to: targetId,
            body: ChatVideoMessageBody(
              localPath: filePath,
              displayName: displayName,
              duration: duration,
              fileSize: fileSize,
              thumbnailLocalPath: thumbnailLocalPath,
              width: width,
              height: height,
            ));

  ///
  /// Creates a voice message for sending.
  ///
  /// Param [targetId] The ID of the message recipient.
  /// - For a one-to-one chat, it is the username of the peer user.
  /// - For a group chat, it is the group ID.
  /// - For a chat room, it is the chat room ID.
  ///
  /// Param [filePath] The path of the voice file.
  ///
  /// Param [duration] The voice duration in seconds.
  ///
  /// Param [fileSize] The size of the voice file, in bytes.
  ///
  /// Param [displayName] The name of the voice file which ends with a suffix that indicates the format of the file. For example "voice.mp3".
  ///
  /// Param [chatType] The chat type, default is single chat, if it is group chat or chat room, see [ChatType].
  ///
  /// **Return** The message instance.
  ///
  ///
  ///
  ChatMessage.createVoiceSendMessage({
    required String targetId,
    required String filePath,
    int duration = 0,
    int? fileSize,
    String? displayName,
    ChatType chatType = ChatType.Chat,
  }) : this.createSendMessage(
            chatType: chatType,
            to: targetId,
            body: ChatVoiceMessageBody(
                localPath: filePath,
                duration: duration,
                fileSize: fileSize,
                displayName: displayName));

  ///
  /// Creates a location message for sending.
  ///
  /// Param [targetId] The ID of the message recipient.
  /// - For a one-to-one chat, it is the username of the peer user.
  /// - For a group chat, it is the group ID.
  /// - For a chat room, it is the chat room ID.
  ///
  /// Param [latitude] The latitude.
  ///
  /// Param [longitude] The longitude.
  ///
  /// Param [address] The address.
  ///
  /// Param [buildingName] The building name.
  ///
  /// Param [chatType] The chat type, default is single chat, if it is group chat or chat room, see [ChatType].
  ///
  /// **Return** The message instance.
  ///
  ///
  ///
  ChatMessage.createLocationSendMessage({
    required String targetId,
    required double latitude,
    required double longitude,
    String? address,
    String? buildingName,
    ChatType chatType = ChatType.Chat,
  }) : this.createSendMessage(
            chatType: chatType,
            to: targetId,
            body: ChatLocationMessageBody(
              latitude: latitude,
              longitude: longitude,
              address: address,
              buildingName: buildingName,
            ));

  ///
  /// Creates a command message for sending.
  ///
  /// Param [targetId] The ID of the message recipient.
  /// - For a one-to-one chat, it is the username of the peer user.
  /// - For a group chat, it is the group ID.
  /// - For a chat room, it is the chat room ID.
  ///
  /// Param [action] The command action.
  ///
  /// Param [deliverOnlineOnly] Whether to send only to online users.
  ///
  /// Param [chatType] The chat type, default is single chat, if it is group chat or chat room, see [ChatType].
  ///
  /// **Return** The message instance.
  ///
  ///
  ///
  ChatMessage.createCmdSendMessage({
    required String targetId,
    required action,
    bool deliverOnlineOnly = false,
    ChatType chatType = ChatType.Chat,
  }) : this.createSendMessage(
            chatType: chatType,
            to: targetId,
            body: ChatCmdMessageBody(
                action: action, deliverOnlineOnly: deliverOnlineOnly));

  ///
  /// Creates a custom message for sending.
  ///
  /// Param [targetId] The ID of the message recipient.
  /// - For a one-to-one chat, it is the username of the peer user.
  /// - For a group chat, it is the group ID.
  /// - For a chat room, it is the chat room ID.
  ///
  /// Param [event] The event.
  ///
  /// Param [params] The params map.
  ///
  /// Param [chatType] The chat type, default is single chat, if it is group chat or chat room, see [ChatType].
  ///
  /// **Return** The message instance.
  ///
  ///
  ///
  ChatMessage.createCustomSendMessage({
    required String targetId,
    required event,
    Map<String, String>? params,
    ChatType chatType = ChatType.Chat,
  }) : this.createSendMessage(
            chatType: chatType,
            to: targetId,
            body: ChatCustomMessageBody(event: event, params: params));

  ///
  /// Creates a combined message for sending.
  ///
  /// Param [targetId] The message recipient. The field setting is determined by the conversation type:
  /// - For a one-to-one chat, it is the user ID of the peer user.
  /// - For a group chat, it is the group ID.
  /// - For a chat room, it is the chat room ID.
  ///
  /// Param [title]  The title of the combined message.
  ///
  /// Param [summary]  The summary of the combined message.
  ///
  /// Param [compatibleText] The compatible text of the combined message.
  ///
  /// Param [msgIds] The list of original messages included in the combined message.
  ///
  /// Param [chatType] The chat type, which is one-to-one chat by default. For group chat or chat room, see [ChatType].
  ///
  /// **Return** The message instance.
  ///
  ///
  ///
  ChatMessage.createCombineSendMessage({
    required String targetId,
    String? title,
    String? summary,
    String? compatibleText,
    required List<String> msgIds,
    ChatType chatType = ChatType.Chat,
  }) : this.createSendMessage(
            chatType: chatType,
            to: targetId,
            body: CombineMessageBody(
              title: title,
              summary: summary,
              compatibleText: compatibleText,
              messageList: msgIds,
            ));

  /// @nodoc
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data.putIfNotNull("from", from);
    data.putIfNotNull("to", to);
    data.putIfNotNull("body", body.toJson());
    data.putIfNotNull("attributes", attributes);
    data.putIfNotNull(
        "direction", this.direction == MessageDirection.SEND ? 'send' : 'rec');
    data.putIfNotNull("hasRead", hasRead);
    data.putIfNotNull("hasReadAck", hasReadAck);
    data.putIfNotNull("hasDeliverAck", hasDeliverAck);
    data.putIfNotNull("needGroupAck", needGroupAck);
    data.putIfNotNull("msgId", msgId);
    data.putIfNotNull("conversationId", this.conversationId ?? this.to);
    data.putIfNotNull("chatType", chatTypeToInt(chatType));
    data.putIfNotNull("localTime", localTime);
    data.putIfNotNull("serverTime", serverTime);
    data.putIfNotNull("status", messageStatusToInt(this.status));
    data.putIfNotNull("isThread", isChatThreadMessage);
    if (_priority != null) {
      data.putIfNotNull("chatroomMessagePriority", _priority!.index);
    }
    data.putIfNotNull('deliverOnlineOnly', deliverOnlineOnly);
    if (receiverList != null) {
      data.putIfNotNull('receiverList', receiverList);
    }

    return data;
  }

  /// @nodoc
  factory ChatMessage.fromJson(Map<String, dynamic> map) {
    return ChatMessage._private()
      ..to = map["to"]
      ..from = map["from"]
      ..body = _bodyFromMap(map["body"])!
      ..attributes = map.getMapValue("attributes")
      ..direction = map["direction"] == 'send'
          ? MessageDirection.SEND
          : MessageDirection.RECEIVE
      ..hasRead = map.boolValue('hasRead')
      ..hasReadAck = map.boolValue('hasReadAck')
      ..needGroupAck = map.boolValue('needGroupAck')
      ..hasDeliverAck = map.boolValue('hasDeliverAck')
      .._msgId = map["msgId"]
      ..conversationId = map["conversationId"]
      ..chatType = chatTypeFromInt(map["chatType"])
      ..localTime = map["localTime"] ?? 0
      ..serverTime = map["serverTime"] ?? 0
      ..isChatThreadMessage = map["isThread"] ?? false
      ..onlineState = map["onlineState"] ?? true
      ..deliverOnlineOnly = map['deliverOnlineOnly'] ?? false
      ..status = messageStatusFromInt(map["status"])
      ..receiverList = map["receiverList"]?.cast<String>();
  }

  static ChatMessageBody? _bodyFromMap(Map map) {
    ChatMessageBody? body;
    switch (map['type']) {
      case 'txt':
        body = ChatTextMessageBody.fromJson(map: map);
        break;
      case 'loc':
        body = ChatLocationMessageBody.fromJson(map: map);
        break;
      case 'cmd':
        body = ChatCmdMessageBody.fromJson(map: map);
        break;
      case 'custom':
        body = ChatCustomMessageBody.fromJson(map: map);
        break;
      case 'file':
        body = ChatFileMessageBody.fromJson(map: map);
        break;
      case 'img':
        body = ChatImageMessageBody.fromJson(map: map);
        break;
      case 'video':
        body = ChatVideoMessageBody.fromJson(map: map);
        break;
      case 'voice':
        body = ChatVoiceMessageBody.fromJson(map: map);
        break;
      case 'combine':
        body = CombineMessageBody.fromJson(map: map);
        break;
      default:
    }

    return body;
  }

  @override
  String toString() {
    return toJson().toString();
  }

  static const MethodChannel _emMessageChannel =
      const MethodChannel('com.chat.im/chat_message', JSONMethodCodec());

  ///
  /// Gets the Reaction list.
  ///
  /// **Return** The Reaction list
  ///
  /// **Throws** A description of the exception. See [ChatError]
  ///
  ///
  ///
  Future<List<ChatMessageReaction>> reactionList() async {
    Map req = {"msgId": msgId};
    Map result = await _emMessageChannel.invokeMethod(
      ChatMethodKeys.getReactionList,
      req,
    );
    try {
      ChatError.hasErrorFromResult(result);
      List<ChatMessageReaction> list = [];
      result[ChatMethodKeys.getReactionList]?.forEach(
        (element) => list.add(
          ChatMessageReaction.fromJson(element),
        ),
      );
      return list;
    } on ChatError catch (e) {
      throw e;
    }
  }

  ///
  /// Gets the number of members that have read the group message.
  ///
  /// **Return** group ack count
  ///
  /// **Throws** A description of the exception. See [ChatError]
  ///
  ///
  ///
  Future<int> groupAckCount() async {
    Map req = {"msgId": msgId};
    Map result =
        await _emMessageChannel.invokeMethod(ChatMethodKeys.groupAckCount, req);
    try {
      ChatError.hasErrorFromResult(result);
      if (result.containsKey(ChatMethodKeys.groupAckCount)) {
        return result[ChatMethodKeys.groupAckCount];
      } else {
        return 0;
      }
    } on ChatError catch (e) {
      throw e;
    }
  }

  ///
  /// Get an overview of the thread in the message (currently only supported by group messages)
  ///
  /// **Return** overview of the thread
  ///
  /// **Throws** A description of the exception. See [ChatError]
  ///
  ///
  ///
  Future<ChatThread?> chatThread() async {
    Map req = {"msgId": msgId};
    Map result =
        await _emMessageChannel.invokeMethod(ChatMethodKeys.getChatThread, req);
    try {
      ChatError.hasErrorFromResult(result);
      if (result.containsKey(ChatMethodKeys.getChatThread)) {
        return result.getValue<ChatThread>(ChatMethodKeys.getChatThread,
            callback: (obj) => ChatThread.fromJson(obj));
      } else {
        return null;
      }
    } on ChatError catch (e) {
      throw e;
    }
  }
}

/// @nodoc
abstract class ChatMessageBody {
  ChatMessageBody({required this.type});

  /// @nodoc
  ChatMessageBody.fromJson({
    required Map map,
    required this.type,
  }) {
    _operatorTime = map["operatorTime"];
    _operatorId = map["operatorId"];
    _operatorCount = map["operatorCount"];
  }

  /// @nodoc
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = messageTypeToTypeStr(this.type);
    return data;
  }

  @override
  String toString() {
    return toJson().toString();
  }

  ///
  /// Gets the chat message type.
  ///
  ///
  ///
  MessageType type;

  ///
  /// Get the user ID of the operator that modified the message last time.
  ///
  ///
  ///
  String? _operatorId;

  ///
  /// Get the UNIX timestamp of the last message modification, in milliseconds.
  ///
  ///
  ///
  int? _operatorTime;

  ///
  /// Get the number of times a message is modified.
  ///
  ///
  ///
  int? _operatorCount;
}

///
/// The command message body.
///
///
///
class ChatCmdMessageBody extends ChatMessageBody {
  ///
  /// Creates a command message.
  ///
  ///
  ///
  ChatCmdMessageBody({required this.action, this.deliverOnlineOnly = false})
      : super(type: MessageType.CMD);

  /// @nodoc
  ChatCmdMessageBody.fromJson({required Map map})
      : super.fromJson(map: map, type: MessageType.CMD) {
    this.action = map["action"];
    this.deliverOnlineOnly = map["deliverOnlineOnly"] ?? false;
  }

  /// @nodoc
  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = super.toJson();
    data.putIfNotNull("action", action);
    data.putIfNotNull("deliverOnlineOnly", deliverOnlineOnly);

    return data;
  }

  ///
  /// The command action content.
  ///
  ///
  ///
  late final String action;

  ///
  /// Checks whether this command message is only delivered to online users.
  ///
  /// - `true`: Yes.
  /// - `false`: No.
  ///
  ///
  ///
  bool deliverOnlineOnly = false;
}

///
/// The location message class.
///
///
///
class ChatLocationMessageBody extends ChatMessageBody {
  ///
  /// Creates a location message body instance.
  ///
  /// Param [latitude] The latitude.
  ///
  /// Param [longitude] The longitude.
  ///
  /// Param [address] The address.
  ///
  /// Param [buildingName] The building name.
  ///
  ///
  ///
  ChatLocationMessageBody({
    required this.latitude,
    required this.longitude,
    String? address,
    String? buildingName,
  }) : super(type: MessageType.LOCATION) {
    _address = address;
    _buildingName = buildingName;
  }

  /// @nodoc
  ChatLocationMessageBody.fromJson({required Map map})
      : super.fromJson(map: map, type: MessageType.LOCATION) {
    this.latitude = (map["latitude"] ?? 0).toDouble();
    this.longitude = (map["longitude"] ?? 0).toDouble();
    this._address = map["address"];
    this._buildingName = map["buildingName"];
  }

  /// @nodoc
  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = super.toJson();
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data.putIfNotNull("address", this._address);
    data.putIfNotNull("buildingName", this._buildingName);
    return data;
  }

  String? _address;
  String? _buildingName;

  ///
  /// The address.
  ///
  ///
  ///
  String? get address => _address;

  ///
  /// The building name.
  ///
  ///
  ///
  String? get buildingName => _buildingName;

  ///
  /// The latitude.
  ///
  ///
  ///
  late final double latitude;

  ///
  /// The longitude.
  ///
  ///
  ///
  late final double longitude;
}

///
/// The base class of file messages.
///
///
///
class ChatFileMessageBody extends ChatMessageBody {
  ///
  /// Creates a message with an attachment.
  ///
  /// Param [localPath] The path of the image file.
  ///
  /// Param [displayName] The file name.
  ///
  /// Param [fileSize] The size of the file in bytes.
  ///
  /// Param [type] The file type.
  ///
  ///
  ///
  ChatFileMessageBody({
    required this.localPath,
    this.displayName,
    this.fileSize,
    MessageType type = MessageType.FILE,
  }) : super(type: type);

  /// @nodoc
  ChatFileMessageBody.fromJson(
      {required Map map, MessageType type = MessageType.FILE})
      : super.fromJson(map: map, type: type) {
    this.secret = map["secret"];
    this.remotePath = map["remotePath"];
    this.fileSize = map["fileSize"];
    this.localPath = map["localPath"] ?? "";
    this.displayName = map["displayName"];
    this.fileStatus =
        ChatFileMessageBody.downloadStatusFromInt(map["fileStatus"]);
  }

  /// @nodoc
  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = super.toJson();
    data.putIfNotNull("secret", this.secret);
    data.putIfNotNull("remotePath", this.remotePath);
    data.putIfNotNull("fileSize", this.fileSize);
    data.putIfNotNull("localPath", this.localPath);
    data.putIfNotNull("displayName", this.displayName);
    data.putIfNotNull("fileStatus", downloadStatusToInt(this.fileStatus));

    return data;
  }

  ///
  /// The local path of the attachment.
  ///
  ///
  ///
  late final String localPath;

  ///
  /// The token used to get the attachment.
  ///
  ///
  ///
  String? secret;

  ///
  /// The attachment path in the server.
  ///
  ///
  ///
  String? remotePath;

  ///
  /// The download status of the attachment.
  ///
  ///
  ///
  DownloadStatus fileStatus = DownloadStatus.PENDING;

  ///
  /// The size of the attachment in bytes.
  ///
  ///
  ///
  int? fileSize;

  ///
  /// The attachment name.
  ///
  ///
  ///
  String? displayName;

  static DownloadStatus downloadStatusFromInt(int? status) {
    if (status == 0) {
      return DownloadStatus.DOWNLOADING;
    } else if (status == 1) {
      return DownloadStatus.SUCCESS;
    } else if (status == 2) {
      return DownloadStatus.FAILED;
    } else {
      return DownloadStatus.PENDING;
    }
  }
}

///
/// The image message body class.
///
///
///
class ChatImageMessageBody extends ChatFileMessageBody {
  ///
  /// Creates an image message body with an image file.
  ///
  /// Param [localPath] The local path of the image file.
  ///
  /// Param [displayName] The image name.
  ///
  /// Param [thumbnailLocalPath] The local path of the image thumbnail.
  ///
  /// Param [sendOriginalImage] The original image included in the image message to be sent.
  ///
  /// Param [fileSize] The size of the image file in bytes.
  ///
  /// Param [width] The image width in pixels.
  ///
  /// Param [height] The image height in pixels.
  ///
  ///
  ///
  ChatImageMessageBody({
    required String localPath,
    String? displayName,
    this.thumbnailLocalPath,
    this.sendOriginalImage = false,
    int? fileSize,
    this.width,
    this.height,
  }) : super(
          localPath: localPath,
          displayName: displayName,
          fileSize: fileSize,
          type: MessageType.IMAGE,
        );

  /// @nodoc
  ChatImageMessageBody.fromJson({required Map map})
      : super.fromJson(map: map, type: MessageType.IMAGE) {
    this.thumbnailLocalPath = map["thumbnailLocalPath"];
    this.thumbnailRemotePath = map["thumbnailRemotePath"];
    this.thumbnailSecret = map["thumbnailSecret"];
    this.sendOriginalImage = map["sendOriginalImage"] ?? false;
    this.height = (map["height"] ?? 0).toDouble();
    this.width = (map["width"] ?? 0).toDouble();
    this.thumbnailStatus =
        ChatFileMessageBody.downloadStatusFromInt(map["thumbnailStatus"]);
  }

  /// @nodoc
  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = super.toJson();
    data.putIfNotNull("thumbnailLocalPath", thumbnailLocalPath);
    data.putIfNotNull("thumbnailRemotePath", thumbnailRemotePath);
    data.putIfNotNull("thumbnailSecret", thumbnailSecret);
    data.putIfNotNull("sendOriginalImage", sendOriginalImage);
    data.putIfNotNull("height", height ?? 0.0);
    data.putIfNotNull("width", width ?? 0.0);
    data.putIfNotNull(
        "thumbnailStatus", downloadStatusToInt(this.thumbnailStatus));
    return data;
  }

  ///
  /// Whether to send the original image.
  ///
  /// - `false`: (default) No. The original image will be compressed if it exceeds 100 KB and the thumbnail will be sent.
  /// - `true`: Yes.
  ///
  ///
  ///
  bool sendOriginalImage = false;

  ///
  /// The local path or the URI (a string) of the thumbnail.
  ///
  ///
  ///
  String? thumbnailLocalPath;

  ///
  /// The URL of the thumbnail on the server.
  ///
  ///
  ///
  String? thumbnailRemotePath;

  ///
  /// The secret to access the thumbnail. A secret is required for verification for thumbnail download.
  ///
  ///
  ///
  String? thumbnailSecret;

  ///
  /// The download status of the thumbnail.
  ///
  ///
  ///
  DownloadStatus thumbnailStatus = DownloadStatus.PENDING;

  ///
  /// The image width in pixels.
  ///
  ///
  ///
  double? width;

  ///
  /// The image height in pixels.
  ///
  ///
  ///
  double? height;
}

///
/// The text message class.
///
///
///
class ChatTextMessageBody extends ChatMessageBody {
  ///
  /// Creates a text message.
  ///
  /// Param [content] The text content.
  ///
  ///
  ///
  ChatTextMessageBody({
    required this.content,
    this.targetLanguages,
  }) : super(type: MessageType.TXT);

  /// @nodoc
  ChatTextMessageBody.fromJson({required Map map})
      : super.fromJson(map: map, type: MessageType.TXT) {
    this.content = map["content"] ?? "";
    this.targetLanguages = map.getList("targetLanguages");
    if (map.containsKey("translations")) {
      this.translations = map["translations"]?.cast<String, String>();
    }
  }

  @override

  ///@nodoc
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = super.toJson();
    data['content'] = this.content;
    data.putIfNotNull("targetLanguages", this.targetLanguages);
    data.putIfNotNull("translations", this.translations);
    return data;
  }

  ///
  /// The text content.
  ///
  ///
  ///
  late final String content;

  ///
  /// The target languages to translate
  ///
  ///
  ///
  List<String>? targetLanguages;

  ///
  /// It is Map, key is target language, value is translated content
  ///
  ///
  ///
  Map<String, String>? translations;

  ///
  /// Get the user ID of the operator that modified the message last time.
  ///
  ///
  ///
  String? get lastModifyOperatorId => _operatorId;

  ///
  /// Get the UNIX timestamp of the last message modification, in milliseconds.
  ///
  ///
  ///
  int? get lastModifyTime => _operatorTime;

  ///
  /// Get the number of times a message is modified.
  ///
  ///
  ///
  int? get modifyCount => _operatorCount;
}

///
/// The video message body class.
///
///
///
class ChatVideoMessageBody extends ChatFileMessageBody {
  ///
  /// Creates a video message.
  ///
  /// Param [localPath] The local path of the video file.
  ///
  /// Param [displayName] The video name.
  ///
  /// Param [duration] The video duration in seconds.
  ///
  /// Param [fileSize] The size of the video file in bytes.
  ///
  /// Param [thumbnailLocalPath] The local path of the video thumbnail.
  ///
  /// Param [height] The video height in pixels.
  ///
  /// Param [width] The video width in pixels.
  ///
  ///
  ///
  ChatVideoMessageBody({
    required String localPath,
    String? displayName,
    this.duration = 0,
    int? fileSize,
    this.thumbnailLocalPath,
    this.height,
    this.width,
  }) : super(
          localPath: localPath,
          displayName: displayName,
          fileSize: fileSize,
          type: MessageType.VIDEO,
        );

  /// @nodoc
  ChatVideoMessageBody.fromJson({required Map map})
      : super.fromJson(map: map, type: MessageType.VIDEO) {
    this.duration = map["duration"];
    this.thumbnailLocalPath = map["thumbnailLocalPath"];
    this.thumbnailRemotePath = map["thumbnailRemotePath"];
    this.thumbnailSecret = map["thumbnailSecret"];
    this.height = (map["height"] ?? 0).toDouble();
    this.width = (map["width"] ?? 0).toDouble();
    this.thumbnailStatus =
        ChatFileMessageBody.downloadStatusFromInt(map["thumbnailStatus"]);
  }

  /// @nodoc
  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = super.toJson();
    data.putIfNotNull("duration", duration);
    data.putIfNotNull("thumbnailLocalPath", thumbnailLocalPath);
    data.putIfNotNull("thumbnailRemotePath", thumbnailRemotePath);
    data.putIfNotNull("thumbnailSecret", thumbnailSecret);
    data.putIfNotNull("height", height ?? 0.0);
    data.putIfNotNull("width", width ?? 0.0);
    data.putIfNotNull(
        "thumbnailStatus", downloadStatusToInt(this.thumbnailStatus));

    return data;
  }

  ///
  /// The video duration in seconds.
  ///
  ///
  ///
  int? duration;

  ///
  /// The local path of the video thumbnail.
  ///
  ///
  ///
  String? thumbnailLocalPath;

  ///
  /// The URL of the thumbnail on the server.
  ///
  ///
  ///
  String? thumbnailRemotePath;

  ///
  /// The secret key of the video thumbnail.
  ///
  ///
  ///
  String? thumbnailSecret;

  ///
  /// The download status of the video thumbnail.
  ///
  ///
  ///
  DownloadStatus thumbnailStatus = DownloadStatus.PENDING;

  ///
  /// The video width in pixels.
  ///
  ///
  ///
  double? width;

  ///
  /// The video height in pixels.
  ///
  ///
  ///
  double? height;
}

///
/// The voice message body class.
///
///
///
class ChatVoiceMessageBody extends ChatFileMessageBody {
  ///
  /// Creates a voice message.
  ///
  /// Param [localPath] The local path of the voice file.
  ///
  /// Param [displayName] The name of the voice file.
  ///
  /// Param [fileSize] The size of the voice file in bytes.
  ///
  /// Param [duration] The voice duration in seconds.
  ///
  ///
  ///
  ChatVoiceMessageBody({
    localPath,
    this.duration = 0,
    String? displayName,
    int? fileSize,
  }) : super(
          localPath: localPath,
          displayName: displayName,
          fileSize: fileSize,
          type: MessageType.VOICE,
        );

  /// @nodoc
  ChatVoiceMessageBody.fromJson({required Map map})
      : super.fromJson(map: map, type: MessageType.VOICE) {
    this.duration = map["duration"] ?? 0;
  }

  /// @nodoc
  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = super.toJson();
    data.putIfNotNull("duration", duration);
    return data;
  }

  ///
  /// The voice duration in seconds.
  ///
  ///
  ///
  late final int duration;
}

///
/// The custom message body.
///
///
///
class ChatCustomMessageBody extends ChatMessageBody {
  ///
  /// Creates a custom message.
  ///
  ///
  ///
  ChatCustomMessageBody({
    required this.event,
    this.params,
  }) : super(type: MessageType.CUSTOM);
  ChatCustomMessageBody.fromJson({required Map map})
      : super.fromJson(map: map, type: MessageType.CUSTOM) {
    this.event = map["event"];
    this.params = map["params"]?.cast<String, String>();
  }

  /// @nodoc
  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = super.toJson();
    data.putIfNotNull("event", event);
    data.putIfNotNull("params", params);

    return data;
  }

  ///
  /// The event.
  ///
  ///
  ///
  late final String event;

  ///
  /// The custom params map.
  ///
  ///
  ///
  Map<String, String>? params;
}

class CombineMessageBody extends ChatMessageBody {
  CombineMessageBody({
    this.title,
    this.summary,
    List<String>? messageList,
    String? compatibleText,
  })  : _compatibleText = compatibleText,
        _messageList = messageList,
        super(type: MessageType.COMBINE);

  final String? title;
  final String? summary;
  final List<String>? _messageList;
  late final String? _compatibleText;

  String? _localPath;
  String? _remotePath;
  String? _secret;

  /// @nodoc
  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = super.toJson();
    data.putIfNotNull("title", title);
    data.putIfNotNull("summary", summary);
    data.putIfNotNull("messageList", _messageList);
    data.putIfNotNull("compatibleText", _compatibleText);
    data.putIfNotNull("localPath", _localPath);
    data.putIfNotNull("remotePath", _remotePath);
    data.putIfNotNull("secret", _secret);
    return data;
  }

  /// @nodoc
  factory CombineMessageBody.fromJson({required Map map}) {
    var body = CombineMessageBody(
      title: map["title"],
      summary: map["summary"],
    );
    body._localPath = map["localPath"];
    body._remotePath = map["remotePath"];
    body._secret = map["secret"];
    return body;
  }
}