import 'package:comizy/tads/product.dart';
import 'package:comizy/tads/showcase.dart';
import 'package:flutter/material.dart';

class ShowcaseChangeNotifier extends ChangeNotifier {
  final Showcase _showcase = Showcase(showcaseLimit: 2);

  Future<void> initializeShowcase(List<Product> products) async {
    _showcase.addProducts(products);
    notifyListeners();
  }

  void addProduct(Product product) {
    _showcase.addProduct(product);
    notifyListeners();
  }
}
