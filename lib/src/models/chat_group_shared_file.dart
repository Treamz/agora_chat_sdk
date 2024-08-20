import '../internal/inner_headers.dart';

///
/// The ChatGroupSharedFile class, which manages the chat group shared files.
///
/// To get the information of the chat group shared file, call [ChatGroupManager.fetchGroupFileListFromServer].
///
/// ```dart
///   List<ChatGroupSharedFile>? list = await ChatClient.getInstance.groupManager.fetchGroupFileListFromServer(groupId);
/// ```
///
///
///
class ChatGroupSharedFile {
  ChatGroupSharedFile._private();

  String? _fileId;
  String? _fileName;
  String? _fileOwner;
  int? _createTime;
  int? _fileSize;

  ///
  /// Gets the shared file ID.
  ///
  /// **Return** The shared file ID.
  ///
  ///
  ///
  String? get fileId => _fileId;

  ///
  /// Gets the shared file name.
  ///
  /// **Return** The shared file name.
  ///
  ///
  ///
  String? get fileName => _fileName;

  ///
  /// Gets the username that uploads the shared file.
  ///
  /// **Return** The username that uploads the shared file.
  ///
  ///
  ///
  String? get fileOwner => _fileOwner;

  ///
  /// Gets the Unix timestamp for uploading the shared file, in milliseconds.
  ///
  /// **Return** The Unix timestamp for uploading the shared file, in milliseconds.
  ///
  ///
  ///
  int? get createTime => _createTime;

  ///
  /// Gets the data length of the shared file, in bytes.
  ///
  /// **Return** The data length of the shared file, in bytes.
  ///
  ///
  ///
  int? get fileSize => _fileSize;

  /// @nodoc
  factory ChatGroupSharedFile.fromJson(Map? map) {
    return ChatGroupSharedFile._private()
      .._fileId = map?["fileId"]
      .._fileName = map?["name"]
      .._fileOwner = map?["owner"]
      .._createTime = map?["createTime"]
      .._fileSize = map?["fileSize"];
  }

  /// @nodoc
  Map toJson() {
    Map data = Map();
    data.putIfNotNull("fileId", _fileId);
    data.putIfNotNull("name", _fileName);
    data.putIfNotNull("owner", _fileOwner);
    data.putIfNotNull("createTime", _createTime);
    data.putIfNotNull("fileSize", _fileSize);
    return data;
  }
}
