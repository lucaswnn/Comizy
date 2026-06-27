abstract class DatabaseLoadable {
  bool _isLoaded = false;
  bool get isLoaded => _isLoaded;

  Future<void> loadData({required bool forceReload}) async {
    if (_isLoaded && !forceReload) {
      return;
    }

    await handleLoadData();
    _isLoaded = true;
  }

  Future<void> handleLoadData();
}
