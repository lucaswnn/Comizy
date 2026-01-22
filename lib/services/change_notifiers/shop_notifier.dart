import 'package:comizy/tads/shop.dart';
import 'package:flutter/material.dart';

class ShopNotifier with ChangeNotifier {
  Shop? _currentShop;
  Shop? get currentShop => _currentShop;
  
  set currentShop(Shop? shop) {
    _currentShop = shop;
    notifyListeners();
  }
}