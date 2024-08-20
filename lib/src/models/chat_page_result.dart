typedef PageResultCallback = Object Function(dynamic obj);

///
/// The ChatPageResult class, which is returned when calling the methods that fetch data by pagination.
/// The SDK also returns the number of remaining pages and the data count of the next page. If the dada count is less than the count you set, there is no more data on server.
///
/// Param [T] Generics.
///
///
///
class ChatPageResult<T> {
  ChatPageResult._private();

  /// @nodoc
  factory ChatPageResult.fromJson(Map map,
      {dataItemCallback = PageResultCallback}) {
    ChatPageResult<T> result = ChatPageResult<T>._private();
    result.._pageCount = map['count'];
    result.._data = [];

    (map['list'] as List).forEach(
      (element) => result._data.add(
        dataItemCallback(element),
      ),
    );

    return result;
  }

  int? _pageCount;
  List<T> _data = [];

  ///
  /// The page count.
  ///
  ///
  ///
  get pageCount => _pageCount;

  ///
  /// The result data.
  ///
  ///
  ///
  List<T>? get data => _data;
}