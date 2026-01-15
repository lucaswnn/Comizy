import 'package:comizy/tads/product.dart';
import 'package:flutter/material.dart';

class ProductNotifier with ChangeNotifier {
  Product? _currentProduct;
  Product? get currentProduct => _currentProduct;
  
  set currentProduct(Product? product) {
    _currentProduct = product;
    notifyListeners();
  }
}