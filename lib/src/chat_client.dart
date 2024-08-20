// ignore_for_file: deprecated_member_use_from_same_package

import 'dart:async';

import 'package:flutter/services.dart';
import 'internal/inner_headers.dart';

///
/// The ChatClient class, which is the entry point of the Chat SDK.
/// With this class, you can log in, log out, and access other functionalities such as group and chatroom.
///
///
///
class ChatClient {
  static ChatClient? _instance;
  final ChatManager _chatManager = ChatManager();
  final ChatContactManager _contactManager = ChatContactManager();
  final ChatRoomManager _chatRoomManager = ChatRoomManager();
  final ChatGroupManager _groupManager = ChatGroupManager();
  final ChatPushManager _pushManager = ChatPushManager();
  final ChatUserInfoManager _userInfoManager = ChatUserInfoManager();

  final ChatPresenceManager _presenceManager = ChatPresenceManager();
  final ChatThreadManager _chatThreadManager = ChatThreadManager();

  final Map<String, ConnectionEventHandler> _connectionEventHandler = {};
  final Map<String, ChatMultiDeviceEventHandler> _multiDeviceEventHandler = {};

  // ignore: unused_field
  ChatProgressManager? _progressManager;

  ChatOptions? _options;

  ///
  /// Gets the configurations.
  ///
  ///
  ///
  ChatOptions? get options => _options;

  String? _currentUserId;

  ///
  /// Gets the SDK instance.
  ///
  ///
  ///
  static ChatClient get getInstance => _instance ??= ChatClient._internal();

  ///
  /// Sets a custom event handler to receive data from iOS or Android devices.
  ///
  /// Param [customEventHandler] The custom event handler.
  ///
  ///
  ///
  void Function(Map map)? customEventHandler;

  ///
  /// Gets the current logged-in user ID.
  ///
  ///
  ///
  String? get currentUserId => _currentUserId;

  ChatClient._internal() {
    _progressManager = ChatProgressManager();
    _addNativeMethodCallHandler();
  }

  void _addNativeMethodCallHandler() {
    ClientChannel.setMethodCallHandler((MethodCall call) async {
      Map? argMap = call.arguments;
      if (call.method == ChatMethodKeys.onConnected) {
        return _onConnected();
      } else if (call.method == ChatMethodKeys.onDisconnected) {
        return _onDisconnected();
      } else if (call.method == ChatMethodKeys.onUserDidLoginFromOtherDevice) {
        String deviceName = argMap?['deviceName'] ?? "";
        _onUserDidLoginFromOtherDevice(deviceName);
      } else if (call.method == ChatMethodKeys.onUserDidRemoveFromServer) {
        _onUserDidRemoveFromServer();
      } else if (call.method == ChatMethodKeys.onUserDidForbidByServer) {
        _onUserDidForbidByServer();
      } else if (call.method == ChatMethodKeys.onUserDidChangePassword) {
        _onUserDidChangePassword();
      } else if (call.method == ChatMethodKeys.onUserDidLoginTooManyDevice) {
        _onUserDidLoginTooManyDevice();
      } else if (call.method == ChatMethodKeys.onUserKickedByOtherDevice) {
        _onUserKickedByOtherDevice();
      } else if (call.method == ChatMethodKeys.onUserAuthenticationFailed) {
        _onUserAuthenticationFailed();
      } else if (call.method == ChatMethodKeys.onMultiDeviceGroupEvent) {
        _onMultiDeviceGroupEvent(argMap!);
      } else if (call.method == ChatMethodKeys.onMultiDeviceContactEvent) {
        _onMultiDeviceContactEvent(argMap!);
      } else if (call.method == ChatMethodKeys.onMultiDeviceThreadEvent) {
        _onMultiDeviceThreadEvent(argMap!);
      } else if (call.method ==
          ChatMethodKeys.onMultiDeviceRemoveMessagesEvent) {
        _onMultiDeviceRoamMessagesRemovedEvent(argMap!);
      } else if (call.method ==
          ChatMethodKeys.onMultiDevicesConversationEvent) {
        _onMultiDevicesConversationEvent(argMap!);
      } else if (call.method == ChatMethodKeys.onSendDataToFlutter) {
        _onReceiveCustomData(argMap!);
      } else if (call.method == ChatMethodKeys.onTokenWillExpire) {
        _onTokenWillExpire(argMap);
      } else if (call.method == ChatMethodKeys.onTokenDidExpire) {
        _onTokenDidExpire(argMap);
      } else if (call.method == ChatMethodKeys.onAppActiveNumberReachLimit) {
        _onAppActiveNumberReachLimit(argMap);
      }
    });
  }

  ///
  /// Adds the connection event handler. After calling this method, you can handle new connection events when they arrive.
  ///
  /// Param [identifier] The custom handler identifier, which is used to find the corresponding handler.
  ///
  /// Param [handler] The handler for connection event. See [ConnectionEventHandler].
  ///
  ///
  ///
  void addConnectionEventHandler(
    String identifier,
    ConnectionEventHandler handler,
  ) {
    _connectionEventHandler[identifier] = handler;
  }

  ///
  /// Removes the connection event handler.
  ///
  /// Param [identifier] The custom handler identifier.
  ///
  ///
  ///
  void removeConnectionEventHandler(String identifier) {
    _connectionEventHandler.remove(identifier);
  }

  ///
  /// Gets the connection event handler.
  ///
  /// Param [identifier] The custom handler identifier.
  ///
  /// **Return** The connection event handler.
  ///
  ///
  ///
  ConnectionEventHandler? getConnectionEventHandler(String identifier) {
    return _connectionEventHandler[identifier];
  }

  ///
  /// Clears all connection event handlers.
  ///
  ///
  ///
  void clearConnectionEventHandles() {
    _connectionEventHandler.clear();
  }

  ///
  /// Adds the multi-device event handler. After calling this method, you can handle for new multi-device events when they arrive.
  ///
  /// Param [identifier] The custom handler identifier, which is used to find the corresponding handler.
  ///
  /// Param [handler] The handler multi-device event. See [ChatMultiDeviceEventHandler].
  ///
  ///
  ///
  void addMultiDeviceEventHandler(
    String identifier,
    ChatMultiDeviceEventHandler handler,
  ) {
    _multiDeviceEventHandler[identifier] = handler;
  }

  ///
  /// Removes the multi-device event handler.
  ///
  /// Param [identifier] The custom handler identifier.
  ///
  ///
  ///
  void removeMultiDeviceEventHandler(String identifier) {
    _multiDeviceEventHandler.remove(identifier);
  }

  ///
  /// Gets the multi-device event handler.
  ///
  /// Param [identifier] The custom handler identifier.
  ///
  /// **Return** The multi-device event handler.
  ///
  ///
  ///
  ChatMultiDeviceEventHandler? getMultiDeviceEventHandler(String identifier) {
    return _multiDeviceEventHandler[identifier];
  }

  ///
  /// Clears all multi-device event handlers.
  ///
  ///
  ///
  void clearMultiDeviceEventHandles() {
    _multiDeviceEventHandler.clear();
  }

  ///
  /// Starts contact and group, chatroom callback.
  ///
  /// Call this method when you UI is ready, then will receive [ChatRoomEventHandler], [ContactEventHandler], [ChatGroupEventHandler] event.
  ///
  ///
  ///
  Future<void> startCallback() async {
    Map result = await ClientChannel.invokeMethod(ChatMethodKeys.startCallback);
    try {
      ChatError.hasErrorFromResult(result);
    } on ChatError catch (e) {
      throw e;
    }
  }

  ///
  /// Checks whether the SDK is connected to the chat server.
  ///
  /// **Return** Whether the SDK is connected to the chat server.
  /// `true`: The SDK is connected to the chat server.
  /// `false`: The SDK is not connected to the chat server.
  ///
  ///
  ///
  Future<bool> isConnected() async {
    Map result = await ClientChannel.invokeMethod(ChatMethodKeys.isConnected);
    try {
      ChatError.hasErrorFromResult(result);
      return result.boolValue(ChatMethodKeys.isConnected);
    } on ChatError catch (e) {
      throw e;
    }
  }

  ///
  /// Checks whether the user has logged in before and did not log out.
  ///
  /// If you need to check whether the SDK is connected to the server, please use [isConnected].
  ///
  /// **Return** Whether the user has logged in before.
  /// `true`: The user has logged in before,
  /// `false`: The user has not logged in before or has called the [logout] method.
  ///
  ///
  ///
  Future<bool> isLoginBefore() async {
    Map result =
        await ClientChannel.invokeMethod(ChatMethodKeys.isLoggedInBefore);
    try {
      ChatError.hasErrorFromResult(result);
      return result.boolValue(ChatMethodKeys.isLoggedInBefore);
    } on ChatError catch (e) {
      throw e;
    }
  }

  ///
  /// Gets the current login user ID.
  ///
  /// **Return** The current login user ID.
  ///
  ///
  ///
  Future<String?> getCurrentUserId() async {
    Map result =
        await ClientChannel.invokeMethod(ChatMethodKeys.getCurrentUser);
    try {
      ChatError.hasErrorFromResult(result);
      _currentUserId = result[ChatMethodKeys.getCurrentUser];
      if (_currentUserId != null) {
        if (_currentUserId!.length == 0) {
          _currentUserId = null;
        }
      }
      return _currentUserId;
    } on ChatError catch (e) {
      throw e;
    }
  }

  ///
  /// Gets the token of the current logged-in user.
  ///
  ///
  ///
  Future<String> getAccessToken() async {
    Map result = await ClientChannel.invokeMethod(ChatMethodKeys.getToken);
    try {
      ChatError.hasErrorFromResult(result);
      return result[ChatMethodKeys.getToken];
    } on ChatError catch (e) {
      throw e;
    }
  }

  ///
  /// Initializes the SDK.
  ///
  /// Param [options] The configurations: [ChatOptions]. Ensure that you set this parameter.
  ///
  ///
  ///
  Future<void> init(ChatOptions options) async {
    _options = options;
    EMLog.v('init: $options');
    await ClientChannel.invokeMethod(ChatMethodKeys.init, options.toJson());
    _currentUserId = await getCurrentUserId();
  }

  ///
  /// Registers a new user.
  ///
  /// Param [userId] The user Id. The maximum length is 64 characters. Ensure that you set this parameter.
  /// Supported characters include the 26 English letters (a-z), the ten numbers (0-9), the underscore (_), the hyphen (-),
  /// and the English period (.). This parameter is case insensitive, and upper-case letters are automatically changed to low-case ones.
  /// If you want to set this parameter as a regular expression, set it as ^[a-zA-Z0-9_-]+$.
  ///
  /// Param [password] The password. The maximum length is 64 characters. Ensure that you set this parameter.
  ///
  /// **Throws** A description of the exception. See [ChatError].
  ///
  ///
  ///
  Future<void> createAccount(String userId, String password) async {
    EMLog.v('create account: $userId : $password');
    Map req = {'username': userId, 'password': password};
    Map result =
        await ClientChannel.invokeMethod(ChatMethodKeys.createAccount, req);
    try {
      ChatError.hasErrorFromResult(result);
    } on ChatError catch (e) {
      throw e;
    }
  }

  ///
  /// Logs in to the chat server with a password or token.
  ///
  /// Param [userId] The user ID.
  ///
  /// Param [pwdOrToken] The password or token.
  ///
  /// Param [isPassword] Whether to log in with a password or a token.
  /// (Default) `true`: A password is used.
  /// `false`: A token is used.
  ///
  /// **Throws** A description of the exception. See [ChatError].
  ///
  ///
  ///
  Future<void> login(String userId, String pwdOrToken,
      [bool isPassword = true]) async {
    EMLog.v('login: $userId : $pwdOrToken, isPassword: $isPassword');
    Map req = {
      'username': userId,
      'pwdOrToken': pwdOrToken,
      'isPassword': isPassword
    };
    Map result = await ClientChannel.invokeMethod(ChatMethodKeys.login, req);
    try {
      ChatError.hasErrorFromResult(result);
      _currentUserId = userId;
    } on ChatError catch (e) {
      throw e;
    }
  }

  ///
  /// Logs in to the chat server by user ID and Agora token. This method supports automatic login.
  ///
  /// Another method to login to chat server is to login with user ID and token, See [login].
  ///
  /// Param [userId] The user Id.
  ///
  /// Param [agoraToken] The Agora token.
  ///
  /// **Throws** A description of the exception. See [ChatError].
  ///
  ///
  ///
  Future<void> loginWithAgoraToken(String userId, String agoraToken) async {
    Map req = {
      "username": userId,
      "agora_token": agoraToken,
    };

    Map result = await ClientChannel.invokeMethod(
        ChatMethodKeys.loginWithAgoraToken, req);
    try {
      ChatError.hasErrorFromResult(result);
      _currentUserId = userId;
    } on ChatError catch (e) {
      throw e;
    }
  }

  ///
  /// Renews the Agora token.
  ///
  /// If a user is logged in with an Agora token, when the token expires, you need to call this method to update the token.
  ///
  /// Param [agoraToken] The new Agora token.
  ///
  /// **Throws** A description of the exception. See [ChatError].
  ///
  ///
  ///
  Future<void> renewAgoraToken(String agoraToken) async {
    Map req = {"agora_token": agoraToken};

    Map result =
        await ClientChannel.invokeMethod(ChatMethodKeys.renewToken, req);
    try {
      ChatError.hasErrorFromResult(result);
    } on ChatError catch (e) {
      throw e;
    }
  }

  ///
  /// Logs out.
  ///
  /// Param [unbindDeviceToken] Whether to unbind the token upon logout.
  ///
  /// `true` (default) Yes.
  /// `false` No.
  ///
  /// **Throws** A description of the exception. See [ChatError].
  ///
  ///
  ///
  Future<void> logout([
    bool unbindDeviceToken = true,
  ]) async {
    EMLog.v('logout unbindDeviceToken: $unbindDeviceToken');
    Map req = {'unbindToken': unbindDeviceToken};
    Map result = await ClientChannel.invokeMethod(ChatMethodKeys.logout, req);
    try {
      ChatError.hasErrorFromResult(result);
      _clearAllInfo();
    } on ChatError catch (e) {
      throw e;
    }
  }

  ///
  /// Updates the App Key, which is the unique identifier to access Agora Chat.
  ///
  /// You can retrieve the new App Key from Agora Console.
  ///
  /// As this key controls all access to Agora Chat for your app, you can only update the key when the current user is logged out.
  ///
  /// Param [newAppKey] The App Key. Ensure that you set this parameter.
  ///
  /// **Throws** A description of the exception. See [ChatError].
  ///
  ///
  ///
  Future<bool> changeAppKey({required String newAppKey}) async {
    EMLog.v('changeAppKey: $newAppKey');
    Map req = {'appKey': newAppKey};
    Map result =
        await ClientChannel.invokeMethod(ChatMethodKeys.changeAppKey, req);
    try {
      ChatError.hasErrorFromResult(result);
      return result.boolValue(ChatMethodKeys.changeAppKey);
    } on ChatError catch (e) {
      throw e;
    }
  }

  ///
  /// Compresses the debug log into a gzip archive.
  ///
  /// Best practice is to delete this debug archive as soon as it is no longer used.
  ///
  /// **Return** The path of the compressed gzip file.
  ///
  /// **Throws** A description of the exception. See [ChatError].
  ///
  ///
  ///
  Future<String> compressLogs() async {
    EMLog.v('compressLogs:');
    Map result = await ClientChannel.invokeMethod(ChatMethodKeys.compressLogs);
    try {
      ChatError.hasErrorFromResult(result);
      return result[ChatMethodKeys.compressLogs];
    } on ChatError catch (e) {
      throw e;
    }
  }

  @Deprecated('Use [fetchLoggedInDevices] instead')

  ///
  /// Gets the list of currently logged-in devices of a specified account.
  ///
  /// Param [userId] The user ID.
  ///
  /// Param [password] The password.
  ///
  /// **Return** The list of the logged-in devices.
  ///
  /// **Throws** A description of the exception. See [ChatError].
  ///
  ///
  ///
  Future<List<ChatDeviceInfo>> getLoggedInDevicesFromServer(
      {required String userId, required String password}) async {
    Map req = {'username': userId, 'password': password};
    Map result = await ClientChannel.invokeMethod(
        ChatMethodKeys.getLoggedInDevicesFromServer, req);
    try {
      ChatError.hasErrorFromResult(result);
      List<ChatDeviceInfo> list = [];
      result[ChatMethodKeys.getLoggedInDevicesFromServer]?.forEach((info) {
        list.add(ChatDeviceInfo.fromJson(info));
      });
      return list;
    } on ChatError catch (e) {
      throw e;
    }
  }

  ///
  /// Gets the list of currently logged-in devices of a specified account.
  ///
  /// Param [userId] The user ID.
  ///
  /// Param [pwdOrToken] The password or token.
  ///
  /// Param [isPwd] Whether a password or token is used: (Default)`true`: A password is used; `false`: A token is used.
  ///
  /// **Return** The list of the logged-in devices.
  ///
  /// **Throws** A description of the exception. See [ChatError].
  ///
  ///
  ///
  Future<List<ChatDeviceInfo>> fetchLoggedInDevices({
    required String userId,
    required String pwdOrToken,
    bool isPwd = true,
  }) async {
    Map req = {'username': userId, 'password': pwdOrToken, 'isPwd': isPwd};
    Map result = await ClientChannel.invokeMethod(
        ChatMethodKeys.getLoggedInDevicesFromServer, req);
    try {
      ChatError.hasErrorFromResult(result);
      List<ChatDeviceInfo> list = [];
      result[ChatMethodKeys.getLoggedInDevicesFromServer]?.forEach((info) {
        list.add(ChatDeviceInfo.fromJson(info));
      });
      return list;
    } on ChatError catch (e) {
      throw e;
    }
  }

  ///
  /// Forces the specified account to log out from the specified device.
  ///
  /// Param [userId] The account you want to force to log out.
  ///
  /// Param [pwdOrToken] The password or token.
  ///
  /// Param [resource] The device ID. For how to fetch the device ID, See [ChatDeviceInfo.resource].
  ///
  /// **Throws** A description of the exception. See [ChatError].
  ///
  ///
  ///
  Future<void> kickDevice({
    required String userId,
    required String pwdOrToken,
    required String resource,
    bool isPwd = true,
  }) async {
    EMLog.v('kickDevice: $userId, "******"');
    Map req = {
      'username': userId,
      'password': pwdOrToken,
      'resource': resource,
      'isPwd': isPwd,
    };
    Map result =
        await ClientChannel.invokeMethod(ChatMethodKeys.kickDevice, req);
    try {
      ChatError.hasErrorFromResult(result);
    } on ChatError catch (e) {
      throw e;
    }
  }

  ///
  /// Forces the specified account to log out from all devices.
  ///
  /// Param [userId] The account you want to force to log out from all the devices.
  ///
  /// Param [pwdOrToken] The password or token.
  ///
  /// Param [isPwd] Whether a password or token is used: (Default)`true`: A password is used; `false`: A token is used.
  ///
  /// **Throws** A description of the exception. See [ChatError].
  ///
  ///
  ///
  Future<void> kickAllDevices({
    required String userId,
    required String pwdOrToken,
    bool isPwd = true,
  }) async {
    Map req = {'username': userId, 'password': pwdOrToken, 'isPwd': isPwd};
    Map result =
        await ClientChannel.invokeMethod(ChatMethodKeys.kickAllDevices, req);
    try {
      ChatError.hasErrorFromResult(result);
    } on ChatError catch (e) {
      throw e;
    }
  }

  Future<void> _onConnected() async {
    for (var handler in _connectionEventHandler.values) {
      handler.onConnected?.call();
    }
  }

  Future<void> _onDisconnected() async {
    for (var handler in _connectionEventHandler.values) {
      handler.onDisconnected?.call();
    }
  }

  Future<void> _onUserDidLoginFromOtherDevice(String deviceName) async {
    for (var handler in _connectionEventHandler.values) {
      handler.onUserDidLoginFromOtherDevice?.call(deviceName);
    }
  }

  Future<void> _onUserDidRemoveFromServer() async {
    for (var handler in _connectionEventHandler.values) {
      handler.onUserDidRemoveFromServer?.call();
    }
  }

  Future<void> _onUserDidForbidByServer() async {
    for (var handler in _connectionEventHandler.values) {
      handler.onUserDidForbidByServer?.call();
    }
  }

  Future<void> _onUserDidChangePassword() async {
    for (var handler in _connectionEventHandler.values) {
      handler.onUserDidChangePassword?.call();
    }
  }

  Future<void> _onUserDidLoginTooManyDevice() async {
    for (var handler in _connectionEventHandler.values) {
      handler.onUserDidLoginTooManyDevice?.call();
    }
  }

  Future<void> _onUserKickedByOtherDevice() async {
    for (var handler in _connectionEventHandler.values) {
      handler.onUserKickedByOtherDevice?.call();
    }
  }

  Future<void> _onUserAuthenticationFailed() async {
    for (var handler in _connectionEventHandler.values) {
      handler.onDisconnected?.call();
    }
  }

  void _onTokenWillExpire(Map? map) {
    for (var item in _connectionEventHandler.values) {
      item.onTokenWillExpire?.call();
    }
  }

  void _onTokenDidExpire(Map? map) {
    for (var item in _connectionEventHandler.values) {
      item.onTokenDidExpire?.call();
    }
  }

  void _onAppActiveNumberReachLimit(Map? map) {
    for (var item in _connectionEventHandler.values) {
      item.onAppActiveNumberReachLimit?.call();
    }
  }

  Future<void> _onMultiDeviceGroupEvent(Map map) async {
    ChatMultiDevicesEvent event =
        convertIntToChatMultiDevicesEvent(map['event'])!;
    String target = map['target'];
    List<String>? users = map.getList("users");

    for (var handler in _multiDeviceEventHandler.values) {
      handler.onGroupEvent?.call(event, target, users);
    }
  }

  Future<void> _onMultiDeviceContactEvent(Map map) async {
    ChatMultiDevicesEvent event =
        convertIntToChatMultiDevicesEvent(map['event'])!;
    String target = map['target'];
    String? ext = map['ext'];

    for (var handler in _multiDeviceEventHandler.values) {
      handler.onContactEvent?.call(event, target, ext);
    }
  }

  Future<void> _onMultiDeviceThreadEvent(Map map) async {
    ChatMultiDevicesEvent event =
        convertIntToChatMultiDevicesEvent(map['event'])!;
    String target = map['target'] ?? '';
    List<String>? users = map.getList("users");

    for (var handler in _multiDeviceEventHandler.values) {
      handler.onChatThreadEvent?.call(event, target, users ?? []);
    }
  }

  Future<void> _onMultiDeviceRoamMessagesRemovedEvent(Map map) async {
    String convId = map['convId'];
    String deviceId = map['deviceId'];
    for (var handler in _multiDeviceEventHandler.values) {
      handler.onRemoteMessagesRemoved?.call(convId, deviceId);
    }
  }

  Future<void> _onMultiDevicesConversationEvent(Map map) async {
    ChatMultiDevicesEvent event =
        convertIntToChatMultiDevicesEvent(map['event'])!;
    String convId = map['convId'];
    ChatConversationType type = conversationTypeFromInt(map['convType']);
    for (var handler in _multiDeviceEventHandler.values) {
      handler.onConversationEvent?.call(event, convId, type);
    }
  }

  void _onReceiveCustomData(Map map) {
    customEventHandler?.call(map);
  }

  ///
  /// Gets the [ChatManager] class. Make sure to call it after ChatClient has been initialized.
  ///
  /// **Return** The `ChatManager` class.
  ///
  ///
  ///
  ChatManager get chatManager {
    return _chatManager;
  }

  ///
  /// Gets the [ChatContactManager] class. Make sure to call it after the ChatClient has been initialized.
  ///
  /// **Return** The `ChatContactManager` class.
  ///
  ///
  ///
  ChatContactManager get contactManager {
    return _contactManager;
  }

  ///
  /// Gets the [ChatRoomManager] class. Make sure to call it after the ChatClient has been initialized.
  ///
  /// **Return** The `ChatRoomManager` class.
  ///
  ///
  ///
  ChatRoomManager get chatRoomManager {
    return _chatRoomManager;
  }

  ///
  /// Gets the [ChatGroupManager] class. Make sure to call it after the ChatClient has been initialized.
  ///
  /// **Return** The `ChatGroupManager` class.
  ///
  ///
  ///
  ChatGroupManager get groupManager {
    return _groupManager;
  }

  ///
  /// Gets the [ChatPushManager] class. Make sure to call it after the ChatClient has been initialized.
  ///
  /// **Return** The `ChatPushManager` class.
  ///
  ///
  ///
  ChatPushManager get pushManager {
    return _pushManager;
  }

  ///
  /// Gets the [ChatUserInfoManager] class. Make sure to call it after the ChatClient has been initialized.
  ///
  /// **Return** The `ChatUserInfoManager` class.
  ///
  ///
  ///
  ChatUserInfoManager get userInfoManager {
    return _userInfoManager;
  }

  ///
  /// Gets the [ChatThreadManager] class. Make sure to call it after the ChatClient has been initialized.
  ///
  /// **Return** The `ChatThreadManager` class.
  ///
  ///
  ///
  ChatThreadManager get chatThreadManager {
    return _chatThreadManager;
  }

  ///
  /// Gets the [ChatPresenceManager] class. Make sure to call it after the ChatClient has been initialized.
  ///
  /// **Return** The `ChatPresenceManager` class.
  ///
  ///
  ///
  ChatPresenceManager get presenceManager {
    return _presenceManager;
  }

  void _clearAllInfo() {
    _currentUserId = null;
    _userInfoManager.clearUserInfoCache();
  }
}
