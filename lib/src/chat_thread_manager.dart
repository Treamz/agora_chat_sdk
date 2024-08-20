// ignore_for_file: deprecated_member_use_from_same_package

import 'package:flutter/services.dart';
import 'internal/inner_headers.dart';

///
/// The chat thread manager class.
///
///
///
class ChatThreadManager {
  static const _channelPrefix = 'com.chat.im';
  static const MethodChannel _channel = const MethodChannel(
      '$_channelPrefix/chat_thread_manager', JSONMethodCodec());

  final Map<String, ChatThreadEventHandler> _eventHandlesMap = {};

  ChatThreadManager() {
    _channel.setMethodCallHandler((MethodCall call) async {
      Map? argMap = call.arguments;
      if (call.method == ChatMethodKeys.onChatThreadCreate) {
        _onChatThreadCreated(argMap);
      } else if (call.method == ChatMethodKeys.onChatThreadUpdate) {
        _onChatThreadUpdated(argMap);
      } else if (call.method == ChatMethodKeys.onChatThreadDestroy) {
        _onChatThreadDestroyed(argMap);
      } else if (call.method == ChatMethodKeys.onUserKickOutOfChatThread) {
        _onChatThreadUserRemoved(argMap);
      }
      return null;
    });
  }

  ///
  /// Adds the chat thread event handler. After calling this method, you can handle for chat thread event when they arrive.
  ///
  /// Param [identifier] The custom handler identifier, is used to find the corresponding handler.
  ///
  /// Param [handler] The handle for chat thread event. See [ChatThreadEventHandler].
  ///
  ///
  ///
  void addEventHandler(
    String identifier,
    ChatThreadEventHandler handler,
  ) {
    _eventHandlesMap[identifier] = handler;
  }

  ///
  /// Remove the chat thread event handler.
  ///
  /// Param [identifier] The custom handler identifier.
  ///
  ///
  ///
  void removeEventHandler(String identifier) {
    _eventHandlesMap.remove(identifier);
  }

  ///
  /// Get the chat thread event handler.
  ///
  /// Param [identifier] The custom handler identifier.
  ///
  /// **Return** The chat thread event handler.
  ///
  ///
  ///
  ChatThreadEventHandler? getEventHandler(String identifier) {
    return _eventHandlesMap[identifier];
  }

  ///
  /// Clear all chat thread event handlers.
  ///
  ///
  ///
  void clearEventHandlers() {
    _eventHandlesMap.clear();
  }

  ///
  /// Get Chat Thread details from server.
  ///
  /// Param [chatThreadId] Chat Thread ID.
  ///
  /// **Return** The chat thread object.
  ///
  /// **Throws** A description of the exception. See [ChatError].
  ///
  ///
  ///
  Future<ChatThread?> fetchChatThread({
    required String chatThreadId,
  }) async {
    Map req = {"threadId": chatThreadId};
    Map result = await _channel.invokeMethod(
      ChatMethodKeys.fetchChatThreadDetail,
      req,
    );
    try {
      ChatError.hasErrorFromResult(result);
      return ChatThread.fromJson(result[ChatMethodKeys.fetchChatThreadDetail]);
    } on ChatError catch (e) {
      throw e;
    }
  }

  ///
  /// Paging to get the list of Chat Threads that the current user has joined from the server
  ///
  /// Param [cursor] The initial value can be empty or empty string.
  ///
  /// Param [limit] The number of fetches at one time. Value range [1, 50].
  ///
  /// **Return** Returns the result of [ChatCursorResult], including the cursor for getting data next time and the chat thread object list.
  ///
  /// **Throws** A description of the exception. See [ChatError].
  ///
  ///
  ///
  Future<ChatCursorResult<ChatThread>> fetchJoinedChatThreads({
    String? cursor,
    int limit = 20,
  }) async {
    Map req = {"pageSize": limit};
    req.putIfNotNull("cursor", cursor);
    Map result =
        await _channel.invokeMethod(ChatMethodKeys.fetchJoinedChatThreads, req);
    try {
      ChatError.hasErrorFromResult(result);
      return ChatCursorResult.fromJson(
          result[ChatMethodKeys.fetchJoinedChatThreads],
          dataItemCallback: (map) {
        return ChatThread.fromJson(map);
      });
    } on ChatError catch (e) {
      throw e;
    }
  }

  ///
  /// Get the subareas under a group from the server
  ///
  /// Param [parentId] Parent ID, generally refers to group ID.
  ///
  /// Param [cursor] The initial value can be empty or empty string.
  ///
  /// Param [limit] The number of fetches at one time. Value range [1, 50].
  ///
  /// **Return** result of [ChatCursorResult], including the cursor for getting data next time and the chat thread object list.
  ///
  /// **Throws** A description of the exception. See [ChatError].
  ///
  ///
  ///
  Future<ChatCursorResult<ChatThread>> fetchChatThreadsWithParentId({
    required String parentId,
    String? cursor,
    int limit = 20,
  }) async {
    Map req = {
      "parentId": parentId,
      "pageSize": limit,
    };
    req.putIfNotNull("cursor", cursor);
    Map result = await _channel.invokeMethod(
        ChatMethodKeys.fetchChatThreadsWithParentId, req);
    try {
      ChatError.hasErrorFromResult(result);
      return ChatCursorResult.fromJson(
          result[ChatMethodKeys.fetchChatThreadsWithParentId],
          dataItemCallback: (map) {
        return ChatThread.fromJson(map);
      });
    } on ChatError catch (e) {
      throw e;
    }
  }

  ///
  /// Paging to get the list of Chat Threads that the current user has joined the specified group from the server。
  ///
  /// Param [parentId] The session id of the upper level of the sub-area
  ///
  /// Param [cursor] The initial value can be empty or empty string.
  ///
  /// Param [limit] The number of fetches at one time. Value range [1, 50].
  ///
  /// **Return** The result of [ChatCursorResult], including the cursor for getting data next time and the chat thread object list.
  ///
  /// **Throws** A description of the exception. See [ChatError].
  ///
  ///
  ///
  Future<ChatCursorResult<ChatThread>> fetchJoinedChatThreadsWithParentId({
    required String parentId,
    String? cursor,
    int limit = 20,
  }) async {
    Map req = {
      "parentId": parentId,
      "pageSize": limit,
    };
    req.putIfNotNull("cursor", cursor);
    Map result = await _channel.invokeMethod(
        ChatMethodKeys.fetchJoinedChatThreadsWithParentId, req);
    try {
      ChatError.hasErrorFromResult(result);
      return ChatCursorResult.fromJson(
          result[ChatMethodKeys.fetchJoinedChatThreadsWithParentId],
          dataItemCallback: (map) {
        return ChatThread.fromJson(map);
      });
    } on ChatError catch (e) {
      throw e;
    }
  }

  ///
  /// Paging to get Chat Thread members.
  ///
  /// The members of the group to which Chat Thread belongs have permission.
  ///
  /// Param [chatThreadId] Chat Thread ID.
  ///
  /// Param [cursor] The initial value can be empty or empty string.
  ///
  /// Param [limit] The number of fetches at one time. Value range [1, 50].
  ///
  /// **Return** The result of [ChatCursorResult], including the cursor for getting data next time and the chat thread member list.
  ///
  /// **Throws** A description of the exception. See [ChatError].
  ///
  ///
  ///
  Future<ChatCursorResult<String>> fetchChatThreadMembers({
    required String chatThreadId,
    String? cursor,
    int limit = 20,
  }) async {
    Map req = {
      "pageSize": limit,
      "threadId": chatThreadId,
    };
    req.putIfNotNull("cursor", cursor);
    Map result = await _channel.invokeMethod(
      ChatMethodKeys.fetchChatThreadMember,
      req,
    );
    try {
      ChatError.hasErrorFromResult(result);
      return ChatCursorResult<String>.fromJson(
          result[ChatMethodKeys.fetchChatThreadMember],
          dataItemCallback: (obj) => obj);
    } on ChatError catch (e) {
      throw e;
    }
  }

  ///
  /// Get the latest news of the specified Chat Thread list from the server.
  ///
  /// Param [chatThreadIds] Chat Thread id list. The list length is not greater than 20.
  ///
  /// **Return** returns a Map collection, the key is the chat thread ID, and the value is the latest message object of the chat thread.
  ///
  /// **Throws** A description of the exception. See [ChatError].
  ///
  ///
  ///
  Future<Map<String, ChatMessage>> fetchLatestMessageWithChatThreads({
    required List<String> chatThreadIds,
  }) async {
    Map req = {
      "threadIds": chatThreadIds,
    };
    Map result = await _channel.invokeMethod(
      ChatMethodKeys.fetchLastMessageWithChatThreads,
      req,
    );
    try {
      ChatError.hasErrorFromResult(result);
      Map? map = result[ChatMethodKeys.fetchLastMessageWithChatThreads];
      Map<String, ChatMessage> ret = {};
      if (map == null) {
        return ret;
      }

      for (var key in map.keys) {
        Map<String, dynamic> msgMap = map[key];
        ret[key] = ChatMessage.fromJson(msgMap);
      }
      return ret;
    } on ChatError catch (e) {
      throw e;
    }
  }

  ///
  /// Remove member from Chat Thread.
  ///
  /// Param [memberId] The ID of the member that was removed from Chat Thread.
  ///
  /// Param [chatThreadId] Chat Thread ID.
  ///
  /// **Throws** A description of the exception. See [ChatError].
  ///
  ///
  ///
  Future<void> removeMemberFromChatThread({
    required String memberId,
    required String chatThreadId,
  }) async {
    Map req = {
      "memberId": memberId,
      "threadId": chatThreadId,
    };
    Map result = await _channel.invokeMethod(
      ChatMethodKeys.removeMemberFromChatThread,
      req,
    );
    try {
      ChatError.hasErrorFromResult(result);
    } on ChatError catch (e) {
      throw e;
    }
  }

  ///
  /// Change Chat Thread name.
  ///
  /// The group owner, group administrator and Thread creator have permission.
  /// After modifying chat thread name, members of the organization (group) to which chat thread belongs will receive the update notification event.
  /// You can set [ChatThreadEventHandler.onChatThreadUpdate] to listen on the event.
  ///
  /// Param [chatThreadId] Chat Thread ID.
  ///
  /// Param [newName]  New Chat Thread name. No more than 64 characters in length.
  ///
  /// **Throws** A description of the exception. See [ChatError].
  ///
  ///
  ///
  Future<void> updateChatThreadName({
    required String chatThreadId,
    required String newName,
  }) async {
    Map req = {
      "name": newName,
      "threadId": chatThreadId,
    };
    Map result = await _channel.invokeMethod(
      ChatMethodKeys.updateChatThreadSubject,
      req,
    );
    try {
      ChatError.hasErrorFromResult(result);
    } on ChatError catch (e) {
      throw e;
    }
  }

  ///
  /// Create Chat Thread.
  ///
  /// Group members have permission.
  /// After chat thread is created, the following notices will appear:
  /// 1. Members of the organization (group) to which chat thread belongs will receive the created notification event,
  /// and can listen to related events by setting [ChatThreadEventHandler].
  /// The event callback function is [ChatThreadEventHandler.onChatThreadCreate].
  /// 2. Multiple devices will receive the notification event and you can set [ChatMultiDeviceEventHandler] to listen on the event.
  /// The event callback function is [ChatMultiDeviceEventHandler.onChatThreadEvent], where the first parameter is the event,
  /// for example, [ChatMultiDevicesEvent.CHAT_THREAD_CREATE] for the chat thread creation event.
  ///
  /// Param [name] Chat Thread name. No more than 64 characters in length.
  ///
  /// Param [messageId] Parent message ID, generally refers to group message ID.
  ///
  /// Param [parentId] Parent ID, generally refers to group ID.
  ///
  /// **Return** ChatThread object
  ///
  /// **Throws** A description of the exception. See [ChatError].
  ///
  ///
  ///
  Future<ChatThread> createChatThread({
    required String name,
    required String messageId,
    required String parentId,
  }) async {
    Map req = {
      "name": name,
      "messageId": messageId,
      "parentId": parentId,
    };
    Map result = await _channel.invokeMethod(
      ChatMethodKeys.createChatThread,
      req,
    );
    try {
      ChatError.hasErrorFromResult(result);
      return ChatThread.fromJson(result[ChatMethodKeys.createChatThread]);
    } on ChatError catch (e) {
      throw e;
    }
  }

  ///
  /// Join Chat Thread.
  ///
  /// Group members have permission.
  /// Join successfully, return the Chat Thread details [ChatThread], the details do not include the number of members.
  /// Repeated addition will throw an ChatError.
  /// After joining chat thread, the multiple devices will receive the notification event.
  /// You can set [ChatMultiDeviceEventHandler] to listen on the event.
  /// The event callback function is [ChatMultiDeviceEventHandler.onChatThreadEvent],
  /// where the first parameter is the event, and chat thread join event is [ChatMultiDevicesEvent.CHAT_THREAD_JOIN].
  ///
  /// Param [chatThreadId] Chat Thread ID.
  ///
  /// **Return** The joined chat thread object;
  ///
  /// **Throws** A description of the exception. See [ChatError].
  ///
  ///
  ///
  Future<ChatThread> joinChatThread({
    required String chatThreadId,
  }) async {
    Map req = {
      "threadId": chatThreadId,
    };
    Map result = await _channel.invokeMethod(
      ChatMethodKeys.joinChatThread,
      req,
    );
    try {
      ChatError.hasErrorFromResult(result);
      return ChatThread.fromJson(result[ChatMethodKeys.joinChatThread]);
    } on ChatError catch (e) {
      throw e;
    }
  }

  ///
  /// Leave Chat Thread.
  ///
  /// The operation is available to Chat Thread members.
  /// After leave chat thread, the multiple devices will receive the notification event.
  /// You can set {@ChatMultiDeviceEventHandler} to listen on the event.
  /// The event callback function is [ChatMultiDeviceEventHandler.onChatThreadEvent],
  /// where the first parameter is the event, and chat thread exit event is [ChatMultiDevicesEvent.CHAT_THREAD_LEAVE].
  ///
  /// Param [chatThreadId] Chat Thread ID.
  ///
  /// **Throws** A description of the exception. See [ChatError].
  ///
  ///
  ///
  Future<void> leaveChatThread({
    required String chatThreadId,
  }) async {
    Map req = {
      "threadId": chatThreadId,
    };
    Map result = await _channel.invokeMethod(
      ChatMethodKeys.leaveChatThread,
      req,
    );
    try {
      ChatError.hasErrorFromResult(result);
    } on ChatError catch (e) {
      throw e;
    }
  }

  ///
  /// Disband Chat Thread.
  ///
  /// Group owner and group administrator to which the Chat Thread belongs have permission.
  /// After chat thread is disbanded, there will be the following notification:
  /// 1. Members of the organization (group) to which chat thread belongs will receive the disbanded notification event,
  /// and can listen to related events by setting [ChatThreadEventHandler].
  /// The event callback function is [ChatThreadEventHandler.onChatThreadDestroy].
  /// 2. Multiple devices will receive the notification event and you can set [ChatMultiDeviceEventHandler] to listen on the event.
  /// The event callback function is [ChatMultiDeviceEventHandler.onChatThreadEvent], where the first parameter is the event,
  /// for example, [ChatMultiDevicesEvent.CHAT_THREAD_DESTROY] for the chat thread destruction event.
  ///
  /// Param [chatThreadId] Chat Thread ID.
  ///
  /// **Throws** A description of the exception. See [ChatError].
  ///
  ///
  ///
  Future<void> destroyChatThread({
    required String chatThreadId,
  }) async {
    Map req = {
      "threadId": chatThreadId,
    };
    Map result = await _channel.invokeMethod(
      ChatMethodKeys.destroyChatThread,
      req,
    );
    try {
      ChatError.hasErrorFromResult(result);
    } on ChatError catch (e) {
      throw e;
    }
  }

  Future<void> _onChatThreadCreated(Map? event) async {
    if (event == null) {
      return;
    }
    _eventHandlesMap.values.forEach((element) {
      element.onChatThreadCreate?.call(ChatThreadEvent.fromJson(event));
    });
  }

  Future<void> _onChatThreadUpdated(Map? event) async {
    if (event == null) {
      return;
    }
    _eventHandlesMap.values.forEach((element) {
      element.onChatThreadUpdate?.call(ChatThreadEvent.fromJson(event));
    });
  }

  Future<void> _onChatThreadDestroyed(Map? event) async {
    if (event == null) {
      return;
    }
    _eventHandlesMap.values.forEach((element) {
      element.onChatThreadDestroy?.call(ChatThreadEvent.fromJson(event));
    });
  }

  Future<void> _onChatThreadUserRemoved(Map? event) async {
    if (event == null) {
      return;
    }

    _eventHandlesMap.values.forEach((element) {
      element.onUserKickOutOfChatThread?.call(
        ChatThreadEvent.fromJson(event),
      );
    });
  }
}
