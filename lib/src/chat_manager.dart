// ignore_for_file: deprecated_member_use_from_same_package

import "dart:async";

import 'package:flutter/services.dart';
import 'package:agora_chat_sdk/agora_chat_sdk.dart';
import 'internal/inner_headers.dart';

///
/// The chat manager class, responsible for sending and receiving messages, loading and deleting conversations, and downloading attachments.
///
/// The sample code for sending a text message:
///
/// ```dart
///    ChatMessage msg = ChatMessage.createTxtSendMessage(
///        username: toChatUsername, content: content);
///    await ChatClient.getInstance.chatManager.sendMessage(msg);
/// ```
///
///
///
class ChatManager {
  final Map<String, ChatEventHandler> _eventHandlesMap = {};

  /// @nodoc
  ChatManager() {
    ChatChannel.setMethodCallHandler((MethodCall call) async {
      if (call.method == ChatMethodKeys.onMessagesReceived) {
        return _onMessagesReceived(call.arguments);
      } else if (call.method == ChatMethodKeys.onCmdMessagesReceived) {
        return _onCmdMessagesReceived(call.arguments);
      } else if (call.method == ChatMethodKeys.onMessagesRead) {
        return _onMessagesRead(call.arguments);
      } else if (call.method == ChatMethodKeys.onGroupMessageRead) {
        return _onGroupMessageRead(call.arguments);
      } else if (call.method ==
          ChatMethodKeys.onReadAckForGroupMessageUpdated) {
        return _onReadAckForGroupMessageUpdated(call.arguments);
      } else if (call.method == ChatMethodKeys.onMessagesDelivered) {
        return _onMessagesDelivered(call.arguments);
      } else if (call.method == ChatMethodKeys.onMessagesRecalled) {
        return _onMessagesRecalled(call.arguments);
      } else if (call.method == ChatMethodKeys.onConversationUpdate) {
        return _onConversationsUpdate(call.arguments);
      } else if (call.method == ChatMethodKeys.onConversationHasRead) {
        return _onConversationHasRead(call.arguments);
      } else if (call.method == ChatMethodKeys.onMessageReactionDidChange) {
        return _messageReactionDidChange(call.arguments);
      } else if (call.method == ChatMethodKeys.onMessageContentChanged) {
        return _onMessageContentChanged(call.arguments);
      }
      return null;
    });
  }

  ///
  /// Adds the chat event handler. After calling this method, you can handle for chat event when they arrive.
  ///
  /// Param [identifier] The custom handler identifier, is used to find the corresponding handler.
  ///
  /// Param [handler] The handler for chat event. See [ChatEventHandler].
  ///
  ///
  ///
  void addEventHandler(
    String identifier,
    ChatEventHandler handler,
  ) {
    _eventHandlesMap[identifier] = handler;
  }

  ///
  /// Remove the chat event handler.
  ///
  /// Param [identifier] The custom handler identifier.
  ///
  ///
  ///
  void removeEventHandler(String identifier) {
    _eventHandlesMap.remove(identifier);
  }

  ///
  /// Get the chat event handler.
  ///
  /// Param [identifier] The custom handler identifier.
  ///
  /// **Return** The chat event handler.
  ///
  ///
  ///
  ChatEventHandler? getEventHandler(String identifier) {
    return _eventHandlesMap[identifier];
  }

  ///
  /// Clear all chat event handlers.
  ///
  ///
  ///
  void clearEventHandlers() {
    _eventHandlesMap.clear();
  }

  ///
  /// Sends a message.
  ///
  /// **Note**
  /// For attachment messages such as voice, image, or video messages, the SDK automatically uploads the attachment.
  /// You can set whether to upload the attachment to the chat sever using [ChatOptions.serverTransfer].
  ///
  /// To listen for the status of sending messages, call [ChatManager.addMessageEvent].
  ///
  /// Param [message] The message object to be sent: [ChatMessage].
  ///
  /// **Throws** A description of the exception. See [ChatError].
  ///
  ///
  ///
  Future<ChatMessage> sendMessage(ChatMessage message) async {
    message.status = MessageStatus.PROGRESS;
    Map result = await ChatChannel.invokeMethod(
        ChatMethodKeys.sendMessage, message.toJson());
    try {
      ChatError.hasErrorFromResult(result);
      ChatMessage msg =
          ChatMessage.fromJson(result[ChatMethodKeys.sendMessage]);
      message.from = msg.from;
      message.to = msg.to;
      message.status = msg.status;
      return message;
    } on ChatError catch (e) {
      throw e;
    }
  }

  ///
  /// Resends a message.
  ///
  /// Param [message] The message object to be resent: [ChatMessage].
  ///
  ///
  ///
  Future<ChatMessage> resendMessage(ChatMessage message) async {
    message.status = MessageStatus.PROGRESS;
    Map result = await ChatChannel.invokeMethod(
        ChatMethodKeys.resendMessage, message.toJson());
    try {
      ChatError.hasErrorFromResult(result);
      ChatMessage msg =
          ChatMessage.fromJson(result[ChatMethodKeys.resendMessage]);
      message.from = msg.from;
      message.to = msg.to;
      message.status = msg.status;
      return message;
    } on ChatError catch (e) {
      throw e;
    }
  }

  ///
  /// Sends the read receipt to the server.
  ///
  /// This method applies to one-to-one chats only.
  ///
  /// **Warning**
  /// This method only takes effect if you set [ChatOptions.requireAck] as `true`.
  ///
  /// **Note**
  /// To send the group message read receipt, call [sendGroupMessageReadAck].
  ///
  /// We recommend that you call [sendConversationReadAck] when entering a chat page, and call this method to reduce the number of method calls.
  ///
  /// Param [message] The message body: [ChatMessage].
  ///
  /// **Throws** A description of the exception. See [ChatError].
  ///
  ///
  ///
  Future<bool> sendMessageReadAck(ChatMessage message) async {
    Map req = {"to": message.from, "msg_id": message.msgId};
    Map result =
        await ChatChannel.invokeMethod(ChatMethodKeys.ackMessageRead, req);
    try {
      ChatError.hasErrorFromResult(result);
      return result.boolValue(ChatMethodKeys.ackMessageRead);
    } on ChatError catch (e) {
      throw e;
    }
  }

  ///
  /// Sends the group message receipt to the server.
  ///
  /// You can call the method only after setting the following method: [ChatOptions.requireAck] and [ChatMessage.needGroupAck].
  ///
  /// **Note**
  /// - This method takes effect only after you set [ChatOptions.requireAck] and [ChatMessage.needGroupAck] as `true`.
  /// - This method applies to group messages only. To send a one-to-one chat message receipt, call [sendMessageReadAck]; to send a conversation receipt, call [sendConversationReadAck].
  ///
  ///
  /// Param [msgId] The message ID.
  ///
  /// Param [groupId] The group ID.
  ///
  /// Param [content] The extension information, which is a custom keyword that specifies a custom action or command.
  ///
  /// **Throws** A description of the exception. See [ChatError].
  ///
  ///
  ///
  Future<void> sendGroupMessageReadAck(
    String msgId,
    String groupId, {
    String? content,
  }) async {
    Map req = {
      "msg_id": msgId,
      "group_id": groupId,
    };
    req.putIfNotNull("content", content);

    Map result =
        await ChatChannel.invokeMethod(ChatMethodKeys.ackGroupMessageRead, req);
    try {
      ChatError.hasErrorFromResult(result);
    } on ChatError catch (e) {
      throw e;
    }
  }

  ///
  /// Sends the conversation read receipt to the server. This method is only for one-to-one chat conversations.
  ///
  /// This method informs the server to set the unread message count of the conversation to 0. In multi-device scenarios, all the devices receive the [ChatEventHandler.onConversationRead] callback.
  ///
  /// **Note**
  /// This method applies to one-to-one chat conversations only. To send a group message read receipt, call [sendGroupMessageReadAck].
  ///
  /// Param [conversationId] The conversation ID.
  ///
  /// **Throws** A description of the exception. See [ChatError].
  ///
  ///
  ///
  Future<bool> sendConversationReadAck(String conversationId) async {
    Map req = {"convId": conversationId};
    Map result =
        await ChatChannel.invokeMethod(ChatMethodKeys.ackConversationRead, req);
    try {
      ChatError.hasErrorFromResult(result);
      return result.boolValue(ChatMethodKeys.ackConversationRead);
    } on ChatError catch (e) {
      throw e;
    }
  }

  ///
  /// Recalls the sent message.
  ///
  /// Param [messageId] The message ID.
  ///
  /// **Throws** A description of the exception. See [ChatError].
  ///
  ///
  ///
  Future<void> recallMessage(String messageId) async {
    Map req = {"msg_id": messageId};
    Map result =
        await ChatChannel.invokeMethod(ChatMethodKeys.recallMessage, req);
    try {
      ChatError.hasErrorFromResult(result);
    } on ChatError catch (e) {
      throw e;
    }
  }

  ///
  /// Loads a message from the local database by message ID.
  ///
  /// Param [messageId] The message ID.
  ///
  /// **Return** The message object specified by the message ID. Returns null if the message does not exist.
  ///
  /// **Throws** A description of the exception. See [ChatError].
  ///
  ///
  ///
  Future<ChatMessage?> loadMessage(String messageId) async {
    Map req = {"msg_id": messageId};
    Map<String, dynamic> result =
        await ChatChannel.invokeMethod(ChatMethodKeys.getMessage, req);
    try {
      ChatError.hasErrorFromResult(result);
      if (result.containsKey(ChatMethodKeys.getMessage)) {
        return ChatMessage.fromJson(result[ChatMethodKeys.getMessage]);
      } else {
        return null;
      }
    } on ChatError catch (e) {
      throw e;
    }
  }

  ///
  /// Gets the conversation by conversation ID and conversation type.
  ///
  /// Param [conversationId] The conversation ID.
  ///
  /// Param [type] The conversation type: [ChatConversationType].
  ///
  /// Param [createIfNeed] Whether to create a conversation is the specified conversation is not found:
  /// - `true`: Yes.
  /// - `false`: No.
  ///
  /// **Return** The conversation object found according to the ID and type. Returns null if the conversation is not found.
  ///
  /// **Throws** A description of the exception. See [ChatError].
  ///
  ///
  ///
  Future<ChatConversation?> getConversation(
    String conversationId, {
    ChatConversationType type = ChatConversationType.Chat,
    bool createIfNeed = true,
  }) async {
    Map req = {
      "convId": conversationId,
      "type": conversationTypeToInt(type),
      "createIfNeed": createIfNeed
    };
    Map result =
        await ChatChannel.invokeMethod(ChatMethodKeys.getConversation, req);
    try {
      ChatError.hasErrorFromResult(result);
      ChatConversation? ret;
      if (result[ChatMethodKeys.getConversation] != null) {
        ret = ChatConversation.fromJson(result[ChatMethodKeys.getConversation]);
      }
      return ret;
    } on ChatError catch (e) {
      throw e;
    }
  }

  ///
  /// Gets the thread conversation by thread ID.
  ///
  /// Param [threadId] The thread ID.
  ///
  /// **Return** The conversation object.
  ///
  /// **Throws** A description of the exception. See [ChatError].
  ///
  ///
  ///
  Future<ChatConversation?> getThreadConversation(String threadId) async {
    Map result = await ChatChannel.invokeMethod(
      ChatMethodKeys.getThreadConversation,
      {"convId": threadId},
    );

    try {
      ChatConversation? ret;
      ChatError.hasErrorFromResult(result);
      if (result[ChatMethodKeys.getThreadConversation] != null) {
        ret = ChatConversation.fromJson(
            result[ChatMethodKeys.getThreadConversation]);
      }
      return ret;
    } on ChatError catch (e) {
      throw e;
    }
  }

  ///
  /// Marks all messages as read.
  ///
  /// This method is for the local conversations only.
  ///
  /// **Throws** A description of the exception. See [ChatError].
  ///
  ///
  ///
  Future<void> markAllConversationsAsRead() async {
    Map result =
        await ChatChannel.invokeMethod(ChatMethodKeys.markAllChatMsgAsRead);
    try {
      ChatError.hasErrorFromResult(result);
    } on ChatError catch (e) {
      throw e;
    }
  }

  ///
  /// Gets the count of the unread messages.
  ///
  /// **Return** The count of the unread messages.
  ///
  /// **Throws** A description of the exception. See [ChatError].
  ///
  ///
  ///
  Future<int> getUnreadMessageCount() async {
    Map result =
        await ChatChannel.invokeMethod(ChatMethodKeys.getUnreadMessageCount);
    try {
      int ret = 0;
      ChatError.hasErrorFromResult(result);
      if (result.containsKey(ChatMethodKeys.getUnreadMessageCount)) {
        ret = result[ChatMethodKeys.getUnreadMessageCount] as int;
      }
      return ret;
    } on ChatError catch (e) {
      throw e;
    }
  }

  ///
  /// Updates the local message.
  ///
  /// The message will be updated both in the cache and local database.
  ///
  /// **Throws** A description of the exception. See [ChatError].
  ///
  ///
  ///
  Future<void> updateMessage(ChatMessage message) async {
    Map req = {"message": message.toJson()};
    Map result =
        await ChatChannel.invokeMethod(ChatMethodKeys.updateChatMessage, req);
    try {
      ChatError.hasErrorFromResult(result);
    } on ChatError catch (e) {
      throw e;
    }
  }

  ///
  /// Imports messages to the local database.
  ///
  /// Before importing, ensure that the sender or receiver of the message is the current user.
  ///
  /// For each method call, we recommends to import less than 1,000 messages.
  ///
  /// Param [messages] The message list.
  ///
  /// **Throws** A description of the exception. See [ChatError].
  ///
  ///
  ///
  Future<void> importMessages(List<ChatMessage> messages) async {
    List<Map> list = [];
    messages.forEach((element) {
      list.add(element.toJson());
    });
    Map req = {"messages": list};
    Map result =
        await ChatChannel.invokeMethod(ChatMethodKeys.importMessages, req);
    try {
      ChatError.hasErrorFromResult(result);
    } on ChatError catch (e) {
      throw e;
    }
  }

  ///
  /// Downloads the attachment files from the server.
  ///
  /// You can call the method again if the attachment download fails.
  ///
  /// Param [message] The message with the attachment that is to be downloaded.
  ///
  /// **Throws** A description of the exception. See [ChatError].
  ///
  ///
  ///
  Future<void> downloadAttachment(ChatMessage message) async {
    Map result = await ChatChannel.invokeMethod(
        ChatMethodKeys.downloadAttachment, {"message": message.toJson()});
    try {
      ChatError.hasErrorFromResult(result);
    } on ChatError catch (e) {
      throw e;
    }
  }

  ///
  /// Downloads the thumbnail if the message has not been downloaded before or if the download fails.
  ///
  /// Param [message] The message object.
  ///
  /// **Throws** A description of the exception. See [ChatError].
  ///
  ///
  ///
  Future<void> downloadThumbnail(ChatMessage message) async {
    Map result = await ChatChannel.invokeMethod(
        ChatMethodKeys.downloadThumbnail, {"message": message.toJson()});
    try {
      ChatError.hasErrorFromResult(result);
    } on ChatError catch (e) {
      throw e;
    }
  }

  ///
  /// Gets all conversations from the local database.
  ///
  /// Conversations will be first loaded from the cache. If no conversation is found, the SDK loads from the local database.
  ///
  /// **Return** All the conversations from the cache or local database.
  ///
  /// **Throws** A description of the exception. See [ChatError].
  ///
  ///
  ///
  Future<List<ChatConversation>> loadAllConversations() async {
    Map result =
        await ChatChannel.invokeMethod(ChatMethodKeys.loadAllConversations);
    try {
      ChatError.hasErrorFromResult(result);
      List<ChatConversation> conversationList = [];
      result[ChatMethodKeys.loadAllConversations]?.forEach((element) {
        conversationList.add(ChatConversation.fromJson(element));
      });
      return conversationList;
    } on ChatError catch (e) {
      throw e;
    }
  }

  @Deprecated('Use [fetchConversation] instead')

  ///
  /// Gets the conversation list from the server.
  ///
  /// To use this function, you need to contact our business manager to activate it. After this function is activated, users can pull 10 conversations within 7 days by default (each conversation contains the latest historical message). If you want to adjust the number of conversations or time limit, please contact our business manager.
  ///
  /// **Return** The conversation list of the current user.
  ///
  /// **Throws** A description of the exception. See [ChatError].
  ///
  ///
  ///
  Future<List<ChatConversation>> getConversationsFromServer() async {
    Map result = await ChatChannel.invokeMethod(
        ChatMethodKeys.getConversationsFromServer);
    try {
      ChatError.hasErrorFromResult(result);
      List<ChatConversation> conversationList = [];
      result[ChatMethodKeys.getConversationsFromServer]?.forEach((element) {
        conversationList.add(ChatConversation.fromJson(element));
      });
      return conversationList;
    } on ChatError catch (e) {
      throw e;
    }
  }

  @Deprecated('Use [fetchConversation] instead')

  ///
  /// Gets the list of conversations from the server.
  ///
  /// Param [pageNum] The current page number.
  ///
  /// Param [pageSize] The number of conversations to get on each page.
  ///
  /// **Return** The conversation list of the current user.
  ///
  /// **Throws** A description of the exception. See [ChatError].
  ///
  ///
  ///
  Future<List<ChatConversation>> fetchConversationListFromServer({
    int pageNum = 1,
    int pageSize = 20,
  }) async {
    Map request = {
      "pageNum": pageNum,
      "pageSize": pageSize,
    };
    Map result = await ChatChannel.invokeMethod(
      ChatMethodKeys.fetchConversationsFromServerWithPage,
      request,
    );
    try {
      ChatError.hasErrorFromResult(result);
      List<ChatConversation> conversationList = [];
      result[ChatMethodKeys.fetchConversationsFromServerWithPage]
          ?.forEach((element) {
        conversationList.add(ChatConversation.fromJson(element));
      });
      return conversationList;
    } on ChatError catch (e) {
      throw e;
    }
  }

  ///
  /// Get the list of conversations from the server with pagination.
  ///
  /// The SDK retrieves the list of conversations in the reverse chronological order of their active time (the timestamp of the last message).
  /// If there is no message in the conversation, the SDK retrieves the list of conversations in the reverse chronological order of their creation time.
  ///
  /// Param [cursor] The position from which to start getting data. The SDK retrieves conversations from the latest active one if this parameter is not set.
  ///
  /// Param [pageSize] The number of conversations that you expect to get on each page. The value range is [1,50].
  ///
  /// **Return** The conversation list of the current user.
  ///
  /// **Throws** A description of the exception. See [ChatError].
  ///
  ///
  ///
  Future<ChatCursorResult<ChatConversation>> fetchConversation({
    String? cursor,
    int pageSize = 20,
  }) async {
    Map map = {
      "pageSize": pageSize,
    };
    map.putIfNotNull('cursor', cursor);
    Map result = await ChatChannel.invokeMethod(
      ChatMethodKeys.getConversationsFromServerWithCursor,
      map,
    );
    try {
      ChatError.hasErrorFromResult(result);
      return ChatCursorResult.fromJson(
          result[ChatMethodKeys.getConversationsFromServerWithCursor],
          dataItemCallback: (map) {
        return ChatConversation.fromJson(map);
      });
    } on ChatError catch (e) {
      throw e;
    }
  }

  ///
  /// Unidirectionally removes historical message by message ID from the server.
  ///
  /// Param [conversationId] The conversation ID.
  ///
  /// Param [type] The conversation type.
  ///
  /// Param [msgIds] The list of IDs of messages to be removed.
  ///
  ///
  ///
  Future<void> deleteRemoteMessagesWithIds(
      {required String conversationId,
      required ChatConversationType type,
      required List<String> msgIds}) async {
    Map request = {
      "convId": conversationId,
      "type": type.index,
      "msgIds": msgIds,
    };
    Map result = await ChatChannel.invokeMethod(
      ChatMethodKeys.removeMessagesFromServerWithMsgIds,
      request,
    );
    try {
      ChatError.hasErrorFromResult(result);
    } on ChatError catch (e) {
      throw e;
    }
  }

  ///
  /// Unidirectionally removes historical message by timestamp from the server.
  ///
  /// Param [conversationId] The conversation ID.
  ///
  /// Param [type] The conversation type.
  ///
  /// Param [timestamp] The UNIX timestamp in millisecond. Messages with a timestamp smaller than the specified one will be removed.
  ///
  ///
  ///
  Future<void> deleteRemoteMessagesBefore(
      {required String conversationId,
      required ChatConversationType type,
      required int timestamp}) async {
    Map request = {
      "convId": conversationId,
      "type": type.index,
      "timestamp": timestamp,
    };
    Map result = await ChatChannel.invokeMethod(
      ChatMethodKeys.removeMessagesFromServerWithTs,
      request,
    );
    try {
      ChatError.hasErrorFromResult(result);
    } on ChatError catch (e) {
      throw e;
    }
  }

  ///
  /// Deletes a conversation and its related messages from the local database.
  ///
  /// If you set [deleteMessages] to `true`, the local historical messages are deleted when the conversation is deleted.
  ///
  /// Param [conversationId] The conversation ID.
  ///
  /// Param [deleteMessages] Whether to delete the historical messages when deleting the conversation.
  /// - `true`: (default) Yes.
  /// - `false`: No.
  ///
  /// **Return** Whether the conversation is successfully deleted.
  /// - `true`: Yes;
  /// - `false`: No.
  ///
  /// **Throws** A description of the exception. See [ChatError].
  ///
  ///
  ///
  Future<bool> deleteConversation(
    String conversationId, {
    bool deleteMessages = true,
  }) async {
    Map req = {"convId": conversationId, "deleteMessages": deleteMessages};
    Map result =
        await ChatChannel.invokeMethod(ChatMethodKeys.deleteConversation, req);
    try {
      ChatError.hasErrorFromResult(result);
      return result.boolValue(ChatMethodKeys.deleteConversation);
    } on ChatError catch (e) {
      throw e;
    }
  }

  ///
  /// Gets historical messages of the conversation from the server with pagination.
  ///
  /// Param [conversationId] The conversation ID.
  ///
  /// Param [type] The conversation type. See [ChatConversationType].
  ///
  /// Param [pageSize] The number of messages per page.
  ///
  /// Param [direction] The message search direction. See [ChatSearchDirection].
  ///
  /// Param [startMsgId] The ID of the message from which you start to get the historical messages. If `null` is passed, the SDK gets messages in the reverse chronological order.
  ///
  /// **Return** The obtained messages and the cursor for the next query.
  ///
  /// **Throws** A description of the exception. See [ChatError].
  ///
  ///
  ///
  Future<ChatCursorResult<ChatMessage>> fetchHistoryMessages({
    required String conversationId,
    ChatConversationType type = ChatConversationType.Chat,
    int pageSize = 20,
    ChatSearchDirection direction = ChatSearchDirection.Up,
    String startMsgId = '',
  }) async {
    Map req = Map();
    req['convId'] = conversationId;
    req['type'] = conversationTypeToInt(type);
    req['pageSize'] = pageSize;
    req['startMsgId'] = startMsgId;
    req['direction'] = direction.index;
    Map result = await ChatChannel.invokeMethod(
        ChatMethodKeys.fetchHistoryMessages, req);
    try {
      ChatError.hasErrorFromResult(result);
      return ChatCursorResult<ChatMessage>.fromJson(
          result[ChatMethodKeys.fetchHistoryMessages],
          dataItemCallback: (value) {
        return ChatMessage.fromJson(value);
      });
    } on ChatError catch (e) {
      throw e;
    }
  }

  ///
  /// Gets historical messages of a conversation from the server according to [FetchMessageOptions].
  ///
  /// Param [conversationId] The conversation ID, which is the user ID of the peer user for one-to-one chat, but the group ID for group chat.
  ///
  /// Param [type] The conversation type. You can set this parameter only to [ChatConversationType.Chat] or [ChatConversationType.GroupChat].
  ///
  /// Param [options] The parameter configuration class for pulling historical messages from the server. See [FetchMessageOptions].
  ///
  /// Param [cursor] The cursor position from which to start querying data.
  ///
  /// Param [pageSize] The number of messages that you expect to get on each page. The value range is [1,50].
  ///
  ///
  ///
  Future<ChatCursorResult<ChatMessage>> fetchHistoryMessagesByOption(
    String conversationId,
    ChatConversationType type, {
    FetchMessageOptions? options,
    String? cursor,
    int pageSize = 50,
  }) async {
    Map req = Map();
    req.putIfNotNull('convId', conversationId);
    req.putIfNotNull('type', conversationTypeToInt(type));
    req.putIfNotNull('pageSize', pageSize);
    req.putIfNotNull('cursor', cursor);
    req.putIfNotNull('options', options?.toJson());
    Map result = await ChatChannel.invokeMethod(
        ChatMethodKeys.fetchHistoryMessagesByOptions, req);
    try {
      ChatError.hasErrorFromResult(result);
      return ChatCursorResult<ChatMessage>.fromJson(
          result[ChatMethodKeys.fetchHistoryMessagesByOptions],
          dataItemCallback: (value) {
        return ChatMessage.fromJson(value);
      });
    } on ChatError catch (e) {
      throw e;
    }
  }

  ///
  /// Retrieves messages from the database according to the parameters.
  ///
  /// **Note**
  /// Pay attention to the memory usage when the maxCount is large. Currently, a maximum of 400 historical messages can be retrieved each time.
  ///
  /// Param [keywords] The keywords in message.
  ///
  /// Param [timestamp] The Unix timestamp for search, in milliseconds.
  ///
  /// Param [maxCount] The maximum number of messages to retrieve each time.
  ///
  /// Param [from] A user ID or group ID at which the retrieval is targeted. Usually, it is the conversation ID.
  ///
  /// **Return** The list of messages.
  ///
  /// **Throws** A description of the exception. See [ChatError].
  ///
  ///
  ///
  Future<List<ChatMessage>> searchMsgFromDB(
    String keywords, {
    int timestamp = -1,
    int maxCount = 20,
    String from = '',
    ChatSearchDirection direction = ChatSearchDirection.Up,
  }) async {
    Map req = Map();
    req['keywords'] = keywords;
    req['timestamp'] = timestamp;
    req['maxCount'] = maxCount;
    req['from'] = from;
    req['direction'] = direction == ChatSearchDirection.Up ? "up" : "down";

    Map result =
        await ChatChannel.invokeMethod(ChatMethodKeys.searchChatMsgFromDB, req);
    try {
      ChatError.hasErrorFromResult(result);
      List<ChatMessage> list = [];
      result[ChatMethodKeys.searchChatMsgFromDB]?.forEach((element) {
        list.add(ChatMessage.fromJson(element));
      });
      return list;
    } on ChatError catch (e) {
      throw e;
    }
  }

  ///
  /// Gets read receipts for group messages from the server with pagination.
  ///
  /// For how to send read receipts for group messages, see [sendConversationReadAck].
  ///
  /// Param [msgId] The message ID.
  ///
  /// Param [startAckId] The starting read receipt ID for query. If you set it as null, the SDK retrieves the read receipts in the in reverse chronological order.
  ///
  /// Param [pageSize] The number of read receipts per page.
  ///
  /// **Return** The list of obtained read receipts and the cursor for next query.
  ///
  /// **Throws** A description of the exception. See [ChatError].
  ///
  ///
  ///
  Future<ChatCursorResult<ChatGroupMessageAck>> fetchGroupAcks(
    String msgId,
    String groupId, {
    String? startAckId,
    int pageSize = 0,
  }) async {
    Map req = {"msg_id": msgId, "group_id": groupId};
    req["pageSize"] = pageSize;
    req.putIfNotNull("ack_id", startAckId);

    Map result =
        await ChatChannel.invokeMethod(ChatMethodKeys.asyncFetchGroupAcks, req);

    try {
      ChatError.hasErrorFromResult(result);
      ChatCursorResult<ChatGroupMessageAck> cursorResult =
          ChatCursorResult.fromJson(
        result[ChatMethodKeys.asyncFetchGroupAcks],
        dataItemCallback: (map) {
          return ChatGroupMessageAck.fromJson(map);
        },
      );

      return cursorResult;
    } on ChatError catch (e) {
      throw e;
    }
  }

  ///
  /// Deletes the specified conversation and the related historical messages from the server.
  ///
  /// Param [conversationId] The conversation ID.
  ///
  /// Param [conversationType] The conversation type. See  [ChatConversationType].
  ///
  /// Param [isDeleteMessage] Whether to delete the chat history when deleting the conversation.
  /// - `true`: (default) Yes.
  /// - `false`: No.
  ///
  ///
  /// **Throws** A description of the exception. See [ChatError].
  ///
  ///
  ///
  Future<void> deleteRemoteConversation(
    String conversationId, {
    ChatConversationType conversationType = ChatConversationType.Chat,
    bool isDeleteMessage = true,
  }) async {
    Map req = {};
    req["conversationId"] = conversationId;
    if (conversationType == ChatConversationType.Chat) {
      req["conversationType"] = 0;
    } else if (conversationType == ChatConversationType.GroupChat) {
      req["conversationType"] = 1;
    } else {
      req["conversationType"] = 2;
    }
    req["isDeleteRemoteMessage"] = isDeleteMessage;

    Map data = await ChatChannel.invokeMethod(
        ChatMethodKeys.deleteRemoteConversation, req);
    try {
      ChatError.hasErrorFromResult(data);
    } on ChatError catch (e) {
      throw e;
    }
  }

  ///
  /// Deletes messages with timestamp that is before the specified one.
  ///
  /// Param [timestamp]  The specified Unix timestamp(milliseconds).
  ///
  /// **Throws** A description of the exception. See [ChatError].
  ///
  ///
  ///
  Future<void> deleteMessagesBefore(int timestamp) async {
    Map result = await ChatChannel.invokeMethod(
        ChatMethodKeys.deleteMessagesBeforeTimestamp, {"timestamp": timestamp});
    try {
      ChatError.hasErrorFromResult(result);
    } on ChatError catch (e) {
      throw e;
    }
  }

  ///
  ///  Reports an inappropriate message.
  ///
  /// Param [messageId] The ID of the message to report.
  ///
  /// Param [tag] The tag of the inappropriate message. You need to type a custom tag, like `porn` or `ad`.
  ///
  /// Param [reason] The reporting reason. You need to type a specific reason.
  ///
  /// **Throws** A description of the exception. See [ChatError].
  ///
  ///
  ///
  Future<void> reportMessage({
    required String messageId,
    required String tag,
    required String reason,
  }) async {
    Map req = {"msgId": messageId, "tag": tag, "reason": reason};
    Map result =
        await ChatChannel.invokeMethod(ChatMethodKeys.reportMessage, req);
    try {
      ChatError.hasErrorFromResult(result);
    } on ChatError catch (e) {
      throw e;
    }
  }

  ///
  /// Adds a Reaction.
  ///
  /// Param [messageId] The message ID.
  ///
  /// Param [reaction] The Reaction content.
  ///
  /// **Throws** A description of the exception. See [ChatError].
  ///
  ///
  ///
  Future<void> addReaction({
    required String messageId,
    required String reaction,
  }) async {
    Map req = {"reaction": reaction, "msgId": messageId};
    Map result =
        await ChatChannel.invokeMethod(ChatMethodKeys.addReaction, req);
    try {
      ChatError.hasErrorFromResult(result);
    } on ChatError catch (e) {
      throw e;
    }
  }

  ///
  /// Deletes a Reaction.
  ///
  /// Param [messageId] The message ID.
  ///
  /// Param [reaction] The Reaction content.
  ///
  /// **Throws** A description of the exception. See [ChatError].
  ///
  ///
  ///
  Future<void> removeReaction({
    required String messageId,
    required String reaction,
  }) async {
    Map req = {"reaction": reaction, "msgId": messageId};
    Map result =
        await ChatChannel.invokeMethod(ChatMethodKeys.removeReaction, req);
    try {
      ChatError.hasErrorFromResult(result);
    } on ChatError catch (e) {
      throw e;
    }
  }

  ///
  /// Gets the list of Reactions.
  ///
  /// Param [messageIds] The message IDs.
  ///
  /// Param [chatType] The chat type. Only one-to-one chat [ChatType.Chat] and group chat [ChatType.GroupChat] are allowed.
  ///
  /// Param [groupId] The group ID. This parameter is valid only when the chat type is group chat.
  ///
  /// **Return** The Reaction list under the specified message ID（[ChatMessageReaction.userList] is the summary data, which only contains the information of the first three users）.
  ///
  /// **Throws** A description of the exception. See [ChatError].
  ///
  ///
  ///
  Future<Map<String, List<ChatMessageReaction>>> fetchReactionList({
    required List<String> messageIds,
    required ChatType chatType,
    String? groupId,
  }) async {
    Map req = {
      "msgIds": messageIds,
      "chatType": chatTypeToInt(chatType),
    };
    req.putIfNotNull("groupId", groupId);
    Map result = await ChatChannel.invokeMethod(
      ChatMethodKeys.fetchReactionList,
      req,
    );

    try {
      ChatError.hasErrorFromResult(result);
      Map<String, List<ChatMessageReaction>> ret = {};
      for (var info in result[ChatMethodKeys.fetchReactionList].entries) {
        List<ChatMessageReaction> reactions = [];
        for (var item in info.value) {
          reactions.add(ChatMessageReaction.fromJson(item));
        }
        ret[info.key] = reactions;
      }
      return ret;
    } on ChatError catch (e) {
      throw e;
    }
  }

  ///
  /// Gets the Reaction details.
  ///
  /// Param [messageId] The message ID.
  ///
  /// Param [reaction] The Reaction content.
  ///
  /// Param [cursor] The cursor position from which to get Reactions.
  ///
  /// Param [pageSize] The number of Reactions you expect to get on each page.
  ///
  /// **Return** The result callback, which contains the reaction list obtained from the server and the cursor for the next query. Returns null if all the data is fetched.
  ///
  /// **Throws** A description of the exception. See [ChatError].
  ///
  ///
  ///
  Future<ChatCursorResult<ChatMessageReaction>> fetchReactionDetail({
    required String messageId,
    required String reaction,
    String? cursor,
    int pageSize = 20,
  }) async {
    Map req = {
      "msgId": messageId,
      "reaction": reaction,
    };
    req.putIfNotNull("cursor", cursor);
    req.putIfNotNull("pageSize", pageSize);
    Map result =
        await ChatChannel.invokeMethod(ChatMethodKeys.fetchReactionDetail, req);

    try {
      ChatError.hasErrorFromResult(result);
      return ChatCursorResult<ChatMessageReaction>.fromJson(
          result[ChatMethodKeys.fetchReactionDetail],
          dataItemCallback: (value) {
        return ChatMessageReaction.fromJson(value);
      });
    } on ChatError catch (e) {
      throw e;
    }
  }

  ///
  /// Translates a text message.
  ///
  /// Param [msg] The message object for translation.
  ///
  /// Param [languages] The list of target language codes.
  ///
  /// **Return** The translated message.
  ///
  /// **Throws** A description of the exception. See [ChatError].
  ///
  ///
  ///
  Future<ChatMessage> translateMessage({
    required ChatMessage msg,
    required List<String> languages,
  }) async {
    Map req = {};
    req["message"] = msg.toJson();
    req["languages"] = languages;
    Map result =
        await ChatChannel.invokeMethod(ChatMethodKeys.translateMessage, req);
    try {
      ChatError.hasErrorFromResult(result);
      return ChatMessage.fromJson(result[ChatMethodKeys.translateMessage]);
    } on ChatError catch (e) {
      throw e;
    }
  }

  ///
  /// Gets all languages supported by the translation service.
  ///
  /// **Return** The supported languages.
  ///
  /// **Throws** A description of the exception. See [ChatError].
  ///
  ///
  ///
  Future<List<ChatTranslateLanguage>> fetchSupportedLanguages() async {
    Map result =
        await ChatChannel.invokeMethod(ChatMethodKeys.fetchSupportLanguages);
    try {
      ChatError.hasErrorFromResult(result);
      List<ChatTranslateLanguage> list = [];
      result[ChatMethodKeys.fetchSupportLanguages]?.forEach((element) {
        list.add(ChatTranslateLanguage.fromJson(element));
      });
      return list;
    } on ChatError catch (e) {
      throw e;
    }
  }

  ///
  /// Gets the list of pinned conversations from the server with pagination.
  ///
  /// The SDK returns the pinned conversations in the reverse chronological order of their pinning.
  ///
  /// Param [cursor] The position from which to start getting data. If this parameter is not set, the SDK retrieves conversations from the latest pinned one.
  ///
  /// Param [pageSize] The number of conversations that you expect to get on each page. The value range is [1,50].
  ///
  /// **Return** The pinned conversation list of the current user.
  ///
  /// **Throws** A description of the exception. See [ChatError].
  ///
  ///
  ///
  Future<ChatCursorResult<ChatConversation>> fetchPinnedConversations({
    String? cursor,
    int pageSize = 20,
  }) async {
    Map map = {
      "pageSize": pageSize,
    };
    map.putIfNotNull('cursor', cursor);
    Map result = await ChatChannel.invokeMethod(
      ChatMethodKeys.getPinnedConversationsFromServerWithCursor,
      map,
    );
    try {
      ChatError.hasErrorFromResult(result);
      return ChatCursorResult.fromJson(
          result[ChatMethodKeys.getPinnedConversationsFromServerWithCursor],
          dataItemCallback: (map) {
        return ChatConversation.fromJson(map);
      });
    } on ChatError catch (e) {
      throw e;
    }
  }

  ///
  /// Sets whether to pin a conversation.
  ///
  /// Param [conversationId] The conversation ID.
  ///
  /// Param [isPinned]  Whether to pin a conversation:
  /// - true: Pin the conversation.
  /// - false: Unpin the conversation.
  ///
  /// **Throws** A description of the exception. See [ChatError].
  ///
  ///
  ///
  Future<void> pinConversation(
      {required String conversationId, required bool isPinned}) async {
    Map map = {
      'convId': conversationId,
      'isPinned': isPinned,
    };

    Map result = await ChatChannel.invokeMethod(
      ChatMethodKeys.pinConversation,
      map,
    );
    try {
      ChatError.hasErrorFromResult(result);
    } on ChatError catch (e) {
      throw e;
    }
  }

  ///
  /// Modifies a message.
  ///
  /// After this method is called to modify a message, both the local message and the message on the server are modified.
  ///
  /// This method can only modify a text message in one-to-one chats or group chats, but not in chat rooms.
  ///
  /// Param [messageId] The ID of the message to modify.
  ///
  /// Param [msgBody]  The modified message body [ChatTextMessageBody].
  ///
  /// **Return** The modified message.
  ///
  /// **Throws** A description of the exception. See [ChatError].
  ///
  ///
  ///
  Future<ChatMessage> modifyMessage({
    required String messageId,
    required ChatTextMessageBody msgBody,
  }) async {
    Map map = {
      'msgId': messageId,
      'body': msgBody.toJson(),
    };

    Map result = await ChatChannel.invokeMethod(
      ChatMethodKeys.modifyMessage,
      map,
    );
    try {
      ChatError.hasErrorFromResult(result);
      return ChatMessage.fromJson(result[ChatMethodKeys.modifyMessage]);
    } on ChatError catch (e) {
      throw e;
    }
  }

  ///
  /// Gets the details of a combined message.
  ///
  /// Param [message] The combined message.
  ///
  /// **Return** The list of original messages included in the combined message.
  ///
  /// **Throws** A description of the exception. See [ChatError].
  ///
  ///
  ///
  Future<List<ChatMessage>> fetchCombineMessageDetail({
    required ChatMessage message,
  }) async {
    Map map = {
      'message': message.toJson(),
    };

    Map result = await ChatChannel.invokeMethod(
      ChatMethodKeys.downloadAndParseCombineMessage,
      map,
    );

    try {
      ChatError.hasErrorFromResult(result);
      List<ChatMessage> messages = [];
      List list = result[ChatMethodKeys.downloadAndParseCombineMessage];
      list.forEach((element) {
        messages.add(ChatMessage.fromJson(element));
      });
      return messages;
    } on ChatError catch (e) {
      throw e;
    }
  }

  ///
  /// Adds a message status listener.
  ///
  /// Param [identifier] The ID of the message status listener. The ID is required when you delete a message status listener.
  ///
  /// Param [event] The message status event.
  ///
  ///
  ///
  void addMessageEvent(String identifier, ChatMessageEvent event) {
    MessageCallBackManager.getInstance.addMessageEvent(identifier, event);
  }

  ///
  /// Removes a message status listener.
  ///
  /// Param [identifier] The ID of the message status listener. The ID is set when you add a message status listener.
  ///
  ///
  ///
  void removeMessageEvent(String identifier) {
    MessageCallBackManager.getInstance.removeMessageEvent(identifier);
  }

  ///
  /// Clears all message status listeners.
  ///
  ///
  ///
  void clearMessageEvent() {
    MessageCallBackManager.getInstance.clearAllMessageEvents();
  }

  Future<void> _onMessagesReceived(List messages) async {
    List<ChatMessage> messageList = [];
    for (var message in messages) {
      messageList.add(ChatMessage.fromJson(message));
    }

    for (var item in _eventHandlesMap.values) {
      item.onMessagesReceived?.call(messageList);
    }
  }

  Future<void> _onCmdMessagesReceived(List messages) async {
    List<ChatMessage> list = [];
    for (var message in messages) {
      list.add(ChatMessage.fromJson(message));
    }

    for (var item in _eventHandlesMap.values) {
      item.onCmdMessagesReceived?.call(list);
    }
  }

  Future<void> _onMessagesRead(List messages) async {
    List<ChatMessage> list = [];
    for (var message in messages) {
      list.add(ChatMessage.fromJson(message));
    }

    for (var item in _eventHandlesMap.values) {
      item.onMessagesRead?.call(list);
    }
  }

  Future<void> _onGroupMessageRead(List messages) async {
    List<ChatGroupMessageAck> list = [];
    for (var message in messages) {
      list.add(ChatGroupMessageAck.fromJson(message));
    }

    for (var item in _eventHandlesMap.values) {
      item.onGroupMessageRead?.call(list);
    }
  }

  Future<void> _onReadAckForGroupMessageUpdated(List messages) async {
    for (var item in _eventHandlesMap.values) {
      item.onReadAckForGroupMessageUpdated?.call();
    }
  }

  Future<void> _onMessagesDelivered(List messages) async {
    List<ChatMessage> list = [];
    for (var message in messages) {
      list.add(ChatMessage.fromJson(message));
    }

    for (var item in _eventHandlesMap.values) {
      item.onMessagesDelivered?.call(list);
    }
  }

  Future<void> _onMessagesRecalled(List messages) async {
    List<ChatMessage> list = [];
    for (var message in messages) {
      list.add(ChatMessage.fromJson(message));
    }

    for (var item in _eventHandlesMap.values) {
      item.onMessagesRecalled?.call(list);
    }
  }

  Future<void> _onConversationsUpdate(dynamic obj) async {
    for (var item in _eventHandlesMap.values) {
      item.onConversationsUpdate?.call();
    }
  }

  Future<void> _onConversationHasRead(dynamic obj) async {
    String from = (obj as Map)['from'];
    String to = obj['to'];

    for (var item in _eventHandlesMap.values) {
      item.onConversationRead?.call(from, to);
    }
  }

  Future<void> _messageReactionDidChange(List reactionChangeList) async {
    List<ChatMessageReactionEvent> list = [];
    for (var reactionChange in reactionChangeList) {
      list.add(ChatMessageReactionEvent.fromJson(reactionChange));
    }

    for (var item in _eventHandlesMap.values) {
      item.onMessageReactionDidChange?.call(list);
    }
  }

  Future<void> _onMessageContentChanged(dynamic obj) async {
    ChatMessage msg = ChatMessage.fromJson(obj["message"]);
    String operator = obj["operator"] ?? "";
    int operationTime = obj["operationTime"] ?? 0;
    for (var item in _eventHandlesMap.values) {
      item.onMessageContentChanged?.call(msg, operator, operationTime);
    }
  }
}

///
/// The message status event class.
/// During message delivery, the message ID will be changed from a local uuid to a global unique ID that is generated by the server to uniquely identify a message on all devices using the SDK.
/// This API should be implemented in the chat page widget to listen for message status changes.
///
///
///
class ChatMessageEvent {
  ChatMessageEvent({
    this.onSuccess,
    this.onError,
    this.onProgress,
  });

  ///
  /// Occurs when a message is successfully sent or downloaded.
  ///
  /// Param [msgId] The pre-sending message ID or the ID of the message that is successfully downloaded.
  ///
  /// Param [msg] The message that is successfully sent or downloaded.
  ///
  ///
  ///
  final void Function(String msgId, ChatMessage msg)? onSuccess;

  ///
  /// Occurs when a message fails to be sent or downloaded.
  ///
  /// Param [msgId] The pre-sending message ID or the ID of the message that fails to be downloaded.
  ///
  /// Param [msg] The message that fails to be sent or downloaded.
  ///
  ///
  ///
  final void Function(String msgId, ChatMessage msg, ChatError error)? onError;

  ///
  /// Occurs when there is a progress for message upload or download. This event is triggered when a message is being uploaded or downloaded.
  ///
  /// Param [msgId] The ID of the message that is being uploaded or downloaded.
  ///
  /// Param [progress] The upload or download progress.
  ///
  ///
  ///
  final void Function(String msgId, int progress)? onProgress;
}

/// @nodoc
class MessageCallBackManager {
  static const _channelPrefix = 'com.chat.im';
  static const MethodChannel _emMessageChannel =
      const MethodChannel('$_channelPrefix/chat_message', JSONMethodCodec());
  Map<String, ChatMessageEvent> cacheHandleMap = {};
  static MessageCallBackManager? _instance;
  static MessageCallBackManager get getInstance =>
      _instance = _instance ?? MessageCallBackManager._internal();

  MessageCallBackManager._internal() {
    _emMessageChannel.setMethodCallHandler((MethodCall call) async {
      Map<String, dynamic> argMap = call.arguments;
      String? localId = argMap['localId'];
      if (localId == null) return;
      cacheHandleMap.forEach((key, value) {
        if (call.method == ChatMethodKeys.onMessageProgressUpdate) {
          int progress = argMap["progress"];
          value.onProgress?.call(localId, progress);
        } else if (call.method == ChatMethodKeys.onMessageError) {
          ChatMessage msg = ChatMessage.fromJson(argMap['message']);
          ChatError err = ChatError.fromJson(argMap['error']);
          value.onError?.call(localId, msg, err);
        } else if (call.method == ChatMethodKeys.onMessageSuccess) {
          ChatMessage msg = ChatMessage.fromJson(argMap['message']);
          value.onSuccess?.call(localId, msg);
        }
      });

      return null;
    });
  }

  /// @nodoc
  void addMessageEvent(String key, ChatMessageEvent event) {
    cacheHandleMap[key] = event;
  }

  /// @nodoc
  void removeMessageEvent(String key) {
    if (cacheHandleMap.containsKey(key)) {
      cacheHandleMap.remove(key);
    }
  }

  /// @nodoc
  void clearAllMessageEvents() {
    cacheHandleMap.clear();
  }
}
