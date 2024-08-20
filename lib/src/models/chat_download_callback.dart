import '../internal/inner_headers.dart';

///
/// The group shared download callback.
///
///
///
class ChatDownloadCallback {
  ///
  /// Download success callback.
  ///
  ///
  ///
  final void Function(String fileId, String path)? onSuccess;

  ///
  /// Download error callback.
  ///
  ///
  ///
  final void Function(String fileId, ChatError error)? onError;

  ///
  /// Download progress callback.
  ///
  ///
  ///
  final void Function(String fileId, int progress)? onProgress;

  ///
  /// Create a group shared file download callback.
  ///
  ///
  ///
  ChatDownloadCallback({
    this.onSuccess,
    this.onError,
    this.onProgress,
  });
}
