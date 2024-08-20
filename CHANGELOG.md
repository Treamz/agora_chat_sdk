This page provides release notes for the Agora Chat Flutter SDK.

## v1.2.0(Dec 5, 2023)

#### New features

- Adds the function of sending a combined message:
  - `MessageType.COMBINE`: The combined message type.
  - `CombineMessageBody`: The combined message body class.
  - `ChatManager#fetchCombineMessageDetail`：Gets the list of original messages included in a combined message from the server.
- Adds the function of modifying a text message that is sent:
  - `ChatManager#modifyMessage`: Modifies a text message that is sent.
  - `ChatEventHandler#onMessageContentChanged`: Occurs when a sent message is modified. The message recipient receives this callback.
  - `ChatTextMessageBody#lastModifyTime`: Indicates when the content of a sent message is modified last time.
  - `ChatTextMessageBody#lastModifyOperatorId`: Indicates the user ID of user that modifies a sent message last time.
  - `ChatTextMessageBody#modifyCount`: Indicates the number of times a sent message is modified.
- Adds the function of pinning a conversation:
  - `ChatManager#pinConversation`: Pins or unpins a conversation.
  - `ChatManager#fetchPinnedConversations`: Gets the list of pinned conversations from the server.
  - `ChatConversation#isPinned`: Specifies whether the conversation is pinned.
  - `ChatConversation#pinnedTime`: Specifies when the conversation is pinned.
- Adds the `fetchConversation` method to get the conversation list from the server. Marks the `ChatManager#getConversationsFromServer` method deprecated.
- Adds `FetchMessageOptions` as the parameter configuration class for pulling historical messages from the server.
- Adds the `ChatManager#fetchHistoryMessagesByOption` method to get historical messages of a conversation from the server according to `FetchMessageOptions`, the parameter configuration class for pulling historical messages.
- Adds the `direction` parameter to `ChatManager#fetchHistoryMessages` to allow you to retrieve historical messages from the server according to the message search direction.
- Adds the `ChatConversation#deleteMessagesWithTs` method to delete messages sent or received in a certain period from the local database.
- Adds the `ChatMessage#deliverOnlineOnly` field to specify whether the message is delivered only when the recipient(s) is/are online.
- Adds the function of managing custom attributes of group members:
  - `ChatGroupManager#setMemberAttributes`: Sets custom attributes of a group member.
  - `ChatGroupManager#fetchMemberAttributes` and `GroupManager#fetchMembersAttributes`: Gets custom attributes of group members.
  - `ChatGroupEventHandler#onAttributesChangedOfGroupMember`: Occurs when a custom attribute is changed for a group member.
- Adds the `reason` parameter to `ChatRoomEventHandler#onRemovedFromChatRoom` so that the member removed from the chat room knows the removal reason.
- Adds the `ChatConnectionEventHandler#onAppActiveNumberReachLimit` callback that occurs when the number of daily active users (DAU) or monthly active users (MAU) for the app has reached the upper limit.
- Adds the `IMultiDeviceDelegate#OnRoamDeleteMultiDevicesEvent` callback that occurs when historical messages in a conversation are deleted from the server on one device. This event is received by other devices.
- Adds the support for user tokens in the following methods:
  - `ChatClient#fetchLoggedInDevices`: Gets the list of online login devices of a user.
  - `ChatClient#kickDevice`: Kicks a user out of the app on a device.
  - `ChatClient#kickAllDevices`: Kicks a user out of the app on all devices.
- Adds the `ChatMultiDeviceEventHandler#onRemoteMessagesRemoved` callback that occurs when historical messages in a conversation are deleted from the server on one device. This event is received by other devices.
- Adds the Reaction operation class `ReactionOperate`:
  - `Add`: Adds a Reaction.
  - `Remove`：Removes a Reaction.
- Adds the `ChatRoomEventHandler#onSpecificationChanged` callback that occurs when details of a chat room are changed.

### Improvements

- Optimized the `ChatManager#searchMsgFromDB` method to include custom messages in the message retrieval result.
- Adapted to the Android 14 system.


#### Issues fixed

- `ConnectionEventHandler#onConnected` and `ConnectionEventHandler#onDisconnected` cannot be received on the iOS system.
- Message extension attributes of the string type in the Android system turn into the Int type.
- Upon a hot reload on Android, the callback is triggered repeatedly.
- When you retrieve custom chat room attributes, passing `null` to the key of an attribute causes the app to crash.
- Chat room events cannot be received by a user that logs in to the Agora Chat server again after logout on the Android platform.
- `ChatManager#getThreadConversation` error.
- The `ChatMessage#chatThread` error.
- The `ChatRoomEventHandler#onSpecificationChanged` is not triggered when the chat room announcement changes.
- The Android platform crashes when a user is removed from a thread.
- An error occurs when `ChatThreadManager#fetchChatThreadMembers` is called.



## v1.1.1(June 16, 2023)

#### Issues fixed

- Fix: Callback methods executing multiple times due to multiple initialization of android.


## v1.1.0+1(April 4, 2023)

#### Issues fixed

- Fixed Android sending video message url error.

## v1.1.0(February 28, 2023)

#### New features

- Upgrades the native platforms `iOS` and `Android` that the Flutter platform depends on to v1.1.0.
- Adds the function of managing custom chat room attributes to implement functions like seat control and synchronization in voice chatrooms.
- Adds the `ChatManager#fetchConversationListFromServer` method to allow users to get the conversation list from the server with pagination.
- Adds the `ChatMessage#chatroomMessagePriority` attribute to implement the chat room message priority function to ensure that high-priority messages are dealt with first.

#### Improvements

Changed the message sending result callback from `ChatMessage#setMessageStatusCallBack` to `ChatManager#addMessageEvent`.

#### Issues fixed

`ChatManager#deleteMessagesBeforeTimestamp` execution failures.

## v1.0.9(December 19, 2022)


#### Issues fixed

- Some alerts on Android 12.
- The inconsistency of messages in the memory and the database due to a call to the `updateMessage` method in rare scenarios.
- The `ChatGroupEventHandler#onDestroyedFromGroup` callback that occurs when a group is destroyed does not work on the Android platform.
- The `ChatGroupEventHandler#onAutoAcceptInvitationFromGroup` callback that occurs when a user's group invitation is accepted automatically does not work on the Android platform.
- Crashes in rare scenarios.

## v1.0.8(November 22, 2022)

#### Improvements

Removed some redundant logs of the SDK.

#### Issues fixed

- Failures in getting a large number of messages from the server in few scenarios.
- The issue of incorrect data statistics.
- Crashes caused by log printing in rare scenarios.

## v1.0.7(September 7, 2022)


#### New features

- Adds the `customEventHandler` attribute in `ChatClient` to allow you to set custom listeners to receive the data sent from the Android or iOS device to the Flutter. 
- Adds event listener classes for event listening.
- Adds the `PushTemplate` method in `PushManager to support custom push templates. 
- Adds the `isDisabled` attribute in `Group` to to indicate whether a group is disabled. This attribute needs to be set by developers at the server side. This attribute is returned when you call the `fetchGroupInfoFromServer` method to get group details.
- Adds the the `displayName` attribute in `PushConfigs` to allow you to check the nickname displayed in your push notifications.

#### Improvements

- Marked `AddXXXManagerListener` methods (like `addChatManagerListener`  and `addContactManagerListener`) as deprecated.

- Modified API references.

## v1.0.6(July 21, 2022)

#### Issues fixed

- The callbacks for messaging thread were not triggered on iOS.
- The callbacks for reaction were not triggered in iOS.
- Occasional crashes occurred on Android when retrieving conversations from the server.

## v1.0.5(June 17, 2022)

This is the first release for the Agora Chat Flutter SDK, which enables you to add real-time chatting functionalities to an Android or iOS app. Major features include the following:

- Sending and receiving messages in one-to-one chats, chat groups, and chat rooms.
- Retrieving and managing conversations and messages.
- Managing chat groups and chat rooms.
- Managing contact and block lists.

For the complete feature list, see [Product Overview](./agora_chat_overview?platform=Flutter).

Agora Chat is charged on a MAU (Monthly Active Users) basis. For details, see [Pricing for Agora Chat](./agora_chat_pricing?platform=Flutter) and [Pricing Plan Details](./agora_chat_plan?platform=Flutter).

Refer to the following documentations to enable Agora Chat and use the Chat SDK to implement real-time chatting functionalities in your app:

- [Enable and Configure Agora Chat](./enable_agora_chat)
- [Get Started with Agora Chat](./agora_chat_get_started_flutter)
- [Messages](./agora_chat_message_overview?platform=Flutter)
- [Chat Group](./agora_chat_group_overview?platform=Flutter)
- [Chat Room](./agora_chat_chatroom_overview?platform=Flutter)
- [API Reference](./api-ref?platform=Flutter)