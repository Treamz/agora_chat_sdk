import '../internal/inner_headers.dart';

///
/// The ChatGroup class, which contains the information of the chat group.
///
///
///
class ChatGroup {
  ChatGroup._private({
    required this.groupId,
    this.name,
    this.description,
    this.owner,
    this.announcement,
    this.memberCount,
    this.memberList,
    this.adminList,
    this.blockList,
    this.muteList,
    this.messageBlocked,
    this.isAllMemberMuted,
    this.permissionType,
    this.maxUserCount,
    this.isMemberOnly,
    this.isMemberAllowToInvite,
    this.extension,
    this.isDisabled = false,
  });

  ///
  /// Gets the group ID.
  ///
  ///
  ///
  final String groupId;

  ///
  /// Gets the group name.
  ///
  /// **Note**
  /// To get the correct value, ensure that you call [ChatGroupManager.fetchGroupInfoFromServer] before calling this method.
  ///
  ///
  ///
  final String? name;

  ///
  /// Gets the group description.
  ///
  /// **Note**
  /// To get the correct value, ensure that you call [ChatGroupManager.fetchGroupInfoFromServer] before calling this method.
  ///
  ///
  ///
  final String? description;

  ///
  /// Gets the user ID of the group owner.
  ///
  /// **Note**
  /// To get the correct value, ensure that you call [ChatGroupManager.fetchGroupInfoFromServer] before calling this method.
  ///
  ///
  ///
  final String? owner;

  ///
  ///  The content of the group announcement.
  ///
  ///
  ///
  final String? announcement;

  ///
  /// Gets the member count of the group.
  ///
  /// **Note**
  /// To get the correct value, ensure that you call [ChatGroupManager.fetchGroupInfoFromServer] before calling this method.
  ///
  ///
  ///
  final int? memberCount;

  ///
  /// Gets the member list of the group.
  ///
  /// **Note**
  /// To get the correct value, ensure that you call [ChatGroupManager.fetchMemberListFromServer] before calling this method.
  ///
  ///
  ///
  final List<String>? memberList;

  ///
  /// Gets the admin list of the group.
  ///
  /// **Note**
  /// To get the correct value, ensure that you call [ChatGroupManager.fetchGroupInfoFromServer] before calling this method.
  ///
  ///
  ///
  final List<String>? adminList;

  ///
  /// Gets the block list of the group.
  ///
  /// If no block list is found from the server, the return may be empty.
  ///
  /// **Note**
  /// To get the correct value, ensure that you call [ChatGroupManager.fetchBlockListFromServer] before calling this method.
  ///
  ///
  ///
  final List<String>? blockList;

  ///
  /// Gets the mute list of the group.
  ///
  /// **Note**
  /// To get the correct value, ensure that you call [ChatGroupManager.fetchMuteListFromServer] before calling this method.
  ///
  ///
  ///
  final List<String>? muteList;

  ///
  /// Gets whether the group message is blocked.
  ///
  /// **Note**
  /// To get the correct value, ensure that you call [ChatGroupManager.fetchGroupInfoFromServer] before calling this method.
  ///
  ///
  ///
  final bool? messageBlocked;

  ///
  /// Gets Whether all members are muted.
  ///
  /// **Note**
  /// To get the correct value, ensure that you call [ChatGroupManager.fetchGroupInfoFromServer] before calling this method.
  ///
  ///
  ///
  final bool? isAllMemberMuted;

  /// @nodoc
  ChatGroupOptions? _options;

  ///
  /// Gets the current user's role in group.
  ///
  /// **Note**
  /// To get the correct value, ensure that you call [ChatGroupManager.fetchGroupInfoFromServer] before calling this method.
  ///
  ///
  ///
  final ChatGroupPermissionType? permissionType;

  ///
  /// Gets the maximum number of group members allowed in a group. The parameter is set when the group is created.
  ///
  /// **Note**
  /// To get the correct value, ensure that you call [ChatGroupManager.fetchGroupInfoFromServer] before calling this method.
  ///
  ///
  ///
  final int? maxUserCount;

  ///
  /// Checks whether users cannot join a chat group freely:
  /// - `true`: Yes. Needs the approval from the group owner(admin) or being invited by group members(PrivateOnlyOwnerInvite, PrivateMemberCanInvite, PublicJoinNeedApproval).
  /// - `false`: No. Users can join freely [ChatGroupStyle.PublicOpenJoin].
  ///
  /// **Note**
  /// There are four types of group properties used to define the style of a group: [ChatGroupStyle].
  ///
  /// **Return**
  /// Whether users can join a chat group with only the approval of the group owner(admin):
  /// - `true`: Yes. Needs the approval from the group owner(admin) or being invited by group members.
  /// - `false`: No.
  ///
  ///
  ///
  final bool? isMemberOnly;

  ///
  /// Checks whether a group member is allowed to invite other users to join the group.
  ///
  /// **Note**
  /// To get the correct value, ensure that you call [ChatGroupManager.fetchGroupInfoFromServer] before calling this method.
  ///
  /// **Return**
  /// - `true`: Yes;
  /// - `false`: No. Only the group owner or admin can invite others to join the group.
  ///
  ///
  ///
  final bool? isMemberAllowToInvite;

  ///
  /// Group detail extensions which can be in the JSON format to contain more group information.
  ///
  ///
  ///
  final String? extension;

  ///
  /// Whether the group is disabled. The default value for reading or pulling roaming messages from the database is NO
  ///
  ///
  ///
  final bool isDisabled;

  @Deprecated(
      "Switch to using isMemberOnly | isMemberAllowToInvite | maxUserCount to instead")
  ChatGroupOptions? get settings => _options;

  /// @nodoc
  factory ChatGroup.fromJson(Map map) {
    String groupId = map['groupId'];
    String? name = map["name"];
    String? description = map["desc"];
    String? owner = map["owner"];
    String? announcement = map["announcement"];
    int? memberCount = map["memberCount"];
    List<String>? memberList = map.getList("memberList");
    List<String>? adminList = map.getList("adminList");
    List<String>? blockList = map.getList("blockList");
    List<String>? muteList = map.getList("muteList");
    bool? messageBlocked = map["messageBlocked"];
    bool? isAllMemberMuted = map["isAllMemberMuted"];
    ChatGroupPermissionType? permissionType =
        permissionTypeFromInt(map['permissionType']);
    int? maxUserCount = map["maxUserCount"];
    bool? isMemberOnly = map["isMemberOnly"];
    bool? isMemberAllowToInvite = map["isMemberAllowToInvite"];
    bool? isDisabled = map["isDisabled"];
    String? extension = map["ext"];

    return ChatGroup._private(
      groupId: groupId,
      name: name,
      description: description,
      owner: owner,
      announcement: announcement,
      memberCount: memberCount,
      memberList: memberList,
      adminList: adminList,
      blockList: blockList,
      muteList: muteList,
      messageBlocked: messageBlocked,
      isAllMemberMuted: isAllMemberMuted,
      permissionType: permissionType,
      maxUserCount: maxUserCount,
      isMemberOnly: isMemberOnly,
      isMemberAllowToInvite: isMemberAllowToInvite,
      extension: extension,
      isDisabled: isDisabled ?? false,
    );
  }

  /// @nodoc
  Map toJson() {
    Map data = Map();
    data.putIfNotNull("groupId", groupId);
    data.putIfNotNull("name", name);
    data.putIfNotNull("desc", description);
    data.putIfNotNull("owner", owner);
    data.putIfNotNull("announcement", announcement);
    data.putIfNotNull("memberCount", memberCount);
    data.putIfNotNull("memberList", memberList);
    data.putIfNotNull("adminList", adminList);
    data.putIfNotNull("blockList", blockList);
    data.putIfNotNull("muteList", muteList);
    data.putIfNotNull("messageBlocked", messageBlocked);
    data.putIfNotNull("isDisabled", isDisabled);
    data.putIfNotNull("isAllMemberMuted", isAllMemberMuted);
    data.putIfNotNull("options", _options?.toJson());
    data.putIfNotNull("permissionType", permissionTypeToInt(permissionType));
    return data;
  }

  @override
  String toString() {
    return this.toJson().toString();
  }
}

///
/// The class that defines basic information of chat groups.
///
///
///
class ChatGroupInfo {
  ///
  /// The group ID.
  ///
  ///
  ///
  final String groupId;

  ///
  /// The group name.
  ///
  ///
  ///
  final String? name;

  ChatGroupInfo._private({
    required this.groupId,
    required this.name,
  });

  factory ChatGroupInfo.fromJson(Map map) {
    String groupId = map["groupId"];
    String? groupName = map["name"];
    return ChatGroupInfo._private(
      groupId: groupId,
      name: groupName,
    );
  }
}
