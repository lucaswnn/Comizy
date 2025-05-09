class UserAlreadyCreatedException implements Exception {
  final String message;

  UserAlreadyCreatedException(this.message);

  @override
  String toString() => 'UserAlreadyCreatedException: $message';
}

class UserIsNullException implements Exception{
  final String message;

  UserIsNullException(this.message);

  @override
  String toString() => 'UserIsNullException: $message';
}