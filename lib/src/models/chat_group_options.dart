import '../internal/inner_headers.dart';

///
/// The group options to be configured when the chat group is created.
///
///
///
class ChatGroupOptions {
  ///
  /// Sets the group options.
  ///
  /// Param [style] The group style: {ChatGroupStyle}.
  ///
  /// Param [maxCount] The maximum number of members in a group. The default value is 200.
  ///
  /// Param [inviteNeedConfirm] Whether you can automatically add a user to the chat group depends on the settings of [inviteNeedConfirm] and [ChatOptions.autoAcceptGroupInvitation].
  ///
  /// - If `inviteNeedConfirm` is set to `false`, you can add the invitee directly to the chat group, regardless of the settings of [ChatOptions.autoAcceptGroupInvitation].
  /// - If `inviteNeedConfirm` is set to `true`, whether the invitee automatically joins the chat group or not depends on the settings of [ChatOptions.autoAcceptGroupInvitation] on the invitee's client.
  /// - If `autoAcceptGroupInvitation` is set to `true`, the invitee automatically joins the chat group.
  /// - If `autoAcceptGroupInvitation` is set to `false`, the invitee does not join the chat group until this invitee approves the group invitation.
  ///
  /// Param [ext] Group detail extensions which can be in the JSON format to contain more group information.
  ///
  ///
  ///
  ChatGroupOptions({
    this.style = ChatGroupStyle.PrivateOnlyOwnerInvite,
    this.maxCount = 200,
    this.inviteNeedConfirm = false,
    this.ext,
  });

  ///
  /// Gets the group style.
  ///
  /// **Return** The group style. See {ChatGroupStyle}.
  ///
  ///
  ///
  final ChatGroupStyle style;

  ///
  /// Gets the maximum number of members in a group.
  ///
  /// **Return** The maximum number of members in a group.
  ///
  ///
  ///
  final int maxCount;

  ///
  /// Whether you need the approval from the user when adding this user to the chat group.
  ///
  /// Whether you can automatically add a user to the chat group depends on the settings of [inviteNeedConfirm] and [ChatOptions.autoAcceptGroupInvitation].
  ///
  /// - If `inviteNeedConfirm` is set to `false`, you can add the invitee directly to the chat group, regardless of the settings of [ChatOptions.autoAcceptGroupInvitation].
  /// - If `inviteNeedConfirm` is set to `true`, whether the invitee automatically joins the chat group or not depends on the settings of [ChatOptions.autoAcceptGroupInvitation] on the invitee's client.
  ///    - If `autoAcceptGroupInvitation` is set to `true`, the invitee automatically joins the chat group.
  ///    - If `autoAcceptGroupInvitation` is set to `false`, the invitee does not join the chat group until this invitee approves the group invitation.
  ///
  /// **Return** Whether you need the approval from the user when adding this user to the chat group.
  ///
  ///
  ///
  final bool inviteNeedConfirm;

  ///
  ///  Gets the extension in a group.
  ///
  /// **Return** The extension in a group.
  ///
  ///
  ///
  final String? ext;

  /// @nodoc
  Map toJson() {
    Map data = Map();
    data['style'] = groupStyleTypeToInt(style);
    data['maxCount'] = maxCount;
    data['inviteNeedConfirm'] = inviteNeedConfirm;
    data.putIfNotNull("ext", ext);
    return data;
  }

  @override
  String toString() {
    return this.toJson().toString();
  }
}