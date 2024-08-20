///
/// The ChatUserInfo class, which contains the user attributes, such as the nickname, description, and avatar.
///
///
///
class ChatUserInfo {
  ///
  /// Creates a user attribute.
  ///
  ///
  ///
  ChatUserInfo._private(
    this.userId, {
    this.nickName,
    this.avatarUrl,
    this.mail,
    this.phone,
    this.gender = 0,
    this.sign,
    this.birth,
    this.ext,
  });

  /// @nodoc
  factory ChatUserInfo.fromJson(Map map) {
    ChatUserInfo info = ChatUserInfo._private(
      map["userId"],
      nickName: map["nickName"],
      avatarUrl: map["avatarUrl"],
      mail: map["mail"],
      phone: map["phone"],
      gender: map["gender"] ?? 0,
      sign: map["sign"],
      birth: map["birth"],
      ext: map["ext"],
    );
    return info;
  }

  /// @nodoc
  Map toJson() {
    Map data = Map();
    data['userId'] = userId;
    if (nickName != null) {
      data['nickName'] = nickName;
    }
    if (avatarUrl != null) {
      data['avatarUrl'] = avatarUrl;
    }
    if (mail != null) {
      data['mail'] = mail;
    }
    if (phone != null) {
      data['phone'] = phone;
    }
    data['gender'] = gender;
    if (sign != null) {
      data['sign'] = sign;
    }
    if (birth != null) {
      data['birth'] = birth;
    }
    if (ext != null) {
      data['ext'] = ext;
    }

    return data;
  }

  ///
  /// Gets the userId.
  ///
  ///
  ///
  final String userId;

  ///
  /// Gets the user's nickname.
  ///
  ///
  ///
  final String? nickName;

  ///
  /// Gets the avatar URL of the user.
  ///
  ///
  ///
  final String? avatarUrl;

  ///
  /// Gets the email address of the user.
  ///
  ///
  ///
  final String? mail;

  ///
  /// Gets the mobile numbers of the user.
  ///
  ///
  ///
  final String? phone;

  ///
  /// Gets the user's gender.
  ///
  /// The user's gender:
  /// - `0`: (Default) UnKnow;
  /// - `1`: Male;
  /// - `2`: Female.
  ///
  ///
  ///
  final int gender;

  ///
  /// Gets the user's signature.
  ///
  ///
  ///
  final String? sign;

  ///
  /// Gets the user's data of birth.
  ///
  ///
  ///
  final String? birth;

  ///
  /// Gets the user's extension information.
  ///
  ///
  ///
  final String? ext;

  ///
  /// Gets the time period(seconds) when the user attributes in the cache expire.
  /// If the interval between two callers is less than or equal to the value you set in the parameter,
  /// user attributes are obtained directly from the local cache; otherwise, they are obtained from the server.
  /// For example, if you set this parameter to 120(2 minutes), once this method is called again within 2 minutes,
  /// the SDK returns the attributes obtained last time.
  ///
  ///
  ///
  final int expireTime = DateTime.now().millisecondsSinceEpoch;
}
