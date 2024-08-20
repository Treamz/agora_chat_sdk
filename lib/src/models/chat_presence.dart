///
/// The presence property class that contains presence properties, including the publisher's user ID and current presence state, and the platform used by the online device, as well as the presence's extension information, update time, and subscription expiration time.
///
///
///
class ChatPresence {
  ///
  /// The user ID of the presence publisher.
  ///
  ///
  ///
  final String publisher;

  ///
  /// The presence description information.
  ///
  ///
  ///
  final String statusDescription;

  ///
  /// The presence update time, which is generated by the server.
  ///
  ///
  ///
  final int lastTime;

  ///
  /// The expiration time of the presence subscription.
  ///
  ///
  ///
  final int expiryTime;

  ///
  /// The details of the current presence state.
  ///
  ///
  ///
  Map<String, int>? statusDetails;

  /// @nodoc
  ChatPresence._private(
    this.publisher,
    this.statusDescription,
    this.statusDetails,
    this.lastTime,
    this.expiryTime,
  );

  /// @nodoc
  factory ChatPresence.fromJson(Map map) {
    String publisher = map["publisher"] ?? "";
    String statusDescription = map["statusDescription"] ?? "";
    int latestTime = map["lastTime"] ?? 0;
    int expiryTime = map["expiryTime"] ?? 0;
    Map<String, int>? statusDetails = map["statusDetails"]?.cast<String, int>();
    return ChatPresence._private(
        publisher, statusDescription, statusDetails, latestTime, expiryTime);
  }
}

///
/// The presence details, including the platform used by the publisher's current online device and the current presence state.
///
///
///
class ChatPresenceStatusDetail {
  ///
  /// The platform used by the current online device of the publisher, which can be "ios", "android", "linux", "win", or "webim".
  ///
  ///
  ///
  final String device;

  ///
  /// The current presence state of the publisher.
  ///
  ///
  ///
  final int status;

  /// @nodoc
  ChatPresenceStatusDetail._private(
    this.device,
    this.status,
  );

  /// @nodoc
  factory ChatPresenceStatusDetail.fromJson(Map map) {
    String device = map["device"];
    int status = map["status"] ?? 0;
    return ChatPresenceStatusDetail._private(device, status);
  }
}
