import '../internal/inner_headers.dart';

///
/// The chat room instance class.
///
/// **Note**
/// To get the correct value, ensure that you call [ChatRoomManager.fetchChatRoomInfoFromServer] before calling this method.
///
///
///
class ChatRoom {
  ChatRoom._private({
    required this.roomId,
    this.name,
    this.description,
    this.owner,
    this.announcement,
    this.memberCount,
    this.maxUsers,
    this.adminList,
    this.memberList,
    this.blockList,
    this.muteList,
    this.isAllMemberMuted,
    this.permissionType = ChatRoomPermissionType.None,
  });

  String toString() => toJson().toString();

  /// @nodoc
  factory ChatRoom.fromJson(Map<String, dynamic> map) {
    return ChatRoom._private(
        roomId: map["roomId"],
        name: map["name"],
        description: map["desc"],
        owner: map["owner"],
        memberCount: map["memberCount"],
        maxUsers: map["maxUsers"],
        adminList: map.getList("adminList"),
        memberList: map.getList("memberList"),
        blockList: map.getList("blockList"),
        muteList: map.getList("muteList"),
        announcement: map["announcement"],
        permissionType: chatRoomPermissionTypeFromInt(map["permissionType"]),
        isAllMemberMuted: map.boolValue("isAllMemberMuted"));
  }

  /// @nodoc
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['roomId'] = roomId;
    data.putIfNotNull("name", name);
    data.putIfNotNull("desc", description);
    data.putIfNotNull("owner", owner);
    data.putIfNotNull("memberCount", memberCount);
    data.putIfNotNull("maxUsers", maxUsers);
    data.putIfNotNull("adminList", adminList);
    data.putIfNotNull("memberList", memberList);
    data.putIfNotNull("blockList", blockList);
    data.putIfNotNull("muteList", muteList);
    data.putIfNotNull("announcement", announcement);
    data.putIfNotNull("isAllMemberMuted", isAllMemberMuted);
    data['permissionType'] = chatRoomPermissionTypeToInt(permissionType);

    return data;
  }

  ///
  /// Gets the chat room ID.
  ///
  /// **Note**
  /// To get the correct value, ensure that you call [ChatRoomManager.fetchChatRoomInfoFromServer] before calling this method.
  ///
  ///
  ///
  final String roomId;

  ///
  /// Gets the chat room name from the memory.
  ///
  /// **Note**
  /// To get the correct value, ensure that you call [ChatRoomManager.fetchChatRoomInfoFromServer] before calling this method.
  ///
  ///
  ///
  final String? name;

  ///
  /// Gets the chat room description from the memory.
  ///
  /// **Note**
  /// To get the correct value, ensure that you call [ChatRoomManager.fetchChatRoomInfoFromServer] before calling this method.
  ///
  ///
  ///
  final String? description;

  ///
  /// Gets the chat room owner ID. If this method returns an empty string, the SDK fails to get chat room details.
  ///
  /// **Note**
  /// To get the correct value, ensure that you call [ChatRoomManager.fetchChatRoomInfoFromServer] before calling this method.
  ///
  ///
  ///
  final String? owner;

  ///
  /// Gets the chat room announcement in the chat room from the memory.
  ///
  /// **Note**
  /// To get the correct value, ensure that you call [ChatRoomManager.fetchChatRoomAnnouncement] before calling this method. Otherwise, the return value may not be correct.
  ///
  ///
  ///
  final String? announcement;

  ///
  /// Gets the number of online members from the memory.
  ///
  /// **Note**
  /// To get the correct value, ensure that you call [ChatRoomManager.fetchChatRoomInfoFromServer] before calling this method.
  ///
  ///
  ///
  final int? memberCount;

  ///
  /// Gets the maximum number of members in the chat room from the memory, which is set/specified when the chat room is created.
  ///
  /// **Note**
  /// To get the correct value, ensure that you call [ChatRoomManager.fetchChatRoomInfoFromServer] before calling this method.
  ///
  ///
  ///
  final int? maxUsers;

  ///
  /// Gets the chat room admin list.
  ///
  /// **Note**
  /// To get the correct value, ensure that you call [ChatRoomManager.fetchChatRoomInfoFromServer] before calling this method.
  ///
  ///
  ///
  final List<String>? adminList;

  ///
  /// Gets the member list.
  ///
  /// **Note**
  /// To get the correct value, ensure that you call [ChatRoomManager.fetchChatRoomMembers].
  ///
  ///
  ///
  final List<String>? memberList;

  ///
  /// Gets the chat room block list.
  ///
  /// **Note**
  /// To get the block list, you can call [ChatRoomManager.fetchChatRoomBlockList].
  ///
  ///
  ///
  final List<String>? blockList;

  ///
  /// Gets the mute list of the chat room.
  ///
  /// **Note**
  /// To get the mute list, you can call [ChatRoomManager.fetchChatRoomMuteList].
  ///
  ///
  ///
  final List<String>? muteList;

  ///
  /// Checks whether all members are muted in the chat room from the memory.
  ///
  /// **Note**
  /// To get the correct value, ensure that you call [ChatRoomManager.fetchChatRoomInfoFromServer] before calling this method.
  ///
  ///
  ///
  final bool? isAllMemberMuted;

  ///
  /// Gets the current user's role in the chat room. The role types: [ChatRoomPermissionType].
  ///
  /// **Note**
  /// To get the correct value, ensure that you call [ChatRoomManager.fetchChatRoomInfoFromServer] before calling this method.
  ///
  ///
  ///
  final ChatRoomPermissionType permissionType;
}
