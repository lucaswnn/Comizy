import 'package:comizy/tads/product.dart';
import 'package:flutter/material.dart';

class ProductCartChangeNotifier extends ChangeNotifier {
  final Map<Product, int> _products = {};
  Map<Product, int> get products => _products;

  void addProduct(Product product) {
    _products.update(product, (val) => val + 1, ifAbsent: () => 1);
    notifyListeners();
  }

  void removeProduct(Product product) {
    if (_products[product] == 1) {
      _products.remove(product);
    } else {
      _products[product] = _products[product]! - 1;
    }
    notifyListeners();
  }

  void clearProduct(Product product) {
    _products.remove(product);
    notifyListeners();
  }

  int getProductQuantity(Product product) => _products[product] ?? 0;
}
