// ignore_for_file: deprecated_member_use_from_same_package

import 'dart:async';
import 'package:flutter/services.dart';
import 'internal/inner_headers.dart';

///
/// The group manager class, which manages group creation and deletion, user joining and exiting the group, etc.
///
///
///
class ChatGroupManager {
  static const _channelPrefix = 'com.chat.im';
  static const MethodChannel _channel = const MethodChannel(
      '$_channelPrefix/chat_group_manager', JSONMethodCodec());

  final Map<String, ChatGroupEventHandler> _eventHandlesMap = {};

  ///
  /// group shared file download callback.
  ///
  ///
  ///
  ChatDownloadCallback? downloadCallback;

  /// @nodoc
  ChatGroupManager() {
    _channel.setMethodCallHandler((MethodCall call) async {
      Map? argMap = call.arguments;
      if (call.method == ChatMethodKeys.onGroupChanged) {
        return _onGroupChanged(argMap);
      }
      return null;
    });
  }

  ///
  /// Adds the group event handler. After calling this method, you can handle for new group event when they arrive.
  ///
  /// Param [identifier] The custom handler identifier, is used to find the corresponding handler.
  ///
  /// Param [handler] The handle for group event. See [ChatGroupEventHandler].
  ///
  ///
  ///
  void addEventHandler(
    String identifier,
    ChatGroupEventHandler handler,
  ) {
    _eventHandlesMap[identifier] = handler;
  }

  ///
  /// Remove the group event handler.
  ///
  /// Param [identifier] The custom handler identifier.
  ///
  ///
  ///
  void removeEventHandler(String identifier) {
    _eventHandlesMap.remove(identifier);
  }

  ///
  /// Get the group event handler.
  ///
  /// Param [identifier] The custom handler identifier.
  ///
  /// **Return** The group event handler.
  ///
  ///
  ///
  ChatGroupEventHandler? getEventHandler(String identifier) {
    return _eventHandlesMap[identifier];
  }

  ///
  /// Clear all group event handlers.
  ///
  ///
  ///
  void clearEventHandlers() {
    _eventHandlesMap.clear();
  }

  ///
  /// Gets the group instance from the cache by group ID.
  ///
  /// Param [groupId] The group ID.
  ///
  /// **Return** The group instance. Returns null if the group does not exist.
  ///
  /// **Throws** A description of the exception. See [ChatError].
  ///
  ///
  ///
  Future<ChatGroup?> getGroupWithId(String groupId) async {
    Map req = {'groupId': groupId};
    Map result =
        await _channel.invokeMethod(ChatMethodKeys.getGroupWithId, req);
    try {
      ChatError.hasErrorFromResult(result);
      if (result.containsKey(ChatMethodKeys.getGroupWithId)) {
        return ChatGroup.fromJson(result[ChatMethodKeys.getGroupWithId]);
      } else {
        return null;
      }
    } on ChatError catch (e) {
      throw e;
    }
  }

  ///
  /// Gets all groups of the current user from the cache.
  ///
  /// **Return** The group list.
  ///
  /// **Throws** A description of the exception. See [ChatError].
  ///
  ///
  ///
  Future<List<ChatGroup>> getJoinedGroups() async {
    Map result = await _channel.invokeMethod(ChatMethodKeys.getJoinedGroups);
    try {
      ChatError.hasErrorFromResult(result);
      List<ChatGroup> list = [];
      result[ChatMethodKeys.getJoinedGroups]
          ?.forEach((element) => list.add(ChatGroup.fromJson(element)));
      return list;
    } on ChatError catch (e) {
      throw e;
    }
  }

  ///
  /// Gets all groups of the current user from the server.
  ///
  /// This method returns a group list which does not contain member information. If you want to update information of a group to include its member information, call [fetchGroupInfoFromServer].
  ///
  /// Param [pageSize] The size of groups per page.
  ///
  /// Param [pageNum] The page number.
  ///
  /// Param [needMemberCount] The return result contains the number of group members
  ///
  /// Param [needRole] The result contains the current user's role in the group
  ///
  /// **Return** The list of groups that the current user joins.
  ///
  /// **Throws** A description of the exception. See [ChatError].
  ///
  ///
  ///
  Future<List<ChatGroup>> fetchJoinedGroupsFromServer({
    int pageSize = 20,
    int pageNum = 0,
    bool needMemberCount = false,
    bool needRole = false,
  }) async {
    Map req = {
      'pageSize': pageSize,
      'pageNum': pageNum,
      "needMemberCount": needMemberCount,
      "needRole": needRole,
    };
    Map result = await _channel.invokeMethod(
        ChatMethodKeys.getJoinedGroupsFromServer, req);
    try {
      ChatError.hasErrorFromResult(result);
      List<ChatGroup> list = [];
      result[ChatMethodKeys.getJoinedGroupsFromServer]
          ?.forEach((element) => list.add(ChatGroup.fromJson(element)));
      return list;
    } on ChatError catch (e) {
      throw e;
    }
  }

  ///
  /// Gets public groups from the server with pagination.
  ///
  /// Param [pageSize] The number of public groups per page.
  ///
  /// Param [cursor] The cursor position from which to start to get data next time. Sets the parameter as null for the first time.
  ///
  /// **Return** The result of [ChatCursorResult], including the cursor for getting data next time and the group list.
  /// If [ChatCursorResult.cursor] is an empty string (""), all data is fetched.
  ///
  /// **Throws** A description of the exception. See [ChatError].
  ///
  ///
  ///
  Future<ChatCursorResult<ChatGroupInfo>> fetchPublicGroupsFromServer({
    int pageSize = 200,
    String? cursor,
  }) async {
    Map req = {'pageSize': pageSize};
    req.putIfNotNull("cursor", cursor);
    Map result = await _channel.invokeMethod(
        ChatMethodKeys.getPublicGroupsFromServer, req);
    try {
      ChatError.hasErrorFromResult(result);
      return ChatCursorResult<ChatGroupInfo>.fromJson(
          result[ChatMethodKeys.getPublicGroupsFromServer],
          dataItemCallback: (value) {
        return ChatGroupInfo.fromJson(value);
      });
    } on ChatError catch (e) {
      throw e;
    }
  }

  ///
  /// Creates a group instance.
  ///
  /// After the group is created, the data in the cache and database will be updated and multiple devices will receive the notification event and update the group data to the cache and database.
  /// You can set [ChatMultiDeviceEventHandler] to listen for the event. If an event occurs, the callback function
  /// [ChatMultiDeviceEventHandler.onGroupEvent] is triggered, where the first parameter is the event which is
  /// [ChatMultiDevicesEvent.GROUP_CREATE] for a group creation event.
  ///
  /// Param [groupName] The group name.
  ///
  /// Param [desc] The group description.
  ///
  /// Param [inviteMembers] The group member array. The group owner ID is optional.
  ///
  /// Param [inviteReason] The group joining invitation.
  ///
  /// Param [options] The options for creating a group. See [ChatGroupOptions].
  /// The options are as follows:
  /// - The maximum number of group members. The default value is 200.
  /// - The group style. See [ChatGroupStyle]. The default value is [ChatGroupStyle.PrivateOnlyOwnerInvite].
  /// - Whether to ask for permission when inviting a user to join the group. The default value is `false`, indicating that invitees are automatically added to the group without their permission.
  /// - The group detail extensions.
  ///
  /// **Return** The created group instance.
  ///
  /// **Throws** A description of the exception. See [ChatError].
  ///
  ///
  ///
  Future<ChatGroup> createGroup({
    String? groupName,
    String? desc,
    List<String>? inviteMembers,
    String? inviteReason,
    required ChatGroupOptions options,
  }) async {
    Map req = {'options': options.toJson()};
    req.putIfNotNull("groupName", groupName);
    req.putIfNotNull("desc", desc);
    req.putIfNotNull("inviteMembers", inviteMembers);
    req.putIfNotNull("inviteReason", inviteReason);

    Map result = await _channel.invokeMethod(ChatMethodKeys.createGroup, req);
    try {
      ChatError.hasErrorFromResult(result);
      return ChatGroup.fromJson(result[ChatMethodKeys.createGroup]);
    } on ChatError catch (e) {
      throw e;
    }
  }

  ///
  /// Gets the group information from the server.
  ///
  /// This method does not get member information. If member information is required, call [fetchMemberListFromServer].
  ///
  /// Param [groupId] The group ID.
  ///
  /// Param [fetchMembers] Whether to get group members. By default, a list of 200 members is fetched.
  ///
  /// **Return** The group instance.
  ///
  /// **Throws** A description of the exception. See [ChatError].
  ///
  ///
  ///
  Future<ChatGroup> fetchGroupInfoFromServer(
    String groupId, {
    bool fetchMembers = false,
  }) async {
    Map req = {"groupId": groupId, "fetchMembers": fetchMembers};
    Map result = await _channel.invokeMethod(
        ChatMethodKeys.getGroupSpecificationFromServer, req);
    try {
      ChatError.hasErrorFromResult(result);
      return ChatGroup.fromJson(
          result[ChatMethodKeys.getGroupSpecificationFromServer]);
    } on ChatError catch (e) {
      throw e;
    }
  }

  ///
  /// Gets the member list of the group with pagination.
  ///
  /// For example:
  ///   ```dart
  ///     ChatCursorResult<String> result = await ChatClient.getInstance.groupManager.fetchMemberListFromServer(groupId); // search 1
  ///     result = await ChatClient.getInstance.groupManager.fetchMemberListFromServer(groupId, cursor: result.cursor); // search 2
  ///   ```
  ///
  /// Param [groupId] The group ID.
  ///
  /// Param [pageSize] The number of group members per page.
  ///
  /// Param [cursor] The cursor position from which to start to get data next time. Sets the parameter as null for the first time.
  ///
  /// **Return** The result of [ChatCursorResult], including the cursor for getting data next time and the group member list.
  /// If [ChatCursorResult.cursor] is an empty string (""), all data is fetched.
  ///
  /// **Throws** A description of the exception. See [ChatError].
  ///
  ///
  ///
  Future<ChatCursorResult<String>> fetchMemberListFromServer(
    String groupId, {
    int pageSize = 200,
    String? cursor,
  }) async {
    Map req = {
      'groupId': groupId,
      'pageSize': pageSize,
    };
    req.putIfNotNull("cursor", cursor);
    Map result = await _channel.invokeMethod(
      ChatMethodKeys.getGroupMemberListFromServer,
      req,
    );
    try {
      ChatError.hasErrorFromResult(result);
      return ChatCursorResult<String>.fromJson(
          result[ChatMethodKeys.getGroupMemberListFromServer],
          dataItemCallback: (value) => value);
    } on ChatError catch (e) {
      throw e;
    }
  }

  ///
  /// Gets the group block list from server with pagination.
  ///
  /// Only the group owner or admin can call this method.
  ///
  /// Param [groupId] The group ID.
  ///
  /// Param [pageSize] The number of groups per page.
  ///
  /// Param [pageNum] The page number, starting from 1.
  ///
  /// **Return** The group block list.
  ///
  /// **Throws** A description of the exception. See [ChatError].
  ///
  ///
  ///
  Future<List<String>> fetchBlockListFromServer(
    String groupId, {
    int pageSize = 200,
    int pageNum = 1,
  }) async {
    Map req = {'groupId': groupId, 'pageNum': pageNum, 'pageSize': pageSize};
    Map result = await _channel.invokeMethod(
        ChatMethodKeys.getGroupBlockListFromServer, req);
    try {
      ChatError.hasErrorFromResult(result);
      return result[ChatMethodKeys.getGroupBlockListFromServer]
              ?.cast<String>() ??
          [];
    } on ChatError catch (e) {
      throw e;
    }
  }

  ///
  /// Gets the mute list of the group from the server.
  ///
  /// Only the group owner or admin can call this method.
  ///
  /// Param [groupId] The group ID.
  ///
  /// Param [pageSize] The number of muted members per page.
  ///
  /// Param [pageNum] The page number, starting from 1.
  ///
  /// **Return** The group mute map, key is memberId and value is mute time.
  ///
  /// **Throws** A description of the exception. See [ChatError].
  ///
  ///
  ///
  Future<Map<String, int>> fetchMuteListFromServer(
    String groupId, {
    int pageSize = 200,
    int pageNum = 1,
  }) async {
    Map req = {'groupId': groupId, 'pageNum': pageNum, 'pageSize': pageSize};
    Map result = await _channel.invokeMethod(
        ChatMethodKeys.getGroupMuteListFromServer, req);
    try {
      ChatError.hasErrorFromResult(result);
      Map? tmpMap = result[ChatMethodKeys.getGroupMuteListFromServer];
      Map<String, int> ret = {};
      if (tmpMap != null) {
        for (var item in tmpMap.entries) {
          if (item.key is String && item.value is int) {
            ret[item.key] = item.value;
          }
        }
      }
      return ret;
    } on ChatError catch (e) {
      throw e;
    }
  }

  ///
  /// Gets the allow list of the group from the server.
  ///
  /// Only the group owner or admin can call this method.
  ///
  /// Param [groupId] The group ID.
  ///
  /// **Return** The allow list of the group.
  ///
  /// **Throws** A description of the exception. See [ChatError].
  ///
  ///
  ///
  Future<List<String>> fetchAllowListFromServer(String groupId) async {
    Map req = {'groupId': groupId};
    Map result = await _channel.invokeMethod(
        ChatMethodKeys.getGroupWhiteListFromServer, req);
    try {
      List<String> list = [];
      ChatError.hasErrorFromResult(result);
      result[ChatMethodKeys.getGroupWhiteListFromServer]?.forEach((element) {
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
  /// Gets whether the member is on the allow list of the group.
  ///
  /// Param [groupId] The group ID.
  ///
  /// **Return** A Boolean value to indicate whether the current user is on the allow list of the group;
  ///
  /// **Throws** A description of the exception. See [ChatError].
  ///
  ///
  ///
  Future<bool> isMemberInAllowListFromServer(String groupId) async {
    Map req = {'groupId': groupId};
    Map result = await _channel.invokeMethod(
        ChatMethodKeys.isMemberInWhiteListFromServer, req);
    try {
      ChatError.hasErrorFromResult(result);
      return result.boolValue(ChatMethodKeys.isMemberInWhiteListFromServer);
    } on ChatError catch (e) {
      throw e;
    }
  }

  ///
  /// Gets the shared files of the group from the server.
  ///
  /// Param [groupId] The group ID.
  ///
  /// Param [pageSize] The number of shared files per page.
  ///
  /// Param [pageNum] The page number, starting from 1.
  ///
  /// **Return** The shared files.
  ///
  /// **Throws** A description of the exception. See [ChatError].
  ///
  ///
  ///
  Future<List<ChatGroupSharedFile>> fetchGroupFileListFromServer(
    String groupId, {
    int pageSize = 200,
    int pageNum = 1,
  }) async {
    Map req = {'groupId': groupId, 'pageNum': pageNum, 'pageSize': pageSize};
    Map result = await _channel.invokeMethod(
        ChatMethodKeys.getGroupFileListFromServer, req);
    try {
      ChatError.hasErrorFromResult(result);
      List<ChatGroupSharedFile> list = [];
      result[ChatMethodKeys.getGroupFileListFromServer]?.forEach((element) {
        list.add(ChatGroupSharedFile.fromJson(element));
      });
      return list;
    } on ChatError catch (e) {
      throw e;
    }
  }

  ///
  /// Gets the group announcement from the server.
  ///
  /// Group members can call this method.
  ///
  /// Param [groupId] The group ID.
  ///
  /// **Return** The group announcement.
  ///
  /// **Throws** A description of the exception. See [ChatError].
  ///
  ///
  ///
  Future<String?> fetchAnnouncementFromServer(String groupId) async {
    Map req = {'groupId': groupId};
    Map result = await _channel.invokeMethod(
        ChatMethodKeys.getGroupAnnouncementFromServer, req);
    try {
      ChatError.hasErrorFromResult(result);
      return result[ChatMethodKeys.getGroupAnnouncementFromServer];
    } on ChatError catch (e) {
      throw e;
    }
  }

  ///
  /// Adds users to the group.
  ///
  /// Only the group owner or admin can call this method.
  ///
  /// Param [groupId] The group ID.
  ///
  /// Param [members] The array of new members to add.
  ///
  /// Param [welcome] The welcome message.
  ///
  /// **Throws** A description of the exception. See [ChatError].
  ///
  ///
  ///
  Future<void> addMembers(
    String groupId,
    List<String> members, {
    String? welcome,
  }) async {
    Map req = {'groupId': groupId, 'members': members};
    req.putIfNotNull("welcome", welcome);
    Map result = await _channel.invokeMethod(ChatMethodKeys.addMembers, req);
    try {
      ChatError.hasErrorFromResult(result);
    } on ChatError catch (e) {
      throw e;
    }
  }

  ///
  /// Invites users to join the group.
  ///
  /// This method works only for groups with the style of [ChatGroupStyle.PrivateOnlyOwnerInvite], [ChatGroupStyle.PrivateMemberCanInvite], or [ChatGroupStyle.PublicJoinNeedApproval].
  /// For a group with the [ChatGroupStyle.PrivateOnlyOwnerInvite] style, only the group owner can invite users to join the group;
  /// For a group with the [ChatGroupStyle.PrivateMemberCanInvite] style, each group member can invite users to join the group.
  ///
  /// Param [groupId] The group ID.
  ///
  /// Param [members] The array of new members to invite.
  ///
  /// Param [reason] The invitation reason.
  ///
  /// **Throws** A description of the exception. See [ChatError].
  ///
  ///
  ///
  Future<void> inviterUser(
    String groupId,
    List<String> members, {
    String? reason,
  }) async {
    Map req = {
      'groupId': groupId,
      'members': members,
    };
    req.putIfNotNull("reason", reason);

    Map result = await _channel.invokeMethod(
      ChatMethodKeys.inviterUser,
      req,
    );

    try {
      ChatError.hasErrorFromResult(result);
    } on ChatError catch (e) {
      throw e;
    }
  }

  ///
  /// Removes a member from the group.
  ///
  /// Only the group owner or admin can call this method.
  ///
  /// Param [groupId] The group ID.
  ///
  /// Param [members] The username of the member to be removed.
  ///
  /// **Throws** A description of the exception. See [ChatError].
  ///
  ///
  ///
  Future<void> removeMembers(
    String groupId,
    List<String> members,
  ) async {
    Map req = {'groupId': groupId, 'members': members};
    Map result = await _channel.invokeMethod(ChatMethodKeys.removeMembers, req);
    try {
      ChatError.hasErrorFromResult(result);
    } on ChatError catch (e) {
      throw e;
    }
  }

  ///
  /// Adds the user to the block list of the group.
  ///
  /// Users will be first removed from the group they have joined before being added to the block list of the group. The users on the group block list cannot join the group again.
  ///
  /// Only the group owner or admin can call this method.
  ///
  /// Param [groupId] The group ID.
  ///
  /// Param [members] The list of users to be added to the block list.
  ///
  /// **Throws**  A description of the exception. See [ChatError].
  ///
  ///
  ///
  Future<void> blockMembers(
    String groupId,
    List<String> members,
  ) async {
    Map req = {'groupId': groupId, 'members': members};
    Map result = await _channel.invokeMethod(ChatMethodKeys.blockMembers, req);
    try {
      ChatError.hasErrorFromResult(result);
    } on ChatError catch (e) {
      throw e;
    }
  }

  ///
  /// Removes users from the group block list.
  ///
  /// Only the group owner or admin can call this method.
  ///
  /// Param [groupId] The group ID.
  ///
  /// Param [members] The users to be removed from the group block list.
  ///
  /// **Throws**  A description of the exception. See [ChatError].
  ///
  ///
  ///
  Future<void> unblockMembers(
    String groupId,
    List<String> members,
  ) async {
    Map req = {'groupId': groupId, 'members': members};
    Map result =
        await _channel.invokeMethod(ChatMethodKeys.unblockMembers, req);
    try {
      ChatError.hasErrorFromResult(result);
    } on ChatError catch (e) {
      throw e;
    }
  }

  ///
  /// Changes the group name.
  ///
  /// Only the group owner or admin can call this method.
  ///
  /// Param [groupId] The group ID.
  ///
  /// Param [name] The new group name.
  ///
  /// **Throws** A description of the exception. See [ChatError].
  ///
  ///
  ///
  Future<void> changeGroupName(
    String groupId,
    String name,
  ) async {
    Map req = {'name': name, 'groupId': groupId};
    Map result =
        await _channel.invokeMethod(ChatMethodKeys.updateGroupSubject, req);
    try {
      ChatError.hasErrorFromResult(result);
    } on ChatError catch (e) {
      throw e;
    }
  }

  ///
  /// Changes the group description.
  ///
  /// Only the group owner or admin can call this method.
  ///
  /// Param [groupId] The group ID.
  ///
  /// Param [desc] The new group description.
  ///
  /// **Throws** A description of the exception. See [ChatError].
  ///
  ///
  ///
  Future<void> changeGroupDescription(
    String groupId,
    String desc,
  ) async {
    Map req = {'desc': desc, 'groupId': groupId};
    Map result =
        await _channel.invokeMethod(ChatMethodKeys.updateDescription, req);
    try {
      ChatError.hasErrorFromResult(result);
    } on ChatError catch (e) {
      throw e;
    }
  }

  ///
  /// Leaves a group.
  ///
  /// Param [groupId] The group ID.
  ///
  /// **Throws** A description of the exception. See [ChatError].
  ///
  ///
  ///
  Future<void> leaveGroup(String groupId) async {
    Map req = {'groupId': groupId};
    Map result = await _channel.invokeMethod(ChatMethodKeys.leaveGroup, req);
    try {
      ChatError.hasErrorFromResult(result);
    } on ChatError catch (e) {
      throw e;
    }
  }

  ///
  /// Destroys the group instance.
  ///
  /// Only the group owner can call this method.
  ///
  /// Param [groupId] The group ID.
  ///
  /// **Throws** A description of the exception. See [ChatError].
  ///
  ///
  ///
  Future<void> destroyGroup(String groupId) async {
    Map req = {'groupId': groupId};
    Map result = await _channel.invokeMethod(ChatMethodKeys.destroyGroup, req);
    try {
      ChatError.hasErrorFromResult(result);
    } on ChatError catch (e) {
      throw e;
    }
  }

  ///
  /// Blocks group messages.
  ///
  /// The user that blocks group messages is still a group member, but can't receive group messages.
  ///
  /// Param [groupId] The group ID.
  ///
  /// **Throws** A description of the exception. See [ChatError].
  ///
  ///
  ///
  Future<void> blockGroup(String groupId) async {
    Map req = {'groupId': groupId};
    Map result = await _channel.invokeMethod(ChatMethodKeys.blockGroup, req);
    try {
      ChatError.hasErrorFromResult(result);
    } on ChatError catch (e) {
      throw e;
    }
  }

  ///
  /// Unblocks group messages.
  ///
  /// Param [groupId] The group ID.
  ///
  /// **Throws** A description of the exception. See [ChatError].
  ///
  ///
  ///
  Future<void> unblockGroup(String groupId) async {
    Map req = {'groupId': groupId};
    Map result = await _channel.invokeMethod(ChatMethodKeys.unblockGroup, req);
    try {
      ChatError.hasErrorFromResult(result);
    } on ChatError catch (e) {
      throw e;
    }
  }

  ///
  /// Transfers the group ownership.
  ///
  /// Only the group owner can call this method.
  ///
  /// Param [groupId] The group ID.
  ///
  /// Param [newOwner] The new owner ID.
  ///
  /// **Throws** A description of the exception. See [ChatError].
  ///
  ///
  ///
  Future<void> changeOwner(
    String groupId,
    String newOwner,
  ) async {
    Map req = {'groupId': groupId, 'owner': newOwner};
    Map result =
        await _channel.invokeMethod(ChatMethodKeys.updateGroupOwner, req);
    try {
      ChatError.hasErrorFromResult(result);
    } on ChatError catch (e) {
      throw e;
    }
  }

  ///
  /// Adds a group admin.
  ///
  /// Only the group owner can call this method and group admins cannot.
  ///
  /// Param [groupId] The group ID.
  ///
  /// Param [memberId] The username of the admin to add.
  ///
  /// **Throws** A description of the exception. See [ChatError].
  ///
  ///
  ///
  Future<void> addAdmin(
    String groupId,
    String memberId,
  ) async {
    Map req = {'groupId': groupId, 'admin': memberId};
    Map result = await _channel.invokeMethod(ChatMethodKeys.addAdmin, req);
    try {
      ChatError.hasErrorFromResult(result);
    } on ChatError catch (e) {
      throw e;
    }
  }

  ///
  /// Removes a group admin.
  ///
  /// Only the group owner can call this method.
  ///
  /// Param [groupId] The group ID.
  ///
  /// Param [adminId] The username of the admin to remove.
  ///
  /// **Throws** A description of the exception. See [ChatError].
  ///
  ///
  ///
  Future<void> removeAdmin(
    String groupId,
    String adminId,
  ) async {
    Map req = {'groupId': groupId, 'admin': adminId};
    Map result = await _channel.invokeMethod(ChatMethodKeys.removeAdmin, req);
    try {
      ChatError.hasErrorFromResult(result);
    } on ChatError catch (e) {
      throw e;
    }
  }

  ///
  /// Mutes group members.
  ///
  /// Only the group owner or admin can call this method.
  ///
  /// Param [groupId] The group ID.
  ///
  /// Param [members] The list of members to be muted.
  ///
  /// Param [duration] The mute duration in milliseconds.
  ///
  /// **Throws** A description of the exception. See [ChatError].
  ///
  ///
  ///
  Future<void> muteMembers(
    String groupId,
    List<String> members, {
    int duration = -1,
  }) async {
    Map req = {'groupId': groupId, 'members': members, 'duration': duration};
    Map result = await _channel.invokeMethod(ChatMethodKeys.muteMembers, req);
    try {
      ChatError.hasErrorFromResult(result);
    } on ChatError catch (e) {
      throw e;
    }
  }

  ///
  /// Unmutes group members.
  ///
  /// Only the group owner or admin can call this method.
  ///
  /// Param [groupId] The group ID.
  ///
  /// Param [members] The list of members to be muted.
  ///
  /// **Throws** A description of the exception. See [ChatError].
  ///
  ///
  ///
  Future<void> unMuteMembers(
    String groupId,
    List<String> members,
  ) async {
    Map req = {'groupId': groupId, 'members': members};
    Map result = await _channel.invokeMethod(ChatMethodKeys.unMuteMembers, req);
    try {
      ChatError.hasErrorFromResult(result);
    } on ChatError catch (e) {
      throw e;
    }
  }

  ///
  /// Mutes all members.
  ///
  /// Only the group owner or admin can call this method.
  ///
  /// Param [groupId] The group ID.
  ///
  /// **Throws** A description of the exception. See [ChatError].
  ///
  ///
  ///
  Future<void> muteAllMembers(String groupId) async {
    Map req = {'groupId': groupId};
    Map result =
        await _channel.invokeMethod(ChatMethodKeys.muteAllMembers, req);
    try {
      ChatError.hasErrorFromResult(result);
    } on ChatError catch (e) {
      throw e;
    }
  }

  ///
  /// Unmutes all members.
  ///
  /// Only the group owner or admin can call this method.
  ///
  /// Param [groupId] The group ID.
  ///
  /// **Throws** A description of the exception. See [ChatError].
  ///
  ///
  ///
  Future<void> unMuteAllMembers(String groupId) async {
    Map req = {'groupId': groupId};
    Map result =
        await _channel.invokeMethod(ChatMethodKeys.unMuteAllMembers, req);
    try {
      ChatError.hasErrorFromResult(result);
    } on ChatError catch (e) {
      throw e;
    }
  }

  ///
  /// Adds members to the allow list of the group.
  ///
  /// Only the group owner or admin can call this method.
  ///
  /// Param [groupId] The group ID.
  ///
  /// Param [members] The members to be added to the allow list of the group.
  ///
  /// **Throws** A description of the exception. See [ChatError].
  ///
  ///
  ///
  Future<void> addAllowList(
    String groupId,
    List<String> members,
  ) async {
    Map req = {'groupId': groupId, 'members': members};
    Map result = await _channel.invokeMethod(ChatMethodKeys.addWhiteList, req);
    try {
      ChatError.hasErrorFromResult(result);
    } on ChatError catch (e) {
      throw e;
    }
  }

  ///
  /// Removes members from the allow list of the group.
  ///
  /// Only the group owner or admin can call this method.
  ///
  /// Param [groupId] The group ID.
  ///
  /// Param [members] The members to be removed from the allow list of the group.
  ///
  /// **Throws** A description of the exception. See [ChatError].
  ///
  ///
  ///
  Future<void> removeAllowList(
    String groupId,
    List<String> members,
  ) async {
    Map req = {'groupId': groupId, 'members': members};
    Map result =
        await _channel.invokeMethod(ChatMethodKeys.removeWhiteList, req);
    try {
      ChatError.hasErrorFromResult(result);
    } on ChatError catch (e) {
      throw e;
    }
  }

  ///
  /// Uploads the shared file to the group.
  ///
  /// When a shared file is uploaded, the upload progress callback will be triggered.
  ///
  /// Param [groupId] The group ID.
  ///
  /// Param [filePath] The local path of the shared file.
  ///
  /// **Throws** A description of the exception. See [ChatError].
  ///
  ///
  ///
  Future<void> uploadGroupSharedFile(
    String groupId,
    String filePath,
  ) async {
    Map req = {'groupId': groupId, 'filePath': filePath};
    Map result =
        await _channel.invokeMethod(ChatMethodKeys.uploadGroupSharedFile, req);
    try {
      ChatError.hasErrorFromResult(result);
    } on ChatError catch (e) {
      throw e;
    }
  }

  ///
  /// Downloads the shared file of the group.
  ///
  /// Note: The callback is only used for progress callback.
  ///
  /// Param [groupId] The group ID.
  ///
  /// Param [fileId] The ID of the shared file.
  ///
  /// Param [savePath] The local path of the shared file.
  ///
  /// **Throws** A description of the exception. See [ChatError].
  ///
  ///
  ///
  Future<void> downloadGroupSharedFile({
    required String groupId,
    required String fileId,
    required String savePath,
  }) async {
    Map req = {'groupId': groupId, 'fileId': fileId, 'savePath': savePath};
    Map result = await _channel.invokeMethod(
        ChatMethodKeys.downloadGroupSharedFile, req);
    try {
      ChatError.hasErrorFromResult(result);
    } on ChatError catch (e) {
      throw e;
    }
  }

  ///
  /// Removes a shared file of the group.
  ///
  /// Group members can delete their own uploaded files. The group owner or admin can delete all shared files.
  ///
  /// Param [groupId] The group ID.
  ///
  /// Param [fileId] The ID of the shared file.
  ///
  /// **Throws** A description of the exception. See [ChatError].
  ///
  ///
  ///
  Future<void> removeGroupSharedFile(
    String groupId,
    String fileId,
  ) async {
    Map req = {'groupId': groupId, 'fileId': fileId};
    Map result =
        await _channel.invokeMethod(ChatMethodKeys.removeGroupSharedFile, req);
    try {
      ChatError.hasErrorFromResult(result);
    } on ChatError catch (e) {
      throw e;
    }
  }

  ///
  /// Updates the group announcement.
  ///
  /// Only the group owner or admin can call this method.
  ///
  /// Param [groupId] The group ID.
  ///
  /// Param [announcement] The group announcement.
  ///
  /// **Throws** A description of the exception. See [ChatError].
  ///
  ///
  ///
  Future<void> updateGroupAnnouncement(
    String groupId,
    String announcement,
  ) async {
    Map req = {'groupId': groupId, 'announcement': announcement};
    Map result = await _channel.invokeMethod(
        ChatMethodKeys.updateGroupAnnouncement, req);
    try {
      ChatError.hasErrorFromResult(result);
    } on ChatError catch (e) {
      throw e;
    }
  }

  ///
  /// Updates the group extension field.
  ///
  /// Only the group owner or admin can call this method.
  ///
  /// Param [groupId] The group ID.
  ///
  /// Param [extension] The group extension field.
  ///
  /// **Throws** A description of the exception. See [ChatError].
  ///
  ///
  ///
  Future<void> updateGroupExtension(
    String groupId,
    String extension,
  ) async {
    Map req = {'groupId': groupId, 'ext': extension};
    Map result =
        await _channel.invokeMethod(ChatMethodKeys.updateGroupExt, req);
    try {
      ChatError.hasErrorFromResult(result);
    } on ChatError catch (e) {
      throw e;
    }
  }

  ///
  /// Joins a public group.
  ///
  /// For a group that requires no authentication，users can join it freely without obtaining permissions from the group owner.
  /// For a group that requires authentication, users need to wait for the group owner to agree before joining the group. For details, See [ChatGroupStyle].
  ///
  /// Param [groupId] The group ID.
  ///
  /// **Throws** A description of the exception. See [ChatError].
  ///
  ///
  ///
  Future<void> joinPublicGroup(
    String groupId,
  ) async {
    Map req = {'groupId': groupId};
    Map result =
        await _channel.invokeMethod(ChatMethodKeys.joinPublicGroup, req);
    try {
      ChatError.hasErrorFromResult(result);
    } on ChatError catch (e) {
      throw e;
    }
  }

  ///
  /// Requests to join a group.
  ///
  /// This method works only for public groups requiring authentication, i.e., groups with the style of [ChatGroupStyle.PublicJoinNeedApproval].
  ///
  /// Param [groupId] The group ID.
  ///
  /// Param [reason] The reason for requesting to join the group.
  ///
  /// **Throws** A description of the exception. See [ChatError].
  ///
  ///
  ///
  Future<void> requestToJoinPublicGroup(
    String groupId, {
    String? reason,
  }) async {
    Map req = {'groupId': groupId};
    req.putIfNotNull('reason', reason);
    Map result = await _channel.invokeMethod(
        ChatMethodKeys.requestToJoinPublicGroup, req);
    try {
      ChatError.hasErrorFromResult(result);
    } on ChatError catch (e) {
      throw e;
    }
  }

  ///
  /// Approves a group request.
  ///
  /// Only the group owner or admin can call this method.
  ///
  /// Param [groupId] The group ID.
  ///
  /// Param [username] The username of the user who sends a request to join the group.
  ///
  /// **Throws** A description of the exception. See [ChatError].
  ///
  ///
  ///
  Future<void> acceptJoinApplication(
    String groupId,
    String username,
  ) async {
    Map req = {'groupId': groupId, 'username': username};
    Map result =
        await _channel.invokeMethod(ChatMethodKeys.acceptJoinApplication, req);
    try {
      ChatError.hasErrorFromResult(result);
    } on ChatError catch (e) {
      throw e;
    }
  }

  ///
  /// Declines a group request.
  ///
  /// Only the group owner or admin can call this method.
  ///
  /// Param [groupId] The group ID.
  ///
  /// Param [username] The username of the user who sends a request to join the group.
  ///
  /// Param [reason] The reason of declining.
  ///
  /// **Throws** A description of the exception. See [ChatError].
  ///
  ///
  ///
  Future<void> declineJoinApplication(
    String groupId,
    String username, {
    String? reason,
  }) async {
    Map req = {'groupId': groupId, 'username': username};
    req.putIfNotNull('reason', reason);

    Map result =
        await _channel.invokeMethod(ChatMethodKeys.declineJoinApplication, req);
    try {
      ChatError.hasErrorFromResult(result);
    } on ChatError catch (e) {
      throw e;
    }
  }

  ///
  /// Accepts a group invitation.
  ///
  /// Param [groupId] The group ID.
  ///
  /// Param [inviter] The user who initiates the invitation.
  ///
  /// **Return** The group instance which the user has accepted the invitation to join.
  ///
  /// **Throws** A description of the exception. See [ChatError].
  ///
  ///
  ///
  Future<ChatGroup> acceptInvitation(
    String groupId,
    String inviter,
  ) async {
    Map req = {'groupId': groupId, 'inviter': inviter};
    Map result = await _channel.invokeMethod(
        ChatMethodKeys.acceptInvitationFromGroup, req);
    try {
      ChatError.hasErrorFromResult(result);
      return ChatGroup.fromJson(
          result[ChatMethodKeys.acceptInvitationFromGroup]);
    } on ChatError catch (e) {
      throw e;
    }
  }

  ///
  /// Declines a group invitation.
  ///
  /// Param [groupId] The group ID.
  ///
  /// Param [inviter] The username of the inviter.
  ///
  /// Param [reason] The reason of declining.
  ///
  /// **Throws** A description of the exception. See [ChatError].
  ///
  ///
  ///
  Future<void> declineInvitation({
    required String groupId,
    required String inviter,
    String? reason,
  }) async {
    Map req = {'groupId': groupId, 'inviter': inviter};
    req.putIfNotNull('reason', reason);
    Map result = await _channel.invokeMethod(
        ChatMethodKeys.declineInvitationFromGroup, req);
    try {
      ChatError.hasErrorFromResult(result);
    } on ChatError catch (e) {
      throw e;
    }
  }

  ///
  /// Sets custom attributes of a group member.
  ///
  /// Param [groupId] The group ID.
  ///
  /// Param [userId] The user ID of the group member for whom the custom attributes are set. The default value is the current user ID.
  ///
  /// Param [attributes] The map of custom attributes in key-value format.
  /// In a key-value pair, if the value is set to an empty string, the custom attribute will be deleted.
  ///
  /// **Throws** A description of the exception. See [ChatError].
  ///
  ///
  ///
  Future<void> setMemberAttributes({
    required String groupId,
    required Map<String, String> attributes,
    String? userId,
  }) async {
    Map req = {
      'groupId': groupId,
    };
    if (userId != null) {
      req.putIfNotNull('userId', userId);
    }
    req.putIfNotNull('attributes', attributes);
    Map result = await _channel.invokeMethod(
        ChatMethodKeys.setMemberAttributesFromGroup, req);
    try {
      ChatError.hasErrorFromResult(result);
    } on ChatError catch (e) {
      throw e;
    }
  }

  ///
  /// Removes custom attributes of a group member.
  ///
  /// Param [groupId] The group ID.
  ///
  /// Param [keys] The keys of custom attributes to remove.
  ///
  /// Param [userId] The user ID of the group member for whom the custom attributes are removed. The default value is the current user ID.
  ///
  /// **Throws** A description of the exception. See [ChatError].
  ///
  ///
  ///
  Future<void> removeMemberAttributes({
    required String groupId,
    required List<String> keys,
    String? userId,
  }) async {
    Map req = {
      'groupId': groupId,
    };
    if (userId != null) {
      req.putIfNotNull('userId', userId);
    }
    req.putIfNotNull('keys', keys);
    Map result = await _channel.invokeMethod(
        ChatMethodKeys.removeMemberAttributesFromGroup, req);
    try {
      ChatError.hasErrorFromResult(result);
    } on ChatError catch (e) {
      throw e;
    }
  }

  ///
  /// Gets all custom attributes of a group member.
  ///
  /// Param [groupId] The group ID.
  ///
  /// Param [userId] The user ID of the group member whose all custom attributes are retrieved. The default value is the current user ID.
  ///
  /// **Return** The user attributes of the group member.
  ///
  /// **Throws** A description of the exception. See [ChatError].
  ///
  ///
  ///
  Future<Map<String, String>> fetchMemberAttributes({
    required String groupId,
    String? userId,
  }) async {
    Map req = {'groupId': groupId};
    if (userId != null) {
      req.putIfNotNull('userId', userId);
    }
    Map result = await _channel.invokeMethod(
        ChatMethodKeys.fetchMemberAttributesFromGroup, req);
    try {
      ChatError.hasErrorFromResult(result);
      Map<String, String> ret = {};
      result[ChatMethodKeys.fetchMemberAttributesFromGroup]
          .forEach((key, value) {
        ret[key] = value;
      });
      return ret;
    } on ChatError catch (e) {
      throw e;
    }
  }

  ///
  /// Gets custom attributes of multiple group members by attribute key.
  ///
  /// Param [groupId] The group ID.
  ///
  /// Param [userIds] The array of user IDs of group members whose custom attributes are retrieved. You can pass in a maximum of 10 user IDs.
  ///
  /// Param [keys] The array of keys of custom attributes to be retrieved.
  ///
  /// **Return** The users attributes.
  ///
  /// **Throws** A description of the exception. See [ChatError].
  ///
  ///
  ///
  ///
  Future<Map<String, Map<String, String>>> fetchMembersAttributes({
    required String groupId,
    required List<String> userIds,
    List<String>? keys,
  }) async {
    Map req = {'groupId': groupId, 'userIds': userIds};
    req.putIfNotNull("keys", keys);
    Map result = await _channel.invokeMethod(
        ChatMethodKeys.fetchMembersAttributesFromGroup, req);
    try {
      ChatError.hasErrorFromResult(result);
      var map = result[ChatMethodKeys.fetchMembersAttributesFromGroup];
      Map<String, Map<String, String>> ret = {};
      if (map is Map) {
        map.keys.forEach((element) {
          if (map[element] is Map) {
            Map<String, String> value =
                Map<String, String>.from(map[element] ?? {});
            ret[element] = value;
          }
        });
      }
      return ret;
    } on ChatError catch (e) {
      throw e;
    }
  }

  Future<void> _onGroupChanged(Map? map) async {
    var type = map!['type'];
    _eventHandlesMap.values.forEach((element) {
      switch (type) {
        case ChatGroupChangeEvent.ON_INVITATION_RECEIVED:
          String groupId = map['groupId'];
          String? groupName = map['groupName'];
          String inviter = map['inviter'];
          String? reason = map['reason'];
          element.onInvitationReceivedFromGroup
              ?.call(groupId, groupName, inviter, reason);
          break;
        case ChatGroupChangeEvent.ON_INVITATION_ACCEPTED:
          String groupId = map['groupId'];
          String invitee = map['invitee'];
          String? reason = map['reason'];
          element.onInvitationAcceptedFromGroup?.call(groupId, invitee, reason);
          break;
        case ChatGroupChangeEvent.ON_INVITATION_DECLINED:
          String groupId = map['groupId'];
          String invitee = map['invitee'];
          String? reason = map['reason'];
          element.onInvitationDeclinedFromGroup?.call(groupId, invitee, reason);
          break;
        case ChatGroupChangeEvent.ON_AUTO_ACCEPT_INVITATION:
          String groupId = map['groupId'];
          String inviter = map['inviter'];
          String? inviteMessage = map['inviteMessage'];
          element.onAutoAcceptInvitationFromGroup
              ?.call(groupId, inviter, inviteMessage);
          break;
        case ChatGroupChangeEvent.ON_USER_REMOVED:
          String groupId = map['groupId'];
          String? groupName = map['groupName'];
          element.onUserRemovedFromGroup?.call(groupId, groupName);
          break;
        case ChatGroupChangeEvent.ON_REQUEST_TO_JOIN_RECEIVED:
          String groupId = map['groupId'];
          String? groupName = map['groupName'];
          String applicant = map['applicant'];
          String? reason = map['reason'];
          element.onRequestToJoinReceivedFromGroup
              ?.call(groupId, groupName, applicant, reason);
          break;
        case ChatGroupChangeEvent.ON_REQUEST_TO_JOIN_DECLINED:
          String groupId = map['groupId'];
          String? groupName = map['groupName'];
          String decliner = map['decliner'];
          String? reason = map['reason'];
          element.onRequestToJoinDeclinedFromGroup
              ?.call(groupId, groupName, decliner, reason);
          break;
        case ChatGroupChangeEvent.ON_REQUEST_TO_JOIN_ACCEPTED:
          String groupId = map['groupId'];
          String? groupName = map['groupName'];
          String accepter = map['accepter'];
          element.onRequestToJoinAcceptedFromGroup
              ?.call(groupId, groupName, accepter);
          break;
        case ChatGroupChangeEvent.ON_GROUP_DESTROYED:
          String groupId = map['groupId'];
          String? groupName = map['groupName'];
          element.onGroupDestroyed?.call(groupId, groupName);
          break;
        case ChatGroupChangeEvent.ON_MUTE_LIST_ADDED:
          String groupId = map['groupId'];
          List<String> mutes = List.from(map['mutes'] ?? []);
          int? muteExpire = map['muteExpire'];
          element.onMuteListAddedFromGroup?.call(groupId, mutes, muteExpire);
          break;
        case ChatGroupChangeEvent.ON_MUTE_LIST_REMOVED:
          String groupId = map['groupId'];
          List<String> mutes = List.from(map['mutes'] ?? []);
          element.onMuteListRemovedFromGroup?.call(groupId, mutes);
          break;
        case ChatGroupChangeEvent.ON_ADMIN_ADDED:
          String groupId = map['groupId'];
          String administrator = map['administrator'];
          element.onAdminAddedFromGroup?.call(groupId, administrator);
          break;
        case ChatGroupChangeEvent.ON_ADMIN_REMOVED:
          String groupId = map['groupId'];
          String administrator = map['administrator'];
          element.onAdminRemovedFromGroup?.call(groupId, administrator);
          break;
        case ChatGroupChangeEvent.ON_OWNER_CHANGED:
          String groupId = map['groupId'];
          String newOwner = map['newOwner'];
          String oldOwner = map['oldOwner'];
          element.onOwnerChangedFromGroup?.call(groupId, newOwner, oldOwner);
          break;
        case ChatGroupChangeEvent.ON_MEMBER_JOINED:
          String groupId = map['groupId'];
          String member = map['member'];
          element.onMemberJoinedFromGroup?.call(groupId, member);
          break;
        case ChatGroupChangeEvent.ON_MEMBER_EXITED:
          String groupId = map['groupId'];
          String member = map['member'];
          element.onMemberExitedFromGroup?.call(groupId, member);
          break;
        case ChatGroupChangeEvent.ON_ANNOUNCEMENT_CHANGED:
          String groupId = map['groupId'];
          String announcement = map['announcement'];
          element.onAnnouncementChangedFromGroup?.call(groupId, announcement);
          break;
        case ChatGroupChangeEvent.ON_SHARED_FILE_ADDED:
          String groupId = map['groupId'];
          ChatGroupSharedFile sharedFile =
              ChatGroupSharedFile.fromJson(map['sharedFile']);
          element.onSharedFileAddedFromGroup?.call(groupId, sharedFile);
          break;
        case ChatGroupChangeEvent.ON_SHARED_FILE__DELETED:
          String groupId = map['groupId'];
          String fileId = map['fileId'];
          element.onSharedFileDeletedFromGroup?.call(groupId, fileId);
          break;
        case ChatGroupChangeEvent.ON_WHITE_LIST_ADDED:
          String groupId = map["groupId"];
          List<String> members = List.from(map['whitelist'] ?? []);
          element.onAllowListAddedFromGroup?.call(groupId, members);
          break;
        case ChatGroupChangeEvent.ON_WHITE_LIST_REMOVED:
          String groupId = map["groupId"];
          List<String> members = List.from(map['whitelist'] ?? []);
          element.onAllowListRemovedFromGroup?.call(groupId, members);
          break;
        case ChatGroupChangeEvent.ON_ALL_MEMBER_MUTE_STATE_CHANGED:
          String groupId = map["groupId"];
          bool isAllMuted = map["isMuted"] as bool;
          element.onAllGroupMemberMuteStateChanged?.call(groupId, isAllMuted);
          break;
        case ChatGroupChangeEvent.ON_SPECIFICATION_DID_UPDATE:
          ChatGroup group = ChatGroup.fromJson(map["group"]);
          element.onSpecificationDidUpdate?.call(group);
          break;
        case ChatGroupChangeEvent.ON_STATE_CHANGED:
          String groupId = map["groupId"];
          bool isDisable = map["isDisabled"] as bool;
          element.onDisableChanged?.call(groupId, isDisable);
          break;
        case ChatGroupChangeEvent.ON_ATTRIBUTES_CHANGED_OF_MEMBER:
          String groupId = map["groupId"];
          String userId = map["userId"];
          Map<String, String>? attributes =
              map["attributes"].cast<String, String>();
          String? operatorId = map["operatorId"];
          element.onAttributesChangedOfGroupMember?.call(
            groupId,
            userId,
            attributes,
            operatorId,
          );
      }
    });
  }
}
