import '../internal/inner_headers.dart';

///
/// The ChatDeviceInfo class, which contains the multi-device information.
///
///
///
class ChatDeviceInfo {
  ChatDeviceInfo._private(
    this.resource,
    this.deviceUUID,
    this.deviceName,
  );

  /// @nodoc
  Map toJson() {
    Map data = Map();
    data.putIfNotNull("resource", resource);
    data.putIfNotNull("deviceUUID", deviceUUID);
    data.putIfNotNull("deviceName", deviceName);

    return data;
  }

  /// @nodoc
  factory ChatDeviceInfo.fromJson(Map map) {
    return ChatDeviceInfo._private(
      map["resource"],
      map["deviceUUID"],
      map["deviceName"],
    );
  }

  ///
  /// The information of other login devices.
  ///
  ///
  ///
  final String? resource;

  ///
  /// The UUID of the device.
  ///
  ///
  ///
  final String? deviceUUID;

  ///
  /// The device type. For example: "Pixel 6 Pro".
  ///
  ///
  ///
  final String? deviceName;
}
