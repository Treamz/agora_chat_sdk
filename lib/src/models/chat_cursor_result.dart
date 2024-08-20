typedef CursorResultCallback = Object Function(dynamic obj);

///
/// The ChatCursorResult class, which specifies the cursor from which to query results.
/// When querying using this class, the SDK returns the queried instance and the cursor.
///
///   ```dart
///     String? cursor;
///     ChatCursorResult<ChatGroup> result = await ChatClient.getInstance.groupManager.fetchPublicGroupsFromServer(pageSize: 10, cursor: cursor);
///     List<ChatGroup>? group = result.data;
///     cursor = result.cursor;
///   ```
///
///
///
class ChatCursorResult<T> {
  ChatCursorResult._private(
    this.cursor,
    this.data,
  );

  /// @nodoc
  factory ChatCursorResult.fromJson(Map<String, dynamic> map,
      {dataItemCallback = CursorResultCallback}) {
    List<T> list = [];
    (map['list'] as List)
        .forEach((element) => list.add(dataItemCallback(element)));
    ChatCursorResult<T> result =
        ChatCursorResult<T>._private(map['cursor'], list);

    return result;
  }

  ///
  /// Gets the cursor.
  ///
  ///
  ///
  final String? cursor;

  ///
  /// Gets the data list.
  ///
  ///
  ///
  final List<T> data;
}
