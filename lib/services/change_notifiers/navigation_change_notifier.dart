import 'package:comizy/tads/product.dart';
import 'package:comizy/tads/shop.dart';
import 'package:flutter/material.dart';

class NavigationChangeNotifier extends ChangeNotifier{
  Product? _currentProduct;

  Product? get currentProduct => _currentProduct;

  set currentProduct(Product? product){
    _currentProduct = product;
    notifyListeners();
  }

  void clearCurrentProduct(){
    _currentProduct = null;
    notifyListeners();
  }

  
  Shop? _currentShop;

  Shop? get currentShop => _currentShop;

  set currentShop(Shop? shop){
    _currentShop = shop;
    notifyListeners();
  }

  void clearCurrentShop(){
    _currentShop = null;
    notifyListeners();
  }
}