import 'package:comizy/tads/product.dart';
import 'package:comizy/tads/showcase.dart';
import 'package:flutter/material.dart';
import 'package:comizy/utils/mvp_database.dart';

class ShowcaseChangeNotifier extends ChangeNotifier {
  final Showcase _showcase = mvpShowcase;
  Showcase get showcase => _showcase;

  Future<void> initializeShowcase(List<Product> products) async {
    _showcase.addProducts(products);
    notifyListeners();
  }

  void addProduct(Product product) {
    _showcase.addProduct(product);
    notifyListeners();
  }

  void clearShowcase() {
    _showcase.clearShowcase();
    notifyListeners();
  }
}
