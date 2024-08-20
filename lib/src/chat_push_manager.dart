import 'dart:io';

import 'internal/inner_headers.dart';

///
/// The message push configuration options.
///
///
///
class ChatPushManager {
  ///
  /// Gets the push configurations from the server.
  ///
  ///
  ///
  Future<ChatPushConfigs> fetchPushConfigsFromServer() async {
    Map result = await PushChannel.invokeMethod(
        ChatMethodKeys.getImPushConfigFromServer);
    try {
      ChatError.hasErrorFromResult(result);
      return ChatPushConfigs.fromJson(
          result[ChatMethodKeys.getImPushConfigFromServer]);
    } on ChatError catch (e) {
      throw e;
    }
  }

  ///
  /// Updates the push display nickname of the current user.
  ///
  /// This method can be used to set a push display nickname, the push display nickname will be used to show for offline push notification.
  /// When the app user changes the nickname in the user profile use [ChatUserInfoManager.updateUserInfo]
  /// be sure to also call this method to update to prevent the display differences.
  ///
  /// Param [nickname] The push display nickname, which is different from the nickname in the user profile.
  ///
  /// **Throws** A description of the issue that caused this exception. See [ChatError]
  ///
  ///
  ///
  Future<void> updatePushNickname(String nickname) async {
    Map req = {'nickname': nickname};
    Map result =
        await PushChannel.invokeMethod(ChatMethodKeys.updatePushNickname, req);
    try {
      ChatError.hasErrorFromResult(result);
    } on ChatError catch (e) {
      throw e;
    }
  }

  ///
  /// Updates the push message display style. The default value is [DisplayStyle.Simple].
  ///
  /// Param [displayStyle] The push message display style.
  ///
  /// **Throws** A description of the issue that caused this exception. See [ChatError]
  ///
  ///
  ///
  Future<void> updatePushDisplayStyle(DisplayStyle displayStyle) async {
    Map req = {'pushStyle': displayStyle == DisplayStyle.Simple ? 0 : 1};
    Map result =
        await PushChannel.invokeMethod(ChatMethodKeys.updateImPushStyle, req);
    try {
      ChatError.hasErrorFromResult(result);
    } on ChatError catch (e) {
      throw e;
    }
  }

  ///
  /// Updates the HMS push token.
  ///
  /// Param [token] The HMS push token.
  ///
  /// **Throws** A description of the issue that caused this exception. See [ChatError]
  ///
  ///
  ///
  Future<void> updateHMSPushToken(String token) async {
    if (Platform.isAndroid) {
      Map req = {'token': token};
      Map result = await PushChannel.invokeMethod(
          ChatMethodKeys.updateHMSPushToken, req);
      try {
        ChatError.hasErrorFromResult(result);
      } on ChatError catch (e) {
        throw e;
      }
    }
  }

  ///
  /// Updates the FCM push token.
  ///
  /// Param [token] The FCM push token.
  ///
  /// **Throws** A description of the issue that caused this exception. See [ChatError]
  ///
  ///
  ///
  Future<void> updateFCMPushToken(String token) async {
    Map req = {'token': token};
    Map result =
        await PushChannel.invokeMethod(ChatMethodKeys.updateFCMPushToken, req);
    try {
      ChatError.hasErrorFromResult(result);
    } on ChatError catch (e) {
      throw e;
    }
  }

  ///
  /// Updates the APNs push token.
  ///
  /// Param [token] The APNs push token.
  ///
  /// **Throws** A description of the issue that caused this exception. See [ChatError]
  ///
  ///
  ///
  Future<void> updateAPNsDeviceToken(String token) async {
    if (Platform.isIOS) {
      Map req = {'token': token};
      Map result = await PushChannel.invokeMethod(
          ChatMethodKeys.updateAPNsPushToken, req);
      try {
        ChatError.hasErrorFromResult(result);
      } on ChatError catch (e) {
        throw e;
      }
    }
  }

  ///
  /// Sets the push notifications for a conversation.
  ///
  /// Param [conversationId] The conversation ID.
  ///
  /// Param [type] The conversation type.
  ///
  /// Param [param]  The offline push parameters.
  ///
  /// **Throws** A description of the exception. See [ChatError].
  ///
  ///
  ///
  ///
  Future<void> setConversationSilentMode({
    required String conversationId,
    required ChatConversationType type,
    required ChatSilentModeParam param,
  }) async {
    Map req = {};
    req["conversationId"] = conversationId;
    req["conversationType"] = conversationTypeToInt(type);
    req["param"] = param.toJson();

    Map result = await PushChannel.invokeMethod(
        ChatMethodKeys.setConversationSilentMode, req);
    try {
      ChatError.hasErrorFromResult(result);
    } on ChatError catch (e) {
      throw e;
    }
  }

  ///
  /// Removes the offline push notification settings for a conversation.
  ///
  /// After the setting is deleted, the conversation follows the setting of [ChatPushManager.setSilentModeForAll] of the current logged-in user.
  ///
  /// Param [conversationId] The conversation ID.
  ///
  /// Param [type] The conversation type.
  ///
  /// **Throws** A description of the exception. See [ChatError].
  ///
  ///
  ///
  Future<void> removeConversationSilentMode({
    required String conversationId,
    required ChatConversationType type,
  }) async {
    Map req = {};
    req["conversationId"] = conversationId;
    req["conversationType"] = conversationTypeToInt(type);
    Map result = await PushChannel.invokeMethod(
        ChatMethodKeys.removeConversationSilentMode, req);
    try {
      ChatError.hasErrorFromResult(result);
    } on ChatError catch (e) {
      throw e;
    }
  }

  ///
  /// Gets the offline push settings of a conversation.
  ///
  /// Param [conversationId] The conversation ID.
  ///
  /// Param [type] The conversation type.
  ///
  /// **Return** The offline push settings of the conversation.
  ///
  /// **Throws** A description of the exception. See [ChatError].
  ///
  ///
  ///
  Future<ChatSilentModeResult> fetchConversationSilentMode({
    required String conversationId,
    required ChatConversationType type,
  }) async {
    Map req = {};
    req["conversationId"] = conversationId;
    req["conversationType"] = conversationTypeToInt(type);
    Map result = await PushChannel.invokeMethod(
        ChatMethodKeys.fetchConversationSilentMode, req);
    try {
      ChatError.hasErrorFromResult(result);
      Map map = result[ChatMethodKeys.fetchConversationSilentMode];
      return ChatSilentModeResult.fromJson(map);
    } on ChatError catch (e) {
      throw e;
    }
  }

  ///
  /// Sets the offline push settings at the app level for the current login user.
  ///
  /// Param [param] The offline push parameters.
  ///
  /// **Throws** A description of the exception. See [ChatError].
  ///
  ///
  ///
  Future<void> setSilentModeForAll({
    required ChatSilentModeParam param,
  }) async {
    Map req = {};
    req["param"] = param.toJson();
    Map result = await PushChannel.invokeMethod(
      ChatMethodKeys.setSilentModeForAll,
      req,
    );
    try {
      ChatError.hasErrorFromResult(result);
    } on ChatError catch (e) {
      throw e;
    }
  }

  ///
  /// Gets the offline push settings at the app level for the current login user.
  ///
  /// **Return** The offline push settings settings.
  ///
  /// **Throws** A description of the exception. See [ChatError].
  ///
  ///
  ///
  Future<ChatSilentModeResult> fetchSilentModeForAll() async {
    Map result =
        await PushChannel.invokeMethod(ChatMethodKeys.fetchSilentModeForAll);
    try {
      ChatError.hasErrorFromResult(result);
      return ChatSilentModeResult.fromJson(
        result[ChatMethodKeys.fetchSilentModeForAll],
      );
    } on ChatError catch (e) {
      throw e;
    }
  }

  ///
  /// Gets the offline push settings of specified conversations.
  ///
  /// Param [conversations]  The conversation list.
  ///
  /// **Return** The key is the conversation ID and the value is offline push settings.
  ///
  /// **Throws** A description of the exception. See [ChatError].
  ///
  ///
  ///
  Future<Map<String, ChatSilentModeResult>> fetchSilentModeForConversations(
    List<ChatConversation> conversations,
  ) async {
    Map<String, int> req = {};
    for (var item in conversations) {
      req[item.id] = conversationTypeToInt(item.type);
    }
    Map result = await PushChannel.invokeMethod(
      ChatMethodKeys.fetchSilentModeForConversations,
      req,
    );
    try {
      ChatError.hasErrorFromResult(result);
      Map<String, ChatSilentModeResult> ret = {};
      Map? tmpMap = result[ChatMethodKeys.fetchSilentModeForConversations];
      if (tmpMap != null) {
        for (var item in tmpMap.entries) {
          if (item.key is String && item.value is Map) {
            ret[item.key] = ChatSilentModeResult.fromJson(item.value);
          }
        }
      }
      return ret;
    } on ChatError catch (e) {
      throw e;
    }
  }

  ///
  /// Sets the preferred language for push notifications.
  ///
  /// Param [languageCode] The language code.
  ///
  /// **Throws** A description of the exception. See [ChatError].
  ///
  ///
  ///
  Future<void> setPreferredNotificationLanguage(String languageCode) async {
    Map req = {"code": languageCode};
    Map result = await PushChannel.invokeMethod(
      ChatMethodKeys.setPreferredNotificationLanguage,
      req,
    );
    try {
      ChatError.hasErrorFromResult(result);
    } on ChatError catch (e) {
      throw e;
    }
  }

  ///
  /// Gets the preferred language for push notifications.
  ///
  /// **Return** The language code.
  ///
  /// **Throws** A description of the exception. See [ChatError].
  ///
  ///
  ///
  Future<String?> fetchPreferredNotificationLanguage() async {
    Map result = await PushChannel.invokeMethod(
      ChatMethodKeys.fetchPreferredNotificationLanguage,
    );
    try {
      ChatError.hasErrorFromResult(result);
      String? ret = result[ChatMethodKeys.fetchPreferredNotificationLanguage];
      return ret;
    } on ChatError catch (e) {
      throw e;
    }
  }

  ///
  /// Sets the template for offline push notifications.
  ///
  /// Param [pushTemplateName] The push template name.
  ///
  /// **Throws** A description of the exception. See [ChatError].
  ///
  ///
  ///
  Future<void> setPushTemplate(String pushTemplateName) async {
    Map result =
        await PushChannel.invokeMethod(ChatMethodKeys.setPushTemplate, {
      "pushTemplateName": pushTemplateName,
    });
    try {
      ChatError.hasErrorFromResult(result);
    } on ChatError catch (e) {
      throw e;
    }
  }

  ///
  /// Gets the template for offline push notifications.
  ///
  /// **Return** The push template name.
  ///
  /// **Throws** A description of the exception. See [ChatError].
  ///
  ///
  ///
  Future<String?> getPushTemplate() async {
    Map result = await PushChannel.invokeMethod(ChatMethodKeys.getPushTemplate);
    try {
      ChatError.hasErrorFromResult(result);
      String? ret = result[ChatMethodKeys.getPushTemplate];
      return ret;
    } on ChatError catch (e) {
      throw e;
    }
  }
}
