class ShowcaseOverflowException implements Exception {
  final String message;

  ShowcaseOverflowException(this.message);

  @override
  String toString() => 'ShowcaseOverflowException: $message';
}