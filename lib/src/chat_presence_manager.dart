// ignore_for_file: deprecated_member_use_from_same_package

import 'package:flutter/services.dart';
import 'internal/inner_headers.dart';

///
/// The Manager that defines how to manage presence states.
///
///
///
class ChatPresenceManager {
  static const _channelPrefix = 'com.chat.im';
  static const MethodChannel _channel = const MethodChannel(
      '$_channelPrefix/chat_presence_manager', JSONMethodCodec());

  final Map<String, ChatPresenceEventHandler> _eventHandlesMap = {};

  /// @nodoc
  ChatPresenceManager() {
    _channel.setMethodCallHandler((MethodCall call) async {
      Map? argMap = call.arguments;
      if (call.method == ChatMethodKeys.onPresenceStatusChanged) {
        return _presenceChange(argMap!);
      }
      return null;
    });
  }

  ///
  /// Adds the presence event handler. After calling this method, you can handle for new presence event when they arrive.
  ///
  /// Param [identifier] The custom handler identifier, is used to find the corresponding handler.
  ///
  /// Param [handler] The handle for presence event. See [ChatPresenceEventHandler].
  ///
  ///
  ///
  void addEventHandler(
    String identifier,
    ChatPresenceEventHandler handler,
  ) {
    _eventHandlesMap[identifier] = handler;
  }

  ///
  /// Remove the presence event handler.
  ///
  /// Param [identifier] The custom handler identifier.
  ///
  ///
  ///
  void removeEventHandler(String identifier) {
    _eventHandlesMap.remove(identifier);
  }

  ///
  /// Get the presence event handler.
  ///
  /// Param [identifier] The custom handler identifier.
  ///
  /// **Return** The presence event handler.
  ///
  ///
  ///
  ChatPresenceEventHandler? getEventHandler(String identifier) {
    return _eventHandlesMap[identifier];
  }

  ///
  /// Clear all presence event handlers.
  ///
  ///
  ///
  void clearEventHandlers() {
    _eventHandlesMap.clear();
  }

  ///
  /// Publishes a custom presence state.
  ///
  /// Param [description] The extension information of the presence state. It can be set as nil.
  ///
  /// **Throws** A description of the exception. See [ChatError].
  ///
  ///
  ///
  Future<void> publishPresence(
    String description,
  ) async {
    Map req = {'desc': description};
    Map result = await _channel.invokeMethod(
        ChatMethodKeys.presenceWithDescription, req);
    try {
      ChatError.hasErrorFromResult(result);
    } on ChatError catch (e) {
      throw e;
    }
  }

  ///
  /// Subscribes to a user's presence states. If the subscription succeeds, the subscriber will receive the callback when the user's presence state changes.
  ///
  /// Param [members] The list of IDs of users whose presence states you want to subscribe to.
  ///
  /// Param [expiry] The expiration time of the presence subscription.
  ///
  /// **Return** Which contains IDs of users whose presence states you have subscribed to.
  ///
  /// **Throws** A description of the exception. See [ChatError].
  ///
  ///
  ///
  Future<List<ChatPresence>> subscribe({
    required List<String> members,
    required int expiry,
  }) async {
    Map req = {'members': members, "expiry": expiry};
    Map result =
        await _channel.invokeMethod(ChatMethodKeys.presenceSubscribe, req);
    try {
      ChatError.hasErrorFromResult(result);
      List<ChatPresence> list = [];
      result[ChatMethodKeys.presenceSubscribe]?.forEach((element) {
        list.add(ChatPresence.fromJson(element));
      });
      return list;
    } on ChatError catch (e) {
      throw e;
    }
  }

  ///
  /// Unsubscribes from a user's presence states.
  ///
  /// Param [members] The array of IDs of users whose presence states you want to unsubscribe from.
  ///
  /// **Throws** A description of the exception. See [ChatError].
  ///
  ///
  ///
  Future<void> unsubscribe({
    required List<String> members,
  }) async {
    Map req = {'members': members};
    Map result =
        await _channel.invokeMethod(ChatMethodKeys.presenceUnsubscribe, req);
    try {
      ChatError.hasErrorFromResult(result);
    } on ChatError catch (e) {
      throw e;
    }
  }

  ///
  /// Uses pagination to get a list of users whose presence states you have subscribed to.
  ///
  /// Param [pageNum] The current page number, starting from 1.
  ///
  /// Param [pageSize] The number of subscribed users on each page.
  ///
  /// **Return** Which contains IDs of users whose presence states you have subscribed to. Returns null if you subscribe to no user's presence state.
  ///
  /// **Throws** A description of the exception. See [ChatError].
  ///
  ///
  ///
  Future<List<String>> fetchSubscribedMembers({
    int pageNum = 1,
    int pageSize = 20,
  }) async {
    Map req = {'pageNum': pageNum, "pageSize": pageSize};
    Map result = await _channel.invokeMethod(
        ChatMethodKeys.fetchSubscribedMembersWithPageNum, req);
    try {
      ChatError.hasErrorFromResult(result);
      List<String> list = [];
      result[ChatMethodKeys.fetchSubscribedMembersWithPageNum]
          ?.forEach((element) {
        if (element is String) {
          list.add(element);
        }
      });
      return list;
    } on ChatError catch (e) {
      throw e;
    }
  }

  ///
  /// Gets the current presence state of users.
  ///
  /// Param [members] The array of IDs of users whose current presence state you want to check.
  ///
  /// **Return** Which contains the users whose presence state you have subscribed to.
  ///
  /// **Throws** A description of the exception. See [ChatError].
  ///
  ///
  ///
  Future<List<ChatPresence>> fetchPresenceStatus({
    required List<String> members,
  }) async {
    Map req = {'members': members};
    Map result =
        await _channel.invokeMethod(ChatMethodKeys.fetchPresenceStatus, req);
    try {
      ChatError.hasErrorFromResult(result);
      List<ChatPresence> list = [];
      result[ChatMethodKeys.fetchPresenceStatus]?.forEach((element) {
        list.add(ChatPresence.fromJson(element));
      });
      return list;
    } on ChatError catch (e) {
      throw e;
    }
  }

  Future<void> _presenceChange(Map event) async {
    List? mapList = event['presences'];
    if (mapList == null) {
      return;
    }
    List<ChatPresence> pList = [];
    for (var item in mapList) {
      pList.add(ChatPresence.fromJson(item));
    }

    for (var handle in _eventHandlesMap.values) {
      handle.onPresenceStatusChanged?.call(pList);
    }
  }
}
