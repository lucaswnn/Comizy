import 'package:comizy/services/command/async_command.dart';
import 'package:flutter/material.dart';

class AsyncActionNotifier<R> with ChangeNotifier {
  bool _isExecuting = false;
  R? _result;
  Object? _error;

  bool get isExecuting => _isExecuting;
  R? get result => _result;
  Object? get error => _error;

  Future<void> execute(AsyncCommand<R> command) async {
    _isExecuting = true;
    _error = null;
    notifyListeners();

    try {
      _result = await command.execute();
    } catch (e) {
      _error = e;
    } finally {
      _isExecuting = false;
      notifyListeners();
    }
  }

  void reset() {
    _isExecuting = false;
    _result = null;
    _error = null;
    notifyListeners();
  }
}
