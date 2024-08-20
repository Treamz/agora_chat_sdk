import '../internal/inner_headers.dart';

///
/// The ChatOptions class, which contains the settings of the Chat SDK.
///
/// For example, whether to encrypt the messages before sending and whether to automatically accept the friend invitations.
///
///
///
class ChatOptions {
  ///
  /// The app key that you get from the console when creating the app.
  ///
  ///
  ///
  final String appKey;

  ///
  /// Whether to enable automatic login.
  ///
  /// - `true`: (Default) Yes;
  /// - `false`: No.
  ///
  ///
  ///
  final bool autoLogin;

  ///
  /// Whether to output the debug information. Make sure to call the method after initializing the ChatClient using [ChatClient.init].
  ///
  /// - `true`: Yes.
  /// - `false`: (Default)No.
  ///
  ///
  ///
  final bool debugModel;

  ///
  /// Whether to accept friend invitations from other users automatically.
  ///
  /// - `true`: (Default) Yes;
  /// - `false`: No.
  ///
  ///
  ///
  final bool acceptInvitationAlways;

  ///
  /// Whether to accept group invitations automatically.
  ///
  /// - `true`: (Default) Yes;
  /// - `false`: No.
  ///
  ///
  ///
  final bool autoAcceptGroupInvitation;

  ///
  /// Whether to require read receipt after sending a message.
  ///
  /// - `true`: (Default) Yes;
  /// - `false`: No.
  ///
  ///
  ///
  final bool requireAck;

  ///
  /// Whether to require the delivery receipt after sending a message.
  ///
  /// - `true`: Yes;
  /// - `false`: (Default) No.
  ///
  ///
  ///
  final bool requireDeliveryAck;

  ///
  /// Whether to delete the group messages when leaving a group.
  ///
  /// - `true`: (Default) Yes;
  /// - `false`: No.
  ///
  ///
  ///
  final bool deleteMessagesAsExitGroup;

  ///
  /// Whether to delete the chat room messages when leaving the chat room.
  ///
  /// - `true`: (Default) Yes;
  /// - `false`: No.
  ///
  ///
  ///
  final bool deleteMessagesAsExitChatRoom;

  ///
  /// Whether to allow the chat room owner to leave the chat room.
  ///
  /// - `true`: (Default) Yes;
  /// - `false`: No.
  ///
  ///
  ///
  final bool isChatRoomOwnerLeaveAllowed;

  ///
  /// Whether to sort the messages by the time when the messages are received by the server.
  ///
  /// - `true`: (Default) Yes;
  /// - `false`: No.
  ///
  ///
  ///
  final bool sortMessageByServerTime;

  ///
  /// Whether only HTTPS is used for REST operations.
  ///
  /// - `true`: (Default) Only HTTPS is used.
  /// - `false`: Both HTTP and HTTPS are allowed.
  ///
  ///
  ///
  final bool usingHttpsOnly;

  ///
  /// Whether to upload the message attachments automatically to the chat server.
  ///
  /// - `true`: (Default) Yes;
  /// - `false`: No. Message attachments are uploaded to a custom path.
  ///
  ///
  ///
  final bool serverTransfer;

  ///
  /// Whether to automatically download the thumbnail.
  ///
  /// - `true`: (Default) Yes;
  /// - `false`: No.
  ///
  ///
  ///
  final bool isAutoDownloadThumbnail;

  ///
  /// Whether to enable DNS.
  ///
  /// - `true`: (Default) Yes;
  /// - `false`: No.
  ///
  ///
  ///
  final bool enableDNSConfig;

  ///
  /// The DNS URL.
  ///
  ///
  ///
  final String? dnsUrl;

  ///
  /// The custom REST server.
  ///
  ///
  ///
  final String? restServer;

  ///
  /// The custom IM message server url.
  ///
  ///
  ///
  final String? imServer;

  ///
  /// The custom IM server port.
  ///
  ///
  ///
  final int? imPort;

  ///
  /// The area code.
  /// This attribute is used to restrict the scope of accessible edge nodes. The default value is `AreaCodeGLOB`.
  /// This attribute can be set only when you call [ChatClient.init]. The attribute setting cannot be changed during the app runtime.
  ///
  ///
  ///
  final int chatAreaCode;

  ///
  /// Whether to include empty conversations when the SDK loads conversations from the local database:
  /// - `true`: Yes;
  /// - `false`: (Default) No.
  ///
  ///
  ///
  final bool enableEmptyConversation;

  ///
  ///  Custom device name.
  ///
  ///
  ///
  final String? deviceName;

  ///
  /// Custom system type.
  ///
  ///
  ///
  final int? osType;

  ChatPushConfig _pushConfig = ChatPushConfig();

  ///
  /// Enable OPPO PUSH on OPPO devices.
  ///
  /// Param [appKey] The app ID for OPPO PUSH.
  ///
  /// Param [secret] The app secret for OPPO PUSH.
  ///
  ///
  ///
  void enableOppoPush(String appKey, String secret) {
    _pushConfig.enableOppoPush = true;
    _pushConfig.oppoAppKey = appKey;
    _pushConfig.oppoAppSecret = secret;
  }

  ///
  /// Enable Mi Push on Mi devices.
  ///
  /// Param [appId] The app ID for Mi Push.
  ///
  /// Param [appKey] The app key for Mi Push.
  ///
  ///
  ///
  void enableMiPush(String appId, String appKey) {
    _pushConfig.enableMiPush = true;
    _pushConfig.miAppId = appId;
    _pushConfig.miAppKey = appKey;
  }

  ///
  /// Enable MeiZu Push on MeiZu devices.
  /// Param [appId] The app ID for MeiZu Push.
  /// Param [appKey] The app key for MeiZu Push.
  ///
  ///
  ///
  void enableMeiZuPush(String appId, String appKey) {
    _pushConfig.mzAppId = appId;
    _pushConfig.mzAppKey = appKey;
  }

  ///
  /// Enable Firebase Cloud Messaging (FCM) push on devices that support Google Play.
  ///
  /// Param [appId] The app ID for FCM push.
  ///
  ///
  ///
  void enableFCM(String appId) {
    _pushConfig.enableFCM = true;
    _pushConfig.fcmId = appId;
  }

  ///
  /// Enable vivo Push on vivo devices.
  ///
  ///
  ///
  void enableVivoPush() {
    _pushConfig.enableVivoPush = true;
  }

  ///
  /// Enable Huawei Push on Huawei devices.
  ///
  ///
  ///
  void enableHWPush() {
    _pushConfig.enableHWPush = true;
  }

  ///
  /// Enables Apple Push Notification service (APNs) on iOS devices.
  ///
  /// Param [certName] The APNs certificate name.
  ///
  ///
  ///
  void enableAPNs(String certName) {
    _pushConfig.enableAPNS = true;
    _pushConfig.apnsCertName = certName;
  }

  ///
  /// Sets the app options.
  ///
  /// Param [appKey] The app key that you get from the console when creating an app.
  ///
  /// Param [autoLogin] Whether to enable automatic login.
  ///
  /// Param [debugModel] Whether to output the debug information. Make sure to call the method after the ChatClient is initialized. See [ChatClient.init].
  ///
  /// Param [acceptInvitationAlways] Whether to accept friend invitations from other users automatically.
  ///
  /// Param [autoAcceptGroupInvitation] Whether to accept group invitations automatically.
  ///
  /// Param [requireAck] Whether the read receipt is required.
  ///
  /// Param [requireDeliveryAck] Whether the delivery receipt is required.
  ///
  /// Param [deleteMessagesAsExitGroup] Whether to delete the related group messages when leaving a group.
  ///
  /// Param [deleteMessagesAsExitChatRoom] Whether to delete the related chat room messages when leaving the chat room.
  ///
  /// Param [isChatRoomOwnerLeaveAllowed] Whether to allow the chat room owner to leave the chat room.
  ///
  /// Param [sortMessageByServerTime] Whether to sort the messages by the time the server receives messages.
  ///
  /// Param [usingHttpsOnly] Whether only HTTPS is used for REST operations.
  ///
  /// Param [serverTransfer] Whether to upload the message attachments automatically to the chat server.
  ///
  /// Param [isAutoDownloadThumbnail] Whether to automatically download the thumbnail.
  ///
  /// Param [enableDNSConfig] Whether to enable DNS.
  ///
  /// Param [dnsUrl] The DNS url.
  ///
  /// Param [restServer] The REST server for private deployments.
  ///
  /// Param [imPort] The IM server port for private deployments.
  ///
  /// Param [imServer] The IM server URL for private deployment.
  ///
  /// Param [chatAreaCode] The area code.
  ///
  /// Param [enableEmptyConversation] Whether to include empty conversations when the SDK loads conversations from the local database.
  ///
  ///
  ///
  ///
  ChatOptions({
    required this.appKey,
    this.autoLogin = true,
    this.debugModel = false,
    this.acceptInvitationAlways = false,
    this.autoAcceptGroupInvitation = false,
    this.requireAck = true,
    this.requireDeliveryAck = false,
    this.deleteMessagesAsExitGroup = true,
    this.deleteMessagesAsExitChatRoom = true,
    this.isChatRoomOwnerLeaveAllowed = true,
    this.sortMessageByServerTime = true,
    this.usingHttpsOnly = true,
    this.serverTransfer = true,
    this.isAutoDownloadThumbnail = true,
    this.enableDNSConfig = true,
    this.dnsUrl,
    this.restServer,
    this.imPort,
    this.imServer,
    this.chatAreaCode = ChatAreaCode.GLOB,
    this.enableEmptyConversation = false,
    this.deviceName,
    this.osType,
  });

  /// @nodoc
  Map toJson() {
    Map data = new Map();
    data.putIfNotNull("appKey", appKey);
    data.putIfNotNull("autoLogin", autoLogin);
    data.putIfNotNull("debugModel", debugModel);
    data.putIfNotNull("acceptInvitationAlways", acceptInvitationAlways);
    data.putIfNotNull(
      "autoAcceptGroupInvitation",
      autoAcceptGroupInvitation,
    );
    data.putIfNotNull("deleteMessagesAsExitGroup", deleteMessagesAsExitGroup);
    data.putIfNotNull(
        "deleteMessagesAsExitChatRoom", deleteMessagesAsExitChatRoom);
    data.putIfNotNull("dnsUrl", dnsUrl);
    data.putIfNotNull("enableDNSConfig", enableDNSConfig);
    data.putIfNotNull("imPort", imPort);
    data.putIfNotNull("imServer", imServer);
    data.putIfNotNull("isAutoDownload", isAutoDownloadThumbnail);
    data.putIfNotNull(
        "isChatRoomOwnerLeaveAllowed", isChatRoomOwnerLeaveAllowed);
    data.putIfNotNull("requireAck", requireAck);
    data.putIfNotNull("requireDeliveryAck", requireDeliveryAck);
    data.putIfNotNull("restServer", restServer);
    data.putIfNotNull("serverTransfer", serverTransfer);
    data.putIfNotNull("sortMessageByServerTime", sortMessageByServerTime);
    data.putIfNotNull("usingHttpsOnly", usingHttpsOnly);
    data.putIfNotNull('loadEmptyConversations', enableEmptyConversation);
    data.putIfNotNull('deviceName', deviceName);
    data.putIfNotNull('osType', osType);

    data["usingHttpsOnly"] = this.usingHttpsOnly;
    data["pushConfig"] = this._pushConfig.toJson();
    data["areaCode"] = this.chatAreaCode;

    return data;
  }

  @override
  String toString() {
    return toJson().toString();
  }
}
