import 'package:flutter/material.dart';

class NavigationHelper {
  const NavigationHelper._();

  static final _key = GlobalKey<NavigatorState>();

  static GlobalKey<NavigatorState> get key => _key;

  static Future<T?> pushNamed<T extends Object?>(
    String routeName, {
    Object? arguments,
  }) {
    return _key.currentState!.pushNamed<T?>(
      routeName,
      arguments: arguments,
    );
  }

  static Future<T?>? pushReplacementNamed<T extends Object?>(
    String routeName, {
    Object? arguments,
  }) {
    return _key.currentState?.pushReplacementNamed(
      routeName,
      arguments: arguments,
    );
  }

  static void pop<T extends Object?>([T? result]) {
    return _key.currentState?.pop(result);
  }

  static void popUntilNamed(String routeName) {
    return _key.currentState?.popUntil(
      (route) => route.settings.name == routeName,
    );
  }

  static Future<T?> pushNamedAndClearStack<T extends Object?>(
    String routeName, {
    Object? arguments,
  }) {
    return _key.currentState!.pushNamedAndRemoveUntil<T>(
      routeName,
      (_) => false,
      arguments: arguments,
    );
  }
}
