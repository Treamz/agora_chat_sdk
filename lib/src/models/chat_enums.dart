///
/// The group types.
///
///
///
enum ChatGroupStyle {
  ///
  /// Private groups where only the the group owner can invite users to join.
  ///
  ///
  ///
  PrivateOnlyOwnerInvite,

  ///
  /// Private groups where all group members can invite users to join.
  ///
  ///
  ///
  PrivateMemberCanInvite,

  ///
  /// Public groups where users can join only after receiving an invitation from the group owner(admin) or the joining request being approved by the  group owner(admin).
  ///
  ///
  ///
  PublicJoinNeedApproval,

  ///
  /// Public groups where users can join freely.
  ///
  ///
  ///
  PublicOpenJoin,
}

///
/// The conversation types.
///
///
///
enum ChatConversationType {
  ///
  /// One-to-one chat.
  ///
  ///
  ///
  Chat,

  ///
  /// Group chat.
  ///
  ///
  ///
  GroupChat,

  ///
  /// Chat room.
  ///
  ///
  ///
  ChatRoom,
}

///
/// The chat types.
///
/// There are three chat types: one-to-one chat, group chat, and chat room.
///
///
///
enum ChatType {
  ///
  /// One-to-one chat.
  ///
  ///
  ///
  Chat,

  ///
  /// Group chat.
  ///
  ///
  ///
  GroupChat,

  ///
  /// Chat room.
  ///
  ///
  ///
  ChatRoom,
}

///
/// The message directions.
///
/// Whether the message is sent or received.
///
///
///
enum MessageDirection {
  ///
  /// This message is sent from the local user.
  ///
  ///
  ///
  SEND,

  ///
  /// The message is received by the local user.
  ///
  ///
  ///
  RECEIVE,
}

///
/// The message sending/reception status.
///
///
///
enum MessageStatus {
  ///
  /// The message is created.
  ///
  ///
  ///
  CREATE,

  ///
  /// The message is being delivered/received.
  ///
  ///
  ///
  PROGRESS,

  ///
  /// The message is successfully delivered/received.
  ///
  ///
  ///
  SUCCESS,

  ///
  /// The message fails to be delivered/received.
  ///
  ///
  ///
  FAIL,
}

///
/// The download status of the attachment file.
///
///
///
enum DownloadStatus {
  ///
  /// The file message download is pending.
  ///
  ///
  ///
  PENDING,

  ///
  /// The file message is being downloaded.
  ///
  ///
  ///
  DOWNLOADING,

  ///
  /// The file message download succeeds.
  ///
  ///
  ///
  SUCCESS,

  ///
  /// The file message download fails.
  ///
  ///
  ///
  FAILED,
}

///
/// The message types.
///
///
///
enum MessageType {
  ///
  /// The text message.
  ///
  ///
  ///
  TXT,

  ///
  /// The image message.
  ///
  ///
  ///
  IMAGE,

  ///
  /// The video message.
  ///
  ///
  ///
  VIDEO,

  ///
  /// The location message.
  ///
  ///
  ///
  LOCATION,

  ///
  /// The voice message.
  ///
  ///
  ///
  VOICE,

  ///
  /// The file message.
  ///
  ///
  ///
  FILE,

  ///
  /// The command message.
  ///
  ///
  ///
  CMD,

  ///
  /// The custom message.
  ///
  ///
  ///
  CUSTOM,

  ///
  /// The combine message.
  ///
  ///
  ///
  COMBINE,
}

///
/// The group roles.
///
///
///
enum ChatGroupPermissionType {
  ///
  /// Unknown.
  ///
  ///
  ///
  None,

  ///
  /// The regular group member.
  ///
  ///
  ///
  Member,

  ///
  /// The group admin.
  ///
  ///
  ///
  Admin,

  ///
  /// The group owner.
  ///
  ///
  ///
  Owner,
}

///
/// The chat room roles.
///
///
///
enum ChatRoomPermissionType {
  ///
  /// Unknown.
  ///
  ///
  ///
  None,

  ///
  /// The regular chat room member.
  ///
  ///
  ///
  Member,

  ///
  /// The chat room admin.
  ///
  ///
  ///
  Admin,

  ///
  /// The chat room owner.
  ///
  ///
  ///
  Owner,
}

///
/// The message search directions.
///
///
///
enum ChatSearchDirection {
  ///
  /// Messages are retrieved in the reverse chronological order of when the server receives the message.
  ///
  ///
  ///
  Up,

  ///
  /// Messages are retrieved in the chronological order of when the server receives the message.
  ///
  ///
  ///
  Down,
}

///
/// Multi-device event types.
///
/// This enumeration takes user A logged into both DeviceA1 and DeviceA2 as an example to illustrate the various multi-device event types and when these events are triggered.
///
///
///

enum ChatMultiDevicesEvent {
  ///
  /// The current user removed a contact on another device.
  ///
  ///
  ///
  CONTACT_REMOVE,

  ///
  /// The current user accepted a friend request on another device.
  ///
  ///
  ///
  CONTACT_ACCEPT,

  ///
  /// The current user declined a friend request on another device.
  ///
  ///
  ///
  CONTACT_DECLINE,

  ///
  /// The current user added a contact to the block list on another device.
  ///
  ///
  ///
  CONTACT_BAN,

  ///
  /// The current user removed a contact from the block list on another device.
  ///
  ///
  ///
  CONTACT_ALLOW,

  ///
  /// The current user created a group on another device.
  ///
  ///
  ///
  GROUP_CREATE,

  ///
  /// The current user destroyed a group on another device.
  ///
  ///
  ///
  GROUP_DESTROY,

  ///
  /// The current user joined a group on another device.
  ///
  ///
  ///
  GROUP_JOIN,

  ///
  /// The current user left a group on another device.
  ///
  ///
  ///
  GROUP_LEAVE,

  ///
  /// The current user requested to join a group on another device.
  ///
  ///
  ///
  GROUP_APPLY,

  ///
  /// The current user accepted a group request on another device.
  ///
  ///
  ///
  GROUP_APPLY_ACCEPT,

  ///
  /// The current user declined a group request on another device.
  ///
  ///
  ///
  GROUP_APPLY_DECLINE,

  ///
  /// The current user invited a user to join the group on another device.
  ///
  ///
  ///
  GROUP_INVITE,

  ///
  /// The current user accepted a group invitation on another device.
  ///
  ///
  ///
  GROUP_INVITE_ACCEPT,

  ///
  /// The current user declined a group invitation on another device.
  ///
  ///
  ///
  GROUP_INVITE_DECLINE,

  ///
  /// The current user kicked a member out of a group on another device.
  ///
  ///
  ///
  GROUP_KICK,

  ///
  /// The current user added a member to a group block list on another device.
  ///
  ///
  ///
  GROUP_BAN,

  ///
  /// The current user removed a member from a group block list on another device.
  ///
  ///
  ///
  GROUP_ALLOW,

  ///
  /// The current user blocked a group on another device.
  ///
  ///
  ///
  GROUP_BLOCK,

  ///
  /// The current user unblocked a group on another device.
  ///
  ///
  ///
  GROUP_UNBLOCK,

  ///
  /// The current user transferred the group ownership on another device.
  ///
  ///
  ///
  GROUP_ASSIGN_OWNER,

  ///
  /// The current user added an admin on another device.
  ///
  ///
  ///
  GROUP_ADD_ADMIN,

  ///
  /// The current user removed an admin on another device.
  ///
  ///
  ///
  GROUP_REMOVE_ADMIN,

  ///
  /// The current user muted a member on another device.
  ///
  ///
  ///
  GROUP_ADD_MUTE,

  ///
  /// The current user unmuted a member on another device.
  ///
  ///
  ///
  GROUP_REMOVE_MUTE,

  ///
  /// The current user added on allow list on another device.
  ///
  ///
  ///
  GROUP_ADD_USER_ALLOW_LIST,

  ///
  /// The current user removed on allow list on another device.
  ///
  ///
  ///
  GROUP_REMOVE_USER_ALLOW_LIST,

  ///
  /// The current user are group ban on another device.
  ///
  ///
  ///
  GROUP_ALL_BAN,

  ///
  /// The current user are remove group ban on another device.
  ///
  ///
  ///
  GROUP_REMOVE_ALL_BAN,

  ///
  /// The current user are group disable on another device.
  ///
  ///
  ///
  GROUP_DISABLED,

  ///
  /// The current user are group able on another device.
  ///
  ///
  ///
  GROUP_ABLE,

  ///
  /// The current user modified custom attributes of a group member on another device.
  ///
  ///
  GROUP_MEMBER_ATTRIBUTES_CHANGED,

  ///
  /// The current user created a message thread on another device.
  ///
  ///
  ///
  CHAT_THREAD_CREATE,

  ///
  /// The current user destroyed a message thread on another device.
  ///
  ///
  ///
  CHAT_THREAD_DESTROY,

  ///
  /// The current user joined a message thread on another device.
  ///
  ///
  ///
  CHAT_THREAD_JOIN,

  ///
  /// The current user left a message thread on another device.
  ///
  ///
  ///
  CHAT_THREAD_LEAVE,

  ///
  /// The current user updated message thread information on another device.
  ///
  ///
  ///
  CHAT_THREAD_UPDATE,

  ///
  /// The current user kicked a member out of a message thread on another device.
  ///
  ///
  ///
  CHAT_THREAD_KICK,

  ///
  /// The current user pinned a conversation on another device.
  ///
  ///
  ///
  CONVERSATION_PINNED,

  ///
  /// The current user unpinned a conversation on another device.
  ///
  ///
  ///
  CONVERSATION_UNPINNED,

  ///
  /// The current user removed a conversation from the server.
  ///
  ///
  ///
  CONVERSATION_DELETE,
}

///
/// The message thread events.
///
///
///
enum ChatThreadOperation {
  ///
  /// The unknown type of message thread event.
  ///
  ///
  ///
  UnKnown,

  ///
  /// The message thread is created.
  ///
  ///
  ///
  Create,

  ///
  /// The message thread is updated.
  ///
  ///
  ///
  Update,

  ///
  /// The message thread is destroyed.
  ///
  ///
  ///
  Delete,

  ///
  /// The last reply in the message thread is updated.
  ///
  ///
  ///
  Update_Msg,
}

///
/// The push display styles.
///
///
///
enum DisplayStyle {
  ///
  /// A simple message is shown in the notification bar, for example, "You've got a new message.".
  ///
  ///
  ///
  Simple,

  ///
  /// The message content is shown in the notification bar.
  ///
  ///
  ///
  Summary,
}

///
/// The offline push settings.
///
///
///
enum ChatSilentModeParamType {
  ///
  /// The push notification mode.
  ///
  ///
  ///
  REMIND_TYPE,

  ///
  /// The DND duration.
  ///
  ///
  ///
  SILENT_MODE_DURATION,

  ///
  /// The DND time frame.
  ///
  ///
  ///
  SILENT_MODE_INTERVAL,
}

///
/// The push notification modes.
///
///
///
enum ChatPushRemindType {
  ///
  /// Receives push notifications for all offline messages.
  ///
  ///
  ///
  ALL,

  ///
  /// Only receives push notifications for mentioned messages.
  ///
  ///
  ///
  MENTION_ONLY,

  ///
  /// Do not receive push notifications for offline messages.
  ///
  ///
  ///
  NONE,
}

///
/// Chat room message priorities.
///
///
///
enum ChatRoomMessagePriority {
  ///
  /// High
  ///
  ///
  ///
  High,

  ///
  /// Normal
  ///
  ///
  ///
  Normal,

  ///
  /// Low
  ///
  ///
  ///
  Low,
}

///
/// Reaction operations.
///
///
///
enum ReactionOperate {
  ///
  /// Remove
  ///
  ///
  ///
  Remove,

  ///
  /// Add
  ///
  ///
  ///
  Add,
}

enum LeaveReason {
  Kicked,
  Offline,
}
