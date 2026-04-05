enum RemoveCashStatus {
  success,
  notEnoughCash,
  error,
}

class Wallet {
  int _cash;

  Wallet(int cash) : _cash = cash;

  int get cash => _cash;
  void addCash(int value) => _cash += value;

  RemoveCashStatus removeCash(int value) {
    if (_cash < value) {
      return RemoveCashStatus.notEnoughCash;
    }
    _cash -= value;
    return RemoveCashStatus.success;
  }
}
