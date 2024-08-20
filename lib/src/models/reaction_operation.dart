import 'chat_enums.dart';

///
/// Reaction operation.
///
///
///
class ReactionOperation {
  ///
  /// Reaction operation.
  ///
  /// Param [userId] The user ID of the operator.
  ///
  /// Param [reaction] Changed Reaction.
  ///
  /// Param [operate] The Reaction operation type.
  ///
  ///
  ///
  const ReactionOperation._private(
    this.userId,
    this.reaction,
    this.operate,
  );

  ///
  /// The user ID of the operator.
  ///
  ///
  ///
  final String userId;

  ///
  /// Changed Reaction.
  ///
  ///
  ///
  final String reaction;

  ///
  /// The Reaction operation type.
  ///
  ///
  ///
  final ReactionOperate operate;

  /// @nodoc
  factory ReactionOperation.fromJson(Map map) {
    String userId = map["userId"];
    String reaction = map["reaction"];

    ReactionOperate operate = (map["operate"] ?? 0) == 0
        ? ReactionOperate.Remove
        : ReactionOperate.Add;

    return ReactionOperation._private(userId, reaction, operate);
  }
}
