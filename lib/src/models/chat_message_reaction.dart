import '../internal/inner_headers.dart';

///
/// The message Reaction instance class, which has the following attributes:
/// Reaction: The message Reaction.
/// UserCount: The count of users that added the Reaction.
/// UserList: The list of users that added the Reaction.
/// isAddedBySelf: Whether the current user added this Reaction.
///
///
///
class ChatMessageReaction {
  ///
  /// The Reaction content
  ///
  ///
  ///
  final String reaction;

  ///
  /// The count of the users who added this Reaction.
  ///
  ///
  ///
  final int userCount;

  ///
  /// Whether the current user added this Reaction.
  ///
  /// `Yes`: is added by self
  /// `No`: is not added by self.
  ///
  ///
  ///
  final bool isAddedBySelf;

  ///
  /// The list of users that added this Reaction
  ///
  /// **Note**
  /// To get the entire list of users adding this Reaction, you can call [ChatManager.fetchReactionDetail] which returns the user list with pagination.
  /// Other methods like [ChatMessage.reactionList], [ChatManager.fetchReactionList] or [ChatEventHandler.onMessageReactionDidChange] can get the first three users.
  ///
  ///
  ///
  final List<String> userList;

  ChatMessageReaction._private({
    required this.reaction,
    required this.userCount,
    required this.isAddedBySelf,
    required this.userList,
  });

  /// @nodoc
  factory ChatMessageReaction.fromJson(Map map) {
    String reaction = map["reaction"];
    int count = map["count"];

    bool isAddedBySelf = map["isAddedBySelf"] ?? false;
    List<String> userList = [];
    List<String>? tmp = map.getList("userList");
    if (tmp != null) {
      userList.addAll(tmp);
    }
    return ChatMessageReaction._private(
      reaction: reaction,
      userCount: count,
      isAddedBySelf: isAddedBySelf,
      userList: userList,
    );
  }
}

///
/// The message reaction change event class.
///
///
///
class ChatMessageReactionEvent {
  ///
  /// The conversation ID.
  ///
  ///
  ///
  final String conversationId;

  ///
  /// The message ID.
  ///
  ///
  ///
  final String messageId;

  ///
  /// The Reaction which is changed.
  ///
  ///
  ///
  final List<ChatMessageReaction> reactions;

  ///
  /// Details of changed operation.
  ///
  ///
  ///
  final List<ReactionOperation> operations;

  ChatMessageReactionEvent._private({
    required this.conversationId,
    required this.messageId,
    required this.reactions,
    required this.operations,
  });

  /// @nodoc
  factory ChatMessageReactionEvent.fromJson(Map map) {
    String conversationId = map["conversationId"];
    String messageId = map["messageId"];
    List<ChatMessageReaction> reactions = [];
    map["reactions"]?.forEach((element) {
      reactions.add(ChatMessageReaction.fromJson(element));
    });

    List<ReactionOperation> operations = [];
    map["operations"]?.forEach((e) {
      operations.add(ReactionOperation.fromJson(e));
    });

    return ChatMessageReactionEvent._private(
      conversationId: conversationId,
      messageId: messageId,
      reactions: reactions,
      operations: operations,
    );
  }
}
