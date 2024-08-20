import 'dart:core';
import 'package:flutter/services.dart';

import '../internal/inner_headers.dart';

///
/// The conversation class, indicating a one-to-one chat, a group chat, or a conversation chat. It contains the messages that are sent and received within the conversation.
///
/// The following code shows how to get the number of the unread messages from the conversation.
/// ```dart
///   // ConversationId can be the other party id, the group id, or the chat room id.
///   ChatConversation? con = await ChatClient.getInstance.chatManager.getConversation(conversationId);
///   int? unreadCount = con?.unreadCount;
/// ```
///
///
///
class ChatConversation {
  ChatConversation._private(
    this.id,
    this.type,
    this._ext,
    this.isChatThread,
    this.isPinned,
    this.pinnedTime,
  );

  /// @nodoc
  factory ChatConversation.fromJson(Map<String, dynamic> map) {
    Map<String, String>? ext = map["ext"]?.cast<String, String>();
    ChatConversation ret = ChatConversation._private(
      map["convId"],
      conversationTypeFromInt(map["type"]),
      ext,
      map["isThread"] ?? false,
      map["isPinned"] ?? false,
      map["pinnedTime"] ?? 0,
    );

    return ret;
  }

  /// @nodoc
  Map<String, dynamic> _toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["type"] = conversationTypeToInt(this.type);
    data["convId"] = this.id;
    data["isThread"] = this.isChatThread;
    return data;
  }

  ///
  /// The conversation ID.
  ///
  /// For one-to-one chat，the conversation ID is the username of the other party.
  /// For group chat, the conversation ID is the group ID, not the group name.
  /// For chat room, the conversation ID is the chat room ID, not the chat room name.
  /// For help desk, the conversation ID is the username of the other party.
  ///
  ///
  ///
  final String id;

  ///
  /// The conversation type.
  ///
  ///
  ///
  final ChatConversationType type;

  ///
  /// Is chat thread conversation.
  ///
  ///
  ///
  final bool isChatThread;

  ///
  /// Whether the conversation is pinned:
  /// - `true`: Yes;
  /// - `false`: No.
  ///
  ///
  ///
  final bool isPinned;

  ///
  ///  The UNIX timestamp when the conversation is pinned. The unit is millisecond. This value is `0` when the conversation is not pinned.
  ///
  ///
  ///
  final int pinnedTime;

  Map<String, String>? _ext;

  static const MethodChannel _emConversationChannel =
      const MethodChannel('com.chat.im/chat_conversation', JSONMethodCodec());

  ///
  /// The conversation extension attribute.
  ///
  /// This attribute is not available for thread conversations.
  ///
  ///
  Map<String, String>? get ext => _ext;

  ///
  /// Set the conversation extension attribute.
  ///
  /// This attribute is not available for thread conversations.
  ///
  ///
  Future<void> setExt(Map<String, String>? ext) async {
    Map req = this._toJson();
    req.putIfNotNull("ext", ext);
    Map result = await _emConversationChannel.invokeMethod(
        ChatMethodKeys.syncConversationExt, req);
    try {
      ChatError.hasErrorFromResult(result);
      _ext = ext;
    } on ChatError catch (e) {
      throw e;
    }
  }

  ///
  /// Gets the last message from the conversation.
  ///
  /// The operation does not change the unread message count.
  ///
  /// The SDK gets the latest message from the local memory first. If no message is found, the SDK loads the message from the local database and then puts it in the memory.
  ///
  /// **Return** The message instance.
  ///
  ///
  ///
  Future<ChatMessage?> latestMessage() async {
    Map req = this._toJson();
    Map result = await _emConversationChannel.invokeMethod(
        ChatMethodKeys.getLatestMessage, req);
    try {
      ChatError.hasErrorFromResult(result);
      if (result.containsKey(ChatMethodKeys.getLatestMessage)) {
        return ChatMessage.fromJson(result[ChatMethodKeys.getLatestMessage]);
      } else {
        return null;
      }
    } on ChatError catch (e) {
      throw e;
    }
  }

  ///
  /// Gets the latest message from the conversation.
  ///
  /// **Return** The message instance.
  ///
  ///
  ///
  Future<ChatMessage?> lastReceivedMessage() async {
    Map req = this._toJson();
    Map result = await _emConversationChannel.invokeMethod(
        ChatMethodKeys.getLatestMessageFromOthers, req);
    try {
      ChatError.hasErrorFromResult(result);
      if (result.containsKey(ChatMethodKeys.getLatestMessageFromOthers)) {
        return ChatMessage.fromJson(
            result[ChatMethodKeys.getLatestMessageFromOthers]);
      } else {
        return null;
      }
    } on ChatError catch (e) {
      throw e;
    }
  }

  ///
  /// Gets the unread message count of the conversation.
  ///
  /// **Return** The unread message count of the conversation.
  ///
  /// **Throws** A description of the exception. See [ChatError].
  ///
  ///
  ///
  Future<int> unreadCount() async {
    Map req = this._toJson();
    Map result = await _emConversationChannel.invokeMethod(
        ChatMethodKeys.getUnreadMsgCount, req);
    try {
      ChatError.hasErrorFromResult(result);
      if (result.containsKey(ChatMethodKeys.getUnreadMsgCount)) {
        return result[ChatMethodKeys.getUnreadMsgCount];
      } else {
        return 0;
      }
    } on ChatError catch (e) {
      throw e;
    }
  }

  ///
  /// Marks a message as read.
  ///
  /// Param [messageId] The message ID.
  ///
  /// **Throws** A description of the exception. See [ChatError].
  ///
  ///
  ///
  Future<void> markMessageAsRead(String messageId) async {
    Map req = this._toJson();
    req['msg_id'] = messageId;
    Map result = await _emConversationChannel.invokeMethod(
        ChatMethodKeys.markMessageAsRead, req);
    try {
      ChatError.hasErrorFromResult(result);
    } on ChatError catch (e) {
      throw e;
    }
  }

  ///
  /// Marks all messages as read.
  ///
  ///
  ///
  Future<void> markAllMessagesAsRead() async {
    Map result = await _emConversationChannel.invokeMethod(
        ChatMethodKeys.markAllMessagesAsRead, this._toJson());
    try {
      ChatError.hasErrorFromResult(result);
    } on ChatError catch (e) {
      throw e;
    }
  }

  ///
  /// Inserts a message to a conversation in the local database and the SDK will automatically update the last message.
  ///
  /// Make sure you set the conversation ID as that of the conversation where you want to insert the message.
  ///
  /// Param [message] The message instance.
  ///
  /// **Throws** A description of the exception. See [ChatError].
  ///
  ///
  ///
  Future<void> insertMessage(ChatMessage message) async {
    Map req = this._toJson();
    req['msg'] = message.toJson();
    Map result = await _emConversationChannel.invokeMethod(
        ChatMethodKeys.insertMessage, req);
    try {
      ChatError.hasErrorFromResult(result);
    } on ChatError catch (e) {
      throw e;
    }
  }

  ///
  /// Inserts a message to the end of a conversation in the local database.
  ///
  /// Make sure you set the conversation ID as that of the conversation where you want to insert the message.
  ///
  /// Param [message] The message instance.
  ///
  /// **Throws** A description of the exception. See [ChatError].
  ///
  ///
  ///
  Future<void> appendMessage(ChatMessage message) async {
    Map req = this._toJson();
    req['msg'] = message.toJson();
    Map result = await _emConversationChannel.invokeMethod(
        ChatMethodKeys.appendMessage, req);
    try {
      ChatError.hasErrorFromResult(result);
    } on ChatError catch (e) {
      throw e;
    }
  }

  ///
  /// Updates a message in the local database.
  ///
  /// The latestMessage of the conversation and other properties will be updated accordingly. The message ID of the message, however, remains the same.
  ///
  /// Param [message] The message to be updated.
  ///
  /// **Throws** A description of the exception. See [ChatError].
  ///
  ///
  ///
  Future<void> updateMessage(ChatMessage message) async {
    Map req = this._toJson();
    req['msg'] = message.toJson();
    Map result = await _emConversationChannel.invokeMethod(
        ChatMethodKeys.updateConversationMessage, req);
    ChatError.hasErrorFromResult(result);
    try {
      ChatError.hasErrorFromResult(result);
    } on ChatError catch (e) {
      throw e;
    }
  }

  ///
  /// Deletes a message in the local database.
  ///
  /// **Note**
  /// After this method is called, the message is only deleted both from the memory and the local database.
  ///
  /// Param [messageId] The ID of message to be deleted.
  ///
  /// **Throws** A description of the exception. See [ChatError].
  ///
  ///
  ///
  Future<void> deleteMessage(String messageId) async {
    Map req = this._toJson();
    req['msg_id'] = messageId;
    Map result = await _emConversationChannel.invokeMethod(
        ChatMethodKeys.removeMessage, req);
    try {
      ChatError.hasErrorFromResult(result);
    } on ChatError catch (e) {
      throw e;
    }
  }

  ///
  /// Deletes all the messages of the conversation from both the memory and local database.
  ///
  /// **Throws** A description of the exception. See [ChatError].
  ///
  ///
  ///
  Future<void> deleteAllMessages() async {
    Map result = await _emConversationChannel.invokeMethod(
        ChatMethodKeys.clearAllMessages, this._toJson());
    try {
      ChatError.hasErrorFromResult(result);
    } on ChatError catch (e) {
      throw e;
    }
  }

  ///
  /// Deletes messages sent or received in a certain period from the local database.
  ///
  /// Param [startTs] The starting UNIX timestamp for message deletion. The unit is millisecond.
  ///
  /// Param [endTs] The end UNIX timestamp for message deletion. The unit is millisecond.
  ///
  /// **Throws** A description of the exception. See [ChatError].
  ///
  ///
  ///
  ///
  Future<void> deleteMessagesWithTs(int startTs, int endTs) async {
    Map req = this._toJson();
    req['startTs'] = startTs;
    req['endTs'] = endTs;
    Map result = await _emConversationChannel.invokeMethod(
        ChatMethodKeys.deleteMessagesWithTs, req);
    try {
      ChatError.hasErrorFromResult(result);
    } on ChatError catch (e) {
      throw e;
    }
  }

  ///
  /// Gets the message with a specific message ID.
  ///
  /// If the message is already loaded into the memory cache, the message will be directly returned; otherwise, the message will be loaded from the local database and loaded in the memory.
  ///
  /// Param [messageId] The message ID.
  ///
  /// **Return** The message instance.
  ///
  /// **Throws** A description of the exception. See [ChatError].
  ///
  ///
  ///
  Future<ChatMessage?> loadMessage(String messageId) async {
    Map req = this._toJson();
    req['msg_id'] = messageId;
    Map result = await _emConversationChannel.invokeMethod(
        ChatMethodKeys.loadMsgWithId, req);
    try {
      ChatError.hasErrorFromResult(result);
      if (result[ChatMethodKeys.loadMsgWithId] != null) {
        return ChatMessage.fromJson(result[ChatMethodKeys.loadMsgWithId]);
      } else {
        return null;
      }
    } on ChatError catch (e) {
      throw e;
    }
  }

  ///
  /// Retrieves messages from the database according to the following parameters: the message type, the Unix timestamp, max count, sender.
  ///
  /// **Note**
  /// Be cautious about the memory usage when the maxCount is large.
  ///
  /// Param [type] The message type, including TXT, VOICE, IMAGE, and so on.
  ///
  /// Param [timestamp] The Unix timestamp for the search.
  ///
  /// Param [count] The max number of messages to search.
  ///
  /// Param [sender] The sender of the message. The param can also be used to search in group chat or chat room.
  ///
  /// Param [direction]  The direction in which the message is loaded: [ChatSearchDirection].
  /// - `ChatSearchDirection.Up`: Messages are retrieved in the reverse chronological order of when the server received messages.
  /// - `ChatSearchDirection.Down`: Messages are retrieved in the chronological order of when the server received messages.
  ///
  /// **Return** The message list.
  ///
  /// **Throws** A description of the exception. See [ChatError].
  ///
  ///
  ///
  Future<List<ChatMessage>> loadMessagesWithMsgType({
    required MessageType type,
    int timestamp = -1,
    int count = 20,
    String? sender,
    ChatSearchDirection direction = ChatSearchDirection.Up,
  }) async {
    Map req = this._toJson();
    req['msgType'] = messageTypeToTypeStr(type);
    req['timestamp'] = timestamp;
    req['count'] = count;
    req['direction'] = direction == ChatSearchDirection.Up ? "up" : "down";
    req.putIfNotNull("sender", sender);
    Map result = await _emConversationChannel.invokeMethod(
        ChatMethodKeys.loadMsgWithMsgType, req);
    try {
      ChatError.hasErrorFromResult(result);
      List<ChatMessage> list = [];
      result[ChatMethodKeys.loadMsgWithMsgType]?.forEach((element) {
        list.add(ChatMessage.fromJson(element));
      });
      return list;
    } on ChatError catch (e) {
      throw e;
    }
  }

  ///
  /// Loads multiple messages from the local database.
  ///
  /// Loads messages from the local database before the specified message.
  ///
  /// The loaded messages will also join the existing messages of the conversation stored in the memory.
  ///
  /// Param [startMsgId] The starting message ID. Message loaded in the memory before this message ID will be loaded. If the `startMsgId` is set as "" or null, the SDK will first load the latest messages in the database.
  ///
  /// Param [loadCount] The number of messages per page.
  ///
  /// Param [direction]  The direction in which the message is loaded: ChatSearchDirection.
  /// - `ChatSearchDirection.Up`: Messages are retrieved in the reverse chronological order of when the server received messages.
  /// - `ChatSearchDirection.Down`: Messages are retrieved in the chronological order of when the server received messages.
  ///
  /// **Return** The message list.
  ///
  /// **Throws** A description of the exception. See [ChatError].
  ///
  ///
  ///
  Future<List<ChatMessage>> loadMessages({
    String startMsgId = '',
    int loadCount = 20,
    ChatSearchDirection direction = ChatSearchDirection.Up,
  }) async {
    Map req = this._toJson();
    req["startId"] = startMsgId;
    req['count'] = loadCount;
    req['direction'] = direction == ChatSearchDirection.Up ? "up" : "down";

    Map<String, dynamic> result = await _emConversationChannel.invokeMethod(
        ChatMethodKeys.loadMsgWithStartId, req);

    try {
      ChatError.hasErrorFromResult(result);
      List<ChatMessage> msgList = [];
      result[ChatMethodKeys.loadMsgWithStartId]?.forEach((element) {
        msgList.add(ChatMessage.fromJson(element));
      });
      return msgList;
    } on ChatError catch (e) {
      throw e;
    }
  }

  ///
  /// Loads messages from the local database by the following parameters: keywords, timestamp, max count, sender, search direction.
  ///
  /// **Note** Pay attention to the memory usage when the maxCount is large.
  ///
  /// Param [keywords] The keywords in message.
  ///
  /// Param [sender] The message sender. The param can also be used to search in group chat.
  ///
  /// Param [timestamp] The timestamp for search.
  ///
  /// Param [count] The maximum number of messages to search.
  ///
  /// Param [direction] The direction in which the message is loaded: ChatSearchDirection.
  /// `ChatSearchDirection.Up`: Gets the messages loaded before the timestamp of the specified message ID.
  /// `ChatSearchDirection.Down`: Gets the messages loaded after the timestamp of the specified message ID.
  ///
  /// **Returns** The list of retrieved messages.
  ///
  /// **Throws** A description of the exception. See [ChatError].
  ///
  ///
  ///
  Future<List<ChatMessage>> loadMessagesWithKeyword(
    String keywords, {
    String? sender,
    int timestamp = -1,
    int count = 20,
    ChatSearchDirection direction = ChatSearchDirection.Up,
  }) async {
    Map req = this._toJson();
    req["keywords"] = keywords;
    req['count'] = count;
    req['timestamp'] = timestamp;
    req['direction'] = direction == ChatSearchDirection.Up ? "up" : "down";
    req.putIfNotNull("sender", sender);

    Map<String, dynamic> result = await _emConversationChannel.invokeMethod(
        ChatMethodKeys.loadMsgWithKeywords, req);

    try {
      ChatError.hasErrorFromResult(result);
      List<ChatMessage> msgList = [];
      result[ChatMethodKeys.loadMsgWithKeywords]?.forEach((element) {
        msgList.add(ChatMessage.fromJson(element));
      });
      return msgList;
    } on ChatError catch (e) {
      throw e;
    }
  }

  ///
  /// Loads messages from the local database according the following parameters: start timestamp, end timestamp, count.
  ///
  /// **Note** Pay attention to the memory usage when the maxCount is large.
  ///
  ///  Param [startTime] The starting Unix timestamp for search.
  ///
  ///  Param [endTime] The ending Unix timestamp for search.
  ///
  ///  Param [count] The maximum number of message to retrieve.
  ///
  /// **Returns** The list of searched messages.
  ///
  /// **Throws** A description of the exception. See [ChatError].
  ///
  ///
  ///
  Future<List<ChatMessage>> loadMessagesFromTime({
    required int startTime,
    required int endTime,
    int count = 20,
  }) async {
    Map req = this._toJson();
    req["startTime"] = startTime;
    req['endTime'] = endTime;
    req['count'] = count;

    Map<String, dynamic> result = await _emConversationChannel.invokeMethod(
        ChatMethodKeys.loadMsgWithTime, req);

    try {
      ChatError.hasErrorFromResult(result);
      List<ChatMessage> msgList = [];
      result[ChatMethodKeys.loadMsgWithTime]?.forEach((element) {
        msgList.add(ChatMessage.fromJson(element));
      });
      return msgList;
    } on ChatError catch (e) {
      throw e;
    }
  }

  ///
  /// Message count
  ///
  ///
  ///
  Future<int> messagesCount() async {
    Map req = this._toJson();
    Map<String, dynamic> result = await _emConversationChannel.invokeMethod(
      ChatMethodKeys.messageCount,
      req,
    );

    try {
      ChatError.hasErrorFromResult(result);
      int count = result[ChatMethodKeys.messageCount];
      return count;
    } on ChatError catch (e) {
      throw e;
    }
  }
}
