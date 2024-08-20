// ignore_for_file: deprecated_member_use_from_same_package

import "dart:async";

import 'package:flutter/services.dart';
import 'internal/inner_headers.dart';

///
/// The chat room manager class, which manages user joining and exiting the chat room, retrieving the chat room list, and managing member privileges.
/// The sample code for joining a chat room:
/// ```dart
///   try {
///       await ChatClient.getInstance.chatRoomManager.joinChatRoom(chatRoomId);
///   } on ChatError catch (e) {
///       debugPrint(e.toString());
///   }
/// ```
///
///
///
class ChatRoomManager {
  static const _channelPrefix = 'com.chat.im';
  static const MethodChannel _channel = const MethodChannel(
      '$_channelPrefix/chat_room_manager', JSONMethodCodec());

  /// @nodoc
  ChatRoomManager() {
    _channel.setMethodCallHandler((MethodCall call) async {
      Map? argMap = call.arguments;
      if (call.method == ChatMethodKeys.chatRoomChange) {
        return _chatRoomChange(argMap!);
      }
      return null;
    });
  }

  final Map<String, ChatRoomEventHandler> _eventHandlesMap = {};

  Future<void> _chatRoomChange(Map event) async {
    String? type = event['type'];

    for (var item in _eventHandlesMap.values) {
      switch (type) {
        case ChatRoomEvent.ON_CHAT_ROOM_DESTROYED:
          String roomId = event['roomId'];
          String? roomName = event['roomName'];
          item.onChatRoomDestroyed?.call(roomId, roomName);
          break;
        case ChatRoomEvent.ON_MEMBER_JOINED:
          String roomId = event['roomId'];
          String participant = event['participant'];
          item.onMemberJoinedFromChatRoom?.call(roomId, participant);
          break;
        case ChatRoomEvent.ON_MEMBER_EXITED:
          String roomId = event['roomId'];
          String? roomName = event['roomName'];
          String participant = event['participant'];
          item.onMemberExitedFromChatRoom?.call(roomId, roomName, participant);
          break;
        case ChatRoomEvent.ON_REMOVED_FROM_CHAT_ROOM:
          String roomId = event['roomId'];
          String? roomName = event['roomName'];
          String participant = event['participant'];
          LeaveReason? reason;
          int iReason = event['reason'] ?? -1;
          if (iReason == 0) {
            reason = LeaveReason.Kicked;
          } else if (iReason == 2) {
            reason = LeaveReason.Offline;
          }
          item.onRemovedFromChatRoom
              ?.call(roomId, roomName, participant, reason);
          break;
        case ChatRoomEvent.ON_MUTE_LIST_ADDED:
          String roomId = event['roomId'];
          List<String> mutes = List.from(event['mutes'] ?? []);
          String? expireTime = event['expireTime'];
          item.onMuteListAddedFromChatRoom?.call(roomId, mutes, expireTime);
          break;
        case ChatRoomEvent.ON_MUTE_LIST_REMOVED:
          String roomId = event['roomId'];
          List<String> mutes = List.from(event['mutes'] ?? []);
          item.onMuteListRemovedFromChatRoom?.call(roomId, mutes);
          break;
        case ChatRoomEvent.ON_ADMIN_ADDED:
          String roomId = event['roomId'];
          String admin = event['admin'];
          item.onAdminAddedFromChatRoom?.call(roomId, admin);
          break;
        case ChatRoomEvent.ON_ADMIN_REMOVED:
          String roomId = event['roomId'];
          String admin = event['admin'];
          item.onAdminRemovedFromChatRoom?.call(roomId, admin);
          break;
        case ChatRoomEvent.ON_OWNER_CHANGED:
          String roomId = event['roomId'];
          String newOwner = event['newOwner'];
          String oldOwner = event['oldOwner'];
          item.onOwnerChangedFromChatRoom?.call(roomId, newOwner, oldOwner);
          break;
        case ChatRoomEvent.ON_ANNOUNCEMENT_CHANGED:
          String roomId = event['roomId'];
          String announcement = event['announcement'];
          item.onAnnouncementChangedFromChatRoom?.call(roomId, announcement);
          break;
        case ChatRoomEvent.ON_WHITE_LIST_ADDED:
          String roomId = event['roomId'];
          List<String> members = List.from(event["whitelist"] ?? []);
          item.onAllowListAddedFromChatRoom?.call(roomId, members);
          break;
        case ChatRoomEvent.ON_WHITE_LIST_REMOVED:
          String roomId = event['roomId'];
          List<String> members = List.from(event["whitelist"] ?? []);
          item.onAllowListRemovedFromChatRoom?.call(roomId, members);
          break;
        case ChatRoomEvent.ON_ALL_MEMBER_MUTE_STATE_CHANGED:
          String roomId = event['roomId'];
          bool isAllMuted = event['isMuted'];
          item.onAllChatRoomMemberMuteStateChanged?.call(roomId, isAllMuted);
          break;
        case ChatRoomEvent.ON_SPECIFICATION_CHANGED:
          ChatRoom room = ChatRoom.fromJson(event["room"]);
          item.onSpecificationChanged?.call(room);
          break;
        case ChatRoomEvent.ON_ATTRIBUTES_UPDATED:
          String roomId = event['roomId'];
          Map<String, String> attributes =
              event["attributes"].cast<String, String>();
          String fromId = event["fromId"];
          item.onAttributesUpdated?.call(
            roomId,
            attributes,
            fromId,
          );
          break;
        case ChatRoomEvent.ON_ATTRIBUTES_REMOVED:
          String roomId = event['roomId'];
          List<String> keys = event["keys"].cast<String>();
          String fromId = event["fromId"];
          item.onAttributesRemoved?.call(
            roomId,
            keys,
            fromId,
          );
          break;
      }
    }
  }

  ///
  /// Adds the room event handler. After calling this method, you can handle for new room event when they arrive.
  ///
  /// Param [identifier] The custom handler identifier, is used to find the corresponding handler.
  ///
  /// Param [handler] The handle for room event. See [ChatRoomEventHandler].
  ///
  ///
  ///
  void addEventHandler(
    String identifier,
    ChatRoomEventHandler handler,
  ) {
    _eventHandlesMap[identifier] = handler;
  }

  ///
  /// Remove the room event handler.
  ///
  /// Param [identifier] The custom handler identifier.
  ///
  ///
  ///
  void removeEventHandler(String identifier) {
    _eventHandlesMap.remove(identifier);
  }

  ///
  /// Get the room event handler.
  ///
  /// Param [identifier] The custom handler identifier.
  ///
  /// **Return** The room event handler.
  ///
  ///
  ///
  ChatRoomEventHandler? getEventHandler(String identifier) {
    return _eventHandlesMap[identifier];
  }

  ///
  /// Clear all room event handlers.
  ///
  ///
  ///
  void clearEventHandlers() {
    _eventHandlesMap.clear();
  }

  ///
  /// Joins the chat room.
  ///
  /// To exit the chat room, call [leaveChatRoom].
  ///
  /// Param [roomId] The ID of the chat room to join.
  ///
  /// **Throws** A description of the exception. See [ChatError].
  ///
  ///
  ///
  Future<void> joinChatRoom(String roomId) async {
    Map result = await _channel
        .invokeMethod(ChatMethodKeys.joinChatRoom, {"roomId": roomId});
    try {
      ChatError.hasErrorFromResult(result);
    } on ChatError catch (e) {
      throw e;
    }
  }

  ///
  /// Leaves the chat room.
  ///
  /// Param [roomId] The ID of the chat room to leave.
  ///
  /// **Throws** A description of the exception. See [ChatError].
  ///
  ///
  ///
  Future<void> leaveChatRoom(String roomId) async {
    Map result = await _channel
        .invokeMethod(ChatMethodKeys.leaveChatRoom, {"roomId": roomId});
    try {
      ChatError.hasErrorFromResult(result);
    } on ChatError catch (e) {
      throw e;
    }
  }

  ///
  /// Gets chat room data from the server with pagination.
  ///
  /// Param [pageNum] The page number, starting from 1.
  ///
  /// Param [pageSize] The number of records per page.
  ///
  /// **Return** Chat room data. See [ChatPageResult].
  ///
  /// **Throws** A description of the exception. See [ChatError].
  ///
  ///
  ///
  Future<ChatPageResult<ChatRoom>> fetchPublicChatRoomsFromServer({
    int pageNum = 1,
    int pageSize = 200,
  }) async {
    Map result = await _channel.invokeMethod(
        ChatMethodKeys.fetchPublicChatRoomsFromServer,
        {"pageNum": pageNum, "pageSize": pageSize});
    try {
      ChatError.hasErrorFromResult(result);
      return ChatPageResult<ChatRoom>.fromJson(
          result[ChatMethodKeys.fetchPublicChatRoomsFromServer],
          dataItemCallback: (map) {
        return ChatRoom.fromJson(map);
      });
    } on ChatError catch (e) {
      throw e;
    }
  }

  ///
  /// Gets the details of the chat room from the server.
  /// By default, the details do not include the chat room member list.
  ///
  /// Param [roomId] The chat room ID.
  ///
  /// **Return** The chat room instance.
  ///
  /// **Throws** A description of the exception. See [ChatError].
  ///
  ///
  ///
  Future<ChatRoom> fetchChatRoomInfoFromServer(
    String roomId, {
    bool fetchMembers = false,
  }) async {
    Map result = await _channel.invokeMethod(
        ChatMethodKeys.fetchChatRoomInfoFromServer,
        {"roomId": roomId, "fetchMembers": fetchMembers});
    try {
      ChatError.hasErrorFromResult(result);
      return ChatRoom.fromJson(
          result[ChatMethodKeys.fetchChatRoomInfoFromServer]);
    } on ChatError catch (e) {
      throw e;
    }
  }

  ///
  /// Gets the chat room in the cache.
  ///
  /// Param [roomId] The chat room ID.
  ///
  /// **Return** The chat room instance. Returns null if the chat room is not found in the cache.
  ///
  /// **Throws** A description of the exception. See [ChatError].
  ///
  ///
  ///
  Future<ChatRoom?> getChatRoomWithId(String roomId) async {
    Map result = await _channel
        .invokeMethod(ChatMethodKeys.getChatRoom, {"roomId": roomId});
    try {
      ChatError.hasErrorFromResult(result);
      if (result.containsKey(ChatMethodKeys.getChatRoom)) {
        return ChatRoom.fromJson(result[ChatMethodKeys.getChatRoom]);
      } else {
        return null;
      }
    } on ChatError catch (e) {
      throw e;
    }
  }

  ///
  /// Creates a chat room.
  ///
  /// Param [name] The chat room name.
  ///
  /// Param [desc] The chat room description.
  ///
  /// Param [welcomeMsg] A welcome message that invites users to join the chat room.
  ///
  /// Param [maxUserCount] The maximum number of members allowed to join the chat room.
  ///
  /// Param [members] The list of members invited to join the chat room.
  ///
  /// **Return** The chat room instance.
  ///
  /// **Throws** A description of the exception. See [ChatError].
  ///
  ///
  ///
  Future<ChatRoom> createChatRoom(
    String name, {
    String? desc,
    String? welcomeMsg,
    int maxUserCount = 300,
    List<String>? members,
  }) async {
    Map req = Map();
    req['subject'] = name;
    req['maxUserCount'] = maxUserCount;
    req.putIfNotNull("desc", desc);
    req.putIfNotNull("welcomeMsg", welcomeMsg);
    req.putIfNotNull("members", members);
    Map result =
        await _channel.invokeMethod(ChatMethodKeys.createChatRoom, req);
    try {
      ChatError.hasErrorFromResult(result);
      return ChatRoom.fromJson(result[ChatMethodKeys.createChatRoom]);
    } on ChatError catch (e) {
      throw e;
    }
  }

  ///
  /// Destroys a chat room.
  ///
  /// Only the chat room owner can call this method.
  ///
  /// Param [roomId] The chat room ID.
  ///
  /// **Throws** A description of the exception. See [ChatError].
  ///
  ///
  ///
  Future<void> destroyChatRoom(
    String roomId,
  ) async {
    Map req = {"roomId": roomId};
    Map result =
        await _channel.invokeMethod(ChatMethodKeys.destroyChatRoom, req);
    try {
      ChatError.hasErrorFromResult(result);
    } on ChatError catch (e) {
      throw e;
    }
  }

  ///
  /// Changes the chat room name.
  ///
  /// Only the chat room owner can call this method.
  ///
  /// Param [roomId] The chat room ID.
  ///
  /// Param [name] The new name of the chat room.
  ///
  /// **Throws** A description of the exception. See [ChatError].
  ///
  ///
  ///
  Future<void> changeChatRoomName(
    String roomId,
    String name,
  ) async {
    Map req = {"roomId": roomId, "subject": name};
    Map result =
        await _channel.invokeMethod(ChatMethodKeys.changeChatRoomSubject, req);
    try {
      ChatError.hasErrorFromResult(result);
    } on ChatError catch (e) {
      throw e;
    }
  }

  ///
  /// Modifies the chat room description.
  ///
  /// Only the chat room owner can call this method.
  ///
  /// Param [roomId] The chat room ID.
  ///
  /// Param [description] The new description of the chat room.
  ///
  /// **Throws** A description of the exception. See [ChatError].
  ///
  ///
  ///
  Future<void> changeChatRoomDescription(
    String roomId,
    String description,
  ) async {
    Map req = {"roomId": roomId, "description": description};
    Map result = await _channel.invokeMethod(
        ChatMethodKeys.changeChatRoomDescription, req);
    try {
      ChatError.hasErrorFromResult(result);
    } on ChatError catch (e) {
      throw e;
    }
  }

  ///
  /// Gets the chat room member list.
  ///
  /// Param [roomId] The chat room ID.
  ///
  /// Param [cursor] The cursor position from which to start getting data.
  ///
  /// Param [pageSize] The number of members per page.
  ///
  /// **Return** The list of chat room members. See [ChatCursorResult]. If [ChatCursorResult.cursor] is an empty string (""), all data is fetched.
  ///
  /// **Throws** A description of the exception. See [ChatError].
  ///
  ///
  ///
  Future<ChatCursorResult<String>> fetchChatRoomMembers(
    String roomId, {
    String? cursor,
    int pageSize = 200,
  }) async {
    Map req = {"roomId": roomId, "pageSize": pageSize};
    req.putIfNotNull("cursor", cursor);
    Map result =
        await _channel.invokeMethod(ChatMethodKeys.fetchChatRoomMembers, req);
    try {
      ChatError.hasErrorFromResult(result);
      return ChatCursorResult<String>.fromJson(
          result[ChatMethodKeys.fetchChatRoomMembers],
          dataItemCallback: (obj) => obj);
    } on ChatError catch (e) {
      throw e;
    }
  }

  ///
  /// Mutes the specified members in a chat room.
  ///
  /// Only the chat room owner or admin can call this method.
  ///
  /// Param [roomId] The chat room ID.
  ///
  /// Param [muteMembers] The list of members to be muted.
  ///
  /// Param [duration] The mute duration in milliseconds.
  ///
  /// **Throws** A description of the exception. See [ChatError].
  ///
  ///
  ///
  Future<void> muteChatRoomMembers(
    String roomId,
    List<String> muteMembers, {
    int duration = -1,
  }) async {
    Map req = {
      "roomId": roomId,
      "muteMembers": muteMembers,
      "duration": duration
    };
    Map result =
        await _channel.invokeMethod(ChatMethodKeys.muteChatRoomMembers, req);
    try {
      ChatError.hasErrorFromResult(result);
    } on ChatError catch (e) {
      throw e;
    }
  }

  ///
  /// Unmutes the specified members in a chat room.
  ///
  /// Only the chat room owner or admin can call this method.
  ///
  /// Param [roomId] The chat room ID.
  ///
  /// Param [unMuteMembers] The list of members to be unmuted.
  ///
  /// **Throws** A description of the exception. See [ChatError].
  ///
  ///
  ///
  Future<void> unMuteChatRoomMembers(
    String roomId,
    List<String> unMuteMembers,
  ) async {
    Map req = {"roomId": roomId, "unMuteMembers": unMuteMembers};
    Map result =
        await _channel.invokeMethod(ChatMethodKeys.unMuteChatRoomMembers, req);
    try {
      ChatError.hasErrorFromResult(result);
    } on ChatError catch (e) {
      throw e;
    }
  }

  ///
  /// Transfers the chat room ownership.
  ///
  /// Only the chat room owner can call this method.
  ///
  /// Param [roomId] The chat room ID.
  ///
  /// Param [newOwner] The ID of the new chat room owner.
  ///
  /// **Throws** A description of the exception. See [ChatError].
  ///
  ///
  ///
  Future<void> changeOwner(
    String roomId,
    String newOwner,
  ) async {
    Map req = {"roomId": roomId, "newOwner": newOwner};
    Map result =
        await _channel.invokeMethod(ChatMethodKeys.changeChatRoomOwner, req);
    try {
      ChatError.hasErrorFromResult(result);
    } on ChatError catch (e) {
      throw e;
    }
  }

  ///
  /// Adds a chat room admin.
  ///
  /// Only the chat room owner can call this method.
  ///
  /// Param [roomId] The chat room ID.
  ///
  /// Param [admin] The ID of the chat room admin to be added.
  ///
  /// **Throws** A description of the exception. See [ChatError].
  ///
  ///
  ///
  Future<void> addChatRoomAdmin(
    String roomId,
    String admin,
  ) async {
    Map req = {"roomId": roomId, "admin": admin};
    Map result =
        await _channel.invokeMethod(ChatMethodKeys.addChatRoomAdmin, req);
    try {
      ChatError.hasErrorFromResult(result);
    } on ChatError catch (e) {
      throw e;
    }
  }

  ///
  /// Removes privileges of a chat room admin.
  ///
  /// Param [roomId] The chat room ID.
  ///
  /// Param [admin] The ID of admin whose privileges are to be removed.
  ///
  /// **Throws** A description of the exception. See [ChatError].
  ///
  ///
  ///
  Future<void> removeChatRoomAdmin(
    String roomId,
    String admin,
  ) async {
    Map req = {"roomId": roomId, "admin": admin};
    Map result =
        await _channel.invokeMethod(ChatMethodKeys.removeChatRoomAdmin, req);
    try {
      ChatError.hasErrorFromResult(result);
    } on ChatError catch (e) {
      throw e;
    }
  }

  ///
  /// Gets the list of members who are muted in the chat room from the server.
  ///
  /// Only the chat room owner or admin can call this method.
  ///
  /// Param [roomId] The chat room ID.
  ///
  /// Param [pageNum] The page number, starting from 1.
  ///
  /// Param [pageSize] The number of muted members per page.
  ///
  /// **Return** The muted member list.
  ///
  /// **Throws** A description of the exception. See [ChatError].
  ///
  ///
  ///
  Future<List<String>> fetchChatRoomMuteList(
    String roomId, {
    int pageNum = 1,
    int pageSize = 200,
  }) async {
    Map req = {"roomId": roomId, "pageNum": pageNum, "pageSize": pageSize};
    Map result =
        await _channel.invokeMethod(ChatMethodKeys.fetchChatRoomMuteList, req);
    try {
      ChatError.hasErrorFromResult(result);
      return result[ChatMethodKeys.fetchChatRoomMuteList]?.cast<String>() ?? [];
    } on ChatError catch (e) {
      throw e;
    }
  }

  ///
  /// Removes the specified members from a chat room.
  ///
  /// Only the chat room owner or admin can call this method.
  ///
  /// Param [roomId] The chat room ID.
  ///
  /// Param [members] The list of the members to be removed.
  ///
  /// **Throws** A description of the exception. See [ChatError].
  ///
  ///
  ///
  Future<void> removeChatRoomMembers(
    String roomId,
    List<String> members,
  ) async {
    Map req = {"roomId": roomId, "members": members};
    Map result =
        await _channel.invokeMethod(ChatMethodKeys.removeChatRoomMembers, req);
    try {
      ChatError.hasErrorFromResult(result);
    } on ChatError catch (e) {
      throw e;
    }
  }

  ///
  /// Adds the specified members to the block list of the chat room.
  ///
  /// Only the chat room owner or admin can call this method.
  ///
  /// **Note**
  /// - Chat room members added to the block list are removed from the chat room by the server, and cannot re-join the chat room.
  /// - The removed members receive the [ChatRoomEventHandler.onRemovedFromChatRoom] callback.
  ///
  /// Param [roomId] The chat room ID.
  ///
  /// Param [members] The list of members to be added to block list.
  ///
  /// **Throws** A description of the exception. See [ChatError].
  ///
  ///
  ///
  Future<void> blockChatRoomMembers(
    String roomId,
    List members,
  ) async {
    Map req = {"roomId": roomId, "members": members};
    Map result =
        await _channel.invokeMethod(ChatMethodKeys.blockChatRoomMembers, req);
    try {
      ChatError.hasErrorFromResult(result);
    } on ChatError catch (e) {
      throw e;
    }
  }

  ///
  /// Removes the specified members from the block list of the chat room.
  ///
  /// Only the chat room owner or admin can call this method.
  ///
  /// Param [roomId] The chat room ID.
  ///
  /// Param [members] The list of members to be removed from the block list.
  ///
  /// **Throws** A description of the exception. See [ChatError].
  ///
  ///
  ///
  Future<void> unBlockChatRoomMembers(
    String roomId,
    List members,
  ) async {
    Map req = {"roomId": roomId, "members": members};
    Map result =
        await _channel.invokeMethod(ChatMethodKeys.unBlockChatRoomMembers, req);
    try {
      ChatError.hasErrorFromResult(result);
    } on ChatError catch (e) {
      throw e;
    }
  }

  ///
  /// Gets the chat room block list with pagination.
  ///
  /// Only the chat room owner or admin can call this method.
  ///
  /// Param [roomId] The chat room ID.
  ///
  /// Param [pageNum] The page number, starting from 1.
  ///
  /// Param [pageSize] The number of users on the block list per page.
  ///
  /// **Return** The list of the blocked chat room members.
  ///
  /// **Throws** A description of the exception. See [ChatError].
  ///
  ///
  ///
  Future<List<String>> fetchChatRoomBlockList(
    String roomId, {
    int pageNum = 1,
    int pageSize = 200,
  }) async {
    Map req = {"roomId": roomId, "pageNum": pageNum, "pageSize": pageSize};
    Map result =
        await _channel.invokeMethod(ChatMethodKeys.fetchChatRoomBlockList, req);
    try {
      ChatError.hasErrorFromResult(result);
      return result[ChatMethodKeys.fetchChatRoomBlockList]?.cast<String>() ??
          [];
    } on ChatError catch (e) {
      throw e;
    }
  }

  ///
  /// Updates the chat room announcement.
  ///
  /// Only the chat room owner or admin can call this method.
  ///
  /// Param [roomId] The chat room ID.
  ///
  /// Param [announcement] The announcement content.
  ///
  /// **Throws** A description of the exception. See [ChatError].
  ///
  ///
  ///
  Future<void> updateChatRoomAnnouncement(
    String roomId,
    String announcement,
  ) async {
    Map req = {"roomId": roomId, "announcement": announcement};
    Map result = await _channel.invokeMethod(
        ChatMethodKeys.updateChatRoomAnnouncement, req);
    try {
      ChatError.hasErrorFromResult(result);
    } on ChatError catch (e) {
      throw e;
    }
  }

  ///
  /// Gets the chat room announcement from the server.
  ///
  /// Param [roomId] The chat room ID.
  ///
  /// **Return** The chat room announcement.
  ///
  /// **Throws** A description of the exception. See [ChatError].
  ///
  ///
  ///
  Future<String?> fetchChatRoomAnnouncement(
    String roomId,
  ) async {
    Map req = {"roomId": roomId};
    Map result = await _channel.invokeMethod(
        ChatMethodKeys.fetchChatRoomAnnouncement, req);
    try {
      ChatError.hasErrorFromResult(result);
      return result[ChatMethodKeys.fetchChatRoomAnnouncement];
    } on ChatError catch (e) {
      throw e;
    }
  }

  ///
  /// Gets the allow list from the server.
  ///
  /// Only the chat room owner or admin can call this method.
  ///
  /// Param [roomId] The chat room ID.
  ///
  /// **Return** The chat room allow list.
  ///
  /// **Throws** A description of the exception. See [ChatError].
  ///
  ///
  ///
  Future<List<String>> fetchChatRoomAllowListFromServer(String roomId) async {
    Map req = {"roomId": roomId};
    Map result = await _channel.invokeMethod(
        ChatMethodKeys.fetchChatRoomWhiteListFromServer, req);

    try {
      ChatError.hasErrorFromResult(result);
      List<String> list = [];
      result[ChatMethodKeys.fetchChatRoomWhiteListFromServer]
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
  /// Checks whether the member is on the allow list.
  ///
  /// Param [roomId] The chat room ID.
  ///
  /// **Return** Whether the member is on the allow list.
  /// - `true`: Yes;
  /// - `false`: No.
  /// **Throws** A description of the exception. See [ChatError].
  ///
  ///
  ///
  Future<bool> isMemberInChatRoomAllowList(String roomId) async {
    Map req = {"roomId": roomId};
    Map result = await _channel.invokeMethod(
        ChatMethodKeys.isMemberInChatRoomWhiteListFromServer, req);

    try {
      ChatError.hasErrorFromResult(result);
      return result
          .boolValue(ChatMethodKeys.isMemberInChatRoomWhiteListFromServer);
    } on ChatError catch (e) {
      throw e;
    }
  }

  ///
  /// Adds members to the allowlist.
  ///
  /// Only the chat room owner or admin can call this method.
  ///
  /// Param [roomId] The chat room ID.
  ///
  /// Param [members] The list of members to be added to the allow list.
  ///
  /// **Throws** A description of the exception. See [ChatError].
  ///
  ///
  ///
  Future<void> addMembersToChatRoomAllowList(
    String roomId,
    List<String> members,
  ) async {
    Map req = {
      "roomId": roomId,
      "members": members,
    };
    Map result = await _channel.invokeMethod(
      ChatMethodKeys.addMembersToChatRoomWhiteList,
      req,
    );

    try {
      ChatError.hasErrorFromResult(result);
    } on ChatError catch (e) {
      throw e;
    }
  }

  ///
  /// Removes members from the allow list.
  ///
  /// Only the chat room owner or admin can call this method.
  ///
  /// Param [roomId] The chat room ID.
  ///
  /// Param [members] The list of members to be removed from the allow list.
  ///
  /// **Throws** A description of the exception. See [ChatError].
  ///
  ///
  ///
  Future<void> removeMembersFromChatRoomAllowList(
    String roomId,
    List<String> members,
  ) async {
    Map req = {
      "roomId": roomId,
      "members": members,
    };
    Map result = await _channel.invokeMethod(
      ChatMethodKeys.removeMembersFromChatRoomWhiteList,
      req,
    );
    try {
      ChatError.hasErrorFromResult(result);
    } on ChatError catch (e) {
      throw e;
    }
  }

  ///
  /// Mutes all members.
  ///
  /// Only the chat room owner or admin can call this method.
  ///
  /// This method does not work for the chat room owner, admin, and members added to the allow list.
  ///
  /// Param [roomId] The chat room ID.
  ///
  /// **Throws** A description of the exception. See [ChatError].
  ///
  ///
  ///
  Future<void> muteAllChatRoomMembers(String roomId) async {
    Map req = {"roomId": roomId};
    Map result = await _channel.invokeMethod(
      ChatMethodKeys.muteAllChatRoomMembers,
      req,
    );
    try {
      ChatError.hasErrorFromResult(result);
    } on ChatError catch (e) {
      throw e;
    }
  }

  ///
  /// Unmutes all members.
  ///
  /// Only the chat room owner or admin can call this method.
  ///
  /// Param [roomId] The chat room ID.
  ///
  /// **Throws** A description of the exception. See [ChatError].
  ///
  ///
  ///
  Future<void> unMuteAllChatRoomMembers(String roomId) async {
    Map req = {"roomId": roomId};
    Map result = await _channel.invokeMethod(
      ChatMethodKeys.unMuteAllChatRoomMembers,
      req,
    );
    try {
      ChatError.hasErrorFromResult(result);
    } on ChatError catch (e) {
      throw e;
    }
  }

  ///
  /// Gets the list of custom chat room attributes based on the attribute key list.
  ///
  /// Param [roomId] The chat room ID.
  ///
  /// Param [keys] The key list of attributes to get. If you set it as `null` or leave it empty, this method retrieves all custom attributes.
  ///
  /// **Return** The chat room attributes in key-value pairs.
  ///
  /// **Throws** A description of the exception. See [ChatError].
  ///
  ///
  ///
  Future<Map<String, String>?> fetchChatRoomAttributes({
    required String roomId,
    List<String>? keys,
  }) async {
    Map req = {
      "roomId": roomId,
    };

    if (keys != null) {
      req['keys'] = keys;
    }

    Map result = await _channel.invokeMethod(
      ChatMethodKeys.fetchChatRoomAttributes,
      req,
    );
    try {
      ChatError.hasErrorFromResult(result);
      return result[ChatMethodKeys.fetchChatRoomAttributes]
          ?.cast<String, String>();
    } on ChatError catch (e) {
      throw e;
    }
  }

  ///
  /// Sets custom chat room attributes.
  ///
  /// Param [roomId] The chat room ID.
  ///
  /// Param [attributes] The chat room attributes to add. The attributes are in key-value format.
  ///
  /// Note:
  /// In a key-value pair, the key is the attribute name that can contain 128 characters at most; the value is the attribute value that cannot exceed 4096 characters.
  /// A chat room can have a maximum of 100 custom attributes and the total length of custom chat room attributes cannot exceed 10 GB for each app. Attribute keys support the following character sets:
  /// * - 26 lowercase English letters (a-z)
  /// * - 26 uppercase English letters (A-Z)
  /// * - 10 numbers (0-9)
  /// * - "_", "-", "."
  ///
  /// Param [deleteWhenLeft] Whether to delete the chat room attributes set by the member when he or she exits the chat room.
  ///
  /// Param [overwrite] Whether to overwrite the attributes with same key set by others.
  ///
  /// **Return** `failureKeys map` is returned in key-value format, where the key is the attribute key and the value is the reason for the failure.
  ///
  /// **Throws** A description of the exception. See [ChatError].
  ///
  ///
  ///
  Future<Map<String, int>?> addAttributes(
    String roomId, {
    required Map<String, String> attributes,
    bool deleteWhenLeft = false,
    bool overwrite = false,
  }) async {
    Map req = {
      "roomId": roomId,
      "attributes": attributes,
      "autoDelete": deleteWhenLeft,
      "forced": overwrite,
    };

    Map result = await _channel.invokeMethod(
      ChatMethodKeys.setChatRoomAttributes,
      req,
    );
    try {
      ChatError.hasErrorFromResult(result);
      return result[ChatMethodKeys.setChatRoomAttributes]?.cast<String, int>();
    } on ChatError catch (e) {
      throw e;
    }
  }

  ///
  /// Removes custom chat room attributes.
  ///
  /// Param [roomId] The chat room ID.
  ///
  /// Param [keys] The keys of the custom chat room attributes to remove.
  ///
  /// Param [force] Whether to remove the attributes with same key set by others.
  ///
  /// **Return** `failureKeys map` is returned in key-value format, where the key is the attribute key and the value is the reason for the failure.
  ///
  /// **Throws** A description of the exception. See [ChatError].
  ///
  ///
  ///
  ///
  Future<Map<String, int>?> removeAttributes(
    String roomId, {
    required List<String> keys,
    bool force = false,
  }) async {
    Map req = {
      "roomId": roomId,
      "keys": keys,
      "forced": force,
    };

    Map result = await _channel.invokeMethod(
      ChatMethodKeys.removeChatRoomAttributes,
      req,
    );
    try {
      ChatError.hasErrorFromResult(result);
      return result[ChatMethodKeys.removeChatRoomAttributes]
          ?.cast<String, int>();
    } on ChatError catch (e) {
      throw e;
    }
  }
}