import 'package:flutter/material.dart';
import 'package:agora_chat_sdk/agora_chat_sdk.dart';

///
/// The connection event handler.
///
/// For the occasion of onDisconnected during unstable network condition, you don't need to reconnect manually,
/// the chat SDK will handle it automatically.
///
/// Note: We recommend not to update UI based on those methods, because this method is called on worker thread. If you update UI in those methods, other UI errors might be invoked.
/// Also do not insert heavy computation work here, which might invoke other listeners to handle this connection event.
///
/// Adds connection event handler:
/// ```dart
///   ChatClient.getInstance.addConnectionEventHandler(UNIQUE_HANDLER_ID, ConnectionEventHandler());
/// ```
///
/// Remove a connection event handler:
/// ```dart
///   ChatClient.getInstance.removeConnectionEventHandler(UNIQUE_HANDLER_ID);
/// ```
///
///
///
class ConnectionEventHandler {
  ///
  /// Occurs when the SDK connects to the chat server successfully.
  ///
  ///
  ///
  final VoidCallback? onConnected;

  ///
  /// Occurs when the SDK disconnect from the chat server.
  ///
  /// Note that the logout may not be performed at the bottom level when the SDK is disconnected.
  ///
  ///
  ///
  final VoidCallback? onDisconnected;

  ///
  /// Occurs when the current user account is logged in to another device.
  ///
  ///
  ///
  final void Function(String deviceName)? onUserDidLoginFromOtherDevice;

  ///
  /// Occurs when the current chat user is removed from the server.
  ///
  ///
  ///
  final VoidCallback? onUserDidRemoveFromServer;

  ///
  /// Occurs when the current chat user is forbid from the server.
  ///
  ///
  ///
  final VoidCallback? onUserDidForbidByServer;

  ///
  /// Occurs when the current chat user is changed password.
  ///
  ///
  ///
  final VoidCallback? onUserDidChangePassword;

  ///
  /// Occurs when the current chat user logged to many devices.
  ///
  ///
  ///
  final VoidCallback? onUserDidLoginTooManyDevice;

  ///
  /// Occurs when the current chat user kicked by other device.
  ///
  ///
  ///
  final VoidCallback? onUserKickedByOtherDevice;

  ///
  /// Occurs when the current chat user authentication failed.
  ///
  ///
  ///
  final VoidCallback? onUserAuthenticationFailed;

  ///
  /// Occurs when the token is about to expire.
  ///
  ///
  ///
  final VoidCallback? onTokenWillExpire;

  ///
  /// Occurs when the token has expired.
  ///
  ///
  ///
  final VoidCallback? onTokenDidExpire;

  ///
  ///  The number of daily active users (DAU) or monthly active users (MAU) for the app has reached the upper limit .
  ///
  ///
  ///
  final VoidCallback? onAppActiveNumberReachLimit;

  ///
  /// The chat connection listener callback.
  ///
  /// Param [onConnected] The SDK connects to the chat server successfully.
  ///
  /// Param [onDisconnected] The SDK disconnect from the chat server.
  ///
  /// Param [onUserDidLoginFromOtherDevice] The current user account is logged in to another device.
  ///
  /// Param [onUserDidRemoveFromServer] The current chat user is removed from the server.
  ///
  /// Param [onUserDidForbidByServer] The current chat user is banned by the server.
  ///
  /// Param [onUserDidChangePassword] The current chat user is changed password.
  ///
  /// Param [onUserDidLoginTooManyDevice] The current chat user logged in to many devices.
  ///
  /// Param [onUserKickedByOtherDevice] The current chat user is kicked by another device.
  ///
  /// Param [onUserAuthenticationFailed] The authentication for the chat user failed.
  ///
  /// Param [onTokenWillExpire] The token is about to expire.
  ///
  /// Param [onTokenDidExpire] The token has expired.
  ///
  /// Param [onAppActiveNumberReachLimit] The number of daily active users (DAU) or monthly active users (MAU) for the app has reached the upper limit.
  ///
  ///
  ///
  ///
  ConnectionEventHandler({
    this.onConnected,
    this.onDisconnected,
    this.onUserDidLoginFromOtherDevice,
    this.onUserDidRemoveFromServer,
    this.onUserDidForbidByServer,
    this.onUserDidChangePassword,
    this.onUserDidLoginTooManyDevice,
    this.onUserKickedByOtherDevice,
    this.onUserAuthenticationFailed,
    this.onTokenWillExpire,
    this.onTokenDidExpire,
    this.onAppActiveNumberReachLimit,
  });
}

///
/// The multi-device event handler.
/// Listens for callback for the current user's actions on other devices, including contact changes, group changes, and thread changes.
///
/// Adds a multi-device event handler:
/// ```dart
///   ChatClient.getInstance.addMultiDeviceEventHandler((UNIQUE_HANDLER_ID, ChatMultiDeviceEventHandler());
/// ```
///
/// Removes a multi-device event handler:
/// ```dart
///   ChatClient.getInstance.removeMultiDeviceEventHandler(UNIQUE_HANDLER_ID);
/// ```
///
///
///
class ChatMultiDeviceEventHandler {
  ///
  /// The multi-device event of contact.
  ///
  ///
  ///
  final void Function(
    ChatMultiDevicesEvent event,
    String userId,
    String? ext,
  )? onContactEvent;

  ///
  /// The multi-device event of group.
  ///
  ///
  ///
  final void Function(
    ChatMultiDevicesEvent event,
    String groupId,
    List<String>? userIds,
  )? onGroupEvent;

  ///
  /// The multi-device event of thread.
  ///
  ///
  ///
  final void Function(
    ChatMultiDevicesEvent event,
    String chatThreadId,
    List<String> userIds,
  )? onChatThreadEvent;

  ///
  /// Callback received by other devices after historical messages in a conversation are removed from the server in a multi-device login scenario.
  ///
  ///
  ///
  final void Function(
    String conversationId,
    String deviceId,
  )? onRemoteMessagesRemoved;

  ///
  /// The multi-device event callback for the operation of a conversation.
  ///
  ///
  ///
  final void Function(
    ChatMultiDevicesEvent event,
    String conversationId,
    ChatConversationType type,
  )? onConversationEvent;

  ///
  /// The multi-device event handler.
  ///
  /// Param [onContactEvent] The multi-device event of contact.
  ///
  /// Param [onGroupEvent] The multi-device event of group.
  ///
  /// Param [onChatThreadEvent] The multi-device event of thread.
  ///
  /// Param [onRemoteMessagesRemoved] The multi-device event of historical messages removed from the server.
  ///
  /// Param [onConversationEvent] The multi-device event callback for the operation of a conversation.
  ///
  ///
  ///
  ///
  ChatMultiDeviceEventHandler({
    this.onContactEvent,
    this.onGroupEvent,
    this.onChatThreadEvent,
    this.onRemoteMessagesRemoved,
    this.onConversationEvent,
  });
}

///
/// The chat event handler.
///
/// This handler is used to check whether messages are received. If messages are sent successfully, a delivery receipt will be returned (delivery receipt needs to be enabled: [ChatOptions.requireDeliveryAck].
/// If the peer user reads the received message, a read receipt will be returned (read receipt needs to be enabled: [ChatOptions.requireAck]).
/// This API should be implemented in the app to listen for message status changes.
///
/// Adds chat event handler:
/// ```dart
///   ChatClient.getInstance.chatManager.addEventHandler(UNIQUE_HANDLER_ID, ChatEventHandler());
/// ```
///
/// Removes a chat event handler:
/// ```dart
///   ChatClient.getInstance.chatManager.removeEventHandler(UNIQUE_HANDLER_ID);
/// ```
///
///
///
class ChatEventHandler {
  ///
  /// Occurs when a message is received.
  ///
  /// This callback is triggered to notify the user when a message such as texts or an image, video, voice, location, or file is received.
  ///
  ///
  ///
  final void Function(List<ChatMessage> messages)? onMessagesReceived;

  ///
  /// Occurs when a command message is received.
  ///
  /// This callback only contains a command message body that is usually invisible to users.
  ///
  ///
  ///
  final void Function(List<ChatMessage> messages)? onCmdMessagesReceived;

  ///
  /// Occurs when a read receipt is received for a message.
  ///
  ///
  ///
  final void Function(List<ChatMessage> messages)? onMessagesRead;

  ///
  /// Occurs when a read receipt is received for a group message.
  ///
  ///
  ///
  final void Function(List<ChatGroupMessageAck> groupMessageAcks)?
      onGroupMessageRead;

  ///
  /// Occurs when the update for the group message read status is received.
  ///
  ///
  ///
  final VoidCallback? onReadAckForGroupMessageUpdated;

  ///
  /// Occurs when a delivery receipt is received.
  ///
  ///
  ///
  final void Function(List<ChatMessage> messages)? onMessagesDelivered;

  ///
  /// Occurs when a received message is recalled.
  ///
  ///
  ///
  final void Function(List<ChatMessage> messages)? onMessagesRecalled;

  ///
  /// Occurs when the conversation updated.
  ///
  ///
  ///
  final VoidCallback? onConversationsUpdate;

  ///
  /// Occurs when a conversation read receipt is received.
  ///
  /// Occurs in the following scenarios:
  /// (1) The message is read by the recipient (The conversation receipt is sent).
  /// Upon receiving this event, the SDK sets the [ChatMessage.hasReadAck] property of the message in the conversation to `true` in the local database.
  /// (2) In the multi-device login scenario, when one device sends a Conversation receipt,
  /// the server will set the number of unread messages to 0, and the callback occurs on the other devices.
  /// and sets the [ChatMessage.hasReadAck] property of the message in the conversation to `true` in the local database.
  ///
  ///
  ///
  final void Function(String from, String to)? onConversationRead;

  ///
  /// Occurs when the Reaction data changes.
  ///
  ///
  ///
  final void Function(List<ChatMessageReactionEvent> events)?
      onMessageReactionDidChange;

  ///
  /// Occurs when the message content is modified.
  ///
  ///
  ///
  final void Function(
    ChatMessage message,
    String operatorId,
    int operationTime,
  )? onMessageContentChanged;

  ///
  /// The chat event handler.
  ///
  /// Param [onMessagesReceived] Occurs when a message is received.
  ///
  /// Param [onCmdMessagesReceived] Occurs when a command message is received.
  ///
  /// Param [onMessagesRead] Occurs when a read receipt is received for a one-to-one message.
  ///
  /// Param [onGroupMessageRead] Occurs when a read receipt is received for a group message.
  ///
  /// Param [onReadAckForGroupMessageUpdated] Occurs when the group message read status is received.
  ///
  /// Param [onMessagesDelivered] Occurs when a delivery receipt is received.
  ///
  /// Param [onMessagesRecalled] Occurs when a received message is recalled.
  ///
  /// Param [onConversationsUpdate] Occurs when a conversation is updated.
  ///
  /// Param [onConversationRead] Occurs when a conversation read receipt is received.
  ///
  /// Param [onMessageReactionDidChange] Occurs when the Reaction data changes.
  ///
  /// Param [onMessageContentChanged] Occurs when the message content is modified.
  ///
  ///
  ///
  ChatEventHandler({
    this.onMessagesReceived,
    this.onCmdMessagesReceived,
    this.onMessagesRead,
    this.onGroupMessageRead,
    this.onReadAckForGroupMessageUpdated,
    this.onMessagesDelivered,
    this.onMessagesRecalled,
    this.onConversationsUpdate,
    this.onConversationRead,
    this.onMessageReactionDidChange,
    this.onMessageContentChanged,
  });
}

///
/// The chat room event handler.
///
/// Adds chat event handler:
/// ```dart
///   ChatClient.getInstance.chatRoomManager.addEventHandler(UNIQUE_HANDLER_ID, ChatRoomEventHandler());
/// ```
///
/// Removes a chat room event handler:
/// ```dart
///   ChatClient.getInstance.chatRoomManager.removeEventHandler(UNIQUE_HANDLER_ID);
/// ```
///
///
///
class ChatRoomEventHandler {
  ///
  /// Occurs when a member is changed to be an admin.
  ///
  ///
  ///
  final void Function(
    String roomId,
    String admin,
  )? onAdminAddedFromChatRoom;

  ///
  /// Occurs when an admin is removed.
  ///
  ///
  ///
  final void Function(
    String roomId,
    String admin,
  )? onAdminRemovedFromChatRoom;

  ///
  /// Occurs when all members in the chat room are muted or unmuted.
  ///
  ///
  ///
  final void Function(
    String roomId,
    bool isAllMuted,
  )? onAllChatRoomMemberMuteStateChanged;

  ///
  /// Occurs when the chat room member(s) is/are added to the allowlist.
  ///
  ///
  ///
  final void Function(
    String roomId,
    List<String> members,
  )? onAllowListAddedFromChatRoom;

  ///
  /// Occurs when the chat room member(s) is/are removed from the allowlist.
  ///
  ///
  ///
  final void Function(
    String roomId,
    List<String> members,
  )? onAllowListRemovedFromChatRoom;

  ///
  /// Occurs when the announcement changed.
  ///
  ///
  ///
  final void Function(
    String roomId,
    String announcement,
  )? onAnnouncementChangedFromChatRoom;

  ///
  /// Occurs when the chat room is destroyed.
  ///
  ///
  ///
  final void Function(
    String roomId,
    String? roomName,
  )? onChatRoomDestroyed;

  ///
  /// Occurs when a member leaves the chat room.
  ///
  ///
  ///
  final void Function(
    String roomId,
    String? roomName,
    String participant,
  )? onMemberExitedFromChatRoom;

  ///
  /// Occurs when a user joins the chat room.
  ///
  ///
  ///
  final void Function(String roomId, String participant)?
      onMemberJoinedFromChatRoom;

  ///
  /// Occurs when a chat room member(s) is/are added to mute list.
  ///
  ///
  ///
  final void Function(
    String roomId,
    List<String> mutes,
    String? expireTime,
  )? onMuteListAddedFromChatRoom;

  ///
  /// Occurs when the a chat room member(s) is/are removed from mute list.
  ///
  ///
  ///
  final void Function(
    String roomId,
    List<String> mutes,
  )? onMuteListRemovedFromChatRoom;

  ///
  /// Occurs when the chat room ownership is transferred.
  ///
  ///
  ///
  final void Function(
    String roomId,
    String newOwner,
    String oldOwner,
  )? onOwnerChangedFromChatRoom;

  ///
  /// Occurs when a user is removed from a chat room.
  ///
  ///
  ///
  final void Function(
    String roomId,
    String? roomName,
    String? participant,
    LeaveReason? reason,
  )? onRemovedFromChatRoom;

  ///
  /// Occurs when the chat room specifications changes. All chat room members receive this event.
  ///
  ///
  ///
  final void Function(ChatRoom room)? onSpecificationChanged;

  ///
  /// Occurs when the custom chat room attributes (key-value) are updated.
  ///
  ///
  ///
  final void Function(
    String roomId,
    Map<String, String> attributes,
    String from,
  )? onAttributesUpdated;

  ///
  /// Occurs when the custom chat room attributes (key-value) are removed.
  ///
  ///
  ///
  final void Function(
    String roomId,
    List<String> removedKeys,
    String from,
  )? onAttributesRemoved;

  ///
  /// The chat room manager listener callback.
  ///
  /// Param [onAdminAddedFromChatRoom] A member is changed to be an admin.
  ///
  /// Param [onAdminRemovedFromChatRoom] An admin is been removed.
  ///
  /// Param [onAllChatRoomMemberMuteStateChanged] All members in the chat room are muted or unmuted.
  ///
  /// Param [onAllowListAddedFromChatRoom] The chat room member(s) is/are added to the allowlist.
  ///
  /// Param [onAllowListRemovedFromChatRoom] The chat room member(s) is/are removed from the allowlist.
  ///
  /// Param [onAnnouncementChangedFromChatRoom] The announcement is changed.
  ///
  /// Param [onChatRoomDestroyed] The chat room is destroyed.
  ///
  /// Param [onMemberExitedFromChatRoom] A member leaves the chat room.
  ///
  /// Param [onMemberJoinedFromChatRoom] A user joins the chat room.
  ///
  /// Param [onMuteListAddedFromChatRoom] The chat room member(s) is/are added to mute list.
  ///
  /// Param [onMuteListRemovedFromChatRoom] The chat room member(s) is/are removed from mute list.
  ///
  /// Param [onOwnerChangedFromChatRoom] The chat room ownership is transferred.
  ///
  /// Param [onRemovedFromChatRoom] The chat room member(s) is/are removed from the allowlist.
  ///
  /// Param [onSpecificationChanged] The chat room specification changed.
  ///
  /// Param [onAttributesUpdated] The chat room attribute(s) is/are updated.
  ///
  /// Param [onAttributesRemoved] The chat room attribute(s) is/are removed.
  ///
  ///
  ///
  ChatRoomEventHandler({
    this.onAdminAddedFromChatRoom,
    this.onAdminRemovedFromChatRoom,
    this.onAllChatRoomMemberMuteStateChanged,
    this.onAllowListAddedFromChatRoom,
    this.onAllowListRemovedFromChatRoom,
    this.onAnnouncementChangedFromChatRoom,
    this.onChatRoomDestroyed,
    this.onMemberExitedFromChatRoom,
    this.onMemberJoinedFromChatRoom,
    this.onMuteListAddedFromChatRoom,
    this.onMuteListRemovedFromChatRoom,
    this.onOwnerChangedFromChatRoom,
    this.onRemovedFromChatRoom,
    this.onSpecificationChanged,
    this.onAttributesUpdated,
    this.onAttributesRemoved,
  });
}

///
/// The message thread event handler, which handles message thread events such as creating or leaving a message thread.
///
/// Adds a message thread event handler:
/// ```dart
///   ChatClient.getInstance.chatThreadManager.addEventHandler(UNIQUE_HANDLER_ID, ChatThreadEventHandler());
/// ```
///
/// Removes a chat event handler:
/// ```dart
/// ChatClient.getInstance.chatThreadManager.removeEventHandler(UNIQUE_HANDLER_ID);
/// ```
///
///
///
class ChatThreadEventHandler {
  ///
  /// Occurs when a message thread is created.
  ///
  /// Each member of the group to which the message thread belongs can receive the callback.
  ///
  ///
  ///
  final void Function(
    ChatThreadEvent event,
  )? onChatThreadCreate;

  ///
  /// Occurs when a message thread is destroyed.
  ///
  /// Each member of the group to which the message thread belongs can receive the callback.
  ///
  ///
  ///
  final void Function(
    ChatThreadEvent event,
  )? onChatThreadDestroy;

  ///
  /// Occurs when a message thread is updated.
  ///
  /// This callback is triggered when the message thread name is changed or a threaded reply is added or recalled.
  ///
  /// Each member of the group to which the message thread belongs can receive the callback.
  ///
  ///
  ///
  final void Function(
    ChatThreadEvent event,
  )? onChatThreadUpdate;

  ///
  /// Occurs when the current user is removed from the message thread by the group owner or a group admin to which the message thread belongs.
  ///
  ///
  ///
  final void Function(
    ChatThreadEvent event,
  )? onUserKickOutOfChatThread;

  ///
  /// The message thread listener callback.
  ///
  /// Param [onChatThreadCreate] A message thread is created. All members in the group to which the thread belongs receive this callback.
  ///
  /// Param [onChatThreadDestroy] A message thread is destroyed. All members in the group to which the destroyed thread belongs receive this callback.
  ///
  /// Param [onChatThreadUpdate] A message thread is updated. All members in the group to which the updated thread belongs receive this callback.
  ///
  /// Param [onUserKickOutOfChatThread]  The current user is removed from the message thread by the group owner or a group admin to which the message thread belongs. The current user removed from the thread receives the callback.
  ///
  ///
  ///
  ChatThreadEventHandler({
    this.onChatThreadCreate,
    this.onChatThreadDestroy,
    this.onChatThreadUpdate,
    this.onUserKickOutOfChatThread,
  });
}

///
/// The contact event handler.
///
/// Occurs when the contact changes, including adding or deleting contacts and accept or rejecting friend requests.
///
/// Adds a contact event handler:
/// ```dart
///   ChatClient.getInstance.contactManager.addEventHandler(UNIQUE_HANDLER_ID, ContactEventHandler());
/// ```
///
/// Removes a contact event handler:
/// ```dart
///   ChatClient.getInstance.contactManager.removeEventHandler(UNIQUE_HANDLER_ID);
/// ```
///
///
///
class ContactEventHandler {
  ///
  /// Occurs when user is added as a contact by another user.
  ///
  ///
  ///
  final void Function(
    String userId,
  )? onContactAdded;

  ///
  /// Occurs when a user is removed from the contact list by another user.
  ///
  ///
  ///
  final void Function(
    String userId,
  )? onContactDeleted;

  ///
  /// Occurs when a user receives a friend request.
  ///
  ///
  ///
  final void Function(
    String userId,
    String? reason,
  )? onContactInvited;

  ///
  /// Occurs when a friend request is approved.
  ///
  ///
  ///
  final void Function(
    String userId,
  )? onFriendRequestAccepted;

  ///
  /// Occurs when a friend request is declined.
  ///
  ///
  ///
  final void Function(
    String userId,
  )? onFriendRequestDeclined;

  ///
  /// The contact updates listener callback.
  ///
  /// Param [onContactAdded] Current user is added as a contact by another user.
  ///
  /// Param [onContactDeleted] Current user is removed from the contact list by another user.
  ///
  /// Param [onContactInvited] Current user receives a friend request.
  ///
  /// Param [onFriendRequestAccepted] A friend request is approved.
  ///
  /// Param [onFriendRequestDeclined] A friend request is declined.
  ///
  ///
  ///
  ContactEventHandler({
    this.onContactAdded,
    this.onContactDeleted,
    this.onContactInvited,
    this.onFriendRequestAccepted,
    this.onFriendRequestDeclined,
  });
}

///
/// The group event handler.
///
/// Occurs when the following group events happens: joining a group, approving or declining a group request, and kicking a user out of a group.
///
/// Adds a group event handler:
/// ```dart
///   ChatClient.getInstance.groupManager.addEventHandler(UNIQUE_HANDLER_ID, ChatGroupEventHandler());
/// ```
///
/// Removes a group event handler:
/// ```dart
///   ChatClient.getInstance.groupManager.removeEventHandler(UNIQUE_HANDLER_ID);
/// ```
///
///
///
class ChatGroupEventHandler {
  ///
  /// Occurs when a member is set as an admin.
  ///
  ///
  ///
  final void Function(
    String groupId,
    String admin,
  )? onAdminAddedFromGroup;

  ///
  /// Occurs when a member's admin privileges are removed.
  ///
  ///
  ///
  final void Function(
    String groupId,
    String admin,
  )? onAdminRemovedFromGroup;

  ///
  /// Occurs when all group members are muted or unmuted.
  ///
  ///
  ///
  final void Function(
    String groupId,
    bool isAllMuted,
  )? onAllGroupMemberMuteStateChanged;

  ///
  /// Occurs when one or more group members are added to the allowlist.
  ///
  ///
  ///
  final void Function(
    String groupId,
    List<String> members,
  )? onAllowListAddedFromGroup;

  ///
  /// Occurs when one or more members are removed from the allowlist.
  ///
  ///
  ///
  final void Function(
    String groupId,
    List<String> members,
  )? onAllowListRemovedFromGroup;

  ///
  /// Occurs when the announcement is updated.
  ///
  ///
  ///
  final void Function(
    String groupId,
    String announcement,
  )? onAnnouncementChangedFromGroup;

  ///
  /// Occurs when the group invitation is accepted automatically.
  /// For settings, See [ChatOptions.autoAcceptGroupInvitation].
  /// The SDK will join the group before notifying the app of the acceptance of the group invitation.
  ///
  ///
  ///
  final void Function(
    String groupId,
    String inviter,
    String? inviteMessage,
  )? onAutoAcceptInvitationFromGroup;

  ///
  /// Occurs when a group is destroyed.
  ///
  ///
  ///
  final void Function(
    String groupId,
    String? groupName,
  )? onGroupDestroyed;

  ///
  /// Occurs when a group invitation is accepted.
  ///
  ///
  ///
  final void Function(
    String groupId,
    String invitee,
    String? reason,
  )? onInvitationAcceptedFromGroup;

  ///
  /// Occurs when a group invitation is declined.
  ///
  ///
  ///
  final void Function(
    String groupId,
    String invitee,
    String? reason,
  )? onInvitationDeclinedFromGroup;

  ///
  /// Occurs when the user receives a group invitation.
  ///
  ///
  ///
  final void Function(
    String groupId,
    String? groupName,
    String inviter,
    String? reason,
  )? onInvitationReceivedFromGroup;

  ///
  /// Occurs when a member proactively leaves the group.
  ///
  ///
  ///
  final void Function(
    String groupId,
    String member,
  )? onMemberExitedFromGroup;

  ///
  /// Occurs when a user joins a group.
  ///
  ///
  ///
  final void Function(
    String groupId,
    String member,
  )? onMemberJoinedFromGroup;

  ///
  /// Occurs when one or more group members are muted.
  ///
  /// Note: The mute function is different from a block list.
  /// A user, when muted, can still see group messages, but cannot send messages in the group.
  /// However, a user on the block list can neither see nor send group messages.
  ///
  ///
  ///
  final void Function(
    String groupId,
    List<String> mutes,
    int? muteExpire,
  )? onMuteListAddedFromGroup;

  ///
  /// Occurs when one or more group members are unmuted.
  ///
  ///
  ///
  final void Function(
    String groupId,
    List<String> mutes,
  )? onMuteListRemovedFromGroup;

  ///
  /// Occurs when the group ownership is transferred.
  ///
  ///
  ///
  final void Function(
    String groupId,
    String newOwner,
    String oldOwner,
  )? onOwnerChangedFromGroup;

  ///
  /// Occurs when a group request is accepted.
  ///
  ///
  ///
  final void Function(
    String groupId,
    String? groupName,
    String accepter,
  )? onRequestToJoinAcceptedFromGroup;

  ///
  /// Occurs when a group request is declined.
  ///
  ///
  ///
  final void Function(
    String groupId,
    String? groupName,
    String decliner,
    String? reason,
  )? onRequestToJoinDeclinedFromGroup;

  ///
  /// Occurs when the group owner or administrator receives a group request from a user.
  ///
  ///
  ///
  final void Function(
    String groupId,
    String? groupName,
    String applicant,
    String? reason,
  )? onRequestToJoinReceivedFromGroup;

  ///
  /// Occurs when a shared file is added to a group.
  ///
  ///
  ///
  final void Function(
    String groupId,
    ChatGroupSharedFile sharedFile,
  )? onSharedFileAddedFromGroup;

  ///
  /// Occurs when the group detail information is updated.
  ///
  ///
  ///
  final void Function(
    ChatGroup group,
  )? onSpecificationDidUpdate;

  ///
  /// Occurs when the group is enabled or disabled.
  ///
  ///
  ///
  final void Function(
    String groupId,
    bool isDisable,
  )? onDisableChanged;

  ///
  /// Occurs when a shared file is removed from a group.
  ///
  ///
  ///
  final void Function(
    String groupId,
    String fileId,
  )? onSharedFileDeletedFromGroup;

  ///
  /// Occurs when the current user is removed from the group by the group admin.
  ///
  ///
  ///
  final void Function(
    String groupId,
    String? groupName,
  )? onUserRemovedFromGroup;

  ///
  /// Occurs when a custom attribute(s) of a group member is/are changed.
  ///
  /// Param [groupId] The group ID.
  ///
  /// Param [userId] The user ID of the group member whose custom attributes are changed.
  ///
  /// Param [attributes] The modified custom attributes, in key-value format.
  ///
  /// Param [operatorId] The user ID of the operator.
  ///
  ///
  ///
  ///
  final void Function(
    String groupId,
    String userId,
    Map<String, String>? attributes,
    String? operatorId,
  )? onAttributesChangedOfGroupMember;

  ///
  /// The group manager listener callback.
  ///
  /// Param [onAdminAddedFromGroup] A member is set as an admin.
  ///
  /// Param [onAdminRemovedFromGroup] A member's admin privileges are removed.
  ///
  /// Param [onAllGroupMemberMuteStateChanged] All group members are muted or unmuted.
  ///
  /// Param [onAllowListAddedFromGroup] One or more group members are muted.
  ///
  /// Param [onAllowListRemovedFromGroup] One or more group members are unmuted.
  ///
  /// Param [onAnnouncementChangedFromGroup] The announcement is updated.
  ///
  /// Param [onAutoAcceptInvitationFromGroup] The group invitation is accepted automatically.
  ///
  /// Param [onGroupDestroyed] A group is destroyed.
  ///
  /// Param [onInvitationAcceptedFromGroup] A group invitation is accepted.
  ///
  /// Param [onInvitationDeclinedFromGroup] A group invitation is declined.
  ///
  /// Param [onInvitationReceivedFromGroup] The user receives a group invitation.
  ///
  /// Param [onMemberExitedFromGroup] A member proactively leaves the group.
  ///
  /// Param [onMemberJoinedFromGroup] A user joins a group.
  ///
  /// Param [onMuteListAddedFromGroup] One or more group members are muted.
  ///
  /// Param [onMuteListRemovedFromGroup] One or more group members are unmuted.
  ///
  /// Param [onOwnerChangedFromGroup] The group ownership is transferred.
  ///
  /// Param [onRequestToJoinAcceptedFromGroup] A group request is accepted.
  ///
  /// Param [onRequestToJoinDeclinedFromGroup] A group request is declined.
  ///
  /// Param [onRequestToJoinReceivedFromGroup] The group owner or administrator receives a group request from a user.
  ///
  /// Param [onSharedFileAddedFromGroup] A shared file is added to a group.
  ///
  /// Param [onSharedFileDeletedFromGroup] A shared file is removed from a group.
  ///
  /// Param [onUserRemovedFromGroup] Current user is removed from the group by the group admin.
  ///
  /// Param [onSpecificationDidUpdate] The group detail information is updated.
  ///
  /// Param [onDisableChanged] Te group is enabled or disabled.
  ///
  /// Param [onAttributesChangedOfGroupMember] A custom attribute(s) of a group member is/are changed.
  ///
  ///
  ///
  ChatGroupEventHandler({
    this.onAdminAddedFromGroup,
    this.onAdminRemovedFromGroup,
    this.onAllGroupMemberMuteStateChanged,
    this.onAllowListAddedFromGroup,
    this.onAllowListRemovedFromGroup,
    this.onAnnouncementChangedFromGroup,
    this.onAutoAcceptInvitationFromGroup,
    this.onGroupDestroyed,
    this.onInvitationAcceptedFromGroup,
    this.onInvitationDeclinedFromGroup,
    this.onInvitationReceivedFromGroup,
    this.onMemberExitedFromGroup,
    this.onMemberJoinedFromGroup,
    this.onMuteListAddedFromGroup,
    this.onMuteListRemovedFromGroup,
    this.onOwnerChangedFromGroup,
    this.onRequestToJoinAcceptedFromGroup,
    this.onRequestToJoinDeclinedFromGroup,
    this.onRequestToJoinReceivedFromGroup,
    this.onSharedFileAddedFromGroup,
    this.onSharedFileDeletedFromGroup,
    this.onUserRemovedFromGroup,
    this.onSpecificationDidUpdate,
    this.onDisableChanged,
    this.onAttributesChangedOfGroupMember,
  });
}

///
/// The presence event handler.
///
/// Occurs when the following presence events happens: presence status changed.
///
/// Adds a presence event handler:
/// ```dart
///   ChatClient.getInstance.presenceManager.addEventHandler(UNIQUE_HANDLER_ID, ChatPresenceEventHandler());
/// ```
///
/// Removes a presence event handler:
/// ```dart
///   ChatClient.getInstance.presenceManager.removeEventHandler(UNIQUE_HANDLER_ID);
/// ```
///
///
///
class ChatPresenceEventHandler {
  ///
  /// Occurs when the presence state of a subscribed user changes.
  ///
  ///
  ///
  final Function(List<ChatPresence> list)? onPresenceStatusChanged;

  ///
  /// The presence manager listener callback.
  ///
  /// Param [onPresenceStatusChanged] The presence state of a subscribed user changes.
  ///
  ///
  ///
  ChatPresenceEventHandler({
    this.onPresenceStatusChanged,
  });
}
